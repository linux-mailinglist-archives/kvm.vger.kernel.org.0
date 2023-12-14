Return-Path: <kvm+bounces-4523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E46281367A
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C308A1C20CCE
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F142A60BA1;
	Thu, 14 Dec 2023 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aEo9v25O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709E8120
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702572037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iRk2CZG4/Ab0na0DCr/3bwBDdbw32XXRbYjtR9ARqr4=;
	b=aEo9v25OM/gE5di+aBPf3D9LXEcXiiA65oslylKM/r2lNEXaqNlI+VuNFhHv7Pj+CPQok+
	BHkmjnBOT2swr8aKlxlLncNa9BpRondqBL3f3qow5f9a4brdiWE2Iw1PgCFCkm5fgfkxbI
	/xEPLvn8oJ7opGs5N7PnY4Pnq9tLS34=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-rHlY3Vs6NKKMMQtCQhcV6g-1; Thu, 14 Dec 2023 11:40:34 -0500
X-MC-Unique: rHlY3Vs6NKKMMQtCQhcV6g-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-54554ea191bso4344695a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:40:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702572033; x=1703176833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRk2CZG4/Ab0na0DCr/3bwBDdbw32XXRbYjtR9ARqr4=;
        b=eGvhJBpc+ILlmbbZoRHQpGmgvj+LCYIY+Qgh9Y4gEIiONPYgflqY/H4q89B7vjsOm0
         m6GgqTo2kl6ZRXCKLt8U324GfpY8+tJHNpN1A9GO/Jya2c+2XvrPGvC+SaXQmNHnR7qK
         2S236fmhjmXLgOIkOLiiAFhviUQObzjh4cTcimqKWjY1BT4m4RyW6qoTdnxsHHIEUDmm
         /PcVs7INcaK92Vv3eAMx3MXH9j/BlGVxz6UV3QqJyUzgZfTXipcf0lU42Zr2a6AcJX0m
         ZoFqoN94P7FfP6I0PM7fTi+d2nImh59UhJPy7GXDMukTjwEwkfSGsbfp+5kI/ADFi7si
         66Ig==
X-Gm-Message-State: AOJu0YxstnhrMCm7L3ycqVQuUiBGf9AZtWnrI+K8jBIFqD04p2rFbymd
	uYUY3mDxcW27qVObS+OCjxNpyLMIJPMeQO4lVjEEwAuDBHEWNtGeT2LcQSQqQLJeLpcnRY1ZO14
	R5DIE2in0kPlQjdPe/iRT
X-Received: by 2002:a50:d657:0:b0:54c:f9e6:e40f with SMTP id c23-20020a50d657000000b0054cf9e6e40fmr5439735edj.7.1702572033325;
        Thu, 14 Dec 2023 08:40:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvmFnJLvOAFDRW8ctVUYl/ZQOHmqyiQ5QKA7dMnsf6MbAZiLEGF9Ip05ui1pTG2jJFcq303w==
X-Received: by 2002:a50:d657:0:b0:54c:f9e6:e40f with SMTP id c23-20020a50d657000000b0054cf9e6e40fmr5439730edj.7.1702572032938;
        Thu, 14 Dec 2023 08:40:32 -0800 (PST)
Received: from redhat.com ([2.52.132.243])
        by smtp.gmail.com with ESMTPSA id n8-20020a50cc48000000b0054c9df4317dsm6901383edi.7.2023.12.14.08.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 08:40:23 -0800 (PST)
Date: Thu, 14 Dec 2023 11:40:03 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, jasowang@redhat.com,
	jgg@nvidia.com, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, parav@nvidia.com,
	feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, si-wei.liu@oracle.com, leonro@nvidia.com,
	maorg@nvidia.com
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231214113649-mutt-send-email-mst@kernel.org>
References: <20231207102820.74820-10-yishaih@nvidia.com>
 <20231214013642-mutt-send-email-mst@kernel.org>
 <ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
 <20231214041515-mutt-send-email-mst@kernel.org>
 <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
 <20231214075905.59a4a3ba.alex.williamson@redhat.com>
 <20231214100403-mutt-send-email-mst@kernel.org>
 <5b596e34-aac9-4786-8f13-4d85986803f0@nvidia.com>
 <20231214091501.4f843335.alex.williamson@redhat.com>
 <c838ad5a-e6ba-4b8e-a9a2-5d43da0ba5a4@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c838ad5a-e6ba-4b8e-a9a2-5d43da0ba5a4@nvidia.com>

