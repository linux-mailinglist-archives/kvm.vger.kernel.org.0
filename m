Return-Path: <kvm+bounces-30061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B919B692F
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE9EDB2289E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B47214424;
	Wed, 30 Oct 2024 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mr+W9Dej"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F36D2141B7
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305774; cv=none; b=BMscs0cOg8vLe0sw/4hgdynm/KrpMdvBaV5YtMbP8zK5Vdxo0NqVsgd5yqv4vLWJ1BDzaXxmqOkGQDxyIsCry5wHNdJCEtKtXo6Gset7dBnVEy7DtiuoUjzHLqOibxaB4WdD9oxA94zO2/vkNImZbC2mE/UaSuuXMouypC0MUUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305774; c=relaxed/simple;
	bh=md1HBRYmrYuVJq4LtV4huZbaYK/2NBkeE53jf9sL7Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzktXZonGu/8d/J84ZCsOrjdyZNfK15cGGmAPnLR3OgeAGVhArhkpNZtaj5se/ocAimPGKM4pdvFUXfp6L7cFqZoTn5Qam3t/vLV4LbSaPxFYdd1Wz/60PEcDvx5myc04dmTTQcXoT+UK3bWFdWiaQwmenjXf0T5G52mYH/s3d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mr+W9Dej; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so305e9.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 09:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730305770; x=1730910570; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N+b8KRc5zmIDoFCouEIsaDpmzreD1wdS/csixNpC9nU=;
        b=mr+W9DejmyuiOnfPHvzSVyBjVENHiXY6SLpz4t8kXTyXq65HJh35GBXk86mUeBvtoi
         QfWXBnRO1jDg2tg6hmCa4pJ+XUUraeKbTVBmYdZuiWiLe2uT9SINRLwCywBG9HYb1S32
         7Fk7xNPcEJDN6R8EGU3rtCRS4Jj9Ls1hHj5mpRQktKUez+vD+DAd8SvwjMh4uCtlpAh9
         VgEWYAxvW7rTKF/rFv8i7mkvaqppeCTqqVr1VIExMAo7+G/s2gPNc4BK2DStqDqU2iuj
         RPQJmoQXA7AAWtrEjy4DOmZzY2++9eW7EtG+I4mKnF2f2oQqFFIGj1w0kZBB32rRMrZe
         5U8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730305770; x=1730910570;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+b8KRc5zmIDoFCouEIsaDpmzreD1wdS/csixNpC9nU=;
        b=LPVDFXnB26nWPmmcw1e8+6cbe1z4yynwV9OVOjH8XKgrfpMRp4LseVxzahrcCTwU2K
         Bfrr62/uaJd7cjdTYnKFH73+Uf9vhs3+q+o/g8QE+VNpXIj65fHoJONPYN6Np60u8B5W
         SoSlqkAlOXrR4AdcXKgGDi+K9aV5qgRJMdDJmqp8lC0MU9tT/Zfw+DtLd8x0zKKmqdZ0
         6/pa0XkrIaImj9p51a5TsMkDZ26M4Fij4zq1c/+nWkQMVapjKjUgszOQ2KQ+Haj1NoX5
         ScIxaYMAwvWUYNzwrXpJh5TJjaZ5ONYUEEqAZqCZCbxbPtPnmWnR6km0Divk2tDuw8zW
         cxrg==
X-Forwarded-Encrypted: i=1; AJvYcCVboAEEv247LhZdcCmM7SVZ/l74RQgqD1ImhOr1T/bJDJHqErH56QdzFMeRnotT48yKGao=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTue6enGoh7QrA/4iGYmjmJn7rOZjzSWUohaZgCvcSoRvwDecd
	7NDOIWquLVidysaNDEXxyOrw4dZCMwM3GeKSzOhvjVOXN1O+jLyXcUBYHZTUiA==
