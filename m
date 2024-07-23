Return-Path: <kvm+bounces-22111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BACF939F49
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 13:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5167628374A
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 11:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D94814F130;
	Tue, 23 Jul 2024 11:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="buhCbNCB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2284914D422
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 11:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721732663; cv=none; b=c5JSkb3X3ctalnOIt0f/pC0EGjt7OZZZAGhbxJPMAdUf2EUafDM/WOcAQwSXFQkkHsQ4xx5hGdJkJPoCtm4bKFMRg//D4OmGygqF/CIxLIlAFqMpuo+XsuJMGFwTuFAGaVIf/wjZXrmGtAyKTxMMBClZEQGQGs6rceo6tnjFPFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721732663; c=relaxed/simple;
	bh=6hACR6MxAj1NYC11Q1DxFcypWZd5B93E3TgTVAa/GOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7tMuAVQk1Vk8mfZNeXwo7F6Jj+z0r6YdScBBSbWR7hws7woDhpekouRSzwUvrs8kG2pGYnVvQbDpJyYPOIbatpNL2R1AQ89oiFrG3TTAmmHol7r+0W77j32O5Qsp+7JNEgc3Fb9PeN3uk45FiYPfL5KFJc+hc5PsOtm9lPY1Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=buhCbNCB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721732661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CwTb7hnD8qNwiBtvtGGixQf/Bn3HIMxKUDzIwfA0Aws=;
	b=buhCbNCBNu9L8cU6faET/HJ47GZ+95qan4xPwASvcqou1zDWX7tm8ud34iD//LfZTRky7A
	CQf7qrz43ABfr5DvE4hBWBThAQRm9tJeqBELHSpjhJFbdRrVW9Znto7iPB2vUXQY79wsUi
	IzaEDoo7R90dnrrLQtqgLYCsNQMem3g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-OjF9JQ_WPp2iyhLgIV8_LQ-1; Tue, 23 Jul 2024 07:04:19 -0400
X-MC-Unique: OjF9JQ_WPp2iyhLgIV8_LQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a797c5b4f47so51594966b.2
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 04:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721732658; x=1722337458;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwTb7hnD8qNwiBtvtGGixQf/Bn3HIMxKUDzIwfA0Aws=;
        b=Q4L69tyS4GdAVpJM9tvACM0s97GHMKvJ0DGJDLBrt10m/wWBNpgT0lgZEid/KiQAzG
         blUAhrFnV4x4SspOvnzH/8iKMYDq2QZxNuzolWmB41dGNvgPHo1/pxV1yVp2SVNOhMb8
         vGmhUHmVuN7airlvaV06e14DMI6hM3Zb7znC7Pwpt70O/tZ218QRyJhIP8w4DmGAdy57
         cWDHrORGaNX/zb6vEPnABy9SiBmc69nNMTtqUiiuxcHZZ1lOKlRLRQ2FEBeBvkxOnKzI
         ZGKICPlQrqTykAtXv5+PB12qiBOKmV3sEVfsWXTo7n7x5X/f2FH25YTSt5ZqhmDNC4c3
         Hg5w==
X-Forwarded-Encrypted: i=1; AJvYcCXyXYvpLdbMr7lMKf6+xpcpbpRCrsawjH/AFXkxJwjHsmgKQKV1Et/syjP272dgUDjokqjw7u7O7+cgTuthV4X3UH+5
X-Gm-Message-State: AOJu0Yz4h8qs7j73/TT63hiaq0PUFbmzj0XLm05Mj0I867OCQAZF0MRc
	a8fPJo1MOq+VmY2UaRzcW/uh63RgMAx9/EcQNlndXy4TlO1d50Fd2zgFvO1KG8TXfKc0p37Z1VW
	acwWxFNDu62/Q8E1Oa7nNcMl6dEO7MSleqxC0NiLNTOk+U7m+bg==
X-Received: by 2002:a17:906:7315:b0:a77:dbe2:31ff with SMTP id a640c23a62f3a-a7a4c4326ddmr652980266b.66.1721732658217;
        Tue, 23 Jul 2024 04:04:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9GOmzLADn5ttFoMePb46sE7uLr7blKeRCjyBahlXRvTEqNvkNRYIcfhXkKRQ6ebd1fZXamw==
