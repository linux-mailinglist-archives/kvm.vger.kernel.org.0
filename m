Return-Path: <kvm+bounces-61156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2955EC0D1D4
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 12:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F0A794F10C0
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDAE2FB63F;
	Mon, 27 Oct 2025 11:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrSxi+DL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12282F7AC3
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 11:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761563674; cv=none; b=QxraLKslSGMLEN6YsDYPtqQn6oJnQSnQZjJv4OwP+06HuCL1qg6qgtjYlEDk8kjFsnm235yrAjPSy4gVKRqDQvkAC6pyySRky0PiwU7IUG2VsJPyBHKMaUEU7DNjY0jVsEBZta4Id+TzDgnFC4zoMSYmTX9SmM4RzfVSDHSNm/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761563674; c=relaxed/simple;
	bh=IhPw5JiuGawWjhUC7p2pfnm8f4c84/O2WHAP6X8TfbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBwvvrhUPGJr3B9BIFJQcboeB2u7ARECOJbBjqqpj/tOGbv5PocP39cyY9NGvLzLFReKIINDXPVMP+GGVgrq8woPBLV049zZHJ4UPfOFlw50toHEyanQ6/2xRvnbKgT/8CFcZ3dzo3l6qI83UlcCxm+pm8JIJV/gNehKy1+HPPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrSxi+DL; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761563673; x=1793099673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IhPw5JiuGawWjhUC7p2pfnm8f4c84/O2WHAP6X8TfbA=;
  b=XrSxi+DLw2SpYCh7myGchkz+kwqD94pMCoPnY3rCDPqcxpIw+ZxlakQP
   MmwBIWA8TgAM0GtrUX84256QKvWYKPg2OkWEcPohVdgmfgEbWOYZQfHT6
   tw12rCByEwnm3qMM3rlYzsIoFg/v0lfsUXuq3KMS0tYrhaLNv4/TPzUaa
   s4bXQ+5KPs3iLKXtUjyhROvY0nscFR8i46aF3245Cv6x4JnWq7fUFOtpq
   PrU0+bFx4Pa53gacw5clk87tVPJ4is/ECzQSnklnI1UrD2V4UGJvK5xAz
   XWQR2ic+1SUAurWwgcW5GOQP50FGH8m4l2zaC7XktJpiXo42wLyD9rah3
   Q==;
X-CSE-ConnectionGUID: G889NtiQT86wWvAtS+zFAA==
X-CSE-MsgGUID: 2sV+bfAHRtyzH5le4uIRCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63341239"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="63341239"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 04:14:32 -0700
X-CSE-ConnectionGUID: yA7wC3JdTzesg5bgq/k1LA==
X-CSE-MsgGUID: FePlTOIpTuagbAk//+Gadg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="189330236"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 27 Oct 2025 04:14:29 -0700
Date: Mon, 27 Oct 2025 19:36:39 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
Message-ID: <aP9ZR4fI99o54Nfw@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-11-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024065632.1448606-11-zhao1.liu@intel.com>

> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1917376dbea9..b01729ad36d2 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1522,7 +1522,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
>              XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
>              XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
> -            XSTATE_PKRU_MASK,
> +            XSTATE_PKRU_MASK | XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |

ARCH LBR belongs to FEAT_XSAVE_XSS_LO.

> +            XSTATE_XTILE_DATA_MASK,
>      },
>      [FEAT_XSAVE_XCR0_HI] = {
>          .type = CPUID_FEATURE_WORD,
> -- 
> 2.34.1
> 

