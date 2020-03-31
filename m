Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D8B199F4A
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgCaTkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:40:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59434 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729368AbgCaTkf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585683634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U/VGYhnEFcRnnck5kQgK5opKWmK9mE8bqE7Og2ysZDk=;
        b=N9aeXCmUoJ1Bh3umbszM8mHSdlKAJ61nS9nW8A5IorEQYYicQzNaETMvQG2SOdliwR3Ck8
        azlSbP2edT50lPX50lHlwz8Plnxg6IfY1A0X65A1rlsB46oayM83r1bjIy/yvY2jK+IMo/
        HkweENkJ5dpDBzUuD2s210OiU5+Z5Nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-beujuJUjPmCUp7d7ml0qUA-1; Tue, 31 Mar 2020 15:40:32 -0400
X-MC-Unique: beujuJUjPmCUp7d7ml0qUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D3E48014CC;
        Tue, 31 Mar 2020 19:40:31 +0000 (UTC)
Received: from horse.redhat.com (ovpn-118-184.phx2.redhat.com [10.3.118.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4829319C6A;
        Tue, 31 Mar 2020 19:40:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6E7D62202E3; Tue, 31 Mar 2020 15:40:20 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, aarcange@redhat.com,
        dhildenb@redhat.com
Subject: [PATCH 4/4] kvm,x86,async_pf: Search exception tables in case of error
Date:   Tue, 31 Mar 2020 15:40:11 -0400
Message-Id: <20200331194011.24834-5-vgoyal@redhat.com>
In-Reply-To: <20200331194011.24834-1-vgoyal@redhat.com>
References: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If an error happens during page fault and it was kernel code executing
at the time of fault, search exception tables and jump to corresponding
handler, if there is one.

This is useful when virtiofs DAX code is doing memcpy and page fault
returns an error because corresponding page has been truncated on
host. In that case, we want to return that error to guest user space,
instead of retrying infinitely.

This does not take care of nested KVM. Exit into L1 does not have notion
of passing "struct pt_regs" to handler. That needs to be fixed first.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |  5 +++--
 arch/x86/kernel/kvm.c           | 24 ++++++++++++++++++------
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_p=
ara.h
index 2d464e470325..2c9e7c852b40 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -88,7 +88,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsi=
gned long p1,
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
-void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
+void kvm_async_pf_task_wait(u32 token, int interrupt_kernel,
+			    struct pt_regs *regs, unsigned long error_code);
 void kvm_async_pf_task_wake(u32 token, bool is_err, unsigned long addr);
 void kvm_read_and_reset_pf_reason(struct kvm_apf_reason *reason);
 extern void kvm_disable_steal_time(void);
@@ -103,7 +104,7 @@ static inline void kvm_spinlock_init(void)
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */
=20
 #else /* CONFIG_KVM_GUEST */
-#define kvm_async_pf_task_wait(T, I) do {} while(0)
+#define kvm_async_pf_task_wait(T, I, R, E) do {} while(0)
 #define kvm_async_pf_task_wake(T, I, A) do {} while(0)
=20
 static inline bool kvm_para_available(void)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 97753a648133..387ef0aa323b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -98,17 +98,23 @@ static struct kvm_task_sleep_node *_find_apf_task(str=
uct kvm_task_sleep_head *b,
 	return NULL;
 }
=20
-static void handle_async_pf_error(int user_mode, unsigned long fault_add=
r)
+static inline void handle_async_pf_error(int user_mode,
+					 unsigned long fault_addr,
+					 struct pt_regs *regs,
+					 unsigned long error_code)
 {
 	if (user_mode)
 		force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)fault_addr);
+	else
+		fixup_exception(regs, X86_TRAP_PF, error_code, fault_addr);
 }
=20
 /*
  * @interrupt_kernel: Is this called from a routine which interrupts the=
 kernel
  * 		      (other than user space)?
  */
-void kvm_async_pf_task_wait(u32 token, int interrupt_kernel)
+void kvm_async_pf_task_wait(u32 token, int interrupt_kernel,
+			    struct pt_regs *regs, unsigned long error_code)
 {
 	u32 key =3D hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b =3D &async_pf_sleepers[key];
@@ -120,13 +126,17 @@ void kvm_async_pf_task_wait(u32 token, int interrup=
t_kernel)
 	raw_spin_lock(&b->lock);
 	e =3D _find_apf_task(b, token);
 	if (e) {
+		bool is_err =3D e->is_err;
+		unsigned long fault_addr =3D e->fault_addr;
+
 		/* dummy entry exist -> wake up was delivered ahead of PF */
-		if (e->is_err)
-			handle_async_pf_error(!interrupt_kernel, e->fault_addr);
 		hlist_del(&e->link);
 		kfree(e);
 		raw_spin_unlock(&b->lock);
=20
+		if (is_err)
+			handle_async_pf_error(!interrupt_kernel, fault_addr,
+					      regs, error_code);
 		rcu_irq_exit();
 		return;
 	}
@@ -167,7 +177,8 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_=
kernel)
 		finish_swait(&n.wq, &wait);
=20
 	if (n.is_err)
-		handle_async_pf_error(!interrupt_kernel, n.fault_addr);
+		handle_async_pf_error(!interrupt_kernel, n.fault_addr, regs,
+				      error_code);
=20
 	rcu_irq_exit();
 	return;
@@ -273,7 +284,8 @@ do_async_page_fault(struct pt_regs *regs, unsigned lo=
ng error_code, unsigned lon
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		kvm_async_pf_task_wait((u32)address, !user_mode(regs));
+		kvm_async_pf_task_wait((u32)address, !user_mode(regs), regs,
+				       error_code);
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e3337c5f73e0..a9b707fb5861 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4207,7 +4207,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u6=
4 error_code,
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		vcpu->arch.apf.host_apf_reason.reason =3D 0;
 		local_irq_disable();
-		kvm_async_pf_task_wait(fault_address, 0);
+		kvm_async_pf_task_wait(fault_address, 0, NULL, 0);
 		local_irq_enable();
 		break;
 	case KVM_PV_REASON_PAGE_READY:
--=20
2.25.1

