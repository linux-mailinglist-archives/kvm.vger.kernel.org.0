Return-Path: <kvm+bounces-31040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B166D9BF88C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70F5F284324
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA7C20CCE0;
	Wed,  6 Nov 2024 21:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZRClz3jO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F65F20C47E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730928828; cv=none; b=oP09BW8ZSunSgCx8+YQ7A4FrrVU+XhEThcXX134wNq37RDIt4czRIkuIoi5JZmFcQI8IWAAO4ebIXHLR+J3q+8pK3uke3O71Mx2eZeB91ZEjT53bX9UChd8wwZIlsFmQbZXTmotzUOH2cPtgoGxd/5qLE3OLQh0rnU1xP2f9HeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730928828; c=relaxed/simple;
	bh=fdOaNFvjHNhZvAo41H3nYbZtuHMgOflDpg4KuZc1jzg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MjnvvILiaV8y4OP+2fK+Wj969OetgyDOA2UVPMmsaYzXpFYcqTQzBluQ+WF0gvemxOrRziim3L2vAAAs4vggkJeSyfh6RrSONf1LfShNrslHxTGUEek4DAFJvVWXbizVSHRQbbz5keEzq6fXanXf6ll7IOoDn6LxHAPedkcnMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZRClz3jO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730928825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3rFuWga3DWj70TxE9k7zWnQDJYpC4sUfbe1+XXpU5Mo=;
	b=ZRClz3jOJnFTw/Rslvc4FyK5hPTmuBrCn562MN283zlVuKTLzFINZWY+7AxZ+jeoEM+1cW
	K/4SDTRcWHv2lKYsKmVLYKZj9Lr7hQkrLAt4BGMBYir8/AeBBCgDkVMZ8GKCddZSf18S3p
	pMplibFpeHGQUvqvz0xIXh23jQqer2I=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-FTYMPgNtMsOkDbAJKixwYA-1; Wed, 06 Nov 2024 16:33:44 -0500
X-MC-Unique: FTYMPgNtMsOkDbAJKixwYA-1
X-Mimecast-MFC-AGG-ID: FTYMPgNtMsOkDbAJKixwYA
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83b7cce903cso6143839f.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 13:33:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730928824; x=1731533624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rFuWga3DWj70TxE9k7zWnQDJYpC4sUfbe1+XXpU5Mo=;
        b=ShCXJdXHo400nkktHvzLtUJYrn8QiuZwX471QiakxIwnwqgQWkg7xTX1MhHesMxUdP
         A456p3ve3Yb4hUS+m3btnxDmdVr77UOIMLDNOIlBHfc6wVBmNW8Z1XxVURNwelxrxzm8
         b4fVpW9XDmlDiYP7oqu1hNudUO2aoVilY613Qm9kze7BMB5c0hfBMZ+vysiDyJZiYxEv
         SpVY50QkqUNUUKqUv0Ii4HU0w4xxMKfG4KAeArer2uQKMGobuD78EoD7tsW9lNRZe7Rp
         b3KN7v35hMYIQiNHzkYxy887TTqqRqkRekgOH+XjlxTz452F/lEXpywdY3KJo6SVHQi9
         TBOA==
X-Forwarded-Encrypted: i=1; AJvYcCVKyXNA/VApoNtj8c3tj6EaU2Aw8JVKlDsN/DKL2AQtKkyt60YK78c2N1l5YzU3DiKLTew=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv0NhPoRiTo6yu7q2ujc0TPwIX7tlCMYlP2ici6X3C6V+4u3hM
	/AMltw7tHUzAd/d6kVpHXo1ZjHqxTAAtrWrTCBDrP/+nxciCiVb7ScvcBfQrc7etJ/qoHZhM7Bc
	cf9f0qaPKfiVmTskDE0SijZDMR2UUXQwoY+dtyUIrjJNdNk8COA==
X-Received: by 2002:a05:6e02:218a:b0:3a2:6cd7:3255 with SMTP id e9e14a558f8ab-3a6e84df7d1mr3656925ab.6.1730928824180;
        Wed, 06 Nov 2024 13:33:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuT+VT9roBsHPUnIHBvMzoBnoPeaxTloo7Ag+mF34Wwwx3rkMzbNjX101Do2BtnATBTfkrHQ==
X-Received: by 2002:a05:6e02:218a:b0:3a2:6cd7:3255 with SMTP id e9e14a558f8ab-3a6e84df7d1mr3656805ab.6.1730928823737;
        Wed, 06 Nov 2024 13:33:43 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6c6643853sm23973195ab.43.2024.11.06.13.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 13:33:43 -0800 (PST)
Date: Wed, 6 Nov 2024 14:33:41 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 5/7] vfio/virtio: Add support for the basic live
 migration functionality
Message-ID: <20241106143341.1b23936c.alex.williamson@redhat.com>
In-Reply-To: <eebad7d5-d7c2-4910-872c-c362c246aa78@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241104102131.184193-6-yishaih@nvidia.com>
	<20241105154746.60e06e75.alex.williamson@redhat.com>
	<eebad7d5-d7c2-4910-872c-c362c246aa78@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 6 Nov 2024 12:21:03 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 06/11/2024 0:47, Alex Williamson wrote:
