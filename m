Return-Path: <kvm+bounces-35636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE7AA13693
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 10:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75DA818891D2
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2101D8E1A;
	Thu, 16 Jan 2025 09:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hnXebEtw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53CA26AF6
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 09:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737019697; cv=none; b=GpVj+dZ/7JANtEp/jSi6RN1VUlLsBtw4bN07dA694Zn3nDWeSFNrIENOhtD9/GcPC2P3zzsv7F5CmAwqeU5nnyhw2vX58mYckxcZMf1gunS1We5f7AkwCt747zJwcW7IVIAlFo/goWUsmDIwxvSt/FbioT+FUie6POifT/BV0Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737019697; c=relaxed/simple;
	bh=i9CJq6mh1Xcp9sBXpvbK28sgVJJJJFUlEMvpbsub/bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DarbJW+OMx3Uu5B46AbZnOCZNsHxVvnU+/I7ltPOe5Pas7b1MPlKfTYWdvyoX77U5BLsvYzFEqsxlFBi1A0QYNNdsg0IbViNKHYl81DIATM1xp+DvybJ7ezeGkchvDUU8w1w1JfpyC51E89rgjQTREu4KzAZJ890GS1K61+yml8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=hnXebEtw; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-436202dd730so3775385e9.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 01:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737019692; x=1737624492; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H3BsnAoQkUOuoKYlBFDIPGPW0kgM78WvS760M32hguo=;
        b=hnXebEtwFCEUlOz5emCwzO0zEXMiejRvreyaqlFbg4CYJh/nKWZNYd9ZKyjSjWNMUW
         w9jkZaWPiEzn8xvny7zZaeldkuXgyUZXcfF7zfTDiL23Yv57mgnYESONhKZQ2SPrHIcY
         8tOSdJwXB4sZLmEOk7zp/7YP+gxZehNJNxvkatVpHQrh38FfDK1IgkfQlyse/RkbPsxo
         EEzbslJnPV6vWoYXS0QFG9OyMiHafnlE1nWOj4lkv5KXun2AY6bbp000VYVRqPww9N+x
         oGZMNDU9L0KqEIRiKCS8DmEiJW9YSv1ZVgJzP+ptR/PsX0sTzl+UrSrwReZGMATHE51R
         rNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737019692; x=1737624492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H3BsnAoQkUOuoKYlBFDIPGPW0kgM78WvS760M32hguo=;
        b=iN7uYPDk86gIgsoF63XuqZK2gHXSBdc29u9fEukLWlc8IoVHrYAL6SQpk9t4r2ZDqK
         8tUxh8HY8+U9FaZcAfu/5pV+tZ2pfjqzyzmdS7fJUisxajE3dNEnWV+vH3p2/frmqpKl
         GtAX5Vb1oG2ZaTG145MA7Qb9/B7ES6JIy1q1EoNoLTOihWcLkUeo+p1u03Z34zmzRj4m
         8iNJeb2PZOO1fZBmqq5KDSEkKyuTk+N+M4c/GX67SmhcgpkwX5kl+1eYZdrS242AaSHJ
         zEADVmWbZiSAm9V/Xc8w1n1wHiBovjQWRCRS4yGbqEH3fx+Ajfi2zNsFUBv/cB+abR2y
         zUoQ==
X-Gm-Message-State: AOJu0YyJHN9f3/SRjyDn8LsMFGTfx12kmZVdzpGgLRMTwW7l6gZ30XjY
	ihiBCGDTCh2vQfNZDM0slJh25xigNVp4nlb9Vszp5H7hq5TeEw6NFbk4EMN/pwg=
X-Gm-Gg: ASbGncva56vjQ1huK2imRQlq1y1qnVtZ+wStcaJlPCrPPaaCNhD1jiu5e2cg+MM4/d2
	XkkmZQTkjuhFTBykIcm1FvPcJ0cI7xdR7gXGdKLqJMVBz3QfXx/Nef3fbUyWnYD/hnNqfuAC+2z
	nPblv5cf2oRoURtr5WFzGWeYmxKWJhq++UVfqnoeoM5UxgQvCZ3oB58yVUkUY2fLyv2AgGimdqM
	lC4x9RBhOKcpjT8jNAjDjaLLAgXZ+4O8q2d6/WNmVbthUPztBh/NqjlRXwHwuO3dW0WJv6qAUHn
	t603hHAp5xQ7kAtz++vD/PZimHNn5gZc65QHeEr8Ow==
X-Google-Smtp-Source: AGHT+IGkXzitVIl2xC4+uCIjMrGgjP57ZGUd4zJZ8dsllBGolwrs+nH3aliXgZ9Gc3Iy5cYM7lVqvQ==
X-Received: by 2002:a05:600c:3ba4:b0:431:3bf9:3ebb with SMTP id 5b1f17b1804b1-436e26f4805mr256332965e9.24.1737019691988;
        Thu, 16 Jan 2025 01:28:11 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74f9ccasm52005305e9.39.2025.01.16.01.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 01:28:11 -0800 (PST)
