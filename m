Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13275642FD4
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiLESXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLESXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:23:16 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3EDD67
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 10:23:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d3so11610439plr.10
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 10:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wrG4WesnEhk5NLSq/YG3nhMzwwU7RaEXC9segHeDYJk=;
        b=OqMx52fMzis0wzRBGQKZSzSb3RlhV4y4sy4W7p/1W9GmNOf2pm9J+IGZbpD3Jlgw2e
         xd9iYfzm4xCxj3fw2IkRihO46FVYF1UMPfEoUXl6m+woYA0e0bnU6aW5PHwfs6OT7fQ7
         +7/U5XdjFccF7xEVN4ezPuqIqyrq1KIw71sAY8C5W1gXD+iJlT4SvPksyYQPmNzOVTkT
         FljZ+7EMIQGmdshWIs/8UHoedqGAti+FmBBSpaFflk6WGXooVdOWl49m2QVvnmKxfLVK
         l6L61r3MEiNIU2G7kBgup+QlvPYlH+nvpPu+Zuf/KYdcyQgKGRQVVsMJKq6SwyQ/giAN
         po7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wrG4WesnEhk5NLSq/YG3nhMzwwU7RaEXC9segHeDYJk=;
        b=pAiRrv4RiLTpYRs0VcUO5PibAe7uvAfzd3UISmxYc21iIxvjM19rzUdhNxdHmrj9LD
         RWGvJV0eu/CMcvINjj2cqEC5y6ibGzTottGS3u4ozgzyrdJW7m0WCXRPi9zvVPQqjHW0
         q1Hp9wElZlzSWzedsyHZmhXeHivcduqw5hGC9PULUHDHUvrKDUemSoSDHSpDLsI1sMz+
         mKew+yN1IYhovf3ppPbtLvX8YPs2RWmjNG2uqEhVvZqVOrGyekMTVIZVIFafoesNSwjj
         sdU+dNa4LevXmrXFgs83fe8+cx4NZLXsiwQLIhOundZx7nqyCdmysie4lUsaJ1nzdTCo
         d1PQ==
X-Gm-Message-State: ANoB5pliygrcp7KXwDpVbLfXrjqq7lhxVV+4A1EfNNhgawjm6D23mQ2t
        s6xqyk8u3QxBNeRNVB1wGmllSw==
X-Google-Smtp-Source: AA0mqf7klLfuhXgPALOW9jQYhcN6mrjnWU2ntGY2DimbKdA5/feviP88dW+9Ml8rQYDv59cM3adsyA==
X-Received: by 2002:a17:903:31d5:b0:188:5581:c8de with SMTP id v21-20020a17090331d500b001885581c8demr66215140ple.140.1670264594925;
        Mon, 05 Dec 2022 10:23:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f139-20020a623891000000b005746c3b2445sm10169977pfa.151.2022.12.05.10.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 10:23:14 -0800 (PST)
Date:   Mon, 5 Dec 2022 18:23:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
Message-ID: <Y443Du/lVJut4YoB@google.com>
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com>
 <Y44NylxprhPn6AoN@x1n>
 <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <CALzav=eFXqcFgbYi-6XpyE1Nfi7arADpOtYBPkEHn4AH9oP16A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=eFXqcFgbYi-6XpyE1Nfi7arADpOtYBPkEHn4AH9oP16A@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022, David Matlack wrote:
> On Mon, Dec 5, 2022 at 9:31 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > On Sat, Dec 03, 2022 at 01:03:38AM +0000, Sean Christopherson wrote:
> > > > On Thu, Dec 01, 2022, James Houghton wrote:
> > > > > == Problems ==
> > > > > The major problem here is that this only solves the scalability
> > > > > problem for the KVM demand paging case. Other userfaultfd users, if
> > > > > they have scalability problems, will need to find another approach.
> > > >
> > > > It may not fully solve KVM's problem either.  E.g. if the VM is running nested
> > > > VMs, many (most?) of the user faults could be triggered by FNAME(walk_addr_generic)
> > > > via __get_user() when walking L1's EPT tables.
> >
> > We could always modify FNAME(walk_addr_generic) to return out to user
> > space in the same way if that is indeed another bottleneck.
> 
> Scratch that, walk_addr_generic ultimately has a ton of callers
> throughout KVM, so it would be difficult to plumb the error handling
> out to userspace.

It would be easy enough to plumb a "fast-only" flag into walk_addr_generic().
