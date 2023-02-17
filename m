Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9229369A4D3
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBQEWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBQEWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:22:06 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543A73A0BD
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:22:05 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id k4so4336255vsc.4
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DmQBbpAu6B0uYYhxH30aHdK9UMmXNgVHX14jvNOggZk=;
        b=tJA35Ofvs7OhFLQM4OAO9pyzBvthd1pHbKdaGQcRJ3YavWvQaShc7aTkBnKhHNN/qf
         71V0DM19hvtEjOHUzjLR2745KsM8dlyMKcd01CcQ+FwFzC7/bE1MPLr0cth7zPVN5t84
         xXJakn3yMkVRExor1tx6+hTzGcDc9X7aMCvaIxvranghfxdnSmz++u5JcY376v30Pvve
         cbEsgeTf3k8MLOzEzpPng3PoJj+Ma95D9fTXhjgzq7h+2JupaecZZY1EoqYZmXBd2Gl2
         pokR2z1r2mqfRnRHTWASeUWMVLlt4NHNRc3gZ0KfBJzISW6RhMZlmTLJmVp6kSJ54cKK
         2BCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DmQBbpAu6B0uYYhxH30aHdK9UMmXNgVHX14jvNOggZk=;
        b=x/O+VGGYZdsJ4cqxE+GAlTXvkOx8o2RmmZfF6rGfT9EVKXI6z9rKPw/A5yraviKsJU
         EsCewWz9IqnCb1BxomaBbtiSQEGC58ldmCe+IB1hdWCQ4vw0iQD3FMr7E/6EKSbGzT+7
         3kr9FQLtzRiozm8YaefHEz/FdtntYVe09gUP5icn87w5mCZxnCQcYwwqi5cIlVHHAEU6
         azNfKqT3GfapHi59EYnABbrIrtavHnrvN6NxPfPSf5iVyvlNngwIFLUvcaRv4H1CnED6
         gyX1vVd5eGkDrka3rPVbyJtk+VB86VJRdmxALqzlbhOPXoHXzKN4ZwCzU/0Ig1xElm3r
         WDOw==
X-Gm-Message-State: AO0yUKVEYQ5nR23OyQTVIDk74wbdd2dU4uCMoQmOhdL7irLfLiQTs52n
        cloiVghI64qCW/QaghwLiYlOvGN/YRkWH9LJ5OnShw==
X-Google-Smtp-Source: AK7set8pOdWfIt69LFD7Klja37MX4Y0B4AgeZGxYGFzE3TmHzaA3GYFi17QwE/R0IT0jJksQbazWrQ2EJ3TyMlpGcMk=
X-Received: by 2002:a67:cf47:0:b0:411:c1a0:c787 with SMTP id
 f7-20020a67cf47000000b00411c1a0c787mr1602974vsm.26.1676607724287; Thu, 16 Feb
 2023 20:22:04 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-4-yuzhao@google.com>
In-Reply-To: <20230217041230.2417228-4-yuzhao@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 16 Feb 2023 21:21:28 -0700
Message-ID: <CAOUHufYSx-edDVCZSauOzwOJG6Av0++0TFT4ko8qWq7vLi_mjw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
>
> This patch adds kvm_arch_test_clear_young() for the vast majority of
> VMs that are not pKVM and run on hardware that sets the accessed bit
> in KVM page tables.
>
> It relies on two techniques, RCU and cmpxchg, to safely test and clear
> the accessed bit without taking the MMU lock. The former protects KVM
> page tables from being freed while the latter clears the accessed bit
> atomically against both the hardware and other software page table
> walkers.
>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  7 +++
>  arch/arm64/include/asm/kvm_pgtable.h    |  8 +++
>  arch/arm64/include/asm/stage2_pgtable.h | 43 ++++++++++++++
>  arch/arm64/kvm/arm.c                    |  1 +
>  arch/arm64/kvm/hyp/pgtable.c            | 51 ++--------------
>  arch/arm64/kvm/mmu.c                    | 77 ++++++++++++++++++++++++-
>  6 files changed, 141 insertions(+), 46 deletions(-)

Adding Marc and Will.

Can you please add other interested parties that I've missed?

Thanks.
