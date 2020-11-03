Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC99B2A5A15
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 23:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgKCW10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 17:27:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729342AbgKCW1Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 17:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604442442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7WnNFtdh/XhSWs/5uRGkdqLklaY8lxiV5/cBXnNnAz4=;
        b=gqvMFwI5sFfwslcWqAwMFoqY4cHyQyqaa6ibEoXc1cvQOjKOyS8uu1hu9DDv1kf6foSD5s
        750q6+eqgBUzEIyy6GwwuoylKcAOfTVOLpzROrb+I6U9MozEaIuGkmWUmZHs/556P54rai
        vIulCEc5FCGQXnauRmAAqCd6STbEylg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-cImbOjKIPMuVEnC9pdsFUg-1; Tue, 03 Nov 2020 17:27:18 -0500
X-MC-Unique: cImbOjKIPMuVEnC9pdsFUg-1
Received: by mail-qv1-f72.google.com with SMTP id z9so11337913qvo.20
        for <kvm@vger.kernel.org>; Tue, 03 Nov 2020 14:27:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7WnNFtdh/XhSWs/5uRGkdqLklaY8lxiV5/cBXnNnAz4=;
        b=k1sEx6jyxN+EwxjTo4yNf8hnUbg7C/TETe2yKxIty17uh2PvVfjt/YVynlpl3MnnSb
         lLM7ZKr44GPoVZyNjoaIBvsSpe6dVQbmvl6vku81ASNdX2kNdj8SW8wEJGd7fYCKHj9p
         zMfuyTlpf6T+ay8HBs1IsaEyWLfXrtsWoCJBZdCiu8BNXMI2VTLG1J5usbqJXO3kri/g
         RjANZoUyMXjPOz3/e2nUYOWae9xeaa2VXLpzoZPN5oe3SFE/NuP5UPH+eTcCb+dNdXAo
         TDk4OXDl0Ol0hJNwOA4G757a7rqML1IkKm5gx2djr7EusyHvKTvFYBUzKwGnHvdgo0er
         4q4w==
X-Gm-Message-State: AOAM531WEw6711l3keeD9MRAno0oBxjvxhCmmjVwVkfA81/rQmmGOnBr
        2zwtp9A4LX2sW6FRyJG2wABnoWO6VYY+qFN0EbS/V46Xjo0D+uKfM8CjYcCqEw9T5f/RoW1mUOZ
        a0rFxWcarQHjU
X-Received: by 2002:ad4:5807:: with SMTP id dd7mr29352850qvb.35.1604442437879;
        Tue, 03 Nov 2020 14:27:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzc70C60zkSdfPRst23C2RS+oSt5cbk//7/42r9EKzo6ozDdmjq2gYpA4ML73cF1vBY8EL8Aw==
X-Received: by 2002:ad4:5807:: with SMTP id dd7mr29352821qvb.35.1604442437641;
        Tue, 03 Nov 2020 14:27:17 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id q27sm169750qki.60.2020.11.03.14.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 14:27:16 -0800 (PST)
Date:   Tue, 3 Nov 2020 17:27:15 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH 5/5] KVM: selftests: Introduce the dirty log perf test
Message-ID: <20201103222715.GM20600@xz-x1>
References: <20201027233733.1484855-1-bgardon@google.com>
 <20201027233733.1484855-6-bgardon@google.com>
 <20201102222102.GE20600@xz-x1>
 <CANgfPd_sLtqFb3sdpBpd6FWLV4MWKHXH8TSzDbPthzVSQPMJ+A@mail.gmail.com>
 <20201103011205.GG20600@xz-x1>
 <CANgfPd-cWpZviQJj6p5qUDex8rve7N9kFK0Ym_Qt3DBU7QwqJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANgfPd-cWpZviQJj6p5qUDex8rve7N9kFK0Ym_Qt3DBU7QwqJQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 02:17:53PM -0800, Ben Gardon wrote:
> On Mon, Nov 2, 2020 at 5:12 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Mon, Nov 02, 2020 at 03:56:05PM -0800, Ben Gardon wrote:
> > > On Mon, Nov 2, 2020 at 2:21 PM Peter Xu <peterx@redhat.com> wrote:
> > > >
> > > > On Tue, Oct 27, 2020 at 04:37:33PM -0700, Ben Gardon wrote:
> > > > > The dirty log perf test will time verious dirty logging operations
> > > > > (enabling dirty logging, dirtying memory, getting the dirty log,
> > > > > clearing the dirty log, and disabling dirty logging) in order to
> > > > > quantify dirty logging performance. This test can be used to inform
> > > > > future performance improvements to KVM's dirty logging infrastructure.
> > > >
> > > > One thing to mention is that there're a few patches in the kvm dirty ring
> > > > series that reworked the dirty log test quite a bit (to add similar test for
> > > > dirty ring).  For example:
> > > >
> > > >   https://lore.kernel.org/kvm/20201023183358.50607-11-peterx@redhat.com/
> > > >
> > > > Just a FYI if we're going to use separate test programs.  Merging this tests
> > > > should benefit in many ways, of course (e.g., dirty ring may directly runnable
> > > > with the perf tests too; so we can manually enable this "perf mode" as a new
> > > > parameter in dirty_log_test, if possible?), however I don't know how hard -
> > > > maybe there's some good reason to keep them separate...
> > >
> > > Absolutely, we definitely need a performance test for both modes. I'll
> > > take a look at the patch you linked and see what it would take to
> > > support dirty ring in this test.
> >
> > That would be highly appreciated.
> >
> > > Do you think that should be done in this series, or would it make
> > > sense to add as a follow up?
> >
> > To me I slightly lean toward working upon those patches, since we should
> > potentially share quite some code there (e.g., the clear dirty log cleanup
> > seems necessary, or not easy to add the dirty ring tests anyway).  But current
> > one is still ok to me at least as initial version - we should always be more
> > tolerant for test cases, aren't we? :)
> >
> > So maybe we can wait for a 3rd opinion before you change the direction.
> 
> I took a look at your patches for dirty ring and dirty logging modes
> and thought about this some more.
> I think your patch to merge the get and clear dirty log tests is
> great, and I can try to include it and build on it in my series as
> well if desired. I don't think it would be hard to use the same mode
> approach in the dirty log perf test. That said, I think it would be
> easier to keep the functional test (dirty_log_test,
> clear_dirty_log_test) separate from the performance test because the
> dirty log validation is extra time and complexity not needed in the
> dirty log perf test. I did try building them in the same test
> initially, but it was really ugly. Perhaps a future refactoring could
> merge them better.

We can conditionally bypass the validation part.  Let's keep it separate for
now - which is totally fine by me.  Actually I also don't want the dirty ring
series to block your series since I still don't know when it'll land.  That'll
be unnecessary depencency.  Thanks,

-- 
Peter Xu

