Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E031746CB
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 08:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfGYGHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 02:07:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33578 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfGYGHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 02:07:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id r6so43751965qtt.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 23:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PypuxeYUycvP8/id8ByTKjToCiSzfpYpICZWRirx1lg=;
        b=Inf994FgvzxeWhuqQ420cHhY+fUfc/T7LQhei/kGpencukdh4VF442ywyTqTpvN5tc
         nZy93EZ47nM7Lt38SGm8KqG7hbFstFgIl20R4DIY7ztN87BBqyNo3LYg8Ha8re6pTGAU
         VehkqB97JSItqFlovqXxXmlT/lmNwsgVZXv7fqsFSlUTQs6BrGaSYOzfXvgQhhlpFcj4
         kPWgfTzacK2kXPUrr5T5tR8+hNABGvgfANa+Ym9VZpNn43X6BjoQml6NBGJB9w5lJaV2
         8/X0osOVRV0hh+5R/jRyYQMybGOLhRhj1HAcXmox8aI1pr2AAq1KfSd+ys1iAZ4nc/RQ
         C8jQ==
X-Gm-Message-State: APjAAAWbHh+zTYSvkKcT5tVhhGVjOL1Zv7gewAa0V8qCObSMTBikRzhp
        LOh2m/z/u2lvtk3B5SmgQJJrPQ==
X-Google-Smtp-Source: APXvYqwDG4zJA9IYJPz7Qr+XKlkzlftA6U4LgG7wMuKSilowIIArQBRTAM0ujQelE37C7kSAHEerpQ==
X-Received: by 2002:ac8:c45:: with SMTP id l5mr58170164qti.63.1564034841780;
        Wed, 24 Jul 2019 23:07:21 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id k38sm27828576qtk.10.2019.07.24.23.07.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 23:07:20 -0700 (PDT)
Date:   Thu, 25 Jul 2019 02:07:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
Message-ID: <20190725020425-mutt-send-email-mst@kernel.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724171050.7888.62199.stgit@localhost.localdomain>
 <20190724173403-mutt-send-email-mst@kernel.org>
 <ada4e7d932ebd436d00c46e8de699212e72fd989.camel@linux.intel.com>
 <20190724180552-mutt-send-email-mst@kernel.org>
 <6bbead1f2d7b3aa77a8e78ffc6bbbb6d0d68c12e.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bbead1f2d7b3aa77a8e78ffc6bbbb6d0d68c12e.camel@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 03:27:37PM -0700, Alexander Duyck wrote:
> On Wed, 2019-07-24 at 18:08 -0400, Michael S. Tsirkin wrote:
> > On Wed, Jul 24, 2019 at 03:03:56PM -0700, Alexander Duyck wrote:
> > > On Wed, 2019-07-24 at 17:38 -0400, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> > > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > > 
> > > > > Add support for what I am referring to as "bubble hinting". Basically the
> > > > > idea is to function very similar to how the balloon works in that we
> > > > > basically end up madvising the page as not being used. However we don't
> > > > > really need to bother with any deflate type logic since the page will be
> > > > > faulted back into the guest when it is read or written to.
> > > > > 
> > > > > This is meant to be a simplification of the existing balloon interface
> > > > > to use for providing hints to what memory needs to be freed. I am assuming
> > > > > this is safe to do as the deflate logic does not actually appear to do very
> > > > > much other than tracking what subpages have been released and which ones
> > > > > haven't.
> > > > > 
> > > > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > 
> > > > BTW I wonder about migration here.  When we migrate we lose all hints
> > > > right?  Well destination could be smarter, detect that page is full of
> > > > 0s and just map a zero page. Then we don't need a hint as such - but I
> > > > don't think it's done like that ATM.
> > > 
> > > I was wondering about that a bit myself. If you migrate with a balloon
> > > active what currently happens with the pages in the balloon? Do you
> > > actually migrate them, or do you ignore them and just assume a zero page?
> > 
> > Ignore and assume zero page.
> > 
> > > I'm just reusing the ram_block_discard_range logic that was being used for
> > > the balloon inflation so I would assume the behavior would be the same.
> > > 
> > > > I also wonder about interaction with deflate.  ATM deflate will add
> > > > pages to the free list, then balloon will come right back and report
> > > > them as free.
> > > 
> > > I don't know how likely it is that somebody who is getting the free page
> > > reporting is likely to want to also use the balloon to take up memory.
> > 
> > Why not?
> 
> The two functions are essentially doing the same thing. The only real
> difference is enforcement. If the balloon takes the pages the guest cannot
> get them back. I suppose there might be some advantage if you are wanting
> for force shrink a guest but that would be about it.

Yea, that's a common use of the balloon ATM. Helps partition
the host so guests don't conflict. OTOH deflate on oom thing
probably will never be used with hinting.

> > > However hinting on a page that came out of deflate might make sense when
> > > you consider that the balloon operates on 4K pages and the hints are on 2M
> > > pages. You are likely going to lose track of it all anyway as you have to
> > > work to merge the 4K pages up to the higher order page.
> > 
> > Right - we need to fix inflate/deflate anyway.
> > When we do, we can do whatever :)
> 
> One thing we could probably look at for the future would be to more
> closely merge the balloon and this reporting logic. Ideally the balloon
> would grab pages that were already hinted in order to enforce a certain
> size limit on the guest, and then when it gave the pages back they would
> retain their hinted status if possible.
> 
> The only problem is that right now both of those require that
> hinting/reporting be active for the zone being accessed since we otherwise
> don't have pointers to the pages at the head of the "hinted" list.

I guess I was talking about reworking host/guest ABI, you were
talking about the internals. So both need to change :)
