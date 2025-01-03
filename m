Return-Path: <kvm+bounces-34536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3389A00D16
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 18:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40DAD7A0691
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 17:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82FB1FC115;
	Fri,  3 Jan 2025 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DedKMqRj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE3A1FA8C3
	for <kvm@vger.kernel.org>; Fri,  3 Jan 2025 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735926274; cv=none; b=gxgHLVQespRYjB7NREpfbhy3VFZQe9sWj1bKB5EAd1KFoDYL8/v1Pe4LR3CY79cRnQBJNW7+8SeiigctEC6UXVS9Vxj4S2zOYV6uE26sFBOJnYMCu6TfGMkR5OtL0T0U2XfP9wfMnjxw60RMI9Fbl9eidLfkf0ACMcDgVzEQ+qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735926274; c=relaxed/simple;
	bh=AAgcV5tMz9BZdUs8hahSn8mwaUiZZq1ZZhygCHYZ6CY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8xn7nwR9dZLPg+bhlOLF7+cq7fYDP7t7sh0KC/Fj3+7TikS7QuzYMXPJAPY0u/0pS7LzC/M7xfIqvCNmb0aetC8bKSPwf0OhV4tcq7FKc+79YatekQiM+ZqfMaJuBDjzaptJfJo5g6PFnvIcNFXX2zlrGC/0KAsVUAsadOv0P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DedKMqRj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735926271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=stVorBa8A94z2zV/9XfcMpSZKaiKlGhrH0FQVM2KGjE=;
	b=DedKMqRjdd2eBHCt7VVzVQRKmC03wDc+S908c8AyEDWRJaDjGsYhF3vvv2aOZiSNrBnKRU
	dIRBiDhnm931yGKItUT8wZHjP1g4kpVNNXnXfLN+qEbbFfDDrqyKPsN+ZVFIbJeQHrkQJ2
	ijIHofpufOEOZ4Mq1BzwoS6X23EYJ2s=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-eeLVZb0QOx67nsCWvZf89g-1; Fri, 03 Jan 2025 12:44:30 -0500
X-MC-Unique: eeLVZb0QOx67nsCWvZf89g-1
X-Mimecast-MFC-AGG-ID: eeLVZb0QOx67nsCWvZf89g
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-844e255c111so19386439f.0
        for <kvm@vger.kernel.org>; Fri, 03 Jan 2025 09:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735926270; x=1736531070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=stVorBa8A94z2zV/9XfcMpSZKaiKlGhrH0FQVM2KGjE=;
        b=nTwJeHsaVI0AArh5a9/RnAkC2n6S82R46a8zUOD9P+rWU1MCdbXERU5VDfbBEApSSt
         7GcQAto2sL3uHEY45f1lluX2O6YAtBCYwp3jFtUOGanNHvhiyzayeoziCHtvb2Wf2j4Q
         agkjNDK93SR60kY9h3pomJ4wcsK7TbvlC8uXLMhUn8mqzi3uhwvPG041UK8pg/o2i13X
         2VCD0xn6e1O+/X4504pIMS2VXrkxISK+COmIi3/o3hT4fdJx3DCrdcOJ836ZlUff8dT4
         NXRQkICkGP7r1FBKOeXN7wiA0GJA3prqqPnnFXYK9jjbFY+SFxOXgnKuXbG91ji1u+eP
         pyRA==
X-Gm-Message-State: AOJu0Yzaz9gT0aGCWabzH1p9gZjd5Mq68l09JaxEknj0FeRiYQAnzPkH
	4RF30rUSpa8LPFljFbuvJfzO/rPeiIBthMKkoxan3KcRfvZ/1uNTYQuhm+f+nbzn/PrfEQzj+kh
	7jyRZUFRR7BtNlfBYHCKmLbGl2DhyYHiZqOkfqEvLDPNSeH5JOdXSHz0/Vw==
X-Gm-Gg: ASbGncuZrXNMM+fb4s0XVVUROpeSQn/wtnOu8DsBvGgiFFTe/cAtYiOkGC+y6hvqdi1
	hvpjga31WR5/+a+35aUVzNZjKRxXiMiqQD7IebnMYuQnAbISNokBzg1bGD487p68hNvJ8zk/CKq
	t0jbN6vTZ8UWgx7iuDgOnAKRtkInfDxrE+84UYdDifLBlmOi839P+OC3ynTRKmX/+lkHFTP/sat
	sNqNe43dt20UrvXlfWmtG8vYzhj2rgNB7esj3HxYvzJkAAJcJJAtPNRW5Jo
X-Received: by 2002:a05:6602:15c4:b0:847:4d2b:c801 with SMTP id ca18e2360f4ac-8499e83514emr1422316439f.4.1735926269911;
        Fri, 03 Jan 2025 09:44:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGu3BpX2PdS7QzM0Su8SzwKRFBMD1Cg1PPXO+4xkYW0ad+NnSpTjodno5nXHYSFgJEMCAWs9g==
X-Received: by 2002:a05:6602:15c4:b0:847:4d2b:c801 with SMTP id ca18e2360f4ac-8499e83514emr1422316039f.4.1735926269563;
        Fri, 03 Jan 2025 09:44:29 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c21a232sm7720813173.145.2025.01.03.09.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 09:44:29 -0800 (PST)
Date: Fri, 3 Jan 2025 10:44:27 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Tomita Moeko <tomitamoeko@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio/pci: update igd matching conditions
Message-ID: <20250103104427.55f1c73b.alex.williamson@redhat.com>
In-Reply-To: <20241230161054.3674-2-tomitamoeko@gmail.com>
References: <20241230161054.3674-2-tomitamoeko@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 31 Dec 2024 00:10:54 +0800
Tomita Moeko <tomitamoeko@gmail.com> wrote:

> igd device can either expose as a VGA controller or display controller
> depending on whether it is configured as the primary display device in
> BIOS. In both cases, the OpRegion may be present. Also checks if the
> device is at bdf 00:02.0 to avoid setting up igd-specific regions on
> Intel discrete GPUs.
> 
> Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
> ---
> Changelog:
> v2:
> Fix misuse of pci_get_domain_bus_and_slot(), now only compares bdf
> without touching device reference count.
> Link: https://lore.kernel.org/all/20241229155140.7434-1-tomitamoeko@gmail.com/
> 
>  drivers/vfio/pci/vfio_pci.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index e727941f589d..906a1db46d15 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -111,9 +111,11 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
>  	if (ret)
>  		return ret;
>  
> -	if (vfio_pci_is_vga(pdev) &&
> -	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
> +	    (pdev->vendor == PCI_VENDOR_ID_INTEL) &&
> +	    (((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) ||
> +	     ((pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER)) &&
> +	    (pci_dev_id(pdev) == PCI_DEVID(0, PCI_DEVFN(2, 0)))) {

Sorry I wasn't available to reply on previous thread before v2 was
posted, but given that we have vfio_pci_is_vga() we should use it
rather than duplicate the contents.  I think that suggests we should
create a similar helper for display_other.  Alternatively we should
maybe consider if it's sufficient to use just the base class.

The DEVID of course does not include the domain, which make it a rather
suspect check already.  What do the discrete cards report at 0xfc in
config space?  If it's zero or -1 or points to something that we can't
memremap() or points to contents that doesn't include the opregion
signature, then we'll already exit out of vfio_pci_igd_init().  Is
there actually a case that we're actually configuring IGD specific
regions for a discrete card?  Thanks,

Alex

>  		ret = vfio_pci_igd_init(vdev);
>  		if (ret && ret != -ENODEV) {
>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");


