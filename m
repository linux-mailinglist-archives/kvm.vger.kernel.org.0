Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A95E265D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 00:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436812AbfJWWYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 18:24:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:31336 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405952AbfJWWYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 18:24:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 15:24:41 -0700
X-IronPort-AV: E=Sophos;i="5.68,222,1569308400"; 
   d="scan'208";a="191984438"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 15:24:41 -0700
Message-ID: <29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com>
Subject: Re: [PATCH v12 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Wed, 23 Oct 2019 15:24:41 -0700
In-Reply-To: <c50e102c-f72e-df8a-714f-a33897ddbb9f@redhat.com>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
         <c50e102c-f72e-df8a-714f-a33897ddbb9f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-10-23 at 07:35 -0400, Nitesh Narayan Lal wrote:
> On 10/22/19 6:27 PM, Alexander Duyck wrote:
> > This series provides an asynchronous means of reporting unused guest
> > pages to a hypervisor so that the memory associated with those pages can
> > be dropped and reused by other processes and/or guests.
> > 

<snip>

> > 
> I think Michal Hocko suggested us to include a brief detail about the background
> explaining how we ended up with the current approach and what all things we have
> already tried.
> That would help someone reviewing the patch-series for the first time to
> understand it in a better way.

I'm not entirely sure it helps. The problem is that even the "brief"
version will probably be pretty long.

From what I know the first real public discussion of guest memory
overcommit and free page hinting dates back to the 2011 KVM forum and a
presentation by Rik van Riel[0].

Before I got started in the code there was already virtio-balloon free
page hinting[1]. However it was meant to be an all-at-once reporting of
the free pages in the system at a given point in time, and used only for
VM migration. All it does is inflate a balloon until it encounters an OOM
and then it frees the memory back to the guest. One interesting piece that
came out of the work on that patch set was the suggestion by Linus to use
an array based incremental approach[2] which is what I based my later
implementation on.

I believe Nitesh had already been working on his own approach for unused
page hinting for some time at that point. Prior to submitting my RFC there
was already a v7 that had been submitted by Nitesh back in mid 2018[3].
The solution was an array based approach which appeared to instrument
arch_alloc_page and arch_free_page and would prevent allocations while
hinting was occurring.

The first RFC I had written[4] was a synchronous approach that made use of
arch_free_page to make a hypercall that would immediately flag the page as
being unused. However a hypercall per page can be expensive and we ideally
don't want the guest vCPU potentially being hung up while waiting on the
host mmap_sem.

At about this time I believe Nitesh's solution[5] was still trying to keep
an array of pages that were unused and tracking that via arch_free_page.
In the synchronous case it could cause OOM errors, and in the asynchronous
approach it had issues with being overrun and not being able to track
unused pages.

Later I switched to an asynchronous approach[6], originally calling it
"bubble hinting". With the asynchronous approach it is necessary to have a
way to track what pages have been reported and what haven't. I originally
was using the page type to track it as I had a Buddy and a TreatedBuddy,
but ultimately that moved to a "Reported" page flag. In addition I pulled
the counters and pointers out of the free_area/free_list  and instead now
have a stand-alone set of pointers and keep the reported statistics in a
separate dynamic allocation.

Then Nitesh's solution had changed to the bitmap approach[7]. However it
has been pointed out that this solution doesn't deal with sparse memory,
hotplug, and various other issues.

Since then both my approach and Nitesh's approach have been iterating with
mostly minor changes.

[0]: https://www.linux-kvm.org/images/f/ff/2011-forum-memory-overcommit.pdf
[1]: https://lore.kernel.org/lkml/1535333539-32420-1-git-send-email-wei.w.wang@intel.com/
[2]: https://lore.kernel.org/lkml/CA+55aFzqj8wxXnHAdUTiOomipgFONVbqKMjL_tfk7e5ar1FziQ@mail.gmail.com/
[3]: https://www.spinics.net/lists/kvm/msg170113.html
[4]: https://lore.kernel.org/lkml/20190204181118.12095.38300.stgit@localhost.localdomain/
[5]: https://lore.kernel.org/lkml/20190204201854.2328-1-nitesh@redhat.com/
[6]: https://lore.kernel.org/lkml/20190530215223.13974.22445.stgit@localhost.localdomain/
[7]: https://lore.kernel.org/lkml/20190603170306.49099-1-nitesh@redhat.com/

