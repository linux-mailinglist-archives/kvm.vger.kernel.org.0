Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8594434B2
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 18:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhKBRoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 13:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbhKBRoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 13:44:21 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F76C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 10:41:46 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y73so1284246iof.4
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 10:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+jt4U2mLEyx478NdaUuq1MspzT7e5TDgt4TvxlpltBw=;
        b=kdGO6qqnrkLi8ZHdgX5rgE6naeVJUdaCcPSV+WQ6FEA5PUi6nMO5d6ar9+CNnR7oLu
         P5CSnMmE8348s/AaWEmhSfgK2Qod0LHb/Z7iG4bWSTRGuWFse/Ye122Bg83WyRj8/F0G
         bDly7HQ5pgvKIUbLq/Q+0vA1flY0MzUtoyJ1O+7NwuhLRO6L1bxuSJ7PFu3Oa6ks0QI4
         09iWUm3U8/6aSKLpDI4nWn5cIkrDWjeJQwcGlJzHdx5tfGFmRRvbkiUjOFWEsunBcmGq
         qRV764u77lk3kdh73S7BYz1RO1XFrW2bAkTd6Yu4JVpLk6DT4jgeU+gFKvfXGxZqoIsP
         KtEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+jt4U2mLEyx478NdaUuq1MspzT7e5TDgt4TvxlpltBw=;
        b=KQ5WMXytEVTYRh3gNty+pCF3KUo5WnjOLwDqkhJq+BbltgFiJGHE44sPvXDCf7iy2B
         K1XlvwfONt29QTKA0qY3MzfAn5ocpSHr8U5SW4TlgnIlzl7sFy57Z297m3MpACIhH86E
         sslJrW3aMMioMeChqBa3JDDQ/GHUTdtnL4umV3if9aBwzVRGSzrFiGUZFRMsdOZb3P0i
         wzSQox2/2UK+3OfM3VSBg+cLi73mTo12HibcPl6jNeF6codt6cbF3nDLd64Ke/6OtsJS
         Jrc6qu1amHTXBmx99qdJwwJS7utfzZus3tK/b3WFD9o411sdZO+POF58LOOchLW+vn5L
         twgQ==
X-Gm-Message-State: AOAM531wDYJwCC0XOIlbyIPRFJ/lTY2NeDvlSC50c5nOM1sfReRjxAbY
        lS7/WNB9/VzzgD1GqCTAabm9zUdzx6VSezHz/hLLyw==
X-Google-Smtp-Source: ABdhPJyPEiC/ZX2Obj1x89FuYihO6RiqMrNN+cmRHtjO5JehD4YZ8hOZ+v/F+M+9fnT+tbmRJ223ICdKnjoBtoNqhd8=
X-Received: by 2002:a05:6602:14c7:: with SMTP id b7mr16422312iow.130.1635874905419;
 Tue, 02 Nov 2021 10:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211102032900.1888262-1-junaids@google.com>
In-Reply-To: <20211102032900.1888262-1-junaids@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 2 Nov 2021 10:41:34 -0700
Message-ID: <CANgfPd-uJEm62kOri1pS6m4wm71H8yh=K-4WSgVOw3Z2wzccXA@mail.gmail.com>
Subject: Re: [PATCH] kvm: mmu: Use fast PF path for access tracking of huge
 pages when possible
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 1, 2021 at 8:30 PM Junaid Shahid <junaids@google.com> wrote:
>
> The fast page fault path bails out on write faults to huge pages in
> order to accommodate dirty logging. This change adds a check to do that
> only when dirty logging is actually enabled, so that access tracking for
> huge pages can still use the fast path for write faults in the common
> case.
>
> Signed-off-by: Junaid Shahid <junaids@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4..5df9181c5082 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3191,8 +3191,9 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         new_spte |= PT_WRITABLE_MASK;
>
>                         /*
> -                        * Do not fix write-permission on the large spte.  Since
> -                        * we only dirty the first page into the dirty-bitmap in
> +                        * Do not fix write-permission on the large spte when
> +                        * dirty logging is enabled. Since we only dirty the
> +                        * first page into the dirty-bitmap in
>                          * fast_pf_fix_direct_spte(), other pages are missed
>                          * if its slot has dirty logging enabled.
>                          *
> @@ -3201,7 +3202,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                          *
>                          * See the comments in kvm_arch_commit_memory_region().
>                          */
> -                       if (sp->role.level > PG_LEVEL_4K)
> +                       if (sp->role.level > PG_LEVEL_4K &&
> +                           kvm_slot_dirty_track_enabled(fault->slot))
>                                 break;
>                 }
>
> --
> 2.33.1.1089.g2158813163f-goog
>
