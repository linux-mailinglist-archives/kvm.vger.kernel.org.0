Return-Path: <kvm+bounces-35761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8CDA14D3A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:12:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10B8F3A4ACF
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942001FECC5;
	Fri, 17 Jan 2025 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WUtEr4/G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE271FC7E0
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737108455; cv=none; b=kYbUNNRM84MWbEYyCx23y/asIl8nIsJxRTy+ufpW3+mjkcfvf3RLclcpALbt0hXqeYrGjwwa7z5PNrqhNMbqf9IxCkpTcDqJqyeBpluZZRLrhGpENH/6aEXEIuLkDcSRroqGI+zRuZukTPuAtdY4du+DU86bN12R5EOiZn23Ay0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737108455; c=relaxed/simple;
	bh=OYG4tBj9HFAPaC29+T0k+iozdH/sVf9n5eZlB+Oxzm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGI/toBlIzCRuAIuadDW+84Tpb3UiH6Cl6I0P9qSCt3q3rOzxwbd62QLyUVsR6DC1qJhi9uCE7PnZ+VwgYpgGtPLTOCqwi3cOt7ZiSmOVFv2PrwR7ngMXMQDHvH5qLcnQkE00jB2fSqAfpUaECxsfyTpavR2OEaVsK8SPv3x/Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WUtEr4/G; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-436326dcb1cso12174055e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 02:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737108452; x=1737713252; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PRUGkjNqRAXANURkip9Y5j/vnkDXP0o3DX5YMDnxKZc=;
        b=WUtEr4/Gyud8kaER8/HIedZSswueUk1W0juKkTk3406pFi7vOZAMa+J0L5CxzLM7Vl
         OYF6TU14ymxqECwa/FTUzSXbMnCs3w3v3OEyrY8M9rkONHaigPvya0MAshh291zKlGR7
         Yo8DLWeA2VuKtQhSLhZcHAQv4G9s2y34HJq2rW7yCR/l3dh5mrBlAz37qVKxg92nFeT8
         XXpEaHBOaD0yqXv0SfQQ3QtbzyYiusGWmEGRBEibfTLPnT8zp7UZWA8OttOvjeE1IhDY
         GQNWLCE3ZYOq5FTqeIHnDeHvzHdh82xmuGZIHNq6EF+coWTBUEmdeDrbWR+vI4zTOeAU
         ezyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737108452; x=1737713252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRUGkjNqRAXANURkip9Y5j/vnkDXP0o3DX5YMDnxKZc=;
        b=ifslLdsUS49OtCZurXWzDeJ2EmyojTdLCrA/CMFLN+Qw2OgnlhCZyGGXimDFSFjpmH
         alEDM41CCYN+ONfy5wnUTG8SX4bcQ5kD25aq/fcuPBfFb6EqljuENsyrum63N8Eezqo8
         06pu1dgeo4KrQceT96dpgmv7CsnPH64jD1CvbB7V2XeXpRdImEGd2pwx1krBGmooegZp
         pmxPxIdHGext/wH/N4fl21084Z3349OCTGo9u+LUf6MU6kiSMPXpchazLDaCoWZQebIg
         8Je7UMcoLE6pzJ76zv7lEMpDz4hYErY8dSoyrO8uidPcOXSBEYSihx5b7vLAR5Id/l5D
         PAdg==
X-Gm-Message-State: AOJu0YwaK8Yl39Pv6L6qLTuKWQ8kZlw9gDwFTBdeo3TKZnueKucpLHxQ
	2lRjtiXGXwEhglHsldRxhdna+uXmTVNsPBoFxiufSYn4BkcM0V1w3QWCJZi0dt0=
X-Gm-Gg: ASbGncvIQiFgqiZ5hf4KmAOKOVvEHxr2r171qi0Dc/xeWlE+o4ziY8WTyz36k9ULi/L
	iai+8ZpC35KO1wDk20ynqXpmOGc8uJVZG2jx40IvCjNKLnJQlMtl7MRBoSyJVJNDozBZGYBFWf8
	5TITYUBsNHmO67VnfvGabiO+TWZAp2rx2SkW3anGVU0TPVt86jHj7D+vag2ux137kHCkfYl1eSn
	4pVC201I0dTiahmxP+Bnu8/hOLv81xebfYEotnH4CS8+PLl9IU+nbnvJBBp+p1bP2mED5erIigO
	QNXoTrMCx7z6ADoDH/JGIwdMb7OBSLYuOGnbdQySvg==
X-Google-Smtp-Source: AGHT+IHI/zVw1L7/q3vvt3enDlkGC14kx7MYI2Rut9gAjHJVVmEqW/JDTJjAKf1bC87D9M9NOgi3PA==
X-Received: by 2002:a7b:c8c9:0:b0:436:fb02:e68 with SMTP id 5b1f17b1804b1-438913bdd6cmr18528765e9.2.1737108451899;
        Fri, 17 Jan 2025 02:07:31 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389040854bsm28926935e9.7.2025.01.17.02.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 02:07:31 -0800 (PST)
