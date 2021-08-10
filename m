Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7923E8602
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 00:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhHJWTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 18:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234859AbhHJWS7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 18:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628633916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7YZY4Fy0S693Kga/zgn3elAZcDC5WxrNoe2T+rwZApE=;
        b=gMQzqyGRz/puTvjpyiEvqfajWHHm/QDNScN7pjRNvbGcF5GD0iaqXrXYswv8+Dfh1wQswg
        023zCLvi7TSDw+FB25PUyyAnO5lOax5DjHcja1nm754KNo0y+/xvIPukWotukmY9j2fgMv
        EuV3uSZkuvVMUZkb5h/tXKPeiuNsk78=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-G2qIm_uQMTGOc9bUyMF41A-1; Tue, 10 Aug 2021 18:18:35 -0400
X-MC-Unique: G2qIm_uQMTGOc9bUyMF41A-1
Received: by mail-qt1-f200.google.com with SMTP id j1-20020ac866410000b029028bef7ed9e1so252685qtp.11
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7YZY4Fy0S693Kga/zgn3elAZcDC5WxrNoe2T+rwZApE=;
        b=Pe4TqnLJOHWH9lBjmFKhzcFqmzP0g9DecUwXKtX8Jj+1UI22bYZ7M7DufQzID13EMd
         PuY19XeKtIVpEMUNnGy+fWbRmvMlaXp/iG8XFB61SxslPsweYVQQb0pjPLeF0H7w9jA6
         ZMopnc003mb5qq0hkVJV4dl+JKXG8MsYBqJLtx7e8MFjefCiUAx4VUtrYMhTS2K2dkZh
         gN2Cq8HoYfTETqBd2FqNTwrWEMkn2+zmmGPj5Oi5PBwYQQ2aDHlIEdfdTO2iApTkHX33
         AkWCXLqtehbu8iD649md3IQr1b9W/4ruSF2CxwxE+mbEJ4k8hFm0uqgf5FS2pOBj9F6Y
         1VyQ==
X-Gm-Message-State: AOAM532MMHffj8VT7KrspeRCoyjfOaynQTeAExwgs2y6SMV/6vTG/lSP
        KegdSUjEirOx+9F55fT6Nv474G0OuYUav/aeUw4Off0nHJZqDx8aLn6z/KvibGuaUkiZPE+lseL
        zN+L/hbN0Hkb1
X-Received: by 2002:a37:b544:: with SMTP id e65mr31249877qkf.84.1628633915140;
        Tue, 10 Aug 2021 15:18:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwe+BlgB4A1XuAQgShSQ1NiAMJQshbqb1mytM+jP2Rk2LYjiR4/4P9XpXXA95IcNLHVb/a1fw==
X-Received: by 2002:a37:b544:: with SMTP id e65mr31249859qkf.84.1628633914928;
        Tue, 10 Aug 2021 15:18:34 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id a8sm10798674qkn.63.2021.08.10.15.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 15:18:34 -0700 (PDT)
Date:   Tue, 10 Aug 2021 18:18:33 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] vfio: Create vfio_fs_type with inode per device
Message-ID: <YRL7OdHv/CG+oUI6@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818322947.1511194.6035266132085405252.stgit@omen>
 <YRI8Mev5yfeAXsrj@infradead.org>
 <20210810085254.51da01d6.alex.williamson@redhat.com>
 <YRKT2UhgjfWBmwuJ@infradead.org>
 <YRLKSYQL8VvTr3gc@t490s>
 <20210810151614.39a6714f.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210810151614.39a6714f.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 03:16:14PM -0600, Alex Williamson wrote:
> On Tue, 10 Aug 2021 14:49:45 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> > On Tue, Aug 10, 2021 at 03:57:29PM +0100, Christoph Hellwig wrote:
> > > On Tue, Aug 10, 2021 at 08:52:54AM -0600, Alex Williamson wrote:  
> > > > On Tue, 10 Aug 2021 10:43:29 +0200
> > > > Christoph Hellwig <hch@infradead.org> wrote:
> > > >   
> > > > > > + * XXX Adopt the following when available:
> > > > > > + * https://lore.kernel.org/lkml/20210309155348.974875-1-hch@lst.de/    
> > > > > 
> > > > > No need for this link.  
> > > > 
> > > > Is that effort dead?  I've used the link several times myself to search
> > > > for progress, so it's been useful to me.  Thanks,  
> > > 
> > > No, but it seems odd to have reference to an old patchset in the kernel
> > > tree.  
> > 
> > I learn from the reference too.  Maybe move into commit message?  Thanks,
> 
> TBH, I'm ok if it's "odd" if it's useful.  Right here we have two
> instances of it being useful.  I don't think that two lines of comment
> is excessive and we can always remove it when we either make the
> conversion or give up on it.  Moving it to the commit log would just
> bury it to be pointless.
> 
> I don't have a more concise, current, or future-proof way to describe
> the todo item than this link (ok, ok, I could s/lkml/r/ for 3 less
> chars :-P).  Thanks,

Yep, fine by me - either by keeping it in the code, commit message, or in cover
letter, as it's still an useful reference before that series got merged. Thanks,

-- 
Peter Xu

