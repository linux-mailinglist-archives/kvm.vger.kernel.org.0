Return-Path: <kvm+bounces-32131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 759AF9D34E9
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 08:57:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ECE61F23E30
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 07:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B5316F858;
	Wed, 20 Nov 2024 07:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UtWT8Kki"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9305D60DCF;
	Wed, 20 Nov 2024 07:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732089452; cv=none; b=em1pWSvbMvIoH0WMMO8ad7XU9O9VFrRyJSs0+G5jbLMD6qTfJMGVEPhjK5+9xUVTxIHPzdcBvWYEz4fDn4O3/w/5Be0UXP5WPFfqgw5ZTT1H4GqFOEpA62cGpQaUyYjK00MWQTrn3iko6FEB5/SE4+o2N9tt1DoqhoRo31Szr14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732089452; c=relaxed/simple;
	bh=5klydhEP2ptHYa0hRUtNWjeZ6O8S9XNbyXOAH1C48J0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U/vmeh6oU0Tf8qA4KVy99YCMSTkV+RufDvyVQKuUZ4XiNG6VTztQBxLgbY62XqhszQjtdEcmemcxpu3fWe1Ndst4PiOdsKtLu/mnlrc/8LyVUrokQHfiBAtZO243xb0+BC0F59LDxLly+yWkGXkeUEceGN3FCaoqQ3usPwCHs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UtWT8Kki; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732089451; x=1763625451;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5klydhEP2ptHYa0hRUtNWjeZ6O8S9XNbyXOAH1C48J0=;
  b=UtWT8KkiKZi6jnFBubLkagxuFMmAb36mlJ5woQ/cNhpFb8ndntRcFQYS
   QT+VRLwzZrqK02RELY4HPj4aVbmZHrgaVCsxKq9JMnkp299k1IqGm6p7c
   K1Y927BrVAngWA6Wy/S/+AOilPBdDfQArzRXqMngchaiZMaSZwRFtd1hb
   XCNGS5oqnyYfmFiJv9t/y6zDL7ITD8NUL93GQxZIbCwPpltfS6aLHSKS5
   Oigfh3lom/nv7IUA/aUa13BgRSFFnbYwrSuw8+fQJ4jAaJTBsk+UJRd30
   M5xFCh85PGeWMKB3XoFWPMcy/FSTPtvZ8h+0z9mw9wNjgv1GZJYwKkHn3
   g==;
X-CSE-ConnectionGUID: yAcfCrrfRkaYn5YIeu7izQ==
X-CSE-MsgGUID: g3w7odcAQU+tV0ppnMXRNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="34986812"
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="34986812"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 23:57:30 -0800
X-CSE-ConnectionGUID: EtzEjOvMRTWPZUYakc+vyQ==
X-CSE-MsgGUID: zHtU3+7lSdWwgi3/x5ne+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="93895425"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 23:57:25 -0800
Message-ID: <691ea302-e1cc-44bd-91d2-92c27e89daa6@linux.intel.com>
Date: Wed, 20 Nov 2024 15:57:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 27/58] KVM: x86/pmu: Create a function prototype to
 disable MSR interception
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
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
 <20240801045907.4010984-28-mizhang@google.com> <ZzzWLyhFmwSON6K6@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzzWLyhFmwSON6K6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/20/2024 2:17 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
>> interception.
> This hook/patch should be unnecessary, the logic belongs in the vendor refresh()
> callback.

Yes.



