Return-Path: <kvm+bounces-34539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C19A00D89
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 19:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC62C3A4C3A
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 18:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8EB1FAC57;
	Fri,  3 Jan 2025 18:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Efx/nA99"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9341FC100;
	Fri,  3 Jan 2025 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735928257; cv=none; b=L/+dT/elCT4oK/aufG4fSmBinuSxunoiY0mVVA9q7l0Op1NByD8TnLGu8NDOlaXklUPE8ExpVg1FeDLInfxK8DzgCvK3hDuRNiANaIRKXxQb7J18IlBpSnSr1y36FcjXzbVA+YMWLeSD9YB8675exhLO5c5NXdakEhqWcL75x4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735928257; c=relaxed/simple;
	bh=xc+9f48JHIlPCA+Ji5JWyFWQBgflX7bEvQPUBDpv/Mw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZut2K6CEi0iMHDNln2Qp5VfYLr2FdOGrgRJxZnRe6joT+q3KJ1JpfDgR6FX+Bu3Om6jK1iAfWB6FPnOd3Z4Eob07EDuU+R2Ixqxiam6p8etuVSfpkOoYxeNIhkt57/2Vmr1RjSFgkd8T67awzADN9rIWzkdq8ngn9f6qol1Qoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Efx/nA99; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735928255; x=1767464255;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xc+9f48JHIlPCA+Ji5JWyFWQBgflX7bEvQPUBDpv/Mw=;
  b=Efx/nA99QbRh0gTpyRExTkKmGwZxIgU2z7anGNe2brcMJNa1SFFu9far
   0YVYL/3Dfbunz+xOn2j3aJvUDStRHu6zBB43CtqILuGZiFTF3HtT4W0Ti
   aYx4VKCvVOJW3sdeboonOvl3rCJtDijJj8NGCF9q7CQaepM8v8IfRwvzp
   JQLJM3ZC2tvlGIshbINwPUjXRhjxkGN8M2E0QajtTS6blWnGOZzrbIZor
   K8CwPwRBOfsmiOsKOJLbM9vPPQqeQxePJDxxdBu6m4rjP4uVx6IgjTYlI
   3nqW0uCbgTyOHG/IvC7MPWYHr7FX172vvJ9spkIlgU7m153UZwsa9bCx5
   A==;
X-CSE-ConnectionGUID: vjeR+1LhQdi2a5g3dDpvOA==
X-CSE-MsgGUID: JuRW6BMkSReoq0gkTzQfUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="46758556"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="46758556"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 10:17:34 -0800
X-CSE-ConnectionGUID: zF+BhoTwQq23ZKuNskbz+g==
X-CSE-MsgGUID: ifxBTPwQQNqS/7KoRIt36Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105898900"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.163])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 10:17:29 -0800
Message-ID: <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com>
Date: Fri, 3 Jan 2025 20:16:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
 <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com>
 <Z2WZ091z8GmGjSbC@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z2WZ091z8GmGjSbC@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/12/24 18:22, Sean Christopherson wrote:
