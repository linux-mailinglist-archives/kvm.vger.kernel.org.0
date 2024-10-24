Return-Path: <kvm+bounces-29654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B265F9AEA93
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 17:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EA6BB22EEF
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025DF1EF946;
	Thu, 24 Oct 2024 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N+d2AuwH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294891E8833;
	Thu, 24 Oct 2024 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784052; cv=none; b=FMM0HHW7zG6lCBLXuBvpZuemJX9d8LaP8QHQ6W96l42MDeN5sxnnjdA/9134kkNlG5CXxopXKNV2uagS///HUbhrwZpa/lot5k+ne2ZiPJsviZGOFuMOWJ7deI/iBHojnenPutGyj6gkEEAIsYUgeAgeVInRpUkF0Y+TrLGo9d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784052; c=relaxed/simple;
	bh=V0mys8VKe+wh2bASr2FBVzaXHPp9Hknt6GUorObUwnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qCxWuiCypO27ICHzM0B7Zu8m+6/oem9peyWGncIbhXxG9qFIByE5pUlHORWH6Mdcr0o1gkKrXrvg3wNpI0/shPh/c1lhrcW1dTA8XFkXf7xE9QM+GPROKMFcO6TBwflq8w1hfo4HGZo+YC9XCj4P0ATYnn1yTOZCr6H+yZkAxuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N+d2AuwH; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729784050; x=1761320050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V0mys8VKe+wh2bASr2FBVzaXHPp9Hknt6GUorObUwnI=;
  b=N+d2AuwH1p7Lzq54EXDPntlCO9mEm+kgyJT4ValNcFbpTwRtGKlMAUEz
   A2WvA4b2gvnWrYC7Z5FTDsCbmsidq54JRk/Vjq46g4tjQhUQD1NwEWjon
   n2gviIJH9n7NO6elhAv9cb0b66jFgVFKhA+m0npIbtgKliMVb0ZVu6qq5
   SajWAlg5SlghstfyBUGiDQFb9kmxMSorMpjlzqLUGIAssQa0IsKTbtSAL
   oRhQEVSeKWK7rMZIkcUsRYlKwzlnRXRpvqgncC0uX7+i4tn+kfl/4gvND
   aPZEpdrjJ0d0UmmO8uDygh8jNL17bsw8bmy2N+2gmmpqPTk509QIh3+ED
   g==;
X-CSE-ConnectionGUID: lsf9YFQ9SOynJH7wBr3EOg==
X-CSE-MsgGUID: 6tE7FM9nRbChir1z4DJ92g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29583192"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29583192"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 08:34:09 -0700
X-CSE-ConnectionGUID: gW42Oo/YQu2zuGBgdWh9Hw==
X-CSE-MsgGUID: snwWtF/4TK+EHgsFint1IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,229,1725346800"; 
   d="scan'208";a="81059031"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 08:34:06 -0700
Message-ID: <b2cdf533-08f0-487b-998f-0d436be923f5@intel.com>
Date: Thu, 24 Oct 2024 23:34:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
To: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-6-nikunj@amd.com>
 <aff9bf82-e11e-43d9-8661-aefa328242ad@intel.com>
 <de0b0551-003d-0cc8-9015-9124c25f5d43@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <de0b0551-003d-0cc8-9015-9124c25f5d43@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2024 4:44 PM, Nikunj A. Dadhania wrote:
> 
> 
> On 10/24/2024 1:26 PM, Xiaoyao Li wrote:
>> On 10/21/2024 1:51 PM, Nikunj A Dadhania wrote:
>>> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
>>> enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
>>> are being intercepted. If this should occur and Secure TSC is enabled,
>>> terminate guest execution.
>>
>> There is another option to ignore the interception and just return back to
>> guest execution.
> 
> That is not correct, RDTSC/RDTSCP should return the timestamp counter value
> computed using the GUEST_TSC_SCALE and GUEST_TSC_OFFSET part of VMSA.

Ah, I missed this. Yes, if ignore the interception, guest needs to do 
TSC scale itself with GUEST_TSC_SCALE and GUEST_TSC_OFFSET to get the 
correct TSC. It's complicating things while making not intercepting 
RDTSC/RDTSP a hard requirement is much simple.

I think it's worth adding it as the justification.

>> I think it better to add some justification on why make it> fatal and terminate the guest is better than ignoring the interception.
> 
> How about the below updated commit message:
> 
> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
> enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
> are being intercepted. If this should occur and Secure TSC is enabled,
> terminate guest execution as the guest cannot rely on the TSC value provided
> by the hypervisor.
> 
> Regards
> Nikunj
> 