> > On Mon, 4 Nov 2024 12:21:29 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:  
> >> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> >> index b5d3a8c5bbc9..e2cdf2d48200 100644
> >> --- a/drivers/vfio/pci/virtio/main.c
> >> +++ b/drivers/vfio/pci/virtio/main.c  
> > ...  
> >> @@ -485,16 +478,66 @@ static bool virtiovf_bar0_exists(struct pci_dev *pdev)
> >>   	return res->flags;
> >>   }
> >>   
> >> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
> >> +{
> >> +	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
> >> +			struct virtiovf_pci_core_device, core_device.vdev);
> >> +	struct pci_dev *pdev;
> >> +	bool sup_legacy_io;
> >> +	bool sup_lm;
> >> +	int ret;
> >> +
> >> +	ret = vfio_pci_core_init_dev(core_vdev);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	pdev = virtvdev->core_device.pdev;
> >> +	sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
> >> +				!virtiovf_bar0_exists(pdev);
> >> +	sup_lm = virtio_pci_admin_has_dev_parts(pdev);
> >> +
> >> +	/*
> >> +	 * If the device is not capable to this driver functionality, fallback
> >> +	 * to the default vfio-pci ops
> >> +	 */
> >> +	if (!sup_legacy_io && !sup_lm) {
> >> +		core_vdev->ops = &virtiovf_vfio_pci_ops;
> >> +		return 0;
> >> +	}
> >> +
> >> +	if (sup_legacy_io) {
> >> +		ret = virtiovf_read_notify_info(virtvdev);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >> +		virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
> >> +					virtiovf_get_device_config_size(pdev->device);
> >> +		BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
> >> +		virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
> >> +						     GFP_KERNEL);
> >> +		if (!virtvdev->bar0_virtual_buf)
> >> +			return -ENOMEM;
> >> +		mutex_init(&virtvdev->bar_mutex);
> >> +	}
> >> +
> >> +	if (sup_lm)
> >> +		virtiovf_set_migratable(virtvdev);
> >> +
> >> +	if (sup_lm && !sup_legacy_io)
> >> +		core_vdev->ops = &virtiovf_vfio_pci_lm_ops;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>   static int virtiovf_pci_probe(struct pci_dev *pdev,
> >>   			      const struct pci_device_id *id)
> >>   {
> >> -	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
> >>   	struct virtiovf_pci_core_device *virtvdev;
> >> +	const struct vfio_device_ops *ops;
> >>   	int ret;
> >>   
> >> -	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
> >> -	    !virtiovf_bar0_exists(pdev))
> >> -		ops = &virtiovf_vfio_pci_tran_ops;
> >> +	ops = (pdev->is_virtfn) ? &virtiovf_vfio_pci_tran_lm_ops :
> >> +				  &virtiovf_vfio_pci_ops;  
> > 
> > I can't figure out why we moved the more thorough ops setup to the
> > .init() callback of the ops themselves.  Clearly we can do the legacy
> > IO and BAR0 test here and the dev parts test uses the same mechanisms
> > as the legacy IO test, so it seems we could know sup_legacy_io and
> > sup_lm here.  I think we can even do virtiovf_set_migratable() here
> > after virtvdev is allocated below.
> >   
> 
> Setting the 'ops' as part of the probe() seems actually doable, 
> including calling virtiovf_set_migratable() following the virtiodev 
> allocation below.
> 
> The main issue with that approach will be the init part of the legacy IO 
> (i.e. virtiovf_init_legacy_io()) as part of virtiovf_pci_init_device().
> 
> Assuming that we don't want to repeat calling 
> virtiovf_support_legacy_io() as part of virtiovf_pci_init_device() to 
> know whether legacy IO is supported, we can consider calling 
> virtiovf_init_legacy_io() as part of the probe() as well, which IMO 
> doesn't look clean as it's actually seems to match the init flow.
> 
> Alternatively, we can consider checking inside 
> virtiovf_pci_init_device() whether the 'ops' actually equals the 'tran' 
> ones and then call it.
> 
> Something like the below.
> 
> static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
> {
> 	...
> 
> #ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
> 	if (core_vdev->ops == &virtiovf_vfio_pci_tran_lm_ops)
> 		return virtiovf_init_legacy_io(virtvdev);
> #endif
> 
> 	return 0;
> }
> 
> Do you prefer the above approach rather than current V1 code which has a 
>   single check as part of virtiovf_init_legacy_io() ?

If ops is properly configured and set-migratable is done in probe,
then doesn't only the legacy ops .init callback need to init the legacy
setup?  The non-legacy, migration ops structure would just use
vfio_pci_core_init_dev.

> 
> > I think the API to vfio core also suggests we shouldn't be modifying the
> > ops pointer after the core device is allocated.  
> 
> Any pointer for that ?
> Do we actually see a problem with replacing the 'ops' as part of the 
> init flow ?

What makes it that way to me is that it's an argument to and set by the
object constructor.  The ops callbacks should be considered live once
set.  It's probably safe to do as you've done here because the
constructor calls the init callback directly, so we don't have any
races.  However as Jason agreed, it's generally a pattern to avoid and I
think we can rather easily do so here.  Thanks,

Alex


