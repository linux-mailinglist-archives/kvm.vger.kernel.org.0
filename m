Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405264B8FE0
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 19:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbiBPSKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 13:10:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237439AbiBPSKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 13:10:30 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8F52A4A26
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 10:10:17 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so3398104ooi.7
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 10:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zVC5cj0z6rMQpOyPOmFfrF76NsP0MR7V60Bxrd230h8=;
        b=q8IQlHrCXptsSphCoGIR7Lz/Qw8ySxmbDGAVRO4mPP3/HsDpbPi0dH6R3rZYb7CTbj
         ou7qsm3xMtjsRpCI7hDfZe5dyYBshj3mDeWQC7MGXKrucSIYTX76I/w6j9ZQoglE3qxn
         gGBRb9lbvPw3ptllWGR3TWspruFJMRtoFGJ/U0db7bpKlTWzSez5629Z3SueBg9xkBMJ
         +GtzU0/ZCH0ySgTz3rqladIHD+XSurzIcGCEmkvvsTVYnbieK23gTzKm6ccFvlyYnoiR
         CHg3CgJHqqg/TT5WbA3KtwepYNaqP3kJN84qNyLMIe8KnoTBReIZInqK3NGQm+bbHuW7
         Y3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zVC5cj0z6rMQpOyPOmFfrF76NsP0MR7V60Bxrd230h8=;
        b=THBCT2FCFP9xyaiosNp2YWygFL9ScwGhh7UO/mbqffHtEM7Fm9mMS4E4yI7SDvtKqF
         EcgqoK0FxwyDgk1VH0BuPhaXSWqfwzQ6J3Dm2y076Nbj6r2/4+0y/VPkXUJqES18x4hB
         hlX8ebIeej2BMQj6S9suTvF9pjpumZr418jeJXHXhqXPeAf600iNWnAqtDX2aBjSN4xq
         Y48MpP63g7qZJGB/9Z0S/PbdEdfcc2YiuKInkQc4B6ClUp2QW3Y7GRqO68ka3u4uqqpY
         C/lBnJf9uw4EM296NiEPuqrq/Y5Ipk+dYhJViynw7Mjq3/2yrk+x7aFxxWS6Z483dKIA
         LHQA==
X-Gm-Message-State: AOAM531QEZPiwgIB69mBH4N5e1qXMEOxwVSPOLHBdTQS92QgY1r1wFRR
        R69KYEYvuK4JDNelYG4O7R9B3Y2mYFJo5tZ+DYzYdw==
X-Google-Smtp-Source: ABdhPJx+8UjiPN1CieY4Xi5pUk7u/5mk2xIt09T8qbul+0tYqHo1/KGJJDhsJ9CEW8caQBqx6OCrmVhxg6tElA76mdM=
X-Received: by 2002:a4a:5596:0:b0:2dd:bb93:8800 with SMTP id
 e144-20020a4a5596000000b002ddbb938800mr1290780oob.85.1645035016433; Wed, 16
 Feb 2022 10:10:16 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com> <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com> <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com> <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com> <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
 <6afcec02-fb44-7b72-e527-6517a94855d4@linux.intel.com> <CALMp9eQ79Cnh1aqNGLR8n5MQuHTwuf=DMjJ2cTb9uXu94GGhEA@mail.gmail.com>
 <2180ea93-5f05-b1c1-7253-e3707da29f8c@linux.intel.com> <CALMp9eQiaXtF3S0QZ=2_SWavFnv6zFHqf_zFXBrxXb9pVYh0nQ@mail.gmail.com>
 <8d9149b5-e56f-b397-1527-9f21a26ad95b@linux.intel.com> <CALMp9eTqNyG-ke1Aq72hn0CVXER63SgVPamzXria76PmqiZvJQ@mail.gmail.com>
 <31cd6e81-fd74-daa1-8518-8a8dfc6174d0@gmail.com>
In-Reply-To: <31cd6e81-fd74-daa1-8518-8a8dfc6174d0@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Feb 2022 10:10:05 -0800
Message-ID: <CALMp9eTrKmtP4BHxBNvyG9+bhOAd1jofx0rQz0rF=MtaoShb=w@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     "Liang, Kan" <kan.liang@linux.intel.com>,
        David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Feb 15, 2022 at 11:36 PM Like Xu <like.xu.linux@gmail.com> wrote:

> Hardware resources will always be limited (the good news is that
> the number of counters will increase in the future), and when we have
> a common need for the same hardware, we should prioritize overall
> fairness over a GUEST-first strategy.

The bad news about the new counters on Intel is that they are less
capable than the existing counters. SInce there is no bitmask for GP
counters in CPUID.0AH, if you give 4 counters to the guest, then the
host is stuck using the less capable counters.

Overall fairness is definitely not what we want. See the other thread,
which has a proposal for a more configurable perf subsystem that
should meet your needs as well as ours.

Can we move all of this discussion to the other thread, BTW?
