Return-Path: <kvm+bounces-22033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 697F49389F7
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 09:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB7BE1F218E0
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 07:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F8C1BC40;
	Mon, 22 Jul 2024 07:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QkghZ6/V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48371B7F4
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 07:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721632959; cv=none; b=j0r/0aCNt3bfOeQOsAcqjsan/waMCp1KUdyYV5UmFLpzwFT6DeuYq2sC+iGqzk7ty0UHcGgrsuqW3OrqTHTeP+xVxKawgAU3UMfD2JxX52E36BDKpLWdAVKCS9c7+jMI7pmIRxxYdKvwf7O4RzvtUk/5sXIpozMnPI9nH9eyU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721632959; c=relaxed/simple;
	bh=ti/zS8WZC+sFNCGDy+hT0PHfNFDb0khV8QfEj4Bm8lA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbZjLDanh3/PU1eEklYVXrfga3hMyV7YV2HakGs43rZMnA4b1RXOMv80GLBaZ4XXQBW41XvbkF0kK5bR5ILiisZekWys3fzACQWdmQmQpfrM05QYSSP/Kdv1lugpRql2B9BI+wP/0kSLYWmDFrCxZQQ9/nO/aexictNvi2F6ds8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QkghZ6/V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721632956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kInPygYxPMlif7LRw2c2odNqavzlqnp2gG/qn7xs2hI=;
	b=QkghZ6/Vn8DWpg6vpb4JPajEP7ebJbi4Q3bG5qaxhmNJ/BF2qgVsvWWzDC8IIwrplm8DgB
	6qm1Dz50l3mdMjRgTEY35yFhp+A3+JXEUvobNm29clT2mJbeEHJ2FUHPugwhkVIz5FH+D5
	GT50L4eOanLqhR9z9ymO6AC28Di0i6g=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-Pbfvr1h3PaydihRM18Lqgg-1; Mon, 22 Jul 2024 03:22:34 -0400
X-MC-Unique: Pbfvr1h3PaydihRM18Lqgg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2cb685d5987so4557998a91.2
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 00:22:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721632954; x=1722237754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kInPygYxPMlif7LRw2c2odNqavzlqnp2gG/qn7xs2hI=;
        b=ilONt4/8mNIbNtnCVQtxt7EmtQi3nu1OUvLp7Tvu37rjmIfzw5q3ySRpNxf/qDvPKc
         0hA7zQniLCGf3GeO9NOMLcfi8n2nFLw0LA0LIf2qvL0PSeITpFGnJlui+wCMmC0qC/VT
         uE0kxCAP4bCZzekI6ceGDX6JOECosMRW9z9mivhVfTFw1YKfL3VayBEOUY9sSuZ7F2nm
         wttFctjf8diT/lpC0XPKorjBQjpzXhlicNfWJ/GBB6/LWapkrztSlxXQIMn7pHRkKwi2
         UlwfnUrkFc502KTkxs4mdo3bWgZAkXJxDB9IzYMTAIzh8sXAkcptmAorYih3HE8ShRSp
         iKXg==
X-Forwarded-Encrypted: i=1; AJvYcCUcouwl0ZXXgrARU34VDg/w8fkH+NPEcjC518JqlrajYSzOST5udqz4jXHrP65d6PzR8XklIPQJsiEWOPliM28KY+jr
X-Gm-Message-State: AOJu0Yw7K65EB0MX+flHFV6BHQifeTxeKFy2dQ+bpt8JJ2oJaPga3n3V
	Py86oWxcQwOnLA7Aw1eMRtLHDnyQmISYjbmU8I0mObQ7ctBoFwtO3ZElz7dMdtQ3GvRSMmzBF4L
	QtNY3ylIeOOrJEslxSnILj18TY4T0LG48YWfb7wpVCBnfTFWS8C4MKyXG/sxNaG3z3FzVZjlh0y
	1AENZzfQW5nTR15i/p0bKqB0J6
X-Received: by 2002:a17:90b:3908:b0:2c9:84f9:a321 with SMTP id 98e67ed59e1d1-2cd160725f4mr6050175a91.23.1721632953788;
        Mon, 22 Jul 2024 00:22:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZ+E2ceYn0Wd5f0W6UE1K4EVwm5XTvkoIK4IMirb+t3rdiEGFo/XhHs5oBvekS1bW5fcEfxEbRW15sQEZe0cE=
X-Received: by 2002:a17:90b:3908:b0:2c9:84f9:a321 with SMTP id
 98e67ed59e1d1-2cd160725f4mr6050159a91.23.1721632953290; Mon, 22 Jul 2024
 00:22:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530101823.1210161-1-schalla@marvell.com> <20240717054547-mutt-send-email-mst@kernel.org>
 <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
In-Reply-To: <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 22 Jul 2024 15:22:22 +0800
Message-ID: <CACGkMEtQ3SWBpS-00BBCJxoUK5AQRB=FhKGEqigh81GTbRf61A@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
To: Srujana Challa <schalla@marvell.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Vamsi Krishna Attunuru <vattunuru@marvell.com>, 
	Shijith Thotton <sthotton@marvell.com>, Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>, 
	Jerin Jacob <jerinj@marvell.com>, "joro@8bytes.org" <joro@8bytes.org>, 
	"will@kernel.org" <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 11:40=E2=80=AFPM Srujana Challa <schalla@marvell.co=
