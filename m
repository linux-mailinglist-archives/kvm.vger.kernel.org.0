Return-Path: <kvm+bounces-20889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4DF92548E
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 09:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6EA91C24BCE
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 07:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E363A1369A3;
	Wed,  3 Jul 2024 07:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nmY77SKa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FDA134415;
	Wed,  3 Jul 2024 07:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719991420; cv=none; b=CJ/6Bzt9FtZ+05OSMGCc2vUKTs19co2cCI1KuZBH/D8KmB1fS/cRh9t6j8QYnCHy0wltM3WXsInGSbNw0E8aMbdF0DSd/cNqKXGznSBzmBc0rNxnaaFiqE12DY3TLm6E9b8j2eGxxyzMnLuTeKwHIGhK7AivBGSk9rgq+qO/hrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719991420; c=relaxed/simple;
	bh=bU/2YsOmK16v0fOdsJ38br5N/4af3GRgBNGqmZiO8vI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=RqRR9YeZXXAqyWkY6grM0byCG/WlCANfdio4HCl7qAxEf7aFDYWFAmpTKnu98hm/3uC/BUCP2O7nRW8f+3lPH57ZdYUE8RLR4xNiykNhQmoNXfYyUNPzdCgmVZL7ZFWxO+uHQMIZEaNRCOsYCxnGJOp+3IQSabhtg5gGDuAlkM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nmY77SKa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E01C2BD10;
	Wed,  3 Jul 2024 07:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719991419;
	bh=bU/2YsOmK16v0fOdsJ38br5N/4af3GRgBNGqmZiO8vI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nmY77SKan33oVV7BCDgh9UdHHeEJg95y4e4aq46WP/By1OUdh7ymaLPuAOzwyeFcI
	 Azyn1U4InRUI9MjEX5g/LTA0xXPJkqXiVDiOpGz8dHwi/xbKzJnx4gIle3yrlH93Kt
	 jiyWwpSA3KLs0M7+Gwkh7zGQhSD8KRVVp4LMbjhjJF9VgZR5TYA3x+nSZC8Ri41siP
	 Rdp3GQGCbzd1d0/ZM8Hw0WjEIcO60VqN7IJySppYsew1BFzWGKCP67U5plxEY/RfRw
	 ZBpiFTblyfea6k0wvlxGPNNMkOSSCu+rWQXSuwSmJZsDHaB4z+R5rceCeJQO1ZRER5
	 QI+MaDADhNu8A==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sOuL3-009LsO-75;
	Wed, 03 Jul 2024 08:23:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 03 Jul 2024 08:23:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
 christoffer.dall@arm.com, Anders Roxell <anders.roxell@linaro.org>, Andrew
 Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, "open list:ARM" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU introspection
 test if missing
In-Reply-To: <8c11996c-b36d-e560-cdeb-e543ee478a54@huawei.com>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-2-alex.bennee@linaro.org>
 <8c11996c-b36d-e560-cdeb-e543ee478a54@huawei.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <74e184afbc4b58fba984b91964915a9e@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, alex.bennee@linaro.org, pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org, qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, anders.roxell@linaro.org, andrew.jones@linux.dev, alexandru.elisei@arm.com, eric.auger@redhat.com, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2024-07-03 08:09, Zenghui Yu wrote:
> On 2024/7/3 0:35, Alex Bennée wrote:
>> The test for number of events is not a substitute for properly
>> checking the feature register. Fix the define and skip if PMUv3 is not
>> available on the system. This includes emulator such as QEMU which
>> don't implement PMU counters as a matter of policy.
>> 
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> Cc: Anders Roxell <anders.roxell@linaro.org>
>> ---
>>  arm/pmu.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index 9ff7a301..66163a40 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool 
>> overflow_at_64bits) {}
>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>>   #define ID_DFR0_PMU_NOTIMPL	0b0000
>> -#define ID_DFR0_PMU_V3		0b0001
>> +#define ID_DFR0_PMU_V3		0b0011
> 
> Why? This is a macro used for AArch64 and DDI0487J.a (D19.2.59, the
> description of the PMUVer field) says that
> 
> "0b0001	Performance Monitors Extension, PMUv3 implemented."
> 
> while 0b0011 is a reserved value.

I think this is a mix of 32bit and 64bit views (ID_DFR0_EL1.PerfMon
instead of ID_AA64DFR0_EL1.PMUVer), and the whole thing is a mess
(ID_AA64DFR0_PERFMON_MASK is clearly confused...).

I haven't looked at how this patch fits in the rest of the code though.

         M.
-- 
Jazz is not dead. It just smells funny...

