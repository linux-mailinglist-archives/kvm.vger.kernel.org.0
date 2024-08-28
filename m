Return-Path: <kvm+bounces-25270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE79962D0B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEFED282A37
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8581A38DE;
	Wed, 28 Aug 2024 15:54:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FA71A0718;
	Wed, 28 Aug 2024 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724860487; cv=none; b=pR9Tp38vnfx1X1u2s8twoxQRXalK/8a4PFWLs7JXzGTTSDnvFlByXaOAiXU6moh+6h9Racj+aHRCsHkSQiLquPxuBjV8SaU813XIL1yKThFfENIqKHo7iRZo3xi2QFDfuTRaOqiZx2x6D8vC+gVLD7B2a99FUghU5WeSRA41rmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724860487; c=relaxed/simple;
	bh=yfqlcQMZu+JGvpJjxkp4NEwud7Bw+0cvsJjSeYSV/1k=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEScmY7fc0X3EugBrs8CvVHBpWTY41Hvsyktat0LaNBqWhrSQkYjQP42ml2Dw0j0FuhScpyGGrIYAWBF7WnVVSx35tVqaIDeYZiGnIYULuViNOylBT8tXtEg7KAWmu8dYP/7k6i78Z68AhZCLQnHAqlKB0SG1Mal15P5OGGL8tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wv86619BBz6H8D7;
	Wed, 28 Aug 2024 23:51:26 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E0231400D4;
	Wed, 28 Aug 2024 23:54:42 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 28 Aug
 2024 16:54:41 +0100
Date: Wed, 28 Aug 2024 16:54:40 +0100
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
Subject: Re: [RFC PATCH 17/21] coco/sev-guest: Implement the guest side of
 things
Message-ID: <20240828165440.0000211a@Huawei.com>
In-Reply-To: <20240823132137.336874-18-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
	<20240823132137.336874-18-aik@amd.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Aug 2024 23:21:31 +1000
Alexey Kardashevskiy <aik@amd.com> wrote:

> Define tsm_ops for the guest and forward the ops calls to the HV via
> SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST.
> Do the attestation report examination and enable MMIO.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
More trivial stuff.

> diff --git a/drivers/virt/coco/sev-guest/sev_guest_tio.c b/drivers/virt/coco/sev-guest/sev_guest_tio.c
> new file mode 100644
> index 000000000000..33a082e7f039
> --- /dev/null
> +++ b/drivers/virt/coco/sev-guest/sev_guest_tio.c
> @@ -0,0 +1,513 @@



> +static int tio_tdi_sdte_write(struct tsm_tdi *tdi, struct snp_guest_dev *snp_dev, bool invalidate)
> +{
> +	struct snp_guest_crypto *crypto = snp_dev->crypto;
> +	size_t resp_len = sizeof(struct tio_msg_sdte_write_rsp) + crypto->a_len;
> +	struct tio_msg_sdte_write_rsp *rsp = kzalloc(resp_len, GFP_KERNEL);
> +	struct tio_msg_sdte_write_req req = {
> +		.guest_device_id = pci_dev_id(tdi->pdev),
> +		.sdte.vmpl = 0,
> +		.sdte.vtom = tsm_vtom,
> +		.sdte.vtom_en = 1,
> +		.sdte.iw = 1,
> +		.sdte.ir = 1,
> +		.sdte.v = 1,
> +	};
> +	u64 fw_err = 0;
> +	u64 bdfn = pci_dev_id(tdi->pdev);
> +	int rc;
> +
> +	BUILD_BUG_ON(sizeof(struct sdte) * 8 != 512);
> +
> +	if (invalidate)
> +		memset(&req, 0, sizeof(req));

Little odd to fill it then zero it.  Maybe just fill it
if !invalidate

> +
> +	pci_notice(tdi->pdev, "SDTE write vTOM=%lx", (unsigned long) req.sdte.vtom << 21);
> +
> +	if (!rsp)

I'd allocate rsp down here as then obvious what is going on.

> +		return -ENOMEM;
> +
> +	rc = handle_tio_guest_request(snp_dev, TIO_MSG_SDTE_WRITE_REQ,
> +			       &req, sizeof(req), rsp, resp_len,
> +			       NULL, NULL, &bdfn, NULL, &fw_err);
> +	if (rc) {
> +		pci_err(tdi->pdev, "SDTE write failed with 0x%llx\n", fw_err);
> +		goto free_exit;
> +	}
> +
> +free_exit:
> +	/* The response buffer contains the sensitive data, explicitly clear it. */
> +	memzero_explicit(&rsp, sizeof(resp_len));
> +	kfree(rsp);

kfree_sensitive() perhaps?

> +	return rc;
> +}

> +static int sev_guest_tdi_validate(struct tsm_tdi *tdi, bool invalidate, void *private_data)
> +{
> +	struct snp_guest_dev *snp_dev = private_data;
> +	struct tsm_tdi_status ts = { 0 };
> +	int ret;
> +
> +	if (!tdi->report) {
> +		ret = tio_tdi_status(tdi, snp_dev, &ts);
> +
> +		if (ret || !tdi->report) {
> +			pci_err(tdi->pdev, "No report available, ret=%d", ret);
> +			if (!ret && tdi->report)
> +				ret = -EIO;
> +			return ret;
I'd split the error paths to simplify the logic.
		if (ret) {
			pci_err(tdi->pdev, "No report available, ret=%d", ret);
			return ret;
		}
		if (!tdi->report) {
			pci_err(... some more meaningful message)
			return -EIO;
> +		}
> +
> +		if (ts.state != TDISP_STATE_RUN) {
> +			pci_err(tdi->pdev, "Not in RUN state, state=%d instead", ts.state);
> +			return -EIO;
> +		}
> +	}
> +
> +	ret = tio_tdi_sdte_write(tdi, snp_dev, invalidate);
> +	if (ret)
> +		return ret;
> +
> +	ret = tio_tdi_mmio_validate(tdi, snp_dev, invalidate);

return tio_tdi_mmio_validate();

> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}


