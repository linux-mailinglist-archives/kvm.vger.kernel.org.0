Return-Path: <kvm+bounces-29994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2983B9B5A8D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 05:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98DA21F24100
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 04:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C011991D8;
	Wed, 30 Oct 2024 04:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMJoN0sU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF15194C76
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 04:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730261192; cv=none; b=Qp0pwehU3VkiKp02oFDIIHMSLzOoL78xvUKH1v8lvGVP87Ym1j3iy8L9jZZ3qs808OuQ2TIUFu/RWL1Qq3yEOO+2gx0jw+qeHS1lCooZZPNIHZBMnxwt9JumYWC30iRv5bKycGEdqUXEmGOq+9rMJkDrJLRRh/x8yq2KbGFxKfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730261192; c=relaxed/simple;
	bh=632XpUZRsR5/aU6sbXBuVov/ZpV5a8Ycg2UuG1IRfFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UHPDY1OXp/jEzyz4fOWphFBV1JoDUYM1hN3ExD6Fm2RdAuTca67TznTcYAbTreqe2YArzf19haDaZrOnjwIJpWe2j6mZ57MHTaGV6ijXqF1m3YKu9EgAGvGj1XHajIrDod9bGbkUFQqAKpZbmv++hXlOHKUjYzj8W9TYLptfDFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMJoN0sU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730261188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I6Fn1Bf3LTxjm3Pi7bGgRNx/dCat7AxttwP16Rp3WAQ=;
	b=GMJoN0sUrYthfqD+CsV/HB7YqEIKsM9bWEzZaQC74+e2JdsYdr9iWfKlASAIGalXfYiRP0
	vU7D6v5SmTZ4x4flkU9JKoGgp4QeyG1HLGRG/CJNDBSubAgk/fUdJCy43xOL1A1p5rzWMX
	a5CZNBj1cpNuSKnoliz9xOlHMmVt72Q=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-QoKFE19JMp-I_L3BhhQk0Q-1; Wed, 30 Oct 2024 00:06:27 -0400
X-MC-Unique: QoKFE19JMp-I_L3BhhQk0Q-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b155e23851so972658385a.2
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 21:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730261187; x=1730865987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I6Fn1Bf3LTxjm3Pi7bGgRNx/dCat7AxttwP16Rp3WAQ=;
        b=UL4Tzc2ru/Wt9tbQfieikyTUMUYQeBdAmiHBHHI1lZkZlNjoYmhF3s+jFv82TbaNV+
         9LcARmAxEOyV3JG1mtfec84Ec8jn2Ge0GxLcYiKlubrsWZwvnd+G27cLFLiOTeswzA2t
         E7oo8JG5hAu+mbPryvgXlONO93MZj7/Mzlcsv0oPxcmUfOa8Rtmy2yIMOQ4rt6Vm534z
         9iT8Z+1ESbluhOrJgKr6DSABdQSzFoNRFhxDjzJA2CI7RUmPr//LzX0NBvDwWlBisZ+a
         NeXk2QqfQGoFJK8KnS0i86f7ya1CkFXl/SR/m1mO6HNUHnAr6zcSBkpfruw31ISGcE8i
         vcOA==
X-Forwarded-Encrypted: i=1; AJvYcCXkLMhBJSQDdc4aWY/pjWa7ZAzYf0xJZZ4EHdJsYUENuRopQqcRm4k5PfPGRQIDLFW1u9o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9mbkvi9aTza2nuvr9zHQQe4Y1vXwl3EW3pKKZKsfsYNbigj0l
	hylJnKjRXjv2+80K01MhD8wdvHEdo0VF1nOTj5Ws7tuQO9gqaPIW3kLceGNV6qqkW0r6V1sk7W4
	3FBxsp3nRBRssfE8ddTX+cNglUhkrmg1d3BX+QCdICrEqeScR2Q==
X-Received: by 2002:a05:620a:1a84:b0:7a9:b456:c5e6 with SMTP id af79cd13be357-7b193f35bf3mr1894408385a.42.1730261186700;
        Tue, 29 Oct 2024 21:06:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrx1mmIynIiSGSVPWiqtshULFjxIn2aPt/C14LDu8Kq33y8t5ez+1+bvieZGhRPfYYDYfiJQ==
X-Received: by 2002:a05:620a:1a84:b0:7a9:b456:c5e6 with SMTP id af79cd13be357-7b193f35bf3mr1894405985a.42.1730261186319;
        Tue, 29 Oct 2024 21:06:26 -0700 (PDT)
Received: from [192.168.40.163] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b18d2ca347sm481562385a.71.2024.10.29.21.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 21:06:25 -0700 (PDT)
Message-ID: <469bcbeb-97e0-4fc4-9c2b-b86c59dbe24a@redhat.com>
Date: Wed, 30 Oct 2024 00:06:08 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] Initial support for SMMUv3 nested translation
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev,
 Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Eric Auger <eric.auger@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/9/24 12:23 PM, Jason Gunthorpe wrote:
