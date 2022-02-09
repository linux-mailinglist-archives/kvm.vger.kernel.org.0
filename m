Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027304AFD7F
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 20:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbiBITay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 14:30:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbiBITav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 14:30:51 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D066E016D9D
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 11:30:45 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id x193so3642826oix.0
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 11:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udo96sXO56wK/1rXVVyyNGXKmUu/FDGQZPSLzL5BLp0=;
        b=EXUI7Lg3XaAXYffEBZUy8dtUKnQhy8uj6DvNscesHGGYBhASi6E0GIM+uqHlM11z3j
         aGPKpmtalc/eXIw4T9adj6+Uqbm1nj0EkFL/Vq3HEkTG+DX9mj1dXNCfsvj4rCi1L1EE
         3q6TJKxY+zjm7KsvJaG7FeFMtatC/woV5savK6V8uzpnBmoe93T8Jya2aczCu1f+lpww
         dxmCY8b7IWAtUHkeBDuJR9MIa/QkuP6HCo7bA3MS/AQTlYmQc+P6MPsoVAle7ko10lKN
         GmPSVZZV0uBVQ7oMexvaDTFrqF44/FOAo0X9FT+qCmNrV8Va7YH/6RuYGlZ0MgRMIJND
         m0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udo96sXO56wK/1rXVVyyNGXKmUu/FDGQZPSLzL5BLp0=;
        b=cUFK2m36sfHSBwyonLzp/kdTP5x7OgDalF2bexPYEGlsy+2Ry1dqAUgnZThLc4o9tB
         2aSjXFKgtVaI2Bc+imW3Zj7+pJsb4Ha37MA6V+lglElwOTsQUbAvzGk+wBxv0YN7SIYy
         mUTW0dZvgJy1o8v1FCVNM5Je4Ejw7KMakQfUK0y3+sABCm+q40HeZtBnp4uz9Ro6RJoR
         raL+wBe7BK24n5E7++Q3T6EtH2A4oBHu5G089QPIgT/CknFgLpyrIUH3OZ8Z2raWZR3b
         /POlAlYsA0MSKq27pAo+rI7img0M2EK5P1VEH4lMplOjVI7ZJMpsPeodQjo16HFD3fOC
         CuaA==
X-Gm-Message-State: AOAM533/UmzGS+O5XGgAMjRBtNN80drW21jj9MBJ4CYdFaqpwaQvD+We
        JE2cV4FNWm9zQ/b4jL5WrHx1u1LDv68tiGBdBQka4ZpYsapctCED
X-Google-Smtp-Source: ABdhPJw3idISQLewBGtwuj8yOwv4vTxXot9qcEiQpe/plBYQWcaqbqptHiJUan5olxRn+pLwu49kTzcDHQyFH+sTqFc=
X-Received: by 2002:a05:6808:21a5:: with SMTP id be37mr2169181oib.339.1644435044469;
 Wed, 09 Feb 2022 11:30:44 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com> <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
In-Reply-To: <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Feb 2022 11:30:33 -0800
Message-ID: <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        David Dunn <daviddunn@google.com>,
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

On Wed, Feb 9, 2022 at 1:00 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 5/2/2022 9:55 am, Jim Mattson wrote:
> >> +static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
> >>   {
> >> +       u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
> > On AMD, the event select is 12 bits.
>
> Out of your carefulness, we already know this fact.
>
> This function to get the perf_hw_id by the last 16 bits still works because we
> currently
> do not have a 12-bits-select event defined in the amd_event_mapping[]. The
> 12-bits-select
> events (if any) will be programed in the type of PERF_TYPE_RAW.

I beg to differ. It doesn't matter whether there are 12-bit event
selects in amd_event_mapping[] or not. The fundamental problem is that
the equality operation on event selects is broken, because it ignores
the high 4 bits. Hence, we may actually find an entry in that table
that we *think* is for the requested event, but instead it's for some
other event with 0 in the high 4 bits. For example, if the guest
requests event 0x1d0 (retired fused instructions), they will get event
0xd0 instead. According to amd_event_mapping, event 0xd0 is "
PERF_COUNT_HW_STALLED_CYCLES_FRONTEND." However, according to the
Milan PPR, event 0xd0 doesn't exist. So, I don't actually know what
we're counting.

At the very least, we need a patch like the following (which I fully
expect gmail to mangle):

--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -210,7 +210,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
        if (!allow_event)
                return;

-       if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
+       if (!(eventsel & ((0xFULL << 32) |
+                         ARCH_PERFMON_EVENTSEL_EDGE |
                          ARCH_PERFMON_EVENTSEL_INV |
                          ARCH_PERFMON_EVENTSEL_CMASK |
                          HSW_IN_TX |

By the way, the following events from amd_event_mapping[] are not
listed in the Milan PPR:
{ 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES }
{ 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES }
{ 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND }
{ 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND }

Perhaps we should build a table based on amd_f17h_perfmon_event_map[]
for newer AMD processors?
