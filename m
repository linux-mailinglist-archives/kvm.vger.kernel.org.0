Return-Path: <kvm+bounces-3414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C8C8041E5
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 23:57:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 081572813A2
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 22:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1510F22F1A;
	Mon,  4 Dec 2023 22:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFB7qzBJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E316A0
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 14:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701730643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFQGRJAzWPaXjPOylGJVvU7bvVedAM/SvNuhHxMal9Y=;
	b=HFB7qzBJhHnjKmdXz7J5Lh//zG736FBpLwBRxJ7x6A0BF4/oWhuQlFhX+HoMbF2iPsjDOp
	aC9VBEkoUZB+X7b5NaAbqMjXo00RkWj3ZPA1+OvWIJeMHrSR+eoQqqSWJ4S3SvfXzTLxbR
	rajn76NIWHmYkcUA0zaHOaKtWj07BUo=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-z9b9iGTNN4WKWGu4NcrR2Q-1; Mon, 04 Dec 2023 17:57:15 -0500
X-MC-Unique: z9b9iGTNN4WKWGu4NcrR2Q-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6d8580cd8b3so5243714a34.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 14:57:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701730635; x=1702335435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sFQGRJAzWPaXjPOylGJVvU7bvVedAM/SvNuhHxMal9Y=;
        b=LhraM7fyLq+uGwaNxPQELVX3LSic9dsDKzM3G8wCV3ON5hNBArUT2Vl/luBXM/Rvd5
         9v57f5qG467GpLUoUNu4Dm74P/26rNRTmlczWdjKO4llnzzFAMSd5YYPg8uu/sZduFKj
         HxUomOVhfxqY/G9EiPiZNqDpC6UdgqyXh5vbRcYFAgtz9Gbj9nxVhQpHXImUZpp1W7EM
         F3zvuF12XmApYPQqfqJUeIZaX7fZeNYWawuT4VdPyqRLPf6QLXMu/vfGVbVRVJb00I35
         HMAJvaoAK4wrGfvC9KY+UGXEQ0bSZX+5pHz//QhURe9NQorg2cs75jD0aSHOrgXczcg9
         RH9A==
X-Gm-Message-State: AOJu0Ywgx8CERU78n/gKO1F3I8HYeYOhKbOkXtU8VVNXL6nuhVx7hYcI
	6/7aK5w93y3sZ3aZIT71sAr5ww0e/lpL/EVMjOegALV9rJBmBHeadDXAL4IPmLnffTZJoy5bbXz
	0WY85hRW0lqW+
X-Received: by 2002:a05:6830:12c4:b0:6d8:7c3f:166e with SMTP id a4-20020a05683012c400b006d87c3f166emr4031162otq.22.1701730634876;
        Mon, 04 Dec 2023 14:57:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIg6dJoOONh4Yoo4mKqBjNSkUszydCCxuGO3xsIeXMN1VHu7FISng4PFP1phjrHN6wGupKxQ==
X-Received: by 2002:a05:6830:12c4:b0:6d8:7c3f:166e with SMTP id a4-20020a05683012c400b006d87c3f166emr4031151otq.22.1701730634643;
        Mon, 04 Dec 2023 14:57:14 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id k17-20020a9d7611000000b006d7e23c58b6sm2045570otl.38.2023.12.04.14.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 14:57:13 -0800 (PST)
Date: Mon, 4 Dec 2023 15:57:12 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
 <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
 <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 vfio 8/9] vfio/pci: Expose
 vfio_pci_iowrite/read##size()
Message-ID: <20231204155712.76f7e6c8.alex.williamson@redhat.com>
In-Reply-To: <13c56c54-50ff-4894-833a-6c75ca604399@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
	<20231129143746.6153-9-yishaih@nvidia.com>
	<20231130122010.3563bdee.alex.williamson@redhat.com>
	<13c56c54-50ff-4894-833a-6c75ca604399@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 3 Dec 2023 16:14:15 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 30/11/2023 21:20, Alex Williamson wrote:
