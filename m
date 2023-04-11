Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB91B6DE061
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 18:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjDKQDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 12:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjDKQC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 12:02:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC0AF9
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 09:02:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 202-20020a2502d3000000b00b8d404ac555so11806324ybc.14
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 09:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681228974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dAeE7rBx2LrEXGBOeJAa11rA6LzPuJMSc3yrCGL+cOo=;
        b=yHKE0ADk4mlLhhfRhtgCadpVkMpvaHdD8O+iQcvjrzCzWiWCoMxJ5B6WSy8oSIrtU+
         86IzlzFKFuCL/splmCmz4Y+fXbPQeHRrrVeQ+fp1Zod8GOX1yf6SIb2XwpKJF2DaXbiH
         addi8Cj3zaUQD9mEDa5w9UMN9fbhWcC0M8q3n01RY8du83aaL27mCvHpFnmkP4CPdio+
         RG5//irHEyT9DFgwyTszL4Au6tMwBD4ko1UI3T5Ti+vyGLSb50Fzz/L9e+R+6H3pfWE4
         cjjomGR/siYxw8Zw1Vi7iFRkAD6mV5w3EPJjtgz1yxif0YQZAHJlSKHB8MoMvYIQ8xCs
         i6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dAeE7rBx2LrEXGBOeJAa11rA6LzPuJMSc3yrCGL+cOo=;
        b=mj7Y2FwNJ1EC5OFkrYQCijB8dTaBctdCL69yE86HxIk5llN5NWxkXL4HsUju6IzGTx
         V1rZ2gsMVkGkaoW5c5A3nYv+jfLuXKLegJO1qDcM203UquFOpwfkz/8o0fhFMCnlK6LN
         Q1UtaimiUzyqSV40KWzSnqdkqCPYGfTqxJcLlYlEav/Um5LQRwPmT3cm8bA8K8Y5WSzB
         Fok38ZBuhwD9rACG9+VEmUKvljhzm0sSvGaVgZCsPt3tMx7mwk+Mb1q4WonSd5sFLMIm
         356g2bb3ISEo3V2XsvzEEGSZeufjuDqhX7AZ82k5GdxynRU1Z+LVfmVHuWYWgTNiRj3p
         zHKQ==
X-Gm-Message-State: AAQBX9dYRMIL5K1vDCyNdb2+/yJjfiPHF+J9EZkboHqh80zQNDb12QT3
        OOYT+hy/H61T3U+0S2jwPcbXpaqXBdQ=
X-Google-Smtp-Source: AKy350bPU43l2NGxsAIr+vg/0jzFplV883M5PQxzo3Pp2tOzb6IG6EspbBN7X/pTYgjclcvEKd4crZlm/tg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c9a:b0:533:a15a:d33e with SMTP id
 cm26-20020a05690c0c9a00b00533a15ad33emr9641481ywb.5.1681228974368; Tue, 11
 Apr 2023 09:02:54 -0700 (PDT)
Date:   Tue, 11 Apr 2023 09:02:52 -0700
In-Reply-To: <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
Mime-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com> <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
 <ZDSa9Bbqvh0btgQo@google.com> <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
Message-ID: <ZDWEgXM/UILjPGiG@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023, Jeremi Piotrowski wrote:
> On 4/11/2023 1:25 AM, Sean Christopherson wrote:
> > On Wed, Apr 05, 2023, Jeremi Piotrowski wrote:
> >> On 3/7/2023 6:36 PM, Sean Christopherson wrote:
> >>> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
> >>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
> >>> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
> >>> happens to get lucky and not run afoul of the underlying bugs.  The revert appears
> >>> to be reasonably straightforward (see bottom).
> >>
> >> Hi Sean,
> >>
> >> I'm back, and I don't have good news. The fix for the missing hyperv TLB flushes has
> >> landed in Linus' tree and I now had the chance to test things outside Azure, in WSL on my
> >> AMD laptop.
> >>
> >> There is some seriously weird interaction going on between TDP MMU and Hyper-V, with
> >> or without enlightened TLB. My laptop has 16 vCPUs, so the WSL VM also has 16 vCPUs.
> >> I have hardcoded the kernel to disable enlightened TLB (so we know that is not interfering).
> >> I'm running a Flatcar Linux VM inside the WSL VM using legacy BIOS, a single CPU
> >> and 4GB of RAM.
> >>
> >> If I run with `kvm.tdp_mmu=0`, I can boot and shutdown my VM consistently in 20 seconds.
> >>
> >> If I run with TDP MMU, the VM boot stalls for seconds at a time in various spots
> >> (loading grub, decompressing kernel, during kernel boot), the boot output feels like
> >> it's happening in slow motion. The fastest I see it finish the same cycle is 2 minutes,
> >> I have also seen it take 4 minutes, sometimes even not finish at all. Same everything,
> >> the only difference is the value of `kvm.tdp_mmu`.
> > 
> > When a stall occurs, can you tell where the time is lost?  E.g. is the CPU stuck
> > in L0, L1, or L2?  L2 being a single vCPU rules out quite a few scenarios, e.g.
> > lock contention and whatnot.
> 
> It shows up as around 90% L2 time, 10% L1 time.

Are those numbers coming from /proc/<pid>/stat?  Something else?

> I don't have great visibility into L0 time right now, I'm trying to find
> someone who might be able to help with that.
> 
> > 
> > If you can run perf in WSL, that might be the easiest way to suss out what's going
> > on.
> 
> I can run perf, what trace would help?

Good question.  I'm not exactly a perf expert and almost never do anything beyond
`perf top`.  That's probably sufficient for now, I really just want to confirm that
L1 doesn't appear to be stuck, e.g. in KVM's page fault handler.

> The results are the same for both branches, and it does look like this affects AMD and
> Intel equally.

Nice.  I have Intel hardware at home that I'll try to repro on, though it will
be several weeks until I can dive into this.

> So seeing as this will likely take a while to figure out (and I know I won't be able to
> spend too many cycles on this in the next few weeks), what do you think of a patch to
> disable tdp_mmu in this configuration (for the time being?).

I don't particularly love the idea of disabling the TDP MMU without having the
slightest clue what's going wrong, but I'm not totally opposed to it.

Paolo, any thoughts?  You have far more experience with supporting downstream
consumers of KVM.

> Something else I've been wondering: in a KVM-on-KVM setup, is tdp_mmu used in both L0
> and L1 hypervisors right now?

By default, yes.  I double checked that L2 has similar boot times for KVM-on-KVM
with and without the TDP MMU.  Certainly nothing remotely close to 2 minutes.
