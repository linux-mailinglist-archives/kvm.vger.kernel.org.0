Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2D368871C
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbjBBSvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjBBSvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:51:52 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12658A268
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:51:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 5so2827837plo.3
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=92s1J/v3u+gUuu9+JAVWjvaQldTTiVNdn4GiJVShZUo=;
        b=ZqfxJAUsCqlHXcL37UAiEULnvzmklsb5UqQ0hw1beNAz2Y7ROWpbgTK8dMEph7r/4b
         VLZVrTM8ZV8q+pTcMAw2NO+LDrK9nvlxLYfRsqKrMuFBkNKdbOFEO2caMIu28Kg7KUoz
         CiScaH2G/0GZDF6v0W3NVWxPajel2AGHRKiiC5l0ioQi112IQir10Qjkq9187jqFsqmt
         o6aoSViNyprb6p0ciNedLQ47nQvyjvIrE2wkaqJx/o3+L/pXvGluWKjaCukuk6sv0sxA
         sXnL10vplLObrdVtA7nBu/tpRCO425Wboe6UEXvkcSjrhOxaKyc/g3fW49Qh7LSq0yev
         nF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92s1J/v3u+gUuu9+JAVWjvaQldTTiVNdn4GiJVShZUo=;
        b=Va84ShEXSr5KNOMb1TG4Dh8rlcTA8l2e0q541P4+n7w1IcOoEgWV/WSCp7rU6kZkNW
         bfw7OvxR9a66BHEuwNPrqsQVIXVX9Zw60rt9MlufRsjPgeHoPME+7jtx84406X/A5pCn
         Q5IYfiylt4uYGbq6qvm+iSRupycjP1utR7Xp3u8UugBrEG9oiVb+tenJKINu9UcQ4xLG
         YV22CeiQpc6E7MVR/hPTEXOLi7s80oVPd2n5lFFEbTplUIQzbHUcYQaggvoxm4Vt5sg7
         1W9l5i4yOeHKzhgDOQdim+XEtHBWI9Z8NBlcbuWNcmwS39yLDGA6KceK/rI0+d+eCs/B
         6T9A==
X-Gm-Message-State: AO0yUKVLMXdS/gbMhENrImyLh8hEmWZAv7Wf/iGtDPag6cB3DteyqbyN
        +Jtt24kJdgW1SQckWrYFG7WslA==
X-Google-Smtp-Source: AK7set+HAtahAeEjYFdnIkDZh6suSe/pkdbewp9U1iXACabYX5zcuU+L6p/E1XQBosWsbCj4DtjMdw==
X-Received: by 2002:a17:902:9a47:b0:198:af4f:de0a with SMTP id x7-20020a1709029a4700b00198af4fde0amr1151plv.10.1675363911344;
        Thu, 02 Feb 2023 10:51:51 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s11-20020a056a00178b00b0059392f591b0sm17990pfg.53.2023.02.02.10.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 10:51:50 -0800 (PST)
Date:   Thu, 2 Feb 2023 18:51:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        m Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [Patch v4 12/13] KVM: selftests: Make vCPU exit reason test
 assertion common.
Message-ID: <Y9wGQx89zI3TMU1Y@google.com>
References: <20221212183720.4062037-1-vipinsh@google.com>
 <20221212183720.4062037-13-vipinsh@google.com>
 <Y9r0q9cuK/ifu+OW@google.com>
 <CAHVum0fEmEAQSxozb1BTTy-d3UGrsvhjt8V5FXQPrX5wOYqpPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0fEmEAQSxozb1BTTy-d3UGrsvhjt8V5FXQPrX5wOYqpPQ@mail.gmail.com>
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

On Thu, Feb 02, 2023, Vipin Sharma wrote:
> On Wed, Feb 1, 2023 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
> > I love the cleanup, but in the future, please don't squeeze KVM-wide changes in
> > the middle of an otherwise arch-specific series unless it's absolutely necessary.
> > I get why you added the macro before copy-pasting more code into a new test, but
> > the unfortunate side effect is that complicates grabbing the entire series.
> >
> 
> Make sense. So what is preferable:
> 1. Make the big cleanup identified during a series as the last patches
> in that series?
> 2. Have two series and big cleanups rebased on top of the initial series?
> 
> Or, both 1 & 2 are acceptable depending on the cleanup?

  3. Post the cleanup independently, but make a note so that maintainers know
     that there may be conflicts and/or missed cleanup opportunities.

#1 is rarely going to be the best option.  The big cleanup is going to necessitate
Cc'ing a lot of people that don't care about the base arch-specific changes, so
unless the base changes are one or two trivial patches, a lot of people end up
having to wade through a lot of noise.  And aside from annoying people, that also
makes it more likely that someone will overlook the cleanup.

As for #2 vs. #3, #3 is probably a better option in most cases.  For broad cleanups,
odds are very good that there will be other conflicts beyond just the changes _you_
have in-flight.  E.g. in this case, any new tests and/or asserts that are in-flight,
sitting in other trees, etc., will suffer the same fate.  I.e. whoever applies the
cleanup is going to need to resolve conflicts and/or look for other cleanup
opportunities anyways.  For a scenario like this, a way to make life easy for the
maintainer applying the cleanup would be to provide a script, e.g. single grep
command, to look for potential cleanup spots.  That communicates to the maintainer
that there may be silent "conflicts" and makes it easier for them to resolve such
conflicts.

Posting the cleanup separately means the two series/patches can proceed
independently, e.g. respinning one doesn't screw up the other, maintainers can
take the patches in whatever order they prefer, etc.

There are undoubtedly exceptions, e.g. if the resulting conflicts are really nasty,
but those should be few and far between.