On Thu, Dec 14, 2023 at 06:25:25PM +0200, Yishai Hadas wrote:
> On 14/12/2023 18:15, Alex Williamson wrote:
> > On Thu, 14 Dec 2023 18:03:30 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> > 
> > > On 14/12/2023 17:05, Michael S. Tsirkin wrote:
> > > > On Thu, Dec 14, 2023 at 07:59:05AM -0700, Alex Williamson wrote:
> > > > > On Thu, 14 Dec 2023 11:37:10 +0200
> > > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > > > > > > OK, if so, we can come with the below extra code.
> > > > > > > > Makes sense ?
> > > > > > > > 
> > > > > > > > I'll squash it as part of V8 to the relevant patch.
> > > > > > > > 
> > > > > > > > diff --git a/drivers/virtio/virtio_pci_modern.c
> > > > > > > > b/drivers/virtio/virtio_pci_modern.c
> > > > > > > > index 37a0035f8381..b652e91b9df4 100644
> > > > > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > > > > @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
> > > > > > > > *pdev)
> > > > > > > >            struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > > > > > > >            struct virtio_pci_device *vp_dev;
> > > > > > > > 
> > > > > > > > +#ifndef CONFIG_X86
> > > > > > > > +       return false;
> > > > > > > > +#endif
> > > > > > > >            if (!virtio_dev)
> > > > > > > >                    return false;
> > > > > > > > 
> > > > > > > > Yishai
> > > > > > > 
> > > > > > > Isn't there going to be a bunch more dead code that compiler won't be
> > > > > > > able to elide?
> > > > > > 
> > > > > > On my setup the compiler didn't complain about dead-code (I simulated it
> > > > > > by using ifdef CONFIG_X86 return false).
> > > > > > 
> > > > > > However, if we suspect that some compiler might complain, we can come
> > > > > > with the below instead.
> > > > > > 
> > > > > > Do you prefer that ?
> > > > > > 
> > > > > > index 37a0035f8381..53e29824d404 100644
> > > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > > @@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct
> > > > > > virtio_device *vdev)
> > > > > >             BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
> > > > > >             BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> > > > > > 
> > > > > > +#ifdef CONFIG_X86
> > > > > >     /*
> > > > > >      * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
> > > > > >      * commands are supported
> > > > > > @@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
> > > > > > *pdev)
> > > > > >                    return true;
> > > > > >            return false;
> > > > > >     }
> > > > > > +#else
> > > > > > +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
> > > > > > +{
> > > > > > +       return false;
> > > > > > +}
> > > > > > +#endif
> > > > > >     EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
> > > > > 
> > > > > Doesn't this also raise the question of the purpose of virtio-vfio-pci
> > > > > on non-x86?  Without any other features it offers nothing over vfio-pci
> > > > > and we should likely adjust the Kconfig for x86 or COMPILE_TEST.
> > > > > Thanks,
> > > > > 
> > > > > Alex
> > > > 
> > > > Kconfig dependency is what I had in mind, yes. The X86 specific code in
> > > > virtio_pci_modern.c can be moved to a separate file then use makefile
> > > > tricks to skip it on other platforms.
> > > 
> > > The next feature for that driver will be the live migration support over
> > > virtio, once the specification which is WIP those day will be accepted.
> > > 
> > > The migration functionality is not X86 dependent and doesn't have the
> > > legacy virtio driver limitations that enforced us to run only on X86.
> > > 
> > > So, by that time we may need to enable in VFIO the loading of
> > > virtio-vfio-pci driver and put back the ifdef X86 inside VIRTIO, only on
> > > the legacy IO API, as I did already in V8.
> > > 
> > > So using a KCONFIG solution in VFIO is a short term one, which will be
> > > reverted just later on.
> > 
> > I understand the intent, but I don't think that justifies building a
> > driver that serves no purpose in the interim.  IF and when migration
> > support becomes a reality, it's trivial to update the depends line.
> > 
> 
> OK, so I'll add a KCONFIG dependency on X86 as you suggested as part of V9
> inside VFIO.
> 
> > > In addition, the virtio_pci_admin_has_legacy_io() API can be used in the
> > > future not only by VFIO, this was one of the reasons to put it inside
> > > VIRTIO.
> > 
> > Maybe this should be governed by a new Kconfig option which would be
> > selected by drivers like this.  Thanks,
> > 
> 
> We can still keep the simple ifdef X86 inside VIRTIO for future users/usage
> which is not only VFIO.
> 
> Michael,
> Can that work for you ?
> 
> Yishai
> 
> > Alex
> > 

I am not sure what is proposed exactly. General admin q infrastructure
can be kept as is. The legacy things however can never work outside X86.
Best way to limit it to x86 is to move it to a separate file and
only build that on X86. This way the only ifdef we need is where
we set the flags to enable legacy commands.


-- 
MST


