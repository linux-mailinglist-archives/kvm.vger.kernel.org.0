Return-Path: <kvm+bounces-19445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70641905286
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7095B23CE8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F0E16FF3E;
	Wed, 12 Jun 2024 12:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ma5MvMZA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25F316D4E0
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 12:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718195568; cv=none; b=h+wBOw5W61Yr7E8BAAwVbYE2+chloFpxOnUQmiBIJKhaBpHN3SMgR35Qob6emJ13/l9HuXDmknVaZla83UiHONoLi9hVHbt/m8YVDDNm5VobfMHGLhx2NIMUFRY5W739wrJNbNki3FNUEqu+EdofKARVRiEFT6iUPFz7MR1XFnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718195568; c=relaxed/simple;
	bh=fT/rUz7KLw47ie7gQBlOBi/uaQUpPAuVBwYVvWuy8mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gRFhPMNOWWB8Lq6J2bp0+1riDZ6kxPMNTY0AR4Jshofy9wU/dmEmIq0v94oHb9yC2WYdvOMFQ07kLgAJ1Sw1pbNx8AuDhhfXwQYbYN/4q39Hx3QhXD6U/HZlIG0/yAGsvOFN2GisGvfsxLfPKMs6ngtiOMTT+F/wgZe6RzjK8s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ma5MvMZA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718195564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XfQZDtLT+q+ZIAPC3OZ+JW6AZ+Ih2QY45mLdNIYr7/k=;
	b=Ma5MvMZATYTO5SOTYqMLhidwofYJ4uoTxQU7LvZ3NI/EKn/p4MwQSEGUEuqlMAKEoGaX7n
	6UHGo/UI0Sq5PEFFSrHE3XmWk8JCnVcOfVFYWnuN0akPcbEY5gAVWgEzzf/svmUsjdkEs+
	ONXTHc7O2njxG38Y8/Z4U0Vi2ShlrMc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-eh4YPkroPIyW1KcCDCqxPw-1; Wed, 12 Jun 2024 08:32:43 -0400
X-MC-Unique: eh4YPkroPIyW1KcCDCqxPw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4227e29cd39so4584945e9.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718195562; x=1718800362;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XfQZDtLT+q+ZIAPC3OZ+JW6AZ+Ih2QY45mLdNIYr7/k=;
        b=IBb9+XeWCbDxHWcfyhDK1d03/1bcoZEUko0KTOXR1c8oSt0CojBUVsI7pAhT3RVX2U
         gIyvKRBI5azgv40PZwY027MbKeM4SjvM3zhgbNZLYsE7kHaq0B4F4dWOOb02zUkKuNbS
         Ouq0/i2fAfjmKy+zv/u6sgYJ3Rg8ER8SKUV/9kMaTEAPi52SLIEKzSenGMvGLWOZ3//d
         8y7wr7TZ4NadTphJiciHEENudRTrsFl2s+jfYNONzEzZNPZpMa6HwhUpLBtoz8gYBXwO
         iiJY5ubgTxNZFpMTZVnE3ico7MHPxRDatr5l4pm/VQfe72HrdOJefitFvivm/3ScYLQR
         8/hw==
X-Forwarded-Encrypted: i=1; AJvYcCWqHr4AqJekn7qVV0gtaIwIpfN9D1Tc9ybCn9Ki6XbXRTNw2oNis285uuH/ew4psi0jhu0RxKd/UiGejQvRRk8AofgQ
X-Gm-Message-State: AOJu0YwLy7MbsPrjAhskn++FNnPH9Sf6zeZRufh7iKRqcP3cv7Rkdc1s
	8JylFBWsvEKeV7OUbEINPCmsiH9bWAJPqDbPX/tnRHe10J88fy9GWcddOXbd3YJZjXNguO1kXjf
	6YAq7yISQ9aDSmyYKpxwoVucBGI9Mpd6FrlNEzALWj/PUUnDI9A==
X-Received: by 2002:a05:600c:5008:b0:421:81c1:65fa with SMTP id 5b1f17b1804b1-422862a749fmr18009455e9.13.1718195562047;
        Wed, 12 Jun 2024 05:32:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX1J/727VlQKp+bnqlzO56bmec4Mvp/egLF2T+bKHvyiF7Rt8TUW+mf2Itz3LGm+3KTeWuYg==
