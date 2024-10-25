Return-Path: <kvm+bounces-29685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4CC89AF7BA
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 04:55:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 889A5B2223B
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 02:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3901618A93F;
	Fri, 25 Oct 2024 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BsaoVDJU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540043D97A;
	Fri, 25 Oct 2024 02:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729824924; cv=none; b=qfjO1UUV5qpAuKQtgfhtN+8AtceAGU57Jgs2Q6EnoYkWkjiHL8FHNydAgaKWH7ulNhJIAoyKbFmh+VSTG3rMpqR2SKdNsw7ygCXrLGH+dxBWJnnLWqUUHyxjBUs9KlVkjiTVR836yIgHyfEi5/on+qNwHRKGhPmS93yDZBR+HDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729824924; c=relaxed/simple;
	bh=ZVTrbUnLp8cvUUYzJaO7obUrGlncOA7TraEHwEycEJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HD2Q5eOY/3EwooX9iPDYFVczpmEEVuDjmE3hg36Dxr7W1zceoVg50rLB5UH9JzkvsrdkgC4blt5lToAYb3vKi5s+gkvcJQaON/HZtAJwPXUlHU71GGdVKYsXXnbRM6YRr0Wor+aNSIYJBdjUWGovjvcYEaDlpy5bajYKNnOxUOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BsaoVDJU; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729824922; x=1761360922;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZVTrbUnLp8cvUUYzJaO7obUrGlncOA7TraEHwEycEJo=;
  b=BsaoVDJUlpkQAysDz44n+JGCsJzD0ZwMKko0M8jDMhsl0rK08oq5MheY
   5gvgMPWtjLo/fQyX+Io3At6QCOxuCubS3ZjJ3T10MFRLd9iP2IaVPiL1k
   O1hSNByOigWWIRa6BcBAnSL5pWqWndPTDbS9jUv52Xt0FpcLt3GsqbPQA
   ltKBraSZz87Zs31E8i2L7do8uGHfHfioyrmRhmOBnGNB6afzOhxHMQzzi
   /cb0PDjfOy9+ubf+A/B5AhkqHlSM0+RLOAu5559pudhmlE8lkUSqP3rcq
   hfgpQk3PUeAYYUqcJHAjUygSrD89bievdujiTl1tZssWmtDFrE7ExHNJ0
   g==;
X-CSE-ConnectionGUID: 9wveYtqIQdC39GBG9xxrDA==
X-CSE-MsgGUID: T38S9L4oRNSgjPtuTxdkmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="17113816"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="17113816"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:55:21 -0700
X-CSE-ConnectionGUID: 25XcgmakTYeR8SuEy/3Ukw==
X-CSE-MsgGUID: JHsRSBJQSsKtbdfFEymPjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="81618759"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.240.3]) ([10.125.240.3])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:55:16 -0700
Message-ID: <ce1cc916-7aff-499e-a5ae-6677aaada9b5@linux.intel.com>
Date: Fri, 25 Oct 2024 10:55:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 41/58] KVM: x86/pmu: Add support for PMU context
 switch at VM-exit/enter
To: "Chen, Zide" <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-42-mizhang@google.com>
 <748e89d0-b27f-49d0-9dba-d4f65503dcf0@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <748e89d0-b27f-49d0-9dba-d4f65503dcf0@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 10/25/2024 3:57 AM, Chen, Zide wrote:
>
> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>
>> Add correct PMU context switch at VM_entry/exit boundary.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/x86.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index dd6d2c334d90..70274c0da017 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11050,6 +11050,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>  		set_debugreg(0, 7);
>>  	}
>>  
>> +	if (is_passthrough_pmu_enabled(vcpu))
>> +		kvm_pmu_restore_pmu_context(vcpu);
> Suggest to move is_passthrough_pmu_enabled() into the PMU restore API to
> keep x86.c clean. It's up to PMU to decide in what scenarios it needs to
> do context switch.

Agree.


>
>> +
>>  	guest_timing_enter_irqoff();
>>  
>>  	for (;;) {
>> @@ -11078,6 +11081,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>  		++vcpu->stat.exits;
>>  	}
>>  
>> +	if (is_passthrough_pmu_enabled(vcpu))
>> +		kvm_pmu_save_pmu_context(vcpu);
> ditto.
>
>>  	/*
>>  	 * Do this here before restoring debug registers on the host.  And
>>  	 * since we do this before handling the vmexit, a DR access vmexit

