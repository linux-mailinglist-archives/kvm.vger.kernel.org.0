Return-Path: <kvm+bounces-35255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B0BA0AD42
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C68523A6E2E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDA253368;
	Mon, 13 Jan 2025 02:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SXZaKfnT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0B4125D5;
	Mon, 13 Jan 2025 02:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734178; cv=none; b=B8uVW4QNpZARv4NLbDS5ODxx/bbqka8rUfkNAjkC63wQQojH3t02dW+aLph5vMJvOEC/vPKy1uL7vQblHtnxF7hGHKs2uF/NEfQUcZu751HOQYLqGw9rEBC7FUpqZYTnwV936QXj2K98LXLVYMwp12jpbJAy20NPLzzeZSEmPao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734178; c=relaxed/simple;
	bh=vp1TK9ckxcl2xdsdpCR4Hs+hfYadThZX+6WHkwH8NhI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ukQ8gGPnW1pUqggejf0TmEtSk+AUlOx8gOqxy72wQu8ERHOGE99xwoQBtMLO6CvhFTDBm8L9yv34ctwex3q0JVYFaVrMes6ejsBQBGy5PUzDqqT+/M5o5F/nzDVNMsq8bLzIJIRYiCB96ytOPqZCh9pflqbMm6RcKMfw4opVEFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SXZaKfnT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734176; x=1768270176;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=vp1TK9ckxcl2xdsdpCR4Hs+hfYadThZX+6WHkwH8NhI=;
  b=SXZaKfnTMToX3ZW0eJP47EVfKWhKcM07Qeohm78LAbwVqTGMakXSBegd
   4zexoIVfWJjDOndhENfL5le1t+lJ1Kk+TrlAUC7zDRKw71lffTCCZYUPi
   gTmgXnOQ4CjBR9hBR/FL15m1elRxp2k+8k1+z2+Lvj1zcYmr7acxcxRRl
   C70BO9yXjzw074q0ERlwvMavgaY+SeXg9nc0Re7D/lIEAgvCh6IvaroTk
   P941wySdzJIlaVOH/Pk/dQaV3jSI3uruhjsTQ9NNPJG4yQS5H5wRmvQ8C
   zxOwyw7UGJmBUBr4LK2Ly9hjVQfHUvqdgPU+9xW+9vScOC+qaZ3QzxFrK
   w==;
