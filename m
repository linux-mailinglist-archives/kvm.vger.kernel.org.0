Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65576C975
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 08:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfGRGwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 02:52:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfGRGwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 02:52:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A54388E24F;
        Thu, 18 Jul 2019 06:52:05 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id E894160D7C;
        Thu, 18 Jul 2019 06:51:52 +0000 (UTC)
Date:   Thu, 18 Jul 2019 02:51:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, xdeguillard@vmware.com, namit@vmware.com,
        akpm@linux-foundation.org, pagupta@redhat.com, riel@surriel.com,
        dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, lcapitulino@redhat.com,
        aarcange@redhat.com, pbonzini@redhat.com,
        alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH v1] mm/balloon_compaction: avoid duplicate page removal
Message-ID: <20190718024822-mutt-send-email-mst@kernel.org>
References: <1563416610-11045-1-git-send-email-wei.w.wang@intel.com>
 <20190718001605-mutt-send-email-mst@kernel.org>
 <5D301232.7080808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D301232.7080808@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 18 Jul 2019 06:52:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 02:31:14PM +0800, Wei Wang wrote:
> On 07/18/2019 12:31 PM, Michael S. Tsirkin wrote:
> > On Thu, Jul 18, 2019 at 10:23:30AM +0800, Wei Wang wrote:
> > > Fixes: 418a3ab1e778 (mm/balloon_compaction: List interfaces)
> > > 
> > > A #GP is reported in the guest when requesting balloon inflation via
> > > virtio-balloon. The reason is that the virtio-balloon driver has
> > > removed the page from its internal page list (via balloon_page_pop),
> > > but balloon_page_enqueue_one also calls "list_del"  to do the removal.
> > I would add here "this is necessary when it's used from
> > balloon_page_enqueue_list but not when it's called
> > from balloon_page_enqueue".
> > 
> > > So remove the list_del in balloon_page_enqueue_one, and have the callers
> > > do the page removal from their own page lists.
> > > 
> > > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > Patch is good but comments need some work.
> > 
> > > ---
> > >   mm/balloon_compaction.c | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> > > index 83a7b61..1a5ddc4 100644
> > > --- a/mm/balloon_compaction.c
> > > +++ b/mm/balloon_compaction.c
> > > @@ -11,6 +11,7 @@
> > >   #include <linux/export.h>
> > >   #include <linux/balloon_compaction.h>
> > > +/* Callers ensure that @page has been removed from its original list. */
> > This comment does not make sense. E.g. balloon_page_enqueue
> > does nothing to ensure this. And drivers are not supposed
> > to care how the page lists are managed. Pls drop.
> > 
> > Instead please add the following to balloon_page_enqueue:
> > 
> > 
> > 	Note: drivers must not call balloon_page_list_enqueue on
> 
> Probably, you meant balloon_page_enqueue here.

yes

> The description for balloon_page_enqueue also seems incorrect:
> "allocates a new page and inserts it into the balloon page list."
> This function doesn't do any allocation itself.
> Plan to reword it: inserts a new page into the balloon page list."

And maybe
" Page must have been allocated with balloon_page_alloc.".


Also
 * Driver must call it to properly enqueue a balloon pages before definitively

should be
 * Driver must call it to properly enqueue balloon pages before definitively


> 
> Best,
> Wei
