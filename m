Return-Path: <kvm+bounces-38417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50ED7A3974D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6985616E603
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4822F2309AE;
	Tue, 18 Feb 2025 09:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7sW8IUA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21391B4F14;
	Tue, 18 Feb 2025 09:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739871762; cv=none; b=ZHjBYEtfq3aq5GzPCCQG3khoEKToKjjflyTX7ToGqan69+9Khmp7AVtelzf1pO6XL6RBh9C5JDRIieBLppdbSEHnzJdqeRchYwpQ+Iw2wjZQGgGPjYpMZQUfSUtmZ9aFqv9mBoRqo9sO377AJMFE76qyG/p/KbH6+B+Gf/4Oswc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739871762; c=relaxed/simple;
	bh=kh9HSldrYRQDeC+y+arH/ENuq/Loxm22L6EMweKu2as=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XWdrwx1eWYbkfFd2kPVK3h16Bd632fHJAb8e+v07R9wXEmibXP0vYmSXI59mEit68iZ9XicNYO2SGscs4DY0PpFcZ2HrOv/5ZCmESw/fnh7zIRECk9mzQNkQGnFcQD0W5Nq3Yu7LNg3EjtbhbbWoETJbAL4mJD1eZ74ss5Ixq/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7sW8IUA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739871761; x=1771407761;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kh9HSldrYRQDeC+y+arH/ENuq/Loxm22L6EMweKu2as=;
  b=B7sW8IUAIbQkNmRgrzOWkmBA3ZLEZDeG3AzCCddYRsfY3/zaOHVRqNgM
   oaC5g/16pFVoQRh7w/Igw7EgC5vXeRLRoErChBoBkPj1VtRPJdnUs0f4o
   ZlF71i/FZbv0F+aaC3IccpdPVNyRg2pHB83mXMwFixAhrK63nHUREOZc7
   hQyz7xnedJyH5f1rONvxqTL40qMZwtO1uRiry/p4MOC59u7DFfyaXTPSk
   pLm5OlBtcdk14VLg7P7gmDXepWa8eouzX/fI2HFNQYMoVMNM9nsm9crcv
   b70U05YLacVHaI23cuSx/LtFhVKL0Db3KwfD7CB/jBWzGuJUeGn4dTb0P
   w==;
X-CSE-ConnectionGUID: oZU5VPO/Tze7eIBUF/Sq1Q==
X-CSE-MsgGUID: iRLqyuHVQ7SJw5f2K8dtqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="44208178"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="44208178"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:42:40 -0800
X-CSE-ConnectionGUID: 9EMsImeyQ/mS8RMYB2i/Kw==
X-CSE-MsgGUID: cqDhriQWRxmagqfRyt7rXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="114087064"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:42:37 -0800
Message-ID: <420765a3-2187-42b4-a980-eabd0a44e0e0@linux.intel.com>
Date: Tue, 18 Feb 2025 17:42:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v6 17/18] x86: pmu: Adjust lower boundary
 of branch-misses event
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-18-dapeng1.mi@linux.intel.com>
 <Z6-w_ZG1LmTYDJd1@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z6-w_ZG1LmTYDJd1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2/15/2025 5:09 AM, Sean Christopherson wrote:
> On Sat, Sep 14, 2024, Dapeng Mi wrote:
>> @@ -205,6 +208,17 @@ static void adjust_events_range(struct pmu_event *gp_events,
>>  		gp_events[branch_idx].min = LOOP_BRANCHES;
>>  		gp_events[branch_idx].max = LOOP_BRANCHES;
>>  	}
>> +
>> +	/*
>> +	 * For CPUs without IBPB support, no way to force to trigger a
>> +	 * branch miss and the measured branch misses is possible to be
>> +	 * 0. Thus overwrite the lower boundary of branch misses event
>> +	 * to 0 to avoid false positive.
>> +	 */
>> +	if (!has_ibpb()) {
>> +		/* branch misses event */
> This comment is worse than useless, because it necessitates curly braces.

Ah. Yes.


>
>> +		gp_events[branch_miss_idx].min = 0;
>> +	}
>>  }

