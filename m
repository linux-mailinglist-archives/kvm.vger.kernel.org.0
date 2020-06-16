Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423021FC124
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 23:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgFPVtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 17:49:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60925 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgFPVtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 17:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592344152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6PBX3SKVg9nqUd6syjhG1IgYhvtY/KB/e1VnPReQ6w=;
        b=EF6NDaDPC1Zjn0hHKfyl1qGM8Z244e3IfKz7w4hCemY+QF01M7Kx9+mKKcIaKZ58cbPDWB
        /lRV+JX9V/SmmD0vdgsxyHS5dS/RaqcVGMcJQsjeGU+0qcPGIMIjjURbzAp2+kPi5dxO/f
        xqFn43MDirNoa5uWWsKHV2+g3SkHz34=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-k1TY7La4NrqErVOPt9cjEQ-1; Tue, 16 Jun 2020 17:49:11 -0400
X-MC-Unique: k1TY7La4NrqErVOPt9cjEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE5F8E919;
        Tue, 16 Jun 2020 21:49:09 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-132.rdu2.redhat.com [10.10.114.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DB9719D7B;
        Tue, 16 Jun 2020 21:49:03 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id CCDBC225E4C; Tue, 16 Jun 2020 17:49:02 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, vkuznets@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 3/3] kvm, async_pf: Use FOLL_WRITE only for write faults
Date:   Tue, 16 Jun 2020 17:48:47 -0400
Message-Id: <20200616214847.24482-4-vgoyal@redhat.com>
In-Reply-To: <20200616214847.24482-1-vgoyal@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

async_pf_execute() calls get_user_pages_remote() and uses FOLL_WRITE
always. It does not matter whether fault happened due to read/write.

This creates issues if vma is mapped for reading and does not have
VM_WRITE set and check_vma_flags() fails in __get_user_pages() and
get_user_pages_remote() returns -EFAULT.

So far this was not an issue, as we don't care about return code
from get_user_pages_remote(). But soon we want to look at this error
code and if file got truncated and page can't be faulted in, we want
to inject error in guest and let guest take appropriate action (Either
send SIGBUS to guest process or do exception table handling or possibly
die).

Hence, we don't want to get -EFAULT erroneously. Pass FOLL_WRITE only
if it is write fault.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 7 ++++---
 include/linux/kvm_host.h | 4 +++-
 virt/kvm/async_pf.c      | 9 +++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 634182bb07c7..15969c4c8925 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4046,7 +4046,7 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 }
 
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-				   gfn_t gfn)
+				   gfn_t gfn, bool write)
 {
 	struct kvm_arch_async_pf arch;
 
@@ -4056,7 +4056,8 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
-				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
+				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch,
+				  write);
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
@@ -4084,7 +4085,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return true;
-		} else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn))
+		} else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn, write))
 			return true;
 	}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b8558334b184..a7c3999a7374 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -208,12 +208,14 @@ struct kvm_async_pf {
 	bool   wakeup_all;
 	bool notpresent_injected;
 	int error_code;
+	bool write;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-		       unsigned long hva, struct kvm_arch_async_pf *arch);
+		       unsigned long hva, struct kvm_arch_async_pf *arch,
+		       bool write);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 6b30374a4de1..1d2dc267f9b8 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -53,6 +53,7 @@ static void async_pf_execute(struct work_struct *work)
 	int locked = 1;
 	bool first;
 	long ret;
+	unsigned int gup_flags = 0;
 
 	might_sleep();
 
@@ -61,8 +62,10 @@ static void async_pf_execute(struct work_struct *work)
 	 * mm and might be done in another context, so we must
 	 * access remotely.
 	 */
+	if (apf->write)
+		gup_flags = FOLL_WRITE;
 	down_read(&mm->mmap_sem);
-	ret = get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
+	ret = get_user_pages_remote(NULL, mm, addr, 1, gup_flags, NULL, NULL,
 				    &locked);
 	if (locked)
 		up_read(&mm->mmap_sem);
@@ -161,7 +164,8 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 }
 
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-		       unsigned long hva, struct kvm_arch_async_pf *arch)
+		       unsigned long hva, struct kvm_arch_async_pf *arch,
+		       bool write)
 {
 	struct kvm_async_pf *work;
 
@@ -186,6 +190,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	work->addr = hva;
 	work->arch = *arch;
 	work->mm = current->mm;
+	work->write = write;
 	mmget(work->mm);
 	kvm_get_kvm(work->vcpu->kvm);
 
-- 
2.25.4

