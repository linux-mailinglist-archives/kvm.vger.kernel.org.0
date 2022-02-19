Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC624BC718
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 10:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbiBSJak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 04:30:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiBSJah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 04:30:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42A1EB3C
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 01:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645263017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Eykr1P2rsfvs48+0JEfbWc+i1A5Hcx0MrMIOUCrzskw=;
        b=A7mQM1hbz5uEUlLVCTRFt1eTYZdAThPAMaw7zU7mapI92glny6aXxUIbZGHfeP0VW6tY6E
        PjrJGVMM8blKmPQRhu1vINFJkbpqUK3dswCLBg9zcNCbKp4lC51GSqDvNdcm4aBatg1feh
        MoAQ2ZXUCwd73SPMz7NsUAVX5SCkmQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-myxr16Q1NVuGBLuVCycMeg-1; Sat, 19 Feb 2022 04:30:13 -0500
X-MC-Unique: myxr16Q1NVuGBLuVCycMeg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 524A21006AA0;
        Sat, 19 Feb 2022 09:30:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF2052A18C;
        Sat, 19 Feb 2022 09:30:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Like Xu <likexu@tencent.com>
Subject: [PATCH] KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run
Date:   Sat, 19 Feb 2022 04:29:56 -0500
Message-Id: <20220219092956.366301-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_vcpu_ioctl_run is already doing srcu_read_lock/unlock in two
places, namely vcpu_run and post_kvm_run_save, and a third is actually
needed around the call to vcpu->arch.complete_userspace_io to avoid
the following splat:

  WARNING: suspicious RCU usage
  arch/x86/kvm/pmu.c:190 suspicious rcu_dereference_check() usage!
  other info that might help us debug this:
  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by CPU 28/KVM/370841:
  #0: ff11004089f280b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x87/0x730 [kvm]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x59/0x73
   reprogram_fixed_counter+0x15d/0x1a0 [kvm]
   kvm_pmu_trigger_event+0x1a3/0x260 [kvm]
   ? free_moved_vector+0x1b4/0x1e0
   complete_fast_pio_in+0x8a/0xd0 [kvm]

This splat is not at all unexpected, since complete_userspace_io
callbacks can execute similar code to vmexits.  For example, SVM
with nrips=false will call into the emulator from
svm_skip_emulated_instruction().

Reported-by: Like Xu <likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82a9dcd8c67f..66efe1a67c1d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9180,6 +9180,7 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
 		likely(!pic_in_kernel(vcpu->kvm));
 }
 
+/* Called within kvm->srcu read side.  */
 static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
@@ -9188,16 +9189,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
 
-	/*
-	 * The call to kvm_ready_for_interrupt_injection() may end up in
-	 * kvm_xen_has_interrupt() which may require the srcu lock to be
-	 * held, to protect against changes in the vcpu_info address.
-	 */
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_run->ready_for_interrupt_injection =
 		pic_in_kernel(vcpu->kvm) ||
 		kvm_vcpu_ready_for_interrupt_injection(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
 	if (is_smm(vcpu))
 		kvm_run->flags |= KVM_RUN_X86_SMM;
@@ -9815,6 +9809,7 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
 /*
+ * Called within kvm->srcu read side.
  * Returns 1 to let vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
  * userspace.
@@ -10193,6 +10188,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+/* Called within kvm->srcu read side.  */
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
 	bool hv_timer;
@@ -10252,12 +10248,12 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 		!vcpu->arch.apf.halted);
 }
 
+/* Called within kvm->srcu read side.  */
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
 	struct kvm *kvm = vcpu->kvm;
 
-	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
@@ -10291,8 +10287,6 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-
 	return r;
 }
 
@@ -10398,6 +10392,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
+	struct kvm *kvm = vcpu->kvm;
 	int r;
 
 	vcpu_load(vcpu);
@@ -10450,6 +10445,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (unlikely(vcpu->arch.complete_userspace_io)) {
 		int (*cui)(struct kvm_vcpu *) = vcpu->arch.complete_userspace_io;
 		vcpu->arch.complete_userspace_io = NULL;
@@ -10475,8 +10471,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (kvm_run->kvm_valid_regs)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
-	kvm_sigset_deactivate(vcpu);
+	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
+	kvm_sigset_deactivate(vcpu);
 	vcpu_put(vcpu);
 	return r;
 }
-- 
2.31.1

