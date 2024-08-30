Return-Path: <kvm+bounces-25546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA61966684
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 18:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41CF11C20E17
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD46A1B8E86;
	Fri, 30 Aug 2024 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x2zsznKX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32F11B81AB
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725034154; cv=none; b=ogPEY3oT7bp5YGrE4lQRkUkF3Uw5FO1UPBp4ilvX1pNoUe3jdeTAVO9Od1GWNE0wTAviALnjQtuP2u/HZ6tPrskvWbM5C0XksvWOJlIDhO/EjgqkHYHPB6zHpcjQ4EpWdKqYVdcFtOaoQ1A/CXJHns74of9JraMLOxiY01WFYYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725034154; c=relaxed/simple;
	bh=7rBQFpn3FjGjlRb5BTY+59xG7djlagD94WOjLBNAm9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qyA7/JYjLBDKn/jk+VArpdcxp5qpMia3KVPCkcYsdnHTXQ+XaZvAqxdRxfX8x2Lq/k98CMHA1wPfGbMIEpDyviZCXUJt9pNxix2s6P1Mx9bNhPBFXUH5hYRUCEhc7iN4YOzuF1EVKwG/6sqmh6ISmKEBjWdvCwbPP8eShd9v+oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x2zsznKX; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-429d1a9363aso57045e9.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 09:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725034149; x=1725638949; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vv0fuL087x3MhC6ya2Rf+1FppafAgNLtVp021iq6Ns4=;
        b=x2zsznKXbHry+uedc9A7K3jUQWxb3hrY5jrcEh9maUqVgQcxbUQzHqVUYT9Slqjl3g
         1vheQbFIM43l/YoPydnmmcuzMSjWahu9Jer5xXU7cyr1DuQJ4peCmarWLDAjwXFrry8r
         uuowzGftf+CebQ7O3UA1GWpsBpyH3GxWbZPOlP+Uu10hPCWeRseXNT8B307tRQtgbdH1
         sMPODdRieUUZKWFVPOqqAjHqo6LRpjDCk+UFbgMo9L1rgVuWpgdeJKvanLmU5fnJUg/w
         GTOfuIo1aQ/09k2ob8l5/w7ZjRCz+/EPJFwWFOeRCkiF66tZAD72mZ+ILRsQkm093dA1
         5JSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725034149; x=1725638949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vv0fuL087x3MhC6ya2Rf+1FppafAgNLtVp021iq6Ns4=;
        b=FmXPUEOacWJ6OSPU46gZWD4uzaiPj0o2GFzJwJDtTW/aPnOib42io1ih5WsUslhM3R
         Fc0GwACyRV5bhfn7nlbwngrNESM9ryPEy3r/alPVTf2Q4jyxYtoSXCcyK+54HrgYR3mv
         BqAWx6MyFP+lI0VbxfeKDPnXm8xCmranJO7T/u5FG7leAPCuw1VWZhL4a2gNSYLtr82r
         BkvHZdYiTJdryGc2PZ+yhM/OdRaG+nWkbefFGnK1Obs5AtcLB+gIwDP60TJHoLwbtDeg
         FnS3bBI0DbJg5prabOLQ1/vgkgZEcjfXoxxcjGaJ8lDi8G7xDBn4s1xWrnLIj/cSeZWn
         KqMQ==
X-Forwarded-Encrypted: i=1; AJvYcCX308WlHyinzNxwewhAhEXQTd7a/pWL2Ber23UeP5v3xGkvwI0uWIAOS181NQ05v8QJPG8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjp/5onFJ5Gq3mwKj2yBFZ0ruP9lV/wlL1Tn8h2LstmuBwNJJZ
	l5P26h2gDUG0EcP3GEiomzdY+JU38/JYZqP1YQ4ZThqwoNSu1hIw6C08343E3g==
X-Google-Smtp-Source: AGHT+IFDKw+hmg6UDKgRNwErXouL/84n0xlJsA/x2jAYR4WonwLW5J8HQmXP4JmIMEjB7oqEYgQQ2Q==
X-Received: by 2002:a05:600c:b91:b0:426:66a0:6df6 with SMTP id 5b1f17b1804b1-42bba7e2adbmr1505105e9.0.1725034148699;
        Fri, 30 Aug 2024 09:09:08 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4abe4sm4388376f8f.17.2024.08.30.09.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 09:09:08 -0700 (PDT)
Date: Fri, 30 Aug 2024 16:09:04 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <ZtHuoDWbe54H1nhZ@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 27, 2024 at 12:51:38PM -0300, Jason Gunthorpe wrote:
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

I am still reviewing this patch, but just some quick questions.

1) How does userspace do IOTLB maintenance for S1 in that case?

2) Is there a reason the UAPI is designed this way?
The way I imagined this, is that userspace will pass the pointer to the CD
(+ format) not the STE (or part of it).
Making user space messing with shareability and cacheability of S1 CD access
feels odd. (Although CD configure page table access which is similar).

