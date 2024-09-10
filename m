Return-Path: <kvm+bounces-26197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4CFA97291B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 07:57:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 035F71C23E0D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 05:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB68170A2A;
	Tue, 10 Sep 2024 05:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RO48jPGS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7228176252
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 05:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725947819; cv=none; b=qs3bFwwhdwMe0ttcQFd/Yj/wmdC5tJE0pU/EXBQ3HUs1+1nhWwesGt2z/F8Z27WFiJR+Z6yqJyOsQn0Wd8lowRcE+HGYqtVB3o+URso23T1JduA3kxBChb3N1sxfirx2y7E3fLmrt2ke68/ei40EJgzzrYi99PKPsntWAmG2eAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725947819; c=relaxed/simple;
	bh=bEWpONHSiaCAL9nHTlh72m5L9gCK+vPqYF1cUXGkcns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVoM+pQtN7VGgT6AYZmOSH9iswNYiduwcfvIyk8lRcJ7xLVep2mdgvquZJdXChJE7Rf+p5kID6b3CaPR9gQvduTMkKyZO9G4lE9sZigqMK88Ne3XI3OL9R5zV5kyDC4RSiVdkDLy7Gbe9Vye73YkBC2F9D45ujEUCrTee3SUcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RO48jPGS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725947815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZA8O0UwD0kMNADQRx8cL0+Q6S43BimlTMl9M84XCyQ=;
	b=RO48jPGSqHoRIwMTer/lTz8MueumZ56G562FkkRW0EFOj0wvy9l28HYXJpVTn/JbTe8A8Y
	h8MYfqcfWNChZsa+kVuV8vSHfWltQ1PSDOep1T+sxyhT7QkamPJK4lrq4akNF+wBYTS9K7
	8xtjto2DIKsHe5fWt5oFCOdbwf2IGjQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-XknriVawPEeTj2bf6OOXSw-1; Tue, 10 Sep 2024 01:56:53 -0400
X-MC-Unique: XknriVawPEeTj2bf6OOXSw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-374aef640a4so2003545f8f.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 22:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725947812; x=1726552612;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NZA8O0UwD0kMNADQRx8cL0+Q6S43BimlTMl9M84XCyQ=;
        b=XQttTBmZzrYhD/GPNLzWDi9TNifZSZ2ZbPvG69UVBl+gIHGT5eFh/7CvqTrySsr38j
         KMB60UMgGWC6diDZ/gO8ZSm8Qd/DKGZaODUb/tYXz6qsfjXpEXfFH4oOxo/xzGA615Wv
         ZeLThIuwactvY1SpbIu8jdtJrE374QwV7FN9uUtbNlliW1TAfXaw7BI0JM2a8HqwqJDf
         TwV80BZhiu9Dz4Re0mgn+8J71VEGCbogONdVI3OcDLNmJpqxOA5ISzlCOak0Oi2LgMG6
         lomTTLXK9BNFUX4hWoiEyMM18ao+jZfy8dh5wR8t8sYFMglJ0QXDi2S+rtF1rLn0ee6Y
         /+Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWTI/mD69vg/PfphrFePOb4bsVXKm0iMIVV2CvqodHRJNzfpvLXQsngcwOznGa0bjHus8k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6lR7IjKPKMkhdFsZjE1SqzPS7U97Kc598pfnllphrMbA3RwdM
	p/fJa9yPWNd3FIQYT9Rk6eSOiYBFes64NaxFMMGmbv1MrGjVZFjztjZvHdviGeeifjT35cWKzwj
	dl3b+rfrxcXrJLIyqiKi2hAaWp0CNzrV79qrSgHGu07vi2NwOBQ==
X-Received: by 2002:a5d:59a6:0:b0:374:c8a0:5d05 with SMTP id ffacd0b85a97d-37892703fffmr7100629f8f.50.1725947812552;
        Mon, 09 Sep 2024 22:56:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmH3ot6bgXVUW/zJPiXkkj2YR5CszEUT5J/sC3K2/NdHA+7IFqm4HuH7IreAVy/9UyFfpHww==
X-Received: by 2002:a5d:59a6:0:b0:374:c8a0:5d05 with SMTP id ffacd0b85a97d-37892703fffmr7100608f8f.50.1725947811429;
        Mon, 09 Sep 2024 22:56:51 -0700 (PDT)
Received: from redhat.com ([31.187.78.173])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb8b7f1sm98936555e9.48.2024.09.09.22.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 22:56:50 -0700 (PDT)
Date: Tue, 10 Sep 2024 01:56:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Srujana Challa <schalla@marvell.com>
Cc: Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Vamsi Krishna Attunuru <vattunuru@marvell.com>,
	Shijith Thotton <sthotton@marvell.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Message-ID: <20240910015607-mutt-send-email-mst@kernel.org>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <20240717054547-mutt-send-email-mst@kernel.org>
 <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
 <CACGkMEtQ3SWBpS-00BBCJxoUK5AQRB=FhKGEqigh81GTbRf61A@mail.gmail.com>
 <20240722034957-mutt-send-email-mst@kernel.org>
 <DS0PR18MB5368298DAEA53CF7F9710B46A0A92@DS0PR18MB5368.namprd18.prod.outlook.com>
 <20240723070326-mutt-send-email-mst@kernel.org>
 <DS0PR18MB53689BE0C0DFDBD86D396515A0BF2@DS0PR18MB5368.namprd18.prod.outlook.com>
 <DS0PR18MB53684A307C08D17276A465EEA0952@DS0PR18MB5368.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR18MB53684A307C08D17276A465EEA0952@DS0PR18MB5368.namprd18.prod.outlook.com>

