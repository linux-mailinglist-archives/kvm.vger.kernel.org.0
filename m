Return-Path: <kvm+bounces-25268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 754B4962C90
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC3521F25544
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5031A2560;
	Wed, 28 Aug 2024 15:39:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE813C3D5;
	Wed, 28 Aug 2024 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724859579; cv=none; b=PeHskwIk3Ke7PIwqsTJjcJd0Dl6H54+cVn9a3/m77BvwyJ4o6U1tmh1BYRWvNZItNo40bcrhikFTazvy0L0/+PGEnvwNu1uGhN4zcyqqIXBY+C8uGMIW/k+WcZXMW5w/4bP565771PaFPxRqlnni7e/hk+g9QnG7eVfyS8g/KCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724859579; c=relaxed/simple;
	bh=xbdydoh2u22vINByRrRMIya2lqnh9w4150zXJqURBUw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OMq2Uv3WDywh7xtz9dX0IEiW4E7YJ9v81bWMRLNGwT9vFQCeo9uH0qIP6yHTlftZwhZ0qKHMKs6Nrv2DYhw0ZirZGVQWmsWDuUkvhiHnXJqBMcrXVx0KDXaQ6jWLaFVlTbVeYi3DMLdAfufC0fBMtcwrondRe6/omGT7XADpAvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wv7mZ3bWYz6K99Y;
	Wed, 28 Aug 2024 23:36:14 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 236191400D4;
	Wed, 28 Aug 2024 23:39:33 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 28 Aug
 2024 16:39:32 +0100
Date: Wed, 28 Aug 2024 16:39:31 +0100
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
Subject: Re: [RFC PATCH 08/21] crypto/ccp: Implement SEV TIO firmware
 interface
Message-ID: <20240828163931.0000673b@Huawei.com>
In-Reply-To: <20240823132137.336874-9-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
	<20240823132137.336874-9-aik@amd.com>
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

On Fri, 23 Aug 2024 23:21:22 +1000
Alexey Kardashevskiy <aik@amd.com> wrote:

> Implement SEV TIO PSP command wrappers in sev-dev-tio.c, these make
> SPDM calls and store the data in the SEV-TIO-specific structs.
> 
> Implement tsm_ops for the hypervisor, the TSM module will call these
> when loaded on the host and its tsm_set_ops() is called. The HV ops
> are implemented in sev-dev-tsm.c.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Superficial comments online inline.

Jonathan

> ---
>  drivers/crypto/ccp/Makefile      |    2 +
>  arch/x86/include/asm/sev.h       |   20 +
>  drivers/crypto/ccp/sev-dev-tio.h |  105 ++
>  drivers/crypto/ccp/sev-dev.h     |    2 +
>  include/linux/psp-sev.h          |   60 +
>  drivers/crypto/ccp/sev-dev-tio.c | 1565 ++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev-tsm.c |  397 +++++
>  drivers/crypto/ccp/sev-dev.c     |   10 +-
>  8 files changed, 2159 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 394484929dae..d9871465dd08 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -11,6 +11,8 @@ ccp-$(CONFIG_PCI) += sp-pci.o
>  ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>                                     sev-dev.o \
>                                     tee-dev.o \
> +				   sev-dev-tio.o \
> +				   sev-dev-tsm.o \
spaces vs tabs. I guess go for consistency.

>                                     platform-access.o \
>                                     dbc.o \
>                                     hsti.o

> diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
> new file mode 100644
> index 000000000000..42741b17c747
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev-tio.c
> @@ -0,0 +1,1565 @@
> +// SPDX-License-Identifier: GPL-2.0-only