Date: Thu, 16 Jan 2025 10:28:10 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: kvm@vger.kernel.org, felix.chong@codethink.co.uk, 
	lawrence.hunter@codethink.co.uk, roan.richmond@codethink.co.uk
Subject: Re: [PATCH kvmtool] kvmtool: virtio: fix endian for big endian hosts
Message-ID: <20250116-e80c8bf6f54d88dbd6d5e7a9@orel>
References: <20250115101125.526492-1-ben.dooks@codethink.co.uk>
 <20250115-73a1112ddbc729143d052afb@orel>
 <01e504c1-58d3-4652-9366-1f518b7bd86e@codethink.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01e504c1-58d3-4652-9366-1f518b7bd86e@codethink.co.uk>

On Wed, Jan 15, 2025 at 03:09:58PM +0000, Ben Dooks wrote:
> On 15/01/2025 14:24, Andrew Jones wrote:
> > On Wed, Jan 15, 2025 at 10:11:25AM +0000, Ben Dooks wrote:
> > > When running on a big endian host, the virtio mmio-modern.c correctly
> > > sets all reads to return little endian values. However the header uses
> > > a 4 byte char for the magic value, which is always going to be in the
> > > correct endian regardless of host endian.
> > > 
> > > To make the simplest change, simply avoid endian convresion of the
> > > read of the magic value. This fixes the following bug from the guest:
> > > 
> > > [    0.592838] virtio-mmio 10020000.virtio: Wrong magic value 0x76697274!
> > > 
> > > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > > ---
> > >   virtio/mmio-modern.c | 5 ++++-
> > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
> > > index 6c0bb38..fd9c0cb 100644
> > > --- a/virtio/mmio-modern.c
> > > +++ b/virtio/mmio-modern.c
> > > @@ -66,7 +66,10 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
> > >   		return;
> > >   	}
> > > -	*data = cpu_to_le32(val);
> > > +	if (addr != VIRTIO_MMIO_MAGIC_VALUE)
> > > +		*data = cpu_to_le32(val);
> > > +	else
> > > +		*data = val;
> > >   }
> > >   static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
> > > -- 
> > > 2.37.2.352.g3c44437643
> > > 
> > 
> > I think vendor_id should also have the same issue, but drivers don't
> > notice because they all use VIRTIO_DEV_ANY_ID. So how about the
> > change below instead?
> > 
> > Thanks,
> > drew
> > 
> > diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
> > index b428b8d32f48..133817c1dc44 100644
> > --- a/include/kvm/virtio-mmio.h
> > +++ b/include/kvm/virtio-mmio.h
> > @@ -18,7 +18,7 @@ struct virtio_mmio_ioevent_param {
> >   };
> > 
> >   struct virtio_mmio_hdr {
> > -       char    magic[4];
> > +       u32     magic;
> >          u32     version;
> >          u32     device_id;
> >          u32     vendor_id;
> > diff --git a/virtio/mmio.c b/virtio/mmio.c
> > index fae73b52dae0..782268e8f842 100644
> > --- a/virtio/mmio.c
> > +++ b/virtio/mmio.c
> > @@ -6,6 +6,7 @@
> >   #include "kvm/irq.h"
> >   #include "kvm/fdt.h"
> > 
> > +#include <linux/byteorder.h>
> >   #include <linux/virtio_mmio.h>
> >   #include <string.h>
> > 
> > @@ -168,10 +169,10 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
> >                  return r;
> > 
> >          vmmio->hdr = (struct virtio_mmio_hdr) {
> > -               .magic          = {'v', 'i', 'r', 't'},
> > +               .magic          = le32_to_cpu(0x74726976), /* 'virt' */
> 
> 
> just doing the change of magic type and then doing
> 	.magic = 0x74726976;
> 
> should work, as then magic is in host order amd will get converted
> to le32 in the IO code. Don't think vendor_id suffers as it was
> converted from string to hex.

Oh, right. I overthought that one. I prefer the magic in hex better than
the special casing in virtio_mmio_config_in()

Thanks,
drew

> 
> >                  .version        = legacy ? 1 : 2,
> >                  .device_id      = subsys_id,
> > -               .vendor_id      = 0x4d564b4c , /* 'LKVM' */
> > +               .vendor_id      = le32_to_cpu(0x4d564b4c), /* 'LKVM' */
> >                  .queue_num_max  = 256,
> >          };
> > 
> 
> 
> -- 
> Ben Dooks				http://www.codethink.co.uk/
> Senior Engineer				Codethink - Providing Genius
> 
> https://www.codethink.co.uk/privacy.html