X-Received: by 2002:a05:600c:5008:b0:421:81c1:65fa with SMTP id 5b1f17b1804b1-422862a749fmr18009125e9.13.1718195561469;
        Wed, 12 Jun 2024 05:32:41 -0700 (PDT)
Received: from redhat.com ([2a02:14f:178:39eb:4161:d39d:43e6:41f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4229447eaa5sm18672645e9.48.2024.06.12.05.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 05:32:40 -0700 (PDT)
Date: Wed, 12 Jun 2024 08:32:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Srujana Challa <schalla@marvell.com>
Cc: Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Vamsi Krishna Attunuru <vattunuru@marvell.com>,
	Shijith Thotton <sthotton@marvell.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Message-ID: <20240612083001-mutt-send-email-mst@kernel.org>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <CACGkMEsxPfck-Ww6CHSod5wP5xLOpS3t2B8qhTL0=PoE3koCGQ@mail.gmail.com>
 <DS0PR18MB5368E02C4DE7AA96CCD299E0A0F82@DS0PR18MB5368.namprd18.prod.outlook.com>
 <CACGkMEs+s7JEvLXBdyQbj36Y8WSbHXqF2d9HNP3v7CPRPoocXg@mail.gmail.com>
 <DS0PR18MB5368CD9E8E3432A9D19D8C8FA0C02@DS0PR18MB5368.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR18MB5368CD9E8E3432A9D19D8C8FA0C02@DS0PR18MB5368.namprd18.prod.outlook.com>

On Wed, Jun 12, 2024 at 09:22:43AM +0000, Srujana Challa wrote:
> 
> > Subject: Re: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
> > 
> > On Tue, Jun 4, 2024 at 5:29 PM Srujana Challa <schalla@marvell.com> wrote:
> > >
> > > > Subject: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
> > > >
> > > > Prioritize security for external emails: Confirm sender and content
> > > > safety before clicking links or opening attachments
> > > >
> > > > --------------------------------------------------------------------
> > > > -- On Thu, May 30, 2024 at 6:18 PM Srujana Challa
> > > > <schalla@marvell.com>
> > > > wrote:
> > > > >
> > > > > This commit introduces support for an UNSAFE, no-IOMMU mode in the
> > > > > vhost-vdpa driver. When enabled, this mode provides no device
> > > > > isolation, no DMA translation, no host kernel protection, and
> > > > > cannot be used for device assignment to virtual machines. It
> > > > > requires RAWIO permissions and will taint the kernel.
> > > > > This mode requires enabling the
> > > > "enable_vhost_vdpa_unsafe_noiommu_mode"
> > > > > option on the vhost-vdpa driver. This mode would be useful to get
> > > > > better performance on specifice low end machines and can be
> > > > > leveraged by embedded platforms where applications run in controlled
> > environment.
> > > >
> > > > I wonder if it's better to do it per driver:
> > > >
> > > > 1) we have device that use its own IOMMU, one example is the mlx5
> > > > vDPA device
> > > > 2) we have software devices which doesn't require IOMMU at all (but
> > > > still with
> > > > protection)
> > >
> > > If I understand correctly, you’re suggesting that we create a module
> > > parameter specific to the vdpa driver. Then, we can add a flag to the ‘struct
> > vdpa_device’
> > > and set that flag within the vdpa driver based on the module parameter.
> > > Finally, we would use this flag to taint the kernel and go in no-iommu
> > > path in the vhost-vdpa driver?
> > 
> > If it's possible, I would like to avoid changing the vDPA core.
> > 
> > Thanks
> According to my understanding of the discussion at the
> https://lore.kernel.org/all/20240422164108-mutt-send-email-mst@kernel.org,
> Michael has suggested focusing on implementing a no-IOMMU mode in vdpa.
> Michael, could you please confirm if it's fine to transfer all these relevant
> modifications to Marvell's vdpa driver?
> 
> Thanks.


All I said is that octeon driver can be merged without this support.
Then work on no-iommu can start separately.


Whether this belongs in the driver or the core would depend on
what the use-case is. I have not figured it out yet.
What you describe seems generic not card-specific though.
Jason why do you  want this in the driver?