> +static size_t sla_dobj_id_to_size(u8 id)
> +{
> +	size_t n;
> +
> +	BUILD_BUG_ON(sizeof(struct spdm_dobj_hdr_resp) != 0x10);
> +	switch (id) {
> +	case SPDM_DOBJ_ID_REQ:
> +		n = sizeof(struct spdm_dobj_hdr_req);
> +		break;
> +	case SPDM_DOBJ_ID_RESP:
> +		n = sizeof(struct spdm_dobj_hdr_resp);
> +		break;
> +	case SPDM_DOBJ_ID_CERTIFICATE:
> +		n = sizeof(struct spdm_dobj_hdr_cert);
> +		break;
> +	case SPDM_DOBJ_ID_MEASUREMENT:
> +		n = sizeof(struct spdm_dobj_hdr_meas);
> +		break;
> +	case SPDM_DOBJ_ID_REPORT:
> +		n = sizeof(struct spdm_dobj_hdr_report);
> +		break;
> +	default:
> +		WARN_ON(1);
> +		n = 0;
> +		break;
> +	}
> +
> +	return n;

Early returns will make this more readable.

> +}


> +/**
> + * struct sev_data_tio_dev_connect - TIO_DEV_CONNECT
> + *
> + * @length: Length in bytes of this command buffer.
> + * @spdm_ctrl: SPDM control structure defined in Section 5.1.
> + * @device_id: The PCIe Routing Identifier of the device to connect to.
> + * @root_port_id: The PCIe Routing Identifier of the root port of the device.
> + * @segment_id: The PCIe Segment Identifier of the device to connect to.

Doesn't seem to be there.

> + * @dev_ctx_sla: Scatter list address of the device context buffer.
> + * @tc_mask: Bitmask of the traffic classes to initialize for SEV-TIO usage.
> + *           Setting the kth bit of the TC_MASK to 1 indicates that the traffic
> + *           class k will be initialized.
> + * @cert_slot: Slot number of the certificate requested for constructing the SPDM session.
> + * @ide_stream_id: IDE stream IDs to be associated with this device.
> + *                 Valid only if corresponding bit in TC_MASK is set.
> + */
> +struct sev_data_tio_dev_connect {
> +	u32 length;
> +	u32 reserved1;
> +	struct spdm_ctrl spdm_ctrl;
> +	u8 reserved2[8];
> +	struct sla_addr_t dev_ctx_sla;
> +	u8 tc_mask;
> +	u8 cert_slot;
> +	u8 reserved3[6];
> +	u8 ide_stream_id[8];
> +	u8 reserved4[8];
> +} __packed;
> +


> +/**
> + * struct sev_data_tio_guest_request - TIO_GUEST_REQUEST command
> + *
> + * @length: Length in bytes of this command buffer
> + * @spdm_ctrl: SPDM control structure defined in Chapter 2.

Some more fields that aren't documented.  They all should be for
kernel-doc or the scripts will moan. 
I'd just run the script and fixup all the warnings and errors.


> + * @gctx_paddr: system physical address of guest context page
> + * @tdi_ctx_paddr: SPA of page donated by hypervisor
> + * @req_paddr: system physical address of request page
> + * @res_paddr: system physical address of response page
> + */
> +struct sev_data_tio_guest_request {
> +	u32 length;				/* In */
> +	u32 reserved;
> +	struct spdm_ctrl spdm_ctrl;		/* In */
> +	struct sla_addr_t dev_ctx_sla;
> +	struct sla_addr_t tdi_ctx_sla;
> +	u64 gctx_paddr;
> +	u64 req_paddr;				/* In */
> +	u64 res_paddr;				/* In */
> +} __packed;
> +



