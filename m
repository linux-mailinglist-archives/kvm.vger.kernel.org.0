Return-Path: <kvm+bounces-58349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE195B8EBCA
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 04:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E28B47A9DA1
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 02:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5DA2ED85F;
	Mon, 22 Sep 2025 02:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/qUN2Ns"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7488323CB;
	Mon, 22 Sep 2025 02:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758507051; cv=none; b=LrmkXpUlsM6cQBNcfI6rA4CQ90CwXp1ksnlNUR/KNgKrBiYeBY8P7uIsuSkOLwaRF3S2gWH7WJIOZBzXY13O/OnvwCym1xfrGC8c3KahifOWiEE3xvY+mU3r7Ap+zsih6EQCVVpy6uReJzA30osCL1WwDWlRX/W0u2ueqIsiBig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758507051; c=relaxed/simple;
	bh=LLVe+PO1Ldp2B4x9g+Im9ZGp/zFu95niGU1bq4mHCMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TB3C6CZ/E6mHOpy+7+yoRMX/T+QwQNGpJfiePmF0YeRLSDQBSVTlAJdKTz00udQuIVCcDekHBcyRHMUarPQUVTjJjMueRIF1ip4jcF2VSI2Nfh2NBiy3Ck6dK227RlFAKANezW9/5GYio4VuajFMhuqOjQJ1PxrRvFxpo7NzTlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/qUN2Ns; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758507049; x=1790043049;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LLVe+PO1Ldp2B4x9g+Im9ZGp/zFu95niGU1bq4mHCMA=;
  b=B/qUN2NskWcgibUhWKMHfnHDG6bbcGRhp/fWJYxaCPqEI6d7k++DChH9
   DJ9jcYpLj82tffH3xOaPWXImnI48ZFRgPLJ534k4kcQtFaSEOj+A7hmka
   tLBBAqZDz9tOBuBjMq3EvxSMiBNpot4Rvpp6BA80vSqu3yVbJCdqAz2ZE
   k//iQ9NqV1UkZWa/eYMCg/PrFWh8Bm258Z1fntmafyqJdRILV9XsxpOPE
   FQMq9o2MjEoqbRiYaIahhdWC4R183vAwwifV5QvHgAWSVvdBLZ64yY8ur
   dp+fxZObr0sBT4/N+0/Mc7YkipUKGWXRDqSoOldeAUWACssXR2QlA1e5x
   g==;
X-CSE-ConnectionGUID: Qbx9AweuQB6P8uqjF9P/9Q==
X-CSE-MsgGUID: j+C5ekGOR3WpQqvxXomo7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71868559"
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="71868559"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:10:49 -0700
X-CSE-ConnectionGUID: +MkKHI1DSFGVUXFEfg3lvg==
X-CSE-MsgGUID: keUq45DGQUuEA/70e2wYDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="177151833"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:10:45 -0700
Message-ID: <4570dfa1-1e8d-40e9-9341-4836205f5501@linux.intel.com>
Date: Mon, 22 Sep 2025 10:10:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/51] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-10-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
[...]
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3e66d8c5000a..ae402463f991 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -136,6 +136,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   
>   static DEFINE_MUTEX(vendor_module_lock);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> +
>   struct kvm_x86_ops kvm_x86_ops __read_mostly;
>   
>   #define KVM_X86_OP(func)					     \
> @@ -3801,6 +3804,67 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>   	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>   }
>   
> +/*
> + * Returns true if the MSR in question is managed via XSTATE, i.e. is context
> + * switched with the rest of guest FPU state.  Note!  S_CET is _not_ context
> + * switched via XSTATE even though it _is_ saved/restored via XSAVES/XRSTORS.
> + * Because S_CET is loaded on VM-Enter and VM-Exit via dedicated VMCS fields,
> + * the value saved/restored via XSTATE is always the host's value.  That detail
> + * is _extremely_ important, as the guest's S_CET must _never_ be resident in
> + * hardware while executing in the host.  Loading guest values for U_CET and
> + * PL[0-3]_SSP while executing in the kernel is safe, as U_CET is specific to
> + * userspace, and PL[0-3]_SSP are only consumed when transitioning to lower
> + * privilegel levels, i.e. are effectively only consumed by userspace as well.

s/privilegel/privilege[...]

