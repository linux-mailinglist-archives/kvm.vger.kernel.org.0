Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF01547E90E
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 22:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350345AbhLWVZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 16:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350340AbhLWVZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 16:25:00 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02C0C061401
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 13:24:59 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 8so6244919pfo.4
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 13:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rL+RTC6uU2w38Kvf95WrLEaMm666TJG7UeZNTC5pfys=;
        b=Ya2uvFwktV5qZHbI1LK0x5YaKTo+LL4DdZYNp5Z3C3FztRl6K1KOzOkatXzoYjWyJa
         /ZxvlRrQlkxfze8faJW7u5ieSmohv9Izh5ptdbAHDyM3vMe4E2Fs3zaIBuQlRmGI2KMu
         oBXID79fngdBDLkJco8qYXiIS2IPR5g+zPWN975cYE8wt3lWnK13sxxA1w4N4Jc+f5mZ
         zYJ/IkcnVTRK0V8E6k1jcYPU+wT4MeJ3mZLYxWcVfaapbwQSj5LWz5AQqywlwKIV1xaE
         hTgcu1gy0B+vQTsjLPDy/ExJfTjD3Ph/NJbfEoR4I/3SR3XxwCS8cJoQhCXogTv36GJZ
         Z0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rL+RTC6uU2w38Kvf95WrLEaMm666TJG7UeZNTC5pfys=;
        b=PzymqiqG0VJJgWly1bzGE5rDurkpyLqC9x+nV+5E3C1FHu1Sc06N1Z3+pQeQjcHoBl
         US7Pk9dgihDxFRcHtdT/wZzUEVQHW34a0AuBj1BlS6ySRnp1rNju3VRkBj9FnHNWtz+g
         iDwJb5zNBZsbZcQ0WXZS8vX5U4kT/8qfDFY0mFoUOtM8++s2b2ZTTP+uzUzemeRXduw2
         ugkCsAfup/mhA0RA0u+UtmGezWWBlTdnVf0XXQPB2E28A5SIhatLaPpW3TxF3XPI2xUw
         /xh45uW0J05lbyAxe0J5prN2trT7wT10ylO+EREIV7HB8YsFiBSEQBPyiyB6z5UC65BO
         T12Q==
X-Gm-Message-State: AOAM531fAPQeLLoCvFIfeSkutQDnOj1UBnWfooLR2We1XdCoRBunTWno
        FljtnN1QBGyHXm5M/lsz6fzgyA==
X-Google-Smtp-Source: ABdhPJyJ5Qj2YjZQa7EdsUMzYBXh5IQImndIpZU+fHsfhUXjb4pji0wflR1WgiHKJaxKMYhNOqM+/g==
X-Received: by 2002:a65:58ca:: with SMTP id e10mr3629457pgu.116.1640294698968;
        Thu, 23 Dec 2021 13:24:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d13sm6750565pfu.213.2021.12.23.13.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 13:24:58 -0800 (PST)
Date:   Thu, 23 Dec 2021 21:24:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Message-ID: <YcTpJ369cRBN4W93@google.com>
References: <20211210163625.2886-1-dwmw2@infradead.org>
 <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 23, 2021, Paolo Bonzini wrote:
> On 12/22/21 16:18, David Woodhouse wrote:
> > > > n a mapped
> > > > shared info page.
> > > > 
> > > > This can be used for routing MSI of passthrough devices to PIRQ event
> > > > channels in a Xen guest, and we can build on it for delivering IPIs and
> > > > timers directly from the kernel too.
> > > Queued patches 1-5, thanks.
> > > 
> > > Paolo
> > Any word on when these will make it out to kvm.git? Did you find
> > something else I need to fix?
> 
> I got a WARN when testing the queue branch, now I'm bisecting.

Was it perhaps this WARN?

  WARNING: CPU: 5 PID: 2180 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3163 mark_page_dirty_in_slot+0x6b/0x80 [kvm]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 5 PID: 2180 Comm: hyperv_clock Not tainted 5.16.0-rc4+ #81
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:mark_page_dirty_in_slot+0x6b/0x80 [kvm]
   kvm_write_guest+0x117/0x120 [kvm]
   kvm_hv_invalidate_tsc_page+0x99/0xf0 [kvm]
   kvm_arch_vm_ioctl+0x20f/0xb60 [kvm]
   kvm_vm_ioctl+0x711/0xd50 [kvm]
   __x64_sys_ioctl+0x7f/0xb0
   do_syscall_64+0x38/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

