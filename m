Return-Path: <kvm+bounces-38000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96642A33608
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 04:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDB031656DC
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 03:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD17D204C36;
	Thu, 13 Feb 2025 03:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVq+gMZe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C2204696;
	Thu, 13 Feb 2025 03:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739416988; cv=none; b=Xm9XzOfwQZDC3YIcl0TusZTsufOl/BlHgDtZlIrf3QsOtZ5knR1OUr4eoWCNXa+aweEecj16W8tEPJ02WTDVMceShSAEmwpX9TOE7kOnWL15AGEVvYX5DtW+tTfBqsx4xfnupgzzAyuV15NJUAZWMp5Dp3boQ3W12GMXUz4Qs28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739416988; c=relaxed/simple;
	bh=kuUAiyMFdMCoYM/vAznqYtcY80xnW/2OIlD6OFgXp1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6IaTJ4Yx3T0lXuQtQghTkXRNu98p48yxgThMfmYJpIug7U1+jWS/Kh3YZ9GPF+gFdnXNXjx1qbyVVRxkxMWDEBVF/fbW68pyyBXeCxv+NY8LndU0VSnoyxLdSeLvXDw7mk82pXvUc9yvB65/lV6vpAYpXo46eal9VnJFGHOJIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XVq+gMZe; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739416986; x=1770952986;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kuUAiyMFdMCoYM/vAznqYtcY80xnW/2OIlD6OFgXp1w=;
  b=XVq+gMZeNakZ3UHC3s80qG3kDrll3/6GpoX8so9UwAsDzDMj3NMaVmal
   fCZJXmPyrAlQOeAUCU/WUZblx+uqQW8cfP31TEVc8cdgb0O2wozk7qI0R
   ryQ/l4D485kKmrXHB7gWUgFYPU+H8qCsgBplt8u8ldXlN0Lt17UUX08uM
   fX92OS8mAxRC5Gtqw4y97+bKeJTl7qRBWt3YGSgjxRb9PIqvAmf9GRj8r
   CmKGjVV6rKFJCPjeZxoF8yIMEnR7CY3JEI+xvR0naf7wGUiny5sHsLc1M
   TZI91dBOc/6GVgw1S8Lun1y9byMZTEyTSnc+kMgaWLDiwHHMSa+8aIoiE
   Q==;
X-CSE-ConnectionGUID: ELcd7/0iT3e9DE9PVBpbEA==
X-CSE-MsgGUID: L1v1sxg6RmSwcVUTbgdF3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="27697570"
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="27697570"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 19:23:06 -0800
X-CSE-ConnectionGUID: lvgZs1WUTyeXnDZJufRDTw==
X-CSE-MsgGUID: k6pIQ9s5Tvu4TEAC5EXgFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="113535720"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 19:23:02 -0800
Message-ID: <f12e1c06-d38d-4ed0-b471-7f016057f604@linux.intel.com>
Date: Thu, 13 Feb 2025 11:23:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-6-binbin.wu@linux.intel.com>
 <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
 <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com>
 <Z6sReszzi8jL97TP@intel.com> <Z6vvgGFngGjQHwps@google.com>
 <3033f048-6aa8-483a-b2dc-37e8dfb237d5@linux.intel.com>
 <Z6zu8liLTKAKmPwV@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6zu8liLTKAKmPwV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/13/2025 2:56 AM, Sean Christopherson wrote:
> On Wed, Feb 12, 2025, Binbin Wu wrote:
>> On 2/12/2025 8:46 AM, Sean Christopherson wrote:
>>> I am completely comfortable saying that KVM doesn't care about STI/SS shadows
>>> outside of the HALTED case, and so unless I'm missing something, I think it makes
>>> sense for tdx_protected_apic_has_interrupt() to not check RVI outside of the HALTED
>>> case, because it's impossible to know if the interrupt is actually unmasked, and
>>> statistically it's far, far more likely that it _is_ masked.
>> OK. Will update tdx_protected_apic_has_interrupt() in "TDX interrupts" part.
>> And use kvm_vcpu_has_events() to replace the open code in this patch.
> Something to keep an eye on: kvm_vcpu_has_events() returns true if pv_unhalted
> is set, and pv_unhalted is only cleared on transitions KVM_MP_STATE_RUNNABLE.
> If the guest initiates a spurious wakeup, pv_unhalted could be left set in
> perpetuity.

Oh, yes.
KVM_HC_KICK_CPU is allowed in TDX guests.

The change below looks good to me.

One minor issue is when guest initiates a spurious wakeup, pv_unhalted is
left set, then later when the guest want to halt the vcpu, in
__kvm_emulate_halt(), since pv_unhalted is still set and the state will not
transit to KVM_MP_STATE_HALTED.
But I guess it's guests' responsibility to not initiate spurious wakeup,
guests need to bear the fact that HLT could fail due to a previous
spurious wakeup?

>
> I _think_ this would work and is generally desirable?
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8e77e61d4fbd..435ca2782c3c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11114,9 +11114,6 @@ static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>              kvm_apic_init_sipi_allowed(vcpu))
>                  return true;
>   
> -       if (vcpu->arch.pv.pv_unhalted)
> -               return true;
> -
>          if (kvm_is_exception_pending(vcpu))
>                  return true;
>   
> @@ -11157,7 +11154,8 @@ static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>   
>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>   {
> -       return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
> +       return kvm_vcpu_running(vcpu) || vcpu->arch.pv.pv_unhalted ||
> +              kvm_vcpu_has_events(vcpu);
>   }
>   
>   /* Called within kvm->srcu read side.  */
> @@ -11293,7 +11291,7 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>           */
>          ++vcpu->stat.halt_exits;
>          if (lapic_in_kernel(vcpu)) {
> -               if (kvm_vcpu_has_events(vcpu))
> +               if (kvm_vcpu_has_events(vcpu) || vcpu->arch.pv.pv_unhalted)
>                          vcpu->arch.pv.pv_unhalted = false;
>                  else
>                          vcpu->arch.mp_state = state;
>
>


