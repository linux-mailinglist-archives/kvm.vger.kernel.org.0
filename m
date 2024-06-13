Return-Path: <kvm+bounces-19551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0281906468
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 691EB284F1A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ABD1137933;
	Thu, 13 Jun 2024 06:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mLSH/sT7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8AD2119
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 06:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718261459; cv=none; b=b4BM8URHX+TWMMt+jfv83t8JFirxWijQD7UlWKJsqmmM5vsI3dHHsmmFlzgIchfu2xXseii+aFgkvIvv6sn6NjV8RrDa8lRQZXDk/2GGv0oizmEy3uv188V3ZmleUBQNqlxHL+0eMF4sLcaCHH/6ZkYWvlsHsGe6WpN8VU1JG60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718261459; c=relaxed/simple;
	bh=OqkYxmUOfBSzzH178ecuVkjIRH9iD616/PR4kw4x0iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p//8y9SZL/pzJ4kvTa1E1WxcrSUuKe1Phgy5Mju8EmeAg/BlQI+PMcG3jTLrBBRTvqZ8ff5b04o8Y0MiFA7s8xTTX6LQ95dVw1wx38r0LmByd5BpTdpcTQLy0amU/9PUGbQ8y/4BGd7HD6zVaZpxk6vu6LsTARnqNNcVTHOzvvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mLSH/sT7; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718261458; x=1749797458;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=OqkYxmUOfBSzzH178ecuVkjIRH9iD616/PR4kw4x0iI=;
  b=mLSH/sT7zDZt9F5UaSgsh9pqmFzK6Q1JNwc99PA/4w47FQ67M8y4MmxT
   jigIy8F9/oWUHmq1wfbCpVN+45D5DW48boiRSZMTcBe0ynS1ubfZ8k3qZ
   mtnhddyTOxdKWKhbrvn/e1niRO63Yez75aGtnsLa4nvXrKikzdVI2pIKf
   hzVefWwYahp15LzYdPkYBLAiXK0oyi/u8j5JTH7pnb6IdM0xhdur4I36u
   6rmLQ3mhCkC6DVSuharUYTRm19zgkpfLePOJPpjsJgNITiCaci+qJgDVM
   LV0jb120h/YvXHqqmT2Uzahs1QY1rXNEPIoDxPbFCaEGI5FC29uU4Hsi3
   g==;
X-CSE-ConnectionGUID: QKopihNaQXiEMFYfq/omig==
X-CSE-MsgGUID: r55K1AuoQGieJReqQCQaaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="15230006"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="15230006"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:50:58 -0700
X-CSE-ConnectionGUID: u7wbnEIlSLav0AoIrtpXEw==
X-CSE-MsgGUID: GjJuT3mXT66W7daApdG84w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="40106244"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 12 Jun 2024 23:50:56 -0700
Date: Thu, 13 Jun 2024 15:06:25 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/4] i386/cpu: Add PerfMonV2 feature bit
Message-ID: <Zmqace8eCFHPq8ZK@intel.com>
References: <cover.1718218999.git.babu.moger@amd.com>
 <6f83528b78d31eb2543aa09966e1d9bcfd7ec8a2.1718218999.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f83528b78d31eb2543aa09966e1d9bcfd7ec8a2.1718218999.git.babu.moger@amd.com>

On Wed, Jun 12, 2024 at 02:12:18PM -0500, Babu Moger wrote:
> Date: Wed, 12 Jun 2024 14:12:18 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH 2/4] i386/cpu: Add PerfMonV2 feature bit
> X-Mailer: git-send-email 2.34.1
> 
> From: Sandipan Das <sandipan.das@amd.com>
> 
> CPUID leaf 0x80000022, i.e. ExtPerfMonAndDbg, advertises new performance
> monitoring features for AMD processors. Bit 0 of EAX indicates support
> for Performance Monitoring Version 2 (PerfMonV2) features. If found to
> be set during PMU initialization, the EBX bits can be used to determine
> the number of available counters for different PMUs. It also denotes the
> availability of global control and status registers.
> 
> Add the required CPUID feature word and feature bit to allow guests to
> make use of the PerfMonV2 features.
> 
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  target/i386/cpu.c | 26 ++++++++++++++++++++++++++
>  target/i386/cpu.h |  4 ++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 86a90b1405..7f1837cdc9 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1228,6 +1228,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .tcg_features = 0,
>          .unmigratable_flags = 0,
>      },
> +    [FEAT_8000_0022_EAX] = {
> +        .type = CPUID_FEATURE_WORD,
> +        .feat_names = {
> +            "perfmon-v2", NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +        },
> +        .cpuid = { .eax = 0x80000022, .reg = R_EAX, },
> +        .tcg_features = 0,
> +        .unmigratable_flags = 0,
> +    },
>      [FEAT_XSAVE] = {
>          .type = CPUID_FEATURE_WORD,
>          .feat_names = {
> @@ -6998,6 +7014,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              *edx = 0;
>          }
>          break;
> +    case 0x80000022:
> +        *eax = *ebx = *ecx = *edx = 0;
> +        /* AMD Extended Performance Monitoring and Debug */
> +        if (kvm_enabled() && cpu->enable_pmu &&
> +            (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
> +            *eax = CPUID_8000_0022_EAX_PERFMON_V2;
> +            *ebx = kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,
> +                                                R_EBX) & 0xf;

Although only EAX[bit 0] and EBX[bits 0-3] are supported right now, I
think it's better to use ¡°|=¡± rather than just override the
original *eax and *ebx, which will prevent future mistakes or omissions.

Otherwise,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


