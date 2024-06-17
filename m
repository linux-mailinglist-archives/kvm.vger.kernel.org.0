Return-Path: <kvm+bounces-19794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 639DF90B577
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7C3C2851A4
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5AB1411F0;
	Mon, 17 Jun 2024 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GX7DWanE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFEC847A;
	Mon, 17 Jun 2024 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718639113; cv=none; b=iqhGrTTT4yCf1eS3aVpSArtb8fR4jmXZ6bwDKu3HzuRNfoO9/H9NA4jbo8FjeIsDGleqw21UM99EhHQY21noEPc2Wc6cDlKn3XQaF+LpiUO2ouoB9+EaUtrsFvhGewILqQbZLKK5hEliFXTl789yBzTf6XMFNrhZyOnGE3Sqwf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718639113; c=relaxed/simple;
	bh=MZFJlKDbBJ6eK0OqtV0dh2c+XfyBVqooU/cWzg8IwKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ds7OT+paSMfmzoPjUGh4yH0PZf5L2ARrG2F/8+jjSvgasSSGcwyZU01OlXn+Q+80JEdpujf7tE2t9QKo9P+BVwLQPFP5rl+g/cOdLhNPwc0MWIxCsNkxeZbBSfPjPK7wIPo8wkQ55QmHF6AbgHelF2u9zSMfqAko7kunhmMVwWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GX7DWanE; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718639112; x=1750175112;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MZFJlKDbBJ6eK0OqtV0dh2c+XfyBVqooU/cWzg8IwKU=;
  b=GX7DWanE6g1vf9lsvTiLT6GE+P4ojLiSiZ+mS2/XG2waAWM/pJaurSow
   VoNFf3KeB94n7VBRbj6QJDiMKW1hbe4h2h0VZ1itZX+Pu7Jvsw19JKY9w
   hNOFkjiRgBpVdpVR4pwHyrjxuPCkyo7vWUSNGP6iHIljmlLoHSzCFL3AT
   JyY4BIXTm/QNH6JrZUAIwd3gUNZlcrkNTYOSlpGcuBujh/RmmRIYRIhwk
   VnUqDfkcgxl5bKvv1GYKsJ4W+l4pMZSShjNJi5gNr+TLv3Y8kIbcT9lzd
   bprLqOyAjb0ejknWmarXUsnANPf9SLKEKIH0MDjVAEdwM0R73y2pYddPr
   Q==;
X-CSE-ConnectionGUID: MilMomKlSG6laStTR+zPng==
X-CSE-MsgGUID: xxO9EZxIQ/STWwPRs0AmXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="26050531"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="26050531"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 08:45:11 -0700
X-CSE-ConnectionGUID: MRGidVNXTOyjKyJ2SkOCsA==
X-CSE-MsgGUID: Av24Ueh2QiiwrLdAEZ+Ybg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="41094189"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 08:45:11 -0700
Received: from [10.212.91.105] (kliang2-mobl1.ccr.corp.intel.com [10.212.91.105])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 1DA7920B5703;
	Mon, 17 Jun 2024 08:45:07 -0700 (PDT)
Message-ID: <d0eb2af0-4188-440a-ab90-1f90b88820ee@linux.intel.com>
Date: Mon, 17 Jun 2024 11:45:06 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/54] perf: Add generic exclude_guest support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
 <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
 <20240612111732.GW40213@noisy.programming.kicks-ass.net>
 <e72c847f-a069-43e4-9e49-37c0bf9f0a8b@linux.intel.com>
 <20240613091507.GA17707@noisy.programming.kicks-ass.net>
 <3755c323-6244-4e75-9e79-679bd05b13a4@linux.intel.com>
 <f4da2fb2-fa09-4d2b-a78d-1b459ada6d09@linux.intel.com>
 <20240617075123.GX40213@noisy.programming.kicks-ass.net>
 <5fcf4471-bcf9-43af-93a0-dcc4fae27449@linux.intel.com>
 <20240617150038.GW8774@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20240617150038.GW8774@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-06-17 11:00 a.m., Peter Zijlstra wrote:
>>> only the
>>> 'normal' sched-out should stop time.
>> If the guest is the only case which we want to keep the time for, I
>> think we may use a straightforward check as below.
>>
>> 	stop = !(event_type & EVENT_GUEST) && ctx == &cpuctx->ctx;
> So I think I was trying to get stop true when there weren't in fact
> events on, that is when we got in without EVENT_ALL bits, but perhaps
> that case isn't relevant.

It should be irrelevant. Here I think we just need to make sure that the
guest is not the reason for stopping the time if there is an active
time. For the others, there is nothing changed.
The __this_cpu_read(perf_in_guest) check will guarantee that both guest
time and host time sync when any updates occur in the guest mode.

Thanks,
Kan

