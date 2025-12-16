Return-Path: <kvm+bounces-66089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1C0CC50C6
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 20:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C46A63040A71
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 19:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4115B336ED1;
	Tue, 16 Dec 2025 19:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MrBzeP/n";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XPf+GToY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B9C30FF1E
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765915098; cv=none; b=h1Y3ofuucD9374E3HatC3hSjbC23eicWgm31R3feZvKtBw89byc0+OAESRII5kmT304X0JU/bl3hgdYJFc/6SAgVRlRt0DGg12bvyPKlJNlQlYjU0snSxkX6hjYSxKj6ip95FEW9nZshxnSsGmX+OkOsfoFMitlviHW1BFv9u94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765915098; c=relaxed/simple;
	bh=aiS+VBXGWERVPlAx9SX3K5F+LrZjCmiJAM0YrLhOYYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twdIxY+whI4PEmcpsu8TbYBaEtN9dlARP7kK4qPVRNcWOoINoSxzQn/vQRJs284UPqlZHH3XhmpkdxtIrDZ8pTNvG59IZWmf80FNvj9Xbr914mq+0AvyHoOzvQWymYYkul7Z02soMB3Bp3qkGsj/leq+B88PB3uxoC3Ygl58w4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MrBzeP/n; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XPf+GToY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765915095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WILoW472mfGqus7f3vqpilqOzoz0h+z/dztTyHfCBuA=;
	b=MrBzeP/nhFY+eCzBU6K/by5rK/s4oY4EsSKSceHHcILXYeXzUghWObcCKoPJF8EnyZp0f/
	bB4h6VsGQc4lxbKRKNEg1mX+Oynkuuc4vsD0J6c6OKI6A3QRUJsmIlgkpq1pWkb5jKnd0y
	Y56BtPO+2h5D8kZ/dE/q6uvWExcivUE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-V7zDj9vmP-mO3YaX3wJKtw-1; Tue, 16 Dec 2025 14:58:14 -0500
X-MC-Unique: V7zDj9vmP-mO3YaX3wJKtw-1
X-Mimecast-MFC-AGG-ID: V7zDj9vmP-mO3YaX3wJKtw_1765915093
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29efd658fadso143679815ad.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 11:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765915093; x=1766519893; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WILoW472mfGqus7f3vqpilqOzoz0h+z/dztTyHfCBuA=;
        b=XPf+GToYNaVuW7gaQMoVikJ3kWDT/bxOkcOkPbvijWCAPrhKJH8tVYD7WG1+b3Y4Aj
         NmPzsb0NSjk3wDnaoUy1oN/vUadNOuePACfN49IRDdjEMpel1f84jRhU1PwGQPx602yr
         MQMxHFRV7uwln6Y99cGALnzUCtw7zLRc/0/9W68M+UKpXi9hwMKU/nFmXmT2GZJ1soew
         UQLOq3c60cvJl5NBzObww47YAJowVwc52/smnlaDBirCNbpVz45iY16Uewa7tHTxuA66
         BkfVXd2P5Qtm6xrn208rv45ydwBnAIH/ZgF8dxmA8jQ1doEsggv1s6MNAohDbug/XdR1
         NWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915093; x=1766519893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WILoW472mfGqus7f3vqpilqOzoz0h+z/dztTyHfCBuA=;
        b=mhL2rJVIl+Qv/EHIMQaFyo/GyS2VQHL0Kwf3RCDHIpjV4OnSCjak/EKCdAsmFOuolX
         mmZngvpV/IjpeoFYMHbwHCKjSg4dhlCALntAPEmCtcXpy8eUclJyxiKHkxm54D8VJ65a
         bPDevn16hfe0f35ORdn+WoLpLLyPJGX7e17SNytIxHKljGRk50hS0BNftjZrwic2bcFN
         v+ffuK2ke4KMqaROxuVTsPuYb1il2xnT+XDqUtTd483tI6oFPdKKk2dRLVdUAodXNPaW
         XTGd/ZR6JA0a3lZL9T+0XDwk/I16CkvNNqYdNug2LtUSJgQnMhbgxnVexdYR0ngSQ2Y8
         v77Q==
