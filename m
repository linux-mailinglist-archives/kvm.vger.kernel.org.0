Return-Path: <kvm+bounces-53507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB14EB12A8E
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 15:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 085955619B8
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 13:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BCA246776;
	Sat, 26 Jul 2025 13:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XdEO+h87"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB76242D95
	for <kvm@vger.kernel.org>; Sat, 26 Jul 2025 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753535081; cv=none; b=MhaG7OnRD11wZZhekHRzvTqzQ/nGLhkyXIKHtDTRCsQKk0ZjTGcfIH9zCT8TaK9zpHfXu8Iba8r2uKJZsMHTVXwm34p4SIKkdkyA7xrpkffMc2cFCjojX41DRQ3IYjfcFh55f4Qdx/I8IKIp9Dj+01DKuqBuMdjqdIAkECtXRYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753535081; c=relaxed/simple;
	bh=+WCKhO0xxSZVgfZ4pR01ydAPWP0h8Pmblu+CxS2RSuM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WP7OoEF/3P/hoYZzj5abieJ7G+M/jdz8mIoop44c9zujk+lTtJ28gp9K4hb91uZF1AsNZhLv/s/wIwtVbSHySiNI/HCcjd/Kz0YOkIevrUYCLeXK+uSa2mtiOCOmf0yF4alenKnY7c4h/mObjedwPy3m5DHE8umsNOPa9D41R9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XdEO+h87; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753535077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i720ap6kdUBqik09+1lrBx0BIuk68h/nSwK8xDWBR2Y=;
	b=XdEO+h87iTVeT+UIBwZ82u43PSMN0wDYh1DuS6GfzYVPHcNOP5TpK1zXu4SriC1U3vTrhL
	tOlA6U7Ev9WfZteuXAxwmOqW+7rTkvudskvXsV7S6cGwgc2g20o/ijyK6DaVi0CTTfC0Fo
	4SQeqL2Llvnze+Agmg6u1lxzfNZwLQE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-Hi4gSdeHN4S1ihwCnC78kg-1; Sat, 26 Jul 2025 09:04:35 -0400
X-MC-Unique: Hi4gSdeHN4S1ihwCnC78kg-1
X-Mimecast-MFC-AGG-ID: Hi4gSdeHN4S1ihwCnC78kg_1753535075
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e0500ab478so5083735ab.2
        for <kvm@vger.kernel.org>; Sat, 26 Jul 2025 06:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753535075; x=1754139875;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i720ap6kdUBqik09+1lrBx0BIuk68h/nSwK8xDWBR2Y=;
        b=QLki1Xxa70urnLAwemo5XD+n/F+d15IpnTsT2+n3v6nX6m3UlmEFP4XB1lIOCNY1af
         zs+YbKl2qjUwjfhtEMRNPWUayg7K3MxXahEtvHfADf4eSab3IfIuf9tmHnloDzE6fr0Q
         ImAIoW6pqcbRK53Vcf+v56agZFstjCxFRz8f5PitFV2gmYcWWNkRpsgVkSKMzTRyTgwx
         MzAohAk5zeU5pOB9MBBBVd01yObZR4LC4hNP9XWvRb2IqzrAyPZ5gyqsepbvfA3awtDf
         ydFBD1fu31jiLNA4ohQmVa6GwZQ1MxdTzQr1KDU7YsnyYKOhbYuXkph8atjtGZQQylaY
         fWKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOnHiOxVJ4Kz7UbvXDMHyaOhgmB8mfSx7SxNaNkrRxwgVtSjsCA28BPosRbfLD5EaW7Ko=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJpceDHlUOIHYaCoZyPV+0pndp5JW7hA9eeEDqyx38zdvbBxAQ
	6IUx+9KCoGZ7jNBOk8qW8eAj9RjWj8vxXph9bsIHj/Px2nlbFofYmi0EgHnU5esj27Pfpomerg/
	hKGLrePw5pTrv9gTewoPaxJ8ki2i3N7GPGJVzVimrUwTS1nyiMONmwA==
X-Gm-Gg: ASbGncsG+eJ+9Qq+E2jn4LIyAx5tAxfE0/7rgVAxGoQ630ZvagvxyH3iGNa2a1FElhN
	PpgZyPEThxp7jev2l0qihDQQli9rvI189LwckOOyda1nCc4g1kbvcytIJzgtJ96o1whLYf1N8zC
	KXN18q+y6DBFcn20VyytZsUNku82c3rxtaw7JkignEcYVzmeS+zl+xjrYcxoRA6FHcW80XJUCS1
	W4xhM9icFOQJCAsnPmyFwq9nNAdPWUMvVZODs7mQUPUz+MQpU9f7IyknDIgrnPWxipOn7g6hrNM
	bd2X5JhxhAWqPlabBmhoOOr9i/kp5uQjNJ6MfaGWhF4=
X-Received: by 2002:a05:6e02:170d:b0:3e0:4f66:30f8 with SMTP id e9e14a558f8ab-3e3c537e94fmr23717615ab.6.1753535074644;
        Sat, 26 Jul 2025 06:04:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGu8vtNW1zTW3HOQJAAdIxiUr9MeNm579wLk0c07M544lOuVtrYydnLz/DLDXAPlWg9cAR8Zw==
X-Received: by 2002:a05:6e02:170d:b0:3e0:4f66:30f8 with SMTP id e9e14a558f8ab-3e3c537e94fmr23717415ab.6.1753535074164;
        Sat, 26 Jul 2025 06:04:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e3cacd7c18sm8109645ab.49.2025.07.26.06.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jul 2025 06:04:32 -0700 (PDT)
Date: Sat, 26 Jul 2025 07:04:27 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: liulongfang <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <herbert@gondor.apana.org.au>,
 <shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
 <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 3/3] migration: adapt to new migration configuration
Message-ID: <20250726070427.2a75c54f.alex.williamson@redhat.com>
In-Reply-To: <c3e74996-6188-12c6-b0c5-58d2188c0609@huawei.com>
References: <20250717011502.16050-1-liulongfang@huawei.com>
	<20250717011502.16050-4-liulongfang@huawei.com>
	<c3e74996-6188-12c6-b0c5-58d2188c0609@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 26 Jul 2025 14:25:00 +0800
liulongfang <liulongfang@huawei.com> wrote:

> On 2025/7/17 9:15, Longfang Liu wrote:
> > On new platforms greater than QM_HW_V3, the migration region has been
> > relocated from the VF to the PF. The driver must also be modified
> > accordingly to adapt to the new hardware device.
> > 
> > Utilize the PF's I/O base directly on the new hardware platform,
> > and no mmap operation is required. If it is on an old platform,
> > the driver needs to be compatible with the old solution.
> > 
> > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > ---
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 164 ++++++++++++------
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
> >  2 files changed, 118 insertions(+), 53 deletions(-)
> >  
> 
> Hi Alex:
> Please take a look at this set of patches!

I've been waiting for Shameer's review of this one.  Thanks,

