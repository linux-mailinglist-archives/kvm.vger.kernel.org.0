Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B114F83FC
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240573AbiDGPuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiDGPuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:50:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F4091C932
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649346480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=stD7Mf+oZU4TLMHPH585+jVy8eCgnF4xtuFUjszATvg=;
        b=DLBJj1/1Z2rVQ1OHlTmjPhBNNo9Q+MVxPVUg5FvFmeAKB7YKcbHwIlSg1C0xBnD5BTi31N
        G5ZLIkNP/kYbTdU0ihYkJhFkiXXrULACPHHnfTVf+9vsp30EQwQnwD22Og5F9VgcEJFhlU
        lLgR5LPxoCPl+S5IvUf0LU/LNhUjNZQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-uRQbl0RNOp2JsuVgvNWJCQ-1; Thu, 07 Apr 2022 11:47:57 -0400
X-MC-Unique: uRQbl0RNOp2JsuVgvNWJCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 492E738009E5;
        Thu,  7 Apr 2022 15:47:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5922840470E1;
        Thu,  7 Apr 2022 15:47:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU
Date:   Thu,  7 Apr 2022 17:47:54 +0200
Message-Id: <20220407154754.939923-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following WARN is triggered from kvm_vm_ioctl_set_clock():
 WARNING: CPU: 10 PID: 579353 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3161 mark_page_dirty_in_slot+0x6c/0x80 [kvm]
 ...
 CPU: 10 PID: 579353 Comm: qemu-system-x86 Tainted: G        W  O      5.16.0.stable #20
 Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
 RIP: 0010:mark_page_dirty_in_slot+0x6c/0x80 [kvm]
 ...
 Call Trace:
  <TASK>
  ? kvm_write_guest+0x114/0x120 [kvm]
  kvm_hv_invalidate_tsc_page+0x9e/0xf0 [kvm]
  kvm_arch_vm_ioctl+0xa26/0xc50 [kvm]
  ? schedule+0x4e/0xc0
  ? __cond_resched+0x1a/0x50
  ? futex_wait+0x166/0x250
  ? __send_signal+0x1f1/0x3d0
  kvm_vm_ioctl+0x747/0xda0 [kvm]
  ...

The WARN was introduced by commit 03c0304a86bc ("KVM: Warn if
mark_page_dirty() is called without an active vCPU") but the change seems
to be correct (unlike Hyper-V TSC page update mechanism). In fact, there's
no real need to actually write to guest memory to invalidate TSC page, this
can be done by the first vCPU which goes through kvm_guest_time_update().

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/hyperv.c           | 40 +++++++--------------------------
 arch/x86/kvm/hyperv.h           |  2 +-
 arch/x86/kvm/x86.c              |  7 +++---
 4 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 676705ad1e23..3460bcd75bf2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -979,10 +979,10 @@ enum hv_tsc_page_status {
 	HV_TSC_PAGE_GUEST_CHANGED,
 	/* TSC page MSR was written by KVM userspace, update pending */
 	HV_TSC_PAGE_HOST_CHANGED,
+	/* TSC page needs to be updated due to internal KVM changes */
+	HV_TSC_PAGE_KVM_CHANGED,
 	/* TSC page was properly set up and is currently active  */
 	HV_TSC_PAGE_SET,
-	/* TSC page is currently being updated and therefore is inactive */
-	HV_TSC_PAGE_UPDATING,
 	/* TSC page was set up with an inaccessible GPA */
 	HV_TSC_PAGE_BROKEN,
 };
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 123b677111c5..e235c1d43f83 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1135,11 +1135,13 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
 	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
 
+	mutex_lock(&hv->hv_lock);
+
 	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
+	    hv->hv_tsc_page_status == HV_TSC_PAGE_SET ||
 	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET)
-		return;
+		goto out_unlock;
 
-	mutex_lock(&hv->hv_lock);
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		goto out_unlock;
 
@@ -1201,45 +1203,19 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	mutex_unlock(&hv->hv_lock);
 }
 
-void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
+void kvm_hv_request_tsc_page_update(struct kvm *kvm)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
-	u64 gfn;
-	int idx;
-
-	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
-	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
-	    tsc_page_update_unsafe(hv))
-		return;
 
 	mutex_lock(&hv->hv_lock);
 
-	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
-		goto out_unlock;
-
-	/* Preserve HV_TSC_PAGE_GUEST_CHANGED/HV_TSC_PAGE_HOST_CHANGED states */
-	if (hv->hv_tsc_page_status == HV_TSC_PAGE_SET)
-		hv->hv_tsc_page_status = HV_TSC_PAGE_UPDATING;
+	if (hv->hv_tsc_page_status == HV_TSC_PAGE_SET &&
+	    !tsc_page_update_unsafe(hv))
+		hv->hv_tsc_page_status = HV_TSC_PAGE_KVM_CHANGED;
 
-	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
-
-	hv->tsc_ref.tsc_sequence = 0;
-
-	/*
-	 * Take the srcu lock as memslots will be accessed to check the gfn
-	 * cache generation against the memslots generation.
-	 */
-	idx = srcu_read_lock(&kvm->srcu);
-	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
-			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
-		hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
-	srcu_read_unlock(&kvm->srcu, idx);
-
-out_unlock:
 	mutex_unlock(&hv->hv_lock);
 }
 
-
 static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 {
 	if (!hv_vcpu->enforce_cpuid)
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index e19c00ee9ab3..da2737f2a956 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -137,7 +137,7 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
 
 void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			   struct pvclock_vcpu_time_info *hv_clock);
-void kvm_hv_invalidate_tsc_page(struct kvm *kvm);
+void kvm_hv_request_tsc_page_update(struct kvm *kvm);
 
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a066cf92692..e9647614dc8c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2904,7 +2904,7 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
 
 static void kvm_update_masterclock(struct kvm *kvm)
 {
-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 	kvm_end_pvclock_update(kvm);
@@ -3108,8 +3108,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 					offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	if (!v->vcpu_idx)
-		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
 
@@ -6238,7 +6237,7 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	if (data.flags & ~KVM_CLOCK_VALID_FLAGS)
 		return -EINVAL;
 
-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 
-- 
2.35.1