X-Gm-Message-State: AOJu0Yxb2VcrTEWRmHv4Foe6iveVg7vMw3JYA6z2Vh1iEd3a5KQnaLF2
	0SQWxNSQah20UfOUMp4kWimeF39m0/Saj7kUlVrA5qMhOkk761/EyBpVNyQ0RyOx760WNlPCnDi
	9Raf1em93xD5LZVeNxXvAisQjVE97fe+6nXB1UfxvVjl3Shl1Soh8Bg==
X-Gm-Gg: AY/fxX7MjIYibPtZU1KqpkUZ1O615WFjM9Cp/sjUar3DGIBik3iBDnhr+zbqBmqYk0j
	noXIsXwr4eXyzg2sNGBsYtWJyXITYlYmiln3FqmoiEnzOm+NoURCEiYiUU4alRAsrdGqGQYxwUQ
	oVqQYgqzgqi3t1K321UYj4/AzfKBA+M0ruaQBNOpyhJu72pDmlpNPLn25UPxYZmA736QgPz895g
	GTpzwc0w/Vnb/7F0e3iWaiMppNgxbegxKJ0v4j5H0MJNAdWpqq67FbAHhwEoOP+9WcfJS97FQru
	nafSOpixgYQQFzjR7kCvsBsQbTT3urXkF7xnK6U4THWVRcs/H5w+XYYiW4i2w2/9AKTER5BgtG6
	pI0k=
X-Received: by 2002:a17:903:3bad:b0:297:d45b:6d97 with SMTP id d9443c01a7336-29f23e3618emr164955905ad.14.1765915093043;
        Tue, 16 Dec 2025 11:58:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHr2X5JE1VeyIh1e5EanKDeX9YYmMdGAHNX6spNNWVf22t0T9F/mXgE3FmtoXHqzC5TX7vXhg==
X-Received: by 2002:a17:903:3bad:b0:297:d45b:6d97 with SMTP id d9443c01a7336-29f23e3618emr164955555ad.14.1765915092528;
        Tue, 16 Dec 2025 11:58:12 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a094398ed0sm110452725ad.27.2025.12.16.11.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 11:58:11 -0800 (PST)
Date: Tue, 16 Dec 2025 14:58:03 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aUG5y60q03RedLwv@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
 <aTnbf_dtwOo_gaVM@x1.local>
 <20251216144224.GE6079@nvidia.com>
 <aUGCPN2ngvWMG2Ta@x1.local>
 <20251216190131.GI6079@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251216190131.GI6079@nvidia.com>

On Tue, Dec 16, 2025 at 03:01:31PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 11:01:00AM -0500, Peter Xu wrote:
> > Do we have any function that we can fetch the best mapping lower than a
> > specific order?
> 
> I'm not aware of anything

Maybe I can introduce a per-arch helper for it, then.  I'll see if I can
cover some tests from ARM side, or I'll enable x86_64 first so we can do it
in two steps.

> 
> > > None of this logic should be in drivers.
> > 
> > I still think it's the driver's decision to have its own macro controlling
> > the huge pfnmap behavior.  I agree with you core mm can have it, I don't
> > see it blocks the driver not returning huge order if huge pfnmap is turned
> > off.  VFIO-PCI currently indeed only depends directly on global THP
> > configs, but I don't see why it's strictly needed.  So I think it's fine if
> > a driver (even if global THP enabled for pmd/pud) deselect huge pfnmap for
> > other reasons, then here the order returned can still always be PSIZE for
> > the driver.  It's really not a huge deal to me.
> 
> All these APIs should be around the idea that the driver just returns
> what it has and the core mm places it into ptes. There is not a good
> reason drivers should be overriding this logic or doing their own
> thing.

I'll make sure the driver will not need to consider size of mapping that
arch would support.

> 
> > > Drivers shouldn't implement this alignment function without also
> > > implementing huge fault, it is pointless. Don't see a reason to add
> > > extra complexity.
> > 
> > It's not implementing the order hint without huge fault.  It's when both
> > are turned off in a kernel config.. then the order hint (even from driver
> > POV) shouldn't need to be reported.
> 
> No, it should still all be the same the core code just won't call the
> function.
> 
> > I don't know why you have so strong feeling on having a config check in
> > vfio-pci drivers is bad.
> 
> It is leaking MM details into drivers that should not be in drivers.

To me it still makes perfect sense here to pair with huge_fault(), and it's
driver knowledge alone.  It has nothing to do with leaking mm details.

I think I get your point above, maybe when the core mm fallback paths not
available yet we can mix things together. I'll see what I can do when
repost.

-- 
Peter Xu


