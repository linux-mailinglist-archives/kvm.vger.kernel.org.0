Return-Path: <kvm+bounces-38414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB865A39747
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731F13A4842
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BAB22FF2B;
	Tue, 18 Feb 2025 09:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GdRu56Rx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EAC22AE42;
	Tue, 18 Feb 2025 09:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739871386; cv=none; b=Zsqa9jj40uyc4SUnYiZJYwL+Nsc5HAz3nf8ShY7VbjElfQIRCUpwYmafbDhl5IPaBU22EE8G/fNABFXgtA56PxAvXwc+oC4M6+EwlpiJhQW9sbxWLiXRr5/vY/Pf/nNwtgcFIaUtvduyZIfhJ4IJFRweA0Rmg9Z70Q+LsEmwOEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739871386; c=relaxed/simple;
	bh=6wjiP+Lq8n4ALuJUpnvy+4rVMNT7sLHwAY6F3JkTrmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S2Ewbb/z53QNoZqKrptu6fXy11AfsPE8Za7hHiriLSWEyTA8sYog8T4d2evlAwXrUXfyQmOVyngm0QwVvDm4EFsbgh+5Si+L3Jf2V0S27d0We36gOuvjui/pZibcG7X4O4zNzkhoIF464vyhslJA/GSXbrkUw5TbjQNJ5hVdpgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GdRu56Rx; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739871385; x=1771407385;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6wjiP+Lq8n4ALuJUpnvy+4rVMNT7sLHwAY6F3JkTrmE=;
  b=GdRu56RxwKFyjl/Z8TVJIgO1xGKyQdCfpAuixWCk0WLQcBzWjCGvTlRX
   KAjvPTxy72LMtqGmCeGV0CjFln2s7+G6jekfIRHIT8Q1BsxfXj0BTLo0e
   PVRWesP9XElHKVNN7PcCW6Mmd+d7zOFaP/JNC+TqwF7h54cWWZVEkweuv
   40GtpYXFRiQiZT1lx25Rjg7nzusslvhYU/1pEg7U1E35BQveswTPimwRY
   a+7xM8ItP0rKBRWwc5yIXRgmF1PJ6QEw77CN8FX9Dd/7DvcePSrdva9f9
   uhVZj+K7qWPmwxPgM5XQxBeRszpiSTLsWaEoNHtppBhjMD7/lbRzA5BR9
   Q==;
X-CSE-ConnectionGUID: 5yT8YMmzRc2hRucI/lTojA==
X-CSE-MsgGUID: FyffBQ98QdiY4JK5zsafJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40263533"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="40263533"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:36:24 -0800
X-CSE-ConnectionGUID: JBCiSzFDQKOFYs3bgRXvgg==
X-CSE-MsgGUID: 3KWPQKkDTuqmdJsy9IpzJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119558090"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:36:21 -0800
Message-ID: <add089ff-49d9-40a9-a020-5f4eb876aef8@linux.intel.com>
Date: Tue, 18 Feb 2025 17:36:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v6 08/18] x86: pmu: Fix cycles event
 validation failure
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-9-dapeng1.mi@linux.intel.com>
 <Z6-wrVaVSiI9ZKkD@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z6-wrVaVSiI9ZKkD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2/15/2025 5:07 AM, Sean Christopherson wrote:
> On Sat, Sep 14, 2024, Dapeng Mi wrote:
>> +static void warm_up(void)
>> +{
>> +	int i = 8;
>> +
>> +	/*
>> +	 * Since cycles event is always run as the first event, there would be
>> +	 * a warm-up state to warm up the cache, it leads to the measured cycles
>> +	 * value may exceed the pre-defined cycles upper boundary and cause
>> +	 * false positive. To avoid this, introduce an warm-up state before
>> +	 * the real verification.
>> +	 */
>> +	while (i--)
>> +		loop();
> Use a for-loop.

Sure.


>
>> +}
>> +
>>  static void check_counters(void)
>>  {
>>  	if (is_fep_available())
>>  		check_emulated_instr();
>>  
>> +	warm_up();
>>  	check_gp_counters();
>>  	check_fixed_counters();
>>  	check_rdpmc();
>> -- 
>> 2.40.1
>>

