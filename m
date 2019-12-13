Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEFC11E86C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfLMQfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:35:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:55846 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbfLMQfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 11:35:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 08:35:13 -0800
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="364346319"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 08:35:13 -0800
Message-ID: <de779bcc6ccae238dbdedcc61db88abbdb8f291e.camel@linux.intel.com>
Subject: Re: [PATCH v15 6/7] virtio-balloon: Add support for providing free
 page reports to host
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        konrad.wilk@oracle.com, david@redhat.com, pagupta@redhat.com,
        riel@surriel.com, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de
Date:   Fri, 13 Dec 2019 08:35:13 -0800
In-Reply-To: <20191213020553-mutt-send-email-mst@kernel.org>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162255.19548.63866.stgit@localhost.localdomain>
         <20191213020553-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-12-13 at 02:08 -0500, Michael S. Tsirkin wrote:
> On Thu, Dec 05, 2019 at 08:22:55AM -0800, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Add support for the page reporting feature provided by virtio-balloon.
> > Reporting differs from the regular balloon functionality in that is is
> > much less durable than a standard memory balloon. Instead of creating a
> > list of pages that cannot be accessed the pages are only inaccessible
> > while they are being indicated to the virtio interface. Once the
> > interface has acknowledged them they are placed back into their respective
> > free lists and are once again accessible by the guest system.
> > 
> > Unlike a standard balloon we don't inflate and deflate the pages. Instead
> > we perform the reporting, and once the reporting is completed it is
> > assumed that the page has been dropped from the guest and will be faulted
> > back in the next time the page is accessed.
> > 
> > For this reason when I had originally introduced the patch set I referred
> > to this behavior as a "bubble" instead of a "balloon" since the duration
> > is short lived, and when the page is touched the "bubble" is popped and
> > the page is faulted back in.
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> virtio POV is fine here:
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> However please copy virtio-comment on UAPI changes.

So I have been avoiding copying virtio-dev on the kernel changes as I had
gotten feedback that it was annoying some people as they were getting
bounces since they were not subscribed. Will the same type of thing happen
with virtio-comment?

> If possible isolate the last chunk in a patch by itself
> to make it easier for non-kernel developers to review.

Are you talking about the change in "include/uapi/linux/virtio_balloon.h"?

I have it as a standalone patch in the QEMU set, and for the QEMU set I
had included virtio-dev. Would you prefer I include virtio-comment instead
or in addition to virtio-dev? My thought is that I would prefer to keep
the virtio people focused on the QEMU code since they are probably more
comfortable with that, and the kernel people focused on the kernel code.

> > ---
> >  drivers/virtio/Kconfig              |    1 +
> >  drivers/virtio/virtio_balloon.c     |   64 +++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/virtio_balloon.h |    1 +
> >  3 files changed, 66 insertions(+)

<snip>

> > 
> > diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> > index a1966cd7b677..19974392d324 100644
> > --- a/include/uapi/linux/virtio_balloon.h
> > +++ b/include/uapi/linux/virtio_balloon.h
> > @@ -36,6 +36,7 @@
> >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
> >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
> >  #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
> > +#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
> >  
> >  /* Size of a PFN in the balloon interface. */
> >  #define VIRTIO_BALLOON_PFN_SHIFT 12

If this is the bit we are talking about I have it split out already into a
QEMU specific patch as well, it can be found here:
https://lore.kernel.org/lkml/20191205162422.19737.57728.stgit@localhost.localdomain/

If needed I could probably add a cover page and/or update the comments in
that patch if that is needed to better explain the change.

Thanks.

- Alex

