Return-Path: <kvm+bounces-23707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9051F94D425
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46BF728467E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996F71990BE;
	Fri,  9 Aug 2024 16:05:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35EA31870;
	Fri,  9 Aug 2024 16:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219546; cv=none; b=GJvXic7Xgj/KPDrcyXXa3d/Yv7vUNLnrwIA9FFEiT0Q2ubHRWUF9aQT4qmmkGznCWdacWezN0XIl3EYIcrqrFgH9AfKqviRZImIGR+B9o/CyXv6dZ8vgzrDUqZxNX4MVZXh6BAn3YsntElYRlcohdbtYQiDuXcVfhlf2R/AjMWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219546; c=relaxed/simple;
	bh=EXlZUnRF5Qpe5pIaxBUQUq8EmCLYjTj5GAqFyJtOH3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a4/+kbXlJaV/XH90VjJZUrZ6lDsBAxbTsa1uebKV9NWTW65aPs7evHyrzE7cT3oxF9I9x1T3lgG+tU0U7WTHPb3fDvFR4K3mHj1ajh9k9oECdSEIc4cj8tFblkLDrKt6fI0MWC8opgLU8VnBOTl75JYpnssx4H2TOyJi1Z9OKhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FDFF13D5;
	Fri,  9 Aug 2024 09:06:07 -0700 (PDT)
