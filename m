Return-Path: <kvm+bounces-6185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9310C82D39E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 05:25:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC760281470
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 04:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948D920E3;
	Mon, 15 Jan 2024 04:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hb/ZeiT5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BE71FAA
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 04:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705292728; x=1736828728;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jQBlAV4p5/ywuHqFD+3l8FNasA0j7GohoEA/vJyB/q4=;
  b=Hb/ZeiT5Fy7APMdvTakzTiAmH4Wg7nvpgPJiUBB1Fg1gsSpXwILd3xhx
   CnjDXA4TTb2Y9iCJ+4XnMUhg8iji3xRPtlh+cX1IDvoK4AvN4ymEgLZ6i
   cbdsIoF5DC23wp7ikT47mA2v3mcnResvdvR9kuHLrSwTF5IdvXX9pDy8L
   y6i6xU2zuoqKxn2qjYSwlnvKNpSmv39wnEIxkMBQHkcqAAp6iwSKoERJx
   DJi+nX66jRq588Q+fOvw28w/zIquI1buqEUTZ5DiAB8FTeMFP3Ws6OjPU
   Fw1l7W0SUVQFTCy2sLPnRsPLDoCjbs4KFDDrg4KERZ/p/4eIBICNROlul
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="389978588"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="389978588"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 20:25:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="906945453"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="906945453"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 20:25:23 -0800
Message-ID: <5a004819-b9bf-4a2e-b8b3-ed238a66245a@intel.com>
Date: Mon, 15 Jan 2024 12:25:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
 CPUID[4]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-15-zhao1.liu@linux.intel.com>
 <a0cd67f2-94f2-4c4b-9212-6b7344163660@intel.com> <ZaSpQuQxU5UrbIf4@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZaSpQuQxU5UrbIf4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/2024 11:40 AM, Zhao Liu wrote:
>>> +{
>>> +    uint32_t num_ids = 0;
>>> +
>>> +    switch (share_level) {
>>> +    case CPU_TOPO_LEVEL_CORE:
>>> +        num_ids = 1 << apicid_core_offset(topo_info);
>>> +        break;
>>> +    case CPU_TOPO_LEVEL_DIE:
>>> +        num_ids = 1 << apicid_die_offset(topo_info);
>>> +        break;
>>> +    case CPU_TOPO_LEVEL_PACKAGE:
>>> +        num_ids = 1 << apicid_pkg_offset(topo_info);
>>> +        break;
>>> +    default:
>>> +        /*
>>> +         * Currently there is no use case for SMT and MODULE, so use
>>> +         * assert directly to facilitate debugging.
>>> +         */
>>> +        g_assert_not_reached();
>>> +    }
>>> +
>>> +    return num_ids - 1;
>> suggest to just return num_ids, and let the caller to do the -1 work.
> Emm, SDM calls the whole "num_ids - 1" (CPUID.0x4.EAX[bits 14-25]) as
> "maximum number of addressable IDs for logical processors sharing this
> cache"...
> 
> So if this helper just names "num_ids" as max_lp_ids_share_the_cache,
> I'm not sure there would be ambiguity here?

I don't think it will.

if this function is going to used anywhere else, people will need to 
keep in mind to do +1 stuff to get the actual number.

leaving the -1 trick to where CPUID value gets encoded. let's make this 
function generic.

