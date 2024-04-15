Return-Path: <kvm+bounces-14632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8FB8A4B05
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 10:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F0021F226E0
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B049F3BBDE;
	Mon, 15 Apr 2024 08:59:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092013B297
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 08:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713171571; cv=none; b=efY9Be8hECQT45LsldmdssGFz3WMtEZCR1DG7HW60JyeYHOkXoY8qDUHwFwfYPX5natk3cyJB6kjRGW4eH8cQ5J6jj6kBZZSP52sAGUV+GUS86YtbMjIe9Th/IMuuLZPsLaddABFv2Z0wyBWl9ozONif4QffcZ7MRcGCskmmkGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713171571; c=relaxed/simple;
	bh=cQefjCbFLFJbuXKCV4wQx4QliCH4tuRgWArq1MZKwHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CH/aK78tVNNp+qLgfSSsVwm46clnahv2vfl0wrG+vQQKEIXleBNPgf8n2dJUi6zS046grrQ8trj03X59kBKaSGdWAQYsSIgONF4MzEwNj+31KCU5wxgYUFi9IV+9HXi49pFgQoo7/u67SdLbW09rFpd711RNIInjWAZbHPjW56E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA30A2F;
	Mon, 15 Apr 2024 01:59:57 -0700 (PDT)
Received: from [10.57.84.28] (unknown [10.57.84.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3B0C3F64C;
	Mon, 15 Apr 2024 01:59:27 -0700 (PDT)
Message-ID: <23604d92-1d67-4d40-881d-c9a8e6b6fe05@arm.com>
Date: Mon, 15 Apr 2024 09:59:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 00/33] Support for Arm Confidential Compute
 Architecture
Content-Language: en-GB
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com,
 james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com,
 andrew.jones@linux.dev, eric.auger@redhat.com
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <Zha7mFYTPJk34+cO@vm3>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <Zha7mFYTPJk34+cO@vm3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Itaru

On 10/04/2024 17:17, Itaru Kitayama wrote:
> Hi Suzuki,
> 
> On Fri, Apr 12, 2024 at 11:33:35AM +0100, Suzuki K Poulose wrote:
>> This series adds support for running the kvm-unit-tests in the Arm CCA reference
>> software architecture.
>>
>>

...

>> Changes since rfc:
>>    [ https://lkml.kernel.org/r/20230127114108.10025-1-joey.gouly@arm.com ]
>>    - Add support for RMM-v1.0-EAC5, changes to RSI ABIs
>>    - Some hardening checks (FDT overlapping the BSS sections)
>>    - Selftest for memory stress
>>    - Enable PMU/SVE tests for Realms
>>
>>   [0] https://lkml.kernel.org/r/20240412084056.1733704-1-steven.price@arm.com
>>   [1] https://lkml.kernel.org/r/20210702163122.96110-1-alexandru.elisei@arm.com
>>   [2] https://github.com/laurencelundblade/QCBOR

...

> 
> Thanks for the update! I'll go through the series one by one in the
> coming weeks. Just curious one thing - do you guys wish to add Realm tests to the kvm-unit-test package, but not to kselftests?

Thanks for taking a look. kselftests is in plan but we wanted to make
sure the UABI is a bit more stable before we plumb all of that.

Kind regards
Suzuki

> 
> Thanks,
> Itaru.
> 
>>
>> -- 
>> 2.34.1
>>


