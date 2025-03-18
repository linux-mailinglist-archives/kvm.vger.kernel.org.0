Return-Path: <kvm+bounces-41422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 230E1A67B77
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:58:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F08873ADC13
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFECB211A2E;
	Tue, 18 Mar 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7NFpWXh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C637211481
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320720; cv=none; b=TPIn/2PAK3lu3cdezsN8Biw7GQZF0RQuXnC9SPLRhLcIkLIyySEeaP1erSGKJW7NTXw7y5i3kmS/5wAbUE4QL0LbuRHPy4Pc9CwtT46rXckpr8QviFjXF//rR3RAMMjiPsA6Jed5Pou5sjt9L5LRct28/FiQ6KmutCP+CPfUqj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320720; c=relaxed/simple;
	bh=+1bVEzEad7VOho/IB0KwOIvylNq1MXEC0hJ8cVRnBS8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPvX5zIahvBckmmR97GBu+vODWzfQfWKr7nOrmr1Ws9eND5TFvsoBh+/Ov91tcaM/AUDRN10HUS5wRemB6xr72nZGqizZVh8/gYOYS1PGN1/TmrhEmQokF4irsE/jQtBn+CDkuO/Pplu98tb6uTqGY5kLmSFx1mQ28EJAx1SpMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7NFpWXh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742320718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bxl1Ld3BAp4jOPXx2r3UoMSFMwZHzeN8OlZBrkNTKbo=;
	b=L7NFpWXhqmR4EHEZHpwPW8xqYqu8UhWP5E+QOg7OnEYokwTG/f8ShsC/rRk1S4eMZEykYH
	UkMdooQQGjfF9tXStXSEGqV9j0G6nmcNrf0svO8LWbxYVm/7iaf+oF4Vu14v2w5M17GR+Q
	qREZZAMrtZ96zB1w1UxX/N9LGPaIlbY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-NHk4o89_MySghJOF2Vv2JQ-1; Tue, 18 Mar 2025 13:58:36 -0400
X-MC-Unique: NHk4o89_MySghJOF2Vv2JQ-1
X-Mimecast-MFC-AGG-ID: NHk4o89_MySghJOF2Vv2JQ_1742320716
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-858755ba77cso62302339f.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 10:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320716; x=1742925516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bxl1Ld3BAp4jOPXx2r3UoMSFMwZHzeN8OlZBrkNTKbo=;
        b=r3k4fbnu7iVba+bcxUo/Wo+oyxKNutWxwJqgfx3VS1q3Op8BjrT6+EBR0/s8G5OH/a
         0lUudA8tjpsq+rbnxHf0IgX+B80dGp90ZOjlbJBikXLpVIAuXLqor6txdPJ5RZ46wTt5
         BQQtttFblK3LuDxa0U9UlDGN6+cA1PasBIwoEfBWg0OExbB8cOb1qadCgUWqOtjgAVG0
         s12l5RgeZmk/bCWHkbwuIE4gsDjICCB/vlBrsbnklId2Y75qkwgQdpmbupT0Y1o3B3CX
         f1jestOp9k8eLjCtUSoqqbt3p6//JkPuilwCXLVk7cpyYwv2VPnz9qMTx0l/dH1raAc3
         Hq4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUPGwMMERfkClBJ/vT8ILRpmEBT2qtKaENAT6HkT9cp5DPeNIac+rsTiJgwLE7EH3wa9hY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF17KTbRGVi529kvR4zW4BWCIvS6rToDGC58amKoYmn6hm3pku
	/gpJBe1Z5kX5gvONWAkpP9cGKsvVaSHaqvto8Y3zHvUa3M/zoLMv67mQp6GZlOFULvOVjPSyIqO
	PnsRAilFo9Hu9DbnAsC9K9Xrj8Es4v3m37AETDDN/PbYPBmRFdA==
X-Gm-Gg: ASbGncupwTdsqa1RXJoPiea8dY6sUkliVMe1mfzE/4wBQa8S+sdpkz+LCc3zHFrtsi6
	yFjzSNF1D86QUTG5J0ms4aYRoE6GALBT2sZ27BvBKs2vIX8+apuhTGFCKdyJ1W42sJEe0sdnJoN
	tDcaG5DYgHHK0bkY1gTd2kbqDmHy2YvIDUEcfaBI/UA6Ut/eF9/N0X01/WcVIAv/LWPn+55MUCK
	Mf7bzWx0WClG+NqgX86wkgU+1R/nbp+Ij3vzFvcNUHuGpdye9tnP2yh8l3yXJfyaMSA4KVbzIiL
	vILivZqwM9GLqKki6FU=
X-Received: by 2002:a05:6602:620e:b0:855:9e01:9acf with SMTP id ca18e2360f4ac-85dc4820bb0mr535552039f.1.1742320715772;
        Tue, 18 Mar 2025 10:58:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlkkLLnQNtTDFReWf7pCaR7vIy9TXueCWKVkZHXRvNIS2pfiS2nIoGKt6+5q9CMJ94ft2RMA==
X-Received: by 2002:a05:6602:620e:b0:855:9e01:9acf with SMTP id ca18e2360f4ac-85dc4820bb0mr535550839f.1.1742320715386;
        Tue, 18 Mar 2025 10:58:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f263816a1fsm2807665173.110.2025.03.18.10.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 10:58:34 -0700 (PDT)
Date: Tue, 18 Mar 2025 11:58:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: jgg@ziepe.ca, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, yi.l.liu@intel.com, Yunxiang.Li@amd.com,
 pstanner@redhat.com, maddy@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] vfio: pci: Advertise INTx only if LINE is connected
Message-ID: <20250318115832.04abbea7.alex.williamson@redhat.com>
In-Reply-To: <174231895238.2295.12586708771396482526.stgit@linux.ibm.com>
References: <174231895238.2295.12586708771396482526.stgit@linux.ibm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Mar 2025 17:29:21 +0000
Shivaprasad G Bhat <sbhat@linux.ibm.com> wrote:

> On POWER systems, when the device is behind the io expander,
> not all PCI slots would have the PCI_INTERRUPT_LINE connected.
> The firmware assigns a valid PCI_INTERRUPT_PIN though. In such
> configuration, the irq_info ioctl currently advertizes the
> irq count as 1 as the PCI_INTERRUPT_PIN is valid.
> 
> The patch adds the additional check[1] if the irq is assigned
> for the PIN which is done iff the LINE is connected.
> 
> [1]: https://lore.kernel.org/qemu-devel/20250131150201.048aa3bf.alex.williamson@redhat.com/
> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Suggested-By: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 586e49efb81b..4ce70f05b4a8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -734,6 +734,10 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>  			return 0;
>  
>  		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
> +#if IS_ENABLED(CONFIG_PPC64)
> +		if (!vdev->pdev->irq)
> +			pin = 0;
> +#endif
>  
>  		return pin ? 1 : 0;
>  	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
> 
> 

See:

https://lore.kernel.org/all/20250311230623.1264283-1-alex.williamson@redhat.com/

Do we need to expand that to test !vdev->pdev->irq in
vfio_config_init()?  We don't allow a zero irq to be enabled in
vfio_intx_enable(), so we might as well not report it as supported.  I
don't see why any of this needs to be POWER specific.  Thanks,

Alex