On Wed, Aug 28, 2024 at 09:08:13AM +0000, Srujana Challa wrote:
> > Subject: RE: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
> > 
> > > On Tue, Jul 23, 2024 at 07:10:52AM +0000, Srujana Challa wrote:
> > > > > On Mon, Jul 22, 2024 at 03:22:22PM +0800, Jason Wang wrote:
> > > > > > On Fri, Jul 19, 2024 at 11:40 PM Srujana Challa
> > > > > > <schalla@marvell.com>
> > > > > wrote:
> > > > > > >
> > > > > > > > On Thu, May 30, 2024 at 03:48:23PM +0530, Srujana Challa wrote:
> > > > > > > > > This commit introduces support for an UNSAFE, no-IOMMU
> > > > > > > > > mode in the vhost-vdpa driver. When enabled, this mode
> > > > > > > > > provides no device isolation, no DMA translation, no host
> > > > > > > > > kernel protection, and cannot be used for device
> > > > > > > > > assignment to virtual machines. It requires RAWIO
> > > > > > > > > permissions and will taint the
> > > kernel.
> > > > > > > > > This mode requires enabling the
> > > > > > > > "enable_vhost_vdpa_unsafe_noiommu_mode"
> > > > > > > > > option on the vhost-vdpa driver. This mode would be useful
> > > > > > > > > to get better performance on specifice low end machines
> > > > > > > > > and can be leveraged by embedded platforms where
> > > > > > > > > applications run in controlled
> > > > > environment.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Srujana Challa <schalla@marvell.com>
> > > > > > > >
> > > > > > > > Thought hard about that.
> > > > > > > > I think given vfio supports this, we can do that too, and
> > > > > > > > the extension is
> > > > > small.
> > > > > > > >
> > > > > > > > However, it looks like setting this parameter will
> > > > > > > > automatically change the behaviour for existing userspace
> > > > > > > > when
> > > > > IOMMU_DOMAIN_IDENTITY is set.
> > > > Our initial thought was to support only for no-iommu case, in which
> > > > domain
> > > itself
> > > > won't be exist.   So, we can modify the code as below to check for only
> > > presence of domain.
> > > > I think,  only handling of no-iommu case wouldn't effect the
> > > > existing
> > > userspace.
> > > > +   if ((!domain) && vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO))
> > {
> > >
> > > I would prefer some explicit action.
> > > Just not specifying a domain is something I'd like to keep reserved
> > > for something of more wide usefulness.
> > Can we introduce a new feature like VHOST_BACKEND_F_NOIOMMU in
> > VHOST_VDPA_BACKEND_FEATURES?  We can have below logic based on this
> > feature bit negotiation.
> > Thanks.
> Michael, could you please confirm if adding a new feature to VHOST_VDPA_BACKEND_FEATURES
> is an appropriate solution to support no-IOMMU for the vhost-vdpa backend?


Yes. So the idea is to require both a module parameter, and a
flag set by userspace, to make sure users do not mistakenly
try to assign such devices to VMs.

Thanks.

> > >
> > >
> > > > > > > >
> > > > > > > > I suggest a new domain type for use just for this purpose.
> > > > > >
> > > > > > I'm not sure I get this, we want to bypass IOMMU, so it doesn't
> > > > > > even have a doman.
> > > > >
> > > > > yes, a fake one. or come up with some other flag that userspace will set.
> > > > >
> > > > > > > This way if host has
> > > > > > > > an iommu, then the same kernel can run both VMs with
> > > > > > > > isolation and unsafe embedded apps without.
> > > > > > > Could you provide further details on this concept? What
> > > > > > > criteria would determine the configuration of the new domain
> > > > > > > type? Would this require a boot parameter similar to
> > > > > > > IOMMU_DOMAIN_IDENTITY, such as
> > > > > iommu.passthrough=1 or iommu.pt?
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > > >
> > > > > > > > > ---
> > > > > > > > >  drivers/vhost/vdpa.c | 23 +++++++++++++++++++++++
> > > > > > > > >  1 file changed, 23 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > > > > > index bc4a51e4638b..d071c30125aa 100644
> > > > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > > > @@ -36,6 +36,11 @@ enum {
> > > > > > > > >
> > > > > > > > >  #define VHOST_VDPA_IOTLB_BUCKETS 16
> > > > > > > > >
> > > > > > > > > +bool vhost_vdpa_noiommu;
> > > > > > > > >
> > > +module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
> > > > > > > > > +              vhost_vdpa_noiommu, bool, 0644);
> > > > > > > > >
> > > +MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode,
> > > > > > > > "Enable
> > > > > > > > > +UNSAFE, no-IOMMU mode.  This mode provides no device
> > > > > > > > > +isolation, no DMA translation, no host kernel protection,
> > > > > > > > > +cannot be used for device assignment to virtual machines,
> > > > > > > > > +requires RAWIO permissions, and will taint the kernel.
> > > > > > > > > +If you do not know what this is
> > > > > for, step away.
> > > > > > > > > +(default: false)");
> > > > > > > > > +
> > > > > > > > >  struct vhost_vdpa_as {
> > > > > > > > >     struct hlist_node hash_link;
> > > > > > > > >     struct vhost_iotlb iotlb; @@ -60,6 +65,7 @@ struct
> > > > > > > > > vhost_vdpa {
> > > > > > > > >     struct vdpa_iova_range range;
> > > > > > > > >     u32 batch_asid;
> > > > > > > > >     bool suspended;
> > > > > > > > > +   bool noiommu_en;
> > > > > > > > >  };
> > > > > > > > >
> > > > > > > > >  static DEFINE_IDA(vhost_vdpa_ida); @@ -887,6 +893,10 @@
> > > > > > > > > static void vhost_vdpa_general_unmap(struct vhost_vdpa *v,  {
> > > > > > > > >     struct vdpa_device *vdpa = v->vdpa;
> > > > > > > > >     const struct vdpa_config_ops *ops = vdpa->config;
> > > > > > > > > +
> > > > > > > > > +   if (v->noiommu_en)
> > > > > > > > > +           return;
> > > > > > > > > +
> > > > > > > > >     if (ops->dma_map) {
> > > > > > > > >             ops->dma_unmap(vdpa, asid, map->start, map->size);
> > > > > > > > >     } else if (ops->set_map == NULL) { @@ -980,6 +990,9 @@
> > > > > > > > > static int vhost_vdpa_map(struct vhost_vdpa *v,
> > > > > > > > struct vhost_iotlb *iotlb,
> > > > > > > > >     if (r)
> > > > > > > > >             return r;
> > > > > > > > >
> > > > > > > > > +   if (v->noiommu_en)
> > > > > > > > > +           goto skip_map;
> > > > > > > > > +
> > > > > > > > >     if (ops->dma_map) {
> > > > > > > > >             r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
> > > > > > > > >     } else if (ops->set_map) { @@ -995,6 +1008,7 @@ static
> > > > > > > > > int vhost_vdpa_map(struct vhost_vdpa *v,
> > > > > > > > struct vhost_iotlb *iotlb,
> > > > > > > > >             return r;
> > > > > > > > >     }
> > > > > > > > >
> > > > > > > > > +skip_map:
> > > > > > > > >     if (!vdpa->use_va)
> > > > > > > > >             atomic64_add(PFN_DOWN(size),
> > > > > > > > > &dev->mm->pinned_vm);
> > > > > > > > >
> > > > > > > > > @@ -1298,6 +1312,7 @@ static int
> > > > > > > > > vhost_vdpa_alloc_domain(struct
> > > > > > > > vhost_vdpa *v)
> > > > > > > > >     struct vdpa_device *vdpa = v->vdpa;
> > > > > > > > >     const struct vdpa_config_ops *ops = vdpa->config;
> > > > > > > > >     struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> > > > > > > > > +   struct iommu_domain *domain;
> > > > > > > > >     const struct bus_type *bus;
> > > > > > > > >     int ret;
> > > > > > > > >
> > > > > > > > > @@ -1305,6 +1320,14 @@ static int
> > > > > > > > > vhost_vdpa_alloc_domain(struct
> > > > > > > > vhost_vdpa *v)
> > > > > > > > >     if (ops->set_map || ops->dma_map)
> > > > > > > > >             return 0;
> > > > > > > > >
> > > > > > > > > +   domain = iommu_get_domain_for_dev(dma_dev);
> > > > > > > > > +   if ((!domain || domain->type == IOMMU_DOMAIN_IDENTITY)
> > > &&
> > > > > > > > > +       vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {
> > > > > > > >
> > > > > > > > So if userspace does not have CAP_SYS_RAWIO instead of
> > > > > > > > failing with a permission error the functionality changes silently?
> > > > > > > > That's confusing, I think.
> > > > > > > Yes, you are correct. I will modify the code to return error
> > > > > > > when vhost_vdpa_noiommu is set and CAP_SYS_RAWIO is not set.
> > > > > > >
> > > > > > > Thanks.
> > > > > > > >
> > > > > > > >
> > > > > > > > > +           add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > > > > > > > > +           dev_warn(&v->dev, "Adding kernel taint for
> > > > > > > > > + noiommu on
> > > > > > > > device\n");
> > > > > > > > > +           v->noiommu_en = true;
> > > > > > > > > +           return 0;
> > > > > > > > > +   }
> > > > > > > > >     bus = dma_dev->bus;
> > > > > > > > >     if (!bus)
> > > > > > > > >             return -EFAULT;
> > > > > > > > > --
> > > > > > > > > 2.25.1
> > > > > > >
> > > >
> 


