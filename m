Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC287413D
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 00:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfGXWIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 18:08:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34200 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfGXWIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 18:08:37 -0400
Received: by mail-qk1-f195.google.com with SMTP id t8so34978805qkt.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 15:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gF6WF5oKZcAh8lsxIGa4A4qCFkeXLAddUJBeCVn/yGw=;
        b=QznBS875JAey7lRtpEOG8K/bvhUTGZ/rvWKIhERYCTcfyILalul3xq95/Z2sX6Jbrq
         16GzBC2xXkYUNfPsZl1tsr/IrQqVFn9OhsXxY0ooPkn4uvdkQ/1/lHGyKQLHECdwcu4Y
         PwMY5NM0poa5a2QBsWePpGqsAP6/f+9P5IeLp7bqAEyznR6yT9ddKqvbMpAOz6sEDlFG
         dfv0T4Fuby46Qcyayh8mQVrJmudQ50xHqLD1xavKXHMQUN1q/BtaXkibSVoA0+wLCYQK
         O8GiYbg5OOdj1nBHwHXIW4DjsTHdJsa2AfuVFtPu2mxVcxj7vdDxym8pkP7IO+tvVyxF
         s7DA==
X-Gm-Message-State: APjAAAXiDo8IpCKxJwVIbXStfogSvkC2w15yop4fktFGvTPmJOKmA4Cj
        2dr4NMs2z0VOer9oOnOiBOkjfg==
X-Google-Smtp-Source: APXvYqxVJCQ2dlAvvn87eBVVAsdbP4o5lFQJIQ8dJsrhL7h4rGVMj3kyCjifB4jGqlYkUi6EmUay0w==
X-Received: by 2002:a37:4781:: with SMTP id u123mr51143171qka.263.1564006116973;
        Wed, 24 Jul 2019 15:08:36 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id i62sm22082669qke.52.2019.07.24.15.08.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 15:08:35 -0700 (PDT)
Date:   Wed, 24 Jul 2019 18:08:28 -0400
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
Message-ID: <20190724180552-mutt-send-email-mst@kernel.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724171050.7888.62199.stgit@localhost.localdomain>
 <20190724173403-mutt-send-email-mst@kernel.org>
 <ada4e7d932ebd436d00c46e8de699212e72fd989.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada4e7d932ebd436d00c46e8de699212e72fd989.camel@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 03:03:56PM -0700, Alexander Duyck wrote:
> On Wed, 2019-07-24 at 17:38 -0400, Michael S. Tsirkin wrote:
> > On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > 
> > > Add support for what I am referring to as "bubble hinting". Basically the
> > > idea is to function very similar to how the balloon works in that we
> > > basically end up madvising the page as not being used. However we don't
> > > really need to bother with any deflate type logic since the page will be
> > > faulted back into the guest when it is read or written to.
> > > 
> > > This is meant to be a simplification of the existing balloon interface
> > > to use for providing hints to what memory needs to be freed. I am assuming
> > > this is safe to do as the deflate logic does not actually appear to do very
> > > much other than tracking what subpages have been released and which ones
> > > haven't.
> > > 
> > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > BTW I wonder about migration here.  When we migrate we lose all hints
> > right?  Well destination could be smarter, detect that page is full of
> > 0s and just map a zero page. Then we don't need a hint as such - but I
> > don't think it's done like that ATM.
> 
> I was wondering about that a bit myself. If you migrate with a balloon
> active what currently happens with the pages in the balloon? Do you
> actually migrate them, or do you ignore them and just assume a zero page?

Ignore and assume zero page.

> I'm just reusing the ram_block_discard_range logic that was being used for
> the balloon inflation so I would assume the behavior would be the same.
> 
> > I also wonder about interaction with deflate.  ATM deflate will add
> > pages to the free list, then balloon will come right back and report
> > them as free.
> 
> I don't know how likely it is that somebody who is getting the free page
> reporting is likely to want to also use the balloon to take up memory.

Why not?

> However hinting on a page that came out of deflate might make sense when
> you consider that the balloon operates on 4K pages and the hints are on 2M
> pages. You are likely going to lose track of it all anyway as you have to
> work to merge the 4K pages up to the higher order page.

Right - we need to fix inflate/deflate anyway.
When we do, we can do whatever :)

-- 
MST
