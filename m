Return-Path: <kvm+bounces-48936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B162AD4787
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC94A3A88F7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E922D7BF;
	Wed, 11 Jun 2025 00:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cK5FL11X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4D32D5400;
	Wed, 11 Jun 2025 00:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749602471; cv=none; b=uZhXpUblRVpjdEcRoNvOVew1e6q5H9a+D8NTQCjyfwdXC0/eC4GfAbbC8CLWT0RqNmFeN7uaDftG0+S7mV2OHaLt1GU/YqwAqCaZ5a/dNpcl8g1xFTvoQvZO5lTDfdJYfBg7D+GB2P19w6JS+X1zNxFjkAjdz98dQvZr72qYaQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749602471; c=relaxed/simple;
	bh=wv69m7y3xJ8R+WjJkkxUqUFXthhnGnUkVzQhoJmrwhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nseg6npIFTQpOi3xSnq2XT8fOeqgmmyCqhrPJ1aCDypuHrsYnKertQsz3DZ9fh9dOKoNAoXHIPJo1jbLYCdfggrP8+LxAUCxIwf59jaMp2SHdAYOfLg8SfMWDKiJe0g/ZN+usINQHIO4JLuvRz9Gq8L9guSRmaaLMiGhOdH8sL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cK5FL11X; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749602470; x=1781138470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wv69m7y3xJ8R+WjJkkxUqUFXthhnGnUkVzQhoJmrwhQ=;
  b=cK5FL11XM5olRLCDO0WINS95j2X9m0sT6annQP3+PH3zJah85XcVMhwE
   NVrYCirAGfLR6MS3DcAnzJ6Eyiky6KPPuKat+cCd4ZneNcvO0qatg6Ya8
   xPz8QY1qlg2WlXwU4Cg4ao3BzOlQNkxki46naTyk0uW3TKfJPCe765LAg
   xlLsJeTw5TPHPwqP+/rRzpbuSUHlwf5Z8rLBjpuhAFz28lQvC8YIdjCvG
   bLCWIqK2s3jtkqm01ZiNltn1irT5o/fR48A5revOZiDIxGKJ5RvksNKdG
   aMZfr4u0WoAVodbIUEzcRNGE73stbemlLtjnBJsucf2+bRP9M3icYPmLE
   w==;
X-CSE-ConnectionGUID: aOeSHgh8R9+rwMIgQ1IGeQ==
X-CSE-MsgGUID: tjAcDx9nQOK4KiKEhM0EOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="50957705"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="50957705"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 17:41:09 -0700
X-CSE-ConnectionGUID: +3sEoNirRQWj7lm2LYpISg==
X-CSE-MsgGUID: IkS75glYQImOsEKmFYhVBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="184176087"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 17:41:06 -0700
Message-ID: <e6d1f2de-125e-4741-8f50-eebd42c3474c@linux.intel.com>
Date: Wed, 11 Jun 2025 08:41:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 07/16] x86/pmu: Rename
 pmu_gp_counter_is_available() to pmu_arch_event_is_available()
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, =?UTF-8?Q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-8-seanjc@google.com>
 <ffb5e853-dedc-45bb-acd8-c58ff2fc0b71@linux.intel.com>
 <aEhaQITromUV7lIO@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aEhaQITromUV7lIO@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 12:16 AM, Sean Christopherson wrote:
> On Tue, Jun 10, 2025, Dapeng Mi wrote:
>> On 5/30/2025 6:19 AM, Sean Christopherson wrote:
>>> @@ -51,7 +51,7 @@ void pmu_init(void)
>>>  		}
>>>  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
>>>  		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
>>> -		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
>>> +		pmu.arch_event_available = (1u << pmu.nr_gp_counters) - 1;
>> "available architectural events" and "available GP counters" are two
>> different things. I know this would be changed in later patch 09/16, but
>> it's really confusing. Could we merge the later patch 09/16 into this patch?
> Ya.  I was trying to not mix too many things in one patch, but looking at this
> again, I 100% agree that squashing 7-9 into one patch is better overall.
>
>>> @@ -463,7 +463,7 @@ static void check_counters_many(void)
>>>  	int i, n;
>>>  
>>>  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
>>> -		if (!pmu_gp_counter_is_available(i))
>>> +		if (!pmu_arch_event_is_available(i))
>>>  			continue;
>> The intent of check_counters_many() is to verify all available GP and fixed
>> counters can count correctly at the same time. So we should select another
>> available event to verify the counter instead of skipping the counter if an
>> event is not available.
> Agreed, but I'm going to defer that for now, this series already wanders in too
> many directions.  Definitely feel free to post a patch.

Sure. Thanks.



