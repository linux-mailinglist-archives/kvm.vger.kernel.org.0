Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15734B5331
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355084AbiBNOXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:23:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242631AbiBNOXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:23:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26D2AA18D
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644848584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ttq1zIF+SrKEZrF2T0keO74lbLkD3dyG7lRqA0IZLmc=;
        b=Rn1U64NAO0gxeImxhReSpsXmYy7Issw4vy0vLi45bTW6lFKcX2ivLTECkwsW0rAjN4SR4g
        zlnOuZCaZiljVbbPqd3x3Wnm1hjZmQvBLYYyGpfJR30ugfG4c755IQH5XDoeFY9mGF3N2E
        2bu1mTl7/TKCSuIWCI2sRht7ydCSBDQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-16hGOxy9NvyBu3K1zurJFQ-1; Mon, 14 Feb 2022 09:23:01 -0500
X-MC-Unique: 16hGOxy9NvyBu3K1zurJFQ-1
Received: by mail-ej1-f72.google.com with SMTP id la22-20020a170907781600b006a7884de505so5910631ejc.7
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:23:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ttq1zIF+SrKEZrF2T0keO74lbLkD3dyG7lRqA0IZLmc=;
        b=NMGyr3q44ib0veaT3Z/V2fnRYHW0XNQktjnU66CQpgHSgy5Mc1gqzFeXz+Our5+uZn
         ifEdetwUBMKxTVe9DRMyzqXyYSN/yidPJjIeSdE5as2Ry2TYeQfw4yTm/SEx3zjBu3NX
         yJaZKjXYLcNsiWw0k+GWQT0p3Eg7XUDwKNtOI+ozN0B9iBuJFcVxLeyqC9fRMHg9hwUy
         HF+isu5dr5wDq4DG6N3Z9txBZ2Tb9Y4gNVxete0PlhO/NoJheW8lgvR834bMXCfBw6cn
         ZnSAoJT0iySqCdy/32eqE5r3WcMBTSkvAHmrwMtBqWay8CMZ9PLhIpWi5rpK5VOAcIGm
         CHQQ==
X-Gm-Message-State: AOAM533Rw71erENJNT6kv/jgoowteT/BJg8V90AmRqz+hhdbZ55cvrsn
        e7pW1YZ4rl/kc5Uj923f9a+h57EjyXqbdsKi1uhWv33/q5DrVawMjwcM9eCQoqZoAEqyFKysdNJ
        tDjwhHzsh1c6OxUcqr9hez14jN/47FnAs6T2Wd5WhPeamfaiI6TuxPjh7XgqMyhY0
X-Received: by 2002:a17:906:6491:: with SMTP id e17mr9441355ejm.407.1644848580207;
        Mon, 14 Feb 2022 06:23:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHkWCKZf8vjSahg7HTjCALgtHhZmKxZbdVTVuDV5BRta0WBMkii9G1uJOykPzxSxX3AijEzw==
X-Received: by 2002:a17:906:6491:: with SMTP id e17mr9441337ejm.407.1644848579966;
        Mon, 14 Feb 2022 06:22:59 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y19sm3125431edd.11.2022.02.14.06.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 06:22:59 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
In-Reply-To: <87iltm96ql.fsf@redhat.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
 <87ee4d9yp3.fsf@redhat.com>
 <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
 <87bkzh9wkd.fsf@redhat.com> <YgKjDm5OdSOKIdAo@google.com>
 <87wni48b11.fsf@redhat.com> <YgPqV8EZFnENj41D@google.com>
 <87tud87xnr.fsf@redhat.com> <87iltm96ql.fsf@redhat.com>
Date:   Mon, 14 Feb 2022 15:22:58 +0100
Message-ID: <874k51eddp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> In case making HV_TSC_PAGE_UPDATE_REQUIRED a real state (...) is too
> cumbersome ...

Turns out that it's not and/or I was able to convince myself that the
attached modification of your patch is equally good. Lightly tested.
I can test it a bit more and send it out if needed.

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-KVM-x86-hyper-v-Avoid-writing-to-TSC-page-without-an.patch

From 51982d597bcdb497a34ce30b8fb792492d0080dc Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 10 Feb 2022 10:31:36 +0100
Subject: [PATCH RFC] KVM: x86: hyper-v: Avoid writing to TSC page without an
 active vCPU

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

The WARN was introduced by 03c0304a86bc ("KVM: Warn if mark_page_dirty()
is called without an active vCPU") but the change seems to be correct
(unlike Hyper-V TSC page update mechanism). In fact, there's no real need
to write to guest memory to invalidate TSC page, this can be done on
the first vCPU which goes through kvm_guest_time_update().

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/hyperv.c           | 40 +++++++--------------------------
 arch/x86/kvm/hyperv.h           |  2 +-
 arch/x86/kvm/x86.c              |  7 +++---
 4 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e7c545bc7ee..8334148cfc90 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -971,10 +971,10 @@ enum hv_tsc_page_status {
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
index c74e7ebb973d..1f6675f3f084 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1123,11 +1123,13 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
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
 
@@ -1189,45 +1191,19 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
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
index 74b53a16f38a..7c7ad7fe611e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2859,7 +2859,7 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
 
 static void kvm_update_masterclock(struct kvm *kvm)
 {
-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 	kvm_end_pvclock_update(kvm);
@@ -3071,8 +3071,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				       offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	if (!v->vcpu_idx)
-		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
 
@@ -6176,7 +6175,7 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	if (data.flags & ~KVM_CLOCK_VALID_FLAGS)
 		return -EINVAL;
 
-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 
-- 
2.34.1


--=-=-=--