Thanks,
Mostafa

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 217 +++++++++++++++++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  20 ++
>  include/uapi/linux/iommufd.h                |  20 ++
>  3 files changed, 250 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 8db3db6328f8b7..a21dce1f25cb95 100644
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
> @@ -1640,6 +1641,59 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>  }
>  EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
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
> +	 * We relay that into an abort physical STE with the intention that
> +	 * C_BAD_STE for this SID can be generated to userspace.
> +	 */
> +	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
> +		arm_smmu_make_abort_ste(target);
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
>  /*
>   * This can safely directly manipulate the STE memory without a sync sequence
>   * because the STE table has not been installed in the SMMU yet.
> @@ -2065,7 +2119,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
>  		if (!master->ats_enabled)
>  			continue;
>  
> -		arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, &cmd);
> +		if (master_domain->nest_parent) {
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
>  		for (i = 0; i < master->num_streams; i++) {
>  			cmd.atc.sid = master->streams[i].id;
> @@ -2192,6 +2255,16 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>  	}
>  	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
>  
> +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
> +	    smmu_domain->nest_parent) {
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
> @@ -2604,8 +2677,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
>  
>  static struct arm_smmu_master_domain *
>  arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
> -			    struct arm_smmu_master *master,
> -			    ioasid_t ssid)
> +			    struct arm_smmu_master *master, ioasid_t ssid,
> +			    bool nest_parent)
>  {
>  	struct arm_smmu_master_domain *master_domain;
>  
> @@ -2614,7 +2687,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
>  	list_for_each_entry(master_domain, &smmu_domain->devices,
>  			    devices_elm) {
>  		if (master_domain->master == master &&
> -		    master_domain->ssid == ssid)
> +		    master_domain->ssid == ssid &&
> +		    master_domain->nest_parent == nest_parent)
>  			return master_domain;
>  	}
>  	return NULL;
> @@ -2634,6 +2708,9 @@ to_smmu_domain_devices(struct iommu_domain *domain)
>  	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
>  	    domain->type == IOMMU_DOMAIN_SVA)
>  		return to_smmu_domain(domain);
> +	if (domain->type == IOMMU_DOMAIN_NESTED)
> +		return container_of(domain, struct arm_smmu_nested_domain,
> +				    domain)->s2_parent;
>  	return NULL;
>  }
>  
> @@ -2649,7 +2726,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
>  		return;
>  
>  	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
> +	master_domain = arm_smmu_find_master_domain(
> +		smmu_domain, master, ssid, domain->type == IOMMU_DOMAIN_NESTED);
>  	if (master_domain) {
>  		list_del(&master_domain->devices_elm);
>  		kfree(master_domain);
> @@ -2664,6 +2742,7 @@ struct arm_smmu_attach_state {
>  	struct iommu_domain *old_domain;
>  	struct arm_smmu_master *master;
>  	bool cd_needs_ats;
> +	bool disable_ats;
>  	ioasid_t ssid;
>  	/* Resulting state */
>  	bool ats_enabled;
> @@ -2716,7 +2795,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
>  		 * enabled if we have arm_smmu_domain, those always have page
>  		 * tables.
>  		 */
> -		state->ats_enabled = arm_smmu_ats_supported(master);
> +		state->ats_enabled = !state->disable_ats &&
> +				     arm_smmu_ats_supported(master);
>  	}
>  
>  	if (smmu_domain) {
> @@ -2725,6 +2805,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
>  			return -ENOMEM;
>  		master_domain->master = master;
>  		master_domain->ssid = state->ssid;
> +		master_domain->nest_parent = new_domain->type ==
> +					       IOMMU_DOMAIN_NESTED;
>  
>  		/*
>  		 * During prepare we want the current smmu_domain and new
> @@ -3097,6 +3179,122 @@ static struct iommu_domain arm_smmu_blocked_domain = {
>  	.ops = &arm_smmu_blocked_ops,
>  };
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
>  static struct iommu_domain *
>  arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  			   struct iommu_domain *parent,
> @@ -3108,9 +3306,13 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
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
> @@ -3123,6 +3325,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  			goto err_free;
>  		}
>  		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> +		smmu_domain->nest_parent = true;
>  	}
>  
>  	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 4b05c81b181a82..b563cfedf22e91 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -240,6 +240,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
>  #define STRTAB_STE_0_CFG_BYPASS		4
>  #define STRTAB_STE_0_CFG_S1_TRANS	5
>  #define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_NESTED		7
>  
>  #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
>  #define STRTAB_STE_0_S1FMT_LINEAR	0
> @@ -291,6 +292,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
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
> +		    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_EATS)
> +
>  /*
>   * Context descriptors.
>   *
> @@ -508,6 +518,7 @@ struct arm_smmu_cmdq_ent {
>  			};
>  		} cfgi;
>  
> +		#define CMDQ_OP_TLBI_NH_ALL     0x10
>  		#define CMDQ_OP_TLBI_NH_ASID	0x11
>  		#define CMDQ_OP_TLBI_NH_VA	0x12
>  		#define CMDQ_OP_TLBI_EL2_ALL	0x20
> @@ -790,10 +801,18 @@ struct arm_smmu_domain {
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
> @@ -830,6 +849,7 @@ struct arm_smmu_master_domain {
>  	struct list_head devices_elm;
>  	struct arm_smmu_master *master;
>  	ioasid_t ssid;
> +	u8 nest_parent;
>  };
>  
>  static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 83b6e1cd338d8f..76e9ad6c9403af 100644
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
> 2.46.0
> 

