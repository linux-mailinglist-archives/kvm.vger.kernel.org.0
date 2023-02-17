Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A89569A4CF
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBQEUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBQEUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:20:35 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3634E3B879
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:20:33 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id m1so4318813vst.7
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EzJhoV3HmsUkNrfCb9SHGhf85+7gyTZEICckTTZh/aE=;
        b=guZJ0aqVsAObTjuj7XNytr+ADm4zAmp5kFomgta8H/V9agYhSTr6o1f5t6byBbQtNR
         LCahRg6zjHEs07Oc7PqjYUY/tAINKb6gCSN9SVVK1qv9xw3hIb0Lxv+hTjQxq2Dw515d
         YW8A97ln7/4+it2hWhQ+3h52ky8N9GgenEovFel6wIha3BRl6oiiTJWxaNnVSqqzZ5w7
         1EIkoExQzX+JQZiH1bjKl3VX3fzQM6zWgqS4n8HJiKZXfc6EP1cQInYk5aOULHFKvaee
         kU0uis/PgBthxAf5wR7/pAc24CoQ71uLazQep8X2hP8EbEgS5NpqiJEJCFkMqOBKm1zv
         Hrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EzJhoV3HmsUkNrfCb9SHGhf85+7gyTZEICckTTZh/aE=;
        b=3uIwpvmj+tR6JNoqEVTxuPCP0rObY9COPC/+sRuC+RRayEYJHORrRGeKPoIov4VRVH
         zCCapEGLK03aeo8jvhgE7giZ9o+D19kl6zhYcHBS/rO0DLJAnR7RW5qzv1xfkEYZC08H
         q1isZAj6othavrr8ZQR/5gXCba3NZcNm9ODzmP2+Qng2aS/UsoXUG/PxGPcfLTQ1m1f0
         O4xIwJKIofd+DadoRgrVEXKOF16IYsrBtjfnkjO9hGqkA/X5Vn4kOwiAMt2hqsniU5+f
         OLgyvD1/QLhdvzIZt3C+xzrCeuGtVh+QsoJ2+z697TFZ8Qs7dugaSKAqKXVX7RiGpp0n
         3xHQ==
X-Gm-Message-State: AO0yUKVJMFThdkZmMkyOQFD7uEskudbBZ+iAUfV7pBIacq/yylZuqxK9
        rORFg+11LkUU9JLDcAt/l/9rIo/MAyUPUZaM87oKCw==
X-Google-Smtp-Source: AK7set/C7m3gRJtF2smsD9KrApMl+5if6kuQRwt+IEmk635RYBoR+6RvbwCDqKIob+I+QiZWOyrqu86cui6jAk+Etew=
X-Received: by 2002:a67:cf47:0:b0:411:c1a0:c787 with SMTP id
 f7-20020a67cf47000000b00411c1a0c787mr1602398vsm.26.1676607632191; Thu, 16 Feb
 2023 20:20:32 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
In-Reply-To: <20230217041230.2417228-3-yuzhao@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 16 Feb 2023 21:19:55 -0700
Message-ID: <CAOUHufYsiFx=AqnZ6gDCjEHq4cN6XVXF6fPRvGpaXJbbmvoCPQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
>
> This patch adds kvm_arch_test_clear_young() for the vast majority of
> VMs that are not nested and run on hardware that sets the accessed bit
> in TDP MMU page tables.
>
> It relies on two techniques, RCU and cmpxchg, to safely test and clear
> the accessed bit without taking the MMU lock. The former protects KVM
> page tables from being freed while the latter clears the accessed bit
> atomically against both the hardware and other software page table
> walkers.
>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 27 ++++++++++++++++++++++
>  arch/x86/kvm/mmu/spte.h         | 12 ----------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 41 +++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+), 12 deletions(-)

Adding Sean and David.

Can you please add other interested parties that I've missed?

Thanks.
