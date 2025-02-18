Return-Path: <kvm+bounces-38415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC5F2A39755
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25FC3AF09C
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DF723026F;
	Tue, 18 Feb 2025 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cAh2WFFW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484B51FF7C0;
	Tue, 18 Feb 2025 09:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739871634; cv=none; b=BLDlYfwqsf5z7Ae1VO1e9kjudAa2mGdQLSGWGW0IXpKQlOrr8cFAJyDDsTQ0ylLdoTo29Iec0bMwaW5bMo56k1JWqfaDJpopkXonEbtu1OhoKR7jjIpyZnrt2AH3hd6ELw6nS6KQnToT9HDyN9Bcas7IYSZ2slcEM8YV/RS1Qlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739871634; c=relaxed/simple;
	bh=JRizWw/67RFEnnSawRTkKLMyCqufLp0sg0lD6VJe3H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lywc4fMgR+osm4dNC2L2FXBaMqsyQYO3orS35yWQ1QmvvEunR8vInXeEy18QAtbpugQAmdOrM/sW3xxKchWuMRNExceUf4UDl/HPxWGaooxNPkxTCBXwDu0oSRNr26ggprQaQCZTjp9yjsuUlqsII1w2uuPW1HjxW7aaj06x2OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cAh2WFFW; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739871633; x=1771407633;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JRizWw/67RFEnnSawRTkKLMyCqufLp0sg0lD6VJe3H0=;
  b=cAh2WFFWmM+9ZnD4nsvF8BdNQlsu4scvS93XHRww6tFqYChHqtbJTxzt
   cvoymcGxNo47DvyeM7DB+lSNrGHSgN0Us3KEqpupAAShfURdIa5aPfNKS
   ckDKDk15R1ApkdVi5LzqRpFjGFF9ggez/Uv3WX9OnSvwYKFHWzyH3K5Cq
   X9IIxUTQvIqvuXWn4Bhx/bsngkW2M55kj42n77gGP/5a+7SZX+Ry+yhNG
   DZauj6Xl81pyKD5JZD8zspvYzKHO9OmDcNKjqKuKdT9hVUVdBhWxRUQbn
   SYsDAMX/6qE5WOVaN1uZXwPT03wFLblTrO7BztYmiUc8ttjtMc6yzs5YR
   Q==;
X-CSE-ConnectionGUID: b4sVi5whSlKf0Sh1O7XP7g==
X-CSE-MsgGUID: mR64zr70TOWT8wKg7vuzRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="44208040"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="44208040"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:40:26 -0800
X-CSE-ConnectionGUID: vWlnPHsNRDG13+G1uIzvTQ==
X-CSE-MsgGUID: O4dClfVVQgiBDiShbJ7mIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="114086635"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:40:24 -0800
Message-ID: <5381f994-54db-458c-b32f-aa0dfb696d3a@linux.intel.com>
Date: Tue, 18 Feb 2025 17:40:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v6 13/18] x86: pmu: Improve instruction and
 branches events verification
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-14-dapeng1.mi@linux.intel.com>
 <Z6-w24T1iH2S_Fux@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z6-w24T1iH2S_Fux@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2/15/2025 5:08 AM, Sean Christopherson wrote:
> On Sat, Sep 14, 2024, Dapeng Mi wrote:
>> If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
>> __precise_count_loop(). Thus, instructions and branches events can be
>> verified against a precise count instead of a rough range.
>>
>> BTW, some intermittent failures on AMD processors using PerfMonV2 is
>> seen due to variance in counts. This probably has to do with the way
>> instructions leading to a VM-Entry or VM-Exit are accounted when
>> counting retired instructions and branches.
> AMD counts VMRUN as a branch in guest context.

Good to know. Thanks.


>
>> +	 * We see some intermittent failures on AMD processors using PerfMonV2
>> +	 * due to variance in counts. This probably has to do with the way
>> +	 * instructions leading to a VM-Entry or VM-Exit are accounted when
>> +	 * counting retired instructions and branches. Thus only enable the
>> +	 * precise validation for Intel processors.
>> +	 */
>> +	if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
>> +		/* instructions event */
> These comments are useless.

Sure.


>
>> +		gp_events[instruction_idx].min = LOOP_INSTRNS;
>> +		gp_events[instruction_idx].max = LOOP_INSTRNS;
>> +		/* branches event */
>> +		gp_events[branch_idx].min = LOOP_BRANCHES;
>> +		gp_events[branch_idx].max = LOOP_BRANCHES;
>> +	}
>> +}

