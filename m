Return-Path: <kvm+bounces-35312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 338FDA0BFB5
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 19:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45C391688D5
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 18:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04291C07ED;
	Mon, 13 Jan 2025 18:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ad4fAZxT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC511953BB
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736792547; cv=none; b=Ie9+11O45eI3HQwASEgh5c83W0Ub50MrmtOZ1KgGQ4CURaZLPhgG+6qZsyaqoWec/1Rdv0Jxv5umYkYPKOL2tJ9R10j9zzh2Wz/Cm5DSlOC3BprxzH7AdTP+QIF79KW0Z0rb10EeyeH66U9whE8vEWcnmj20dIGXmNEAD1/TvM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736792547; c=relaxed/simple;
	bh=mlJpaoZU5IHPNxKBSiT3wFA46twmtC/vSL/aXDBzDtw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oTyjyRPEHHIWLTOrznWBLonXY7OVT9wRPvahCpejMmbCm428k3zOTAmX9jw+XGc2GWnc3AMmOX3jnCe9w2QnC15ihRe/jWeIFjowcYYx1a6b9haV9MNlW6pWP74b/pZgb2JetIxDNYHOtPFZNg8oj99Fd6AfwQV4WvnPK81/46c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ad4fAZxT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736792544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kpQjFN8DHH3vTIh1N54T9tC0U6NEMf1EWuNsFTx1vug=;
	b=ad4fAZxT4ez9PnhiG//uMMdDgHmTls54dI5RuJXEstgzGCSqlDD93JhbQnixA0XCnJcy11
	Nbdv+YksLB0451St7IYZg/Y2k/hxvmtrIgSmvVmdwhMV9JGGJeG59/iMPVH6uI4OGYdwpw
	WI1x58T3PfON4OdzFk1d26sr7ikxB+o=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-FadkyuGUMtWPFbDBxgZ7jA-1; Mon, 13 Jan 2025 13:22:22 -0500
X-MC-Unique: FadkyuGUMtWPFbDBxgZ7jA-1
X-Mimecast-MFC-AGG-ID: FadkyuGUMtWPFbDBxgZ7jA
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-84990d44b31so23545539f.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 10:22:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736792542; x=1737397342;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kpQjFN8DHH3vTIh1N54T9tC0U6NEMf1EWuNsFTx1vug=;
        b=b4i5klcDZpJlqTvhsThOEu28XCA9UmBAf1xQ/GcFErujxU2mqSWNFUBDfqinqyrbPl
         /5egniCLj+vKlkp6rT4IIaXiWehowS7uh6yTvBBjKE8EjQVTIVAycfSEtQGW/ZQD/9Nd
         174qBNUwjG97Xhf0s0BPeTjOfIElJR72xqXGNQX9b+iu7+S/V0zSwzUJcyZ0ocYb5jx0
         TMEgMNO0yCBmpA1rEbJtCjLoEhxF/VOWAiM8GLISSObX/TQRSORdFmu9ShmzLtp+KiZt
         yQIrPbAx6MYvHc0GaGjZPViLPbUUoWXt/OiurxVgBvElBBoPxAH06ltsVtsiDHJOilUk
         I8Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWbmpQshIaawgNP0E0BrWNZEHsr/eHF/UNYGLpr3g+bo8h4ifC6SFGkoIj+7gXTMiz+BFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJo39Faa2ba6+yQQmXwP3Fd67SmB+CnP5sBa4GWkjwFOMK0faO
	WBNwaWxDt3F0Wi1qtJ53Ae/GAxImh6y+AY1FHtXgUcgNb8hV17jCSSd+6Dtm8hVbs2oUGIkBLLy
	GvUN3ZJ611NgB5WYLG1dNFwttNxlMIPNCaZPHT1xYqd7xOXhtmQ==
X-Gm-Gg: ASbGnct8Tenlpb2oRPACdTRtg2TZLL9MVevNT2wwitOyvB3Rk/0Nbd1WUC1U8UoWucu
	ken3srmMoSFkk9nqaQ0QVny87MHCEcADCT+ZtbHGP+jSZ85D/loDq4E4v7XGq56DsBTn+8UyxP/
	07OKu2/MkNgY5OnGKaDUlgpojUgIPCbcJWS35JXS2dQwmqU+EzFhfuv2gh1goPvfIVDUP2vZebF
	aeL7fT81ABej9Px34oTfgExqXW8t2IpS2V+kUtuChuaWAXyTYh0OmzfBk2A
X-Received: by 2002:a05:6e02:20cf:b0:3a7:bc95:bae5 with SMTP id e9e14a558f8ab-3ce3a8f4251mr43530185ab.5.1736792542236;
        Mon, 13 Jan 2025 10:22:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGyH9wnFNqQ+n+mjGC8mmSv4B42nvMciCAmuDvhldkJxXrWuz7tfNZyGJ/5zifS7d05UYhzqg==
