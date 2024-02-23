Return-Path: <kvm+bounces-9476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 826B5860913
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 03:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 120C9B23423
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324D6BE7D;
	Fri, 23 Feb 2024 02:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J4Srvlmx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9637653A1
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 02:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708657143; cv=none; b=lsU9IGUxMAj4q/+18/OGQYoIb53waNv5Eo4832v6JjcPGieUsWBuVCamb/0AHYJFMbzxNzmhscKt6Ke6mMVLbWYhef4gDUzYns3W6a8DpSSYUcdN3bqyQar/zuVrILkHgFWduMGXDXSt0QJdwBbxpBBJWcVMMaY34KF/J7Zi/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708657143; c=relaxed/simple;
	bh=lYf315eDkP0LzIDpbuMezRD5udJ+FvuHc99oYsTfVnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3NPgMMJJmmSuZId5+thjjOb8ifPNGtlyIVcmMPh3kcZNlbQa2u268pR0l7kV2Kx5wJaB/94vYhconDfWh1tNdxocfiWNiE1RS0vljBOB7sgqk1K2e8LTgVyk1BoUWG5nbHI49SzdmXppuCJCCR3NUxWo2uZRQtSH9ZmRILYxmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J4Srvlmx; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708657141; x=1740193141;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lYf315eDkP0LzIDpbuMezRD5udJ+FvuHc99oYsTfVnI=;
  b=J4SrvlmxF/6/xdhmCqn8BK7jHqNdjEozlEa/fBeXTQOrmfUMgRjw9sTA
   rtudKSmYUwT/CYarPzTkMrGc6CoRvXaL3NR3/Td6EnR0oLL6gHl0lJrbl
   TF0B5uJQbYiKU8VinQuOcron8E1B44CQ4Y4LvK4ICHa0kCjdE50Xgd3uQ
   qifq/F/w7//XNzPqxFERnWSeZwdIMq8NuW59HDbjT8bVpbISTa6XFqBOb
   TF3XRZgidytLfP7eLqVOJAETaTxtMDxsCrDMITzAt23B14LctN4UTZche
   BXk4Mmy8SW3fzNtQ6NnSOmUH5/Hu5oaLA/T7/p2/Chsi7v/Bdwckw2/ml
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="2838515"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="2838515"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:59:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="936985813"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="936985813"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga001.fm.intel.com with ESMTP; 22 Feb 2024 18:58:59 -0800
Date: Fri, 23 Feb 2024 11:12:40 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	xiaoyao.li@intel.com, chao.gao@intel.com, robert.hu@linux.intel.com
Subject: Re: [PATCH v4 1/2] target/i386: add support for LAM in CPUID
 enumeration
Message-ID: <ZdgNKDW+jTcXPvyH@intel.com>
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
 <20240112060042.19925-2-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112060042.19925-2-binbin.wu@linux.intel.com>

On Fri, Jan 12, 2024 at 02:00:41PM +0800, Binbin Wu wrote:
> Date: Fri, 12 Jan 2024 14:00:41 +0800
> From: Binbin Wu <binbin.wu@linux.intel.com>
> Subject: [PATCH v4 1/2] target/i386: add support for LAM in CPUID
>  enumeration
> X-Mailer: git-send-email 2.25.1
> 
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> Linear Address Masking (LAM) is a new Intel CPU feature, which allows
> software to use of the untranslated address bits for metadata.
> 
> The bit definition:
> CPUID.(EAX=7,ECX=1):EAX[26]
> 
> Add CPUID definition for LAM.
> 
> Note LAM feature is not supported for TCG of target-i386, LAM CPIUD bit
> will not be added to TCG_7_1_EAX_FEATURES.
> 
> More info can be found in Intel ISE Chapter "LINEAR ADDRESS MASKING(LAM)"
> https://cdrdv2.intel.com/v1/dl/getContent/671368
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c | 2 +-
>  target/i386/cpu.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2524881ce2..fc862dfeb1 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -967,7 +967,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              "fsrc", NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, "amx-fp16", NULL, "avx-ifma",
> -            NULL, NULL, NULL, NULL,
> +            NULL, NULL, "lam", NULL,
>              NULL, NULL, NULL, NULL,
>          },
>          .cpuid = {
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 7f0786e8b9..18ea755644 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -925,6 +925,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>  #define CPUID_7_1_EAX_AMX_FP16          (1U << 21)
>  /* Support for VPMADD52[H,L]UQ */
>  #define CPUID_7_1_EAX_AVX_IFMA          (1U << 23)
> +/* Linear Address Masking */
> +#define CPUID_7_1_EAX_LAM               (1U << 26)
>  
>  /* Support for VPDPB[SU,UU,SS]D[,S] */
>  #define CPUID_7_1_EDX_AVX_VNNI_INT8     (1U << 4)
> -- 
> 2.25.1
> 
> 

