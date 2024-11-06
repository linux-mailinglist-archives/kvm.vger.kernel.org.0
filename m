Return-Path: <kvm+bounces-31043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7BD9BF945
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 23:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F7A81C22005
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0FA20CCFE;
	Wed,  6 Nov 2024 22:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DK3EeMxC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED59E20823B
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 22:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730932063; cv=none; b=r4tBhDeOt2ULhXVDD6PUCtzidm10qT7kktXElyAQ1IZQrpuwjLjU0lIryCQd3bH64b/27k1TbPW2tOHwJfuzE+auEToZ0vppNZP4zaU3kKSC4DzPbteuuMsoUWDNM7jfUA80FiOye1Gv6btacTePySKHS/ayeGiJXZCe0Zbt8hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730932063; c=relaxed/simple;
	bh=TfcbASzHLXOQmhUTw7B7XdgxSKt70YMSigBRGMXvYGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2a70xhjD+YTHm0xcQthCTC709zIKWhJeD16Ez1sUTFUYMplShcHfaNJJMjPGDsKLNiybHPvH3uxSBBLvqllwNzwbOYRoUulAvHS2X8znhZ/T6/n1e6pWxj/KvyBg4YrPNJBoGleeLfu5SaGMNAnnF9pH0/oYJpX1Mu7HDlu3/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DK3EeMxC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730932060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=go5QFFw5cefXrO1K9axgjZ1UBjNlFOTxnqSlKpShRvI=;
	b=DK3EeMxCI96vKH422Mcx/w7uAqCICaN9nYyy9HaFplm1fT9GW9JT3u2MumL11SlZ1ryFSV
	lUN46hIkExzLv8/rMhQtgVv2VKs5FvCONjSIlVRK66HmPfpgpZsktecsfwYllj1jpOdpxT
	yY/WFxk/CcK6dP90tkCPDF7LRabTUDc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-oVHUQgYFM7CLd2Drraf1nA-1; Wed, 06 Nov 2024 17:27:36 -0500
X-MC-Unique: oVHUQgYFM7CLd2Drraf1nA-1
X-Mimecast-MFC-AGG-ID: oVHUQgYFM7CLd2Drraf1nA
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a4da5c5c02so652805ab.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 14:27:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730932056; x=1731536856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=go5QFFw5cefXrO1K9axgjZ1UBjNlFOTxnqSlKpShRvI=;
        b=I+RVPaJpQ1TTgFH50Lx/zoaNiR98EPYR1K6ewH3h892qnaAwomt29NQ8tqQvwXgT+A
         Uoa0lwz5cmXrWPA85+cN59rsVsXP+AYQKRSPpKrDTsJEtmEcuNb2eEZhf4pPVvMSe2NZ
         VlQ8HugBs19DJtJKYWXVhIIX36ewgsDVzm1rReewLONmDa5Gw3WHuPwVEimBozdDf6QV
         wMrDc77Ewm126NMSXpryIf0F6FixsIcVO/YavDkl6VpyuvlPZmj+8sWp8hIEh/SmTp0A
         Smab/PvRrLQmdpWE2gdKxdpBT2olifNATpjrAzht7qYe5T/73+XMayIh0mrlN0lOfRFf
         KiwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQt6SrTvGL9RTXT1lTs0wB6fR07toRgF8eWoBhkLwmUxqwCftmc4SllXhZCjFlFUbgnvM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHpbPL+N0g+mzCHA3L6U/ImidaZFGtJ7xMmE5w6ZGEwNPkeiC6
	83RWmGNU5QkAjSt6gRMuVmR2naaCXxPqoHS4hpjzTxM+oT3LkiNfbdjTq/+hiP9bHIbYPUqUwiO
	7XNSATF5baTubllDAnO/+XocazQ7YMijqGjYL1kCKERozFrNeWw==
X-Received: by 2002:a05:6e02:1c0f:b0:3a6:c23b:5aa9 with SMTP id e9e14a558f8ab-3a6e84cd750mr3952315ab.4.1730932056014;
        Wed, 06 Nov 2024 14:27:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHN4fi2YHJCawlF5KgLKrt4ol1xgPR4L91BiOakokLHkZ74AuOFSDy3T9be8LT9i6QdnCvUw==