Date: Fri, 17 Jan 2025 11:07:30 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: kvm@vger.kernel.org, felix.chong@codethink.co.uk, 
	lawrence.hunter@codethink.co.uk, roan.richmond@codethink.co.uk
Subject: Re: [PATCH kvmtool] kvmtool: virtio: fix endian for big endian hosts
Message-ID: <20250117-38002d516fcaeb37bae139cc@orel>
References: <20250115101125.526492-1-ben.dooks@codethink.co.uk>
 <20250115-73a1112ddbc729143d052afb@orel>
 <01e504c1-58d3-4652-9366-1f518b7bd86e@codethink.co.uk>
 <20250116-e80c8bf6f54d88dbd6d5e7a9@orel>
 <2509980e-028c-4d49-bb98-a864a9176212@codethink.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2509980e-028c-4d49-bb98-a864a9176212@codethink.co.uk>

On Fri, Jan 17, 2025 at 09:57:29AM +0000, Ben Dooks wrote:
> On 16/01/2025 09:28, Andrew Jones wrote:
> > On Wed, Jan 15, 2025 at 03:09:58PM +0000, Ben Dooks wrote:
> > > On 15/01/2025 14:24, Andrew Jones wrote:
> > > > On Wed, Jan 15, 2025 at 10:11:25AM +0000, Ben Dooks wrote:
> > > > > When running on a big endian host, the virtio mmio-modern.c correctly
> > > > > sets all reads to return little endian values. However the header uses
> > > > > a 4 byte char for the magic value, which is always going to be in the
> > > > > correct endian regardless of host endian.
> > > > > 
> > > > > To make the simplest change, simply avoid endian convresion of the
> > > > > read of the magic value. This fixes the following bug from the guest:
> > > > > 
> > > > > [    0.592838] virtio-mmio 10020000.virtio: Wrong magic value 0x76697274!
> > > > > 
> > > > > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > > > > ---
> > > > >    virtio/mmio-modern.c | 5 ++++-
> > > > >    1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
> > > > > index 6c0bb38..fd9c0cb 100644
> > > > > --- a/virtio/mmio-modern.c
> > > > > +++ b/virtio/mmio-modern.c
> > > > > @@ -66,7 +66,10 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
> > > > >    		return;
> > > > >    	}
> > > > > -	*data = cpu_to_le32(val);
> > > > > +	if (addr != VIRTIO_MMIO_MAGIC_VALUE)
> > > > > +		*data = cpu_to_le32(val);
> > > > > +	else
> > > > > +		*data = val;
> > > > >    }
> > > > >    static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
> > > > > -- 
> > > > > 2.37.2.352.g3c44437643
> > > > > 
> > > > 
> > > > I think vendor_id should also have the same issue, but drivers don't
> > > > notice because they all use VIRTIO_DEV_ANY_ID. So how about the
> > > > change below instead?
> > > > 
> > > > Thanks,
> > > > drew
> > > > 
> > > > diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
> > > > index b428b8d32f48..133817c1dc44 100644
> > > > --- a/include/kvm/virtio-mmio.h
> > > > +++ b/include/kvm/virtio-mmio.h
> > > > @@ -18,7 +18,7 @@ struct virtio_mmio_ioevent_param {
> > > >    };
> > > > 
> > > >    struct virtio_mmio_hdr {
> > > > -       char    magic[4];
> > > > +       u32     magic;
> > > >           u32     version;
> > > >           u32     device_id;
> > > >           u32     vendor_id;
> > > > diff --git a/virtio/mmio.c b/virtio/mmio.c
> > > > index fae73b52dae0..782268e8f842 100644
> > > > --- a/virtio/mmio.c
> > > > +++ b/virtio/mmio.c
> > > > @@ -6,6 +6,7 @@
> > > >    #include "kvm/irq.h"
> > > >    #include "kvm/fdt.h"
> > > > 
> > > > +#include <linux/byteorder.h>
> > > >    #include <linux/virtio_mmio.h>
> > > >    #include <string.h>
> > > > 
> > > > @@ -168,10 +169,10 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
> > > >                   return r;
> > > > 
> > > >           vmmio->hdr = (struct virtio_mmio_hdr) {
> > > > -               .magic          = {'v', 'i', 'r', 't'},
> > > > +               .magic          = le32_to_cpu(0x74726976), /* 'virt' */
> > > 
> > > 
> > > just doing the change of magic type and then doing
> > > 	.magic = 0x74726976;
> > > 
> > > should work, as then magic is in host order amd will get converted
> > > to le32 in the IO code. Don't think vendor_id suffers as it was
> > > converted from string to hex.
> > 
> > Oh, right. I overthought that one. I prefer the magic in hex better than
> > the special casing in virtio_mmio_config_in()
> > 
> > Thanks,
> > drew
> 
> Ok, will wait a few days to see if anyone else has a comment.
> 
> I assume you're ok with me re-doing my patch?

yup, thanks


> 
> Thanks for the review.
> 
> 
> -- 
> Ben Dooks				http://www.codethink.co.uk/
> Senior Engineer				Codethink - Providing Genius
> 
> https://www.codethink.co.uk/privacy.html

