Return-Path: <kvm+bounces-14393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9208C8A2797
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA2CA1C2137B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 07:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F765102E;
	Fri, 12 Apr 2024 07:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WUNl2ZOh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414645028D
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 07:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712905411; cv=none; b=rldi+7L5S0/oy3aODUO10VJQW068Xdis1rBXYyo66oAVsgU3/QXYzBlgyoUMhpxJPq51X8nKsOlAiWd5hy+43trQ6vOM4nf5hes//0VF3I6ceC6IeMLuEwDe7xgc3MO1zH1oy6fyNyaEaKCFCuyxXm1HqSe77DSyD4n7zeZTuPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712905411; c=relaxed/simple;
	bh=YfYzOTQejWBN1QAZ9JlonR1JHH/3MbG0Evv9O2/i10A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fkv7dqZCenPMRZB1q4PnKO9rECB7kP5xRJy1plc7Vm2yh8qBkQFyOxIi6tLrVXyuEtzpi/oYTo+w4nZkARmykwUHCOWQtTfCyFi3ZwBDW6wgqVr8j54U3V1bYgDjJsPDC/zU3fjhJNl2cr7/Z4j/zN66mnFrvqYIweCPcQR+57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WUNl2ZOh; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712905410; x=1744441410;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YfYzOTQejWBN1QAZ9JlonR1JHH/3MbG0Evv9O2/i10A=;
  b=WUNl2ZOh04WrKyFdhnp+zklOEfyFjwXcXV4t6MJmlQyX6Zz9rAESL3yH
   1U885T/JfPRNhZ1k+VmkYwn5urQ4INz2/2KVPcS1GxXw0kIGJRuFoikpw
   85i3ynrW/bjyzrlQU3CJEHfbkmIZqBPG7c78o7zekphqcsXdv+5lPp9Tp
   pKfWDDFCQgSybtuTlMhFG5NiCuaATpmfcHOBN4CqMmK3dKctVMyRXqfVS
   dasKYpz87AJ9SVyOT1GS9rJadW5QNNoyn5fNDLQ7mZCo8GtvEfnl61zdn
   f+akAZEVjP7Zdf49tLrAB4gaeXIX76TFpmfslXlJWOkEoTV1/cPUHpVhu
   Q==;
X-CSE-ConnectionGUID: +eucEVvRQha45194R1cmfA==
X-CSE-MsgGUID: R8RHQlH1QrCy9wLuAjGmUQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8208663"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8208663"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 00:03:26 -0700
X-CSE-ConnectionGUID: 9vSjLb2sRqucV6aQ7L0W4g==
X-CSE-MsgGUID: KjV3noZST8qERTeWHaxUjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21576395"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 00:03:24 -0700
Message-ID: <afbe8c9a-19f9-42e8-a440-2e98271a4ce6@intel.com>
Date: Fri, 12 Apr 2024 15:03:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in
 CPUID.0x80000008
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
References: <20240313125844.912415-1-kraxel@redhat.com>
 <171270475472.1589311.9359836741269321589.b4-ty@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <171270475472.1589311.9359836741269321589.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/10/2024 8:19 AM, Sean Christopherson wrote:
> On Wed, 13 Mar 2024 13:58:41 +0100, Gerd Hoffmann wrote:
>> Use the GuestPhysBits field (EAX[23:16]) to communicate the max
>> addressable GPA to the guest.  Typically this is identical to the max
>> effective GPA, except in case the CPU supports MAXPHYADDR > 48 but does
>> not support 5-level TDP.
>>
>> See commit messages and source code comments for details.
>>
>> [...]
> 
> Applied to kvm-x86 misc, with massaged changelogs to be more verbose when
> describing the impact of each change, e.g. to call out that patch 2 isn't an
> urgent fix because guest firmware can simply limit itself to using GPAs that
> can be addressed with 4-level paging.
> 
> I also tagged patch 1 for stable@, as KVM-on-KVM will do the wrong thing when
> patch 2 lands, i.e. KVM will incorrectly advertise the addressable MAXPHYADDR
> as the raw/real MAXPHYADDR.

you mean old KVM on new KVM?

As far as I see, it seems no harm. e.g., if the userspace and L0 KVM 
have the new implementation. On Intel SRF platform, L1 KVM sees 
EAX[23:16]=48, EAX[7:0]=52. And when L1 KVM is old, it reports EAX[7:0] 
= 48 to L1 userspace.

right, 48 is not the raw/real MAXPHYADDR. But I think there is not 
statement on KVM that CPUID.0x8000_0008.EAX[7:0] of 
KVM_GET_SUPPORTED_CPUID reports the raw/real MAXPHYADDR.

> Please holler if you (or anyone) disagrees with the changes or my analysis on
> the KVM-on-KVM issue.
> 
> Thanks!
> 
> [1/2] KVM: x86: Don't advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID
>        https://github.com/kvm-x86/linux/commit/6f5c9600621b
> [2/2] KVM: x86: Advertise max mappable GPA in CPUID.0x80000008.GuestPhysBits
>        https://github.com/kvm-x86/linux/commit/b628cb523c65
> 
> --
> https://github.com/kvm-x86/linux/tree/next
> 