X-Received: by 2002:a05:6e02:1c0f:b0:3a6:c23b:5aa9 with SMTP id e9e14a558f8ab-3a6e84cd750mr3952155ab.4.1730932055649;
        Wed, 06 Nov 2024 14:27:35 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6bb812f95sm28024745ab.39.2024.11.06.14.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 14:27:35 -0800 (PST)
Date: Wed, 6 Nov 2024 15:27:32 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com, jasowang@redhat.com,
 kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 parav@nvidia.com, feliu@nvidia.com, kevin.tian@intel.com,
 joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
Message-ID: <20241106152732.16ac48d3.alex.williamson@redhat.com>
In-Reply-To: <20241106135909.GO458827@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241104102131.184193-8-yishaih@nvidia.com>
	<20241105162904.34b2114d.alex.williamson@redhat.com>
	<20241106135909.GO458827@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 6 Nov 2024 09:59:09 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 05, 2024 at 04:29:04PM -0700, Alex Williamson wrote:
> > > @@ -1,7 +1,7 @@
> > >  # SPDX-License-Identifier: GPL-2.0-only
> > >  config VIRTIO_VFIO_PCI
> > >          tristate "VFIO support for VIRTIO NET PCI devices"
> > > -        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
> > > +        depends on VIRTIO_PCI
> > >          select VFIO_PCI_CORE
> > >          help
> > >            This provides support for exposing VIRTIO NET VF devices which support
> > > @@ -11,5 +11,7 @@ config VIRTIO_VFIO_PCI
> > >            As of that this driver emulates I/O BAR in software to let a VF be
> > >            seen as a transitional device by its users and let it work with
> > >            a legacy driver.
> > > +          In addition, it provides migration support for VIRTIO NET VF devices
> > > +          using the VFIO framework.  
> > 
> > The first half of this now describes something that may or may not be
> > enabled by this config option and the additional help text for
> > migration is vague enough relative to PF requirements to get user
> > reports that the driver doesn't work as intended.  
> 
> Yes, I think the help should be clearer
> 
> > For the former, maybe we still want a separate config item that's
> > optionally enabled if VIRTIO_VFIO_PCI && VFIO_PCI_ADMIN_LEGACY.  
> 
> If we are going to add a bunch of  #ifdefs/etc for ADMIN_LEGACY we
> may as well just use VIRTIO_PCI_ADMIN_LEGACY directly and not
> introduce another kconfig for it?

I think that's what Yishai is proposing, but as we're adding a whole
new feature to the driver I'm concerned how the person configuring the
kernel knows which features from the description might be available in
the resulting driver.

We could maybe solve that with a completely re-written help text that
describes the legacy feature as X86-only and migration as a separate
architecture independent feature, but people aren't great at reading
and part of the audience is going to see "X86" in their peripheral
vision and disable it, and maybe even complain that the text was
presented to them.

OR, we can just add an optional sub-config bool that makes it easier to
describe the (new) main feature of the driver as supporting live
migration (on supported hardware) and the sub-config option as
providing legacy support (on supported hardware), and that sub-config
is only presented on X86, ie. ADMIN_LEGACY.

Ultimately the code already needs to support #ifdefs for the latter and
I think it's more user friendly and versatile to have the separate
config option.

NB. The sub-config should be default on for upgrade compatibility.

> Is there any reason to compile out the migration support for virtio?
> No other drivers were doing this?

No other vfio-pci variant driver provides multiple, independent
features, so for instance to compile out migration support from the
vfio-pci-mlx5 driver is to simply disable the driver altogether.

> kconfig combinations are painful, it woudl be nice to not make too
> many..

I'm not arguing for a legacy-only, non-migration version (please speak
up if someone wants that).  The code already needs to support the
#ifdefs and I think reflecting that in a sub-config option helps
clarify what the driver is providing and conveniently makes it possible
to have a driver with exactly the same feature set across archs, if
desired.  Thanks,

Alex