Received: from [10.57.46.232] (unknown [10.57.46.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80E923F71E;
	Fri,  9 Aug 2024 09:05:37 -0700 (PDT)
Message-ID: <506de4bc-8beb-4cd3-be2b-86de004d6129@arm.com>
Date: Fri, 9 Aug 2024 17:05:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
To: Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev,
 Alex Williamson <alex.williamson@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
References: <7-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <7-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-08-07 12:41 am, Jason Gunthorpe wrote:
> For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> as the parent and a user provided STE fragment that defines the CD table
> and related data with addresses translated by the S2 iommu_domain.
> 
> The kernel only permits userspace to control certain allowed bits of the
> STE that are safe for user/guest control.
> 
> IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> translation, but there is no way of knowing which S1 entries refer to a
> range of S2.
> 
> For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> flush all ASIDs from the VMID after flushing the S2 on any change to the
> S2.
> 
> Similarly we have to flush the entire ATC if the S2 is changed.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 211 +++++++++++++++++++-
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  20 ++
>   include/uapi/linux/iommufd.h                |  20 ++
>   3 files changed, 247 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 5faaccef707ef1..5dbaffd7937747 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
>   	case CMDQ_OP_TLBI_NH_ASID:
>   		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
>   		fallthrough;
> +	case CMDQ_OP_TLBI_NH_ALL:
>   	case CMDQ_OP_TLBI_S12_VMALL:
>   		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
>   		break;
> @@ -1640,6 +1641,59 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>   }
>   EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
>   
> +static void arm_smmu_make_nested_cd_table_ste(
> +	struct arm_smmu_ste *target, struct arm_smmu_master *master,
> +	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
> +{
> +	arm_smmu_make_s2_domain_ste(target, master, nested_domain->s2_parent,
> +				    ats_enabled);
> +
> +	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
> +				      FIELD_PREP(STRTAB_STE_0_CFG,
> +						 STRTAB_STE_0_CFG_NESTED)) |
> +			  (nested_domain->ste[0] & ~STRTAB_STE_0_CFG);
> +	target->data[1] |= nested_domain->ste[1];
> +}
> +
> +/*
> + * Create a physical STE from the virtual STE that userspace provided when it
> + * created the nested domain. Using the vSTE userspace can request:
> + * - Non-valid STE
> + * - Abort STE
> + * - Bypass STE (install the S2, no CD table)
> + * - CD table STE (install the S2 and the userspace CD table)
> + */
> +static void arm_smmu_make_nested_domain_ste(
> +	struct arm_smmu_ste *target, struct arm_smmu_master *master,
> +	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
> +{
> +	/*
> +	 * Userspace can request a non-valid STE through the nesting interface.
> +	 * We relay that into a non-valid physical STE with the intention that
> +	 * C_BAD_STE for this SID can be delivered to userspace.

NAK, that is a horrible idea. If userspace really wants to emulate that 
it can install a disabled S1 context or move the device to an empty s2 
domain, get translation faults signalled through the normal path, and 
synthesise C_BAD_STE for itself because it knows what it's done. 
Otherwise, how do you propose we would actually tell whether a real 
C_BAD_STE is due to a driver bug, an unknown device, or intentional 
(especially in cases like a surprise removal where we might have to 
transition directly from fake-invalid to real-invalid)?

Yes, userspace can spam up the event queue with translation/permission 
etc. faults, but those are at least clearly attributable and an expected 
part of normal operation; giving it free reign to spam up the event 
queue with what are currently considered *host kernel errors*, with no 
handling or mitigation, is another thing entirely.

> +	 */
> +	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
> +		memset(target, 0, sizeof(*target));
> +		return;
> +	}
> +
> +	switch (FIELD_GET(STRTAB_STE_0_CFG,
> +			  le64_to_cpu(nested_domain->ste[0]))) {
> +	case STRTAB_STE_0_CFG_S1_TRANS:
> +		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
> +						  ats_enabled);
> +		break;
> +	case STRTAB_STE_0_CFG_BYPASS:
> +		arm_smmu_make_s2_domain_ste(
> +			target, master, nested_domain->s2_parent, ats_enabled);
> +		break;
> +	case STRTAB_STE_0_CFG_ABORT:
> +	default:
> +		arm_smmu_make_abort_ste(target);
> +		break;
> +	}
> +}
> +
>   /*
>    * This can safely directly manipulate the STE memory without a sync sequence
>    * because the STE table has not been installed in the SMMU yet.
> @@ -2065,7 +2119,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
>   		if (!master->ats_enabled)
>   			continue;
>   
> -		arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, &cmd);
> +		if (master_domain->nested_parent) {
> +			/*
> +			 * If a S2 used as a nesting parent is changed we have
> +			 * no option but to completely flush the ATC.
> +			 */
> +			arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
> +		} else {
> +			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
> +						&cmd);
> +		}
>   
>   		for (i = 0; i < master->num_streams; i++) {
>   			cmd.atc.sid = master->streams[i].id;
> @@ -2192,6 +2255,16 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>   	}
>   	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
>   
> +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
> +	    smmu_domain->nesting_parent) {

Surely nesting_parent must never be set on anything other than S2 
domains in the first place?

> +		/*
> +		 * When the S2 domain changes all the nested S1 ASIDs have to be
> +		 * flushed too.
> +		 */
> +		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
> +		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
> +	}
> +
>   	/*
>   	 * Unfortunately, this can't be leaf-only since we may have
>   	 * zapped an entire table.
> @@ -2608,13 +2681,15 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
>   			    ioasid_t ssid)
>   {
>   	struct arm_smmu_master_domain *master_domain;
> +	bool nested_parent = smmu_domain->domain.type == IOMMU_DOMAIN_NESTED;
>   
>   	lockdep_assert_held(&smmu_domain->devices_lock);
>   
>   	list_for_each_entry(master_domain, &smmu_domain->devices,
>   			    devices_elm) {
>   		if (master_domain->master == master &&
> -		    master_domain->ssid == ssid)
> +		    master_domain->ssid == ssid &&
> +		    master_domain->nested_parent == nested_parent)

As if nested_parent vs. nesting parent wasn't bad enough, why would we 
need additional disambiguation here? How could more than one attachment 
to the same SID:SSID exist at the same time? How could we have a 
non-nested S1 attachment in a nested domain, or vice-versa, at all?

>   			return master_domain;
>   	}
>   	return NULL;
> @@ -2634,6 +2709,9 @@ to_smmu_domain_devices(struct iommu_domain *domain)
>   	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
>   	    domain->type == IOMMU_DOMAIN_SVA)
>   		return to_smmu_domain(domain);
> +	if (domain->type == IOMMU_DOMAIN_NESTED)
> +		return container_of(domain, struct arm_smmu_nested_domain,
> +				    domain)->s2_parent;
>   	return NULL;
>   }
>   
> @@ -2664,6 +2742,7 @@ struct arm_smmu_attach_state {
>   	struct iommu_domain *old_domain;
>   	struct arm_smmu_master *master;
>   	bool cd_needs_ats;
> +	bool disable_ats;
>   	ioasid_t ssid;
>   	/* Resulting state */
>   	bool ats_enabled;
> @@ -2716,7 +2795,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
>   		 * enabled if we have arm_smmu_domain, those always have page
>   		 * tables.
>   		 */
> -		state->ats_enabled = arm_smmu_ats_supported(master);
> +		state->ats_enabled = !state->disable_ats &&
> +				     arm_smmu_ats_supported(master);
>   	}
>   
>   	if (smmu_domain) {
> @@ -2725,6 +2805,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
>   			return -ENOMEM;
>   		master_domain->master = master;
>   		master_domain->ssid = state->ssid;
> +		master_domain->nested_parent = new_domain->type ==
> +					       IOMMU_DOMAIN_NESTED;
>   
>   		/*
>   		 * During prepare we want the current smmu_domain and new
> @@ -3097,6 +3179,122 @@ static struct iommu_domain arm_smmu_blocked_domain = {
>   	.ops = &arm_smmu_blocked_ops,
>   };
>   
> +static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
> +				      struct device *dev)
> +{
> +	struct arm_smmu_nested_domain *nested_domain =
> +		container_of(domain, struct arm_smmu_nested_domain, domain);
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct arm_smmu_attach_state state = {
> +		.master = master,
> +		.old_domain = iommu_get_domain_for_dev(dev),
> +		.ssid = IOMMU_NO_PASID,
> +		/* Currently invalidation of ATC is not supported */
> +		.disable_ats = true,
> +	};
> +	struct arm_smmu_ste ste;
> +	int ret;
> +
> +	if (arm_smmu_ssids_in_use(&master->cd_table) ||
> +	    nested_domain->s2_parent->smmu != master->smmu)
> +		return -EINVAL;
> +
> +	mutex_lock(&arm_smmu_asid_lock);
> +	ret = arm_smmu_attach_prepare(&state, domain);
> +	if (ret) {
> +		mutex_unlock(&arm_smmu_asid_lock);
> +		return ret;
> +	}
> +
> +	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
> +					state.ats_enabled);
> +	arm_smmu_install_ste_for_dev(master, &ste);
> +	arm_smmu_attach_commit(&state);
> +	mutex_unlock(&arm_smmu_asid_lock);
> +	return 0;
> +}
> +
> +static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
> +{
> +	kfree(container_of(domain, struct arm_smmu_nested_domain, domain));
> +}
> +
> +static const struct iommu_domain_ops arm_smmu_nested_ops = {
> +	.attach_dev = arm_smmu_attach_dev_nested,
> +	.free = arm_smmu_domain_nested_free,
> +};
> +
> +static struct iommu_domain *
> +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> +			      struct iommu_domain *parent,
> +			      const struct iommu_user_data *user_data)
> +{
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> +	struct arm_smmu_nested_domain *nested_domain;
> +	struct arm_smmu_domain *smmu_parent;
> +	struct iommu_hwpt_arm_smmuv3 arg;
> +	unsigned int eats;
> +	unsigned int cfg;
> +	int ret;
> +
> +	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	/*
> +	 * Must support some way to prevent the VM from bypassing the cache
> +	 * because VFIO currently does not do any cache maintenance.
> +	 */
> +	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
> +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	ret = iommu_copy_struct_from_user(&arg, user_data,
> +					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_TRANS_S1))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
> +		return ERR_PTR(-EINVAL);
> +
> +	smmu_parent = to_smmu_domain(parent);
> +	if (smmu_parent->stage != ARM_SMMU_DOMAIN_S2 ||
> +	    smmu_parent->smmu != master->smmu)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* EIO is reserved for invalid STE data. */
> +	if ((arg.ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
> +	    (arg.ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
> +		return ERR_PTR(-EIO);
> +
> +	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg.ste[0]));
> +	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
> +	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
> +		return ERR_PTR(-EIO);
> +
> +	eats = FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(arg.ste[1]));
> +	if (eats != STRTAB_STE_1_EATS_ABT)
> +		return ERR_PTR(-EIO);
> +
> +	if (cfg != STRTAB_STE_0_CFG_S1_TRANS)
> +		eats = STRTAB_STE_1_EATS_ABT;
> +
> +	nested_domain = kzalloc(sizeof(*nested_domain), GFP_KERNEL_ACCOUNT);
> +	if (!nested_domain)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nested_domain->domain.type = IOMMU_DOMAIN_NESTED;
> +	nested_domain->domain.ops = &arm_smmu_nested_ops;
> +	nested_domain->s2_parent = smmu_parent;
> +	nested_domain->ste[0] = arg.ste[0];
> +	nested_domain->ste[1] = arg.ste[1] & ~cpu_to_le64(STRTAB_STE_1_EATS);
> +
> +	return &nested_domain->domain;
> +}
> +
>   static struct iommu_domain *
>   arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>   			   struct iommu_domain *parent,
> @@ -3108,9 +3306,13 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>   	struct arm_smmu_domain *smmu_domain;
>   	int ret;
>   
> +	if (parent)
> +		return arm_smmu_domain_alloc_nesting(dev, flags, parent,
> +						     user_data);
> +
>   	if (flags & ~PAGING_FLAGS)
>   		return ERR_PTR(-EOPNOTSUPP);
> -	if (parent || user_data)
> +	if (user_data)
>   		return ERR_PTR(-EOPNOTSUPP);
>   
>   	smmu_domain = arm_smmu_domain_alloc();
> @@ -3123,6 +3325,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>   			goto err_free;
>   		}
>   		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> +		smmu_domain->nesting_parent = true;
>   	}
>   
>   	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 58cd405652e06a..e149eddb568e7e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -240,6 +240,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
>   #define STRTAB_STE_0_CFG_BYPASS		4
>   #define STRTAB_STE_0_CFG_S1_TRANS	5
>   #define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_NESTED		7
>   
>   #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
>   #define STRTAB_STE_0_S1FMT_LINEAR	0
> @@ -291,6 +292,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
>   
>   #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
>   
> +/* These bits can be controlled by userspace for STRTAB_STE_0_CFG_NESTED */
> +#define STRTAB_STE_0_NESTING_ALLOWED                                         \
> +	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
> +		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
> +#define STRTAB_STE_1_NESTING_ALLOWED                            \
> +	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
> +		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
> +		    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_EATS)
> +
>   /*
>    * Context descriptors.
>    *
> @@ -508,6 +518,7 @@ struct arm_smmu_cmdq_ent {
>   			};
>   		} cfgi;
>   
> +		#define CMDQ_OP_TLBI_NH_ALL     0x10
>   		#define CMDQ_OP_TLBI_NH_ASID	0x11
>   		#define CMDQ_OP_TLBI_NH_VA	0x12
>   		#define CMDQ_OP_TLBI_EL2_ALL	0x20
> @@ -792,6 +803,14 @@ struct arm_smmu_domain {
>   	u8				enforce_cache_coherency;
>   
>   	struct mmu_notifier		mmu_notifier;
> +	bool				nesting_parent : 1;

Erm, please use bool consistently, or use integer bitfields 
consistently, but not a deranged mess of bool bitfields while also 
assigning true/false to full u8s... :/

Thanks,
Robin.

> +};
> +
> +struct arm_smmu_nested_domain {
> +	struct iommu_domain domain;
> +	struct arm_smmu_domain *s2_parent;
> +
> +	__le64 ste[2];
>   };
>   
>   /* The following are exposed for testing purposes. */
> @@ -830,6 +849,7 @@ struct arm_smmu_master_domain {
>   	struct list_head devices_elm;
>   	struct arm_smmu_master *master;
>   	ioasid_t ssid;
> +	u8 nested_parent;
>   };
>   
>   static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 83b6e1cd338d8f..76e9ad6c9403af 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -394,14 +394,34 @@ struct iommu_hwpt_vtd_s1 {
>   	__u32 __reserved;
>   };
>   
> +/**
> + * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
> + *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
> + *
> + * @ste: The first two double words of the user space Stream Table Entry for
> + *       a user stage-1 Context Descriptor Table. Must be little-endian.
> + *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
> + *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
> + *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
> + *
> + * -EIO will be returned if @ste is not legal or contains any non-allowed field.
> + * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
> + * nested domain will translate the same as the nesting parent.
> + */
> +struct iommu_hwpt_arm_smmuv3 {
> +	__aligned_le64 ste[2];
> +};
> +
>   /**
>    * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
>    * @IOMMU_HWPT_DATA_NONE: no data
>    * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
> + * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
>    */
>   enum iommu_hwpt_data_type {
>   	IOMMU_HWPT_DATA_NONE = 0,
>   	IOMMU_HWPT_DATA_VTD_S1 = 1,
> +	IOMMU_HWPT_DATA_ARM_SMMUV3 = 2,
>   };
>   
>   /**

