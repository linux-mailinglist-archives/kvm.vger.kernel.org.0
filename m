Return-Path: <kvm+bounces-14371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D428A23C1
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 04:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0716CB21D6A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 02:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801AC10957;
	Fri, 12 Apr 2024 02:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3f2/CGD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186934C70;
	Fri, 12 Apr 2024 02:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712888419; cv=none; b=lo2mRXFCgJ2c4dNOGGPgqsWpPuAgU7Y9zLlYOFOREQE+Wij0sIfSIk4wPKIvYiPwg/rnWX2hNbFnNvZOMkkewtKlPiq4lPezgw1nbV+2dAu6G5wX8sPxp2bwgBP/git6u/wdnBC7vTeWh0RFU4OrclGcqDJzW/L//B4eSFd1xsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712888419; c=relaxed/simple;
	bh=oK34Wf0XYwEqo6P0lzbmdCpmUBzezW2md526vVn1sek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LaHtKEXQcBw70fgEj3XAdbFIfGkOuDM3rhTHsE8h9BoOBijI0EdV6XGkiHA1VWrQPDJjO/s6WsieOAxxqZmAtRHwTEEm77K1XLKaltJfPfDxx8trJL/ArMEymIHoGIDxFJfGafQoA6YBmSNZUVI9sawC84v3G07fsSldKFp1jFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3f2/CGD; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712888419; x=1744424419;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oK34Wf0XYwEqo6P0lzbmdCpmUBzezW2md526vVn1sek=;
  b=g3f2/CGDCciyBRvw2V9+QOMy/yeCy4SMNTsdMunMhpUFty7RpWdOiSn/
   zj3InDqLwydJidwH5MEr1HNWcwifj8vJ1KU04BEDD4ztutdgWUm5zsovj
   tGiP8iorgrF62Jn7R3pYlcA6XUtH2F7TBHQETh5EUuav9PtB4Wumdqbig
   cvgz2O1JtgJZosR6IAjXy7sHik2puVxqppQaxawx76eGRsEazeZHU/PGo
   oEpq+ysKqMZevEB9sjBZcsT0804FU3Ojewm6asPU0ENesP/KBGFVAyIs9
   cZ2doGGxSZ+L6mCacRt5hoMc+pvpYp8C53IzmtHxUdS5FcJ1vClPN0yDQ
   Q==;
