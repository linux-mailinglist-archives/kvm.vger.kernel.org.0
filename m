Return-Path: <kvm+bounces-61155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 096CFC0D152
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 12:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 384E24E7A6B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F152F90CD;
	Mon, 27 Oct 2025 11:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EttLMYnx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E3E2E1C57
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761563572; cv=none; b=XFV1MK0hqXPK1lpDsiPPZH9/K5/5zn7jiIOkmraWDbVSspc/eWxUemgPG42ju/UbFYMDl49etBHbgdhYU0nGT/gQTOc//HbzS5rXTNGDHrAIYtKwDdVpPWyuMDq1cuOtWjjCDlfXneF8JvlypodEmX6QkvAAgehogFdkwE3miwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761563572; c=relaxed/simple;
	bh=T7zC62ErZg1/hbryOP00DYUI5q8qL4AeEstwHLT26mU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcthCkgvhVXf+MqdG4ykbWWFOYFmmSzqb/q7qlbXzi2E+Icz9r0qSU2GbNklcZK8iyaVSCXpCIafdkk5SqNyTzsA5Wx41uYFbr8zuQyZ7F0jT6xKXxjAzwqrMGMYzXwwaVJmjw04MtMVSTvRp9m+Gv8i5cjEH3uaEOAzpZPU1zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EttLMYnx; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761563570; x=1793099570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T7zC62ErZg1/hbryOP00DYUI5q8qL4AeEstwHLT26mU=;
  b=EttLMYnxPQXc2dX/WRhGcV5RgCgwDF1Q+0JuwOTvQmSGz7duQsSxK40T
   TZN/GRJN3xko9mQp5VkArlRM933bp4S+U9puYPRILukpj8EkhI+sLTIx0
   bzfa14qHGhlPWle78TmTbfjD8h7t8itybg3GVCRzJHn+U8ObBHJqaS4Dr
   cxBRw1Yi9mcv3168FDLFpHMA6zGU2o6xjsPCk8SbwFzntER1RQDYmk4rA
   wYBZxXN0xK5I9B6rFV5vKe+V2j0a9iREPkmaxP0Dlbdp+Nb0c0oo/H376
   aWTXEMB/4MuSx2gBN9Ck7HAhA5sWwO5L+LxMm0v4y2TrZb948GLdM32ew
   g==;
X-CSE-ConnectionGUID: H5NlfLouS+a00bn/MlteZw==
X-CSE-MsgGUID: 5JhRBm4+Tz2V+S185iZpmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81063919"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="81063919"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 04:12:49 -0700
X-CSE-ConnectionGUID: d0E73kGmQTSUZLk/GgIozw==
X-CSE-MsgGUID: 11NVjgtuSLiG1Pimo6QKkg==
X-ExtLoop1: 1
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 27 Oct 2025 04:12:46 -0700
Date: Mon, 27 Oct 2025 19:34:56 +0800
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
Subject: Re: [PATCH v3 16/20] i386/cpu: Mark cet-u & cet-s xstates as
 migratable
Message-ID: <aP9Y4B1J1W+3Gv/2@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-17-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024065632.1448606-17-zhao1.liu@intel.com>

On Fri, Oct 24, 2025 at 02:56:28PM +0800, Zhao Liu wrote:
> Date: Fri, 24 Oct 2025 14:56:28 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: [PATCH v3 16/20] i386/cpu: Mark cet-u & cet-s xstates as migratable
> X-Mailer: git-send-email 2.34.1
> 
> Cet-u and cet-s are supervisor xstates. Their states are saved/loaded by
> saving/loading related CET MSRs. And there's a vmsd "vmstate_cet" to
> migrate these MSRs.
> 
> Thus, it's safe to mark them as migratable.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0bb65e8c5321..c08066a338a3 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1522,7 +1522,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
>              XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
>              XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
> -            XSTATE_PKRU_MASK | XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
> +            XSTATE_PKRU_MASK | XSTATE_CET_U_MASK | XSTATE_CET_S_MASK |

CET-U & CET-S should be added to FEAT_XSAVE_XSS_LO.

> +            XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
>              XSTATE_XTILE_DATA_MASK,
>      },
>      [FEAT_XSAVE_XCR0_HI] = {
> -- 
> 2.34.1
> 