X-CSE-ConnectionGUID: ACRRiwGNSPOcSupQ5uPdvA==
X-CSE-MsgGUID: qXvPpjKPSUKM4aN1JWOfDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="54522339"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="54522339"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:09:36 -0800
X-CSE-ConnectionGUID: nH7d6XE2SWaU5hPjujvllg==
X-CSE-MsgGUID: GilHLt81QJ2lABuJoPRvHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="135141731"
Received: from unknown (HELO [10.238.1.62]) ([10.238.1.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:09:33 -0800
Message-ID: <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
Date: Mon, 13 Jan 2025 10:09:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
 <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
Content-Language: en-US
In-Reply-To: <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/13/2025 10:03 AM, Binbin Wu wrote:
>
> On 12/9/2024 9:07 AM, Binbin Wu wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Inhibit APICv for TDX guest in KVM since TDX doesn't support APICv accesses
>> from host VMM.
>>
>> Follow how SEV inhibits APICv.  I.e, define a new inhibit reason for TDX, set
>> it on TD initialization, and add the flag to kvm_x86_ops.required_apicv_inhibits.
>
Resend due to the format mess.

For TDX guests, APICv is always enabled by TDX module. But in current TDX
basic support patch series, TDX code inhibits APICv for TDX guests from
the view of KVM. Synced with Isaku, the reason was to prevent the APICv
active state from toggling during runtime.

Sean raised the concern in a PUCK session that it is not concept right to
"lie" to KVM that APICv is disabled while it is actually enabled. Instead,
it's better to make APICv enabled and prevent it from being disabled from
the view of KVM.

Following is the analysis about the APICv active state for TDX to kick off
further discussions.

APICv active state
==================
 From the view of KVM, whether APICv state is active or not is decided by:
1. APIC is hw enabled
2. VM and vCPU have no inhibit reasons set.

APIC hw enabled
---------------

After TDX vCPU init, APIC is set to x2APIC mode. However, userspace could
disable APIC via KVM_SET_LAPIC or KVM_SET_{SREGS, SREGS2}.

- KVM_SET_LAPIC
   Currently, KVM allows userspace to request KVM_SET_LAPIC to set the state
   of LAPIC for TDX guests.
   There are two options:
   - Force x2APIC mode and default base address when userspace request
     KVM_SET_LAPIC.
   - Simply reject KVM_SET_LAPIC for TDX guest (apic->guest_apic_protected
     is true), since migration is not supported yet.
   Choose option 2 for simplicity for now.

- KVM_SET_{SREGS, SREGS2}
   KVM rejects userspace to set APIC base when
   vcpu->kvm->arch.has_protected_state and vcpu->arch.guest_state_protected
   are both set.
   Currently for TDX, kvm->arch.has_protected_state is not set, so userspace
   is allowed to modify APIC base.
   There are three options:
   - Reject KVM_SET_{SREGS, SREGS2} when either vcpu->arch.guest_state_protected
     or vcpu->kvm->arch.has_protected_state is set.
   - Check vcpu->arch.guest_state_protected before kvm_apic_set_base() in
     __set_sregs_common().
   - Set has_protected_state for TDX guests.
   Choose option 3, i.e. to set has_protected_state for TDX guests, aligning
   with SEV/SNP.

APICv inhibit reasons
---------------------

APICv could be disabled due to a few inhibit reasons.

- APICV_INHIBIT_REASON_DISABLED
   For TDX, this could be triggered when the module parameter enable_apicv is
   set to false.
   enable_apicv could be checked in tdx_bringup(). Disable TDX support if
   !enable_apicv. So that APICV_INHIBIT_REASON_DISABLED will not be set
   during runtime and apic->apicv_active is initialized to true.

- APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED
   KVM will reject userspace to modify APIC base, i.e., APIC mode will always
   be x2APIC mode, the only reason this could be set is it fails to allocate
   memory for KVM apic map.

- APICV_INHIBIT_REASON_PIT_REINJ
   Based on current code, this is relevant only to AMD's AVIC, so this reason
   will not be set for TDX guests. However, KVM is also not be able to
   intercept EOI for TDX guests. For TDX, if in-kernel PIT is enabled and in
   re-inject mode, the use of PIT in guest may have problem. Fortunately,
   modern OSes don't use PIT.
   Options:
   - Enforce irqchip split for TDX guests, i.e. in-kernel PIT is not supported.
   - Leave it as it is and expect PIT will not be used.

- Reasons will not be set for TDX
   - APICV_INHIBIT_REASON_HYPERV
     TDX doesn't support HyperV guest yet.
   - APICV_INHIBIT_REASON_ABSENT
     In-kernel LAPIC is checked in tdx_vcpu_create().
   - APICV_INHIBIT_REASON_BLOCKIRQ
     TDX doesn't support KVM_SET_GUEST_DEBUG.
   - APICV_INHIBIT_REASON_APIC_ID_MODIFIED
     KVM will reject userspace to modify APIC base, i.e., APIC mode will always
     be x2APIC mode.
   - APICV_INHIBIT_REASON_APIC_BASE_MODIFIED
     KVM will reject userspace to set APIC base.

- Reasons relevant only to AMD's AVIC
   - APICV_INHIBIT_REASON_NESTED,
   - APICV_INHIBIT_REASON_IRQWIN,
   - APICV_INHIBIT_REASON_SEV,
   - APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED.

Summary about APICv inhibit reasons:
APICv could still be disabled runtime in some corner case, e.g,
APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED due to memory allocation failure.
After checking enable_apicv in tdx_bringup(), apic->apicv_active is
initialized as true in kvm_create_lapic().  If APICv is inhibited due to any
reason runtime, the refresh_apicv_exec_ctrl() callback could be used to check
if APICv is disabled for TDX, if APICv is disabled, bug the VM.


Changes of APICv active from false to true
==========================================

Lazy check for pending APIC EOI when In-kernel IOAPIC
-----------------------------------------------------
In-kernel IOAPIC does not receive EOI with AMD SVM AVIC since the processor
accelerates write to APIC EOI register and does not trap if the interrupt
is edge-triggered. So there is a workaround by lazy check for pending APIC
EOI at the time when setting new IOAPIC irq, and update IOAPIC EOI if no
pending APIC EOI.
KVM is also not be able to intercept EOI for TDX guests.
- When APICv is enabled
   The code of lazy check for pending APIC EOI doesn't work for TDX because
   KVM can't get the status of real IRR and ISR, and the values are 0s in
   vIRR and vISR in apic->regs[], kvm_apic_pending_eoi() will always return
   false. So the RTC pending EOI will always be cleared when ioapic_set_irq()
   is called for RTC. Then userspace may miss the coalesced RTC interrupts.
- When When APICv is disabled
   ioapic_lazy_update_eoi() will not be called，then pending EOI status for
   RTC will not be cleared after setting and this will mislead userspace to
   see coalesced RTC interrupts.
Options:
- Force irqchip split for TDX guests to eliminate the use of in-kernel IOAPIC.
- Leave it as it is, but the use of RTC may not be accurate.

kvm_can_post_timer_interrupt()
------------------------------
Whether housekeeping CPU can deliver timer interrupt to target vCPU via
posted interrupt when nohz_full option set.
- When APICv active is false, it always return false.
- When APICv active is true, it also depends on whether mwait or hlt in guest
   is set.
   For TDX guests, hlt will trigger #VE unconditionally and TDX guests request
   HLT via TDVMCALL. Whether mwait is allowed depends on the cpuid configuration
   in TD_PARAMS.
   So current implementation of kvm_mwait_in_guest() and kvm_hlt_in_guest()
   doesn't reflect the real status for TDX guests.
However, Sean mentioned "consulting kvm_can_post_timer_interrupt() in the
expiration path is silly". There could be cleanups for this part.
https://lore.kernel.org/kvm/Z32ZjGH72WPKBMam@google.com/
So, don't do any TDX-specific logic for it.

apic_timer_expired()
--------------------
About kvm_can_post_timer_interrupt() in the expiration path, see the
description above.
For the rest part, when the function is not called from timer function
- If apicv_active, the timer interrupt will be injected via
   kvm_apic_inject_pending_timer_irqs().
- If !apicv_active, the timer interrupt will be handled via
   lapic_timer.pending approach, and finally, the timer interrupt is also be
   injected via kvm_apic_inject_pending_timer_irqs().
Basically, they are functionally equivalent with subtle differences.  E.g.,
if an hrtimer fires while KVM is handling a write to TMICT, KVM will deliver
the interrupt if configured to post timer, but not if APICv is disabled,
because the latter will increment "pending", and "pending" will be cleared
before handling the new TMICT.  Ditto for switch APIC timer modes.
Sean mentioned the entire lapic_timer.pending approach may need to be ditched,
and the timer interrupt could be directly delivered no matter apicv is active
or not. https://lore.kernel.org/kvm/Z32ZjGH72WPKBMam@google.com/
This is not TDX specific, leave it for now.

Options:
- Fix kvm_mwait_in_guest()/kvm_hlt_in_guest() for TDX guests.
- VMX preemption timer can't be used by TDX guests anyway, leave
   kvm_mwait_in_guest()/kvm_hlt_in_guest() as them are, posted timer interrupt
   could be used when userspace requested to disable exit for mwait/hlt.
- VMX preemption timer can't be used by TDX guests anyway, skip checking
   kvm_mwait_in_guest()/kvm_hlt_in_guest().

kvm_arch_dy_has_pending_interrupt()
-----------------------------------
Before enabling off-TD debug, there is no functional change because there
is no PAUSE Exit for TDX guests.
After enabling off-TD debug, the kvm_vcpu_apicv_active(vcpu) should be true
to get the pending interrupt from PID. Set APICv to active for TDX is the
right thing to do.

update_cr8_intercept()
----------------------
Functionally unchanged because the callback update_cr8_intercept() for TDX
is ignored. Set APICv to active for TDX can return earlier to skip unnecessary
code.

kvm_lapic_reset()
kvm_apic_set_state()
--------------------
The callbacks apicv_post_state_restore(), hwapic_irr_update(), and
hwapic_isr_update() will be called for TDX guests when apicv is active,
these callbacks have been ignored by TDX code already, no functional changes.


Issues
======

PIC interrupts
--------------
KVM inject PIC interrupt via event injection path.
Currently, TDX code doesn't handle this, thus PIC interrupts will be lost.
Fortunately, modern OSes don't use PIC.
We could use posted-interrupt in to deliver PIC interrupt if needed.
Or can we assume PIC will not be used by TDX guests?

In-kernel PIT in re-inject mode
-------------------------------
See the description for "APICV_INHIBIT_REASON_PIT_REINJ" above.

Lazy check for pending APIC EOI of In-kernel IOAPIC
---------------------------------------------------
See the description for the same item in "Changes of APICv active from false
to true".

Open:
For the issues related to in-kernel PIT and in-kernel IOAPIC, should KVM
force irqchip split for TDX guests to eliminate the use of in-kernel PIT
and in-kernel IOAPIC?


Proposed code change
====================
Below is the proposed code change to change APICv active from false to true
for TDX guests.

Force irqchip split for TEX guests is not included.

Note, by rejecting KVM_GET_LAPIC/KVM_SET_LAPIC for TDX guests (i.e., when
guest_apic_protected), it returns an error code instead of returning 0.
It requires modifications in QEMU TDX support code to avoid requesting
KVM_GET_LAPIC/KVM_SET_LAPIC.

8<----------------------------------------------------------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0787855ab006..97025a240d54 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1289,15 +1289,6 @@ enum kvm_apicv_inhibit {
       */
      APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,

-    /*********************************************************/
-    /* INHIBITs that are relevant only to the Intel's APICv. */
-    /*********************************************************/
-
-    /*
-     * APICv is disabled because TDX doesn't support it.
-     */
-    APICV_INHIBIT_REASON_TDX,
-
      NR_APICV_INHIBIT_REASONS,
  };

@@ -1316,8 +1307,7 @@ enum kvm_apicv_inhibit {
      __APICV_INHIBIT_REASON(IRQWIN),            \
      __APICV_INHIBIT_REASON(PIT_REINJ),        \
      __APICV_INHIBIT_REASON(SEV),            \
-    __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),    \
-    __APICV_INHIBIT_REASON(TDX)
+    __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)

  struct kvm_arch {
      unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9b79b4bb063f..df9cc4a7f2d8 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -782,8 +782,10 @@ static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)

  static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
  {
-    if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+    if (is_td_vcpu(vcpu)) {
+        KVM_BUG_ON(!kvm_vcpu_apicv_active(vcpu), vcpu->kvm);
          return;
+    }

      vmx_refresh_apicv_exec_ctrl(vcpu);
  }
@@ -908,8 +910,7 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
       BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |            \
       BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |    \
       BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |        \
-     BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |        \
-     BIT(APICV_INHIBIT_REASON_TDX))
+     BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))

  struct kvm_x86_ops vt_x86_ops __initdata = {
      .name = KBUILD_MODNAME,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 67fc391fe798..cc516ab2d990 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -614,6 +614,7 @@ int tdx_vm_init(struct kvm *kvm)
      struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);

      kvm->arch.has_private_mem = true;
