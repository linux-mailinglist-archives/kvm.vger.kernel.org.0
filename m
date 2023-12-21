Return-Path: <kvm+bounces-4975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D9281AE5B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 06:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A67EE1C232AC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 05:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3362ABE4D;
	Thu, 21 Dec 2023 05:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hI/Hx8t/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78B0B677;
	Thu, 21 Dec 2023 05:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703136424; x=1734672424;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=08FXaP4Fhap6FLPVQHsaCAwDjmKBD3tn8cYhXkjFEuQ=;
  b=hI/Hx8t/qYuT4KSfkE8yCkLNj2pi2/OXw1vKIRC3wrv6kN1JYUPd3dJ1
   Sd05yrLotB+sRGqm7Bzc+1OYKzVuW6Ht8uEGckXShEkwDtBVjwE9WfiWV
   TO5morpEix571527ey9Wg4Q1OBifZ5acHv1Gttto4bSs8347IWKIgPejm
   y0yzgDZYjj3Sh8ujRI5PE8hWJkqetab7hrSJmomTwvnYTkWQE9sJ7ltIK
   KNQGaRXE0YfsgBEK9mYEZM/+b1w3yyPwcRIgiN2fNNF84ccF65UY/w46n
   5Fso5hH5gFDt7wL0Oli8kzGnw7Pw1rbEN3TGS8/0BzSGknQhWeFc9rP5A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="376073075"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="376073075"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 21:27:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="867198838"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="867198838"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 21:27:01 -0800
Message-ID: <09cec4fd-2d79-4925-bb2b-7814032fdda3@intel.com>
Date: Thu, 21 Dec 2023 13:26:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] KVM: x86/hyperv: Calculate APIC bus frequency for
 hyper-v
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: isaku.yamahata@gmail.com
References: <cover.1702974319.git.isaku.yamahata@intel.com>
 <ecd345619fdddfe48f375160c90322754cec9096.1702974319.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ecd345619fdddfe48f375160c90322754cec9096.1702974319.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/2023 4:34 PM, Isaku Yamahata wrote:
> Remove APIC_BUS_FREUQNCY and calculate it based on APIC bus cycles per NS.
> APIC_BUS_FREUQNCY is used only for HV_X64_MSR_APIC_FREQUENCY.  The MSR is
> not frequently read, calculate it every time.
> 
> In order to make APIC bus frequency configurable, we need to make make two

two 'make', please drop one.

> related constants into variables.  APIC_BUS_FREUQNCY and APIC_BUS_CYCLE_NS.
> One can be calculated from the other.
>     APIC_BUS_CYCLES_NS = 1000 * 1000 * 1000 / APIC_BUS_FREQUENCY.
> By removing APIC_BUS_FREQUENCY, we need to track only single variable
> instead of two.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes v3:
> - Newly added according to Maxim Levistsky suggestion.
> ---
>   arch/x86/kvm/hyperv.c | 2 +-
>   arch/x86/kvm/lapic.h  | 1 -
>   2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 238afd7335e4..a40ca2fef58c 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1687,7 +1687,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>   		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
>   		break;
>   	case HV_X64_MSR_APIC_FREQUENCY:
> -		data = APIC_BUS_FREQUENCY;
> +		data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
>   		break;
>   	default:
>   		kvm_pr_unimpl_rdmsr(vcpu, msr);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 0a0ea4b5dd8c..a20cb006b6c8 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -17,7 +17,6 @@
>   #define APIC_DEST_MASK			0x800
>   
>   #define APIC_BUS_CYCLE_NS       1
> -#define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
>   
>   #define APIC_BROADCAST			0xFF
>   #define X2APIC_BROADCAST		0xFFFFFFFFul


