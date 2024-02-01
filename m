Return-Path: <kvm+bounces-7647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0486844EDF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F56D1F23256
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED0DE1079B;
	Thu,  1 Feb 2024 01:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="To7JlSp2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D76BEAE3;
	Thu,  1 Feb 2024 01:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706752308; cv=none; b=iJTmQ5MIkD95SK4l2lqgclsLg8GY5hP/yaUXBsfHz46IgMduUi831L3s0LxDwruQSSy7uTmwy7yQQt6kpjrLud57hW5kI3yfRHKGeZcVMwdOBB5ZC5OE1yFP1fdWu/E4qQmiCPYYD24Lj8NIM0fsvkwqw9hvZzNFuWprs4zb14I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706752308; c=relaxed/simple;
	bh=uZifwHdGnq05hwLYvjFee+ZPbSja/gXSEwnvnH97HpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i2mbK7Ug3sbotFKt7Nu+IhYGBn8WVDEeOIIu+pkFRA+0VuYYSowDb5gE+dddwUutuedPl6qGvQv9Nr5ABevp3xvWkbpj3eKeRhsZ51UoYbwjpxcj/Johi0kMKUgD+LGfFADEV0HYMWEpEOzuUB79oJIKu+FENg4jOw0gDfd7UZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=To7JlSp2; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706752307; x=1738288307;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uZifwHdGnq05hwLYvjFee+ZPbSja/gXSEwnvnH97HpA=;
  b=To7JlSp2Yl8PJw2sLNPDlo2Hv3yI/NgDNLIxKSSIPcpa0dMogOV22wWz
   rzoUeCcZRrO5Wd07hfJJAZTYIc7nML4Zf8pNi1FIGAJLM1hDjyDCk7sCd
   nWLWICxu5+7cED0MDg0uRKZJHG9Qork1EzEdUL1mhKz1kwmv4Bs2/t8ad
   o2A+JadUiS8paF1C7sqJ8iG40FUAqNbIxs+CovFKHDc9/II/jUNwjeOzT
   ZJfx0mQDJQLeH26BLn430tPcB7ihqgBBu7gw4v73X2cvuN3x0/q38BUBA
   lsGD5Z6U9V9FoBq0yCu3MDxJccGnLlzWBZd08SLe6JnwUzOILBjW/d76o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3643680"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="3643680"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:51:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="961777969"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="961777969"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.12.33]) ([10.93.12.33])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:51:43 -0800
Message-ID: <50507559-ffb6-4340-a3ac-c0fdba3c9ab8@linux.intel.com>
Date: Thu, 1 Feb 2024 09:51:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/29] KVM: selftests: Test Intel PMU architectural
 events on gp counters
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
 Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>,
 Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
References: <20240109230250.424295-1-seanjc@google.com>
 <20240109230250.424295-17-seanjc@google.com>
 <5f51fda5-bc07-42ac-a723-d09d90136961@linux.intel.com>
 <ZaGxNsrf_pUHkFiY@google.com>
 <cce0483f-539b-4be3-838d-af0ec91db8f0@linux.intel.com>
 <ZbmF9eM84cQhdvGf@google.com>
 <d24dc389-8e73-4a7a-9970-1022dcbfa39c@linux.intel.com>
 <Zbpn284rPe3pMBwI@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zbpn284rPe3pMBwI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/31/2024 11:31 PM, Sean Christopherson wrote:
> On Wed, Jan 31, 2024, Dapeng Mi wrote:
>> BTW, I have a patch series to do the bug fixes and improvements for
>> kvm-unit-tests/pmu test. (some improvement ideas come from this patchset.)
>>
>> https://lore.kernel.org/kvm/20240103031409.2504051-1-dapeng1.mi@linux.intel.com/
>>
>> Could you please kindly review them? Thanks.
> Unfortunately, that's probably not going to happen anytime soon.  I am overloaded
> with KVM/kernel reviews as it is, so I don't expect to have cycles for KUT reviews
> in the near future.
>
> And for PMU tests in particular, I really want to get selftests to the point where
> the PMU selftests are a superset of the PMU KUT tests so that we can drop the KUT
> versions.  In short, reviewing PMU KUT changes is very far down my todo list.

Yeah, It's good and convenient that we can have one-stop test suite to 
verify the PMU functions, so we don't need to verify the PMU functions 
each time with KUT/PMU test and selftest/pmu test independently.

While it looks KUT/PMU test is still broadly used to verify KVM PMU 
features by many users, and the patchset mainly fixes several KUT/PMU 
bugs which would cause false alarms. If these bugs are not fixed, they 
would mislead the users.

Yeah, patch reviewing takes much time and effort, thanks a lot for you 
reviewing our patches in the past, and hope you can review this patchset 
when you are free.


