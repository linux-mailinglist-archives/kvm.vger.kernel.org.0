Return-Path: <kvm+bounces-12902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB7688EFF4
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 21:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38CDAB22CF9
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 20:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084DB15251C;
	Wed, 27 Mar 2024 20:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vy1LTToJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE502D047
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 20:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570336; cv=none; b=PPZEBIkYwU8bzPG3SJajq0a+X8klZZBwORnIE/00yAKrx0L00Qv762xQNu9VxjR1rvk2iGIZoRB/6zZPc8xCbWF91owNY5nenOYDnndgzTkzXM9ATjZfRIlJBywnjYeV67tcr2YbGmGihvWIw5iXCq6I9WSvZsXQOinWp1Chrn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570336; c=relaxed/simple;
	bh=WzIa13U96NZfFBs4EM7FqImMlIViWoOM1oO4KtR8nsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmmlZHMj4Exjy7WSKHPcSF98kbTnfCoIFT7m79fSXUDm73nYdpjK96ZMIKl38AdVzv6t+eNeHOQ4phWzvtnym0PcBpHl1zyr3dVs4TtocOImtFoaSK0+xR2N9wu79xq+DKkMCxFW8xI+39c3sdDK3g1e/MlJMpoGnoGPzhMwD8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vy1LTToJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711570333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6nBIaDcT7LUUT5QTvJ9cu4LaeUEx2trqi0MtGL39LRI=;
	b=Vy1LTToJ3ttu0YhS/EYzdo3nRdufow5ZnOmUFnnSVzqEAODjc+Azhni99bUr/GBbIF8y8c
	2H1tnEuF34hKbraFHtHObwLYJVGaOCINwCW013hKzGipCTVYu2oCzGBrLUnx7B6U15iow3
	0LKVR1XAKqu+X4GkLDwwPQjAR04uBCs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-abIiwMkZNEWqk7pHbiQEtA-1; Wed, 27 Mar 2024 16:12:11 -0400
X-MC-Unique: abIiwMkZNEWqk7pHbiQEtA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33ed8677d16so87780f8f.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711570330; x=1712175130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nBIaDcT7LUUT5QTvJ9cu4LaeUEx2trqi0MtGL39LRI=;
        b=rOxigGvi0pP+otA7c5Ifmn5AeEcBeqANS0nq5INBv5HhZubNpyK60cXemHf9ELtKth
         ttbPHIj411KLR5wlyj6h102DPha+MZuZT00JRSk5DTPebArd9yTN38YgE/l07y0iy6q8
         p0A3Rntjfyd+GTKqdhVxcsADLShjvQ6+lfqZ42XyKr+tIjBhcTxm9a7uvJD+7Iuvf4+1
         3tk3fDQ2pVETEcDSeIbl/ty4IkQUTWfxLO6Bj6CNmlV8K/Q7FR8ngLYhXRPplXNZZWVm
         KthcfiSCozmNVN7AJFiG16IJVdrJBnKR9lddxWcDPomVm34SvtPEM+pCXmBvFwUSAmeL
         +v6A==
X-Forwarded-Encrypted: i=1; AJvYcCVd5gabl840OdxkyzWiXQXTPxSRCQ6BMPLfhE/QhIkRHQNVk4DcZOuz7/jB19Ot/K/9d84pQZmWIguQdJLvQr623zDp
X-Gm-Message-State: AOJu0YyhxtdiuZsxWAh6k2W5vaExULbuMoPnfKQpfphs2ec8KwbfeAJh
	9KUwI1BsjOVTW7Vo+spsZWsT56HiN3HcaO7l9f/yx2X4QhG1JGNb9wQY1ALktSTMzTnbDMywxmR
	6S27bTLu//uS5e6KK3RkQt+lJClOA8z8eRfySe/LeCfcjlLHnkA==
X-Received: by 2002:adf:e291:0:b0:341:7864:a6e3 with SMTP id v17-20020adfe291000000b003417864a6e3mr777062wri.2.1711570330554;
        Wed, 27 Mar 2024 13:12:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqOS1B1IYng0wFCMRvLflHI1VywgJiHL9VKUdTX+xl14v3YTdbY3pG7wS/MfQqo6cdyUV+Dw==
X-Received: by 2002:adf:e291:0:b0:341:7864:a6e3 with SMTP id v17-20020adfe291000000b003417864a6e3mr777039wri.2.1711570329984;
        Wed, 27 Mar 2024 13:12:09 -0700 (PDT)
