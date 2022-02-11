Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B9F4B2CA5
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351757AbiBKSQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:16:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352508AbiBKSQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:16:45 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69490D52
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 10:16:43 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id i10-20020a4aab0a000000b002fccf890d5fso11279939oon.5
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 10:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7am2ar4Jv8fZBmTwASlYhDJ4Y7/49oQSe2eExP9zIZU=;
        b=tV6B9cGyAIj4xKE9gDfUDb62Plp5+0MHQONcNIkkystkI8xA6ApPZ3IxdZahXC38MR
         JjNvqliZfVRPFBUwZZGmCfloaEUw6i3PtDwtFalhpGlzSN5uq92ivqlPSFwr9dLoLmM5
         xarJRSv2f5MpsqGfzwxnHS6wbo+5EXYekLLCidT+yLT3d3UGCy3Xc92cyX5cQs/n6lUL
         bzyeI7VEn46ZAgvG7eR+r4IUpMhPPngIbD7FHh/OSCosSI/gDsKD+4o+nNhfvgjqhj4I
         rlDcVnUjvXxyQySN2g4eXmYX7s2VH5boHVPx6/Bq1KYptPVGwRUBD8CHHVwAdiSCshii
         wQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7am2ar4Jv8fZBmTwASlYhDJ4Y7/49oQSe2eExP9zIZU=;
        b=n9Y0qalrsL4GWrELORUYQBAa9UwGOvXC4IiWOSjTvX8iAYwCls0EwAsP4dovIWPMmS
         NX5llMNbZTK3azn5dpT2mSrVE0r7lvI8ee+3NmOCMzByDKR0THhFaLvmtLfJ48xwsJ0G
         0+1AIVAqtDzsSfU1QvWrb0J9KkoKITnnb6A7BkXUb+GAMFfh9lYNMKa1ao3nLjuDh9NQ
         FlzYOsy9707jq9yOBk0KzdO2pkS0Ihrdafv+CXEXocgh+Ma9K+319QBaQ95zcqpf2wPT
         LI7FkXXBlml9PslTtQn2eGYQQ6ejITis6oyFAC58kmdUd0ooMj7D+h4FDCnMfwq11MRU
         kSCQ==
X-Gm-Message-State: AOAM532jxIwDmhb08gj9dBoTCN/dqrx0FvMrIUu8ikM2Z/QRf5Tm1EYs
        xmWSfvFn17znmEQ8IoNkXW2H6IRxcg+sQbYi6d1lvg==
X-Google-Smtp-Source: ABdhPJxcG1fEAXl5h/O+jzsLSvPdZ5W0LxowykxOy/bie7PdIQvEpr5tTlYRHjC0XyiWl8zfFnN1l6LHJWKZvWMQX+A=
X-Received: by 2002:a05:6871:581:: with SMTP id u1mr539489oan.139.1644603402484;
 Fri, 11 Feb 2022 10:16:42 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
 <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com> <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
 <3bedc79a-5e60-677c-465b-3bc8aa2daad8@gmail.com> <d4dae262-3063-3225-c6e1-3a8513a497ec@amd.com>
In-Reply-To: <d4dae262-3063-3225-c6e1-3a8513a497ec@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 11 Feb 2022 10:16:30 -0800
Message-ID: <CALMp9eShc-o+OZ3j4kDkTbXmY58wQu6Rq6qviZAHsDr4X21a5Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>,
        Stephane Eranian <eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>
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

On Fri, Feb 11, 2022 at 1:56 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>
>
>
> On 10-Feb-22 4:58 PM, Like Xu wrote:
> > cc Kim and Ravi to help confirm more details about this change.
> >
> > On 10/2/2022 3:30 am, Jim Mattson wrote:
> >> By the way, the following events from amd_event_mapping[] are not
> >> listed in the Milan PPR:
> >> { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES }
> >> { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES }
> >> { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND }
> >> { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND }
> >>
> >> Perhaps we should build a table based on amd_f17h_perfmon_event_map[]
> >> for newer AMD processors?
>
> I think Like's other patch series to unify event mapping across kvm
> and host will fix it. No?
> https://lore.kernel.org/lkml/20220117085307.93030-4-likexu@tencent.com

Yes, that should fix it. But why do we even bother? What is the
downside of using PERF_TYPE_RAW all of the time?
