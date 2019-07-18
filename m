Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746CE6D5FF
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfGRUtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 16:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfGRUtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 16:49:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40A2230B8E03;
        Thu, 18 Jul 2019 20:49:12 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id D4D7F19D7A;
        Thu, 18 Jul 2019 20:48:57 +0000 (UTC)
Date:   Thu, 18 Jul 2019 16:48:56 -0400
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
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Message-ID: <20190718164656-mutt-send-email-mst@kernel.org>
References: <20190716115535-mutt-send-email-mst@kernel.org>
 <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
 <20190716125845-mutt-send-email-mst@kernel.org>
 <CAKgT0UfgPdU1H5ZZ7GL7E=_oZNTzTwZN60Q-+2keBxDgQYODfg@mail.gmail.com>
 <20190717055804-mutt-send-email-mst@kernel.org>
 <CAKgT0Uf4iJxEx+3q_Vo9L1QPuv9PhZUv1=M9UCsn6_qs7rG4aw@mail.gmail.com>
 <20190718003211-mutt-send-email-mst@kernel.org>
 <CAKgT0UfQ3dtfjjm8wnNxX1+Azav6ws9zemH6KYc7RuyvyFo3fQ@mail.gmail.com>
 <20190718162040-mutt-send-email-mst@kernel.org>
 <CAKgT0UcKTzSYZnYsMQoG6pXhpDS7uLbDd31dqfojCSXQWSsX_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcKTzSYZnYsMQoG6pXhpDS7uLbDd31dqfojCSXQWSsX_A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 18 Jul 2019 20:49:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 01:34:03PM -0700, Alexander Duyck wrote:
> On Thu, Jul 18, 2019 at 1:24 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Jul 18, 2019 at 08:34:37AM -0700, Alexander Duyck wrote:
> > > > > > For example we allocate pages until shrinker kicks in.
> > > > > > Fair enough but in fact many it would be better to
> > > > > > do the reverse: trigger shrinker and then send as many
> > > > > > free pages as we can to host.
> > > > >
> > > > > I'm not sure I understand this last part.
> > > >
> > > > Oh basically what I am saying is this: one of the reasons to use page
> > > > hinting is when host is short on memory.  In that case, why don't we use
> > > > shrinker to ask kernel drivers to free up memory? Any memory freed could
> > > > then be reported to host.
> > >
> > > Didn't the balloon driver already have a feature like that where it
> > > could start shrinking memory if the host was under memory pressure? If
> > > so how would adding another one add much value.
> >
> > Well fundamentally the basic balloon inflate kind of does this, yes :)
> >
> > The difference with what I am suggesting is that balloon inflate tries
> > to aggressively achieve a specific goal of freed memory. We could have a
> > weaker "free as much as you can" that is still stronger than free page
> > hint which as you point out below does not try to free at all, just
> > hints what is already free.
> 
> Yes, but why wait until the host is low on memory?

It can come about for a variety of reasons, such as
other VMs being aggressive, or ours aggressively caching
stuff in memory.

> With my
> implementation we can perform the hints in the background for a low
> cost already. So why should we wait to free up memory when we could do
> it immediately. Why let things get to the state where the host is
> under memory pressure when the guests can be proactively freeing up
> the pages and improving performance as a result be reducing swap
> usage?

You are talking about sending free memory to host.
Fair enough but if you have drivers that aggressively
allocate memory then there won't be that much free guest
memory without invoking a shrinker.

-- 
MST
