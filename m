Return-Path: <kvm+bounces-25259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4F5962A49
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51FC9B21320
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4CE19AD7E;
	Wed, 28 Aug 2024 14:32:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9224A1BC20;
	Wed, 28 Aug 2024 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855546; cv=none; b=pYi2Aok7HWcu4p2BqDs95bbXq/+oACBKS+oE8XAP4ghDwf/Jz3Y4k24e9uhL5279k0C+yb3ElaYdozffjVRK+u4KeAfvAMw4ZtGYcUF45ErQnRU1i/UPD04/+J9H+4pK8H7s1A9OrzAylg3dU27ab3LYIRNAjbIs+99SUhxGemo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855546; c=relaxed/simple;
	bh=Nz00Nh1OPekSP/JZVlLibawscnLN8fPc8jFtEbuR4aQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byJspjYpzKBwXQuT43+e3xx7vfp0NMDdiLy9Lr6kYioR6+GpCjrh0a8t/x4I/Y7wvYvjLUxtjzD3bUh0dYCYuEG3fQ3sONiBZybKAAwub6jYQlAcrXPdEwReaZZ6uP0/Gx+UWX9Tp7RfUXrcSrAZ9mqgV/Dzbyq6RpPNDhT7t9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wv6H45fktz6H7nv;
	Wed, 28 Aug 2024 22:29:04 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 257151400DB;
	Wed, 28 Aug 2024 22:32:21 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 28 Aug
 2024 15:32:20 +0100
Date: Wed, 28 Aug 2024 15:32:19 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Alexey Kardashevskiy <aik@amd.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Michael Roth" <michael.roth@amd.com>, Alexander
 Graf <agraf@suse.de>, "Nikunj A Dadhania" <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, "Lukas Wunner" <lukas@wunner.de>
Subject: Re: [RFC PATCH 06/21] crypto: ccp: Enable SEV-TIO feature in the
 PSP when supported
Message-ID: <20240828153219.00004a7b@Huawei.com>
In-Reply-To: <20240823132137.336874-7-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
	<20240823132137.336874-7-aik@amd.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Aug 2024 23:21:20 +1000
Alexey Kardashevskiy <aik@amd.com> wrote:

> The PSP advertises the SEV-TIO support via the FEATURE_INFO command
> support of which is advertised via SNP_PLATFORM_STATUS.
> 
> Add FEATURE_INFO and use it to detect the TIO support in the PSP.
> If present, enable TIO in the SNP_INIT_EX call.
> 
> While at this, add new bits to sev_data_snp_init_ex() from SEV-SNP 1.55.
> 
> Note that this tests the PSP firmware support but not if the feature
> is enabled in the BIOS.
> 
> While at this, add new sev_data_snp_shutdown_ex::x86_snp_shutdown
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
I was curious so had a read.
Some minor comments inline.

Jonathan

> ---
>  include/linux/psp-sev.h      | 31 ++++++++-
>  include/uapi/linux/psp-sev.h |  4 +-
>  drivers/crypto/ccp/sev-dev.c | 73 ++++++++++++++++++++
>  3 files changed, 104 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 52d5ee101d3a..1d63044f66be 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
>  	SEV_CMD_MAX,
>  };
> @@ -584,6 +585,25 @@ struct sev_data_snp_addr {
>  	u64 address;				/* In/Out */
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_feature_info - SEV_CMD_SNP_FEATURE_INFO command params
> + *
> + * @len: length of this struct
> + * @ecx_in: subfunction index of CPUID Fn8000_0024
> + * @feature_info_paddr: physical address of a page with sev_snp_feature_info
> + */

Comment seems to have drifted away from the structure.

> +#define SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO	1
> +
> +struct sev_snp_feature_info {
> +	u32 eax, ebx, ecx, edx;			/* Out */
> +} __packed;
> +
> +struct sev_data_snp_feature_info {
> +	u32 length;				/* In */
> +	u32 ecx_in;				/* In */
> +	u64 feature_info_paddr;			/* In */
> +} __packed;
> +

>  /**
> @@ -787,7 +811,8 @@ struct sev_data_range_list {
>  struct sev_data_snp_shutdown_ex {
>  	u32 len;
>  	u32 iommu_snp_shutdown:1;
> -	u32 rsvd1:31;
> +	u32 x86_snp_shutdown:1;

Has docs that want updating I think.

> +	u32 rsvd1:30;
>  } __packed;
>  
>  /**

> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f6eafde584d9..a49fe54b8dd8 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)

> +static int snp_feature_info_locked(struct sev_device *sev, u32 ecx,
> +				   struct sev_snp_feature_info *fi, int *psp_ret)
> +{
> +	struct sev_data_snp_feature_info buf = {
> +		.length = sizeof(buf),
> +		.ecx_in = ecx,
> +	};
> +	struct page *status_page;
> +	void *data;
> +	int ret;
> +
> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +	if (!status_page)
> +		return -ENOMEM;
> +
> +	data = page_address(status_page);
> +
> +	if (sev->snp_initialized && rmp_mark_pages_firmware(__pa(data), 1, true)) {
> +		ret = -EFAULT;
> +		goto cleanup;
> +	}
> +
> +	buf.feature_info_paddr = __psp_pa(data);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &buf, psp_ret);
> +
> +	if (sev->snp_initialized && snp_reclaim_pages(__pa(data), 1, true))
> +		ret = -EFAULT;
		goto cleanup
	}

	memcpy(fi, data, sizeof(*fi));

> +
> +	if (!ret)
> +		memcpy(fi, data, sizeof(*fi));

rather than this is more consistent and hence easier to review.

> +
> +cleanup:
> +	__free_pages(status_page, 0);

	free_page(status_page);

Maybe worth a DEFINE_FREE() to let you do early returns and make this
even nicer to read.



> +	return ret;
> +}
> +
> +static int snp_get_feature_info(struct sev_device *sev, u32 ecx, struct sev_snp_feature_info *fi)
> +{
> +	struct sev_user_data_snp_status status = { 0 };
> +	int psp_ret = 0, ret;
> +
> +	ret = snp_platform_status_locked(sev, &status, &psp_ret);
> +	if (ret)
> +		return ret;
> +	if (ret != SEV_RET_SUCCESS)

	won't get here as ret definitely == 0
given you checked it was just above.

> +		return -EFAULT;
> +	if (!status.feature_info)
> +		return -ENOENT;
> +
> +	ret = snp_feature_info_locked(sev, ecx, fi, &psp_ret);
> +	if (ret)
> +		return ret;
> +	if (ret != SEV_RET_SUCCESS)
> +		return -EFAULT;
and another.

	return snp_feature_info_locked(...


> +
> +	return 0;
> +}
> +
> +static bool sev_tio_present(struct sev_device *sev)
> +{
> +	struct sev_snp_feature_info fi = { 0 };
> +	bool present;
> +
> +	if (snp_get_feature_info(sev, 0, &fi))
> +		return false;
> +
> +	present = (fi.ebx & SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO) != 0;
> +	dev_info(sev->dev, "SEV-TIO support is %s\n", present ? "present" : "not present");

Probably too noisy for final driver but fine for RFC I guess.

> +	return present;
> +}
> +
>  static int __sev_snp_init_locked(int *error)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -1189,6 +1261,7 @@ static int __sev_snp_init_locked(int *error)
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> +		data.tio_en = sev_tio_present(sev);
>  		cmd = SEV_CMD_SNP_INIT_EX;
>  	} else {
>  		cmd = SEV_CMD_SNP_INIT;


