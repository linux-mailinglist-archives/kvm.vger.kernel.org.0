Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547E7636979
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 20:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbiKWTDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 14:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbiKWTDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 14:03:17 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545E512081
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:03:16 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 4so17504640pli.0
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LYJ67wF71BcvO8uwmwy3ELqCWCBu6XNQ28q/rdgvWwE=;
        b=kBJIv846/kULBsOC5L9jGrNLZS3fxfPXvIpSe6V8KKjwhAkFe3/VeU1d/ouT9MadTV
         VjDbPgjJLE6oqgcuzU5VUl64diSXtWgY8VdY93piOsVtuk1rSnZxxH7H8NWwoDkgLzFF
         pkHhI7NXHh6IYAIVPS+FJ0NB4D8yKJd0dRK+oRH4nI7jqkIOV4X1fDlGtTmvTD7ttqj0
         HkqE+xFqgfA61AEAC7QYVGk1cTAMbaJ3FZLdpoN3GZ2M+nngfbQdyXYBGL5N3QP+XK0h
         jVdHv/9jIznrIxuOdqAFm5hX+F5Zsji+Vr3VVof4WbE/vCxH5TDqDsQdDXSvXoyLkfNh
         3r8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LYJ67wF71BcvO8uwmwy3ELqCWCBu6XNQ28q/rdgvWwE=;
        b=4S9xWSufrm54ZSCjShLndTkLzzvnqGKiAkzYJFJEO6YXj7deu5j/u+Y3uO9KGm99nb
         4mN43gStW0Cit64lqgS2ITAtLgs6tialrJe1HjsJ+oY9i7VySaJfrQj5VI3v8pzvp7pD
         7FtR5dINM8C5xYFKcNT6M8t+gejH3a7mEBYOVY0yj72EzKmKZSu0OTUL+kRzJAhf4/ox
         KElF1AOVrnuoRbwmRYaOspuwezl39gSmNdttcrgBy82mBdK4LwbEHzo/uWszyGbqkyKo
         sWJIybUvj8hrURB+w+URGOyP0ba5NGSR7WrbeoFWggLkhBOlQVG4fy0AGhronqwIhCko
         UYGQ==
X-Gm-Message-State: ANoB5pkolWLMqYW1dlySV/ONTajeW8w4isTQTAYFbYSEe97CiSZ+RSVC
        amfLJ4JU/iWt2z/jYh6M6Tbs7w==
X-Google-Smtp-Source: AA0mqf43KIjDGaGB0pVG3YdJhNXRRLbEvrskIfFRe6WjPffa9ZDsSSfHhzpMw/UYkiwwF3z8aHFfTg==
X-Received: by 2002:a17:90a:4892:b0:216:92a9:fd50 with SMTP id b18-20020a17090a489200b0021692a9fd50mr31657292pjh.126.1669230195636;
        Wed, 23 Nov 2022 11:03:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e190-20020a621ec7000000b00561dcfa700asm13062762pfe.107.2022.11.23.11.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 11:03:15 -0800 (PST)
Date:   Wed, 23 Nov 2022 19:03:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y35ub4MnbcwcgVNp@google.com>
References: <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
 <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
 <9f1ea2639839305dd8b82694b3d8c697803f43a1.camel@intel.com>
 <Y35IW/PnbxinKHOL@google.com>
 <168ca2b3-ffac-31c4-0b83-2d0ee75f34a5@intel.com>
 <Y35aXX5b2Ed4vc6y@google.com>
 <2d99f823-09bb-ff51-0e71-f254cc6ad28b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d99f823-09bb-ff51-0e71-f254cc6ad28b@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022, Dave Hansen wrote:
> On 11/23/22 09:37, Sean Christopherson wrote:
> > On Wed, Nov 23, 2022, Dave Hansen wrote:
> >> There's no way we can guarantee _that_.  For one, the PAMT* allocations
> >> can always fail.  I guess we could ask sysadmins to fire up a guest to
> >> "prime" things, but that seems a little silly.  Maybe that would work as
> >> the initial implementation that we merge, but I suspect our users will
> >> demand more determinism, maybe a boot or module parameter.
> > Oh, you mean all of TDX initialization?  I thought "initialization" here mean just
> > doing tdx_enable().
> 
> Yes, but the first call to tdx_enable() does TDH_SYS_INIT and all the
> subsequent work to get the module going.

Ah, sorry, I misread the diff.  Actually applied the patches this time...

> > Yeah, that's not going to be a viable option.  Aside from lacking determinisim,
> > it would be all too easy to end up on a system with fragmented memory that can't
> > allocate the PAMTs post-boot.
> 
> For now, the post-boot runtime PAMT allocations are the one any only way
> that TDX can be initialized.  I pushed for it to be done this way.
> Here's why:
> 
> Doing tdx_enable() is relatively slow and it eats up a non-zero amount
> of physically contiguous RAM for metadata (~1/256th or ~0.4% of RAM).
> Systems that support TDX but will never run TDX guests should not pay
> that cost.
> 
> That means that we either make folks opt-in at boot-time or we try to
> make a best effort at runtime to do the metadata allocations.
> 
> From my perspective, the best-effort stuff is absolutely needed.  Users
> are going to forget the command-line opt in

Eh, any sufficiently robust deployment should be able to ensure that its kernels
boot with "required" command-line options.

> and there's no harm in _trying_ the big allocations even if they fail.

No, but there is "harm" if a host can't provide the functionality the control
plane thinks it supports.

> Second, in reality, the "real" systems that can run TDX guests are
> probably not going to sit around fragmenting memory for a month before
> they run their first guest.  They're going to run one shortly after they
> boot when memory isn't fragmented and the best-effort allocation will
> work really well.

I don't think this will hold true.  Long term, we (Google) want to have a common
pool for non-TDX and TDX VMs.  Forcing TDX VMs to use a dedicated pool of hosts
makes it much more difficult to react to demand, e.g. if we carve out N hosts for
TDX, but only use 10% of those hosts, then that's a lot of wasted capacity/money.
IIRC, people have discussed dynamically reconfiguring hosts so that systems could
be moved in/out of a dedicated pool, but that's still suboptimal, e.g. would
require emptying a host to reboot+reconfigure..

If/when we end up with a common pool, then it's very likely that we could have a
TDX-capable host go weeks/months before launching its first TDX VM.

> Third, if anyone *REALLY* cared to make it reliable *and* wanted to sit
> around fragmenting memory for a month, they could just start a TDX guest
> and kill it to get TDX initialized.  This isn't ideal.  But, to me, it
> beats defining some new, separate ABI (or boot/module option) to do it.

That's a hack.  I have no objection to waiting until KVM is _loaded_ to initialize
TDX, but waiting until KVM_CREATE_VM is not acceptable.  Use cases aside, KVM's ABI
would be a mess, e.g. KVM couldn't use KVM_CHECK_EXTENSION or any other /dev/kvm
ioctl() to enumerate TDX support.

> So, let's have those discussions.  Long-term, what *is* the most
> reliable way to get the TDX module loaded with 100% determinism?  What
> new ABI or interfaces are needed?  Also, is that 100% determinism
> required the moment this series is merged?  Or, can we work up to it?

I don't think we (Google again) strictly need 100% determinism with respect to
enabling TDX, what's most important is that if a host says it's TDX-capable, then
it really is TDX-capable.  I'm sure we'll treat "failure to load" as an error,
but it doesn't necessarily need to be a fatal error as the host can still run in
a degraded state (no idea if we'll actually do that though).

> I think it can wait until this particular series is farther along.

For an opt-in kernel param, agreed.  That can be added later, e.g. if it turns
out that the PAMT allocation failure rate is too high.
