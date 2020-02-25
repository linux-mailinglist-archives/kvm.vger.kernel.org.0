Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F516EC17
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 18:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbgBYRGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 12:06:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46237 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730784AbgBYRGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 12:06:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id j7so3114893wrp.13;
        Tue, 25 Feb 2020 09:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qXpNRZ9xs/Twatu1bWavafSUFsQ4scxT0/RdhBW/8jk=;
        b=OEe9V9rC+kMulshRQAS8YM+L9iWzhcW1Xxz5rAcB3geQVg7wuS0cCmjvjE4yWyDDTD
         t+5HcRu618R1CkPkuGzMnS1uWko6GaJlz4XDFkR8v8q7PY2W2N3OAstCfZEcab2iXfZ2
         huFx6SHuesF4HqBfG0Nc3M/Hm/fDWaFks02qpWJvOQrUY9Bv7IZaK4csGq/0PiPopm5P
         G6dwn0ATM05bDaDVeAf13C06TnG8fB6t13GVdn3Kc7JKU1CnVXozi/kNocPvv8xtNVtL
         vRBvu1CeKfZWftQap++CIXvdmsLMr+aHxpa9nOkkyJzzwEMIUNKREHaYh8hW6NC3fLo6
         fPDg==
X-Gm-Message-State: APjAAAUzIiBLEFELDxJX7UgVoQ3ON4LI9fiR/xZ4IKJ8TZqgbv7ygEEF
        MVuOD3+JDpUtvK4/Fstik4Q=
X-Google-Smtp-Source: APXvYqzpvpcxN3LWok+bnCzox3t9IyXPxqeYk1sM9Majp9Pes3xoHsQ4h/KM6dXuKlBz1TOZ5uiKLw==
X-Received: by 2002:a5d:61d1:: with SMTP id q17mr164163wrv.156.1582650380799;
        Tue, 25 Feb 2020 09:06:20 -0800 (PST)
Received: from localhost (ip-37-188-161-46.eurotel.cz. [37.188.161.46])
        by smtp.gmail.com with ESMTPSA id o2sm4901117wmh.46.2020.02.25.09.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 09:06:19 -0800 (PST)
Date:   Tue, 25 Feb 2020 18:06:19 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC v4 12/13] mm/vmscan: Export drop_slab() and
 drop_slab_node()
Message-ID: <20200225170619.GC32720@dhcp22.suse.cz>
References: <20191212171137.13872-1-david@redhat.com>
 <20191212171137.13872-13-david@redhat.com>
 <20200225145829.GW22443@dhcp22.suse.cz>
 <afdf8600-2339-6d74-5e3d-fa1a23384318@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afdf8600-2339-6d74-5e3d-fa1a23384318@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue 25-02-20 16:09:29, David Hildenbrand wrote:
> On 25.02.20 15:58, Michal Hocko wrote:
> > On Thu 12-12-19 18:11:36, David Hildenbrand wrote:
> >> We already have a way to trigger reclaiming of all reclaimable slab objects
> >> from user space (echo 2 > /proc/sys/vm/drop_caches). Let's allow drivers
> >> to also trigger this when they really want to make progress and know what
> >> they are doing.
> > 
> > I cannot say I would be fan of this. This is a global action with user
> > visible performance impact. I am worried that we will find out that all
> > sorts of drivers have a very good idea that dropping slab caches is
> > going to help their problem whatever it is. We have seen the same patter
> > in the userspace already and that is the reason we are logging the usage
> > to the log and count invocations in the counter.
> 
> Yeah, I decided to hold back patch 11-13 for the v1 (which I am planning
> to post in March after more testing). What we really want is to make
> memory offlining an alloc_contig_range() work better with reclaimable
> objects.
> 
> > 
> >> virtio-mem wants to use these functions when it failed to unplug memory
> >> for quite some time (e.g., after 30 minutes). It will then try to
> >> free up reclaimable objects by dropping the slab caches every now and
> >> then (e.g., every 30 minutes) as long as necessary. There will be a way to
> >> disable this feature and info messages will be logged.
> >>
> >> In the future, we want to have a drop_slab_range() functionality
> >> instead. Memory offlining code has similar demands and also other
> >> alloc_contig_range() users (e.g., gigantic pages) could make good use of
> >> this feature. Adding it, however, requires more work/thought.
> > 
> > We already do have a memory_notify(MEM_GOING_OFFLINE) for that purpose
> > and slab allocator implements a callback (slab_mem_going_offline_callback).
> > The callback is quite dumb and it doesn't really try to free objects
> > from the given memory range or even try to drop active objects which
> > might turn out to be hard but this sounds like a more robust way to
> > achieve what you want.
> 
> Two things:
> 
> 1. memory_notify(MEM_GOING_OFFLINE) is called after trying to isolate
> the page range and checking if we only have movable pages. Won't help
> much I guess.

You are right, I have missed that. Can we reorder those two calls?

> 2. alloc_contig_range() won't benefit from that.

True.

> Something like drop_slab_range() would be better, and calling it from
> the right spots in the core (e.g., set_migratetype_isolate() see below).
> 
> Especially, have a look at mm/page_isolation.c:set_migratetype_isolate()
> 
> "FIXME: Now, memory hotplug doesn't call shrink_slab() by itself. We
> just check MOVABLE pages."

shrink_slab is really a large hammer for this purpose. The notifier
mechanism sounds more appropriate to me. If that means to move it
outside of its current position then let's try to experiment with that.
But there is a long route to have per pfn range reclaim.
-- 
Michal Hocko
SUSE Labs