Alex
 
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > index 515ff87f9ed9..bf4a7468bca0 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
> >  	return 0;
> >  }
> >  
> > +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> > +			   struct acc_vf_data *vf_data)
> > +{
> > +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> > +	struct device *dev = &qm->pdev->dev;
> > +	u32 eqc_addr, aeqc_addr;
> > +	int ret;
> > +
> > +	if (qm->ver == QM_HW_V3) {
> > +		eqc_addr = QM_EQC_DW0;
> > +		aeqc_addr = QM_AEQC_DW0;
> > +	} else {
> > +		eqc_addr = QM_EQC_PF_DW0;
> > +		aeqc_addr = QM_AEQC_PF_DW0;
> > +	}
> > +
> > +	/* QM_EQC_DW has 7 regs */
> > +	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> > +	if (ret) {
> > +		dev_err(dev, "failed to read QM_EQC_DW\n");
> > +		return ret;
> > +	}
> > +
> > +	/* QM_AEQC_DW has 7 regs */
> > +	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> > +	if (ret) {
> > +		dev_err(dev, "failed to read QM_AEQC_DW\n");
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> > +			   struct acc_vf_data *vf_data)
> > +{
> > +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> > +	struct device *dev = &qm->pdev->dev;
> > +	u32 eqc_addr, aeqc_addr;
> > +	int ret;
> > +
> > +	if (qm->ver == QM_HW_V3) {
> > +		eqc_addr = QM_EQC_DW0;
> > +		aeqc_addr = QM_AEQC_DW0;
> > +	} else {
> > +		eqc_addr = QM_EQC_PF_DW0;
> > +		aeqc_addr = QM_AEQC_PF_DW0;
> > +	}
> > +
> > +	/* QM_EQC_DW has 7 regs */
> > +	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> > +	if (ret) {
> > +		dev_err(dev, "failed to write QM_EQC_DW\n");
> > +		return ret;
> > +	}
> > +
> > +	/* QM_AEQC_DW has 7 regs */
> > +	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> > +	if (ret) {
> > +		dev_err(dev, "failed to write QM_AEQC_DW\n");
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >  {
> >  	struct device *dev = &qm->pdev->dev;
> > @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >  		return ret;
> >  	}
> >  
> > -	/* QM_EQC_DW has 7 regs */
> > -	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> > -	if (ret) {
> > -		dev_err(dev, "failed to read QM_EQC_DW\n");
> > -		return ret;
> > -	}
> > -
> > -	/* QM_AEQC_DW has 7 regs */
> > -	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> > -	if (ret) {
> > -		dev_err(dev, "failed to read QM_AEQC_DW\n");
> > -		return ret;
> > -	}
> > -
> >  	return 0;
> >  }
> >  
> > @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >  		return ret;
> >  	}
> >  
> > -	/* QM_EQC_DW has 7 regs */
> > -	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> > -	if (ret) {
> > -		dev_err(dev, "failed to write QM_EQC_DW\n");
> > -		return ret;
> > -	}
> > -
> > -	/* QM_AEQC_DW has 7 regs */
> > -	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> > -	if (ret) {
> > -		dev_err(dev, "failed to write QM_AEQC_DW\n");
> > -		return ret;
> > -	}
> > -
> >  	return 0;
> >  }
> >  
> > @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >  		return ret;
> >  	}
> >  
> > +	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
> > +	if (ret)
> > +		return ret;
> > +
> >  	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
> >  	if (ret) {
> >  		dev_err(dev, "set sqc failed\n");
> > @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >  	vf_data->vf_qm_state = QM_READY;
> >  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
> >  
> > +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
> > +	if (ret)
> > +		return ret;
> > +
> >  	ret = vf_qm_read_data(vf_qm, vf_data);
> >  	if (ret)
> >  		return ret;
> > @@ -1186,34 +1232,45 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >  {
> >  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> >  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > +	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
> >  	struct pci_dev *vf_dev = vdev->pdev;
> >  
> > -	/*
> > -	 * ACC VF dev BAR2 region consists of both functional register space
> > -	 * and migration control register space. For migration to work, we
> > -	 * need access to both. Hence, we map the entire BAR2 region here.
> > -	 * But unnecessarily exposing the migration BAR region to the Guest
> > -	 * has the potential to prevent/corrupt the Guest migration. Hence,
> > -	 * we restrict access to the migration control space from
> > -	 * Guest(Please see mmap/ioctl/read/write override functions).
> > -	 *
> > -	 * Please note that it is OK to expose the entire VF BAR if migration
> > -	 * is not supported or required as this cannot affect the ACC PF
> > -	 * configurations.
> > -	 *
> > -	 * Also the HiSilicon ACC VF devices supported by this driver on
> > -	 * HiSilicon hardware platforms are integrated end point devices
> > -	 * and the platform lacks the capability to perform any PCIe P2P
> > -	 * between these devices.
> > -	 */
> > -
> > -	vf_qm->io_base =
> > -		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> > -			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> > -	if (!vf_qm->io_base)
> > -		return -EIO;
> > +	if (pf_qm->ver == QM_HW_V3) {
> > +		/*
> > +		 * ACC VF dev BAR2 region consists of both functional register space
> > +		 * and migration control register space. For migration to work, we
> > +		 * need access to both. Hence, we map the entire BAR2 region here.
> > +		 * But unnecessarily exposing the migration BAR region to the Guest
> > +		 * has the potential to prevent/corrupt the Guest migration. Hence,
> > +		 * we restrict access to the migration control space from
> > +		 * Guest(Please see mmap/ioctl/read/write override functions).
> > +		 *
> > +		 * Please note that it is OK to expose the entire VF BAR if migration
> > +		 * is not supported or required as this cannot affect the ACC PF
> > +		 * configurations.
> > +		 *
> > +		 * Also the HiSilicon ACC VF devices supported by this driver on
> > +		 * HiSilicon hardware platforms are integrated end point devices
> > +		 * and the platform lacks the capability to perform any PCIe P2P
> > +		 * between these devices.
> > +		 */
> >  
> > +		vf_qm->io_base =
> > +			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> > +				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> > +		if (!vf_qm->io_base)
> > +			return -EIO;
> > +	} else {
> > +		/*
> > +		 * On hardware platforms greater than QM_HW_V3, the migration function
> > +		 * register is placed in the BAR2 configuration region of the PF,
> > +		 * and each VF device occupies 8KB of configuration space.
> > +		 */
> > +		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
> > +				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
> > +	}
> >  	vf_qm->fun_type = QM_HW_VF;
> > +	vf_qm->ver = pf_qm->ver;
> >  	vf_qm->pdev = vf_dev;
> >  	mutex_init(&vf_qm->mailbox_lock);
> >  
> > @@ -1539,7 +1596,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
> >  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
> >  	mutex_lock(&hisi_acc_vdev->open_mutex);
> >  	hisi_acc_vdev->dev_opened = false;
> > -	iounmap(vf_qm->io_base);
> > +	if (vf_qm->ver == QM_HW_V3)
> > +		iounmap(vf_qm->io_base);
> >  	mutex_unlock(&hisi_acc_vdev->open_mutex);
> >  	vfio_pci_core_close_device(core_vdev);
> >  }
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > index 91002ceeebc1..348f8bb5b42c 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > @@ -59,6 +59,13 @@
> >  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
> >  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
> >  
> > +#define QM_MIG_REGION_OFFSET		0x180000
> > +#define QM_MIG_REGION_SIZE		0x2000
> > +
> > +#define QM_SUB_VERSION_ID		0x100210
> > +#define QM_EQC_PF_DW0			0x1c00
> > +#define QM_AEQC_PF_DW0			0x1c20
> > +
> >  struct acc_vf_data {
> >  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
> >  	/* QM match information */
> >   
> 