> On Fri, Dec 20, 2024, Adrian Hunter wrote:
>> On 17/12/24 18:09, Sean Christopherson wrote:
>>> On Mon, Nov 25, 2024, Adrian Hunter wrote:
>>> I would rather just use kvm_load_host_xsave_state(), by forcing vcpu->arch.{xcr0,xss}
>>> to XFAM, with a comment explaining that the TDX module sets XCR0 and XSS prior to
>>> returning from VP.ENTER.  I don't see any justificaton for maintaining a special
>>> flow for TDX, it's just more work.
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 7eff717c9d0d..b49dcf32206b 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -636,6 +636,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>>>  	vcpu->arch.cr0_guest_owned_bits = -1ul;
>>>  	vcpu->arch.cr4_guest_owned_bits = -1ul;
>>>  
>>> +	vcpu->arch.cr4 = <maximal value>;
>> Sorry for slow reply.  Seems fine except maybe CR4 usage.
>>
>> TDX Module validates CR4 based on XFAM and scrubs host state
>> based on XFAM.  It seems like we would need to use XFAM to
>> manufacture a CR4 that we then effectively use as a proxy
>> instead of just checking XFAM.
> Yep.
> 
>> Since only some vcpu->arch.cr4 bits will be meaningful, it also
>> still leaves the possibility for confusion.
> IMO, it's less confusing having '0' for CR0 and CR4, while having accurate values
> for other state.  And I'm far more worried about KVM wondering into a bad path
> because CR0 and/or CR4 are completely wrong.  E.g. kvm_mmu.cpu_role would be
> completely wrong at steady state, the CR4-based runtime CPUID updates would do
> the wrong thing, and any helper that wraps kvm_is_cr{0,4}_bit_set() would likely
> do the worst possible thing.
> 
>> Are you sure you want this?
> Yeah, pretty sure.  It would be nice if the TDX Module exposed guest CR0/CR4 to
> KVM, a la the traps SEV-ES+ uses, but I think the next best thing is to assume
> the guest is using all features.
> 
>>> +	vcpu->arch.cr0 = <maximal value, give or take>;
>> AFAICT we don't need to care about CR0
> Probably not, but having e.g. CR4.PAE/LA57=1 with CR0.PG/PE=0 will be quite
> weird.

Below is what I have so far.  It seems to work.  Note:
 - use of MSR_IA32_VMX_CR0_FIXED1 and MSR_IA32_VMX_CR4_FIXED1
 to provide base value for CR0 and CR4
 - tdx_reinforce_guest_state() to make sure host state doesn't
 get broken because the values go wrong
 - __kvm_set_xcr() to handle guest_state_protected case
 - kvm_vcpu_reset() to handle guest_state_protected case

Please let me know your feedback.

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 10aebae5af18..2a5f756b05e2 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -351,8 +351,10 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 
 static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
-	if (is_td_vcpu(vcpu))
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_after_set_cpuid(vcpu);
 		return;
+	}
 
 	vmx_vcpu_after_set_cpuid(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 191ee209caa0..0ae427340494 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -710,6 +710,57 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+/* Set a maximal guest CR0 value */
+static u64 tdx_guest_cr0(struct kvm_vcpu *vcpu, u64 cr4)
+{
+	u64 cr0;
+
+	rdmsrl(MSR_IA32_VMX_CR0_FIXED1, cr0);
+
+	if (cr4 & X86_CR4_CET)
+		cr0 |= X86_CR0_WP;
+
+	cr0 |= X86_CR0_PE | X86_CR0_NE;
+	cr0 &= ~(X86_CR0_NW | X86_CR0_CD);
+
+	return cr0;
+}
+
+/*
+ * Set a maximal guest CR4 value. Clear bits forbidden by XFAM or
+ * TD Attributes.
+ */
+static u64 tdx_guest_cr4(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	u64 cr4;
+
+	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, cr4);
+
+	if (!(kvm_tdx->xfam & XFEATURE_PKRU))
+		cr4 &= ~X86_CR4_PKE;
+
+	if (!(kvm_tdx->xfam & XFEATURE_CET_USER) || !(kvm_tdx->xfam & BIT_ULL(12)))
+		cr4 &= ~X86_CR4_CET;
+
+	/* User Interrupts */
+	if (!(kvm_tdx->xfam & BIT_ULL(14)))
+		cr4 &= ~BIT_ULL(25);
+
+	if (!(kvm_tdx->attributes & TDX_TD_ATTR_LASS))
+		cr4 &= ~BIT_ULL(27);
+
+	if (!(kvm_tdx->attributes & TDX_TD_ATTR_PKS))
+		cr4 &= ~BIT_ULL(24);
+
+	if (!(kvm_tdx->attributes & TDX_TD_ATTR_KL))
+		cr4 &= ~BIT_ULL(19);
+
+	cr4 &= ~X86_CR4_SMXE;
+
+	return cr4;
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -732,8 +783,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
 	vcpu->arch.cr4_guest_owned_bits = -1ul;
 
-	vcpu->arch.cr4 = <maximal value>;
-	vcpu->arch.cr0 = <maximal value, give or take>;
+	vcpu->arch.cr4 = tdx_guest_cr4(vcpu);
+	vcpu->arch.cr0 = tdx_guest_cr0(vcpu, vcpu->arch.cr4);
 
 	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
 	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
@@ -767,6 +818,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	if (cpu_feature_enabled(X86_FEATURE_XSAVES))
+		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
+}
+
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -933,6 +990,24 @@ static void tdx_user_return_msr_update_cache(void)
 						 tdx_uret_msrs[i].defval);
 }
 
