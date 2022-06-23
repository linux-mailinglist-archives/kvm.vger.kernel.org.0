Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04946558AF4
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiFWVwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiFWVwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:52:44 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DE1609DE
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 14:52:43 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so900266pjv.3
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WP+rwC4TGDAfQrrpdmxtx5HaFMWvuSkA5tpFa2Z0KTo=;
        b=FaIYrEPF7pH2Sg//kKmJsf4O808sp8hU3xWztRq7PW/NTqPPLAtvMC+D62zDoo+Hfo
         nD4lTJVJCNX6DnRqCnafQOpaZ8N3Ie155liv3aGLaVYMelGO1Mt51ztufJGskpU8fqgH
         soA/5thJgCOY4jOHBZt46Rh5pmOj6zNvlG4mmfvzHKkPscBNoRjStOvA/rY0qDp7PcGE
         /RPTM4wLwtu067izgHGTSTyu49NPFzY1X6noKkMnKFZzk623WewYhW1yMNqhhGq5xNVU
         /0m14dFYj73PPdK7f1clf1vXrU0z0O/T7MeJ4hLanIN4KJJk1axvx7cDOqXDjF0as+QH
         21vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WP+rwC4TGDAfQrrpdmxtx5HaFMWvuSkA5tpFa2Z0KTo=;
        b=XH7KlznpS/6Fz750WPrs6PbhVfEKcJsrvf4gmpBNxa/yj+R6G+X0Z60C1uN1xmPM/d
         d/hLkdIlhnKxeXQWeveHblATSJPuJpeGOHe0uJgLFSTVUGvLr5N9/JItP72CISq3aF4H
         NWSW36eH5bglU8QqRWhi1tWktb9ckoPpYhU921btApaaNzEOBo80YdbJMndnmrQVY4R2
         k11ydBpYndHM31wYXsZsYN7J9UL/TJ9IyanwkVC+3e6PEfXKmPUh94ML//0OE0GGbJm5
         Zyxzwrf9VK0ysJ4uydDHkJWzfYkIimSIQrqlfK5qfXOTfotsxRpsOVYF8XK3zfU+hyya
         jFQQ==
X-Gm-Message-State: AJIora9o5GaNZyUZpdapFOiHCsb7nA/7694Riq6OVEPCcgR/8ik84vT1
        G/IucEyN+MrvZkRXY53aD/i73g==
X-Google-Smtp-Source: AGRyM1uSglzJGxysU1/dykORfD2OPQF8J5jiG2z0akLmO9sFwpadT8seYG0Mf7zVPB0bl/0++f3GGA==
X-Received: by 2002:a17:903:110d:b0:168:c610:9a80 with SMTP id n13-20020a170903110d00b00168c6109a80mr40966937plh.12.1656021162711;
        Thu, 23 Jun 2022 14:52:42 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h4-20020a17090adb8400b001ecb28cfbfesm199878pjv.51.2022.06.23.14.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 14:52:42 -0700 (PDT)
Date:   Thu, 23 Jun 2022 21:52:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Message-ID: <YrTgpjLrnRpqFnIa@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <YrR9i3yHzh5ftOxB@google.com>
 <YrTDBwoddwoY1uSV@xz-m1.local>
 <YrTNGVpT8Cw2yrnr@google.com>
 <YrTbKaRe497n8M0o@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrTbKaRe497n8M0o@xz-m1.local>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022, Peter Xu wrote:
> On Thu, Jun 23, 2022 at 08:29:13PM +0000, Sean Christopherson wrote:
> > This is what I came up with for splitting @async into a pure input (no_wait) and
> > a return value (KVM_PFN_ERR_NEEDS_IO).
> 
> The attached patch looks good to me.  It's just that..
> 
> [...]
> 
> >  kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> > -			       bool atomic, bool *async, bool write_fault,
> > +			       bool atomic, bool no_wait, bool write_fault,
> >  			       bool *writable, hva_t *hva)
> 
> .. with this patch on top we'll have 3 booleans already.  With the new one
> to add separated as suggested then it'll hit 4.
> 
> Let's say one day we'll have that struct, but.. are you sure you think
> keeping four booleans around is nicer than having a flag, no matter whether
> we'd like to have a struct or not?

No.

>   kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> 			       bool atomic, bool no_wait, bool write_fault,
>                                bool interruptible, bool *writable, hva_t *hva);
> 
> What if the booleans goes to 5, 6, or more?
> 
> /me starts to wonder what'll be the magic number that we'll start to think
> a bitmask flag will be more lovely here. :)

For the number to really matter, it'd have to be comically large, e.g. 100+.  This
is all on-stack memory, so it's as close to free as can we can get.  Overhead in
terms of (un)marshalling is likely a wash for flags versus bools.  Bools pack in
nicely, so until there are a _lot_ of bools, memory is a non-issue.

That leaves readability, which isn't dependent on the number so much as it is on
the usage, and will be highly subjective based on the final code.

In other words, I'm not dead set against flags, but I would like to see a complete
cleanup before making a decision.  My gut reaction is to use bools, as it makes
consumption cleaner in most cases, e.g.

	if (!(xxx->write_fault || writable))
		return false;

versus

	if (!((xxx->flags & KVM_GTP_WRITE) || writable))
		return false;

but again I'm not going to say never until I actually see the end result.
