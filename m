Return-Path: <kvm+bounces-17943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 550728CBD86
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 11:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E865FB2120E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24E980611;
	Wed, 22 May 2024 09:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AojFgy5e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1947018EB1;
	Wed, 22 May 2024 09:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716369084; cv=none; b=PkJ6pv4eQjX9/DQd5TD9JaZnYBhjE15/7R2SVxrUhsr6DKXilPme8sGg8n1XyNUvdvTbq0JmZnFF+3RNVAJe9d5+iWmNn4CnNmhr0ncz6u2dmgyma70TF1yYv9hgszZnnejKKf5fZ4WQmFFVKUjrdRVpV2eHaNXNweXpk7+H8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716369084; c=relaxed/simple;
	bh=sg1LefpuCNjr3nhPzfp1BfFCuLl2aj/iaibA3Vqno3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JCLYBKjW8ZE2gmB39CUMbqi7oejpdbs3wLRcqQDWLfET4JbbSjrrv3MmpIS3+xHZERrDwwA688GZG00Se/G6KgLKYdy1RLvPxg/Pgpng195r3xKDyxlcuVjwx0EZOYfGQyZIZGFVKTN9R6I7a7nq2+9N9r5/rVf1FALEcjGEnf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AojFgy5e; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716369082; x=1747905082;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sg1LefpuCNjr3nhPzfp1BfFCuLl2aj/iaibA3Vqno3g=;
  b=AojFgy5esysIntL+d9ORLoKha97gTQhyFVpEF3/ys2kPAPwgQy0yanFE
   n3xohYxDbQ6/9hejuCYoUVvJ4a4oMWERLX7y4G1Cuo64eq/q3rC92mhUa
   O5fZC3/K4O1xzKWi2ptBcGSU/oJNRSZEkKVfLTz+u/cyPzbpmQQR+aCsp
   YNDx//sCm1BeOeQwhdaK3LenFH6aoC9sAhWqIj83DLqQUzOYh4FG0qRlD
   rfhjXZUqb4APJBAu3XgUtto6rzvxxMZ9TYWNKVlgzONOAbgS2dgLDp0gt
   zDMooc8li/32mxmu6D53Ajfr0TY+rQiYQV50bGwJ042/fPinOyUmNCLKp
   A==;
X-CSE-ConnectionGUID: Mn5jLqnrQH6Jvw16h/Rnaw==
X-CSE-MsgGUID: MvdarUHVT16x7gbdvSG9Cg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="16435251"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="16435251"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 02:11:21 -0700
X-CSE-ConnectionGUID: Xkk/sViVTYmI387xPxYtRQ==
X-CSE-MsgGUID: ufVIiCCQSNyTwkefiBiS7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="37609274"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 02:11:19 -0700
Message-ID: <9296de25-0d3f-47eb-a98b-e0dcd388cd6b@linux.intel.com>
Date: Wed, 22 May 2024 17:11:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 33/49] KVM: x86: Advertise TSC_DEADLINE_TIMER in
 KVM_GET_SUPPORTED_CPUID
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-34-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240517173926.965351-34-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/18/2024 1:39 AM, Sean Christopherson wrote:
> Advertise TSC_DEADLINE_TIMER via KVM_GET_SUPPORTED_CPUID when it's
> supported in hardware,

But it's using EMUL_F(TSC_DEADLINE_TIMER) below?

>   as the odds of a VMM emulating the local APIC in
> userspace, not emulating the TSC deadline timer, _and_ reflecting
> KVM_GET_SUPPORTED_CPUID back into KVM_SET_CPUID2 are extremely low.
>
> KVM has _unconditionally_ advertised X2APIC via CPUID since commit
> 0d1de2d901f4 ("KVM: Always report x2apic as supported feature"), and it
> is completely impossible for userspace to emulate X2APIC as KVM doesn't
> support forwarding the MSR accesses to userspace.  I.e. KVM has relied on
> userspace VMMs to not misreport local APIC capabilities for nearly 13
> years.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 9 ++++++---
>   arch/x86/kvm/cpuid.c           | 4 ++--
>   2 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 884846282d06..cb744a646de6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1804,15 +1804,18 @@ emulate them efficiently. The fields in each entry are defined as follows:
>            the values returned by the cpuid instruction for
>            this function/index combination
>   
> -The TSC deadline timer feature (CPUID leaf 1, ecx[24]) is always returned
> -as false, since the feature depends on KVM_CREATE_IRQCHIP for local APIC
> -support.  Instead it is reported via::
> +x2APIC (CPUID leaf 1, ecx[21) and TSC deadline timer (CPUID leaf 1, ecx[24])
> +may be returned as true, but they depend on KVM_CREATE_IRQCHIP for in-kernel
> +emulation of the local APIC.  TSC deadline timer support is also reported via::
>   
>     ioctl(KVM_CHECK_EXTENSION, KVM_CAP_TSC_DEADLINE_TIMER)
>   
>   if that returns true and you use KVM_CREATE_IRQCHIP, or if you emulate the
>   feature in userspace, then you can enable the feature for KVM_SET_CPUID2.
>   
> +Enabling x2APIC in KVM_SET_CPUID2 requires KVM_CREATE_IRQCHIP as KVM doesn't
> +support forwarding x2APIC MSR accesses to userspace, i.e. KVM does not support
> +emulating x2APIC in userspace.
>   
>   4.47 KVM_PPC_GET_PVINFO
>   -----------------------
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 699ce4261e9c..d1f427284ccc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -680,8 +680,8 @@ void kvm_set_cpu_caps(void)
>   		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
>   		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
>   		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
> -		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> -		F(F16C) | F(RDRAND)
> +		EMUL_F(TSC_DEADLINE_TIMER) | F(AES) | F(XSAVE) |
> +		0 /* OSXSAVE */ | F(AVX) | F(F16C) | F(RDRAND)
>   	);
>   
>   	kvm_cpu_cap_init(CPUID_1_EDX,