> This brings support for the IOMMFD ioctls:
> 
>   - IOMMU_GET_HW_INFO
>   - IOMMU_HWPT_ALLOC_NEST_PARENT
>   - IOMMU_DOMAIN_NESTED
>   - ops->enforce_cache_coherency()
> 
> This is quite straightforward as the nested STE can just be built in the
> special NESTED domain op and fed through the generic update machinery.
> 
> The design allows the user provided STE fragment to control several
> aspects of the translation, including putting the STE into a "virtual
> bypass" or a aborting state. This duplicates functionality available by
> other means, but it allows trivially preserving the VMID in the STE as we
> eventually move towards the vIOMMU owning the VMID.
> 
> Nesting support requires the system to either support S2FWB or the
> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> cache and view incoherent data, currently VFIO lacks any cache flushing
> that would make this safe.
> 
> Yan has a series to add some of the needed infrastructure for VFIO cache
> flushing here:
> 
>   https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
> 
> Which may someday allow relaxing this further.
> 
> Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
> this.
> 
> This is the first series in what will be several to complete nesting
> support. At least:
>   - IOMMU_RESV_SW_MSI related fixups
>      https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
>   - vIOMMU object support to allow ATS and CD invalidations
>      https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
>   - vCMDQ hypervisor support for direct invalidation queue assignment
>      https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
>   - KVM pinned VMID using vIOMMU for vBTM
>      https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
>   - Cross instance S2 sharing
>   - Virtual Machine Structure using vIOMMU (for vMPAM?)
>   - Fault forwarding support through IOMMUFD's fault fd for vSVA
> 
> The vIOMMU series is essential to allow the invalidations to be processed
> for the CD as well.
> 
> It is enough to allow qemu work to progress.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> 
> v3:
>   - Rebase on v6.12-rc2
>   - Revise commit messages
>   - Consolidate CANWB checks into arm_smmu_master_canwbs()
>   - Add CONFIG_ARM_SMMU_V3_IOMMUFD to compile out iommufd only features
>     like nesting
>   - Shift code into arm-smmu-v3-iommufd.c
>   - Add missed IS_ERR check
>   - Add S2FWB to arm_smmu_get_ste_used()
>   - Fixup quirks checks
>   - Drop ARM_SMMU_FEAT_COHERENCY checks for S2FWB
>   - Limit S2FWB to S2 Nesting Parent domains "just in case"
> v2: https://patch.msgid.link/r/0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com
>   - Revise commit messages
>   - Guard S2FWB support with ARM_SMMU_FEAT_COHERENCY, since it doesn't make
>     sense to use S2FWB to enforce coherency on inherently non-coherent hardware.
>   - Add missing IO_PGTABLE_QUIRK_ARM_S2FWB validation
>   - Include formal ACPIA commit for IORT built using
>     generate/linux/gen-patch.sh
>   - Use FEAT_NESTING to block creating a NESTING_PARENT
>   - Use an abort STE instead of non-valid if the user requests a non-valid
>     vSTE
>   - Consistently use 'nest_parent' for naming variables
>   - Use the right domain for arm_smmu_remove_master_domain() when it
>     removes the master
>   - Join bitfields together
>   - Drop arm_smmu_cache_invalidate_user patch, invalidation will
>     exclusively go via viommu
> v1: https://patch.msgid.link/r/0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com
> 
> Jason Gunthorpe (6):
>    vfio: Remove VFIO_TYPE1_NESTING_IOMMU
>    iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
>    iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
>    iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
>    iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
>    iommu/arm-smmu-v3: Use S2FWB for NESTED domains
> 
> Nicolin Chen (3):
>    ACPICA: IORT: Update for revision E.f
>    ACPI/IORT: Support CANWBS memory access flag
>    iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
>      arm_smmu_hw_info
> 
>   drivers/acpi/arm64/iort.c                     |  13 ++
>   drivers/iommu/Kconfig                         |   9 +
>   drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
>   .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 204 ++++++++++++++++++
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 114 ++++++----
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  83 ++++++-
>   drivers/iommu/arm/arm-smmu/arm-smmu.c         |  16 --
>   drivers/iommu/io-pgtable-arm.c                |  27 ++-
>   drivers/iommu/iommu.c                         |  10 -
>   drivers/iommu/iommufd/vfio_compat.c           |   7 +-
>   drivers/vfio/vfio_iommu_type1.c               |  12 +-
>   include/acpi/actbl2.h                         |   3 +-
>   include/linux/io-pgtable.h                    |   2 +
>   include/linux/iommu.h                         |   5 +-
>   include/uapi/linux/iommufd.h                  |  55 +++++
>   include/uapi/linux/vfio.h                     |   2 +-
>   16 files changed, 465 insertions(+), 98 deletions(-)
>   create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> 
> 
> base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b

Apologies for the delay; quite a few spec bits to lookup, as well as some SMMU refresh-ing on my part.

Reviewed-by: Donald Dutile <ddutile@redhat.com>


