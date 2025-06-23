Return-Path: <kvm+bounces-50399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28814AE4CCC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABDA816C372
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61CF2D4B47;
	Mon, 23 Jun 2025 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CzDUp7Zt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD4E1C84D0
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750703207; cv=none; b=YMApwbm8Kpc1P+8DVTXiFigbaF5oBfWm4HQIgAGoafs45z1JCs1XICqaKjY5DGsuJu3NNgWTxYvs8oDQhiURB5Pn27BlByxbIftsAITS2n4SSvavdRGNWHqT7oFfcqyCSLUY4uCrVjf+uqgZJ8kak1Wj+RwmaC1EzIlxixZacvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750703207; c=relaxed/simple;
	bh=TJbyCjpQUTgcNzSy2LbHi3jtU+JgR5DmqnRNp0zwnzU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZnA/YhLYPLMJ526KQ5VDSiVU8FAbPKOhR10nRA2ueQuQ7kgFqD9YzLmPJ6Q0/5r7GWPwX5fnj21vzpILBtl4TaCrDo+s8CzzBtO9DjQuBCtfXkvcZYdery6jTqNWmMbdhKE+V/ZKiveMDSxJ/m2cz64I7jhQMiWSy+WEYQqJBZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CzDUp7Zt; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-408d05d8c03so833868b6e.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 11:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750703203; x=1751308003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iJHuSuwyngESt8WBCKXgeOnblRRUSgRFggwy+8QiK3Q=;
        b=CzDUp7ZtTacqwgkX/0UBjeDuYjk7hskVNN3cNFfQzty82/IYTxqC3De3ohsi29QpfM
         +lfvWxSpyVpDBbLHlQoBQt4fXDpAmJ3piYbfoE4G5AdBszsd2vC8LvXESzlNNwvb1voB
         1F8nF/ND4s8/MwdPDZmLFUsyriSXkSrL5km5JF2CSoLbtXZ16L9tHYr42PFz9eQnm9TX
         nrmpjdJYMCdzVwnB9zVTBciMbajtQwZf5Lk/rBw8DHiWhRcDMtJWBrmiNpncoSGV2zeC
         MfjTUnyRbsPtmtAs5l+L2O2j7a2b5tClGPXV/1heKgof45X/wkwVWraG80AeicmKwfwX
         uxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750703203; x=1751308003;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJHuSuwyngESt8WBCKXgeOnblRRUSgRFggwy+8QiK3Q=;
        b=ifNcvjkLEOn90TsNRnzwYT/UeOefZ406o2K3skHEtrl/uiAsbxZH6d/ddWzeRaohAl
         vx81JveaEIHMeUunXj7AZXsUoykzNIEtruJifOETQ9/Fp5oZOH65SHjAxOHxqK6zzP/H
         zKrmtMvLIbSJwl0AVY0KZ47iAJXuyJkmEyFUCQiXHQPjooOh5rLf9XMODLkp+EVGMX/1
         xo+i9l7QIqQreQkumF0E921jYq9HGmvHs7sLahQZt5OrdVUTLI7h/nKAWP1qVYH56dOv
         Wq8VCMc+b4gB5KUr1G/szH/pDDzBtANYlYhSG5+6HDnQw9cSQX3ZI6sY4sQ+4mP+KUdU
         1h2A==
X-Gm-Message-State: AOJu0YzcvcsZnF19saDEFs3V1Izgzkz0Ce7e6NcxHK78zSto1pm4ZbXe
	jAsZ3bjvqCr7EKRBMaJcFXlPqE5QdMYhdZN1v7IzdvSq4uEu++U/7b85wEoZf2k6OaJ94cpJypn
	5fvviQwBhUl6tZ49OFudQeyua7g==
