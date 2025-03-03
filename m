Return-Path: <kvm+bounces-39853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C880A4B72D
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 05:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2BE316B571
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 04:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B481A1C84CE;
	Mon,  3 Mar 2025 04:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkpZnxyi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D54156C6F
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 04:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740976939; cv=none; b=khCfmRJjtmT5cMR5fYTjWnFLW15Qz9XmQNcER4Z7ZyzqS5UkzBWFWig9dsAs58NBATreyA0PT80CMguqWRQ9lCIbXpo98R6FSdksQgbIeg/zzCUsxstDkqZUutX7y8GccVrXcxojAI536opBbqeFAGRuTJaucfn0xqN7UjDWuqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740976939; c=relaxed/simple;
	bh=d9xG4OwrGjzvhEjvrP19eENQGSWBx98WpPyZysjrJ10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zk+k2e0xIROmsah7jn5lLqRofG+MudTypR29khPt6quakZSIpwHP9lZ4JFLqDxWRuU0CnCUsZwGuiTuTJYEtd67fQqF2guktAr3cjyJopluWy3LrHYJFnChCOhIKGNGp3ZcR6YMjRJho3Y/67UX/stj+GrPzdD2BmFqUH1nsf3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkpZnxyi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740976936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uZWlrNkWyyIdXT2p4tYOkQhHrguS4IQ3yj366dONwt0=;
	b=fkpZnxyiadWGeoVHc1GNtQ+IubAzueaTw8niZ4Q120AaewPwaFH07rGZ3vjWFU2z0fhyGn
	BPjlQHwmht1xbmhft9sTTVDYJYJljSQcRmH3Sl06z9Md6RgIq4guOQXdU5lNxR3+Nc41Pa
	9qDaJxS8Uuf7ovedLetiWlqCFK/8pco=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-55yjbFOSPU-Htq7Y-U40yQ-1; Sun, 02 Mar 2025 23:42:15 -0500
X-MC-Unique: 55yjbFOSPU-Htq7Y-U40yQ-1
X-Mimecast-MFC-AGG-ID: 55yjbFOSPU-Htq7Y-U40yQ_1740976934
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2ff0875e92bso1918415a91.2
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 20:42:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740976934; x=1741581734;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZWlrNkWyyIdXT2p4tYOkQhHrguS4IQ3yj366dONwt0=;
        b=M8NcYuNP0wBDkJwdxaIGsTLaKitFFODAt4Sit6o05uQFkYVs/zAbowFuE1e2MdseT3
         Bwsqd/5jMI3drXqapYZY5N/M6WppT7Si1YMOq6cTRMOrF7Ji+/FOp566RIkLS1l33mm9
         Hay87y4aZEq37+QyIqhbey1hZCxrKhfOU1iuvE7e+08nablNEI7753gestQZ+Twjvitd
         jU9tovWRU/JRXSaXMYICpR99JS8T9juhixx2IycX/uohLoO67dHpTZFcWxHhwe9C2rF2
         jlYiosz9tQ2dZ96ejeezbxTOsg14/eUX7eUa6BetdYYPi/UFJyfboo/CdKFGhbSa6bf/
         pYgA==
X-Forwarded-Encrypted: i=1; AJvYcCVVSF6ysJsfH+fMWvuSm8i6zswjuZm4yXmn+WZuX/E5nQTxnO6crFPEqJSuWYwb+9b/owM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxeVPTy4pc+oj81FMWOYZfB/CpPQX0Ehgv6wpiSKii2T+s9msp
	/3HqHD9U6qpjNuMeunbX/riDmlHixcc7NpQy3OZSEGNvZrn6JsHDWb+tPa6J3uVD1P52R8R5vdt
	CONVMZ3b2uCfbBKjJwXTuin0bxJsIlfscRu/fnhfeTPeCF62BHA==
