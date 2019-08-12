Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1593B8A28B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 17:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHLPnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 11:43:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35324 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLPnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 11:43:46 -0400
Received: by mail-qk1-f193.google.com with SMTP id r21so77336025qke.2
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2019 08:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p6DR/OYzfN+vBNP6q9yfF8yIqpIgtHE8+UL4dlkfU30=;
        b=id1rgg09dyGi1fSC64yjUeGFBgJzPbfcObynexkZ+fnkwZb9VOcGCbrWsVBBw1Zlxp
         Nd8roSyE4T6CbLSizJDoat5SSJ80s0IK8W6WBEehSEZguc4BURNU/MMDpvP5kn+GQ2GO
         zAKBs3LwSaVPub7Fkt6RmckYw3zCcBtFIH1U9K1TemTOSQt20YdNLzwp27lB3awjqMgx
         zXBW+Lf22la9vhtz/OzrU55V2L0ErKGt313n2P/SpogycPc/XcmiX9LUljgTxkSQoGDI
         qQwBHJAv+1WK0pJnITnvuguiC5ANWiFtwhdKktPMFy2yr2BTaElPVWd8dOYDr1Ev13aE
         nDtA==
X-Gm-Message-State: APjAAAWtmXc2CJ7H3Nx908G0l/YUBlcZiNfVIbVDJXtlPrKxTUlfIPqk
        Wdj1Y2QEWXhTFaMjO3JzIenQZQ==
X-Google-Smtp-Source: APXvYqxqdBbAl7HwqLwogkzmxm32JSi6pIDpBqFOl9pCZpI2YN6+NOeak0SuGGqnKQRcwszCP6Nqzg==
X-Received: by 2002:a37:5d07:: with SMTP id r7mr30078310qkb.4.1565624625037;
        Mon, 12 Aug 2019 08:43:45 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id p3sm68510245qta.12.2019.08.12.08.43.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 08:43:43 -0700 (PDT)
Date:   Mon, 12 Aug 2019 11:43:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, lcapitulino@redhat.com,
        wei.w.wang@intel.com, Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v4 6/6] virtio-balloon: Add support for providing unused
 page reports to host
Message-ID: <20190812114256-mutt-send-email-mst@kernel.org>
References: <20190807224037.6891.53512.stgit@localhost.localdomain>
 <20190807224219.6891.25387.stgit@localhost.localdomain>
 <20190812055054-mutt-send-email-mst@kernel.org>
 <CAKgT0Ucr7GKWsP5sxSbDTtW_7puSqwXDM7y_ZD8i2zNrKNScEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ucr7GKWsP5sxSbDTtW_7puSqwXDM7y_ZD8i2zNrKNScEw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 08:20:43AM -0700, Alexander Duyck wrote:
> On Mon, Aug 12, 2019 at 2:53 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Aug 07, 2019 at 03:42:19PM -0700, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> <snip>
> 
> > > --- a/include/uapi/linux/virtio_balloon.h
> > > +++ b/include/uapi/linux/virtio_balloon.h
> > > @@ -36,6 +36,7 @@
> > >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM      2 /* Deflate balloon on OOM */
> > >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT      3 /* VQ to report free pages */
> > >  #define VIRTIO_BALLOON_F_PAGE_POISON 4 /* Guest is using page poisoning */
> > > +#define VIRTIO_BALLOON_F_REPORTING   5 /* Page reporting virtqueue */
> > >
> > >  /* Size of a PFN in the balloon interface. */
> > >  #define VIRTIO_BALLOON_PFN_SHIFT 12
> >
> > Just a small comment: same as any feature bit,
> > or indeed any host/guest interface changes, please
> > CC virtio-dev on any changes to this UAPI file.
> > We must maintain these in the central place in the spec,
> > otherwise we run a risk of conflicts.
> >
> 
> Okay, other than that if I resubmit with the virtio-dev list added to
> you thing this patch set is ready to be acked and pulled into either
> the virtio or mm tree assuming there is no other significant feedback
> that comes in?
> 
> Thanks.
> 
> - Alex


From my POV yes. If it's my tree acks by mm folks will be necessary.

-- 
MST
