Return-Path: <kvm+bounces-14724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9814E8A62DC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1DADB22B84
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F9539FFE;
	Tue, 16 Apr 2024 05:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPDuRXQf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316011CD06;
	Tue, 16 Apr 2024 05:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244329; cv=none; b=SAvSMfoC7rS0qmlxu1pYZG2SesW87G34D4EoUSvkMBHUiD7rBP6KjECikBVBPh+0Id2QeVTnAaLrVZu0sy726zJoyPqmIfgE3tjQ0LQQhKe+7rZaXYbyoNqSySrFP+uSGo00kX6zBPBwNJFgZidlzARBOIHnNcmJpctKvpKUEBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244329; c=relaxed/simple;
	bh=Xk702F0LwWoR8IwEhI5DFA1b/JYz97xwQQDY6dFv2D0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q9cmMabzss4T8wGkfRdXZS4YUWwR8wTL63bAjo43VI5bkQY5TUv1gJayuEUpGjoowLCfQuDjhZGBn0IknEU08kHKSvkB5V6OgFiussQmbsM0T3wuP1cl/260cVhWSfEBzs4y+mOCttYmPgXKPyQtDAe8Q+KBp3kvbirelAnDxok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPDuRXQf; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713244327; x=1744780327;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xk702F0LwWoR8IwEhI5DFA1b/JYz97xwQQDY6dFv2D0=;
  b=SPDuRXQfPnneAtiIunkL2WyCSAYe4nWwTWZelvNb8iTEfQRTcoFMLYKl
   cgiiDqKDzTETF0eiD1NXPVnvYdC45CPdqL/U3s2pYQJj6iF1RvEkCWNxz
   AKmRque/0YzPuHTvytkE1TMp+Cv1LEX5irC3MbBqmy+EEM1AKJmRY6uXP
   oZ8Yf9rCVjzLgb9NAvrMkI3g0zK+NT+3mJ9CjoiCMZbQPZFE7sw0IpzW0
   BYx5+81rDyW+Zy8FKq3kMHVdbQD47A2HXjoHYtYCw0IzapGonRFEXe7Wz
   fiy2AnAaKvNdC5gC1SRdsKhYuILyBlW4vuvthxdEWrTRGCvUBwMYuoWL3
   A==;
X-CSE-ConnectionGUID: em44YNQOTuSzGSubBV8JqQ==
X-CSE-MsgGUID: rnLFtWddQVmDXCxNudp8qA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="26176781"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26176781"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 22:12:06 -0700
X-CSE-ConnectionGUID: fwpcdSv+Qg6Ln0RoMBkODw==
X-CSE-MsgGUID: onzIOJOaQOSwKu1xjB+Qcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26801136"
Received: from unknown (HELO [10.238.128.139]) ([10.238.128.139])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 22:12:02 -0700
Message-ID: <47157187-47d8-424e-9bd1-b98690dfe68a@linux.intel.com>
Date: Tue, 16 Apr 2024 13:11:59 +0800
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
 <f6f714ef-eb58-4aa9-9c4d-12bfe29c383b@linux.intel.com>
 <Zhl-JFk5hw-hlyGi@google.com>
 <9469faf7-1659-4436-848f-53ec01d967f2@linux.intel.com>
 <Zh1CL8Gf1YpBvvXd@google.com>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <Zh1CL8Gf1YpBvvXd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/15/2024 11:05 PM, Sean Christopherson wrote:
> On Mon, Apr 15, 2024, Xiong Y Zhang wrote:
>> On 4/13/2024 2:32 AM, Sean Christopherson wrote:
>>> On Fri, Apr 12, 2024, Xiong Y Zhang wrote:
>>>>>> 2. NMI watchdog
>>>>>>    the perf event for NMI watchdog is a system wide cpu pinned event, it
>>>>>>    will be stopped also during vm running, but it doesn't have
>>>>>>    attr.exclude_guest=1, we add it in this RFC. But this still means NMI
>>>>>>    watchdog loses function during VM running.
>>>>>>
>>>>>>    Two candidates exist for replacing perf event of NMI watchdog:
>>>>>>    a. Buddy hardlock detector[3] may be not reliable to replace perf event.
>>>>>>    b. HPET-based hardlock detector [4] isn't in the upstream kernel.
>>>>>
>>>>> I think the simplest solution is to allow mediated PMU usage if and only if
>>>>> the NMI watchdog is disabled.  Then whether or not the host replaces the NMI
>>>>> watchdog with something else becomes an orthogonal discussion, i.e. not KVM's
>>>>> problem to solve.
>>>> Make sense. KVM should not affect host high priority work.
>>>> NMI watchdog is a client of perf and is a system wide perf event, perf can't
>>>> distinguish a system wide perf event is NMI watchdog or others, so how about
>>>> we extend this suggestion to all the system wide perf events ?  mediated PMU
>>>> is only allowed when all system wide perf events are disabled or non-exist at
>>>> vm creation.
>>>
>>> What other kernel-driven system wide perf events are there?
>> does "kernel-driven" mean perf events created through
>> perf_event_create_kernel_counter() like nmi_watchdog and kvm perf events ?
> 
> By kernel-driven I meant events that aren't tied to a single userspace process
> or action.
> 
> E.g. KVM creates events, but those events are effectively user-driven because
> they will go away if the associated VM terminates.
> 
>> User can create system wide perf event through "perf record -e {} -a" also, I
>> call it as user-driven system wide perf events.  Perf subsystem doesn't
>> distinguish "kernel-driven" and "user-driven" system wide perf events.
> 
> Right, but us humans can build a list, even if it's only for documentation, e.g.
> to provide help for someone to run KVM guests with mediated PMUs, but can't
> because there are active !exclude_guest events.
> 
>>>> but NMI watchdog is usually enabled, this will limit mediated PMU usage.
>>>
>>> I don't think it is at all unreasonable to require users that want optimal PMU
>>> virtualization to adjust their environment.  And we can and should document the
>>> tradeoffs and alternatives, e.g. so that users that want better PMU results don't
>>> need to re-discover all the "gotchas" on their own.
>>>
>>> This would even be one of the rare times where I would be ok with a dmesg log.
>>> E.g. if KVM is loaded with enable_mediated_pmu=true, but there are system wide
>>> perf events, pr_warn() to explain the conflict and direct the user at documentation
>>> explaining how to make their system compatible with mediate PMU usage.> 
>>>>>> 3. Dedicated kvm_pmi_vector
>>>>>>    In emulated vPMU, host PMI handler notify KVM to inject a virtual
>>>>>>    PMI into guest when physical PMI belongs to guest counter. If the
>>>>>>    same mechanism is used in passthrough vPMU and PMI skid exists
>>>>>>    which cause physical PMI belonging to guest happens after VM-exit,
>>>>>>    then the host PMI handler couldn't identify this PMI belongs to
>>>>>>    host or guest.
>>>>>>    So this RFC uses a dedicated kvm_pmi_vector, PMI belonging to guest
>>>>>>    has this vector only. The PMI belonging to host still has an NMI
>>>>>>    vector.
>>>>>>
>>>>>>    Without considering PMI skid especially for AMD, the host NMI vector
>>>>>>    could be used for guest PMI also, this method is simpler and doesn't
>>>>>
>>>>> I don't see how multiplexing NMIs between guest and host is simpler.  At best,
>>>>> the complexity is a wash, just in different locations, and I highly doubt it's
>>>>> a wash.  AFAIK, there is no way to precisely know that an NMI came in via the
>>>>> LVTPC.
>>>> when kvm_intel.pt_mode=PT_MODE_HOST_GUEST, guest PT's PMI is a multiplexing
>>>> NMI between guest and host, we could extend guest PT's PMI framework to
>>>> mediated PMU. so I think this is simpler.
>>>
>>> Heh, what do you mean by "this"?  Using a dedicated IRQ vector, or extending the
>>> PT framework of multiplexing NMI?
>> here "this" means "extending the PT framework of multiplexing NMI".
> 
> The PT framework's multiplexing is just as crude as regular PMIs though.  Perf
> basically just asks KVM: is this yours?  And KVM simply checks that the callback
> occurred while KVM_HANDLING_NMI is set.
> 
> E.g. prior to commit 11df586d774f ("KVM: VMX: Handle NMI VM-Exits in noinstr region"),
> nothing would prevent perf from miscontruing a host PMI as a guest PMI, because
> KVM re-enabled host PT prior to servicing guest NMIs, i.e. host PT would be active
> while KVM_HANDLING_NMI is set.
> 
> And conversely, if a guest PMI skids past VM-Exit, as things currently stand, the
> NMI will always be treated as host PMI, because KVM will not be in KVM_HANDLING_NMI.
> KVM's emulated PMI can (and should) eliminate false positives for host PMIs by
> precisely checking exclude_guest, but that doesn't help with false negatives for
> guest PMIs, nor does it help with NMIs that aren't perf related, i.e. didn't come
> from the LVTPC> 
> Is a naive implementation simpler?  Maybe.  But IMO, multiplexing NMI and getting
> all the edge cases right is more complex than using a dedicated vector for guest
> PMIs, as the latter provides a "hard" boundary and allows the kernel to _know_ that
> an interrupt is for a guest PMI.
>Totally agree the complex to fix multiplexing NMI corner case. Thanks for explanation.