+static void tdx_reinforce_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	if (WARN_ON_ONCE(vcpu->arch.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK)))
+		vcpu->arch.xcr0 = kvm_tdx->xfam & TDX_XFAM_XCR0_MASK;
+	if (WARN_ON_ONCE(vcpu->arch.ia32_xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK)))
+		vcpu->arch.ia32_xss = kvm_tdx->xfam & TDX_XFAM_XSS_MASK;
+	if (WARN_ON_ONCE(vcpu->arch.pkru))
+		vcpu->arch.pkru = 0;
+	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_XSAVE) &&
+			 !kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)))
+		vcpu->arch.cr4 |= X86_CR4_OSXSAVE;
+	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_XSAVES) &&
+			 !guest_can_use(vcpu, X86_FEATURE_XSAVES)))
+		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
+}
+
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1028,9 +1103,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		update_debugctlmsr(tdx->host_debugctlmsr);
 
 	tdx_user_return_msr_update_cache();
+
+	tdx_reinforce_guest_state(vcpu);
 	kvm_load_host_xsave_state(vcpu);
 
-	vcpu->arch.regs_avail = TDX_REGS_UNSUPPORTED_SET;
+	vcpu->arch.regs_avail = ~0;
 
 	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
 		return EXIT_FASTPATH_NONE;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 861c0f649b69..2e0e300a1f5e 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -110,6 +110,7 @@ struct tdx_cpuid_value {
 } __packed;
 
 #define TDX_TD_ATTR_DEBUG		BIT_ULL(0)
+#define TDX_TD_ATTR_LASS		BIT_ULL(27)
 #define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
 #define TDX_TD_ATTR_PKS			BIT_ULL(30)
 #define TDX_TD_ATTR_KL			BIT_ULL(31)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 7fb1bbf12b39..7f03a6a24abc 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -126,6 +126,7 @@ void tdx_vm_free(struct kvm *kvm);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
@@ -170,6 +171,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2ea7db896ba..f2b1980f830d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1240,6 +1240,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	u64 old_xcr0 = vcpu->arch.xcr0;
 	u64 valid_bits;
 
+	if (vcpu->arch.guest_state_protected) {
+		kvm_update_cpuid_runtime(vcpu);
+		return 0;
+	}
+
 	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
@@ -12388,7 +12393,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 * into hardware, to be zeroed at vCPU creation.  Use CRs as a sentinel
 	 * to detect improper or missing initialization.
 	 */
-	WARN_ON_ONCE(!init_event &&
+	WARN_ON_ONCE(!init_event && !vcpu->arch.guest_state_protected &&
 		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
 
 	/*
diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
index 075419ef3ac7..2cc9bf40a788 100644
--- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
@@ -1054,7 +1054,7 @@ void verify_td_cpuid_tdcall(void)
 	TDX_TEST_ASSERT_SUCCESS(vcpu);
 
 	/* Get KVM CPUIDs for reference */
-	tmp = get_cpuid_entry(kvm_get_supported_cpuid(), 1, 0);
+	tmp = get_cpuid_entry(vcpu->cpuid, 1, 0);
 	TEST_ASSERT(tmp, "CPUID entry missing\n");
 
 	cpuid_entry = *tmp;


