Return-Path: <kvm+bounces-19437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD8ED905102
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A183C1C209C9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9CD16F0CE;
	Wed, 12 Jun 2024 10:59:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6CD16EBFD;
	Wed, 12 Jun 2024 10:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718189969; cv=none; b=KpPtC+uB9hurzP06Ipi0n7SPgfbDCSumqCzeD0QWNRvJ/Q+kuBtz2TQ898nWHdwulDRN61MaWSTMjSBoJxKw40ndYPipziqzm0QJ5/acanJ4kJ+hG/HvDR1MDC52kKOkHvHy3P4cGCuakvUoQ8NqKbFQ/nntGakbUfKMpaw0KMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718189969; c=relaxed/simple;
	bh=llCwwnVAkDKupqy/WhpTunxBcdTwr9NCz6JQmlN1bNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ODIZkUBANWVIk7oTmDag5IMkw/Jbp4bBYrwMRJEoYNVWmFWMyHcMYGw7XxudPJxVmruyXWmSOpPFgyapJcZsTUDIOX9C49QAtIxOJSYGg9RxgkRt7cFdSTn8hVr3PJVd1GrUoX33Ath0C0OM7yCiQw21ZSqDBMriLAOD6M36N40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FA281595;
	Wed, 12 Jun 2024 03:59:50 -0700 (PDT)
Received: from [10.57.72.20] (unknown [10.57.72.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2D073F73B;
	Wed, 12 Jun 2024 03:59:23 -0700 (PDT)
Message-ID: <3301ddd8-f088-48e3-bfac-460891698eac@arm.com>
Date: Wed, 12 Jun 2024 11:59:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
Content-Language: en-GB
To: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-3-steven.price@arm.com> <20240612104023.GB4602@myrica>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240612104023.GB4602@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2024 11:40, Jean-Philippe Brucker wrote:
> On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Detect that the VM is a realm guest by the presence of the RSI
>> interface.
>>
>> If in a realm then all memory needs to be marked as RIPAS RAM initially,
>> the loader may or may not have done this for us. To be sure iterate over
>> all RAM and mark it as such. Any failure is fatal as that implies the
>> RAM regions passed to Linux are incorrect - which would mean failing
>> later when attempting to access non-existent RAM.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Co-developed-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
>> +static bool rsi_version_matches(void)
>> +{
>> +	unsigned long ver_lower, ver_higher;
>> +	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
>> +						&ver_lower,
>> +						&ver_higher);
> 
> There is a regression on QEMU TCG (in emulation mode, not running under KVM):
> 
>    qemu-system-aarch64 -M virt -cpu max -kernel Image -nographic
> 
> This doesn't implement EL3 or EL2, so SMC is UNDEFINED (DDI0487J.a R_HMXQS),
> and we end up with an undef instruction exception. So this patch would
> also break hardware that only implements EL1 (I don't know if it exists).

Thanks for the report,  Could we not check ID_AA64PFR0_EL1.EL3 >= 0 ? I
think we do this for kvm-unit-tests, we need the same here.


Suzuki

> 
> The easiest fix is to detect the SMC conduit through the PSCI node in DT.
> SMCCC helpers already do this, but we can't use them this early in the
> boot. I tested adding an early probe to the PSCI driver to check this, see
> attached patches.
> 
> Note that we do need to test the conduit after finding a PSCI node,
> because even though it doesn't implement EL2 in this configuration, QEMU
> still accepts PSCI HVCs in order to support SMP.
> 
> Thanks,
> Jean
> 


