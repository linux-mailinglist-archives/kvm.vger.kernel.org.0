Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8321360F4
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgAITUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:20:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729430AbgAITUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 14:20:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578597610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U6pv4fiagmi8mGdwv9aqgS69jPV3Df3FlAPRGguwysE=;
        b=PN6273ikkhruNdHausamVg8wQ4WLOsG34prXod4H8tkgn5BOZ4qqLFfFE6R92wpDGehYqU
        f5i5D39aWwNvkF2mN+HdtvFcRev6rcJYBPJ1gA0yXCKj+VWwME5OR4KQu+sjUuAN8nTHZE
        gjTqjN93vJq7J/oNriArv9WtVLCsVis=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-70-rZW8yOoO-0OmkhXvSTg-1; Thu, 09 Jan 2020 14:14:01 -0500
X-MC-Unique: 70-rZW8yOoO-0OmkhXvSTg-1
Received: by mail-qk1-f200.google.com with SMTP id 12so4772708qkf.20
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:14:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U6pv4fiagmi8mGdwv9aqgS69jPV3Df3FlAPRGguwysE=;
        b=AMSPfBDsnDVNpytSoEAt6ZuYvs+eZGyPzJ4iMu3gZ6RQnGZ5/81xY8ydiv3dnOjFAp
         b1nYDsvWAp9eqvSy6o6uc72EIjJykbzujAWHAxa6VByWBDB2NlL4qpf1L2LLiReYI2vX
         TwY3A5Qmzg74k4JD4/98M5HE0+rRFPTqX9WmK0trZdnKYkq6idEiZj0S1ZW2QIKcmv6K
         BXPZrgV2VNxA/BxIvMqONgSLUnb4k2NMVJEviTx5ObRU7StktKgR8fnUjHEJFerB6Kkc
         dbdZHxlFpuaNb8T8LMjcb5QlxLkE+B1VUDltQFZRoXyn7QCR3J4SfO/4x3CGFKt8EmBx
         gGpA==
X-Gm-Message-State: APjAAAXFvOcUnCgQsKwFx30mqskhNR2ETg/9HlVZtXqlbdDfDF5yqh2U
        Bq/ZAHKv2tKEnlm40QYHRQvFR1Y/rnlbwDZ3nKFStiTCXKR2u+7LOhIA65xWMzvbgEZPxF314cD
        Is/0dXVZ96NrB
X-Received: by 2002:ad4:5888:: with SMTP id dz8mr10291686qvb.204.1578597241414;
        Thu, 09 Jan 2020 11:14:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+U3DV2/GGnsOTUJjf+AEHnjgjwkEHejl70teHqLECH8EwIX4KxcbMcG8JIZf4rcDh5tGOUg==
X-Received: by 2002:ad4:5888:: with SMTP id dz8mr10291651qvb.204.1578597241147;
        Thu, 09 Jan 2020 11:14:01 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id l44sm2823904qtb.48.2020.01.09.11.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:14:00 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:13:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
Message-ID: <20200109140948-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109094711.00eb96b1@w520.home>
 <20200109175808.GC36997@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109175808.GC36997@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 12:58:08PM -0500, Peter Xu wrote:
> On Thu, Jan 09, 2020 at 09:47:11AM -0700, Alex Williamson wrote:
> > On Thu,  9 Jan 2020 09:57:08 -0500
> > Peter Xu <peterx@redhat.com> wrote:
> > 
> > > Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> > > (based on kvm/queue)
> > > 
> > > Please refer to either the previous cover letters, or documentation
> > > update in patch 12 for the big picture.  Previous posts:
> > > 
> > > V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
> > > V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
> > > 
> > > The major change in V3 is that we dropped the whole waitqueue and the
> > > global lock. With that, we have clean per-vcpu ring and no default
> > > ring any more.  The two kvmgt refactoring patches were also included
> > > to show the dependency of the works.
> > 
> > Hi Peter,
> 
> Hi, Alex,
> 
> > 
> > Would you recommend this style of interface for vfio dirty page
> > tracking as well?  This mechanism seems very tuned to sparse page
> > dirtying, how well does it handle fully dirty, or even significantly
> > dirty regions?
> 
> That's truely the point why I think the dirty bitmap can still be used
> and should be kept.  IIUC the dirty ring starts from COLO where (1)
> dirty rate is very low, and (2) sync happens frequently.  That's a
> perfect ground for dirty ring.  However it for sure does not mean that
> dirty ring can solve all the issues.  As you said, I believe the full
> dirty is another extreme in that dirty bitmap could perform better.
> 
> > We also don't really have "active" dirty page tracking
> > in vfio, we simply assume that if a page is pinned or otherwise mapped
> > that it's dirty, so I think we'd constantly be trying to re-populate
> > the dirty ring with pages that we've seen the user consume, which
> > doesn't seem like a good fit versus a bitmap solution.  Thanks,
> 
> Right, so I confess I don't know whether dirty ring is the ideal
> solutioon for vfio either.  Actually if we're tracking by page maps or
> pinnings, then IMHO it also means that it could be more suitable to
> use an modified version of dirty ring buffer (as you suggested in the
> other thread), in that we can track dirty using (addr, len) range
> rather than a single page address.  That could be hard for KVM because
> in KVM the page will be mostly trapped in 4K granularity in page
> faults, and it'll also be hard to merge continuous entries with
> previous ones because the userspace could be reading the entries (so
> after we publish the previous 4K dirty page, we should not modify the
> entry any more).

An easy way would be to keep a couple of entries around, not pushing
them into the ring until later.  In fact deferring queue write until
there's a bunch of data to be pushed is a very handy optimization.

When building UAPI's it makes sense to try and keep them generic
rather than tying them to a given implementation.

That's one of the reasons I called for using something
resembling vring_packed_desc.


> VFIO should not have this restriction because the
> marking of dirty page range can be atomic when the range of pages are
> mapped or pinned.
> 
> Thanks,
> 
> -- 
> Peter Xu

