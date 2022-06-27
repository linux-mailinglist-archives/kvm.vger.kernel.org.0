Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929EC55CFBE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbiF0QYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239106AbiF0QYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:24:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8EDCE29
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:24:32 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r20so13850200wra.1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3xCqZKogDypv6eypnWAIX07mm+p6TcVFKXGmBz5uwGo=;
        b=EFJ93YBppveZN8tb8RoZSuAH5W5SG1LiH1nd2yGt5BUolxb7x2ATW1Kz7biQm14+S1
         UM+Fp8eufEM8rSzaN98Vxy+yjs/rNMirq3kcwGggDlKitVyql4aB21ps9KcBglapj9Ua
         1W4ZjfHFR1OX+l2hu2sbJa8kLFx8xcw+LngOMpTPoS5at+/yURveHnzp5IGPSJMu7ZvB
         x275CN6l1938KDghGgk+NqN925rKkvVMXE8N/H2EY4ZUpwt+isaWFqtc66lQKg5sW1P0
         qe563ZBGvDzi6k6E6WBMqiK4kFc+qfzpLTjoypM7LjJTmsiLm26bxb/pjD6ij7bCgcHB
         9Yqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3xCqZKogDypv6eypnWAIX07mm+p6TcVFKXGmBz5uwGo=;
        b=E0gROhBJYCGPwhVv0mt2r/oSrr12AcYHP8fK601+jNGzNj/wXiniCIFjtNWgtJkSLf
         e+uR3vEkaERSFRxuLd2MAasxjxHFh2qYYYYtSRkjUrVOBWDVE6Yng67fLrVGJnVOqJ+C
         Rpzl9/EnV47/sSqnJ2eO5j88uzoGrgQwAs3SulTo8Eq9tm6P7pmMqptFXzVyakx8ux5s
         da4jvRYXROQ+RWPRUbjGXeFOAEW5Xy2OFcWo1OSCEqNMB8T5QsYqzlAUEy0rtz80zLAR
         rBce84rGoF1dJqzb/Xt5rGJxTgF/1BJlzvCFhvnZ2Lb3HsFMu5QN1NIhedNijxxbbW2h
         Eu9g==
X-Gm-Message-State: AJIora9r9NlTprTOdW6vwOjXHYu24Dd6D9j9fVRWqhl8cfF2TELur18Q
        n+hG2oKB1mqz1Z/QGHgFC/wNbR0ECGeL5pmlCX9P5w==
X-Google-Smtp-Source: AGRyM1tEYhoQe960g1sn2OovJNLpmUQIbQxWnmCUUyO6DqjFG9AG5gJFJE0O7TF8AscROp1Q2QZs7ydLv2dJU1UWp8U=
X-Received: by 2002:a05:6000:a1e:b0:21b:8c8d:3cb5 with SMTP id
 co30-20020a0560000a1e00b0021b8c8d3cb5mr13353164wrb.372.1656347071360; Mon, 27
 Jun 2022 09:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com> <20220606222058.86688-2-yosryahmed@google.com>
 <YrnVxM/5KjVhkOnn@google.com>
In-Reply-To: <YrnVxM/5KjVhkOnn@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 27 Jun 2022 09:23:55 -0700
Message-ID: <CAJD7tkaMYhG7_AQgn6fLGFVuSB4wDpY_GzcvSS99tSzTUKFkTw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
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

On Mon, Jun 27, 2022 at 9:07 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > KVM mmu. This provides more insights on the kernel memory used
> > by a workload.
>
> Please provide more justification for NR_SECONDARY_PAGETABLE in the changelog.
> Specially, answer the questions that were asked in the previous version:
>
>   1. Why not piggyback NR_PAGETABLE?
>   2. Why a "generic" NR_SECONDARY_PAGETABLE instead of NR_VIRT_PAGETABLE?
>
> It doesn't have to be super long, but provide enough info so that reviewers and
> future readers don't need to go spelunking to understand the motivation for the
> new counter type.

I added such justification in the cover letter, is it better to
include it here alternatively?
or do you think the description in the cover letter is lacking?

>
> And it's probably worth an explicit Link to Marc's question that prompted the long
> discussion in the previous version, that way if someone does want the gory details
> they have a link readily available.
>
> Link: https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org

I will include the link in the next version.
Thanks!
