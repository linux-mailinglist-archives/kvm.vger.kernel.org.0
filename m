Return-Path: <kvm+bounces-12318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 051AF88163A
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 18:12:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B49172825DC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 17:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958566A02D;
	Wed, 20 Mar 2024 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tx1+fgFN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F3E3EA64;
	Wed, 20 Mar 2024 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954757; cv=none; b=Q84u9FGQIohNLhMUV9M4McVfKJQaYgBWPPm32b0uhCYKDGYrjRGvFkQSqLWLYXWjiWLTRTgIJ36hP/M3AFv0du9hP8dfntbDrLvw/YWXFv11d6BRGHaRmByiJj3C475Lqx4AXMmgF3Vrb9GZj6xa+ezyqP64am6289jLrTVPZjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954757; c=relaxed/simple;
	bh=NS4x9r2TFhkTcyObcZJpU6SIzpzXoCPOlYMJEotNZqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sbfQ7PAMvFdUqww/OCYyVt1+JO7hOBKqUu1UOYCqing8e7wuZtxT0+I0UuAO8j69HSlNOSUwwrGxTL5I0q0fdv+8nf6b0OUD7nJOfRrrYLzXywBaHee4fszve9XE6I/3T6OYreHqhQYbZ9ztEYR72+6C+x1p1+JA3RyYqIJAvMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tx1+fgFN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710954756; x=1742490756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NS4x9r2TFhkTcyObcZJpU6SIzpzXoCPOlYMJEotNZqs=;
  b=Tx1+fgFNloggEUmgCNmr2qexTAu0mEpUt6iVzvoD22npKi89lS3GRFZZ
   2sM1h9233k6z8vrdt5yAQZPJ72yiImzI7g1LFmwa2+a/XZmSoEXiD5OFu
   ZBpMxrzwhqSS+UGiSgfz9WE57z7BhBofUC/dIUYeOzNhmc+EpThuz5kUf
   6K5xU1P+2mCTj8MZYNMpHQwEvzrsMu8946rfb3R4nMDTdY7i0u/siKc/5
   xKyfmsZMI8F3SjBxctu1sY04XVRrKo4jfSW62hfTLwrRGfJAYHBl+dYZD
   aM8NQpxOHxUHjiFXXyxjh37pc1hoAjtY9YScRCGBvurEzeIgIZ/VJHRPo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5771437"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="5771437"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 10:12:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14618463"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 10:12:35 -0700
Received: from [10.212.76.154] (kliang2-mobl1.ccr.corp.intel.com [10.212.76.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 477B9580E13;
	Wed, 20 Mar 2024 10:12:33 -0700 (PDT)
Message-ID: <e4200636-90b1-419f-a4c7-61766eac3b9a@linux.intel.com>
Date: Wed, 20 Mar 2024 13:12:31 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: Raghavendra Rao Ananta <rananta@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
 mizhang@google.com, kan.liang@intel.com, zhenyuw@linux.intel.com,
 dapeng1.mi@linux.intel.com, jmattson@google.com, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com,
 samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
 <CAJHc60ww7cOhtbWNp9WP7bxWKXCZtcT=6e4Fk2TaB63YqWMWbw@mail.gmail.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CAJHc60ww7cOhtbWNp9WP7bxWKXCZtcT=6e4Fk2TaB63YqWMWbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-03-20 12:40 p.m., Raghavendra Rao Ananta wrote:
> Hi Kan,
> 
>>
>> +static void __perf_force_exclude_guest_pmu(struct perf_event_pmu_context *pmu_ctx,
>> +                                          struct perf_event *event)
>> +{
>> +       struct perf_event_context *ctx = pmu_ctx->ctx;
>> +       struct perf_event *sibling;
>> +       bool include_guest = false;
>> +
>> +       event_sched_out(event, ctx);
>> +       if (!event->attr.exclude_guest)
>> +               include_guest = true;
>> +       for_each_sibling_event(sibling, event) {
>> +               event_sched_out(sibling, ctx);
>> +               if (!sibling->attr.exclude_guest)
>> +                       include_guest = true;
>> +       }
>> +       if (include_guest) {
>> +               perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
>> +               for_each_sibling_event(sibling, event)
>> +                       perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
>> +       }
> Does the perf core revert the PERF_EVENT_STATE_ERROR state somewhere
> from the perf_guest_exit() path, or is it expected to remain in this
> state?
> IIUC, in the perf_guest_exit() path, when we land into
> merge_sched_in(), we never schedule the event back if event->state <=
> PERF_EVENT_STATE_OFF.
> 

The perf doesn't revert event with the ERROR STATE. A user asks to
profile both guest and host, but the pass-through mode doesn't allow the
profiling of the guest. So it has to error out and remain the ERROR STATE.

Thanks,
Kan