X-Gm-Gg: ASbGncu3+Y4eG+64MxmK9/iIENECC7V9kpVLXsVridkhLS9pIjwhcM3MXSNr1Eh6rWy
	4HpkqDzrqwfH7UZPs4kpxqCNlzLZiLv8mJ+Rx/HnV5JGdswP8+3c4Xd0ZHYuJqwJAvpKFciDPpr
	/IsN3F7VB9WvKRs4iYGlxur2pZqNM1FdqsPyeBqehyFsnKnICqeqOyeJHcbOj4scDgjU1uQREQP
	K2rRQPclS21ri1ZkPkbqs0G6z6zTk5oKZzX8t7cqwFKlQSsH6R7aMPZlo4oh/Jz0vm9nPkWEnl/
	cc60D78xkg==
X-Google-Smtp-Source: AGHT+IGdZE3KcqRXG596l1/z6mb5HgBOV8QBFXKlVU+7il4yIkzpxSGgNuKMW+f0EJ4DryrcypqYxA==
X-Received: by 2002:a05:600c:34d1:b0:426:7018:2e2f with SMTP id 5b1f17b1804b1-431b4a39c00mr10289735e9.5.1730305769736;
        Wed, 30 Oct 2024 09:29:29 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd917fa7sm25675115e9.18.2024.10.30.09.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 09:29:28 -0700 (PDT)
