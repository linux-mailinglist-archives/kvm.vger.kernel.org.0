Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73D311312D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 18:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfLDRyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 12:54:05 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:34366 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfLDRyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 12:54:05 -0500
Received: by mail-io1-f68.google.com with SMTP id z193so584289iof.1;
        Wed, 04 Dec 2019 09:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Rhu4aVTP3SHJymoOSE6jn6lAKDbkxhTckaz9ubCxMc=;
        b=eqtUE1noyuM8BxzbDMxzyqdljYKTzHhyFZRNmOiuWMgZ7/Dr9BJ6CwwpM8gaqipYeg
         eZNhT3kxzMmcW6y0XsPp0JfxvYLVyKdDag+IjBXVTUmEyZfAjBOnjPPSeaqKmSDx/du7
         rD00G0LPwfAnW17G3uCcucTdP61PcA4umlRWKthIIsFoZmOD5zsiELRq2GAZXI5YUrlb
         2XSou9VQOQ8JxMxWYgsArcGdXoPUPg8oSJBFSNQsXbxqaQC5Eu62hl1g50owCRU7sQx3
         sUPDUX/RP+p86a4V4BKSBgJxAyNOlLFiOSBnmOfwMIYVxKgwqWePihu36s741Lt/ohkO
         T6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Rhu4aVTP3SHJymoOSE6jn6lAKDbkxhTckaz9ubCxMc=;
        b=NjYzGl5Z6slTX2JIuF+Smgw9Iv97K3uMarvat9P/n0LOeH7OfDeNi2LvY5wHI48UZ8
         JtWkWQ/5VJ338s3vf41lA769Iuf92+U4NXTyEMWJ8Es6tlKq6J3LAmSwd+BrUBVHcfJK
         WC6eXRt639JPLIl2L9kQ+XiGn/oSQFBxgVEkyi6QjWod8S7enL5UtPIkRDrDawyg2grj
         ksKKCBhNVrxVR0qkt6Tu1949ZHBcoknS/dvuPHhCAuFoOlpOB2Z+r5vsIQeQrhiDfUkb
         LnYgXqqteSjauhiM1AksLNEZAFIvVqQcIJywuyDFnhQo/lx2HkLsfUOpzVQ7QlIyWMoY
         Cc7A==
X-Gm-Message-State: APjAAAWkKRedlqIpF/X7nblLkKl0aPtn8VQ16e7b16CpyIy0EjXFyLti
        3+ZYCJy47zeSQJSAsfLtmI+XFfXcjmG2l4g8Hak=
X-Google-Smtp-Source: APXvYqx0MZtv/TGr10HI8jDueGeBFRhkkLZ13EEYZPAiEPm8WPvXJzc4BDvj9q4//gK0ifWQqzWKIq0tSN5YXkqt7O4=
X-Received: by 2002:a02:7f54:: with SMTP id r81mr4224567jac.121.1575482044379;
 Wed, 04 Dec 2019 09:54:04 -0800 (PST)
MIME-Version: 1.0
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain> <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
 <20191128115436-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191128115436-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 4 Dec 2019 09:53:53 -0800
Message-ID: <CAKgT0Uf3uhm5B6_aYphJEMLvWicMpnygfE=vYMDx7T4KSpMp-A@mail.gmail.com>
Subject: Re: [PATCH v14 6/6] virtio-balloon: Add support for providing unused
 page reports to host
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 9:00 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Nov 28, 2019 at 04:25:54PM +0100, David Hildenbrand wrote:
> > On 19.11.19 22:46, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > >
> > > Add support for the page reporting feature provided by virtio-balloon.
> > > Reporting differs from the regular balloon functionality in that is is
> > > much less durable than a standard memory balloon. Instead of creating a
> > > list of pages that cannot be accessed the pages are only inaccessible
> > > while they are being indicated to the virtio interface. Once the
> > > interface has acknowledged them they are placed back into their respective
> > > free lists and are once again accessible by the guest system.
> >
> > Maybe add something like "In contrast to ordinary balloon
> > inflation/deflation, the guest can reuse all reported pages immediately
> > after reporting has finished, without having to notify the hypervisor
> > about it (e.g., VIRTIO_BALLOON_F_MUST_TELL_HOST does not apply)."
>
> Maybe we can make apply. The effect of reporting a page is effectively
> putting it in a balloon then immediately taking it out. Maybe without
> VIRTIO_BALLOON_F_MUST_TELL_HOST the pages can be reused before host
> marked buffers used?
>
> We didn't teach existing page hinting to behave like this, but maybe we
> should, and maybe it's not too late, not a long time passed
> since it was merged, and the whole shrinker based thing
> seems to have been broken ...

The problem is the existing hinting implementation relies on pushing
the memory to the point of OOM in order to avoid having to re-hint on
pages. What it is looking for is a snapshot rather than a running
tally. The page reporting bit approach would only work for the first
migration. The problem is the bit is persistent and would leave unused
pages flagged as reported if another migration starts so it wouldn't
re-report those pages.

> BTW generally UAPI patches will have to be sent to virtio-dev
> mailing list before they are merged.

Do you need just the QEMU patches submitted to virtio-dev or both the
virtio kernel patches and the QEMU patches?

One piece of feedback I got was that it was annoying that I was
including virtio-dev since it requires a subscription to send to it.
If you would like I could apply it on the QEMU patches which would
make the changes more visible at least.

Thanks.

- Alex
