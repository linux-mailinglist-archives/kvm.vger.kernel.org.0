Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD8B3E833E
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 20:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhHJSuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 14:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhHJSuL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 14:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628621389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sIY2+IC7WL45hNaXWA0mNkNCzPB+K2jEa8Wry58PE/U=;
        b=CP0AG/TDukuYVBQI6nIBz4MAxe5Z7vGZDaLqpKuYdW+sD5J1wt47tk2poev3avU8KwNWpI
        p5i8IPbS0ZGsZbdrd5JNQSNNE3WKqK/uDamHwLiXYcAm6KbbR6A3y0aUb515d9QKMkhDqm
        nrgTLOH+FEU/N/dc03K3k3bBxkSzuCQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-NQAMlOC2NIm6IbliN_kqKQ-1; Tue, 10 Aug 2021 14:49:48 -0400
X-MC-Unique: NQAMlOC2NIm6IbliN_kqKQ-1
Received: by mail-qv1-f69.google.com with SMTP id t9-20020a0562140c69b029033e8884d712so17486392qvj.18
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 11:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sIY2+IC7WL45hNaXWA0mNkNCzPB+K2jEa8Wry58PE/U=;
        b=ORhm2hbyBxqCD7CMR8mcZT/SwORbkisa7r0LOssmpb7Fbwz7Y5PXoN9JPEY2XRylQX
         gU/o4XUSWFSyKl3BGqjYqqCXkyPQq+dOurz+ShN2cIxkfXmyiqmoAKXhhfrtltIrMWTX
         VkbsJNtdJD1u8GhJ8T7gXEoe9aH44aROXUppRVWk8poyc6Yo1ARdJzgfW9LWYkDUKfvw
         zOuyV+J8aJpjsokztxrXVq5PYVqHOjMIvXGsoljBo4ROFSZ22LeHctZ8n1Y9s6RCTH8o
         R7Vl3fDMsJT2euO6Rf3hLKtUght8vWW6oe9PaeONn4jY1zD4EeDtTiNMJ1o1s3V9WBEu
         UdLA==
X-Gm-Message-State: AOAM5303hF6pan8Opv6b32CzM7YS/c4mCWuCC5KiIZjb/2Qti4anPAb+
        GaPNhmCDR7AnlQNmFUYs7Dw5iHTxqRN+vFzT5LpNZaOnjCvs6e/AHDnaZwX54HZRYcDc2agabpv
        cy6Q7uCRcSJ3O
X-Received: by 2002:a05:620a:4495:: with SMTP id x21mr29960407qkp.468.1628621387550;
        Tue, 10 Aug 2021 11:49:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQvFRashIBFVzGhqhv5sdxbxzhHektVx1wjA60NW0CdiaAdHl2bwdx2KS9QwBp6XM60FSi5Q==
X-Received: by 2002:a05:620a:4495:: with SMTP id x21mr29960386qkp.468.1628621387352;
        Tue, 10 Aug 2021 11:49:47 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id c68sm11756909qkf.48.2021.08.10.11.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 11:49:46 -0700 (PDT)
Date:   Tue, 10 Aug 2021 14:49:45 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] vfio: Create vfio_fs_type with inode per device
Message-ID: <YRLKSYQL8VvTr3gc@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818322947.1511194.6035266132085405252.stgit@omen>
 <YRI8Mev5yfeAXsrj@infradead.org>
 <20210810085254.51da01d6.alex.williamson@redhat.com>
 <YRKT2UhgjfWBmwuJ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YRKT2UhgjfWBmwuJ@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 03:57:29PM +0100, Christoph Hellwig wrote:
> On Tue, Aug 10, 2021 at 08:52:54AM -0600, Alex Williamson wrote:
> > On Tue, 10 Aug 2021 10:43:29 +0200
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > > + * XXX Adopt the following when available:
> > > > + * https://lore.kernel.org/lkml/20210309155348.974875-1-hch@lst.de/  
> > > 
> > > No need for this link.
> > 
> > Is that effort dead?  I've used the link several times myself to search
> > for progress, so it's been useful to me.  Thanks,
> 
> No, but it seems odd to have reference to an old patchset in the kernel
> tree.

I learn from the reference too.  Maybe move into commit message?  Thanks,

-- 
Peter Xu