X-CSE-ConnectionGUID: tQLSC+HfTC+jtUf0Hstp7Q==
X-CSE-MsgGUID: lmO4YhRoTp2xE84dK8upbQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="25788131"
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="25788131"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 19:20:18 -0700
X-CSE-ConnectionGUID: 1lcHP6WkS8iu7fvgQDk9GA==
X-CSE-MsgGUID: 5+TXo8oqTJagXhkQlpadbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="21581981"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.244.162]) ([10.124.244.162])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 19:20:12 -0700
Message-ID: <f6f714ef-eb58-4aa9-9c4d-12bfe29c383b@linux.intel.com>
Date: Fri, 12 Apr 2024 10:19:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/41] KVM: x86/pmu: Introduce passthrough vPM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <ZhgX6BStTh05OfEd@google.com>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <ZhgX6BStTh05OfEd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/2024 1:03 AM, Sean Christopherson wrote:
> <bikeshed>
> 
> I think we should call this a mediated PMU, not a passthrough PMU.  KVM still
> emulates the control plane (controls and event selectors), while the data is
> fully passed through (counters).
> 
> </bikeshed>
> 
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> 
>> 1. host system wide / QEMU events handling during VM running
>>    At VM-entry, all the host perf events which use host x86 PMU will be
>>    stopped. These events with attr.exclude_guest = 1 will be stopped here
>>    and re-started after vm-exit. These events without attr.exclude_guest=1
>>    will be in error state, and they cannot recovery into active state even
>>    if the guest stops running. This impacts host perf a lot and request
>>    host system wide perf events have attr.exclude_guest=1.
>>
>>    This requests QEMU Process's perf event with attr.exclude_guest=1 also.
>>
>>    During VM running, perf event creation for system wide and QEMU
>>    process without attr.exclude_guest=1 fail with -EBUSY. 
>>
>> 2. NMI watchdog
>>    the perf event for NMI watchdog is a system wide cpu pinned event, it
>>    will be stopped also during vm running, but it doesn't have
>>    attr.exclude_guest=1, we add it in this RFC. But this still means NMI
>>    watchdog loses function during VM running.
>>
>>    Two candidates exist for replacing perf event of NMI watchdog:
>>    a. Buddy hardlock detector[3] may be not reliable to replace perf event.
>>    b. HPET-based hardlock detector [4] isn't in the upstream kernel.
> 
> I think the simplest solution is to allow mediated PMU usage if and only if
> the NMI watchdog is disabled.  Then whether or not the host replaces the NMI
> watchdog with something else becomes an orthogonal discussion, i.e. not KVM's
> problem to solve.
Make sense. KVM should not affect host high priority work.
NMI watchdog is a client of perf and is a system wide perf event, perf can't distinguish a system wide perf event is NMI watchdog or others, so how about we extend this suggestion to all the system wide perf events ?
mediated PMU is only allowed when all system wide perf events are disabled or non-exist at vm creation.
but NMI watchdog is usually enabled, this will limit mediated PMU usage.
> 
>> 3. Dedicated kvm_pmi_vector
>>    In emulated vPMU, host PMI handler notify KVM to inject a virtual
>>    PMI into guest when physical PMI belongs to guest counter. If the
>>    same mechanism is used in passthrough vPMU and PMI skid exists
>>    which cause physical PMI belonging to guest happens after VM-exit,
>>    then the host PMI handler couldn't identify this PMI belongs to
>>    host or guest.
>>    So this RFC uses a dedicated kvm_pmi_vector, PMI belonging to guest
>>    has this vector only. The PMI belonging to host still has an NMI
>>    vector.
>>
>>    Without considering PMI skid especially for AMD, the host NMI vector
>>    could be used for guest PMI also, this method is simpler and doesn't
> 
> I don't see how multiplexing NMIs between guest and host is simpler.  At best,
> the complexity is a wash, just in different locations, and I highly doubt it's
> a wash.  AFAIK, there is no way to precisely know that an NMI came in via the
> LVTPC.
when kvm_intel.pt_mode=PT_MODE_HOST_GUEST, guest PT's PMI is a multiplexing NMI between guest and host, we could extend guest PT's PMI framework to mediated PMU. so I think this is simpler.
> 
> E.g. if an IPI NMI arrives before the host's PMU is loaded, confusion may ensue.
> SVM has the luxury of running with GIF=0, but that simply isn't an option on VMX.
> 
>>    need x86 subsystem to reserve the dedicated kvm_pmi_vector, and we
>>    didn't meet the skid PMI issue on modern Intel processors.
>>
>> 4. per-VM passthrough mode configuration
>>    Current RFC uses a KVM module enable_passthrough_pmu RO parameter,
>>    it decides vPMU is passthrough mode or emulated mode at kvm module
>>    load time.
>>    Do we need the capability of per-VM passthrough mode configuration?
>>    So an admin can launch some non-passthrough VM and profile these
>>    non-passthrough VMs in host, but admin still cannot profile all
>>    the VMs once passthrough VM existence. This means passthrough vPMU
>>    and emulated vPMU mix on one platform, it has challenges to implement.
>>    As the commit message in commit 0011, the main challenge is 
>>    passthrough vPMU and emulated vPMU have different vPMU features, this
>>    ends up with two different values for kvm_cap.supported_perf_cap, which
>>    is initialized at module load time. To support it, more refactor is
>>    needed.
> 
> I have no objection to an all-or-nothing setup.  I'd honestly love to rip out the
> existing vPMU support entirely, but that's probably not be realistic, at least not
> in the near future.
> 
>> Remain Works
>> ===
>> 1. To reduce passthrough vPMU overhead, optimize the PMU context switch.
> 
> Before this gets out of its "RFC" phase, I would at least like line of sight to
> a more optimized switch.  I 100% agree that starting with a conservative
> implementation is the way to go, and the kernel absolutely needs to be able to
> profile KVM itself (and everything KVM calls into), i.e. _always_ keeping the
> guest PMU loaded for the entirety of KVM_RUN isn't a viable option.
> 
> But I also don't want to get into a situation where can't figure out a clean,
> robust way to do the optimized context switch without needing (another) massive
> rewrite.
> 
Current PMU context switch happens at each vm-entry/exit, this impacts guest performance even if guest doesn't use PMU, as our first optimization, we will switch the PMU context only when guest really use PMU.

thanks