X-Received: by 2002:a17:906:7315:b0:a77:dbe2:31ff with SMTP id a640c23a62f3a-a7a4c4326ddmr652976666b.66.1721732657405;
        Tue, 23 Jul 2024 04:04:17 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:440:9c9a:ffee:509d:1766:aa7f])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a3c951004sm524265966b.223.2024.07.23.04.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 04:04:16 -0700 (PDT)
Date: Tue, 23 Jul 2024 07:04:07 -0400
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
Message-ID: <20240723070326-mutt-send-email-mst@kernel.org>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <20240717054547-mutt-send-email-mst@kernel.org>
 <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
 <CACGkMEtQ3SWBpS-00BBCJxoUK5AQRB=FhKGEqigh81GTbRf61A@mail.gmail.com>
 <20240722034957-mutt-send-email-mst@kernel.org>
 <DS0PR18MB5368298DAEA53CF7F9710B46A0A92@DS0PR18MB5368.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR18MB5368298DAEA53CF7F9710B46A0A92@DS0PR18MB5368.namprd18.prod.outlook.com>

On Tue, Jul 23, 2024 at 07:10:52AM +0000, Srujana Challa wrote:
> > On Mon, Jul 22, 2024 at 03:22:22PM +0800, Jason Wang wrote:
> > > On Fri, Jul 19, 2024 at 11:40 PM Srujana Challa <schalla@marvell.com>
> > wrote:
> > > >
> > > > > On Thu, May 30, 2024 at 03:48:23PM +0530, Srujana Challa wrote:
> > > > > > This commit introduces support for an UNSAFE, no-IOMMU mode in
> > > > > > the vhost-vdpa driver. When enabled, this mode provides no
> > > > > > device isolation, no DMA translation, no host kernel protection,
> > > > > > and cannot be used for device assignment to virtual machines. It
> > > > > > requires RAWIO permissions and will taint the kernel.
> > > > > > This mode requires enabling the
> > > > > "enable_vhost_vdpa_unsafe_noiommu_mode"
> > > > > > option on the vhost-vdpa driver. This mode would be useful to
> > > > > > get better performance on specifice low end machines and can be
> > > > > > leveraged by embedded platforms where applications run in controlled
> > environment.
> > > > > >
> > > > > > Signed-off-by: Srujana Challa <schalla@marvell.com>
> > > > >
> > > > > Thought hard about that.
> > > > > I think given vfio supports this, we can do that too, and the extension is
> > small.
> > > > >
> > > > > However, it looks like setting this parameter will automatically
> > > > > change the behaviour for existing userspace when
> > IOMMU_DOMAIN_IDENTITY is set.
> Our initial thought was to support only for no-iommu case, in which domain itself
> won't be exist.   So, we can modify the code as below to check for only presence of domain.
> I think,  only handling of no-iommu case wouldn't effect the existing userspace.
> +   if ((!domain) && vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {

I would prefer some explicit action.
Just not specifying a domain is something I'd like
to keep reserved for something of more wide usefulness.


> > > > >
> > > > > I suggest a new domain type for use just for this purpose.
> > >
> > > I'm not sure I get this, we want to bypass IOMMU, so it doesn't even
> > > have a doman.
> > 
> > yes, a fake one. or come up with some other flag that userspace will set.
> > 
> > > > This way if host has
> > > > > an iommu, then the same kernel can run both VMs with isolation and
> > > > > unsafe embedded apps without.
> > > > Could you provide further details on this concept? What criteria
> > > > would determine the configuration of the new domain type? Would this
> > > > require a boot parameter similar to IOMMU_DOMAIN_IDENTITY, such as
> > iommu.passthrough=1 or iommu.pt?
> > >
> > > Thanks
> > >
> > > > >
> > > > > > ---
> > > > > >  drivers/vhost/vdpa.c | 23 +++++++++++++++++++++++
> > > > > >  1 file changed, 23 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index
> > > > > > bc4a51e4638b..d071c30125aa 100644
> > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > @@ -36,6 +36,11 @@ enum {
> > > > > >
> > > > > >  #define VHOST_VDPA_IOTLB_BUCKETS 16
> > > > > >
> > > > > > +bool vhost_vdpa_noiommu;
> > > > > > +module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
> > > > > > +              vhost_vdpa_noiommu, bool, 0644);
> > > > > > +MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode,
> > > > > "Enable
> > > > > > +UNSAFE, no-IOMMU mode.  This mode provides no device isolation,
> > > > > > +no DMA translation, no host kernel protection, cannot be used
> > > > > > +for device assignment to virtual machines, requires RAWIO
> > > > > > +permissions, and will taint the kernel.  If you do not know what this is
> > for, step away.
> > > > > > +(default: false)");
> > > > > > +
> > > > > >  struct vhost_vdpa_as {
> > > > > >     struct hlist_node hash_link;
> > > > > >     struct vhost_iotlb iotlb;
> > > > > > @@ -60,6 +65,7 @@ struct vhost_vdpa {
> > > > > >     struct vdpa_iova_range range;
> > > > > >     u32 batch_asid;
> > > > > >     bool suspended;
> > > > > > +   bool noiommu_en;
> > > > > >  };
> > > > > >
> > > > > >  static DEFINE_IDA(vhost_vdpa_ida); @@ -887,6 +893,10 @@ static
> > > > > > void vhost_vdpa_general_unmap(struct vhost_vdpa *v,  {
> > > > > >     struct vdpa_device *vdpa = v->vdpa;
> > > > > >     const struct vdpa_config_ops *ops = vdpa->config;
> > > > > > +
> > > > > > +   if (v->noiommu_en)
> > > > > > +           return;
> > > > > > +
> > > > > >     if (ops->dma_map) {
> > > > > >             ops->dma_unmap(vdpa, asid, map->start, map->size);
> > > > > >     } else if (ops->set_map == NULL) { @@ -980,6 +990,9 @@
> > > > > > static int vhost_vdpa_map(struct vhost_vdpa *v,
> > > > > struct vhost_iotlb *iotlb,
> > > > > >     if (r)
> > > > > >             return r;
> > > > > >
> > > > > > +   if (v->noiommu_en)
> > > > > > +           goto skip_map;
> > > > > > +
> > > > > >     if (ops->dma_map) {
> > > > > >             r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
> > > > > >     } else if (ops->set_map) {
> > > > > > @@ -995,6 +1008,7 @@ static int vhost_vdpa_map(struct vhost_vdpa
> > > > > > *v,
> > > > > struct vhost_iotlb *iotlb,
> > > > > >             return r;
> > > > > >     }
> > > > > >
> > > > > > +skip_map:
> > > > > >     if (!vdpa->use_va)
> > > > > >             atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
> > > > > >
> > > > > > @@ -1298,6 +1312,7 @@ static int vhost_vdpa_alloc_domain(struct
> > > > > vhost_vdpa *v)
> > > > > >     struct vdpa_device *vdpa = v->vdpa;
> > > > > >     const struct vdpa_config_ops *ops = vdpa->config;
> > > > > >     struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> > > > > > +   struct iommu_domain *domain;
> > > > > >     const struct bus_type *bus;
> > > > > >     int ret;
> > > > > >
> > > > > > @@ -1305,6 +1320,14 @@ static int vhost_vdpa_alloc_domain(struct
> > > > > vhost_vdpa *v)
> > > > > >     if (ops->set_map || ops->dma_map)
> > > > > >             return 0;
> > > > > >
> > > > > > +   domain = iommu_get_domain_for_dev(dma_dev);
> > > > > > +   if ((!domain || domain->type == IOMMU_DOMAIN_IDENTITY) &&
> > > > > > +       vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {
> > > > >
> > > > > So if userspace does not have CAP_SYS_RAWIO instead of failing
> > > > > with a permission error the functionality changes silently?
> > > > > That's confusing, I think.
> > > > Yes, you are correct. I will modify the code to return error when
> > > > vhost_vdpa_noiommu is set and CAP_SYS_RAWIO is not set.
> > > >
> > > > Thanks.
> > > > >
> > > > >
> > > > > > +           add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > > > > > +           dev_warn(&v->dev, "Adding kernel taint for noiommu
> > > > > > + on
> > > > > device\n");
> > > > > > +           v->noiommu_en = true;
> > > > > > +           return 0;
> > > > > > +   }
> > > > > >     bus = dma_dev->bus;
> > > > > >     if (!bus)
> > > > > >             return -EFAULT;
> > > > > > --
> > > > > > 2.25.1
> > > >
> 