X-Received: by 2002:a05:6e02:20cf:b0:3a7:bc95:bae5 with SMTP id e9e14a558f8ab-3ce3a8f4251mr43530095ab.5.1736792541940;
        Mon, 13 Jan 2025 10:22:21 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b6143a6sm2834234173.60.2025.01.13.10.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 10:22:21 -0800 (PST)
Date: Mon, 13 Jan 2025 13:22:08 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Mitchell Augustin <mitchell.augustin@canonical.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, Bjorn Helgaas
 <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM
 boot with passthrough of large BAR Nvidia GPUs on DGX H100
Message-ID: <20250113132208.118f6bfc.alex.williamson@redhat.com>
In-Reply-To: <CAHTA-uZtRzFOuo7vZCjoLF3_n0CCy3+0U0r_deB3jFF0cPivnw@mail.gmail.com>
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
	<CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
	<20241126154145.638dba46.alex.williamson@redhat.com>
	<CAHTA-uZp-bk5HeE7uhsR1frtj9dU+HrXxFZTAVeAwFhPen87wA@mail.gmail.com>
	<20241126170214.5717003f.alex.williamson@redhat.com>
	<CAHTA-uY3pyDLH9-hy1RjOqrRR+OU=Ko6hJ4xWmMTyoLwHhgTOQ@mail.gmail.com>
	<20241127102243.57cddb78.alex.williamson@redhat.com>
	<CAHTA-uaGZkQ6rEMcRq6JiZn8v9nZPn80NyucuSTEXuPfy+0ccw@mail.gmail.com>
	<20241203122023.21171712.alex.williamson@redhat.com>
	<CAHTA-uZWGmoLr0R4L608xzvBAxnr7zQPMDbX0U4MTfN3BAsfTQ@mail.gmail.com>
	<20241203150620.15431c5c.alex.williamson@redhat.com>
	<CAHTA-uZD5_TAZQkxdJRt48T=aPNAKg+x1tgpadv8aDbX5f14vA@mail.gmail.com>
	<20241203163045.3e068562.alex.williamson@redhat.com>
	<CAHTA-ua5g2ygX_1T=YV7Nf1pRzO8TuqS==CCEpK51Gez9Q5woA@mail.gmail.com>
	<CAHTA-uZtRzFOuo7vZCjoLF3_n0CCy3+0U0r_deB3jFF0cPivnw@mail.gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 8 Jan 2025 17:06:18 -0600
Mitchell Augustin <mitchell.augustin@canonical.com> wrote:

> Hi Alex,
> 
> While waiting for
> https://lore.kernel.org/all/20241218224258.2225210-1-mitchell.augustin@canonical.com/
> to be reviewed, I was thinking more about the slowness of
> pci_write_config_<size>() itself in my use case.
> 
> You mentioned this earlier in the thread:
> 
> > It doesn't take into account that toggling the command register bit is not a trivial operation in a virtualized environment.  
> 
> The thing that I don't understand about this is why the speed for this
> toggle (an individual pci_write_config_*() call) would be different
> for one passed-through GPU than for another. On one of my other
> machines with a different GPU, I didn't see any PCI config register
> write slowness during boot with passthrough. Notably, that other GPU
> does have much less VRAM (and is not an Nvidia GPU). While scaling
> issues due to larger GPU memory space would make sense to me if the
> slowdown was in some function whose number of operations was bound by
> device memory, it is unclear to me if that is relevant here, since as
> far as I can tell, no such relationship exists in pci_write_config_*()
> itself since it is just writing a single value to a single
> configuration register regardless of the underlying platform. (It
> appears entirely atomic, and only bound by how long it takes to
> acquire the lock around the register.)  All I can hypothesize is that
> maybe that lock acquisition needs to wait for some
> hardware-implemented operation whose runtime is bound by memory size,
> but that is just my best guess.
> 
> Is there anything you can think of that is triggered by the
> pci_write_config_*() alone that you think might cause device-dependent
> behavior here, or is this likely something that I will just need to
> raise with Nvidia?

The slowness is proportional to the size of the device MMIO address
space.  In QEMU, follow the path of pci_default_write_config().  It's
not simply the config space write, but the fact that the config space
write needs to populate the device memory into the guest address space.
On memory_region_transaction_commit() affected memory listeners are
called, for vfio this is vfio_listener_region_add().  At this point the
device MMIO space is being added to the system_memory address space.
Without a vIOMMU, devices also operate in this same address space,
therefore the MMIO regions of the device need to be DMA mapped through
the IOMMU.  This is where I expect we have the bulk of the overhead as
we iterate the pfnmaps and insert the IOMMU page tables.

Potentially the huge pfnmap support that we've introduced in v6.12 can
help us here if we're faulting the mappings on PUD or PMD levels, then
we should be able to insert the same size mappings into the IOMMU.  I'm
hoping we can begin to make such optimizations now.  Thanks,

Alex