> > On Wed, 29 Nov 2023 16:37:45 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> >> Expose vfio_pci_iowrite/read##size() to let it be used by drivers.
> >>
> >> This functionality is needed to enable direct access to some physical
> >> BAR of the device with the proper locks/checks in place.
> >>
> >> The next patches from this series will use this functionality on a data
> >> path flow when a direct access to the BAR is needed.
> >>
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> ---
> >>   drivers/vfio/pci/vfio_pci_rdwr.c | 10 ++++++----
> >>   include/linux/vfio_pci_core.h    | 19 +++++++++++++++++++
> >>   2 files changed, 25 insertions(+), 4 deletions(-)  
> > 
> > I don't follow the inconsistency between this and the previous patch.
> > Why did we move and rename the code to setup the barmap but we export
> > the ioread/write functions in place?  Thanks,
> > 
> > Alex  
> 
> The mount of code for barmap setup was quite small compared to the 
> ioread/write functions.
> 
> However, I agree, we can be consistent here and export in both cases the 
> functions in place as part of vfio_pci_rdwr.c which is already part of 
> vfio_pci_core.ko
> 
> I may also rename in current patch vfio_pci_iowrite/read<xxx> to have 
> the 'core' prefix as part of the functions names (i.e. 
> vfio_pci_core_iowrite/read<xxx>) to be consistent with other exported 
> core functions and adapt the callers to this name.
> 
> Makes sense ?

Yep.  Thanks,

Alex

> >> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> >> index 6f08b3ecbb89..817ec9a89123 100644
> >> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> >> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> >> @@ -38,7 +38,7 @@
> >>   #define vfio_iowrite8	iowrite8
> >>   
> >>   #define VFIO_IOWRITE(size) \
> >> -static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
> >> +int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
> >>   			bool test_mem, u##size val, void __iomem *io)	\
> >>   {									\
> >>   	if (test_mem) {							\
> >> @@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
> >>   		up_read(&vdev->memory_lock);				\
> >>   									\
> >>   	return 0;							\
> >> -}
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(vfio_pci_iowrite##size);
> >>   
> >>   VFIO_IOWRITE(8)
> >>   VFIO_IOWRITE(16)
> >> @@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
> >>   #endif
> >>   
> >>   #define VFIO_IOREAD(size) \
> >> -static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
> >> +int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
> >>   			bool test_mem, u##size *val, void __iomem *io)	\
> >>   {									\
> >>   	if (test_mem) {							\
> >> @@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
> >>   		up_read(&vdev->memory_lock);				\
> >>   									\
> >>   	return 0;							\
> >> -}
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(vfio_pci_ioread##size);
> >>   
> >>   VFIO_IOREAD(8)
> >>   VFIO_IOREAD(16)
> >> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> >> index 67ac58e20e1d..22c915317788 100644
> >> --- a/include/linux/vfio_pci_core.h
> >> +++ b/include/linux/vfio_pci_core.h
> >> @@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
> >>   pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
> >>   						pci_channel_state_t state);
> >>   
> >> +#define VFIO_IOWRITE_DECLATION(size) \
> >> +int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
> >> +			bool test_mem, u##size val, void __iomem *io);
> >> +
> >> +VFIO_IOWRITE_DECLATION(8)
> >> +VFIO_IOWRITE_DECLATION(16)
> >> +VFIO_IOWRITE_DECLATION(32)
> >> +#ifdef iowrite64
> >> +VFIO_IOWRITE_DECLATION(64)
> >> +#endif
> >> +
> >> +#define VFIO_IOREAD_DECLATION(size) \
> >> +int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
> >> +			bool test_mem, u##size *val, void __iomem *io);
> >> +
> >> +VFIO_IOREAD_DECLATION(8)
> >> +VFIO_IOREAD_DECLATION(16)
> >> +VFIO_IOREAD_DECLATION(32)
> >> +
> >>   #endif /* VFIO_PCI_CORE_H */  
> >   
> 


