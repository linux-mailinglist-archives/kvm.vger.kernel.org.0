Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAAA1E10CB
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404101AbgEYOmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:42:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23511 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404079AbgEYOmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f3A0gdFX+KFXgCRhKQMtbqW7JDhQLi/iXO4FB0FTFtY=;
        b=MzZdV5Tj3vgO5bWhhbyS/zQbuTmyEKHhoVixbp/TvuP417DQaHZNxY9jqz0tIuMDYFQMES
        zZpABnnsX1tr644BZEQRR6z5qBO2fDphLIxCCkbDMju5sD8ZsInMyOOcnfZZ6hzga/PeY3
        t/jbPTsulNX9T2BHdn1VJ/EDYkPTdK8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-2YcZ597PNl2IAPJmLJ1YNg-1; Mon, 25 May 2020 10:42:12 -0400
X-MC-Unique: 2YcZ597PNl2IAPJmLJ1YNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DFD2107ACCD;
        Mon, 25 May 2020 14:42:10 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1443F5D9C5;
        Mon, 25 May 2020 14:42:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/10] KVM: x86: deprecate KVM_ASYNC_PF_SEND_ALWAYS
Date:   Mon, 25 May 2020 16:41:25 +0200
Message-Id: <20200525144125.143875-11-vkuznets@redhat.com>
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Concerns were expressed around APF events delivery when CPU is not
in user mode (KVM_ASYNC_PF_SEND_ALWAYS), e.g.
https://lore.kernel.org/kvm/ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org/

'Page ready' events are already free from '#PF abuse' but 'page not ready'
notifications still go through #PF (to be changed in the future). Make the
probability of running into issues when APF collides with regular #PF lower
by deprecating KVM_ASYNC_PF_SEND_ALWAYS. The feature doesn't seem to be
important enough for any particular workload to notice the difference.

Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h      |  1 -
 arch/x86/include/uapi/asm/kvm_para.h |  2 +-
 arch/x86/kernel/kvm.c                |  3 ---
 arch/x86/kvm/x86.c                   | 13 +++++++++----
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 356c02bfa587..f491214b7667 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -769,7 +769,6 @@ struct kvm_vcpu_arch {
 		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
 		u16 vec;
 		u32 id;
-		bool send_user_only;
 		u32 host_apf_flags;
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 812e9b4c1114..3cae0faac2b8 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -82,7 +82,7 @@ struct kvm_clock_pairing {
 #define KVM_MAX_MMU_OP_BATCH           32
 
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
-#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
+#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1) /* deprecated */
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
 #define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 79730eaef1e1..add123302122 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -324,9 +324,6 @@ static void kvm_guest_cpu_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
 		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
 
-#ifdef CONFIG_PREEMPTION
-		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
-#endif
 		pa |= KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
 
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc1bf6cfc5e0..8222133bf5be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2648,7 +2648,10 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 {
 	gpa_t gpa = data & ~0x3f;
 
-	/* Bits 4:5 are reserved, Should be zero */
+	/*
+	 * Bits 4:5 are reserved and should be zero. Bit 1
+	 * (KVM_ASYNC_PF_SEND_ALWAYS) was deprecated and is being ignored.
+	 */
 	if (data & 0x30)
 		return 1;
 
@@ -2664,7 +2667,6 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 					sizeof(u64)))
 		return 1;
 
-	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
 	kvm_async_pf_wakeup_all(vcpu);
@@ -10433,8 +10435,11 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
 		return false;
 
-	if (!kvm_pv_async_pf_enabled(vcpu) ||
-	    (vcpu->arch.apf.send_user_only && kvm_x86_ops.get_cpl(vcpu) == 0))
+	/*
+	 * 'Page not present' APF events are only delivered when CPU is in
+	 * user mode and APF mechanism is enabled.
+	 */
+	if (!kvm_pv_async_pf_enabled(vcpu) || kvm_x86_ops.get_cpl(vcpu) == 0)
 		return false;
 
 	return true;
-- 
2.25.4

