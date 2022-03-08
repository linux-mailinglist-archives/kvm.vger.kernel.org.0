Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D5B4D1CF5
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348261AbiCHQPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348249AbiCHQPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:15:45 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722D550B3F
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:14:48 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id z8so15996998oix.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIifr3b2QdzGraVEgIab2CtnyH2GC+4PtqflIyd61Ic=;
        b=TNeI8aoAYP5NSnk1pt0TitmjMycf+hJOQWlu8NMS1/pYV3TYZ0CKN4QqDlYmaLG1S3
         wxf89ao5y6FNlcaMNJRSWAT8BoVZa+rNIUsBXImTbXNXVMZxu177cU18Q/VXBjiZ5IMj
         l9o/LXQ9TsHn5mij0AmnDbwqptPURfuVAsZD3C0SwFOD4qbZ4GmZP2SDlGtRHWEq1NAz
         +ao3jAK6lhVjB2I6wpsXxXJmpsHeBVauKJ3JJLwksGSHXYgf+bY142Uwpx85n+HRvHt6
         yKD61xLQBT7shDSiMgs311Hy/6Ax4CR6iTVUx4camFRQOEPAsMFgHWYMOmSHt+UbAJgy
         jK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIifr3b2QdzGraVEgIab2CtnyH2GC+4PtqflIyd61Ic=;
        b=oUbeRGZpXowT1T6BNSKf8UvC9Gu+ySlKwGXAlU67LKhJkVrJXedufRDKUb/KiDsd8j
         BoeplkONjuljw5WLwyx9S5dAiAlC9GZtpVuVDQK44sNrsJgwWL7Q5jYxv9qxyFCIYW3v
         r/Kyk9AxTVRtPQAp0R7XDMCaLPrxGI5YPYJD5/WzrrH6b63NEh14/AYi41MCXIIX2tZe
         pedCC7mtYrZFVqGIWW12BXeyqi2q8xA8x0vY2gTdlIJsNCbIBaOvh5p3TY/YDkpGtYFR
         W3qWa7xVV2TeBRa6HOqN5gGfLOAO0ny/68EpKbyk6r+3gouB0XngqG313FEs62G1wFid
         FuMA==
X-Gm-Message-State: AOAM530h1QZobsZRTEIH2Vxm8rd0JhJVdzt6wBxRxr2njccJvewQcfkT
        PK1UVk1mOcBLhBS3rRRnuI3WvxmtgnUtCohRcLiWAg==
X-Google-Smtp-Source: ABdhPJx7PCyaGd59lU7p8yow0KemQIdnHHEIkqyEGAdsW/PT4/CwGd2lPHkIlyofBfCJnLEOEfiZDTDMnp2aHt5EvTM=
X-Received: by 2002:a05:6808:1446:b0:2d5:281f:9cda with SMTP id
 x6-20020a056808144600b002d5281f9cdamr3108662oiv.13.1646756086855; Tue, 08 Mar
 2022 08:14:46 -0800 (PST)
MIME-Version: 1.0
References: <20220302111334.12689-1-likexu@tencent.com> <20220302111334.12689-13-likexu@tencent.com>
 <CALMp9eT1N_HeipXjpyqrXs_WmBEip2vchy4d1GffpwrEd+444w@mail.gmail.com>
 <273a7631-188b-a7a9-a551-4e577dcdd8d1@gmail.com> <CALMp9eRM9kTxmyHr2k1r=VSjFyDy=Dyvek5gdgZ8bHHrmPL5gQ@mail.gmail.com>
 <158bcefb-4087-c2a3-cfcf-e33ab53af649@gmail.com>
In-Reply-To: <158bcefb-4087-c2a3-cfcf-e33ab53af649@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 8 Mar 2022 08:14:36 -0800
Message-ID: <CALMp9eSvhcPcM4rh90BXV-K1SWUEFJr-7CkgdFgLFhhMT-VoSw@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] KVM: x86/pmu: Clear reserved bit PERF_CTL2[43]
 for AMD erratum 1292
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Mar 8, 2022 at 3:25 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 5/3/2022 3:06 am, Jim Mattson wrote:
> > We should continue to synthesize a #GP for an attempt to set "must be
> > zero" bits or for rule violations, like "address must be canonical."
>
> Actually, I do stand in the same position as you.
>
> > However, we have absolutely no business making up our own hardware
> > specification. This is a bug, and it should be fixed, like any other
> > bug.
> Current virtual hardware interfaces do not strictly comply with vendor
> specifications
> and may not be the same in the first step of enablement, or some of them may have
> to be compromised later out of various complexity.
>
> The behavior of AMD's "synthesize a #GP" to "reserved without qualification" bits
> is clearly a legacy tech decision (not sure if it was intentional). We may need
> a larger
> independent patch set to apply this one-time surgery, including of course this
> pmu issue.
>
> What do you think ?

The PMU issue needs to be fixed ASAP, since a Linux guest will set the
"host-only" bit on a CPU that doesn't support it, and Linux expects
the bit to be ignored and the remainder of the PerfEvtSeln to be
written. Currently, KVM synthesizes #GP and the PerfEvtSeln is not
written.

I don't believe it is necessary to fix all related issues at one time.
Incremental fixes should be fine.