Date: Wed, 30 Oct 2024 16:29:24 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <ZyJe5M4_DHl37PTr@google.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Wed, Oct 09, 2024 at 01:23:14PM -0300, Jason Gunthorpe wrote:
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
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 172 ++++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  25 ++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  37 ++++
>  include/uapi/linux/iommufd.h                  |  20 ++
>  4 files changed, 250 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> index 3d2671031c9bb5..a9aa7514e65ce4 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -29,3 +29,175 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
>  
>  	return info;
>  }
> +
> +static void arm_smmu_make_nested_cd_table_ste(
> +	struct arm_smmu_ste *target, struct arm_smmu_master *master,
> +	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
> +{
> +	arm_smmu_make_s2_domain_ste(target, master, nested_domain->s2_parent,
> +				    ats_enabled);
> +
> +	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
> +				      FIELD_PREP(STRTAB_STE_0_CFG,
> +						 STRTAB_STE_0_CFG_NESTED));
> +	target->data[0] |= nested_domain->ste[0] &
> +			   ~cpu_to_le64(STRTAB_STE_0_CFG);
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
> +	unsigned int cfg =
> +		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(nested_domain->ste[0]));
> +
> +	/*
> +	 * Userspace can request a non-valid STE through the nesting interface.
> +	 * We relay that into an abort physical STE with the intention that
> +	 * C_BAD_STE for this SID can be generated to userspace.
> +	 */
> +	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +		cfg = STRTAB_STE_0_CFG_ABORT;
> +
> +	switch (cfg) {
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
> +static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
> +				      struct device *dev)
> +{
> +	struct arm_smmu_nested_domain *nested_domain =
> +		to_smmu_nested_domain(domain);
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
> +	if (nested_domain->s2_parent->smmu != master->smmu)
> +		return -EINVAL;
> +	if (arm_smmu_ssids_in_use(&master->cd_table))
> +		return -EBUSY;
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
> +	kfree(to_smmu_nested_domain(domain));
> +}
> +
> +static const struct iommu_domain_ops arm_smmu_nested_ops = {
> +	.attach_dev = arm_smmu_attach_dev_nested,
> +	.free = arm_smmu_domain_nested_free,
> +};
> +
> +static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg)
> +{
> +	unsigned int cfg;
> +
> +	if (!(arg->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
> +		memset(arg->ste, 0, sizeof(arg->ste));
> +		return 0;
> +	}
> +
> +	/* EIO is reserved for invalid STE data. */
> +	if ((arg->ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
> +	    (arg->ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
> +		return -EIO;
> +
> +	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg->ste[0]));
> +	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
> +	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
> +		return -EIO;
> +	return 0;
> +}
> +
> +struct iommu_domain *
> +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> +			      struct iommu_domain *parent,
> +			      const struct iommu_user_data *user_data)
> +{
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct arm_smmu_nested_domain *nested_domain;
> +	struct arm_smmu_domain *smmu_parent;
> +	struct iommu_hwpt_arm_smmuv3 arg;
> +	int ret;
> +
> +	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_NESTING))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	/*
> +	 * Must support some way to prevent the VM from bypassing the cache
> +	 * because VFIO currently does not do any cache maintenance.
> +	 */
> +	if (!arm_smmu_master_canwbs(master))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	/*
> +	 * The core code checks that parent was created with
> +	 * IOMMU_HWPT_ALLOC_NEST_PARENT
> +	 */
> +	smmu_parent = to_smmu_domain(parent);
> +	if (smmu_parent->smmu != master->smmu)
> +		return ERR_PTR(-EINVAL);
> +
> +	ret = iommu_copy_struct_from_user(&arg, user_data,
> +					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	ret = arm_smmu_validate_vste(&arg);
> +	if (ret)
> +		return ERR_PTR(ret);
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
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b4b03206afbf48..eb401a4adfedc8 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
>  	case CMDQ_OP_TLBI_NH_ASID:
>  		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
>  		fallthrough;
> +	case CMDQ_OP_TLBI_NH_ALL:
>  	case CMDQ_OP_TLBI_S12_VMALL:
>  		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
>  		break;
> @@ -2230,6 +2231,15 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>  	}
>  	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
>  
> +	if (smmu_domain->nest_parent) {

Do we need a sync between the 2 invalidations to order them?

> +		/*
> +		 * When the S2 domain changes all the nested S1 ASIDs have to be
> +		 * flushed too.
> +		 */
> +		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
> +		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
> +	}
> +
>  	/*
>  	 * Unfortunately, this can't be leaf-only since we may have
>  	 * zapped an entire table.
> @@ -2614,8 +2624,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
>  
>  static struct arm_smmu_master_domain *
>  arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
> -			    struct arm_smmu_master *master,
> -			    ioasid_t ssid)
> +			    struct arm_smmu_master *master, ioasid_t ssid)
>  {
>  	struct arm_smmu_master_domain *master_domain;
>  
> @@ -2644,6 +2653,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
>  	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
>  	    domain->type == IOMMU_DOMAIN_SVA)
>  		return to_smmu_domain(domain);
> +	if (domain->type == IOMMU_DOMAIN_NESTED)
> +		return to_smmu_nested_domain(domain)->s2_parent;
>  	return NULL;
>  }
>  
> @@ -2716,7 +2727,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
>  		 * enabled if we have arm_smmu_domain, those always have page
>  		 * tables.
>  		 */
> -		state->ats_enabled = arm_smmu_ats_supported(master);
> +		state->ats_enabled = !state->disable_ats &&
> +				     arm_smmu_ats_supported(master);
>  	}
>  
>  	if (smmu_domain) {
> @@ -3107,9 +3119,13 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  	struct arm_smmu_domain *smmu_domain;
>  	int ret;
>  
> +	if (parent)
> +		return arm_smmu_domain_alloc_nesting(dev, flags, parent,
> +						     user_data);
> +
>  	if (flags & ~PAGING_FLAGS)
>  		return ERR_PTR(-EOPNOTSUPP);
> -	if (parent || user_data)
> +	if (user_data)
>  		return ERR_PTR(-EOPNOTSUPP);
>  
>  	smmu_domain = arm_smmu_domain_alloc();
> @@ -3122,6 +3138,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  			goto err_free;
>  		}
>  		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> +		smmu_domain->nest_parent = true;
>  	}
>  
>  	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index c9e5290e995a64..b5dbf5acbfc4db 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -243,6 +243,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
>  #define STRTAB_STE_0_CFG_BYPASS		4
>  #define STRTAB_STE_0_CFG_S1_TRANS	5
>  #define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_NESTED		7
>  
>  #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
>  #define STRTAB_STE_0_S1FMT_LINEAR	0
> @@ -294,6 +295,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
>  
>  #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
>  
> +/* These bits can be controlled by userspace for STRTAB_STE_0_CFG_NESTED */
> +#define STRTAB_STE_0_NESTING_ALLOWED                                         \
> +	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
> +		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
> +#define STRTAB_STE_1_NESTING_ALLOWED                            \
> +	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
> +		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
> +		    STRTAB_STE_1_S1STALLD)
> +
>  /*
>   * Context descriptors.
>   *
> @@ -513,6 +523,7 @@ struct arm_smmu_cmdq_ent {
>  			};
>  		} cfgi;
>  
> +		#define CMDQ_OP_TLBI_NH_ALL     0x10
>  		#define CMDQ_OP_TLBI_NH_ASID	0x11
>  		#define CMDQ_OP_TLBI_NH_VA	0x12
>  		#define CMDQ_OP_TLBI_EL2_ALL	0x20
> @@ -814,10 +825,18 @@ struct arm_smmu_domain {
>  	struct list_head		devices;
>  	spinlock_t			devices_lock;
>  	bool				enforce_cache_coherency : 1;
> +	bool				nest_parent : 1;
>  
>  	struct mmu_notifier		mmu_notifier;
>  };
>  
> +struct arm_smmu_nested_domain {
> +	struct iommu_domain domain;
> +	struct arm_smmu_domain *s2_parent;
> +
> +	__le64 ste[2];
> +};
> +
>  /* The following are exposed for testing purposes. */
>  struct arm_smmu_entry_writer_ops;
>  struct arm_smmu_entry_writer {
> @@ -862,6 +881,12 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
>  	return container_of(dom, struct arm_smmu_domain, domain);
>  }
>  
> +static inline struct arm_smmu_nested_domain *
> +to_smmu_nested_domain(struct iommu_domain *dom)
> +{
> +	return container_of(dom, struct arm_smmu_nested_domain, domain);
> +}
> +
>  extern struct xarray arm_smmu_asid_xa;
>  extern struct mutex arm_smmu_asid_lock;
>  
> @@ -908,6 +933,7 @@ struct arm_smmu_attach_state {
>  	struct iommu_domain *old_domain;
>  	struct arm_smmu_master *master;
>  	bool cd_needs_ats;
> +	bool disable_ats;
>  	ioasid_t ssid;
>  	/* Resulting state */
>  	bool ats_enabled;
> @@ -978,8 +1004,19 @@ tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
>  
>  #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
>  void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
> +struct iommu_domain *
> +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> +			      struct iommu_domain *parent,
> +			      const struct iommu_user_data *user_data);
>  #else
>  #define arm_smmu_hw_info NULL
> +static inline struct iommu_domain *
> +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> +			      struct iommu_domain *parent,
> +			      const struct iommu_user_data *user_data)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
>  #endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
>  
>  #endif /* _ARM_SMMU_V3_H */
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index b5c94fecb94ca5..cd4920886ad05e 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -394,14 +394,34 @@ struct iommu_hwpt_vtd_s1 {
>  	__u32 __reserved;
>  };
>  
> +/**
> + * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
> + *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
> + *

That’s supposed to be stream table?

Thanks,
Mostafa

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
>  /**
>   * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
>   * @IOMMU_HWPT_DATA_NONE: no data
>   * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
> + * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
>   */
>  enum iommu_hwpt_data_type {
>  	IOMMU_HWPT_DATA_NONE = 0,
>  	IOMMU_HWPT_DATA_VTD_S1 = 1,
> +	IOMMU_HWPT_DATA_ARM_SMMUV3 = 2,
>  };
>  
>  /**
> -- 
> 2.46.2
> 