Received: from redhat.com ([2.52.20.36])
        by smtp.gmail.com with ESMTPSA id en9-20020a056000420900b00341b451a31asm9531152wrb.36.2024.03.27.13.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 13:12:09 -0700 (PDT)
Date: Wed, 27 Mar 2024 16:11:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vinayak Kale <vkale@nvidia.com>, qemu-devel@nongnu.org,
	marcel.apfelbaum@gmail.com, avihaih@nvidia.com, acurrid@nvidia.com,
	cjia@nvidia.com, zhiw@nvidia.com, targupta@nvidia.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/pci: migration: Skip config space check for
 Vendor Specific Information in VSC during restore/load
Message-ID: <20240327161108-mutt-send-email-mst@kernel.org>
References: <20240322064210.1520394-1-vkale@nvidia.com>
 <20240327113915.19f6256c.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327113915.19f6256c.alex.williamson@redhat.com>

On Wed, Mar 27, 2024 at 11:39:15AM -0600, Alex Williamson wrote:
> On Fri, 22 Mar 2024 12:12:10 +0530
> Vinayak Kale <vkale@nvidia.com> wrote:
> 
> > In case of migration, during restore operation, qemu checks config space of the
> > pci device with the config space in the migration stream captured during save
> > operation. In case of config space data mismatch, restore operation is failed.
> > 
> > config space check is done in function get_pci_config_device(). By default VSC
> > (vendor-specific-capability) in config space is checked.
> > 
> > Due to qemu's config space check for VSC, live migration is broken across NVIDIA
> > vGPU devices in situation where source and destination host driver is different.
> > In this situation, Vendor Specific Information in VSC varies on the destination
> > to ensure vGPU feature capabilities exposed to the guest driver are compatible
> > with destination host.
> > 
> > If a vfio-pci device is migration capable and vfio-pci vendor driver is OK with
> > volatile Vendor Specific Info in VSC then qemu should exempt config space check
> > for Vendor Specific Info. It is vendor driver's responsibility to ensure that
> > VSC is consistent across migration. Here consistency could mean that VSC format
> > should be same on source and destination, however actual Vendor Specific Info
> > may not be byte-to-byte identical.
> > 
> > This patch skips the check for Vendor Specific Information in VSC for VFIO-PCI
> > device by clearing pdev->cmask[] offsets. Config space check is still enforced
> > for 3 byte VSC header. If cmask[] is not set for an offset, then qemu skips
> > config space check for that offset.
> > 
> > Signed-off-by: Vinayak Kale <vkale@nvidia.com>
> > ---
> > Version History
> > v2->v3:
> >     - Config space check skipped only for Vendor Specific Info in VSC, check is
> >       still enforced for 3 byte VSC header.
> >     - Updated commit description with live migration failure scenario.
> > v1->v2:
> >     - Limited scope of change to vfio-pci devices instead of all pci devices.
> > 
> >  hw/vfio/pci.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> 
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>


A very reasonable way to do it.

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

Merge through the VFIO tree I presume?


>  
> > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > index d7fe06715c..1026cdba18 100644
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > @@ -2132,6 +2132,27 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
> >      }
> >  }
> >  
> > +static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
> > +                                        uint8_t size, Error **errp)
> > +{
> > +    PCIDevice *pdev = &vdev->pdev;
> > +
> > +    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
> > +    if (pos < 0) {
> > +        return pos;
> > +    }
> > +
> > +    /*
> > +     * Exempt config space check for Vendor Specific Information during restore/load.
> > +     * Config space check is still enforced for 3 byte VSC header.
> > +     */
> > +    if (size > 3) {
> > +        memset(pdev->cmask + pos + 3, 0, size - 3);
> > +    }
> > +
> > +    return pos;
> > +}
> > +
> >  static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
> >  {
> >      PCIDevice *pdev = &vdev->pdev;
> > @@ -2199,6 +2220,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
> >          vfio_check_af_flr(vdev, pos);
> >          ret = pci_add_capability(pdev, cap_id, pos, size, errp);
> >          break;
> > +    case PCI_CAP_ID_VNDR:
> > +        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
> > +        break;
> >      default:
> >          ret = pci_add_capability(pdev, cap_id, pos, size, errp);
> >          break;


