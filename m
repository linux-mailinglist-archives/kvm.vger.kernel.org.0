Return-Path: <kvm+bounces-16117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 769ED8B48FB
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 02:59:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B162D1C20E64
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 00:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875DF110A;
	Sun, 28 Apr 2024 00:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZbkQ2qu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF60764A;
	Sun, 28 Apr 2024 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714265939; cv=none; b=RA9CjTt3uN75CaSoqnv3xinM8auaMK7SInkM/ZX3fR94BeiF86oSXXZUXksHFlTHtYdRWqCShCBGRD6HLe2oEqnoEVrqu9v5C5zS/jeLm3MpeW2qLMbrEGfuVTDP4roeW5T7mBn6Eh66PgrlHXEjUAey9E3iVMkrtPcfvWdGWDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714265939; c=relaxed/simple;
	bh=sruZuykMgwQNrqDsSrjLsyhTwtcH6jJaF/1elUBTY4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oJEjg8UYblshmzYK868Gw7Opr1YlKw+UXhQFJO3Jb2mJgEwVHGD80XET0WxGT1cGTn6V/N4YKUt6tJdgLDEwvSodrH8HF+nRoCqK3L8pzUe0w5u9//u/OL53D4O3i0nn7LdBRClnNENjS45q4xSYqZR369MTbh8vqKX9lNNkdwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZbkQ2qu; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714265938; x=1745801938;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sruZuykMgwQNrqDsSrjLsyhTwtcH6jJaF/1elUBTY4o=;
  b=WZbkQ2qunJKXyRHUKZ5cF2TwWCiNvHhfjzXsTYu1gilfOP2HKOQQlbV5
   +aZFtsr95MX4pGP5QCyB7/oXXOgZWCb0yV2MPIY5ZLqzTM1CrjwYhltLz
   OviE7Yag7zTuCtxc06Z6OmlO8bYP61oSu25IeStQ1HfVHlU1lJbArbvQH
   HSm/vJBVXuUoe4AdS+INvfMKWKMlXOJ7zg0WRcJTk5TrvV1MJqN8BDspf
   Y9TaQ6/33NBidnDlqLdUSyVmicwHAoWLF7Tukruo6LJtfvGoO8zNpkCW0
   7MpvANHuym5OQXdd9z/rgBC7rW7ZxxKkfZO6qOiQfF0lZvI1tv6sNnAaT
   g==;
X-CSE-ConnectionGUID: c7P+zrYJRPeoG3GMLCd9+g==
X-CSE-MsgGUID: KLLNWMcZTyuAv3FY7qv+1A==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="9827167"
X-IronPort-AV: E=Sophos;i="6.07,236,1708416000"; 
   d="scan'208";a="9827167"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2024 17:58:57 -0700
X-CSE-ConnectionGUID: 1ADNkzFRT7KuUnFBhO/zJg==
X-CSE-MsgGUID: fFQsozLAQF6AxccK77EbFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,236,1708416000"; 
   d="scan'208";a="25642447"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2024 17:58:53 -0700
Message-ID: <b9095b0d-72f0-4e54-8d2e-f965ddff06bb@linux.intel.com>
Date: Sun, 28 Apr 2024 08:58:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Kan Liang <kan.liang@linux.intel.com>, maobibo <maobibo@loongson.cn>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com>
 <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
 <ZirPGnSDUzD-iWwc@google.com>
 <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
 <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com>
 <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
 <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com>
 <ZiwEoZDIg8l7-uid@google.com>
 <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/27/2024 11:04 AM, Mingwei Zhang wrote:
> On Fri, Apr 26, 2024 at 12:46 PM Sean Christopherson <seanjc@google.com> wrote:
>> On Fri, Apr 26, 2024, Kan Liang wrote:
>>>> Optimization 4
>>>> allows the host side to immediately profiling this part instead of
>>>> waiting for vcpu to reach to PMU context switch locations. Doing so
>>>> will generate more accurate results.
>>> If so, I think the 4 is a must to have. Otherwise, it wouldn't honer the
>>> definition of the exclude_guest. Without 4, it brings some random blind
>>> spots, right?
>> +1, I view it as a hard requirement.  It's not an optimization, it's about
>> accuracy and functional correctness.
> Well. Does it have to be a _hard_ requirement? no? The irq handler
> triggered by "perf record -a" could just inject a "state". Instead of
> immediately preempting the guest PMU context, perf subsystem could
> allow KVM defer the context switch when it reaches the next PMU
> context switch location.
>
> This is the same as the preemption kernel logic. Do you want me to
> stop the work immediately? Yes (if you enable preemption), or No, let
> me finish my job and get to the scheduling point.
>
> Implementing this might be more difficult to debug. That's my real
> concern. If we do not enable preemption, the PMU context switch will
> only happen at the 2 pairs of locations. If we enable preemption, it
> could happen at any time.

IMO I don't prefer to add a switch to enable/disable the preemption. I 
think current implementation is already complicated enough and 
unnecessary to introduce an new parameter to confuse users. Furthermore, 
the switch could introduce an uncertainty and may mislead the perf user 
to read the perf stats incorrectly.  As for debug, it won't bring any 
difference as long as no host event is created.


>
>> What _is_ an optimization is keeping guest state loaded while KVM is in its
>> run loop, i.e. initial mediated/passthrough PMU support could land upstream with
>> unconditional switches at entry/exit.  The performance of KVM would likely be
>> unacceptable for any production use cases, but that would give us motivation to
>> finish the job, and it doesn't result in random, hard to diagnose issues for
>> userspace.
> That's true. I agree with that.
>
>>>> Do we want to preempt that? I think it depends. For regular cloud
>>>> usage, we don't. But for any other usages where we want to prioritize
>>>> KVM/VMM profiling over guest vPMU, it is useful.
>>>>
>>>> My current opinion is that optimization 4 is something nice to have.
>>>> But we should allow people to turn it off just like we could choose to
>>>> disable preempt kernel.
>>> The exclude_guest means everything but the guest. I don't see a reason
>>> why people want to turn it off and get some random blind spots.