If so, it was clearly introduced by commit 03c0304a86bc ("KVM: Warn if mark_page_dirty()
is called without an active vCPU").  But that change is 100% correct as it's trivial
to crash KVM without its protection.  E.g. running hyper_clock with these mods

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2dd78c1db4b6..ae0d0490580a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -371,6 +371,8 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
        vm_create_irqchip(vm);
 #endif

+       vm_enable_dirty_ring(vm, 0x10000);
+
        for (i = 0; i < nr_vcpus; ++i) {
                uint32_t vcpuid = vcpuids ? vcpuids[i] : i;

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index e0b2bb1339b1..1032695e3901 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -212,6 +212,8 @@ int main(void)
        vm = vm_create_default(VCPU_ID, 0, guest_main);
        run = vcpu_state(vm, VCPU_ID);

+       vm_mem_region_set_flags(vm, 0, KVM_MEM_LOG_DIRTY_PAGES);
+
        vcpu_set_hv_cpuid(vm, VCPU_ID);

        tsc_page_gva = vm_vaddr_alloc_page(vm);

Triggers a NULL pointer deref.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 12959a067 P4D 12959a067 PUD 129594067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 5 PID: 1784 Comm: hyperv_clock Not tainted 5.16.0-rc4+ #82
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_dirty_ring_get+0xe/0x30 [kvm]
   mark_page_dirty_in_slot.part.0+0x30/0x60 [kvm]
   kvm_write_guest+0x117/0x130 [kvm]
   kvm_hv_invalidate_tsc_page+0x99/0xf0 [kvm]
   kvm_arch_vm_ioctl+0x20f/0xb60 [kvm]
   kvm_vm_ioctl+0x711/0xd50 [kvm]
   __x64_sys_ioctl+0x7f/0xb0
   do_syscall_64+0x38/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Commit e880c6ea55b9 ("KVM: x86: hyper-v: Prevent using not-yet-updated TSC page
by secondary CPUs") is squarely to blame as it was added after dirty ring, though
in Vitaly's defense, David put it best: "That's a fairly awful bear trap".

Assuming there's nothing special about vcpu0's clock, I belive the below fixes
all issues.  If not, then the correct fix is to have vcpu0 block all other vCPUs
until the update completes.

---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/hyperv.c           | 39 ++++++++-------------------------
 arch/x86/kvm/hyperv.h           |  2 +-
 arch/x86/kvm/x86.c              |  7 +++---
 4 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d97f4adc1cb..f85df83e3083 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -971,10 +971,11 @@ enum hv_tsc_page_status {
 	HV_TSC_PAGE_HOST_CHANGED,
 	/* TSC page was properly set up and is currently active  */
 	HV_TSC_PAGE_SET,
-	/* TSC page is currently being updated and therefore is inactive */
-	HV_TSC_PAGE_UPDATING,
 	/* TSC page was set up with an inaccessible GPA */
 	HV_TSC_PAGE_BROKEN,
+
+	/* TSC page needs to be updated to handle a guest or host change */
+	HV_TSC_PAGE_UPDATE_REQUIRED = BIT(31),
 };

 /* Hyper-V emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6e38a7d22e97..84b063bda4d8 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1122,14 +1122,14 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
 	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);

-	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
-	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET)
-		return;
-
 	mutex_lock(&hv->hv_lock);
+
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		goto out_unlock;

+	if (!(hv->hv_tsc_page_status & HV_TSC_PAGE_UPDATE_REQUIRED))
+		goto out_unlock;
+
 	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
 	/*
 	 * Because the TSC parameters only vary when there is a
@@ -1188,45 +1188,24 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	mutex_unlock(&hv->hv_lock);
 }

-void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
+void kvm_hv_request_tsc_page_update(struct kvm *kvm)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
-	u64 gfn;
-	int idx;
+
+	mutex_lock(&hv->hv_lock);

 	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
 	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
 	    tsc_page_update_unsafe(hv))
-		return;
-
-	mutex_lock(&hv->hv_lock);
-
-	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		goto out_unlock;

-	/* Preserve HV_TSC_PAGE_GUEST_CHANGED/HV_TSC_PAGE_HOST_CHANGED states */
-	if (hv->hv_tsc_page_status == HV_TSC_PAGE_SET)
-		hv->hv_tsc_page_status = HV_TSC_PAGE_UPDATING;
-
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
+	if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE)
+		hv->hv_tsc_page_status |= HV_TSC_PAGE_UPDATE_REQUIRED;

 out_unlock:
 	mutex_unlock(&hv->hv_lock);
 }

-
 static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 {
 	if (!hv_vcpu->enforce_cpuid)
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index ed1c4e546d04..3e79b4a9ed4e 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -133,7 +133,7 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);

 void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			   struct pvclock_vcpu_time_info *hv_clock);
-void kvm_hv_invalidate_tsc_page(struct kvm *kvm);
+void kvm_hv_request_tsc_page_update(struct kvm *kvm);

 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c194a8cbd25f..c1adc9efea28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2848,7 +2848,7 @@ static void kvm_end_pvclock_update(struct kvm *kvm)

 static void kvm_update_masterclock(struct kvm *kvm)
 {
-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 	kvm_end_pvclock_update(kvm);
@@ -3060,8 +3060,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				       offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	if (!v->vcpu_idx)
-		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }

@@ -6039,7 +6038,7 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	if (data.flags & ~KVM_CLOCK_VALID_FLAGS)
 		return -EINVAL;

-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);


base-commit: 9f73307be079749233b47e623a67201975c575bc
--