X-Google-Smtp-Source: AGHT+IGC715JfAZ6bB+MUmt3e2UkqjENUKLIOq46BUMkNYiBZaTpU+l16Sml2Ik55e/lBKhpSWes9ItyhVpKmkS24Q==
X-Received: from oirr11.prod.google.com ([2002:a05:6808:840b:b0:40a:c991:8f3c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1645:b0:401:918a:5b89 with SMTP id 5614622812f47-40ac6ef30e6mr10779472b6e.26.1750703203710;
 Mon, 23 Jun 2025 11:26:43 -0700 (PDT)
Date: Mon, 23 Jun 2025 18:26:42 +0000
In-Reply-To: <aFYFqrYRsmCi6oii@linux.dev> (message from Oliver Upton on Fri,
 20 Jun 2025 18:06:50 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntpleu9uvx.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 07/23] perf: arm_pmuv3: Introduce method to partition
 the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Fri, Jun 20, 2025 at 10:13:07PM +0000, Colton Lewis wrote:
>> For PMUv3, the register field MDCR_EL2.HPMN partitiones the PMU
>> counters into two ranges where counters 0..HPMN-1 are accessible by
>> EL1 and, if allowed, EL0 while counters HPMN..N are only accessible by
>> EL2.

>> Create module parameters partition_pmu and reserved_guest_counters to
>> reserve a number of counters for the guest. These numbers are set at
>> boot because the perf subsystem assumes the number of counters will
>> not change after the PMU is probed.

>> Introduce the function armv8pmu_partition() to modify the PMU driver's
>> cntr_mask of available counters to exclude the counters being reserved
>> for the guest and record reserved_guest_counters as the maximum
>> allowable value for HPMN.

>> Due to the difficulty this feature would create for the driver running
>> at EL1 on the host, partitioning is only allowed in VHE mode. Working
>> on nVHE mode would require a hypercall for every counter access in the
>> driver because the counters reserved for the host by HPMN are only
>> accessible to EL2.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm/include/asm/arm_pmuv3.h   | 10 ++++
>>   arch/arm64/include/asm/arm_pmuv3.h |  5 ++
>>   drivers/perf/arm_pmuv3.c           | 95 +++++++++++++++++++++++++++++-
>>   include/linux/perf/arm_pmu.h       |  1 +
>>   4 files changed, 109 insertions(+), 2 deletions(-)

>> diff --git a/arch/arm/include/asm/arm_pmuv3.h  
>> b/arch/arm/include/asm/arm_pmuv3.h
>> index 2ec0e5e83fc9..9dc43242538c 100644
>> --- a/arch/arm/include/asm/arm_pmuv3.h
>> +++ b/arch/arm/include/asm/arm_pmuv3.h
>> @@ -228,6 +228,11 @@ static inline bool kvm_set_pmuserenr(u64 val)

>>   static inline void kvm_vcpu_pmu_resync_el0(void) {}

>> +static inline bool has_vhe(void)
>> +{
>> +	return false;
>> +}
>> +

> This has nothing to do with PMUv3, I'm a bit surprised to see you're
> touching 32-bit ARM. Can you just gate the whole partitioning thing on
> arm64?

The PMUv3 driver also has to compile on 32-bit ARM.

My first series had the partitioning code in arch/arm64 but you asked me
to move it to the PMUv3 driver.

How are you suggesting I square those two requirements?

>> +static bool partition_pmu __read_mostly;
>> +static u8 reserved_guest_counters __read_mostly;
>> +
>> +module_param(partition_pmu, bool, 0);
>> +MODULE_PARM_DESC(partition_pmu,
>> +		 "Partition the PMU into host and guest VM counters [y/n]");
>> +
>> +module_param(reserved_guest_counters, byte, 0);
>> +MODULE_PARM_DESC(reserved_guest_counters,
>> +		 "How many counters to reserve for guest VMs [0-$NR_COUNTERS]");
>> +

> This is confusing and not what we discussed offline.

> Please use a single parameter that describes the number of counters used
> by the *host*. This affects the *host* PMU driver, KVM can discover (and
> use) the leftovers.

> If the single module parameter goes unspecified the user did not ask for
> PMU partitioning.

I understand what we discussed offline, but I had a dilemma.

If we do a single module parameter for number of counters used by the
host, then it defaults to 0 if unset and there is no way to distinguish
between no partitioning and a request for partitioning reserving 0
counters to the host which I also thought you requested. Would you be
happy leaving no way to specify that?

In any case, I think the usage is more self explainatory if
partitition=[y/n] is a separate bit. The other parameter for guest
reservation is then based on a consideration of what an unset parameter
should mean and I decided it's a more sane default if partition=y
[other-param]=0/unset gives 0 counters to the guest.

It does affect the host, but by default the host owns everything. The
only people who will be tweaking these parameters are going to be
concerned with how many counters the guest gets and I think the
parameters should reflect that intent.

>> +/**
>> + * armv8pmu_reservation_is_valid() - Determine if reservation is allowed
>> + * @guest_counters: Number of host counters to reserve
>> + *
>> + * Determine if the number of host counters in the argument is
>> + * allowed. It is allowed if it will produce a valid value for
>> + * register field MDCR_EL2.HPMN.
>> + *
>> + * Return: True if reservation allowed, false otherwise
>> + */
>> +static bool armv8pmu_reservation_is_valid(u8 guest_counters)
>> +{
>> +	return guest_counters <= armv8pmu_pmcr_n_read();
>> +}
>> +
>> +/**
>> + * armv8pmu_partition_supported() - Determine if partitioning is  
>> possible
>> + *
>> + * Partitioning is only supported in VHE mode (with PMUv3, assumed
>> + * since we are in the PMUv3 driver)
>> + *
>> + * Return: True if partitioning is possible, false otherwise
>> + */
>> +static bool armv8pmu_partition_supported(void)
>> +{
>> +	return has_vhe();
>> +}
>> +
>> +/**
>> + * armv8pmu_partition() - Partition the PMU
>> + * @pmu: Pointer to pmu being partitioned
>> + * @guest_counters: Number of host counters to reserve
>> + *
>> + * Partition the given PMU by taking a number of host counters to
>> + * reserve and, if it is a valid reservation, recording the
>> + * corresponding HPMN value in the hpmn field of the PMU and clearing
>> + * the guest-reserved counters from the counter mask.
>> + *
>> + * Passing 0 for @guest_counters has the effect of disabling  
>> partitioning.
>> + *
>> + * Return: 0 on success, -ERROR otherwise
>> + */
>> +static int armv8pmu_partition(struct arm_pmu *pmu, u8 guest_counters)
>> +{
>> +	u8 nr_counters;
>> +	u8 hpmn;
>> +
>> +	if (!armv8pmu_reservation_is_valid(guest_counters))
>> +		return -EINVAL;
>> +
>> +	nr_counters = armv8pmu_pmcr_n_read();
>> +	hpmn = guest_counters;
>> +
>> +	pmu->hpmn_max = hpmn;

> I'm not sure the host driver needs this for anything, KVM just needs to
> know what's potentially in use by the host.

>> +	/* Inform host driver of available counters */

> ... said the driver to itself :)

I can delete that comment now :)

