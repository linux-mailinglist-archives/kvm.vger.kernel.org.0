Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39AC4D8B35
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 18:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbiCNR6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 13:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbiCNR6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 13:58:17 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272DD3F32A
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 10:56:58 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id r11so19210438ioh.10
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 10:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xsL1yyPtJH82a/B6MBZL26Q4PHqCsWQNmYIJJchipuw=;
        b=KtqEQwoiSXyAB3K4bV435qjbFXJZkJJNQyB/cVy7lTZCWPCMP2gCAsuv8gd7ryVSiE
         bcsa7fl/aMf90imqBHODe+ZAIZE7CpC69Y40xpkKe5wSCRHZxp/H87xAcWvB4JNOXu3d
         bNiKKFNhApF15p3dDy5q41PwLrkWIsaQdJFqS+Bd6WyR58vyuWxz5OX3NZ1+tU7YGQr5
         Fb59HUD42e2h2poQpjhprRt/6U/KIh5FL3WH6ehqyhiCyYe6N8cpdfkgA+IbC2XAs0bj
         OviAyjxtZF9IUMY+WztYBO6Ch5ZhPXJmS14L+xPQWTWuZezSAPj7G3BqDsX6YMs15EZ4
         yLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xsL1yyPtJH82a/B6MBZL26Q4PHqCsWQNmYIJJchipuw=;
        b=mQ4FzjUbkVhVFdcVYA6D0ED1X6899NhGZJI32YV3aOLRSuw/Y3mSbzy323oDNr6fFX
         yNUJc8ZNxze2BncMT1h+n5NeqaIQfIfGCkJI/TlRPaws9tNp7Xh/moc4x5QjIQKFL8Ft
         z08FPsjdKvXPVtipbTCsSRB3fTZQatIt2jNZRQhP9LFbTb+PX1tjg81dylqBwdZtNnOu
         cDqFTJLCmvM7Li1sIUaAF6zFAVf4Ofqdc50FevWk5xYZsel1pQ1xfsLBYxFRWrONq74O
         TsOtm1OIQ7F1kcAP5dqP5hEtahLvz6YnpmiI4mNGvOFuheInG5S2zOOdAklh7IFTjBIQ
         zjLw==
X-Gm-Message-State: AOAM530WUiINufCXw3j12+3e06YNbpLUPuh/Lmfu0yx/l24KPiDAp7Wr
        Ghxp6+m/jH6fEomdodk2AoV+bQ==
X-Google-Smtp-Source: ABdhPJy6l5Ou9XQOSDEOcVNbiOD8lP+BMjp9ZgR//wgjY3OzFqL54o6tA6KnRImChbwn0iMz9SNzpw==
X-Received: by 2002:a05:6638:22c:b0:319:f4d2:9e06 with SMTP id f12-20020a056638022c00b00319f4d29e06mr8731004jaq.223.1647280617634;
        Mon, 14 Mar 2022 10:56:57 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id s12-20020a92cbcc000000b002bd04428740sm9419353ilq.80.2022.03.14.10.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:56:57 -0700 (PDT)
Date:   Mon, 14 Mar 2022 17:56:53 +0000
From:   Oliver Upton <oupton@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RFC PATCH 000/105] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <Yi+B5bZ1LpaNCUJT@google.com>
References: <20220311055056.57265-1-seanjc@google.com>
 <20220314110653.a46vy5hqegt75wpb@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314110653.a46vy5hqegt75wpb@gator>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 12:06:53PM +0100, Andrew Jones wrote:
> On Fri, Mar 11, 2022 at 05:49:11AM +0000, Sean Christopherson wrote:
> > First off, hopefully I didn't just spam you with 106 emails.  In theory,
> > unless you're subscribed to LKML, you should see only the cover letter
> > and everything else should be on lore if you want to pull down the mbox
> > (instead of saying "LOL, 105 patches!?!?", or maybe after you say that).
> > 
> > This is a (very) early RFC for overhauling KVM's selftests APIs.  It's
> > compile tested only (maybe), there are no changelogs, etc...
> > 
> > My end goal with an overhaul is to get to a state where adding new
> > features and writing tests is less painful/disgusting (I feel dirty every
> > time I copy+paste VCPU_ID).  I opted to directly send only the cover
> > letter because most of the individual patches aren't all that interesting,
> > there's still 46 patches even if the per-test conversions are omitted, and
> > it's the final state that I really care about and want to discuss.
> > 
> > The overarching theme of my take on where to go with selftests is to stop
> > treating tests like second class citizens.  Stop hiding vcpu, kvm_vm, etc...
> > There's no sensitive data/constructs, and the encapsulation has led to
> > really, really bad and difficult to maintain code.  E.g. Want to call a
> > vCPU ioctl()?  Hope you have the VM...
> 
> Ack to dropping the privateness of structs.
> 
> > 
> > The other theme in the rework is to deduplicate code and try to set us
> > up for success in the future.  E.g. provide macros/helpers instead of
> > spamming CTRL-C => CTRL-V (see the -700 LoC).
> 
> Ack to more helper functions. I'm not sure what the best way to document
> or provide examples for the API is though. Currently we mostly rely on
> test writers to read other tests (I suppose the function headers help a
> bit, but, IMO, not much). Maybe we need a heavily commented example.c
> that can help test writers get started, along with better API function
> descriptions for anything exported from the lib.
> 

+1. Definitely guilty of copy/pasting a test then tweaking to fit the
problem I'm trying to solve. A barebones example would be helpful.

Haven't looked at the patches yet, but one of my whines about the
selftests is that every test winds up explicitly handling exit reasons
that percolate up from the libraries. Perhaps some helpers around ABORTs
and the like would be useful (and maybe Sean already did this!)

> > 
> > I was hoping to get this into a less shabby state before posting, but I'm
> > I'm going to be OOO for the next few weeks and want to get the ball rolling
> > instead of waiting another month or so.
> 
> Ideas look good to me, but I'll wait for the cleaned up series posted to
> the KVM ML to review it. Also, I see at least patch 1/105 is a fix. It'd
> be nice to post all fixes separately so they get in sooner than later.
> 
> Oh, some of the renaming doesn't look all that important to me, like
> prefixing with kvm_ or adding _arch_, but I don't have strong preferences
> on the names. Also, for the _arch_ functions it'd be nice to create
> common, weak functions which the arch must override. The common function
> would just assert. That should help people who want to port to other
> architectures determine what they need to implement first. And, for
> anything which an arch can optionally adopt a common implementation,
> *not* naming the common function with _arch_, but still defining it as
> weak, would make sense to me too.

I think it may make more sense to only define optional functions as
weak and let the compiler do the screaming for the required ones. Only
discovering that functions are missing at runtime could be annoying if
you're cross-compiling and running on a separate host with a different
architecture.

--
Oliver
