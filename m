Return-Path: <kvm+bounces-16828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 252D88BE248
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:36:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9554289685
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 12:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E20A15B13C;
	Tue,  7 May 2024 12:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Og7f3jyC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8A215749B
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 12:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715085361; cv=none; b=ia/UJKGvnZQA+VqrFefjdlP/XQGy7hCgpDWUMO42vHx+KxIuSkQr6cjnyXUMBT9Sl3oGF6y4BMkc2zR2qHqgv7LTT70ROK8CTmbSjK1OIwnurLdKZOLNHH07Z4CxS0gKDpAcjbi+f9mTh2Pt9Aoh/Sou6QwvaXZAz9KOgV/v3G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715085361; c=relaxed/simple;
	bh=/VqOVOf+Chp6Cx4kGTVzbLFZ8Tk5g5gkPOnVTDN1n/g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXd82kx/3zgw4Zk+vXEBZDX+3qPnZGlt/YLEj4rD9Ue49ilyLZJvpHjy5EYq0DTELpTJmWYHi8fkddcI8BFhxHtoIxjYRfG2JkgEuRPLQj4OTOFWgogfjV+OZ/l5Ip3HQBh2FJdIOylGtZSPfO0syia9G3xDUGH2nUiTN7y+TV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Og7f3jyC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715085358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z82EnBE6w/YMHyWlquYeC6kxPT63rf43ffus2zTDhaE=;
	b=Og7f3jyC13oE2TxhHkcRNCmH309d1ZYrVn8ScZaCjVoiOVHFdJnGDR6ydADEbjDVvcMykX
	VdwygDkkNXfrEP7bB9ebjVm5B0rRVbpxLT06WDhktlAatAJ8wdSajPQBIDgqSRHS7dtWaY
	WM/Vk8gAKvBXp47U3fzqhAg8e5jej2A=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-HrZf4vFQNSeRBrgnySg_cw-1; Tue, 07 May 2024 08:35:57 -0400
X-MC-Unique: HrZf4vFQNSeRBrgnySg_cw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-23527d696fdso2820391fac.2
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 05:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715085356; x=1715690156;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z82EnBE6w/YMHyWlquYeC6kxPT63rf43ffus2zTDhaE=;
        b=PzIEpbI8liYCXqwfr+pSuvq+wfF8ZCVSssdRjdUvZkq1h9n9exe4h0g+d1wLMpSpTu
         JO7KHPpH2VG4RRh/u9kBCrYETVl++5t9A43aiDXb+X9MPP5EPt+6SF4KdrOzrUlGDa9e
         J0ZQuwcnFl23opnhr3z4vXqshZShhCXqtOMVbsPq53R1+k9jbpuovEWraGd3cEumv7Xf
         e87Y+ZtwE1M1O/LEqSyhfnHz/rUE4IV7DWPHZ1zn7h8pEeOelzjQN/8WPNVmr/fPeo8h
         FFZ0I7nz8T5bYzdndxI0jiOSVG9amY8uA8ni0S0Ti/MJM+MnGvvExYsiRMlarlQw7oXS
         Kxlw==
X-Forwarded-Encrypted: i=1; AJvYcCX+ZsMxHO+5vr1A/ZqdrZF7EBrRjWNCSGfcooqnuLb/IidtrT4yPgcUi+25uwXuN4BGyADb6ZlxW1wujxZ9Be/kc6cq
X-Gm-Message-State: AOJu0YxgUXMAvIzHSGdbvgnoU9v8uIGhfPkKyjsx8XxV/23z6Nmly+RL
	7O26HFyCorrNOOS9GHZ6EYyoPcyYRJYD12iMEkoz6cmxyA30NgbMtsdMTlGTwrQnT5THgTbVgUf
	PeBAKFujkxyonS5WsGjuc8As7fpsLIEIhL6p3opIZHd8ih0xsrw==
X-Received: by 2002:a05:6870:440c:b0:23f:f53c:300f with SMTP id u12-20020a056870440c00b0023ff53c300fmr3908827oah.50.1715085356362;
        Tue, 07 May 2024 05:35:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRVuyDs7cUEq7Dy4vZ69Ps3PmD7nNwnp8Uza+87Ob0e9rwCtgqxkxMxUdgN7WUk1w/lnvRow==
X-Received: by 2002:a05:6870:440c:b0:23f:f53c:300f with SMTP id u12-20020a056870440c00b0023ff53c300fmr3908815oah.50.1715085356060;
        Tue, 07 May 2024 05:35:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id uu1-20020a056870ae0100b002392041da7dsm2532131oab.48.2024.05.07.05.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 05:35:55 -0700 (PDT)
Date: Tue, 7 May 2024 06:35:52 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: liulongfang <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location
 of the XQC address
Message-ID: <20240507063552.705cb1b6.alex.williamson@redhat.com>
In-Reply-To: <bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
	<20240425132322.12041-3-liulongfang@huawei.com>
	<20240503101138.7921401f.alex.williamson@redhat.com>
	<bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 May 2024 16:29:05 +0800
liulongfang <liulongfang@huawei.com> wrote:

> On 2024/5/4 0:11, Alex Williamson wrote:
> > On Thu, 25 Apr 2024 21:23:19 +0800
> > Longfang Liu <liulongfang@huawei.com> wrote:
> >   
> >> According to the latest hardware register specification. The DMA
> >> addresses of EQE and AEQE are not at the front of their respective
> >> register groups, but start from the second.
> >> So, previously fetching the value starting from the first register
> >> would result in an incorrect address.
> >>
> >> Therefore, the register location from which the address is obtained
> >> needs to be modified.  
> > 
> > How does this affect migration?  Has it ever worked?  Does this make  
> 
> The general HiSilicon accelerator task will only use SQE and CQE.
> EQE is only used when user running kernel mode task and uses interrupt mode.
> AEQE is only used when user running task exceptions occur and software reset
> is required.
> 
> The DMA addresses of these four queues are written to the device by the device
> driver through the mailbox command during driver initialization.
> The DMA addresses of EQE and AEQE are migrated through the device register.
> 
> EQE and AEQE are not used in general task, after the live migration is completed,
> this DMA address error will not be found. until we added a new kernel-mode test case
> that we discovered that this address was abnormal.
> 
> > the migration data incompatible?
> >  
> 
> This address only affects the kernel mode interrupt mode task function and device
> exception recovery function.
> They do not affect live migration functionality

Then why are we migrating them?  Especially EQE, if it is only used by
kernel mode drivers then why does the migration protocol have any
business transferring the value from the source device?  It seems the
fix should be not to apply the value from the source and mark these as
reserved fields in the migration data stream.  Thanks,

Alex

 
> > Fixes: ???
> >   
> 
> OK!
> 
> Thanks.
> Longfang.
> >> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >> ---
> >>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 8 ++++----
> >>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h | 3 +++
> >>  2 files changed, 7 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> index 45351be8e270..0c7e31076ff4 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> @@ -516,12 +516,12 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>  		return -EINVAL;
> >>  
> >>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> >> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
> >> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> >>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> >> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
> >> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
> >> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> >> +	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
> >>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> >> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
> >> +	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
> >>  
> >>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
> >>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> index 5bab46602fad..f887ab98581c 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> @@ -38,6 +38,9 @@
> >>  #define QM_REG_ADDR_OFFSET	0x0004
> >>  
> >>  #define QM_XQC_ADDR_OFFSET	32U
> >> +#define QM_XQC_ADDR_LOW	0x1
> >> +#define QM_XQC_ADDR_HIGH	0x2
> >> +
> >>  #define QM_VF_AEQ_INT_MASK	0x0004
> >>  #define QM_VF_EQ_INT_MASK	0x000c
> >>  #define QM_IFC_INT_SOURCE_V	0x0020  
> > 
> > .
> >   
> 


