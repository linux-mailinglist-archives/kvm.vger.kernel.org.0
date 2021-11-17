Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD85454C80
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 18:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbhKQRyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 12:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbhKQRx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 12:53:57 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52104C061200
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:50:58 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id h2so3609158ili.11
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lkt5VDANJrHR51gs8CAG2OXXi5XD+MdhvA72avGDOc4=;
        b=mQTBxX/AhdH8AcSTZ1oQPcDjLZto0Ehc9x1kBzrn/BCYj2gGZ5dMwJjj7DDX1lQuPg
         57/UfcbDTtGoLQ9AlFplfpkc0sr57CV1TV0iePkhEZOs5CvWo9ogJSeYB9Y2OswYQLXg
         KPYvW4TNPO0lgzYnE+tseW91H65372j23doPSMQwEWQ5fYDk0kFkCcTwLw829KVwWdWh
         p7Y6vg74txEPIjSGx1oJLdrgcMxjGbbeSs4MsXQgVEZ5iBsSYBwLm6ReY8k3oD+CAXx+
         EeUc4vKiBc2n1m/fYLx7UM/JUam3xu3WhdDdeFvTjvi5AmFwk022ubmIYh73ZSPYZc5Q
         /Ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lkt5VDANJrHR51gs8CAG2OXXi5XD+MdhvA72avGDOc4=;
        b=76W1Pfrs1OFsuIvlMbEXq1RxjyVt0TtSOyRLQwXnZQ961r+rQcd6YsLuflO9MTz2AJ
         sgyIPsYPj1mgaDI8PCH9npTp6cjKnV87gSRSkSB8uqbk2vbhfd23F57p1ZVH27XE0W0B
         RMPPG4BX1FX/MRCuIF5aBcyME1xiwVWeWlJnzY69jKo8A0WVO7LzYdIMJW632L3hNJ56
         wAlDAVrnyXycWwqm1OgTd9guTcNbF+IQD5T/U89dNGp8dRRVgsXbu3I3DIm/9mzJruNL
         4vMRyY2nlvyVfHaRG7TY3mbmUiRapeGK3a9bVfr5tHR7kpbI3a2CByhjLdOgRlKmGfHS
         x+kw==
X-Gm-Message-State: AOAM5317kAu/9/6kxbOQa0I1UQ6J4QsU2TFb+QPCWz+CMm57VCSAZb03
        ISOhUbFmfOJFD9ve/BaNcuvBVJkZRqjFqyjO/HphSQ==
X-Google-Smtp-Source: ABdhPJxjtlGPRylo+0Oi7DKiYCfUcfuS2UBdm1eGpEg3WHAYD+1zsIgO8Zm8z3F6FXktDRYd7+tqidmGsRvbfw4V7p0=
X-Received: by 2002:a05:6e02:1809:: with SMTP id a9mr11425113ilv.203.1637171457619;
 Wed, 17 Nov 2021 09:50:57 -0800 (PST)
MIME-Version: 1.0
References: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
 <21453a1d2533afb6e59fb6c729af89e771ff2e76.1637140154.git.houwenlong93@linux.alibaba.com>
In-Reply-To: <21453a1d2533afb6e59fb6c729af89e771ff2e76.1637140154.git.houwenlong93@linux.alibaba.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 17 Nov 2021 09:50:46 -0800
Message-ID: <CANgfPd_=M-8r8H5uoaPz_VTXZpmX6XD+QGAdBdz4PERUoqE1OA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Pass parameter flush as false in kvm_tdp_mmu_zap_collapsible_sptes()
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 1:20 AM Hou Wenlong
<houwenlong93@linux.alibaba.com> wrote:
>
> Since tlb flush has been done for legacy MMU before
> kvm_tdp_mmu_zap_collapsible_sptes(), so the parameter flush
> should be false for kvm_tdp_mmu_zap_collapsible_sptes().
>
> Fixes: e2209710ccc5d ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>

Haha, I'm glad we're thinking along similar lines. I just sent a patch
yesterday to remove the flush parameter from that function entirely:
https://lore.kernel.org/lkml/20211115234603.2908381-2-bgardon@google.com/
I'll CC you on that patch.

> ---
>  arch/x86/kvm/mmu/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d57319e596a9..4b2be04e9862 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5853,7 +5853,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>                                    const struct kvm_memory_slot *slot)
>  {
> -       bool flush = false;
> +       bool flush;
>
>         if (kvm_memslots_have_rmaps(kvm)) {
>                 write_lock(&kvm->mmu_lock);
> @@ -5870,7 +5870,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>
>         if (is_tdp_mmu_enabled(kvm)) {
>                 read_lock(&kvm->mmu_lock);
> -               flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
> +               flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, false);
>                 if (flush)
>                         kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>                 read_unlock(&kvm->mmu_lock);
> --
> 2.31.1
>