X-Gm-Gg: ASbGnct1UW5kfRdUnUBZKj/I8fJU5ScXTb0q8EpxUnkkUMEYEp9WqnLWMpudEKxJgim
	fmHEHhOYbYs3WT2ofg4MLp4//+A7WK3/5yPzbIDcnFG1RW8l4ZIub0DrK1renJ0ChTzTjg1srRh
	71ChEI5h8DGxLrRUR3TGXeGvzf5EJaNU6VQOrBbwMe2hTXg9MJF0Bf8dysapWsifAzGhIKz5RMQ
	luq5rMWdd2BgQQX9Shmy3w7Z0caD5I642L8jX8nnwYxNe8yjnXhJP7ZbTU4wES0nN5G0FeSxNQK
	QxNXAsnMMLbCU6YEow==
X-Received: by 2002:a05:6a20:7347:b0:1f0:e7e2:b295 with SMTP id adf61e73a8af0-1f2f4c9c884mr15086800637.5.1740976934438;
        Sun, 02 Mar 2025 20:42:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMQAnjp3aPLIp+JkScadGYw1k0nhzSpzFpRULDgvvNejMSWpiBemFKZIbJFmyuqZgvHibZmA==
X-Received: by 2002:a05:6a20:7347:b0:1f0:e7e2:b295 with SMTP id adf61e73a8af0-1f2f4c9c884mr15086777637.5.1740976934109;
        Sun, 02 Mar 2025 20:42:14 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af221346042sm3304724a12.28.2025.03.02.20.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 20:42:13 -0800 (PST)
Message-ID: <3413f278-2507-4bb5-8904-550abe93e459@redhat.com>
Date: Mon, 3 Mar 2025 14:42:04 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/45] arm64: RME: ioctls to create and configure
 realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-9-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-9-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> Add the KVM_CAP_ARM_RME_CREATE_RD ioctl to create a realm. This involves
> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
> the base level of the Realm Translation Tables (RTT). A VMID also need
> to be picked, since the RMM has a separate VMID address space a
> dedicated allocator is added for this purpose.
> 
> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
> before it is created. Configuration options can be classified as:
> 
>   1. Parameters specific to the Realm stage2 (e.g. IPA Size, vmid, stage2
>      entry level, entry level RTTs, number of RTTs in start level, LPA2)
>      Most of these are not measured by RMM and comes from KVM book
>      keeping.
> 
>   2. Parameters controlling "Arm Architecture features for the VM". (e.g.
>      SVE VL, PMU counters, number of HW BRPs/WPs), configured by the VMM
>      using the "user ID register write" mechanism. These will be
>      supported in the later patches.
> 
>   3. Parameters are not part of the core Arm architecture but defined
>      by the RMM spec (e.g. Hash algorithm for measurement,
>      Personalisation value). These are programmed via
>      KVM_CAP_ARM_RME_CONFIG_REALM.
> 
> For the IPA size there is the possibility that the RMM supports a
> different size to the IPA size supported by KVM for normal guests. At
> the moment the 'normal limit' is exposed by KVM_CAP_ARM_VM_IPA_SIZE and
> the IPA size is configured by the bottom bits of vm_type in
> KVM_CREATE_VM. This means that it isn't easy for the VMM to discover
> what IPA sizes are supported for Realm guests. Since the IPA is part of
> the measurement of the realm guest the current expectation is that the
> VMM will be required to pick the IPA size demanded by attestation and
> therefore simply failing if this isn't available is fine. An option
> would be to expose a new capability ioctl to obtain the RMM's maximum
> IPA size if this is needed in the future.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Separate RMM RTT calculations from host PAGE_SIZE. This allows the
>     host page size to be larger than 4k while still communicating with an
>     RMM which uses 4k granules.
> Changes since v5:
>   * Introduce free_delegated_granule() to replace many
>     undelegate/free_page() instances and centralise the comment on
>     leaking when the undelegate fails.
>   * Several other minor improvements suggested by reviews - thanks for
>     the feedback!
> Changes since v2:
>   * Improved commit description.
>   * Improved return failures for rmi_check_version().
>   * Clear contents of PGD after it has been undelegated in case the RMM
>     left stale data.
>   * Minor changes to reflect changes in previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   5 +
>   arch/arm64/include/asm/kvm_rme.h     |  19 ++
>   arch/arm64/kvm/arm.c                 |  16 ++
>   arch/arm64/kvm/mmu.c                 |  22 +-
>   arch/arm64/kvm/rme.c                 | 322 +++++++++++++++++++++++++++
>   5 files changed, 382 insertions(+), 2 deletions(-)
> 