m> wrote:
>
> > On Thu, May 30, 2024 at 03:48:23PM +0530, Srujana Challa wrote:
> > > This commit introduces support for an UNSAFE, no-IOMMU mode in the
> > > vhost-vdpa driver. When enabled, this mode provides no device
> > > isolation, no DMA translation, no host kernel protection, and cannot
> > > be used for device assignment to virtual machines. It requires RAWIO
> > > permissions and will taint the kernel.
> > > This mode requires enabling the
> > "enable_vhost_vdpa_unsafe_noiommu_mode"
> > > option on the vhost-vdpa driver. This mode would be useful to get
> > > better performance on specifice low end machines and can be leveraged
> > > by embedded platforms where applications run in controlled environmen=
t.
> > >
> > > Signed-off-by: Srujana Challa <schalla@marvell.com>
> >
> > Thought hard about that.
> > I think given vfio supports this, we can do that too, and the extension=
 is small.
> >
> > However, it looks like setting this parameter will automatically change=
 the
> > behaviour for existing userspace when IOMMU_DOMAIN_IDENTITY is set.
> >
> > I suggest a new domain type for use just for this purpose.

I'm not sure I get this, we want to bypass IOMMU, so it doesn't even
have a doman.

> This way if host has
> > an iommu, then the same kernel can run both VMs with isolation and unsa=
fe
> > embedded apps without.
> Could you provide further details on this concept? What criteria would de=
termine
> the configuration of the new domain type? Would this require a boot param=
eter
> similar to IOMMU_DOMAIN_IDENTITY, such as iommu.passthrough=3D1 or iommu.=
pt?

Thanks

> >
> > > ---
> > >  drivers/vhost/vdpa.c | 23 +++++++++++++++++++++++
> > >  1 file changed, 23 insertions(+)
> > >
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index
> > > bc4a51e4638b..d071c30125aa 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -36,6 +36,11 @@ enum {
> > >
> > >  #define VHOST_VDPA_IOTLB_BUCKETS 16
> > >
> > > +bool vhost_vdpa_noiommu;
> > > +module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
> > > +              vhost_vdpa_noiommu, bool, 0644);
> > > +MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode,
> > "Enable
> > > +UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no
> > > +DMA translation, no host kernel protection, cannot be used for devic=
e
> > > +assignment to virtual machines, requires RAWIO permissions, and will
> > > +taint the kernel.  If you do not know what this is for, step away.
> > > +(default: false)");
> > > +
> > >  struct vhost_vdpa_as {
> > >     struct hlist_node hash_link;
> > >     struct vhost_iotlb iotlb;
> > > @@ -60,6 +65,7 @@ struct vhost_vdpa {
> > >     struct vdpa_iova_range range;
> > >     u32 batch_asid;
> > >     bool suspended;
> > > +   bool noiommu_en;
> > >  };
> > >
> > >  static DEFINE_IDA(vhost_vdpa_ida);
> > > @@ -887,6 +893,10 @@ static void vhost_vdpa_general_unmap(struct
> > > vhost_vdpa *v,  {
> > >     struct vdpa_device *vdpa =3D v->vdpa;
> > >     const struct vdpa_config_ops *ops =3D vdpa->config;
> > > +
> > > +   if (v->noiommu_en)
> > > +           return;
> > > +
> > >     if (ops->dma_map) {
> > >             ops->dma_unmap(vdpa, asid, map->start, map->size);
> > >     } else if (ops->set_map =3D=3D NULL) {
> > > @@ -980,6 +990,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
> > struct vhost_iotlb *iotlb,
> > >     if (r)
> > >             return r;
> > >
> > > +   if (v->noiommu_en)
> > > +           goto skip_map;
> > > +
> > >     if (ops->dma_map) {
> > >             r =3D ops->dma_map(vdpa, asid, iova, size, pa, perm, opaq=
ue);
> > >     } else if (ops->set_map) {
> > > @@ -995,6 +1008,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
> > struct vhost_iotlb *iotlb,
> > >             return r;
> > >     }
> > >
> > > +skip_map:
> > >     if (!vdpa->use_va)
> > >             atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
> > >
> > > @@ -1298,6 +1312,7 @@ static int vhost_vdpa_alloc_domain(struct
> > vhost_vdpa *v)
> > >     struct vdpa_device *vdpa =3D v->vdpa;
> > >     const struct vdpa_config_ops *ops =3D vdpa->config;
> > >     struct device *dma_dev =3D vdpa_get_dma_dev(vdpa);
> > > +   struct iommu_domain *domain;
> > >     const struct bus_type *bus;
> > >     int ret;
> > >
> > > @@ -1305,6 +1320,14 @@ static int vhost_vdpa_alloc_domain(struct
> > vhost_vdpa *v)
> > >     if (ops->set_map || ops->dma_map)
> > >             return 0;
> > >
> > > +   domain =3D iommu_get_domain_for_dev(dma_dev);
> > > +   if ((!domain || domain->type =3D=3D IOMMU_DOMAIN_IDENTITY) &&
> > > +       vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {
> >
> > So if userspace does not have CAP_SYS_RAWIO instead of failing with a
> > permission error the functionality changes silently?
> > That's confusing, I think.
> Yes, you are correct. I will modify the code to return error when vhost_v=
dpa_noiommu
> is set and CAP_SYS_RAWIO is not set.
>
> Thanks.
> >
> >
> > > +           add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > > +           dev_warn(&v->dev, "Adding kernel taint for noiommu on
> > device\n");
> > > +           v->noiommu_en =3D true;
> > > +           return 0;
> > > +   }
> > >     bus =3D dma_dev->bus;
> > >     if (!bus)
> > >             return -EFAULT;
> > > --
> > > 2.25.1
>


