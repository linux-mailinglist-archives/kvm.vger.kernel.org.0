Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD9558F820
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 09:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiHKHKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 03:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 03:10:36 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE693C16D;
        Thu, 11 Aug 2022 00:10:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id fy5so1151595ejc.3;
        Thu, 11 Aug 2022 00:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=dAhd4gEM83PA+rHnY8fu6knzzWteqcqTJGT3QcBl8QE=;
        b=Km1lkPjvhsX3hD9bH5P8eLDqvoYFA072dV412cZkbgsKPw6Ipm62uSjMiQfigVpLqs
         WzySjm4TE9UYFBHJeURL7y5srb/0OudOFVSoCrkHywIYOYFNhjiN1HG7sU3Ek1KATgVs
         5TlO8dedoHQfNN32JMsYI3A0GXVzBzQXKK8SB78TI111r3YiXwg30/T1dIvmiy2Hb/YU
         E4fNUFyyCzSgGGmw+RnteI6hJEee1RvX5xX9JcRvKiSXW6ZYsuFRG1xQTqgKNEcXx246
         Qpx0xk7VpvkzPnG5C7KmEizPm7moymbeZK1KaM1hDetZH13oEGezty0RgAS5vsnTcPZE
         6oog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=dAhd4gEM83PA+rHnY8fu6knzzWteqcqTJGT3QcBl8QE=;
        b=6qKDuVK0DuaG7LjwR7sHiNFMGihjzr/PhdEYFXgdPAcCDQJZE/bOmXevl+5ZhupxZF
         BiPmMmJ4XzWaT4Fv92vDKz1d2mYeLjV4KFLXMxxbd4WOGH7NKJOvnPTm4vbI1YOnWhg5
         IDF7Lmbrxqe0WZQaH2mYWe+LVwYF2ULlHVPlK0KvEeJO0Tcyz+wNsyTnvpm+5wpkUNew
         BSMgofwRCFcVUjJUQ0LC7QRLfl5bl7cfd4NoN1FINRS9yPA3S1FG2dCycjvLxsGTlfPC
         TpuHzclaqktMZE8/DftH6XJ3BkjvJegU1SU9uD/9mqUHaPPSTs5tLEspWu1qwZlPhGuj
         nOdQ==
X-Gm-Message-State: ACgBeo26PKmUbGkGsiZ4Uhl09g59EtuZ0mOID/qqK4AKyjf9o9PsHaNc
        Cdwvtq7G0Mcem1VQSnPVadUKRNBMjIUEJwxlzxw=
X-Google-Smtp-Source: AA6agR5nBqaMJFYs0SBB45KqeECQOVqA6pq0EkPvjsNWhYPZ+PQVmOhArrAUNSjFRJQZCS4sxj8RtsRbFXBfuNvuzfY=
X-Received: by 2002:a17:907:a063:b0:730:750b:bb62 with SMTP id
 ia3-20020a170907a06300b00730750bbb62mr23113122ejc.612.1660201833037; Thu, 11
 Aug 2022 00:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220721103549.49543-1-likexu@tencent.com> <5e8f11ef-22ff-ee67-ed39-8e07d4ee9028@gmail.com>
In-Reply-To: <5e8f11ef-22ff-ee67-ed39-8e07d4ee9028@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 11 Aug 2022 15:10:20 +0800
Message-ID: <CANRm+Cwj29M9HU3=JRUOaKDR+iDKgr0eNMWQi0iLkR5THON-bg@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] KVM: x86/pmu: Fix some corner cases including
 Intel PEBS
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kindly ping, :)
On Tue, 2 Aug 2022 at 19:16, Like Xu <like.xu.linux@gmail.com> wrote:
>
> To catch up on the first -rc, ping beggarly and guiltily.
>
> On 21/7/2022 6:35 pm, Like Xu wrote:
> > Good well-designed tests can help us find more bugs, especially when
> > the test steps differ from the Linux kernel behaviour in terms of the
> > timing of access to virtualized hw resources.
> >
> > A new guest PEBS kvm-unit-test constructs a number of typical and
> > corner use cases to demonstrate how fragile the earlier PEBS
> > enabling patch set is. I prefer to reveal these flaws and fix them
> > myself before we receive complaints from projects that rely on it.
> >
> > In this patch series, there is one small optimization (006), one hardware
> > surprise (002), and most of these fixes have stepped on my little toes.
> >
> > Please feel free to run tests, add more or share comments.
> >
> > Previous:
> > https://lore.kernel.org/kvm/20220713122507.29236-1-likexu@tencent.com/
> >
> > V1 -> V2 Changelog:
> > - For 3/7, use "hw_idx > -1" and add comment; (Sean)
> > - For 4/7, refine commit message and add comment; (Sean)
> > - For 6/7, inline reprogram_counter() and restrict pmc->current_config;
> >
> > Like Xu (7):
> >    perf/x86/core: Update x86_pmu.pebs_capable for ICELAKE_{X,D}
> >    perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
> >    KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
> >    KVM: x86/pmu: Don't generate PEBS records for emulated instructions
> >    KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
> >    KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
> >    KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter
> >
> >   arch/x86/events/intel/core.c    |  4 ++-
> >   arch/x86/include/asm/kvm_host.h |  6 +++--
> >   arch/x86/kvm/pmu.c              | 47 +++++++++++++++++++++------------
> >   arch/x86/kvm/pmu.h              |  6 ++++-
> >   arch/x86/kvm/svm/pmu.c          |  2 +-
> >   arch/x86/kvm/vmx/pmu_intel.c    | 30 ++++++++++-----------
> >   6 files changed, 58 insertions(+), 37 deletions(-)
> >
