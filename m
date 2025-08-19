Return-Path: <kvm+bounces-55043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 135D5B2CE9B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A6DF1C2229A
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6B934575E;
	Tue, 19 Aug 2025 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfPIU53g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E9C2D24B5
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 21:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755639342; cv=none; b=ui2ngsZl4UsMSD1xd2UYb66G0J8914iDTY2nRwRL+JJZB1cEIAjfQNRFTi+TW1L1NFvFIL9HGMqWYZ5wcPg1bjVod03fXowZwVq7E42w+H1vRkR36GZw78rXqEzRrtsqOWMxhHZnIj6439IEXDrrlIe+QD+FJyfsmyRbJq6W7Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755639342; c=relaxed/simple;
	bh=3JXvhyM+RRBPSVTefP4PEXr46P8gPZfZLhVMeBUTFIU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=io7E8J0xiJNR9LuQhltbESTTz50TF5vCXQfi91dtI5W2wxNmuZVgWWbQl0gD7z+KBSN7XuVxMm8qk9oNoLLKTTuHqrUTz5sBzdh8DsWRjWCZxwUYUn1BtL/4ev/b/W88QvReVzfzifXkxMBwWpwJzTHwdeTGZW7r5D42F8RvtLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfPIU53g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755639339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6iDQKIIdT+2SJ8+DhL5hYIEEI1jo8Q9AzHhOaOEzd4w=;
	b=dfPIU53gHvfgJ9MT/sMeIBG56uIJo+JKDJY52sElWSs0D0hKr+dPGFJL7obKK7RDlXN0UC
	xxNSOgwuqoJDzo5Ubzr81AjRQFGCnjX4N5qImwWnF2YB9SJTmwHG2KIoXuRdGDm3HRrhgc
	boaANL9KQDIvb+MyctC6mayBNs9a+iA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-aZ7wvH12Mju3JEvkziBNgA-1; Tue, 19 Aug 2025 17:35:37 -0400
X-MC-Unique: aZ7wvH12Mju3JEvkziBNgA-1
X-Mimecast-MFC-AGG-ID: aZ7wvH12Mju3JEvkziBNgA_1755639336
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88432d98a10so21002539f.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 14:35:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755639335; x=1756244135;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6iDQKIIdT+2SJ8+DhL5hYIEEI1jo8Q9AzHhOaOEzd4w=;
        b=C/R8ZVCd78nmSDICLnSWse9ibjQ2vGIV5Yp133JfSS3h6mr99PZNkJjeJ+Ttrqh2So
         Op2MywJDjnCmsC2A/Qm8UV8iwmESKoHJ6f0kPHXkSdvjUrqwOKtlpxGL9eiuGYLEbyTl
         TVVWQPB/PWallloAKihEzBlukgp3CKbvgkRucwyWYKHXvqwLTF0x6VvlOKXDEtI9Ek20
         2T60FfDEeVfaKfmMeGpXhPWzUmbBeS4YzlZAgW1piaoB4m4zr07+MMcOuqKYtkPi1ZPS
         fSZSKqWFVAHd5hhcVLvRvlJPbOQzoC5qKNeaOApXBcmX1sJsPwAtTDxzMVrGXyX8HUuv
         CtUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDUmQgf6v37yJRA8MUd3vO7ctDjQiOOYHQ4FvHdnfnpAISCMt/JA2uVfSdJcquoz3rk80=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK8H0RYEHkO2E3Jg/pISlHPDfmdjV70TQTON8GT/SB+OagQg6A
	NlgjMdvwQlLeoUTAbloNnu9OBZ0Xtd1vqe8VRenARRrW1diMdtuSrMNG3UHPFDkgKT2fk4/yBHp
	3eYV9k18H+1vePlP9iD+LEn4TR4ve4dBnwmjHHLCorN9jeN1ZN9LgcjlEDp07vg==
X-Gm-Gg: ASbGncv8uRLZi9OsuQovv18jgKxdkc8nu+UiAs3Ib6J+dMdYghIJQ57Z/MZaCQWO9Hk
	EAatIJE6SyLRLc/VM1Z81nxcbGGoQpaq8Bi7tB9i3g+HAmyLCzrHmfejdsO4s29jXd++bmKsdv3
	Mc8YdbE4eiwt2Jclv4fvyOM6Tfz2nfROinUvuFV+3Rk3YjwoVHiFPFyefzE8etS939K7zOpdBqS
	eXJCcpy2gELiw2ff/ATtYvIps+QLE0mnMTGTqSPtapkRFBu6GW24K0TzE3/PuTnQFaJSSswn271
	BDA9b2EK4v4qeTGon/o1s5q4yrhsEQGQkbQftO/Owps=
X-Received: by 2002:a05:6e02:2196:b0:3e5:2e10:4e07 with SMTP id e9e14a558f8ab-3e67ca5eec7mr3555435ab.3.1755639335090;
        Tue, 19 Aug 2025 14:35:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgkgvGBRUd39IOP1MgLgnmdC7ykiUhOMWMZw0mCeVs0drCNd3D9NjDutqXcR3q7kyiPuvjgg==
