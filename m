Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD521794F
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 22:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgGGU0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 16:26:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:6241 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgGGU0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 16:26:25 -0400
IronPort-SDR: 7Qjh6edZuJGpqxlHnDQ8L5qOBjx0mLTEpsB+oQuF8/x7NyrZjc/gaxIvESKF/6aNRtQy+0D+Cv
 I5VnFsqXCJ2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="146759192"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="146759192"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 13:26:23 -0700
IronPort-SDR: kKJnIcKlGwzU4Mpw47283qOwWXFTF6OyFfUa/NJP4HDbjorz4a5ST4WPrHLMiWQJILAkUJhV6/
 HYLbcOegt8RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="315637082"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jul 2020 13:26:23 -0700
Date:   Tue, 7 Jul 2020 13:26:23 -0700
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
Message-ID: <20200707202623.GM20096@linux.intel.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
 <20200702230849.GL3575@linux.intel.com>
 <20200703184122.GF6677@xz-x1>
 <20200707061732.GI5208@linux.intel.com>
 <20200707195009.GE88106@xz-x1>
 <20200707195658.GK20096@linux.intel.com>
 <20200707201508.GH88106@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707201508.GH88106@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 04:15:08PM -0400, Peter Xu wrote:
> On Tue, Jul 07, 2020 at 12:56:58PM -0700, Sean Christopherson wrote:
> > > > It's a single line of code, and there's more than one
> > > > "shouldn't" in the above.
> > > 
> > > If you want, I can both set it and add the comment.  Thanks,
> > 
> > Why bother with the comment?  It'd be wrong in the sense that the as_id is
> > always valid/accurate, even if npages == 0.
> 
> Sorry I'm confused.. when npages==0, why as_id field is meaningful?  Even if
> the id field is meaningless after the slot is successfully removed, or am I
> wrong?
> 
> My understanding is that after your dynamic slot work, we'll only have at most
> one extra memslot that was just removed, and that slot should be meaningless as
> a whole.  Feel free to correct me.

Your understanding is correct.  What I'm saying is that if something goes
awry and the memslots need to be debugged, having accurate info for that one
defunct memslot could be helpful, if only to not confuse a future debugger
that doesn't fully understand memslots or address spaces.  Sure, it could be
manually added back in for debug, but it's literally a single line of code
to carry and it avoids the need for a special comment.
