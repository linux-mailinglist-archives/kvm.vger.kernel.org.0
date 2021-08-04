Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144AD3E0A46
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 00:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhHDWT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 18:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhHDWT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 18:19:56 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED2BC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 15:19:43 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso3131338otq.6
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 15:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIeDGb81HEa/IJ5OXkRbKetCo9gTIt6kKZjhA2DPOzc=;
        b=M8ipkm04J9ZGePM4PMk62q3rG4n6ksWm61P98tEQF81wH9EEavJbqwECZ5uEzr4Q27
         /w0ohBflOWp5rFFxsBFYZJhdj8Zfs8oyTl1rVVfP1ulP5J1OxcSFcbqVRUJ3CkGbXa81
         +bwl73Zcr8ByhEiE1ws7/8ebdlmUKCJ1+zkQH/kDL3MKeuoyszmspyHAljmZuL8xSrKB
         DdZNU6o+pMeLUgRwFCv/R6zYHVBF9UFwxfW6gQ4DD8WVkxoE6jTp1hrRAAfl28Ypi9ko
         zwfomSxHWKmmT34MnujIrqAL4hRjlhkcRD0nifc8NdOrrPvqNu71S8y3ClRaAmxRszBC
         Y5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIeDGb81HEa/IJ5OXkRbKetCo9gTIt6kKZjhA2DPOzc=;
        b=ArT3gMtL6SjXQzid0Ag2CrKnNf3hLbI2oQW+spRmOADqX40pOsheLfDCdvDgNruuMO
         ugrjk6iDgUzisyKXKF8/WoFCuy80TAXWh+UWFfCXCymyPcRZ0OrwZeJD27zdVeKUAIDg
         voUascACj1vmNMoh8dpErfEcs5vJR9dsDWVds7S0xI2FWAsKGd4wAwzzmVcuIzwDDaMa
         WsNCz63c+oMnzKx+FwaXtFp6F1UPf2/SFldrSiRiS7CzfkXwS1vxBxSpAy7bOyNLEHkx
         cAHDi2W1L8CuA6fOod4MdVyBlSuTGt7/CpxjtHyVJSGdWon45Z1eopzPoR5cP/YlFGSF
         Qe9w==
X-Gm-Message-State: AOAM530hdPbC0Dyn1Mi8l5wR3Jb4HqhwxZDt4Sz6Kb9vM4qt0Z3J/04V
        qaCuBhO6zgjl9tk3mepnD7i9HvpnVXNTlVKU6K0Ebw==
X-Google-Smtp-Source: ABdhPJxiWFtLtbQZDHzmp15IKxv8wOz2ClzTL6LLruJYPn66EMJRznjCSucbOVPpnEq+m9gMByWN53k3qOuogdTVC98=
X-Received: by 2002:a9d:63c6:: with SMTP id e6mr1313817otl.295.1628115582214;
 Wed, 04 Aug 2021 15:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210804214609.1096003-1-seanjc@google.com>
In-Reply-To: <20210804214609.1096003-1-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 4 Aug 2021 15:19:30 -0700
Message-ID: <CALMp9eSxuoLf4hopA_=y_FohCAnLRjQuQ_PeGKO325UJ5J+qLA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 4, 2021 at 2:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Take a signed 'long' instead of an 'unsigned long' for the number of
> pages to add/subtract to the total number of pages used by the MMU.  This
> fixes a zero-extension bug on 32-bit kernels that effectively corrupts
> the per-cpu counter used by the shrinker.
>
> Per-cpu counters take a signed 64-bit value on both 32-bit and 64-bit
> kernels, whereas kvm_mod_used_mmu_pages() takes an unsigned long and thus
> an unsigned 32-bit value on 32-bit kernels.  As a result, the value used
> to adjust the per-cpu counter is zero-extended (unsigned -> signed), not
> sign-extended (signed -> signed), and so KVM's intended -1 gets morphed to
> 4294967295 and effectively corrupts the counter.
>
> This was found by a staggering amount of sheer dumb luck when running
> kvm-unit-tests on a 32-bit KVM build.  The shrinker just happened to kick
> in while running tests and do_shrink_slab() logged an error about trying
> to free a negative number of objects.  The truly lucky part is that the
> kernel just happened to be a slightly stale build, as the shrinker no
> longer yells about negative objects as of commit 18bb473e5031 ("mm:
> vmscan: shrink deferred objects proportional to priority").
>
>  vmscan: shrink_slab: mmu_shrink_scan+0x0/0x210 [kvm] negative objects to delete nr=-858993460
>
> Fixes: bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page limit calculation")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Ouch!

Reviewed-by: Jim Mattson <jmattson@google.com>