With below comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

[...]

> +
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_params *params = realm->params;
> +	void *rd = NULL;
> +	phys_addr_t rd_phys, params_phys;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +	int i, r;
> +	int rtt_num_start;
> +
> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	rtt_num_start = realm_num_root_rtts(realm);
> +
> +	if (WARN_ON(realm->rd) || WARN_ON(!realm->params))
> +		return -EEXIST;
> +

Two WARN_ON() can be combined into one.

	if (WARN_ON(realm->rd || !realm->param))

> +	if (pgd_size / RMM_PAGE_SIZE < rtt_num_start)
> +		return -EINVAL;
> +
> +	rd = (void *)__get_free_page(GFP_KERNEL);
> +	if (!rd)
> +		return -ENOMEM;
> +
> +	rd_phys = virt_to_phys(rd);
> +	if (rmi_granule_delegate(rd_phys)) {
> +		r = -ENXIO;
> +		goto free_rd;
> +	}
> +
> +	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (rmi_granule_delegate(pgd_phys)) {
> +			r = -ENXIO;
> +			goto out_undelegate_tables;
> +		}
> +	}
> +
> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	params->rtt_level_start = get_start_level(realm);
> +	params->rtt_num_start = rtt_num_start;
> +	params->rtt_base = kvm->arch.mmu.pgd_phys;
> +	params->vmid = realm->vmid;
> +
> +	params_phys = virt_to_phys(params);
> +
> +	if (rmi_realm_create(rd_phys, params_phys)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> +		WARN_ON(rmi_realm_destroy(rd_phys));
> +		goto out_undelegate_tables;
> +	}
> +
> +	realm->rd = rd;
> +
> +	return 0;
> +
> +out_undelegate_tables:
> +	while (i > 0) {
> +		i -= RMM_PAGE_SIZE;
> +
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys))) {
> +			/* Leak the pages if they cannot be returned */
> +			kvm->arch.mmu.pgt = NULL;
> +			break;
> +		}
> +	}
> +	if (WARN_ON(rmi_granule_undelegate(rd_phys))) {
> +		/* Leak the page if it isn't returned */
> +		return r;
> +	}
> +free_rd:
> +	free_page((unsigned long)rd);
> +	return r;
> +}
> +

[...]

> +
> +int kvm_init_realm_vm(struct kvm *kvm)
> +{
> +	struct realm_params *params;
> +
> +	params = (struct realm_params *)get_zeroed_page(GFP_KERNEL);
> +	if (!params)
> +		return -ENOMEM;
> +
> +	kvm->arch.realm.params = params;
> +	return 0;
> +}
> +

The local variable @params is unnecessary, something like below.

	kvm->arch.realm.params = (struct realm_parms *)get_zeroed_page(GFP_KERNEL);

>   void kvm_init_rme(void)
>   {
>   	if (PAGE_SIZE != SZ_4K)
> @@ -52,5 +368,11 @@ void kvm_init_rme(void)
>   		/* Continue without realm support */
>   		return;
>   
> +	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
> +		return;
> +
> +	if (rme_vmid_init())
> +		return;
> +
>   	/* Future patch will enable static branch kvm_rme_is_available */
>   }

Thanks,
Gavin


