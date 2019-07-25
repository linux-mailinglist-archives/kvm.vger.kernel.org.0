Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61957535B
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 17:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389666AbfGYP7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 11:59:30 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45093 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389660AbfGYP73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 11:59:29 -0400
Received: by mail-io1-f65.google.com with SMTP id g20so98292318ioc.12;
        Thu, 25 Jul 2019 08:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qK60BCTTRu0Ys+kw65S0SEpX7dQ3Yakjf+W+ppKoJMM=;
        b=oqCfu2vZEmKMr8jRkoBDSP/46uQ6yqxt8toi+TVwd67qyXZK0EBxRVYSpECs1dwMez
         IcJIExjgCycm93oaDl70T2DnEn7kMwO14tnS8UtAuIfAxD0Ln5ChwW4wMj7sr+cqrW43
         yqY55w0i6b+GOWyP7gKwmC458qQHUeDS97+wQoA3lDOdm/pWF1L93CK72iojAHynec/9
         USk3f/L5BqSWz3PuRVIgj6ptLf1A1c1Acf4Il4Li+zceMw4N8A0Ba+Y37CdXImGl4IQJ
         ZI5OmwkoV2oZAFYErftwgUqwAR1e1gcfGZxglhUJGt6g/ZSQJdEo/2T29phDR2gqyXky
         nXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qK60BCTTRu0Ys+kw65S0SEpX7dQ3Yakjf+W+ppKoJMM=;
        b=J6uHgrbQLFbuEKGkO+w5vjWgPPDyj0W3U4ZfPvwq7FgqQyuCSPB86MzYOxDslX1goj
         9BxOD99r2s0SGFyackYtCxSS7sF6QhNwPjZOqvECOs1hxVXTIoP5FD2Nw1jUduTiHxkM
         w5a4y4VBONMRrPg1C/os1NW6dsimQtMuMIIBSYTVxYA/YE8J8DiSwv12pprArw9QWH7L
         kY81nPIhk+6VYef1NxFtoXlTfoRdYe4dQvdLwq+4FfsE2Hpcn2/VzIKtxt4ueFyvtS9y
         eUY0rLxrHwR/+uNPN0SQl9hUDXIMSRCJs2ZKjHQ6NT5x5FvePMTOAvn7qVfyydoNvL9W
         ogyA==
X-Gm-Message-State: APjAAAWs01ddsLYEeIXV7kQnyQY2hYFjmbeqeX9q0bM6IyRLnpcdY1sE
        R04Zy4Kyn16LORLPLAyJCA6wK7tAHiFBPzIuAAU=
X-Google-Smtp-Source: APXvYqykv1YdLQoWPp1mD51S3A7Q+qMzrIevwBDJOREyxPzWS4W+wUHAKx/78O4j5/nzoqGCrsWrL3POrUlIcbXB5S4=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr15281210ioj.64.1564070368966;
 Thu, 25 Jul 2019 08:59:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724170259.6685.18028.stgit@localhost.localdomain> <a9f52894-52df-cd0c-86ac-eea9fbe96e34@redhat.com>
In-Reply-To: <a9f52894-52df-cd0c-86ac-eea9fbe96e34@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 25 Jul 2019 08:59:17 -0700
Message-ID: <CAKgT0Ud-UNk0Mbef92hDLpWb2ppVHsmd24R9gEm2N8dujb4iLw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mm: Introduce Hinted pages
To:     David Hildenbrand <david@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 25, 2019 at 1:53 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 24.07.19 19:03, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

<snip>

> >  /*
> > + * PageHinted() is an alias for Offline, however it is not meant to be an
> > + * exclusive value. It should be combined with PageBuddy() when seen as it
> > + * is meant to indicate that the page has been scrubbed while waiting in
> > + * the buddy system.
> > + */
> > +PAGE_TYPE_OPS(Hinted, offline)
>
>
> CCing Matthew
>
> I am still not sure if I like the idea of having two page types at a time.
>
> 1. Once we run out of page type bits (which can happen easily looking at
> it getting more and more user - e.g., maybe for vmmap pages soon), we
> might want to convert again back to a value-based, not bit-based type
> detection. This will certainly make this switch harder.

Shouldn't we wait to cross that bridge until we get there? It wouldn't
take much to look at either defining the buddy as 2 types for such a
case, or if needed we could then look at the option of moving over to
another bit.

> 2. It will complicate the kexec/kdump handling. I assume it can be fixed
> some way - e.g., making the elf interface aware of the exact notion of
> page type bits compared to mapcount values we have right now (e.g.,
> PAGE_BUDDY_MAPCOUNT_VALUE). Not addressed in this series yet.

It does, but not by much. We were already exposing both the buddy and
offline values. The cahnge could probably be in the executable that
are accessing the interface to allow the combination of buddy and
offline. That is one of the advantages of using the "offline" value to
also mean hinted since then "hinted" is just a combination of the two
known values.

> Can't we reuse one of the traditional page flags for that, not used
> along with buddy pages? E.g., PG_dirty: Pages that were not hinted yet
> are dirty.

Reusing something like the dirty bit would just be confusing in my
opinion. In addition it looks like Xen has also re-purposed PG_dirty
already for another purpose.

If anything I could probably look at seeing if the PG_private flags
are available when a page is in the buddy allocator which I suspect
they probably are since the only users I currently see appear to be
SLOB and compound pages. Either that or maybe something like PG_head
might make sense since once we start allocating them we are popping
the head off of the boundary list.
