Return-Path: <kvm+bounces-11979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8130387E880
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 12:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52A7DB21A8A
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 11:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE6F36AF5;
	Mon, 18 Mar 2024 11:22:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EFEA2E651;
	Mon, 18 Mar 2024 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710760964; cv=none; b=hpyE29rU+6wIz2Fsep3SfLDl0VTPEASUVbuZjoFEAKLq5YKfAJ2Q/ck0wMwiPpgKA9Eurw0TdCu/CP55mv3JMbrah396Y6wddvfBKNyNudkJhnCXfTyOyQIm/wMKt725OjgSQzMFieIiWOxTNj8Lqmq8o7JtU16Lwcz/1Mvn3DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710760964; c=relaxed/simple;
	bh=VJmGLdrpLC4M2layVFICfKfdaErWKxnf2M1uTyH1ek0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l21PV2Yvz0VLH6Njia9JBGzReXTda5lkXLAbr60ibBWOvLmx92vxZnP6lv8uZjxXrwjVw7oyOPPwV+saoXLCMLqGGnMty0bFYqVFw6k7/kfsZ5KUJtghqg6cm6j8I09L/bfBpljbXkBD5sB0TJHDK4Uhvnja9fnIe3A+hb3GlyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A857BDA7;
	Mon, 18 Mar 2024 04:23:17 -0700 (PDT)
Received: from [10.57.12.69] (unknown [10.57.12.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55E0C3F762;
	Mon, 18 Mar 2024 04:22:39 -0700 (PDT)
Message-ID: <4809297b-a2f4-45a2-9005-884232a35b75@arm.com>
Date: Mon, 18 Mar 2024 11:22:39 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 06/28] arm64: RME: ioctls to create and configure
 realms
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-7-steven.price@arm.com>
 <e5267f44-5e9a-42a2-a921-5f3428b03c05@os.amperecomputing.com>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <e5267f44-5e9a-42a2-a921-5f3428b03c05@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks for taking a look at this.

On 18/03/2024 07:40, Ganapatrao Kulkarni wrote:
> On 27-01-2023 04:59 pm, Steven Price wrote:
[...]
>>   int kvm_init_rme(void)
>>   {
>> +    int ret;
>> +
>>       if (PAGE_SIZE != SZ_4K)
>>           /* Only 4k page size on the host is supported */
>>           return 0;
>> @@ -43,6 +394,12 @@ int kvm_init_rme(void)
>>           /* Continue without realm support */
>>           return 0;
>>   +    ret = rme_vmid_init();
>> +    if (ret)
>> +        return ret;
>> +
>> +    WARN_ON(rmi_features(0, &rmm_feat_reg0));
> 
> Why WARN_ON, Is that good enough to print err/info message and keep
> "kvm_rme_is_available" disabled?

Good point. RMI_FEATURES "does not have any failure conditions" so this
is very much a "should never happen" situation. Assuming the call
gracefully fails then rmm_feat_reg0 would remain 0 which would in
practise stop realms being created, but this is clearly non-ideal.

I'll fix this up in the next version to do the rmi_features() call
before rme_vmid_init(), that way we can just return early without
setting kvm_rme_is_available in this situation. I'll keep the WARN_ON
because something has gone very wrong if this call fails.

> IMO, we should print message when rme is enabled, otherwise it should be
> silent return.

The rmi_check_version() call already outputs a "RMI ABI version %d.%d"
message - I don't want to be too noisy here. Other than the 'cannot
happen' situations if you see the "RMI ABI" message then
kvm_rme_is_available will be set. And those 'cannot happen' routes will
print their own error message (and point to a seriously broken system).

And obviously in the case of SMC_RMI_VERSION not being supported then we
silently return as this is taken to mean there isn't an RMM.

Thanks,

Steve


