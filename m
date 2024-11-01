Return-Path: <kvm+bounces-30274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1F09B894B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 03:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E99A282214
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 02:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FD61386C9;
	Fri,  1 Nov 2024 02:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcTFvFBF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0868D132106;
	Fri,  1 Nov 2024 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730428001; cv=none; b=YS+nLRcXvf098yXgNbGkpDbHiqXHaM4dV3s9yIGM1dAK4DVGCPZ01W53s15oLRlxn834dgQlp+BVh4/7/jqLwtOElQxqeudaLEq+2eZGjrwIIs9GtW3+frOjqmtJa91zKYqR69zr6FLalo/+L/aIMHl3ZP2IP287fSPEClAmkv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730428001; c=relaxed/simple;
	bh=36d/haT9WVEiYz68TrS3g6j6z+zykDcFIsogP8k278g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R4upFv7+LZuvJce5+5XjrIJdz8BY6mqjSdHQyJ2DjYSitakGnVwvU/2GfuV/KL9QRlrT6ZJUEfXKLhu5oGhc+Ka9IC3U8ozl8yp0tAnPV0XwiipeQuQRZvvN6bV73eYEpeUvkwiG2MByuLyaP4Z4bc+6iYsn97qKShqzhA/2mdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcTFvFBF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730427995; x=1761963995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=36d/haT9WVEiYz68TrS3g6j6z+zykDcFIsogP8k278g=;
  b=PcTFvFBFn9B/0N2h6Neoe9PFAepi70XkvXGOjD/SmjLaQkQVuJ8OtmaD
   Qsn346jcLMdz3CHjBY5goVyVoeQyqPkPpfr1Rm45P1G2JTOj17LM92Hy8
   qspoeGePDWeykCUZuN7KffNnbgqBwxawIasI0HMi4geJ1tdjZWEHfdniG
   pDQ6M9LwZIQkEedarV/S9XtjFBZsw06ELlkc3mPAIbMh6s4HpzD0Sn6JB
   MdTozHZvDvASH93zCUhyJWaHtQFJ11JN+SyxOSVj2u2/eN1pVtG5OwYLw
   5tPCFEw74bUi4AS/SlK5NkufAZ6ufU8ufQ/pMV4ufWYBDNGZ24THe/grx
   w==;
X-CSE-ConnectionGUID: ARX7FLXCSAucEHoWDnFPlA==
X-CSE-MsgGUID: RuQUJGNsSheYxexPgzF9Iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="29624852"
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="29624852"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 19:26:34 -0700
X-CSE-ConnectionGUID: dDnDVFxYS+WNs19XhhdKcA==
X-CSE-MsgGUID: D9PTgFuuTrKLvQp2R0Y5SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="106155665"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.224.127]) ([10.124.224.127])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 19:25:45 -0700
Message-ID: <9c55087b-e529-46cd-8678-51975a9acc71@linux.intel.com>
Date: Fri, 1 Nov 2024 10:25:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
 <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZyLWMGcgj76YizSw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 10/31/2024 10:54 PM, Sean Christopherson wrote:
