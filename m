Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE761DA66F
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 02:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgETAXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 20:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgETAXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 20:23:54 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFD3C061A0F
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:23:54 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id c24so1242438qtw.7
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=avb7NmnU6F4GXp6QDpPuRKwMmbteUvDOYc+XSVXqfUg=;
        b=kUtg3k2Zk95pFNovjaNi3ts8Qr+uwvcFUkE4sdylDXM33QYzBULVaVS3rmhxpfLtfk
         yC12+xL5xWf7bVa8jD//ax9zMq91kSB4rIzgAA++JH4QRpODcHDNjQMKo7XPKZLuZlLr
         cOEYSba8cfExQzYwoLS76FxudzdRbNw4DxUY9IkwwOF7911DNLU1T0dfUR0UDtELbOYf
         o46YiUV/EzJNMcJP12tuKXUht6ujvjE5pkW2TepOIGMpyPdu/Eyii9ufdXXbnS/ZUvwB
         vANvduTKv6Tui7gPvAWKOeVMJBtvFQGWJRb4Co8i0gfinFf5SF/38/E/xQ6tJJxbm6Wp
         mz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=avb7NmnU6F4GXp6QDpPuRKwMmbteUvDOYc+XSVXqfUg=;
        b=rWklf4wsw50/qbwUZd+wypoRMMae9Ou6y19jER84V4bx04zSTSZ4Thoh4sDu8k9kYf
         IyJNXed4fo58V4Degyv2SctDicuXiKAxRLx+N2wVw2saW2WYxx+1oSXAzcMUnSR1Vzou
         nxQOBWf3LIZKRKL7etnvHrNwkBLE7I2vTEKl53iJFPtPKZ2mvVUEtgSrpQ9jzklAWjZH
         nfrUiwfMcuKvsd94fncKAYsNqZj5S4qtIP57PBv4NT33NnIyDrZ5H7+ds5Kl1bYrbsha
         bRqS6ooADqixOyk1cjraqnims1rOS6dTKoH+mPSrxS6sqWMvwE+A9rDcYrSGMW8mY+2b
         mZ3w==
X-Gm-Message-State: AOAM530qXTklTBWb6oOXgGV6gTwubIfSDv6Sr592PFuZwkpKaFScV4NY
        NCeVhzJmOQuPAvrGhLjtJ0J+HA==
X-Google-Smtp-Source: ABdhPJy6IHAu3n3yAVDLVyq8guI0aN6TF9jJX1XyB5KexvvvBJbQ+dAuvWUo+JtKMNWs0QHnac7S8A==
X-Received: by 2002:aed:23d2:: with SMTP id k18mr2816662qtc.224.1589934233409;
        Tue, 19 May 2020 17:23:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id g1sm1030282qkm.123.2020.05.19.17.23.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 17:23:53 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbCWW-0003V1-K6; Tue, 19 May 2020 21:23:52 -0300
Date:   Tue, 19 May 2020 21:23:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 0/2] vfio/type1/pci: IOMMU PFNMAP invalidation
Message-ID: <20200520002352.GD31189@ziepe.ca>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158947414729.12590.4345248265094886807.stgit@gimli.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 10:51:46AM -0600, Alex Williamson wrote:
> This is a follow-on series to "vfio-pci: Block user access to disabled
> device MMIO"[1], which extends user access blocking of disabled MMIO
> ranges to include unmapping the ranges from the IOMMU.  The first patch
> adds an invalidation callback path, allowing vfio bus drivers to signal
> the IOMMU backend to unmap ranges with vma level granularity.  This
> signaling is done both when the MMIO range becomes inaccessible due to
> memory disabling, as well as when a vma is closed, making up for the
> lack of tracking or pinning for non-page backed vmas.  The second
> patch adds registration and testing interfaces such that the IOMMU
> backend driver can test whether a given PFNMAP vma is provided by a
> vfio bus driver supporting invalidation.  We can then implement more
> restricted semantics to only allow PFNMAP DMA mappings when we have
> such support, which becomes the new default.
> 
> Jason, if you'd like Suggested-by credit for the ideas here I'd be
> glad to add it.  Thanks,

Certainly a Reported-by would be OK

The only thing I don't like here is this makes some P2P DMA mapping
scheme for VMAs with invalidation that is completely private to vfio.

Many of us want this in other subsystems, and there are legimiate uses
for vfio to import BAR memory for P2P from other places than itself.

So I would really rather this be supported by the core kernel in some
way.

That said, this is a bug fix, and we still don't have much agreement
on what the core kernel version should look like, let alone how it
should work with an IOMMU. 

So maybe this goes ahead as is and we can figure out how to replace it
with something general later on?

Jason
