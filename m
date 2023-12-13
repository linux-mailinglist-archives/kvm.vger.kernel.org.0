Return-Path: <kvm+bounces-4392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4908B811FDF
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 21:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E262D1F2189F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 20:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E317E56D;
	Wed, 13 Dec 2023 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S3hi+Mbo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9559C
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702499035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5C/keDxF1/pt3LjYpoXehfsM1EqRnMNHBvxaU+Hjdwg=;
	b=S3hi+MboDUrdHQJqBzkeOIQFwyWda4sG/QH8lMDmu1hcuFK64MNlC7ZK8ZLszrUzzGOtlr
	4Iyvxhd2T1QD4rvrdp5VWe2KDDhtwa32Bpc9pM1ulq2POyqTBKVlaGOs/2dG7nfysW/8vn
	KKtN/+KGgpMmx4wWd2KC8rdrl0EXASc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-PAsCtSL4PXK6q8sx3DVITQ-1; Wed, 13 Dec 2023 15:23:53 -0500
X-MC-Unique: PAsCtSL4PXK6q8sx3DVITQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7b71b4b179aso342848839f.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:23:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702499033; x=1703103833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5C/keDxF1/pt3LjYpoXehfsM1EqRnMNHBvxaU+Hjdwg=;
        b=O7XpOmmzU3wyEosbvonbkqR52BagBsrucou0mfgJX/QiKkeFn50UCqPta6eX5YOJHX
         P7w1rY8nyandGAi4dvE50EUJnLy4B3s8G05XRofpwucYWeLbzwyj6CLK6CiUxrjCr+pP
         NBrcvDUDN1J1zYkn2nuxRLW6Vx9SfKPOPPt7vb+x2csvzuXM4Zf47kDRhmlKKBGbWJmH
         bKBdJbPx8rhvaK5b3szFW0s/c5qxhxsmIl5Dxueajz/xVMKU2Ddkg6AP9AqXLp8O+6az
         zZ0hQVYF55/Cfigo8P1LOcgm2jVa6YH2OGoZppWNC33XRqrs1pISQSrXWvq8gpBi0HL2
         VCOQ==
X-Gm-Message-State: AOJu0YyRkS2VqYtIbxUCyKi+gxfHaUAcUNGNWQfEefab38HwANH+6jDd
	hLVnPSbDpOSwDIqe8p03OJhS+mpwJFWuBl3OBBjrI9nnvvpgA23RgVasSrjAKNREnZbSQwUF6FM
	Ex60AHKZn6FjT
X-Received: by 2002:a6b:7009:0:b0:7b7:430e:b6d3 with SMTP id l9-20020a6b7009000000b007b7430eb6d3mr4887261ioc.19.1702499033005;
        Wed, 13 Dec 2023 12:23:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVH/Wa4FgSzR7V+CcfM/i9gA7Z0wWs/QWlnrtIE7JmYOrHsB69O/zXT6ljBY0amDk6CkU7pw==
X-Received: by 2002:a6b:7009:0:b0:7b7:430e:b6d3 with SMTP id l9-20020a6b7009000000b007b7430eb6d3mr4887249ioc.19.1702499032741;
        Wed, 13 Dec 2023 12:23:52 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id p8-20020a0566380e8800b0046926dafa32sm3041580jas.135.2023.12.13.12.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 12:23:52 -0800 (PST)
Date: Wed, 13 Dec 2023 13:23:40 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "mst@redhat.com" <mst@redhat.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
 <parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>,
 "jiri@nvidia.com" <jiri@nvidia.com>, "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>, "si-wei.liu@oracle.com"
 <si-wei.liu@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
 "maorg@nvidia.com" <maorg@nvidia.com>, "jasowang@redhat.com"
 <jasowang@redhat.com>
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231213132340.4f692bd0.alex.williamson@redhat.com>
In-Reply-To: <fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
	<20231207102820.74820-10-yishaih@nvidia.com>
	<BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
	<fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 Dec 2023 14:25:10 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 13/12/2023 10:23, Tian, Kevin wrote:
 
> >> +
> >> +static int virtiovf_pci_probe(struct pci_dev *pdev,
> >> +			      const struct pci_device_id *id)
> >> +{
> >> +	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
> >> +	struct virtiovf_pci_core_device *virtvdev;
> >> +	int ret;
> >> +
> >> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
> >> +	    !virtiovf_bar0_exists(pdev))
> >> +		ops = &virtiovf_vfio_pci_tran_ops;  
> > 
> > I have a confusion here.
> > 
> > why do we want to allow this driver binding to non-matching VF or
> > even PF?  
> 
> The intention is to allow the binding of any virtio-net device (i.e. PF, 
> VF which is not transitional capable) to have a single driver over VFIO 
> for all virtio-net devices.
> 
> This enables any user space application to bind and use any virtio-net 
> device without the need to care.
> 
> In case the device is not transitional capable, it will simply use the 
> generic vfio functionality.

The algorithm we've suggested for finding the most appropriate variant
driver for the device doesn't include a step of moving on to another
driver if the binding fails.  We lose determinism at that point.
Therefore this driver needs to handle all devices matching the id table.
The fact that virtio dictates various config space fields limits our
ability to refine the match from the id table. Thanks,

Alex


