Return-Path: <kvm+bounces-32231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B86D9D45A9
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D27BFB22AD8
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 02:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE2C7080A;
	Thu, 21 Nov 2024 02:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lsH8y80t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394E923098E;
	Thu, 21 Nov 2024 02:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732154729; cv=none; b=FaPqqz7iQJxnQnMaIjnzUq2qqTJ6iVoR0xKbZi/fIkKIUFPNw8xKVeCw94hCTnZN4KmVa4yqDEshgGtUNw59Fp/LpgQWCMIMh7yEU2iB6xih4Msh9meFXwkW/Qhmi4ydJP8nX5IrLTzHRtYmAEeZlUAimwIhbSnSsacs+QwZLws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732154729; c=relaxed/simple;
	bh=m/U6SpuID0SlkPq2iYQQi1gQBQ4UwQ+ea4P9iXI+LxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3ckwKpU7Sk628hD6fOiq5v9T5GgM1/xGMo+vF3Bx+sFRZfYONVOlzIK6hXOuO/n748DDVl91lXu0XwzpdIeWbzg36SzMW7rJifVA2tEyMTFUllztrzftrofja7WSUI+NI7RcEssxusTTVi/1W+JlEx41WKDAYey/Wfzw4zg27o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lsH8y80t; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732154729; x=1763690729;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m/U6SpuID0SlkPq2iYQQi1gQBQ4UwQ+ea4P9iXI+LxQ=;
  b=lsH8y80t/h1lzUL6l7e/R9xJpkjYdZpUZho70OjdrsU4bjOu9jRZDlPH
   JiWNSIwef2E/EF3/ofKHXdHEkqDGE1x0gmAAMwO7mHyhZz6k7QcDEBTJ1
   lJEnlSBDDMm1Z/iFj5rl/7oIBQ/QjtZvWMse24gqcMXSQX7lZIy6NWAnq
   qjDFiWPQri77OXOIOzNo8srLROV45eE3aUlyH2yhRLNWOzxk2QiZjNS5A
   vnjnMJq63onXVj+KfvagmlK1a0KEhbPpMXfltaFglYAI9bB1/7m+ylcwv
   GwEDoaZklGR0RnpwyCvPGCGHa8lVscTkhRgRjQMRkjG/qg70ICSlWtsTZ
   Q==;
X-CSE-ConnectionGUID: 2mAzhiztQMG96QlOgKk4+A==
X-CSE-MsgGUID: doJEKrisSnyDvZ4h+hCVKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="31992598"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="31992598"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:05:27 -0800
X-CSE-ConnectionGUID: syeSNi0UT8SC0UtGOSIWpA==
X-CSE-MsgGUID: 7tMuD8hqRna5twxBiWEM5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90498564"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:05:21 -0800
Message-ID: <1e26029a-ef9a-4468-b66f-b47f5139ad88@linux.intel.com>
Date: Thu, 21 Nov 2024 10:05:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 43/58] KVM: x86/pmu: Introduce PMU operator for
 setting counter overflow
To: Sean Christopherson <seanjc@google.com>, Zide Chen <zide.chen@intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-44-mizhang@google.com>
 <d0d8a945-1623-448a-b08a-8877464a4531@intel.com>
 <Zz4u6ThdAZ9M83wf@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz4u6ThdAZ9M83wf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 2:48 AM, Sean Christopherson wrote:
> On Fri, Oct 25, 2024, Zide Chen wrote:
>>
>> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>>> Introduce PMU operator for setting counter overflow. When emulating counter
>>> increment, multiple counters could overflow at the same time, i.e., during
>>> the execution of the same instruction. In passthrough PMU, having an PMU
>>> operator provides convenience to update the PMU global status in one shot
>>> with details hidden behind the vendor specific implementation.
>> Since neither Intel nor AMD does implement this API, this patch should
>> be dropped.
> For all of these small APIs, please introduce and use the API in the same patch.
> That avoids goofs like this, where something is never used, and makes the patches
> far easier to review.

Sure.


>