X-Received: by 2002:a05:6e02:2196:b0:3e5:2e10:4e07 with SMTP id e9e14a558f8ab-3e67ca5eec7mr3555265ab.3.1755639334587;
        Tue, 19 Aug 2025 14:35:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c94781d01sm3668172173.4.2025.08.19.14.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 14:35:33 -0700 (PDT)
Date: Tue, 19 Aug 2025 15:35:30 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <herbert@gondor.apana.org.au>,
 <shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
 <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v7 3/3] migration: adapt to new migration configuration
Message-ID: <20250819153530.3332c3ea.alex.williamson@redhat.com>
In-Reply-To: <20250805065106.898298-4-liulongfang@huawei.com>
References: <20250805065106.898298-1-liulongfang@huawei.com>
	<20250805065106.898298-4-liulongfang@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Patch title should be consistent with previous patches to this driver,
"migration:" is not very meaningful.  "hisi_acc_vfio_pci:" is the most
commonly used prefix.

More below...

On Tue, 5 Aug 2025 14:51:06 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> On new platforms greater than QM_HW_V3, the migration region has been
> relocated from the VF to the PF. The driver must also be modified
> accordingly to adapt to the new hardware device.
> 
> On the older hardware platform QM_HW_V3, the live migration configuration
> region is placed in the latter 32K portion of the VF's BAR2 configuration
> space. On the new hardware platform QM_HW_V4, the live migration
> configuration region also exists in the same 32K area immediately following
> the VF's BAR2, just like on QM_HW_V3.
> 
> However, access to this region is now controlled by hardware. Additionally,
> a copy of the live migration configuration region is present in the PF's BAR2
> configuration space. On the new hardware platform QM_HW_V4, when an older
> version of the driver is loaded, it behaves like QM_HW_V3 and uses the
> configuration region in the VF, ensuring that the live migration function
> continues to work normally. When the new version of the driver is loaded,
> it directly uses the configuration region in the PF. Meanwhile, hardware
> configuration disables the live migration configuration region in the VF's
> BAR2: reads return all 0xF values, and writes are silently ignored.

Patch 1/ suggests that the migration config registers are fully moved
from VF to PF, opening the full BAR2 to user access.  Here I think it's
described differently, that V4 hardware operates in V3 compatibility
mode with the migration configuration registers only becoming disabled
when the driver switches to V4 mode.  Aren't the patches backwards then,
that we should only expose the full BAR2 once the driver has disabled
the migration registers?

Actually I think it's patch 2/ that was claimed is independent of
these vfio-pci variant driver changes that appears to direct the PF to
disable compatibility mode, right?  But if we implement the vfio driver
change without the PF driver change, then I think we're broken and
we're creating a tenuous dependency between the PF driver and the
vfio-pci variant VF driver.  It seems like maybe we need to rely on
both V4 hardware AND testing that the PF driver has set the write
config before we can implement V4 mode here.  Thanks,

Alex

> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 164 ++++++++++++------
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>  2 files changed, 118 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index ddb3fd4df5aa..a20785bcea62 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
>  	return 0;
>  }
>  
> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> +			   struct acc_vf_data *vf_data)
> +{
> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> +	struct device *dev = &qm->pdev->dev;
> +	u32 eqc_addr, aeqc_addr;
> +	int ret;
> +
> +	if (qm->ver == QM_HW_V3) {
> +		eqc_addr = QM_EQC_DW0;
> +		aeqc_addr = QM_AEQC_DW0;
> +	} else {
> +		eqc_addr = QM_EQC_PF_DW0;
> +		aeqc_addr = QM_AEQC_PF_DW0;
> +	}
> +
> +	/* QM_EQC_DW has 7 regs */
> +	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to read QM_EQC_DW\n");
> +		return ret;
> +	}
> +
> +	/* QM_AEQC_DW has 7 regs */
> +	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to read QM_AEQC_DW\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> +			   struct acc_vf_data *vf_data)
> +{
> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> +	struct device *dev = &qm->pdev->dev;
> +	u32 eqc_addr, aeqc_addr;
> +	int ret;
> +
> +	if (qm->ver == QM_HW_V3) {
> +		eqc_addr = QM_EQC_DW0;
> +		aeqc_addr = QM_AEQC_DW0;
> +	} else {
> +		eqc_addr = QM_EQC_PF_DW0;
> +		aeqc_addr = QM_AEQC_PF_DW0;
> +	}
> +
> +	/* QM_EQC_DW has 7 regs */
> +	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to write QM_EQC_DW\n");
> +		return ret;
> +	}
> +
> +	/* QM_AEQC_DW has 7 regs */
> +	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to write QM_AEQC_DW\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>  {
>  	struct device *dev = &qm->pdev->dev;
> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>  		return ret;
>  	}
>  
> -	/* QM_EQC_DW has 7 regs */
> -	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> -	if (ret) {
> -		dev_err(dev, "failed to read QM_EQC_DW\n");
> -		return ret;
> -	}
> -
> -	/* QM_AEQC_DW has 7 regs */
> -	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> -	if (ret) {
> -		dev_err(dev, "failed to read QM_AEQC_DW\n");
> -		return ret;
> -	}
> -
>  	return 0;
>  }
>  
> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>  		return ret;
>  	}
>  
> -	/* QM_EQC_DW has 7 regs */
> -	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> -	if (ret) {
> -		dev_err(dev, "failed to write QM_EQC_DW\n");
> -		return ret;
> -	}
> -
> -	/* QM_AEQC_DW has 7 regs */
> -	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> -	if (ret) {
> -		dev_err(dev, "failed to write QM_AEQC_DW\n");
> -		return ret;
> -	}
> -
>  	return 0;
>  }
>  
> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return ret;
>  	}
>  
> +	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
> +	if (ret)
> +		return ret;
> +
>  	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>  	if (ret) {
>  		dev_err(dev, "set sqc failed\n");
> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	vf_data->vf_qm_state = QM_READY;
>  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>  
> +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
> +	if (ret)
> +		return ret;
> +
>  	ret = vf_qm_read_data(vf_qm, vf_data);
>  	if (ret)
>  		return ret;
> @@ -1186,34 +1232,45 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
>  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> +	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>  	struct pci_dev *vf_dev = vdev->pdev;
>  
> -	/*
> -	 * ACC VF dev BAR2 region consists of both functional register space
> -	 * and migration control register space. For migration to work, we
> -	 * need access to both. Hence, we map the entire BAR2 region here.
> -	 * But unnecessarily exposing the migration BAR region to the Guest
> -	 * has the potential to prevent/corrupt the Guest migration. Hence,
> -	 * we restrict access to the migration control space from
> -	 * Guest(Please see mmap/ioctl/read/write override functions).
> -	 *
> -	 * Please note that it is OK to expose the entire VF BAR if migration
> -	 * is not supported or required as this cannot affect the ACC PF
> -	 * configurations.
> -	 *
> -	 * Also the HiSilicon ACC VF devices supported by this driver on
> -	 * HiSilicon hardware platforms are integrated end point devices
> -	 * and the platform lacks the capability to perform any PCIe P2P
> -	 * between these devices.
> -	 */
> -
> -	vf_qm->io_base =
> -		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> -			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> -	if (!vf_qm->io_base)
> -		return -EIO;
> +	if (pf_qm->ver == QM_HW_V3) {
> +		/*
> +		 * ACC VF dev BAR2 region consists of both functional register space
> +		 * and migration control register space. For migration to work, we
> +		 * need access to both. Hence, we map the entire BAR2 region here.
> +		 * But unnecessarily exposing the migration BAR region to the Guest
> +		 * has the potential to prevent/corrupt the Guest migration. Hence,
> +		 * we restrict access to the migration control space from
> +		 * Guest(Please see mmap/ioctl/read/write override functions).
> +		 *
> +		 * Please note that it is OK to expose the entire VF BAR if migration
> +		 * is not supported or required as this cannot affect the ACC PF
> +		 * configurations.
> +		 *
> +		 * Also the HiSilicon ACC VF devices supported by this driver on
> +		 * HiSilicon hardware platforms are integrated end point devices
> +		 * and the platform lacks the capability to perform any PCIe P2P
> +		 * between these devices.
> +		 */
>  
> +		vf_qm->io_base =
> +			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> +				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> +		if (!vf_qm->io_base)
> +			return -EIO;
> +	} else {
> +		/*
> +		 * On hardware platforms greater than QM_HW_V3, the migration function
> +		 * register is placed in the BAR2 configuration region of the PF,
> +		 * and each VF device occupies 8KB of configuration space.
> +		 */
> +		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
> +				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
> +	}
>  	vf_qm->fun_type = QM_HW_VF;
> +	vf_qm->ver = pf_qm->ver;
>  	vf_qm->pdev = vf_dev;
>  	mutex_init(&vf_qm->mailbox_lock);
>  
> @@ -1539,7 +1596,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>  	hisi_acc_vdev->dev_opened = false;
> -	iounmap(vf_qm->io_base);
> +	if (vf_qm->ver == QM_HW_V3)
> +		iounmap(vf_qm->io_base);
>  	mutex_unlock(&hisi_acc_vdev->open_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 91002ceeebc1..348f8bb5b42c 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -59,6 +59,13 @@
>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>  
> +#define QM_MIG_REGION_OFFSET		0x180000
> +#define QM_MIG_REGION_SIZE		0x2000
> +
> +#define QM_SUB_VERSION_ID		0x100210
> +#define QM_EQC_PF_DW0			0x1c00
> +#define QM_AEQC_PF_DW0			0x1c20
> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */


