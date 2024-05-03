Return-Path: <kvm+bounces-16523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA2FE8BB09B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 18:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC0E01C21117
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 16:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1AA155342;
	Fri,  3 May 2024 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M6StspMX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CA846421
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714752707; cv=none; b=TRHqCx/uxj6q+dhuaJdfGxJLTXLLbQhVt4WZTEAEt5ChOeIzoUwoeCa3a4B4p0XiOnczwn1sGADPFqu7w72VAftUQ9XwluZmL1A5/erMF22HChyPI9d3jkP/UXwBAPdRhlFOYZySfQu87cwoQxoirD1RbBaPS9WAP/cOTkYaeu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714752707; c=relaxed/simple;
	bh=lBc8mIGqc0Pyzb4/0nOXv6g1qY48kquuboJ7JtBmRDE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fD1bKj8HuldYgZMFvNUDSOcjyylFQPTIpk7gozkK5jzcl589CcNrmJJ1Iavmas/+hsaKmA0wBiyi+LZJIZcxSQxTevpjl5+W1uFf5LS3SQKtr1Cs+pFZwOls9mtaGrO/H4PoY00WPQXvcyn6CoiWl3d07Y/t+ZDTSyPT5FbDNT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M6StspMX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714752704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZOiOpZyBKuObIgtTt9nNi/hSpkFKeeLY85af4HJ/a4=;
	b=M6StspMXWxDtjYNCJHLKmyH56gq+sTqScXZyZk0/hpMq3GXDDSZGihVSxKGRHlPtXXkjij
	aZaImnUGCg1U1CPtwo/VDbQqfNMdEwoGa97RxSqYpMCGsFI3odhpdLWxfwBklt0l+NC6/3
	SoKSa5wg37PrHmwzr99N6cr9Dr2z7QI=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-Wm13e3SFOoKAHtUeYDxJZQ-1; Fri, 03 May 2024 12:11:43 -0400
X-MC-Unique: Wm13e3SFOoKAHtUeYDxJZQ-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5aa50631e23so9762199eaf.2
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 09:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714752703; x=1715357503;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ZOiOpZyBKuObIgtTt9nNi/hSpkFKeeLY85af4HJ/a4=;
        b=dCw3rI+rf6irqpIGfml8s2obatCz3kP3scTJuuG0scbxIkL/bO5T8dSaHg5N9cu8Vp
         TA3KRX/FnXpdapHr+3s+FLfNyBP+sXs8N2aTvzy1dZJv/azFWjz90m/2jEqLr4osbBB9
         KEPfKmgKjZj2eVQ6ol33KXtGG+ZvTaasGlzLfJSSIPf2eqBZer0lpwYpKnzjtdTI0aHw
         08VfU0Uy2ybL/+fL0ZzN4sksl5drAzHSXsJysX4E02T8tXfnzXk5bNcrOARI8rDevd2R
         RFwYtB+m8YuVIveMNvEKOwlke4nBkZeTo824DPkCnqx5/Hr27EckQHrmffJDYh+Iu3vj
         NC5w==
X-Forwarded-Encrypted: i=1; AJvYcCV+FAjXxIHcRjLbtlaCpZ3oH6Y6uOUkA47/hYyi6z87REbwEMWSVEm9/++lajwt/RCFcjYstbVmNJA8h1Bp/RM6KcfH
X-Gm-Message-State: AOJu0YxP9cCHSBoth+xl7USl4XWDdgDvuOUy0ZeV9nbdgkyrOUN7+UFq
	3r2Ce0hIOK1U0Ijpv48UaQNxHzkTNESPjj1ziZOaTkmiUOZvGcEsMPo13sxSfI3rfqhFv/ghIAn
	U6wR2t3pSbgA9qko/W9CSq8WalXpk6+OMk0iTXRUICq0YZpiBdw==
X-Received: by 2002:a4a:d888:0:b0:5ac:bdbf:8a31 with SMTP id b8-20020a4ad888000000b005acbdbf8a31mr3298911oov.8.1714752702770;
        Fri, 03 May 2024 09:11:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENI13JqeWl+3nRXkEgDH9DAZfXX8Y7O0g+Kcb7NHM7u5AIluDQAEa1B47G9dtTONyGkn4Qkw==
X-Received: by 2002:a4a:d888:0:b0:5ac:bdbf:8a31 with SMTP id b8-20020a4ad888000000b005acbdbf8a31mr3298888oov.8.1714752702398;
        Fri, 03 May 2024 09:11:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id cg12-20020a056820098c00b005b1da7520c9sm358982oob.7.2024.05.03.09.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 09:11:42 -0700 (PDT)
Date: Fri, 3 May 2024 10:11:38 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location
 of the XQC address
Message-ID: <20240503101138.7921401f.alex.williamson@redhat.com>
In-Reply-To: <20240425132322.12041-3-liulongfang@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
	<20240425132322.12041-3-liulongfang@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Apr 2024 21:23:19 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> According to the latest hardware register specification. The DMA
> addresses of EQE and AEQE are not at the front of their respective
> register groups, but start from the second.
> So, previously fetching the value starting from the first register
> would result in an incorrect address.
> 
> Therefore, the register location from which the address is obtained
> needs to be modified.

How does this affect migration?  Has it ever worked?  Does this make
the migration data incompatible?

Fixes: ???

> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 8 ++++----
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h | 3 +++
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 45351be8e270..0c7e31076ff4 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -516,12 +516,12 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return -EINVAL;
>  
>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> +	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
> +	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
>  
>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 5bab46602fad..f887ab98581c 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -38,6 +38,9 @@
>  #define QM_REG_ADDR_OFFSET	0x0004
>  
>  #define QM_XQC_ADDR_OFFSET	32U
> +#define QM_XQC_ADDR_LOW	0x1
> +#define QM_XQC_ADDR_HIGH	0x2
> +
>  #define QM_VF_AEQ_INT_MASK	0x0004
>  #define QM_VF_EQ_INT_MASK	0x000c
>  #define QM_IFC_INT_SOURCE_V	0x0020