> My other idea was have an out-param to separate the return code intended for KVM
> from the return code intended for the guest.  I generally dislike out-params, but
> trying to juggle a return value that multiplexes guest and host values seems like
> an even worse idea.
>
> Also completely untested...
>
> ---
>   arch/x86/include/asm/kvm_host.h |  8 +++----
>   arch/x86/kvm/x86.c              | 41 +++++++++++++++------------------
>   2 files changed, 23 insertions(+), 26 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6d9f763a7bb9..226df5c56811 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2179,10 +2179,10 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>   	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl);
> +int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			    unsigned long a0, unsigned long a1,
> +			    unsigned long a2, unsigned long a3,
> +			    int op_64_bit, int cpl, unsigned long *ret);
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>   
>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e09daa3b157c..e9ae09f1b45b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9998,13 +9998,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl)
> +int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			    unsigned long a0, unsigned long a1,
> +			    unsigned long a2, unsigned long a3,
> +			    int op_64_bit, int cpl, unsigned long *ret)
>   {
> -	unsigned long ret;
> -
>   	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>   
>   	if (!op_64_bit) {
> @@ -10016,15 +10014,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   	}
>   
>   	if (cpl) {
> -		ret = -KVM_EPERM;
> +		*ret = -KVM_EPERM;
>   		goto out;
>   	}
>   
> -	ret = -KVM_ENOSYS;
> +	*ret = -KVM_ENOSYS;
>   
>   	switch (nr) {
>   	case KVM_HC_VAPIC_POLL_IRQ:
> -		ret = 0;
> +		*ret = 0;
>   		break;
>   	case KVM_HC_KICK_CPU:
>   		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_UNHALT))
> @@ -10032,36 +10030,36 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   
>   		kvm_pv_kick_cpu_op(vcpu->kvm, a1);
>   		kvm_sched_yield(vcpu, a1);
> -		ret = 0;
> +		*ret = 0;
>   		break;
>   #ifdef CONFIG_X86_64
>   	case KVM_HC_CLOCK_PAIRING:
> -		ret = kvm_pv_clock_pairing(vcpu, a0, a1);
> +		*ret = kvm_pv_clock_pairing(vcpu, a0, a1);
>   		break;
>   #endif
>   	case KVM_HC_SEND_IPI:
>   		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SEND_IPI))
>   			break;
>   
> -		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
> +		*ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
>   		break;
>   	case KVM_HC_SCHED_YIELD:
>   		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED_YIELD))
>   			break;
>   
>   		kvm_sched_yield(vcpu, a0);
> -		ret = 0;
> +		*ret = 0;
>   		break;
>   	case KVM_HC_MAP_GPA_RANGE: {
>   		u64 gpa = a0, npages = a1, attrs = a2;
>   
> -		ret = -KVM_ENOSYS;
> +		*ret = -KVM_ENOSYS;
>   		if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
>   			break;
>   
>   		if (!PAGE_ALIGNED(gpa) || !npages ||
>   		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
> -			ret = -KVM_EINVAL;
> +			*ret = -KVM_EINVAL;
>   			break;
>   		}

*ret needs to be set to 0 for this case before returning 0 to caller?

>   
> @@ -10080,13 +10078,13 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   		return 0;
>   	}
>   	default:
> -		ret = -KVM_ENOSYS;
> +		*ret = -KVM_ENOSYS;
>   		break;
>   	}
>   
>   out:
>   	++vcpu->stat.hypercalls;
> -	return ret;
> +	return 1;
>   }
>   EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
>   
> @@ -10094,7 +10092,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long nr, a0, a1, a2, a3, ret;
>   	int op_64_bit;
> -	int cpl;
> +	int cpl, r;
>   
>   	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>   		return kvm_xen_hypercall(vcpu);
> @@ -10110,10 +10108,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   	op_64_bit = is_64_bit_hypercall(vcpu);
>   	cpl = kvm_x86_call(get_cpl)(vcpu);
>   
> -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> -		return 0;
> +	r = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, &ret);
> +	if (r <= r)
A typo here.
I guess it meant to be "if (r <= ret)" ?

So the combinations will be
----------------------------------------------------------------------------
    |  r  |    ret    | r <= ret |
---|-----|-----------|----------|-------------------------------------------
  1 |  0  |     0     |   true   |  return r, which is 0, exit to userspace
---|-----|-----------|----------|-------------------------------------------
  2 |  1  |     0     |   false  |  set vcpu's RAX and return back to guest
---|-----|-----------|----------|-------------------------------------------
  3 |  1  | -KVM_Exxx |   false  |  set vcpu's RAX and return back to guest
---|-----|-----------|----------|-------------------------------------------
  4 |  1  |  Positive |   true   |  return r, which is 1,
    |     |     N     |          |  back to guest without setting vcpu's RAX
----------------------------------------------------------------------------

KVM_HC_SEND_IPI, which calls kvm_pv_send_ipi() can hit case 4, which will
return back to guest without setting RAX. It is different from the current behavior.

r can be 0 only if there is no other error detected during pre-checks.
I think it can just check whether r is 0 or not.
I.e.,

@@ -10094,7 +10092,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
  {
      unsigned long nr, a0, a1, a2, a3, ret;
      int op_64_bit;
-    int cpl;
+    int cpl, r;

      if (kvm_xen_hypercall_enabled(vcpu->kvm))
          return kvm_xen_hypercall(vcpu);
@@ -10110,10 +10108,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
      op_64_bit = is_64_bit_hypercall(vcpu);
      cpl = kvm_x86_call(get_cpl)(vcpu);

-    ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-    if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-        /* MAP_GPA tosses the request to the user space. */
-        return 0;
+    r = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, &ret);
+    if (!r)
+        return 0;

      if (!op_64_bit)
          ret = (u32)ret;


> +		return r;
>   
>   	if (!op_64_bit)
>   		ret = (u32)ret;
>
> base-commit: 675248928970d33f7fc8ca9851a170c98f4f1c4f


