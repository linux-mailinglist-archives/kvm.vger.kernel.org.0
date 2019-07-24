Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDE574136
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 00:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfGXWD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 18:03:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:50964 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbfGXWD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 18:03:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 15:03:56 -0700
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="scan'208";a="175019406"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 15:03:56 -0700
Message-ID: <ada4e7d932ebd436d00c46e8de699212e72fd989.camel@linux.intel.com>
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
Date:   Wed, 24 Jul 2019 15:03:56 -0700
In-Reply-To: <20190724173403-mutt-send-email-mst@kernel.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
         <20190724171050.7888.62199.stgit@localhost.localdomain>
         <20190724173403-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-07-24 at 17:38 -0400, Michael S. Tsirkin wrote:
> On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Add support for what I am referring to as "bubble hinting". Basically the
> > idea is to function very similar to how the balloon works in that we
> > basically end up madvising the page as not being used. However we don't
> > really need to bother with any deflate type logic since the page will be
> > faulted back into the guest when it is read or written to.
> > 
> > This is meant to be a simplification of the existing balloon interface
> > to use for providing hints to what memory needs to be freed. I am assuming
> > this is safe to do as the deflate logic does not actually appear to do very
> > much other than tracking what subpages have been released and which ones
> > haven't.
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> BTW I wonder about migration here.  When we migrate we lose all hints
> right?  Well destination could be smarter, detect that page is full of
> 0s and just map a zero page. Then we don't need a hint as such - but I
> don't think it's done like that ATM.

I was wondering about that a bit myself. If you migrate with a balloon
active what currently happens with the pages in the balloon? Do you
actually migrate them, or do you ignore them and just assume a zero page?
I'm just reusing the ram_block_discard_range logic that was being used for
the balloon inflation so I would assume the behavior would be the same.

> I also wonder about interaction with deflate.  ATM deflate will add
> pages to the free list, then balloon will come right back and report
> them as free.

I don't know how likely it is that somebody who is getting the free page
reporting is likely to want to also use the balloon to take up memory.
However hinting on a page that came out of deflate might make sense when
you consider that the balloon operates on 4K pages and the hints are on 2M
pages. You are likely going to lose track of it all anyway as you have to
work to merge the 4K pages up to the higher order page.