> +int sev_tio_tdi_status(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
> +		       struct tsm_spdm *spdm)
> +{
> +	struct sev_tio_tdi_status_data *data = (struct sev_tio_tdi_status_data *) dev_data->data;
> +	struct sev_data_tio_tdi_status status = {
> +		.length = sizeof(status),
> +		.dev_ctx_sla = dev_data->dev_ctx,
> +		.tdi_ctx_sla = tdi_data->tdi_ctx,
> +	};
> +	int ret;
> +
> +	if (IS_SLA_NULL(dev_data->dev_ctx) || IS_SLA_NULL(tdi_data->tdi_ctx))
> +		return -ENXIO;
> +
> +	memset(data, 0, sizeof(*data));
> +
> +	spdm_ctrl_init(spdm, &status.spdm_ctrl, dev_data);
> +	status.status_paddr = __psp_pa(data);
> +
> +	ret = sev_tio_do_cmd(SEV_CMD_TIO_TDI_STATUS, &status, sizeof(status),
> +			     &dev_data->psp_ret, dev_data, spdm);
> +
> +	return ret;

return sev_tio_do_cmd()

Same in other similar cases.

> +}


> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> new file mode 100644
> index 000000000000..a11dea482d4b
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -0,0 +1,397 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +// Interface to CCP/SEV-TIO for generic PCIe TDISP module
> +
> +#include <linux/pci.h>
> +#include <linux/pci-doe.h>
> +#include <linux/tsm.h>
> +
> +#include <linux/smp.h>
> +#include <asm/sev-common.h>
> +
> +#include "psp-dev.h"
> +#include "sev-dev.h"
> +#include "sev-dev-tio.h"
> +
> +static int mkret(int ret, struct tsm_dev_tio *dev_data)
> +{
> +	if (ret)
> +		return ret;
> +
> +	if (dev_data->psp_ret == SEV_RET_SUCCESS)
> +		return 0;
> +
> +	pr_err("PSP returned an error %d\n", dev_data->psp_ret);
I'm not totally convinced this is worth while vs simply checking
at call sites.

> +	return -EINVAL;
> +}
> +
> +static int dev_connect(struct tsm_dev *tdev, void *private_data)
> +{
> +	u16 device_id = pci_dev_id(tdev->pdev);
> +	u16 root_port_id = 0; // FIXME: this is NOT PCI id, need to figure out how to calculate this
> +	u8 segment_id = tdev->pdev->bus ? pci_domain_nr(tdev->pdev->bus) : 0;
> +	struct tsm_dev_tio *dev_data = tdev->data;
> +	int ret;
> +
> +	if (!dev_data) {
> +		dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
> +		if (!dev_data)
> +			return -ENOMEM;
> +
> +		ret = sev_tio_dev_create(dev_data, device_id, root_port_id, segment_id);
> +		if (ret)
> +			goto free_exit;
> +
> +		tdev->data = dev_data;
> +	}
...

> +
> +free_exit:
> +	sev_tio_dev_reclaim(dev_data, &tdev->spdm);
> +	kfree(dev_data);

Correct to free even if not allocated here?
Perhaps a comment if so.

> +
> +	return ret;
> +}
> +


> +static int ide_refresh(struct tsm_dev *tdev, void *private_data)
> +{
> +	struct tsm_dev_tio *dev_data = tdev->data;
> +	int ret;
> +
> +	if (!dev_data)
> +		return -ENODEV;
> +
> +	ret = sev_tio_ide_refresh(dev_data, &tdev->spdm);
> +
> +	return ret;

	return sev_tio_ide_refresh()

> +}

> +
> +static int tdi_create(struct tsm_tdi *tdi)
> +{
> +	struct tsm_tdi_tio *tdi_data = tdi->data;
> +	int ret;
> +
> +	if (tdi_data)
> +		return -EBUSY;
> +
> +	tdi_data = kzalloc(sizeof(*tdi_data), GFP_KERNEL);
> +	if (!tdi_data)
> +		return -ENOMEM;
> +
> +	ret = sev_tio_tdi_create(tdi->tdev->data, tdi_data, pci_dev_id(tdi->pdev),
> +				 tdi->rseg, tdi->rseg_valid);
> +	if (ret)
> +		kfree(tdi_data);
	if (ret) {
		kfree(tdi_data);
		return ret;
	}

	tid->data = tdi_data;

	return 0;

is slightly longer but a more standard form so easier to review.

> +	else
> +		tdi->data = tdi_data;
> +
> +	return ret;
> +}
> +

