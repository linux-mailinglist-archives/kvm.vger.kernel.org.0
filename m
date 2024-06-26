Return-Path: <kvm+bounces-20511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 591F891752E
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 02:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9E5AB22E8A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 00:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF3C1FDA;
	Wed, 26 Jun 2024 00:12:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A783D819;
	Wed, 26 Jun 2024 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719360757; cv=none; b=bPKpeJSpwLcPnuyYSqdjtXVTyFlW0VPE2I3nv9mUPNp1g/0LHi6q5rwSATEs62cJvA4NuGkXQ88Ucd2cHhNTUJC2cHlLAFRZCiXzX6/WMmX3YGVw+6XUlx4o2ETpNbmtmPIgh5hZaO0vAmZTtcwiR/A+7cyuORJSd2ac+DOPmi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719360757; c=relaxed/simple;
	bh=Di2v1aCgxQbeNZ3G+5jaCus/A3dLdp3TNrO30NfoLj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7yp60KU5XhgDGiqA/IbpuhY4Piai/qbvh1BWlC+bZ+N/l/Bnc/jyC3ue5MATd+jSOf7pfSLzAntcxS/F3LTRO3jhcvyMeWHCn4Yd3fOLCAx+rSytgMGtwznz1lHzw8IYeeJromUpCzMOeZ5HxyJpKvdsRtOuiuJqgz4+i+NjuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DADD339;
	Tue, 25 Jun 2024 17:12:58 -0700 (PDT)
Received: from [192.168.20.22] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F00693F766;
	Tue, 25 Jun 2024 17:12:29 -0700 (PDT)
Message-ID: <ce332c4d-d564-45b5-ae4d-87b569976276@arm.com>
Date: Tue, 25 Jun 2024 19:12:28 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
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
From: Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <20240612104023.GB4602@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 6/12/24 05:40, Jean-Philippe Brucker wrote:
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

To note: i've found out the hard way this set breaks a qemu+kvm+ACPI 
setup as well, for roughly the same reason. I imagine we want kernels 
which can boot in either a realm or a normal guest.

I delayed the version check a bit and then, did enough that 
arm_smcccc_1_1_invoke() could replace arm_smccc_smc() in 
invoke_rsi_fn_smc_with_res(). Which naturally gets it booting again, the 
larger implications i've not considered yet.




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


