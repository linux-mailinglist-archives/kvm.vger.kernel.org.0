Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143455BECEC
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiITSkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 14:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiITSkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 14:40:09 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5202C6E2E2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:40:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c24so3295192plo.3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/DiWjb7VNp6NnqMqVkeacIID4EanwXZiP2GVnIDjepM=;
        b=dbSEoOGoBjfbP5cORYRAanCs0nsf0IlcEyje9M1XjryCAxb1CuUpoGTEkZG2isfiU7
         bGwknEWhQWqvl4BGW1ZykUulb1V0/fjHGtV/gAaW/a3NNpC7PqA+MtZYjzF87+auY1dQ
         dUeswiSUcMcwsDXpj6g1eofmzh5HnW4tAPRAjgUJl0/mnvh4XkwM/noIwLcP1wSQUeHv
         1w5P78p5KEu2q604OATMyObCOTjNg/qxy/0Uj+93QrLSRY8vxWwjixbe/B1cwVrPQ/3l
         4OqL5oRTLs2z+K2JggQ/llFODQxzrBL9X44GH9pWCBw+bUxQSqP8QcFg3o4iTkd1tFrf
         yrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/DiWjb7VNp6NnqMqVkeacIID4EanwXZiP2GVnIDjepM=;
        b=isS8St1DJGFnHy4gSLFux+RrSo3iBvEr1a8kFx38HZHezqipnkGtvqVbQ8Wg/rj/vt
         F1I7Zw8oOdxdfjOG5W0AgpZiIxWhgNeZEQ87TP960ixmIqHsll9MXhIIVI06Ldz3fWk0
         OPJolxc5pl/lHFEiSICeLzpFBkdrVbreMwfXegAeFqwqPl37ss/ugmJwVFZ/AUTRhnm/
         rEkeD77u+o41B26HHBxBMaJNlK2fWyj8HvP16e7GOXxPiB/519Sv1EKLCyjqtyypt1OO
         WWHGhJMcr/vnKDaDpn9NkWHbdXim61mjdmru7bZJqMaZnkRY/tS6Dx8rhNah1zXTjTWb
         WonQ==
X-Gm-Message-State: ACrzQf1Z2UiwWL0JM9ayjwmbLUR/b5l/YO96JfuZpYUyhwPlgMT4YfUh
        iTSOk3xKBGZS69+2GFJleEJOZw==
X-Google-Smtp-Source: AMsMyM60ARJVl3WTxhTkeVBFE7UvvwIfglRK/e87tP+10Q6XQNwL6778c8fIBfL5nvZYJI71KmdOpA==
X-Received: by 2002:a17:902:cccc:b0:178:a9b3:43e6 with SMTP id z12-20020a170902cccc00b00178a9b343e6mr949541ple.92.1663699207698;
        Tue, 20 Sep 2022 11:40:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 9-20020a621409000000b0053e6eae9668sm257638pfu.2.2022.09.20.11.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 11:40:07 -0700 (PDT)
Date:   Tue, 20 Sep 2022 18:40:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v7 08/13] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <YyoJA7gjEaSiGwFi@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-9-ricarkol@google.com>
 <YyoBUcSD6ZyxKxza@google.com>
 <YyoFBBn9uevAkIHT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyoFBBn9uevAkIHT@google.com>
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

On Tue, Sep 20, 2022, Ricardo Koller wrote:
> On Tue, Sep 20, 2022 at 06:07:13PM +0000, Sean Christopherson wrote:
> > On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > > The previous commit added support for callers of ____vm_create() to specify
> > 
> > Changelog is stale, ____vm_create() no longer takes the struct.
> > 
> > Side topic, it's usually a good idea to use "strong" terminology when referencing
> > past/future changes, e.g. if patches get shuffled around for whatever reason,
> > then "previous commit" may become stale/misleading.
> > 
> > It's fairly easy to convey the same info ("something happened recently" or
> > "something is going to happen soon") without being so explicit, e.g.
> > 
> >   Wire up common code to use the appropriate code, page table, and data
> >   memmslots that were recently added instead of hardcoding '0' for the
> >   memslot.
> > 
> > or
> > 
> >   Now that kvm_vm allows specifying different memslots for code, page
> >   tables, and data, use the appropriate memslot when making allocations
> >   in common/libraty code.
> > 
> > > what memslots to use for code, page-tables, and data allocations. Change
> > > them accordingly:
> > > 
> > > - stacks, code, and exception tables use the code memslot
> > 
> > Huh?  Stacks and exceptions are very much data, not code.
> >
> 
> I would *really* like to have the data region only store test data. It
> makes things easier for the test implementation, like owning the whole
> region.

That's fine, but allocating stack as "code" is super confusing.

> At the same I wanted to have a single region for all the "core pages" like
> code, descriptors, exception tables, stacks, etc. Not sure what to call it
> though.

Why?  Code is very different than all those other things.  E.g. the main reason
KVM doesn't provide "not-executable" or "execute-only" memslots is because there's
never been a compelling use case, not because it's difficult to implement.  If KVM
were to ever add such functionality, then we'd want/need selftests to have a
dedicated code memslot.

> So, what about one of these 2 options:
> 
> Option A: 3 regions, where we call the "code" region something else, like
> "core".
> Option B: 4 regions: code, page-tables, core-data (stacks, exception tables, etc),
> test-data.

I like (B), though I'd just call 'em "DATA" and "TEST_DATA".  IIUC, TEST_DATA is
the one you want to be special, i.e. it's ok if something that's not "core" allocates
in DATA, but it's not ok if "core" allocates in TEST_DATA.  That yields an easy
to understand "never use TEST_DATA" rule for library/common/core functionality,
with the code vs. page tables vs. data decision (hopefully) being fairly obvious.

Defining CORE_DATA will force developers to make judgement calls and probably
lead to bikeshedding over whether something is considered "core" code.