> +
> +static int guest_request(struct tsm_tdi *tdi, u32 guest_rid, u64 kvmid, void *req_data,

Probably wrap nearer 80 chars.

> +			 enum tsm_tdisp_state *state, void *private_data)
> +{
> +	struct tsm_dev_tio *dev_data = tdi->tdev->data;
> +	struct tio_guest_request *req = req_data;
> +	int ret;
> +
> +	if (!tdi->data)
> +		return -EFAULT;
> +
> +	if (dev_data->cmd == 0) {
> +		ret = sev_tio_guest_request(&req->data, guest_rid, kvmid,
> +					    dev_data, tdi->data, &tdi->tdev->spdm);
> +		req->fw_err = dev_data->psp_ret;

If the above returned an error is psp_ret always set? I think not.
So maybe separate if (ret) condition, then set this and finally call
the code below.

> +		ret = mkret(ret, dev_data);
> +		if (ret > 0)
> +			return ret;
> +	} else if (dev_data->cmd == SEV_CMD_TIO_GUEST_REQUEST) {
> +		ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
> +		ret = mkret(ret, dev_data);
> +		if (ret > 0)
> +			return ret;
> +	}
> +
> +	if (dev_data->cmd == 0 && state) {
> +		ret = sev_tio_tdi_status(tdi->tdev->data, tdi->data, &tdi->tdev->spdm);
> +		ret = mkret(ret, dev_data);
> +		if (ret > 0)
> +			return ret;
> +	} else if (dev_data->cmd == SEV_CMD_TIO_TDI_STATUS) {
> +		ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
> +		ret = mkret(ret, dev_data);
> +		if (ret > 0)
> +			return ret;
> +
> +		ret = sev_tio_tdi_status_fin(tdi->tdev->data, tdi->data, state);
> +	}
> +
> +	return ret;
> +}
> +
> +static int tdi_status(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts)
> +{
> +	struct tsm_dev_tio *dev_data = tdi->tdev->data;
> +	int ret;
> +
> +	if (!tdi->data)
> +		return -ENODEV;
> +
> +#if 0 /* Not implemented yet */
> +	if (dev_data->cmd == 0) {
> +		ret = sev_tio_tdi_info(tdi->tdev->data, tdi->data, ts);
> +		ret = mkret(ret, dev_data);
> +		if (ret)
> +			return ret;
> +	}
> +#endif
> +
> +	if (dev_data->cmd == 0) {
> +		ret = sev_tio_tdi_status(tdi->tdev->data, tdi->data, &tdi->tdev->spdm);
> +		ret = mkret(ret, dev_data);
> +		if (ret)
> +			return ret;
> +
> +		ret = sev_tio_tdi_status_fin(tdi->tdev->data, tdi->data, &ts->state);

Given code as it stands. Might as well return here.

> +	} else if (dev_data->cmd == SEV_CMD_TIO_TDI_STATUS) {
Making this just an if.

> +		ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
> +		ret = mkret(ret, dev_data);
> +		if (ret)
> +			return ret;
> +
> +		ret = sev_tio_tdi_status_fin(tdi->tdev->data, tdi->data, &ts->state);
and here.

> +	} else {

Making this the inline code as no need for else.

> +		pci_err(tdi->pdev, "Wrong state, cmd 0x%x in flight\n",
> +			dev_data->cmd);
> +	}
> +
> +	return ret;
> +}
> +
> +struct tsm_ops sev_tsm_ops = {
> +	.dev_connect = dev_connect,
> +	.dev_reclaim = dev_reclaim,
> +	.dev_status = dev_status,
> +	.ide_refresh = ide_refresh,
> +	.tdi_bind = tdi_bind,
> +	.tdi_reclaim = tdi_reclaim,
> +	.guest_request = guest_request,
> +	.tdi_status = tdi_status,
> +};



