Return-Path: <kvm+bounces-51256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BD0AF0AC9
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 07:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63A6A44692B
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974361F4179;
	Wed,  2 Jul 2025 05:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TiOVgcON"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EAC60B8A
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 05:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751434718; cv=none; b=byf0eObl29nuQq9QsMSSbeJ01FFPPnj/B2Th0DjODTRyWjqpHpZLnwZ1xMnECebmGrRzno24bDCmLU9RXLF3DKMCheUc+4l4jot8DcLnpzRS+FZApPO/wtklBjlQXQBQqVR1mzZTzmBfmpFZ+6uXB7J9jMSo2CvN32c9P6rF8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751434718; c=relaxed/simple;
	bh=9zgnB3BBaGKVhPYkrZq3To/yKcDwTfEjj3iZ5HAcZzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i8uc6xAxEiprHT2YvO8sqamx8Q2ImEFWn0A7jVMLAI75t4w42u/8VBEwKWdJOFIcWhCWtLhMQvMdVJYKOo3Wri31Q0hl2IfMXFlBxsLn2T7hup/si6x9W5scpv8i1FPSa9ns3BRSDKL6ia8Coh+Fk3lb2Pjun5ycMvBxqL2H1eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TiOVgcON; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751434718; x=1782970718;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9zgnB3BBaGKVhPYkrZq3To/yKcDwTfEjj3iZ5HAcZzc=;
  b=TiOVgcONTAA1uECDC/BtizceFAtdgmL04+5o37dDVlV3bmnuI1O9DgnU
   62C3VhrHt7IIlGqkvj8fv8BMvZGPgeUKvCLaedxjPoW/gewEM9UUbrT0G
   h1VnkznFrUXnB+XMhsNAO4WJ4s0dvaMR7+b7eOI7EVobvo7d0jkb6l6nB
   5e9HK/GTpqvCP7ahlTJofSCg/z2ofh1aGGoNCtSiwSSeUM7LrCuqQ+ThI
   J0nTNHLwhAHatKXT6m34HbDGJVZDa5OAfSPLMsrs4BwQnLNB1mmmpYuYc
   XLRDkNKXFMdTpNPP3Mc45c6teK3wo/Qe5Vfc9qqw/cSH9Lek+1gFm1o3Q
   A==;
X-CSE-ConnectionGUID: TcS+U8jXR6eLJQeJktB4lw==
X-CSE-MsgGUID: 3mJbNSRWQFWFDX91y6vFUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="53581970"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="53581970"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:38:26 -0700
X-CSE-ConnectionGUID: tUtOJQrzSdqA1qJsSylh1g==
X-CSE-MsgGUID: nld65XTKROSvjfpOi6Ydew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="158351488"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:38:21 -0700
Message-ID: <0057388f-ccaa-4b39-a9ba-1d3b820d12da@linux.intel.com>
Date: Wed, 2 Jul 2025 13:38:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/9] target/i386/kvm: reset AMD PMU registers during VM
 reset
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com,
 ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
 <20250624074421.40429-8-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250624074421.40429-8-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/24/2025 3:43 PM, Dongli Zhang wrote:
> + uint32_t sel_base = MSR_K7_EVNTSEL0;
> + uint32_t ctr_base = MSR_K7_PERFCTR0;
> + /*
> + * The address of the next selector or counter register is
> + * obtained by incrementing the address of the current selector
> + * or counter register by one.
> + */
> + uint32_t step = 1;
> +
> + /*
> + * When PERFCORE is enabled, AMD PMU uses a separate set of
> + * addresses for the selector and counter registers.
> + * Additionally, the address of the next selector or counter
> + * register is determined by incrementing the address of the
> + * current register by two.
> + */
> + if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> + sel_base = MSR_F15H_PERF_CTL0;
> + ctr_base = MSR_F15H_PERF_CTR0;
> + step = 2;
> + }

This part of code is duplicate with previous code in kvm_put_msrs(), we'd
better add a new helper to get PMU counter MSRs base and index for all
vendors. (This can be done as an independent patch if no new version for
this patchset).

All others look good to me.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



