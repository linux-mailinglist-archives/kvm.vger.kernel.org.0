Return-Path: <kvm+bounces-30431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2179BAAA8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 02:57:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A41F8281A53
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 01:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3761632D7;
	Mon,  4 Nov 2024 01:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdvJNujd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8A81553AA;
	Mon,  4 Nov 2024 01:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730685436; cv=none; b=RoeGTF0DJE+DJEu7+B6+FD2NTvd48bmOpYr9Iaf37uZFBazrZs9tZFKgVV1Ybo/VgiJv1Hqe0RsenMpk9PXe7CMWgj0bUgEppHbwGNye7L7rPwaYK6ZSYHitCMV/luJWzMPLjJqh4pm1jEeAG1N/vAVhFfL/OmhJKHa3rKt17oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730685436; c=relaxed/simple;
	bh=IsH9lN/eL13p8AH2frhhLZPn2DLhF98kG8OwSXg7opc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eNttSnL1AsGA6Ryiv1IpSHGemJFUkl+XHxqyAh9GyNNpQrs0gDfq3t7tzsdhwKhxBvO2NR/bsE6q/zn+oTyrH8jPJS8M3xUpg2Ox6lJ4tC0pWfV2cxOQzz3U1Yg8LcPgcnfWWQt2n/c9/+uaWbIFH6gVaTzfxMtmhddqwVSHelM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdvJNujd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730685435; x=1762221435;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IsH9lN/eL13p8AH2frhhLZPn2DLhF98kG8OwSXg7opc=;
  b=SdvJNujdIPssUKBKQybzxs+ixJA2LR6ghoYIPTbL2SVprj7uFVxGsPNx
   FQAEUw7QjIY2Vsb6xB6WdQNrlcrrnFr0MFL+u0J+1C0SUxWdAh99214Hh
   r2pHXhH4el47hFcQfe0Pzi9g45A9YQj7xxcU+WwYX/dsRYpId1ADfZ1RB
   bbH4EDtGezIyCI1W840KDWyZyvLZes4mR6mgcnlyyZzH2eBiLzEgdxv/K
   7qL8ZDTfd0/qZCJmJbnlKIkZBHF1uPI8MJTpigSY7MAGsJdXA/75VCN5s
   ClR535B8OXRPZvU9hhGKJhgWYFtXkL5e3VwhMsxE0wUDKbW6dL0VjE+dQ
   w==;
X-CSE-ConnectionGUID: eCLkulDbT0WpSVo3615hRQ==
X-CSE-MsgGUID: 6vgBcMjzTaCtLQ8ERUNl9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41743287"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41743287"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 17:57:11 -0800
X-CSE-ConnectionGUID: 7JISNVq4RHuqU1i5laqiNw==
X-CSE-MsgGUID: ehJcuUBEQhi3YaYMZQsTpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="106857606"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 17:57:01 -0800
Message-ID: <c7b8f395-579b-40d9-b3eb-29a347f73ec9@intel.com>
Date: Mon, 4 Nov 2024 09:56:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: VMX: Bury Intel PT virtualization (guest/host
 mode) behind CONFIG_BROKEN
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20241101185031.1799556-1-seanjc@google.com>
 <20241101185031.1799556-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241101185031.1799556-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/2/2024 2:50 AM, Sean Christopherson wrote:
> Hide KVM's pt_mode module param behind CONFIG_BROKEN, i.e. disable support
> for virtualizing Intel PT via guest/host mode unless BROKEN=y.  There are
> myriad bugs in the implementation, some of which are fatal to the guest,
> and others which put the stability and health of the host at risk.
> 
> For guest fatalities, the most glaring issue is that KVM fails to ensure
> tracing is disabled, and *stays* disabled prior to VM-Enter, which is
> necessary as hardware disallows loading (the guest's) RTIT_CTL if tracing
> is enabled (enforced via a VMX consistency check).  Per the SDM:
> 
>    If the logical processor is operating with Intel PT enabled (if
>    IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
>    IA32_RTIT_CTL" VM-entry control must be 0.
> 
> On the host side, KVM doesn't validate the guest CPUID configuration
> provided by userspace, and even worse, uses the guest configuration to
> decide what MSRs to save/load at VM-Enter and VM-Exit.  E.g. configuring
> guest CPUID to enumerate more address ranges than are supported in hardware
> will result in KVM trying to passthrough, save, and load non-existent MSRs,
> which generates a variety of WARNs, ToPA ERRORs in the host, a potential
> deadlock, etc.
> 
> Fixes: f99e3daf94ff ("KVM: x86: Add Intel PT virtualization work mode")
> Cc: stable@vger.kernel.org
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6ed801ffe33f..087504fb1589 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -217,9 +217,11 @@ module_param(ple_window_shrink, uint, 0444);
>   static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
>   module_param(ple_window_max, uint, 0444);
>   
> -/* Default is SYSTEM mode, 1 for host-guest mode */
> +/* Default is SYSTEM mode, 1 for host-guest mode (which is BROKEN) */
>   int __read_mostly pt_mode = PT_MODE_SYSTEM;
> +#ifdef CONFIG_BROKEN
>   module_param(pt_mode, int, S_IRUGO);
> +#endif

I like the patch, but I didn't find any other usercase of CONFIG_BROKEN 
in current Linux.

>   struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
>   


