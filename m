Return-Path: <kvm+bounces-14288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4DE58A1DA4
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0017A1C24325
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11252205E19;
	Thu, 11 Apr 2024 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/lXCewu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27FA205E03;
	Thu, 11 Apr 2024 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856086; cv=none; b=ufZv7KwMTuFKrpu8U+cMpiiSuy64y2ZFQ/VLzV2H1gBV/0STqvixB/LHE83vqKgJYz/8N7gMRDuBKe47tUlIK35qpE9huMhXbJVgo+ri5ok25Ob3z+AnSI4NP31TWCqQGR1c84Yv6xvdNCMXYc99lG5l22rWVGphN0bNSQAEgsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856086; c=relaxed/simple;
	bh=9ioxE1o8UnG6isr92DEgjeqRWdC/UVqQMVeZumMKxLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tDQU1C6Kr2fW7ZwgzBMJsLQsGgZCZAirRnSOIIdxbV+cQCQz4CL4JixhmOSbDO4JCSBcpE/BbFGvKhUUcpeKLcbza3k6w5j7C/a6kikDAMKGB/eXd+aLG2qe0I88NdcTWMPt94CBU3SCofu+dc551yeaehLteYs83IBQ4CZwPZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/lXCewu; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712856085; x=1744392085;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9ioxE1o8UnG6isr92DEgjeqRWdC/UVqQMVeZumMKxLc=;
  b=j/lXCewu8wqv3ffh9Xp8jpbCb+HYcdXluQabP+QAhq6DW6CvVJ+/eF52
   OZRGeSsAsLj0btUViRrTmlVvx+dORYh7oTeIrUhwShbVhiW3JWQ+rwsIo
   b9PsDv7h5GVk+6wgSu2wFR5ohaFpXms3DhwCJF9E1J9B/xmBGKNqpvQtZ
   foXcdPw2zfAnp7fNU5L7aFFxquG0b/YwvqAmkwdbTcKIXDJGBvDwSaHmG
   BAW6KCw3aT4ajBx81r9b3T+tiVfjKxR2P6Vr9AfrHHaXUDQ32hSrKq/NV
   5DJM/pz0XDz3McWEWZr3gcLcTHD81HocpXN7lPHNpeow0VbWcEmKsDkZ5
   w==;
X-CSE-ConnectionGUID: 9NBRAXkvQ4yADBv+cCYs5w==
X-CSE-MsgGUID: c5xu3xg7SPan2vUNChV7YA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="30763755"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="30763755"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 10:21:25 -0700
X-CSE-ConnectionGUID: tpJNOLeaSk2dvSqvPGUzUw==
X-CSE-MsgGUID: xS6IlqjVTVuys+FxOUhtdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="51920840"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 10:21:24 -0700
Received: from [10.212.101.117] (kliang2-mobl1.ccr.corp.intel.com [10.212.101.117])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id CC4C520921D6;
	Thu, 11 Apr 2024 10:21:21 -0700 (PDT)
Message-ID: <56a98cae-36c5-40f8-8554-77f9d9c9a1b0@linux.intel.com>
Date: Thu, 11 Apr 2024 13:21:20 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/41] perf: x86/intel: Support
 PERF_PMU_CAP_VPMU_PASSTHROUGH
To: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-2-xiong.y.zhang@linux.intel.com>
 <ZhgYD4B1szpbvlHq@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZhgYD4B1szpbvlHq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-11 1:04 p.m., Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> Define and apply the PERF_PMU_CAP_VPMU_PASSTHROUGH flag for the version 4
>> and later PMUs
> 
> Why?  I get that is an RFC, but it's not at all obvious to me why this needs to
> take a dependency on v4+.

The IA32_PERF_GLOBAL_STATUS_RESET/SET MSRs are introduced in v4. They
are used in the save/restore of PMU state. Please see PATCH 23/41.
So it's limited to v4+ for now.

Thanks,
Kan