> > 
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Signed-off-by: Srujana Challa <schalla@marvell.com>
> > > > > ---
> > > > >  drivers/vhost/vdpa.c | 23 +++++++++++++++++++++++
> > > > >  1 file changed, 23 insertions(+)
> > > > >
> > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index
> > > > > bc4a51e4638b..d071c30125aa 100644
> > > > > --- a/drivers/vhost/vdpa.c
> > > > > +++ b/drivers/vhost/vdpa.c
> > > > > @@ -36,6 +36,11 @@ enum {
> > > > >
> > > > >  #define VHOST_VDPA_IOTLB_BUCKETS 16
> > > > >
> > > > > +bool vhost_vdpa_noiommu;
> > > > > +module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
> > > > > +                  vhost_vdpa_noiommu, bool, 0644);
> > > > > +MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode,
> > > > "Enable
> > > > > +UNSAFE, no-IOMMU mode.  This mode provides no device isolation,
> > > > > +no DMA translation, no host kernel protection, cannot be used for
> > > > > +device assignment to virtual machines, requires RAWIO
> > > > > +permissions, and will taint the kernel.  If you do not know what this is
> > for, step away.
> > > > > +(default: false)");
> > > > > +
> > > > >  struct vhost_vdpa_as {
> > > > >         struct hlist_node hash_link;
> > > > >         struct vhost_iotlb iotlb;
> > > > > @@ -60,6 +65,7 @@ struct vhost_vdpa {
> > > > >         struct vdpa_iova_range range;
> > > > >         u32 batch_asid;
> > > > >         bool suspended;
> > > > > +       bool noiommu_en;
> > > > >  };
> > > > >
> > > > >  static DEFINE_IDA(vhost_vdpa_ida); @@ -887,6 +893,10 @@ static
> > > > > void vhost_vdpa_general_unmap(struct vhost_vdpa *v,  {
> > > > >         struct vdpa_device *vdpa = v->vdpa;
> > > > >         const struct vdpa_config_ops *ops = vdpa->config;
> > > > > +
> > > > > +       if (v->noiommu_en)
> > > > > +               return;
> > > > > +
> > > > >         if (ops->dma_map) {
> > > > >                 ops->dma_unmap(vdpa, asid, map->start, map->size);
> > > > >         } else if (ops->set_map == NULL) { @@ -980,6 +990,9 @@
> > > > > static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb
> > *iotlb,
> > > > >         if (r)
> > > > >                 return r;
> > > > >
> > > > > +       if (v->noiommu_en)
> > > > > +               goto skip_map;
> > > > > +
> > > > >         if (ops->dma_map) {
> > > > >                 r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
> > > > >         } else if (ops->set_map) { @@ -995,6 +1008,7 @@ static int
> > > > > vhost_vdpa_map(struct vhost_vdpa *v,
> > > > struct vhost_iotlb *iotlb,
> > > > >                 return r;
> > > > >         }
> > > > >
> > > > > +skip_map:
> > > > >         if (!vdpa->use_va)
> > > > >                 atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
> > > > >
> > > > > @@ -1298,6 +1312,7 @@ static int vhost_vdpa_alloc_domain(struct
> > > > vhost_vdpa *v)
> > > > >         struct vdpa_device *vdpa = v->vdpa;
> > > > >         const struct vdpa_config_ops *ops = vdpa->config;
> > > > >         struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> > > > > +       struct iommu_domain *domain;
> > > > >         const struct bus_type *bus;
> > > > >         int ret;
> > > > >
> > > > > @@ -1305,6 +1320,14 @@ static int vhost_vdpa_alloc_domain(struct
> > > > vhost_vdpa *v)
> > > > >         if (ops->set_map || ops->dma_map)
> > > > >                 return 0;
> > > > >
> > > > > +       domain = iommu_get_domain_for_dev(dma_dev);
> > > > > +       if ((!domain || domain->type == IOMMU_DOMAIN_IDENTITY) &&
> > > > > +           vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {
> > > > > +               add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > > > > +               dev_warn(&v->dev, "Adding kernel taint for noiommu
> > > > > + on
> > > > device\n");
> > > > > +               v->noiommu_en = true;
> > > > > +               return 0;
> > > > > +       }
> > > > >         bus = dma_dev->bus;
> > > > >         if (!bus)
> > > > >                 return -EFAULT;
> > > > > --
> > > > > 2.25.1
> > > > >
> > >
> 


