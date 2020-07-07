Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F81217863
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 21:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgGGT47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 15:56:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:58111 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgGGT47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 15:56:59 -0400
IronPort-SDR: zFr05g4WBMtT+hpM5NMJNTbxhporwZEwsM5zMJ2xuP7GAnJAdY9UDWPqlQ8xS0Vl8AhQF3CLwA
 qJGOMGphJ18w==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="209215847"
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800"; 
   d="scan'208";a="209215847"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 12:56:58 -0700
IronPort-SDR: uJ2aiNFQi5DFX0DNPXct67t6vFZ3yboM/GmfyuVytv9hGVwtvRJZnmQbbU30y6f6nk/pAwVdwf
 YS/TRUNdd37A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800"; 
   d="scan'208";a="427588555"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 07 Jul 2020 12:56:58 -0700
Date:   Tue, 7 Jul 2020 12:56:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v10 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200707195658.GK20096@linux.intel.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
 <20200702230849.GL3575@linux.intel.com>
 <20200703184122.GF6677@xz-x1>
 <20200707061732.GI5208@linux.intel.com>
 <20200707195009.GE88106@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707195009.GE88106@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 03:50:09PM -0400, Peter Xu wrote:
> On Mon, Jul 06, 2020 at 11:17:32PM -0700, Sean Christopherson wrote:
> > On Fri, Jul 03, 2020 at 02:41:22PM -0400, Peter Xu wrote:
> > > On Thu, Jul 02, 2020 at 04:08:49PM -0700, Sean Christopherson wrote:
> > > > This technically needs to set as_id in the deleted memslot.  I highly doubt
> > > > it will ever matter from a functionality perspective, but it'd be confusing
> > > > to encounter a memslot whose as_id did not match that of its owner.
> > > 
> > > Yeah it shouldn't matter because as_id is directly passed in to look up the
> > > pointer of kvm_memslots in kvm_delete_memslot, and memslot->as_id shouldn't be
> > > further referenced.
> > > 
> > > I can add a comment above if this can clarify things a bit:
> > > 
> > > +	u16 as_id; /* cache of as_id; only valid if npages != 0 */
> > 
> > Why not just set it?
> 
> Because the value is useless even if set? :)

It's useless when things go according to plan, but I can see it being useful
if there's a bug that leads to consumption of a deleted memslot.  Maybe not
"useful" so much as "not misleading".
 
> You mean in kvm_delete_memslot(), am I right?

Yes.

> > It's a single line of code, and there's more than one
> > "shouldn't" in the above.
> 
> If you want, I can both set it and add the comment.  Thanks,

Why bother with the comment?  It'd be wrong in the sense that the as_id is
always valid/accurate, even if npages == 0.
