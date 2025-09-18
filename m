Return-Path: <kvm+bounces-57987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6444B83425
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 09:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73AB97B7592
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDF92E6CA1;
	Thu, 18 Sep 2025 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B3KcGxnq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758042D8DD1
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 07:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758179189; cv=none; b=XDeytCipnFVnvSirbQPoDaQ7Yjl+UGPS03LlSHZwzBI9WTR+DhES2Gbw1Nt5AB/hCrXAk88H8Qp2i75lajv6qxGw/ryF+skgkmwiJ0KS+HOBvOhjEtA0dcH2JX7gYruSFuEbZOlcbzk3RIc0HwsZSu09b7jseiKSSYjvSp5pgI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758179189; c=relaxed/simple;
	bh=4IDSaO2MoQqGUX/5Is94akHzdjhGaOyo8qsk/PPh9UI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t5NkcMhtR73tbn5lWNbSt6JOlqQTOzSMQaZ/mVkp/tO0Y1TBBjfYPI4xQ/9ZSP5L0PG+PzwHwf8DDMV6X6e4KNkK2ihMYQhd3d8E+e35goHIK50vB3dXaNlT3lVkGvyND1WgTLFzXGSme/JdBlWhnvCv6xwNOOu/9X0cj6aYPkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B3KcGxnq; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b5eee40cc0so6444921cf.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 00:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758179186; x=1758783986; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SAAVksE0mRteO5BvlzanWiDdXV8KikuWQ+Fsq+TxSGI=;
        b=B3KcGxnql/ENGwNhcU4dGTna77o1r2Z2EULgEJLvMtK3UV+SDAz6viin4k+Ak9jzQJ
         3i1nLlUDE14J3ThGXurClX9QSmDYhIe0riRhH3iiPNKSH4mFPxYAxbPxfHXn7xr+Rso9
         jJY+dMfMXqnc28j1GX6wXvNZNulnGKwEYm33OOE4XULxoCFS4ZlTCBAF8XekAGh9t3iC
         ldbRj7QCEnvlzAqMTMtmEEqDorWWlEYUZLCqlIVmO5xqhjxdRYieVCKwM8OTQzog6fZK
         w8jgUFlzFCV2btVHq6sW5HuGu9a89DoChfuSoYhuQ+ZKuvdSH3B2jJ/405GA1tk79rPs
         4LMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758179186; x=1758783986;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SAAVksE0mRteO5BvlzanWiDdXV8KikuWQ+Fsq+TxSGI=;
        b=ZG2cYGFppYlYJet3cRkwdvojFuUdbtblId6SZj1qpg9ElUWgCgBh6AgxYBP1T/XxvX
         SdgIdC394ijcU78GAwT19d2k4DzSPbP79/FNNqkCQR10xvrcxlOw9570qGUPpanw/I5q
         /69ExKdkRNmzmVVL4Ll0obZM4H/soA0iyWKIJBH93bhSrZ0BggnkhPHI7k3JMFz80j/e
         9xa6kf8nKe0wu/KRq7FD3yTyuzhJHeXtuwW4irkt9pT+fV7HBu6yXYv+0+ZU7UhFrXE8
         +gHSifoUus6UW6L2zRAFQAu4N9ASE+1Nf5ZU0pV1B0GTVpYnTorZWsKLjjdBn9UNm+pO
         Uxew==
X-Forwarded-Encrypted: i=1; AJvYcCUZcXhU/mERFvHAt2/r5Ua3ffYhgr6KNxZpekQo2HL64bgfg1QzspcNLKL3Hgp9GQk+3Xs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOMyS+Z+MJfkl9Mao5j6cc+kTqSefcOPioMrEAUzQr+znXlh8A
	b5agu/meDGsVy99fJfRLqBOtldwnmfLe6i0HLnI4qKLnxluayA0qhIlEPyXJmuCjbn1yX8BxoSM
	61/MMbkHTbLGezx/hwt64uz/xrOxseFo=
X-Gm-Gg: ASbGnctxOH8QlbUy/NWk00NVGRot7f+3KlHZtemHCl4wEKsax6i+ml8hSeGEU3YN7Db
	8bws5ZHuHCplVjt5LqFJmOhWtppmQD0CbkmXR4+knxD6IjLH57TI05vnMhfKXvYdywo5LZ6cDlM
	MtbnxZpu1G1BvPVgKmGy8kB+hGfIuV/xhgpG1X0HaeBZ6k6xSl7AF25BIp8BCfJzAC0sbM7L41e
	bkFWrdaBWChWZYHxiRAkcNn2rs=
X-Google-Smtp-Source: AGHT+IFbZVQhDMTZX5lHB4SYuIOhlN6FkhvAMSCbWGjP3ldm7j7Gsp5zS04D+RgYwl9mCgd/9dZKpzCsIPW+fD5Fio4=
X-Received: by 2002:a05:622a:17cd:b0:4b6:226b:b6b7 with SMTP id
 d75a77b69052e-4ba6ca8ce97mr69471681cf.81.1758179185974; Thu, 18 Sep 2025
 00:06:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902022505.2034408-1-liulongfang@huawei.com>
 <20250902022505.2034408-3-liulongfang@huawei.com> <CAHy=t2_0X4_wqc+zm3Zk8aUPXmsOR57wiGmzR65PFHSa=gTrPA@mail.gmail.com>
 <bb9f8f5a-0cf0-98ef-d7b0-be132b8ce63f@huawei.com> <b9448065-f2ca-899d-e68a-c17e46546b40@huawei.com>
In-Reply-To: <b9448065-f2ca-899d-e68a-c17e46546b40@huawei.com>
From: Shameer Kolothum <shameerkolothum@gmail.com>
Date: Thu, 18 Sep 2025 08:06:16 +0100
X-Gm-Features: AS18NWDGcZI6pNQv-O1Ju-BU2j37aPK9mY1mlw4WtdW_H89-cFcfjh0yzdxwiqs
Message-ID: <CAHy=t29buypWspUjZLHfFjnbixSENfo4we5Q5h_yrSKXJgc2QA@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] hisi_acc_vfio_pci: adapt to new migration configuration
To: liulongfang <liulongfang@huawei.com>
Cc: alex.williamson@redhat.com, jgg@nvidia.com, jonathan.cameron@huawei.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Sept 2025 at 02:29, liulongfang <liulongfang@huawei.com> wrote:
>
> On 2025/9/11 19:30, liulongfang wrote:
> > On 2025/9/11 16:05, Shameer Kolothum wrote:
> >> On Tue, 2 Sept 2025 at 03:26, Longfang Liu <liulongfang@huawei.com> wrote:
> >>>
> >>> On new platforms greater than QM_HW_V3, the migration region has been
> >>> relocated from the VF to the PF. The VF's own configuration space is
> >>> restored to the complete 64KB, and there is no need to divide the
> >>> size of the BAR configuration space equally. The driver should be
> >>> modified accordingly to adapt to the new hardware device.
> >>>
> >>> On the older hardware platform QM_HW_V3, the live migration configuration
> >>> region is placed in the latter 32K portion of the VF's BAR2 configuration
> >>> space. On the new hardware platform QM_HW_V4, the live migration
> >>> configuration region also exists in the same 32K area immediately following
> >>> the VF's BAR2, just like on QM_HW_V3.
> >>>
> >>> However, access to this region is now controlled by hardware. Additionally,
> >>> a copy of the live migration configuration region is present in the PF's
> >>> BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
> >>> older version of the driver is loaded, it behaves like QM_HW_V3 and uses
> >>> the configuration region in the VF, ensuring that the live migration
> >>> function continues to work normally. When the new version of the driver is
> >>> loaded, it directly uses the configuration region in the PF. Meanwhile,
> >>> hardware configuration disables the live migration configuration region
> >>> in the VF's BAR2: reads return all 0xF values, and writes are silently
> >>> ignored.
> >>>
> >>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >>> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
> >>> ---
> >>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
> >>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  13 ++
> >>>  2 files changed, 157 insertions(+), 61 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >>> index 397f5e445136..fcf692a7bd4c 100644
> >>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >>> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
> >>>         return 0;
> >>>  }
> >>>
> >>> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>> +                          struct acc_vf_data *vf_data)
> >>> +{
> >>> +       struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> >>> +       struct device *dev = &qm->pdev->dev;
> >>> +       u32 eqc_addr, aeqc_addr;
> >>> +       int ret;
> >>> +
> >>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3) {
> >>> +               eqc_addr = QM_EQC_DW0;
> >>> +               aeqc_addr = QM_AEQC_DW0;
> >>> +       } else {
> >>> +               eqc_addr = QM_EQC_PF_DW0;
> >>> +               aeqc_addr = QM_AEQC_PF_DW0;
> >>> +       }
> >>> +
> >>> +       /* QM_EQC_DW has 7 regs */
> >>> +       ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> >>> +       if (ret) {
> >>> +               dev_err(dev, "failed to read QM_EQC_DW\n");
> >>> +               return ret;
> >>> +       }
> >>> +
> >>> +       /* QM_AEQC_DW has 7 regs */
> >>> +       ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> >>> +       if (ret) {
> >>> +               dev_err(dev, "failed to read QM_AEQC_DW\n");
> >>> +               return ret;
> >>> +       }
> >>> +
> >>> +       return 0;
> >>> +}
> >>> +
> >>> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>> +                          struct acc_vf_data *vf_data)
> >>> +{
> >>> +       struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> >>> +       struct device *dev = &qm->pdev->dev;
> >>> +       u32 eqc_addr, aeqc_addr;
> >>> +       int ret;
> >>> +
> >>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3) {
> >>> +               eqc_addr = QM_EQC_DW0;
> >>> +               aeqc_addr = QM_AEQC_DW0;
> >>> +       } else {
> >>> +               eqc_addr = QM_EQC_PF_DW0;
> >>> +               aeqc_addr = QM_AEQC_PF_DW0;
> >>> +       }
> >>> +
> >>> +       /* QM_EQC_DW has 7 regs */
> >>> +       ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> >>> +       if (ret) {
> >>> +               dev_err(dev, "failed to write QM_EQC_DW\n");
> >>> +               return ret;
> >>> +       }
> >>> +
> >>> +       /* QM_AEQC_DW has 7 regs */
> >>> +       ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> >>> +       if (ret) {
> >>> +               dev_err(dev, "failed to write QM_AEQC_DW\n");
> >>> +               return ret;
> >>> +       }
> >>> +
> >>> +       return 0;
> >>> +}
> >>> +
> >>>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >>>  {
> >>>         struct device *dev = &qm->pdev->dev;
> >>> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >>>                 return ret;
> >>>         }
> >>>
> >>> -       /* QM_EQC_DW has 7 regs */
> >>> -       ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> >>> -       if (ret) {
> >>> -               dev_err(dev, "failed to read QM_EQC_DW\n");
> >>> -               return ret;
> >>> -       }
> >>> -
> >>> -       /* QM_AEQC_DW has 7 regs */
> >>> -       ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> >>> -       if (ret) {
> >>> -               dev_err(dev, "failed to read QM_AEQC_DW\n");
> >>> -               return ret;
> >>> -       }
> >>> -
> >>>         return 0;
> >>>  }
> >>>
> >>> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >>>                 return ret;
> >>>         }
> >>>
> >>> -       /* QM_EQC_DW has 7 regs */
> >>> -       ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> >>> -       if (ret) {
> >>> -               dev_err(dev, "failed to write QM_EQC_DW\n");
> >>> -               return ret;
> >>> -       }
> >>> -
> >>> -       /* QM_AEQC_DW has 7 regs */
> >>> -       ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> >>> -       if (ret) {
> >>> -               dev_err(dev, "failed to write QM_AEQC_DW\n");
> >>> -               return ret;
> >>> -       }
> >>> -
> >>>         return 0;
> >>>  }
> >>>
> >>> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>>                 return ret;
> >>>         }
> >>>
> >>> +       ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
> >>> +       if (ret)
> >>> +               return ret;
> >>> +
> >>>         ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
> >>>         if (ret) {
> >>>                 dev_err(dev, "set sqc failed\n");
> >>> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>>         vf_data->vf_qm_state = QM_READY;
> >>>         hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
> >>>
> >>> +       ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
> >>> +       if (ret)
> >>> +               return ret;
> >>> +
> >>>         ret = vf_qm_read_data(vf_qm, vf_data);
> >>>         if (ret)
> >>>                 return ret;
> >>> @@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >>>  {
> >>>         struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> >>>         struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> >>> +       struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
> >>>         struct pci_dev *vf_dev = vdev->pdev;
> >>> +       u32 val;
> >>>
> >>> -       /*
> >>> -        * ACC VF dev BAR2 region consists of both functional register space
> >>> -        * and migration control register space. For migration to work, we
> >>> -        * need access to both. Hence, we map the entire BAR2 region here.
> >>> -        * But unnecessarily exposing the migration BAR region to the Guest
> >>> -        * has the potential to prevent/corrupt the Guest migration. Hence,
> >>> -        * we restrict access to the migration control space from
> >>> -        * Guest(Please see mmap/ioctl/read/write override functions).
> >>> -        *
> >>> -        * Please note that it is OK to expose the entire VF BAR if migration
> >>> -        * is not supported or required as this cannot affect the ACC PF
> >>> -        * configurations.
> >>> -        *
> >>> -        * Also the HiSilicon ACC VF devices supported by this driver on
> >>> -        * HiSilicon hardware platforms are integrated end point devices
> >>> -        * and the platform lacks the capability to perform any PCIe P2P
> >>> -        * between these devices.
> >>> -        */
> >>> +       val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
> >>> +       if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
> >>> +               hisi_acc_vdev->drv_mode = HW_ACC_V4;
> >>> +       else
> >>> +               hisi_acc_vdev->drv_mode = HW_ACC_V3;
> >>
> >> The check is for > QM_HW_V3 and drv_mode is set to HW_ACC_V4. From our
> >> previous discussions I think the expectation is that future hardware will follow
> >> this same behaviour. If that is the case, it is better to rename HW_ACC_  to
> >> something more specific to this change than use the V3/V4 name.
> >>
> >
> > If the goal is merely to reflect the context of this change, it would be better to add
> > a comment describing this change directly at the variable's declaration.
> >
>
> Hi, Shameer:
> If there are no further issues, I will continue using the current naming convention and
> add comments at the declaration sites.

I would still prefer naming it differently than just adding comments.
Maybe something like
below + comments in the header.

if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
     hisi_acc_vdev->mig_ctrl_mode = HW_ACC_MIG_PF_CTRL;
else
    hisi_acc_vdev->mig_ctrl_mode = HW_ACC_MIG_VF_CTRL;

Also please don't respin just for this yet. Please wait for Alex to take a look.

Thanks,
Shameer

