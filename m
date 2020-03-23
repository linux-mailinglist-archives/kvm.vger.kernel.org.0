Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C3218F975
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgCWQQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:16:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25044 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727267AbgCWQQe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 12:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584980193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IYrLYvqnGZEV23VKew7hMTB9MLlxza06argJ9Y4MphY=;
        b=VijpbEx1sJLsDOOMoOR5ARqJrAdHi9pTk1gBgUL8gYCCsm6A8LnZ23AGHOHmIW6Uh6GD+z
        IlVxsoYtOI0Kl2B6W43Ikzi/Y5ZdaQYtTN5qB1dSqV0wiq9nQaPzaJAwA6PiJAoN/kap5W
        PfQd9TxorXNB9c4m5PFQ8dvPVkd/Yys=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-WNra2aQ7PLel0T5ebnWq9w-1; Mon, 23 Mar 2020 12:16:31 -0400
X-MC-Unique: WNra2aQ7PLel0T5ebnWq9w-1
Received: by mail-wr1-f69.google.com with SMTP id u18so7552029wrn.11
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 09:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IYrLYvqnGZEV23VKew7hMTB9MLlxza06argJ9Y4MphY=;
        b=Z+66scLAzBJv5Fu1TWbMUlP6ZbS37oTaNbOCIwSSxDmCkuX9gdzOGTXFV0nUChzPgS
         H7frsbMJRbE0dqF9J2nXpODeqW3qS7SSu7E2KTSfu0NgPO48ZuuIPvAmrYyqiEgn76kH
         g1jnaEbnT/TnZUdn2P86aZzcEpl2+pYKcGgQ3sreMFUTeCLNWcWcKhObd7MUG/kANvNL
         y8lHiirxwzxuQFIsnONBXVyuHvp3YrwGjBX9571d60dFKCV79pg2tA4bEV3OwGHDI7om
         3/ouOvIbM9MDaL3C4BW1o/A7QO4DbU3a0rttsGbzS7Kt08FVkXwAQcQOIHyn5GpHEi8b
         wpYg==
X-Gm-Message-State: ANhLgQ1gXRRyt0UsGU2iJo49J0aSD0o/gok23c/SI40F1XL+WR3Q4njH
        MHppxQxOPmZJ424ZBGqUisd7XvscrvkmDBERVRG5VJM3q6TsqvXabejpBh6YlHErY8g+h4GiYeB
        56VzQZxHOigb1
X-Received: by 2002:adf:ecc3:: with SMTP id s3mr28227566wro.32.1584980190357;
        Mon, 23 Mar 2020 09:16:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvbW0tcdx3bsp/p23/luhT8S5W7BBOXb4FD91QyavWn3XWwFNHTv4rOmubmFt012JdzIk11aA==
X-Received: by 2002:adf:ecc3:: with SMTP id s3mr28227526wro.32.1584980190068;
        Mon, 23 Mar 2020 09:16:30 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id s7sm23648472wro.10.2020.03.23.09.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 09:16:29 -0700 (PDT)
Date:   Mon, 23 Mar 2020 12:16:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 06/14] KVM: Make dirty ring exclusive to dirty bitmap
 log
Message-ID: <20200323161626.GJ127076@xz-x1>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-7-peterx@redhat.com>
 <20200321191250.GB13851@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200321191250.GB13851@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 21, 2020 at 12:12:50PM -0700, Sean Christopherson wrote:
> On Wed, Mar 18, 2020 at 12:37:12PM -0400, Peter Xu wrote:
> > There's no good reason to use both the dirty bitmap logging and the
> > new dirty ring buffer to track dirty bits.  We should be able to even
> > support both of them at the same time, but it could complicate things
> > which could actually help little.  Let's simply make it the rule
> > before we enable dirty ring on any arch, that we don't allow these two
> > interfaces to be used together.
> > 
> > The big world switch would be KVM_CAP_DIRTY_LOG_RING capability
> > enablement.  That's where we'll switch from the default dirty logging
> > way to the dirty ring way.  As long as kvm->dirty_ring_size is setup
> > correctly, we'll once and for all switch to the dirty ring buffer mode
> > for the current virtual machine.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.rst |  7 +++++++
> >  virt/kvm/kvm_main.c            | 12 ++++++++++++
> >  2 files changed, 19 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 99ee9cfc20c4..8f3a83298d3f 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6202,3 +6202,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
> >  
> >  The dirty ring can gets full.  When it happens, the KVM_RUN of the
> >  vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
> > +
> > +NOTE: the KVM_CAP_DIRTY_LOG_RING capability and the new ioctl
> 
> Leave off "new", it'll be stale a few months/years from now.

Ok.

> 
> > +KVM_RESET_DIRTY_RINGS are exclusive to the existing KVM_GET_DIRTY_LOG
> 
> Did you mean "mutually exclusive with"?  "exclusive to" would mean they
> can only be used by KVM_GET_DIRTY_LOG with doesn't match the next
> sentence.

I meant "mutual-exclusive".  I'll fix it up.

Thanks,

-- 
Peter Xu