+    kvm->arch.has_protected_state = true;

      /*
       * Because guest TD is protected, VMM can't parse the instruction in TD.
@@ -2354,8 +2355,6 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
          goto teardown;
      }

-    kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
-
      return 0;

      /*
@@ -2741,7 +2740,6 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
          return -EIO;
      }

-    vcpu->arch.apic->apicv_active = false;
      vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;

      return 0;
@@ -3273,6 +3271,11 @@ int __init tdx_bringup(void)
          goto success_disable_tdx;
      }

+    if (!enable_apicv) {
+        pr_err("APICv is required for TDX\n");
+        goto success_disable_tdx;
+    }
+
      if (!tdp_mmu_enabled || !enable_mmio_caching) {
          pr_err("TDP MMU and MMIO caching is required for TDX\n");
          goto success_disable_tdx;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e433c8ee63a5..837a287d8c47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5108,6 +5108,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
  static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
                      struct kvm_lapic_state *s)
  {
+    if (vcpu->arch.apic->guest_apic_protected)
+        return -EINVAL;
+
      kvm_x86_call(sync_pir_to_irr)(vcpu);

      return kvm_apic_get_state(vcpu, s);
@@ -5118,6 +5121,9 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
  {
      int r;

+    if (vcpu->arch.apic->guest_apic_protected)
+        return -EINVAL;
+
      r = kvm_apic_set_state(vcpu, s);
      if (r)
          return r;



