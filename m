Return-Path: <kvm+bounces-29826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 807319B2A81
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 09:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 856F41C21B54
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 08:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BFB1922FC;
	Mon, 28 Oct 2024 08:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZAwnYMK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7AB19049D
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 08:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104808; cv=none; b=E3tevBv4wF75zU427o9CMltmK9KlmzTnacKbd1U+PoKWBxHG2+H1hydrs7/hfPX9mzhmtbYb0a2S41XSG0vLZP7db16gMw/emKhLxR+QnWsCXaqsL6z12CouelWzufksbIfr9KWVB9nNeXhhqn6GwQ7/S0cGxOQ8xIl9vyBqERE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104808; c=relaxed/simple;
	bh=giOUIlMYY9g+1lp8uUNbkptN/mLl6W7Jm/JD1/sGYxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tm+XXyLxdej87f9JQ25xaMHyAZ+2A0NRnOAwqxxmJaQkUag6FzdJp0JP+/otKHnY216yXdJX7sO46dg36Hy/J3PRUDkx/841ZKPDT1qK6/O30SjdMHtvu/WAPNPdSqHjzWCju2CvWqhnCLP1Ze2Pg98d8VsxbbmEN41Nae0KsEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZAwnYMK; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730104805; x=1761640805;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=giOUIlMYY9g+1lp8uUNbkptN/mLl6W7Jm/JD1/sGYxQ=;
  b=WZAwnYMKBI00UASpBu1LAgVBeXEfKWlVGIAcOnFlL5KbQszcBZJARt3k
   Zjzg4JoXghAoknahpIK6GbhhZ9H0Bu+2B585Qr+JIG87zejtf3yj8u9hJ
   rUePUrRCyI+Gnt+ReQxC4OKwUfiwfS9PO9IK1V4nqt5o8A8ECbBsTw173
   fXeQ4cCIqLjsutbjZSQ9+VBS3J2ecq7zlJwhWI9WDgxTqbbbW9EwxrCAd
   DZgLlkdT0cLQT7txG9YomMugIk3PcVPf7ig8tdOx+L8GXKUTNOTnN5giQ
   pno3yQGNrNkHtJmCT1XZ+kbT+iubSj5zAxbygSAWwltIU0muAymwaEtFt
   A==;
X-CSE-ConnectionGUID: NVWGC0qFQCWYfxp/cydpHw==
X-CSE-MsgGUID: wO98m7i5QuOeLRwRGfcRAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29553256"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29553256"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 01:39:57 -0700
X-CSE-ConnectionGUID: ePYqHz3ZTLCh3IhLXteREA==
X-CSE-MsgGUID: wxQqWWDYQZSja73delKz4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="86292516"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa003.jf.intel.com with ESMTP; 28 Oct 2024 01:39:55 -0700
Date: Mon, 28 Oct 2024 16:56:14 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 5/7] target/i386: Expose bits related to SRSO
 vulnerability
Message-ID: <Zx9Rrtks38sqcn44@intel.com>
References: <cover.1729807947.git.babu.moger@amd.com>
 <dadbd70c38f4e165418d193918a3747bd715c5f4.1729807947.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dadbd70c38f4e165418d193918a3747bd715c5f4.1729807947.git.babu.moger@amd.com>

Hi Babu

On Thu, Oct 24, 2024 at 05:18:23PM -0500, Babu Moger wrote:
> Date: Thu, 24 Oct 2024 17:18:23 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH v3 5/7] target/i386: Expose bits related to SRSO
>  vulnerability
> X-Mailer: git-send-email 2.34.1
> 
> Add following bits related Speculative Return Stack Overflow (SRSO).
> Guests can make use of these bits if supported.
> 
> These bits are reported via CPUID Fn8000_0021_EAX.
> ===================================================================
> Bit Feature Description
> ===================================================================
> 27  SBPB                Indicates support for the Selective Branch Predictor Barrier.
> 28  IBPB_BRTYPE         MSR_PRED_CMD[IBPB] flushes all branch type predictions.
> 29  SRSO_NO             Not vulnerable to SRSO.
> 30  SRSO_USER_KERNEL_NO Not vulnerable to SRSO at the user-kernel boundary.
> ===================================================================
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip

I suggest updating the description of SRSO-related mitigations in the
"Important CPU features for AMD x86 hosts" section of docs/system/
cpu-models-x86.rst.inc.

If you could also synchronize the CPU model (you added in this series)
in the "Preferred CPU models for AMD x86 hosts" section, that would be
even better. :-)

> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v3: New patch
> ---
>  target/i386/cpu.c |  2 +-
>  target/i386/cpu.h | 14 +++++++++++---
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 690efd4085..642e71b636 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1221,7 +1221,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, "sbpb",
> -            "ibpb-brtype", NULL, NULL, NULL,
> +            "ibpb-brtype", "srso-no", "srso-user-kernel-no", NULL,
>          },
>          .cpuid = { .eax = 0x80000021, .reg = R_EAX, },
>          .tcg_features = 0,
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index e0dea1ba54..792518b62d 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1015,13 +1015,21 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>  #define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)
>  
>  /* Processor ignores nested data breakpoints */
> -#define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP    (1U << 0)
> +#define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP            (1U << 0)
>  /* LFENCE is always serializing */
>  #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
>  /* Null Selector Clears Base */
> -#define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE    (1U << 6)
> +#define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE            (1U << 6)
>  /* Automatic IBRS */
> -#define CPUID_8000_0021_EAX_AUTO_IBRS   (1U << 8)
> +#define CPUID_8000_0021_EAX_AUTO_IBRS                    (1U << 8)
> +/* Selective Branch Predictor Barrier */
> +#define CPUID_8000_0021_EAX_SBPB                         (1U << 27)
> +/* IBPB includes branch type prediction flushing */
> +#define CPUID_8000_0021_EAX_IBPB_BRTYPE                  (1U << 28)
> +/* Not vulnerable to Speculative Return Stack Overflow */
> +#define CPUID_8000_0021_EAX_SRSO_NO                      (1U << 29)
> +/* Not vulnerable to SRSO at the user-kernel boundary */
> +#define CPUID_8000_0021_EAX_SRSO_USER_KERNEL_NO          (1U << 30)

These feature bits defination could be added in patch 7 because only
patch 7 uses these macros.

BTW, which platform supports CPUID_8000_0021_EAX_SRSO_NO? I found that
even the Turin model added in patch 7 does not support this feature.

Thanks,
Zhao

>  /* Performance Monitoring Version 2 */
>  #define CPUID_8000_0022_EAX_PERFMON_V2  (1U << 0)
> -- 
> 2.34.1
> 
> 

