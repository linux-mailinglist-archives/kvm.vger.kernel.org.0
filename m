Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0507B5BED36
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 20:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiITS5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 14:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiITS5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 14:57:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B827436D
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:57:17 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t3so3343946ply.2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=qR+LuVTt7SenxWyTQj9QGBqupmm5d3dwuEs9Y271sKg=;
        b=kLhljSrt+E5ElK+0GjWZ/EUOZhAbmVexhZGYPz8vKbKrviJoSNR3Eoc9pIvFte4Kbb
         wzOWaqd0JlPZ90KlGJMw3xE+AUxywnTir8Oo2PCvXlybaTVkPAg7SM97GzxGdUyK6Wwg
         C1STJo8BddmOVLpOTzsjFN0j3EGIppiHBhazj2fj7BOxrjPgKcB1jI/iP7xl4NYXfBlC
         b27I8S/hwPDlbnLOFPBjg4wzQlIqkKiOfPrF5P46v59tmAEBkTzUwngSXAphqDDp6qRs
         DSI4OIQKxEOqdb3B4LfUWyLE0rZKKxe/Afg/jR+/MBBRrrVgkeBHlyQ+tuEcrDYQ3YG2
         twTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qR+LuVTt7SenxWyTQj9QGBqupmm5d3dwuEs9Y271sKg=;
        b=4YtaGr56t90NJ8SqyLgprVanqSpCxWD8IWW7nK17g+fWSK29fNbCayygia8uk9u1ey
         zNgeuh1AlEpFPywPthSR+BoKonxR/ZbV+PidPwYRwq8YdqC7tn5ir2gywa7yV2JzD4Il
         nn2nEoEPkfbiRp4FMy8vY2YXpY2r731zdjiV9qnc3uShXx3lbRksoxcEwmsIVgetCUkk
         GY20R3Le+Ur+CNepbVPwQVx6cojV6G8Vo5/9CqJ1Hy5XlmxpTx1rFLVyz0tucvSTZlAI
         qJ90kS5V/ulUaGkhylQNtqxDeYuaZupvXJI33ZuEVK4qVpYx3m4sBd3cDbHCGTDn4UON
         HGJA==
X-Gm-Message-State: ACrzQf02q9cVCgSpRrf22rI5djaT73SdmlVgPOsGG/FKqIsyx3MjejOX
        auxz5ZpI+7eKXKADmlTs9purug==
X-Google-Smtp-Source: AMsMyM7bb7yxnYsMkhRd0wVvY5A8h/96nA7mT3fFI2aAXX3+5hVZrHo5C00JnYuUPiNzko1xnDz3qA==
X-Received: by 2002:a17:902:f550:b0:178:5b6a:3a1c with SMTP id h16-20020a170902f55000b001785b6a3a1cmr1007667plf.36.1663700236828;
        Tue, 20 Sep 2022 11:57:16 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id e1-20020a17090301c100b00172cb8b97a8sm281881plh.5.2022.09.20.11.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 11:57:16 -0700 (PDT)
Date:   Tue, 20 Sep 2022 11:57:12 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v7 08/13] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <YyoNCMmQ0cYzYQIy@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-9-ricarkol@google.com>
 <YyoBUcSD6ZyxKxza@google.com>
 <YyoFBBn9uevAkIHT@google.com>
 <YyoJA7gjEaSiGwFi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyoJA7gjEaSiGwFi@google.com>
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

On Tue, Sep 20, 2022 at 06:40:03PM +0000, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > On Tue, Sep 20, 2022 at 06:07:13PM +0000, Sean Christopherson wrote:
> > > On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > > > The previous commit added support for callers of ____vm_create() to specify
> > > 
> > > Changelog is stale, ____vm_create() no longer takes the struct.
> > > 
> > > Side topic, it's usually a good idea to use "strong" terminology when referencing
> > > past/future changes, e.g. if patches get shuffled around for whatever reason,
> > > then "previous commit" may become stale/misleading.
> > > 
> > > It's fairly easy to convey the same info ("something happened recently" or
> > > "something is going to happen soon") without being so explicit, e.g.
> > > 
> > >   Wire up common code to use the appropriate code, page table, and data
> > >   memmslots that were recently added instead of hardcoding '0' for the
> > >   memslot.
> > > 
> > > or
> > > 
> > >   Now that kvm_vm allows specifying different memslots for code, page
> > >   tables, and data, use the appropriate memslot when making allocations
> > >   in common/libraty code.
> > > 
> > > > what memslots to use for code, page-tables, and data allocations. Change
> > > > them accordingly:
> > > > 
> > > > - stacks, code, and exception tables use the code memslot
> > > 
> > > Huh?  Stacks and exceptions are very much data, not code.
> > >
> > 
> > I would *really* like to have the data region only store test data. It
> > makes things easier for the test implementation, like owning the whole
> > region.
> 
> That's fine, but allocating stack as "code" is super confusing.
> 
> > At the same I wanted to have a single region for all the "core pages" like
> > code, descriptors, exception tables, stacks, etc. Not sure what to call it
> > though.
> 
> Why?  Code is very different than all those other things.  E.g. the main reason
> KVM doesn't provide "not-executable" or "execute-only" memslots is because there's
> never been a compelling use case, not because it's difficult to implement.  If KVM
> were to ever add such functionality, then we'd want/need selftests to have a
> dedicated code memslot.
> 
> > So, what about one of these 2 options:
> > 
> > Option A: 3 regions, where we call the "code" region something else, like
> > "core".
> > Option B: 4 regions: code, page-tables, core-data (stacks, exception tables, etc),
> > test-data.
> 
> I like (B), though I'd just call 'em "DATA" and "TEST_DATA".  IIUC, TEST_DATA is
> the one you want to be special, i.e. it's ok if something that's not "core" allocates
> in DATA, but it's not ok if "core" allocates in TEST_DATA.  That yields an easy
> to understand "never use TEST_DATA" rule for library/common/core functionality,
> with the code vs. page tables vs. data decision (hopefully) being fairly obvious.
> 
> Defining CORE_DATA will force developers to make judgement calls and probably
> lead to bikeshedding over whether something is considered "core" code.

Sounds good, Option B then (with code, pt, data, test-data).

Thanks,
Ricardo
