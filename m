Return-Path: <kvm+bounces-26822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1309E978186
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93B9EB20F3A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997091DB945;
	Fri, 13 Sep 2024 13:52:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D27843144;
	Fri, 13 Sep 2024 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726235566; cv=none; b=EaywomaTjEdOcqiEjpBvVzzmW1rlzLd+ESfSp1Vq4JDkkqIGv0N7oQtQZEpZqwoYjj8TCC2M2B5qG9KGD3Rh2GWnwRCmaNdpcN4KJlx2VEWJpotEfyFjMgITkTbR34qGSJSWeK1aLreeKjJFCxyVbKnHqfYW8ykfk2JXpafDynE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726235566; c=relaxed/simple;
	bh=I+E10dZp9h10g1VxXIbj1/pHLRChuRvZfeT9ZUzKBjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eyAdvbAzgvCRSwnv2oNweLiwqC+ky/FibQPuV0Vq1Z5RYbZ69grwSJMNNIfFxt7fsApgGB1wWb2rul8wvwW2lq1BYbEmzWb+Ke5wex4QSmhZtr/ssZBkv1fAGsRX9vxivRiha3hr5X5cEqPMSp+UDN5KpgFAPvEQ/CnKOivG6b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1106A13D5;
	Fri, 13 Sep 2024 06:53:13 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16F153F73B;
	Fri, 13 Sep 2024 06:52:40 -0700 (PDT)
Message-ID: <2f9f10cf-7356-458a-bf63-ed6a757df81f@arm.com>
Date: Fri, 13 Sep 2024 14:52:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/19] firmware/psci: Add psci_early_test_conduit()
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-5-steven.price@arm.com> <ZsxS52IBVVLKrTEX@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZsxS52IBVVLKrTEX@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/08/2024 11:03, Catalin Marinas wrote:
> On Mon, Aug 19, 2024 at 02:19:09PM +0100, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> Add a function to test early if PSCI is present and what conduit it
>> uses. Because the PSCI conduit corresponds to the SMCCC one, this will
>> let the kernel know whether it can use SMC instructions to discuss with
>> the Realm Management Monitor (RMM), early enough to enable RAM and
>> serial access when running in a Realm.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> On the code itself:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> However, Will has a point and it would be good if we can avoid this
> early setup as much as possible. If it's just the early console used for
> debugging, maybe just pass the full IPA address on the command line and
> allow those high addresses in fixmap. Not sure about the EFI map.
> 

We could delay the RSI init until we have probed the PSCI conduit.
This could be done from setup_arch(), after the psci_{dt,acpi}_init().
This is safe, as the EFI maps are only created later, as an 
early_initcall().

Kind regards
Suzuki


