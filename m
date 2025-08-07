Return-Path: <kvm+bounces-54212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 104C1B1D0E4
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 04:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAE4E560BE3
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 02:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35911C6FF6;
	Thu,  7 Aug 2025 02:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EkP/4WJ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4FD9461;
	Thu,  7 Aug 2025 02:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754533451; cv=none; b=Mx+uI0abUnv7YfeKj/hUfB2de6cQOi1fGYfUbgjJVBZsKLgmn2mU7fd0t1DeZt9I/qN4sveESXgFGNMBDZo/paFSXXSCi+CkZ/YhAY2Ycwc6c4BST5bjNL1XHCo9NF1mA+SSECrPz4IAnBwJAEo09fr75PKJs1o6APYHLBHkfug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754533451; c=relaxed/simple;
	bh=VUVNzu31LJWKIeyqAa2HIaHX9Nc3eAxgg8BRTJDmoBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BwYfRk47QJDF+viwdCvXRpUs331DvI9mQq89rtHfDIhaFDyrRHeKkhLT3qJv8IFgTTv1s0RB7RhOp/F/f0tTIsUvxsN1jXsZyp5h2fE6B1DkaMEjUbSOFg6TSr1QqqQSvdgbtOplEd/6A61TxKIlI5jNWEi/vUb42qqjHCHAnLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EkP/4WJ4; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754533450; x=1786069450;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VUVNzu31LJWKIeyqAa2HIaHX9Nc3eAxgg8BRTJDmoBM=;
  b=EkP/4WJ42sTaiKFakKoDKGbCnCsop4XYIMferrey53/E8Ab/n3DR5oj1
   avYhP6psa3uEGuT945Uppq9nuXhjQHo65gpSZemPm80paJEwONkpTJo7G
   n4vI8so4gPT043oUaLCSCk518NeewShcEdyDh/ZWpFDdKKQ9rk55qqox5
   fuAEjExBCKiPZ+6Vd8dnRNeIGnN/rimumoWedmh5UITwznCtt5fcrIFcI
   29GhF1mfG6dGYlwBnPzm3Zsu4yHr8+b0ItjvWGmsJ+h+l76KAOXYBHASH
   h6PYk+7EJmWPZGTudHEwqSwn/8SOMx54wY185An3tszKoimPugrS7aSTU
   Q==;
X-CSE-ConnectionGUID: SKwwAw7jTEa5kqVqs++mrQ==
X-CSE-MsgGUID: G7hj7W9NQXaA61HvodL9tQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67939642"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="67939642"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 19:24:09 -0700
X-CSE-ConnectionGUID: 7jlSB0LZRUSzrY+yR46A0A==
X-CSE-MsgGUID: RruIQFfpS4OkGH5s5K8Wtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="164936763"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 19:24:08 -0700
Message-ID: <515a5221-dbcd-45cc-bc55-887ae70b63db@linux.intel.com>
Date: Thu, 7 Aug 2025 10:24:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/18] KVM: x86: Push acquisition of SRCU in fastpath into
 kvm_pmu_trigger_event()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>,
 Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-18-seanjc@google.com>
 <e64951b0-4707-42ed-abf4-947def74ea34@linux.intel.com>
 <aJOR4Bk3DwKSVdQV@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aJOR4Bk3DwKSVdQV@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/7/2025 1:33 AM, Sean Christopherson wrote:
> On Wed, Aug 06, 2025, Dapeng Mi wrote:
>> On 8/6/2025 3:05 AM, Sean Christopherson wrote:
>>> Acquire SRCU in the VM-Exit fastpath if and only if KVM needs to check the
>>> PMU event filter, to further trim the amount of code that is executed with
>>> SRCU protection in the fastpath.  Counter-intuitively, holding SRCU can do
>>> more harm than good due to masking potential bugs, and introducing a new
>>> SRCU-protected asset to code reachable via kvm_skip_emulated_instruction()
>>> would be quite notable, i.e. definitely worth auditing.
>>>
>>> E.g. the primary user of kvm->srcu is KVM's memslots, accessing memslots
>>> all but guarantees guest memory may be accessed, accessing guest memory
>>> can fault, and page faults might sleep, which isn't allowed while IRQs are
>>> disabled.  Not acquiring SRCU means the (hypothetical) illegal sleep would
>>> be flagged when running with PROVE_RCU=y, even if DEBUG_ATOMIC_SLEEP=n.
>>>
>>> Note, performance is NOT a motivating factor, as SRCU lock/unlock only
>>> adds ~15 cycles of latency to fastpath VM-Exits.  I.e. overhead isn't a
>>> concern _if_ SRCU protection needs to be extended beyond PMU events, e.g.
>>> to honor userspace MSR filters.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
> ...
>
>>> @@ -968,12 +968,14 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>>>  			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
>>>  		return;
>>>  
>>> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
>> It looks the asset what "kvm->srcu" protects here is
>> kvm->arch.pmu_event_filter which is only read by pmc_is_event_allowed().
>> Besides here, pmc_is_event_allowed() is called by reprogram_counter() but
>> without srcu_read_lock()/srcu_read_unlock() protection.
> No, reprogram_counter() is only called called in the context of KVM_RUN, i.e. with
> the vCPU loaded and thus with kvm->srcu already head for read (acquired by
> kvm_arch_vcpu_ioctl_run()).

Not sure if I understand correctly, but KVM_SET_PMU_EVENT_FILTER ioctl is a
VM-level ioctl and it can be set when vCPUs are running. So assume
KVM_SET_PMU_EVENT_FILTER ioctl is called at vCPU0 and vCPU1 is running
reprogram_counter(). Is it safe without srcu_read_lock()/srcu_read_unlock()
protection?


>  
>> So should we shrink the protection range further and move the
>> srcu_read_lock()/srcu_read_unlock() pair into pmc_is_event_allowed()
>> helper? The side effect is it would bring some extra overhead since
>> srcu_read_lock()/srcu_read_unlock() could be called multiple times.
> No, I don't think it's worth getting that precise.  As you note, there will be
> extra overhead, and it could actually become non-trivial amount of overhead,
> albeit in a somewhat pathological scenario.  And cpl_is_matched() is easy to
> audit, i.e. is very low risk with respect to having "bad" behavior that's hidden
> by virtue of holding SRCU.
>
> E.g. if the guest is using all general purpose PMCs to count instructions
> retired, then KVM would acquire/release SRCU 8+ times.  On Intel, the fastpath
> can run in <800 cycles.  Adding 8 * 2 full memory barriers (difficult to measure,
> but somewhere in the neighborhood of ~10 cycles per barrier) would increase the
> latency by 10-20%.
>
> Again, that's an extreme scenario, but since there's almost nothing to gain from
> pushing SRCU acquisition into the filter checks, I don't see any reason to go
> with an approach that we *know* is sub-optimal.

Yeah, indeed. If there is no need to
add srcu_read_lock()/srcu_read_unlock() protection in reprogram_counter(),
I'm good with this. Thanks.


>
>> An alternative could be to add srcu_read_lock()/srcu_read_unlock() around
>> pmc_is_event_allowed() in reprogram_counter() helper as well.
> As above, there's no need to modify reprogram_counter().  I don't see any future
> where reprogram_counter() would be safe to call in the fastpath, there's simply
> too much going on, i.e. I think reprogram_counter() will always be a non-issue.

