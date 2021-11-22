Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CE44595D5
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 20:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbhKVUAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 15:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239711AbhKVUAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 15:00:38 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3125DC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:57:31 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e144so24905422iof.3
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tu3lxcIg7V05BfeRU1lfgCDNUx8anDFHSWBxng5Jwac=;
        b=srhMB9M6hX0PkCDJD/JQkumC/IQ8M7Lz+cplUXYaHfAi76HHbwUnWECul4L4RyW3GZ
         w1ashi5ZD6M2Std6cYhwV68h2Oek1z9hhwcbYqJduTemt9RX7vRtMkAIX4Scg3jiWfJ6
         L19cXhw/DAa7JB41HMYsjsNBKGjjunmogVFekOu8oi2kg5RyRi0p1jCrYKRfOUPVsA5l
         ViZNpsmbYOPVjM5hEek05EhquFS15s4A8GxJYDNhVixHuFAk3Fbk4J/rMjFqaYxYEqnv
         N7NFJ+2Z1p0OW9A9GFli/pvYeLEjO9UQbwIsCNSOru8/ZDz25V2MSfmjXudcVOxTxc+E
         khYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tu3lxcIg7V05BfeRU1lfgCDNUx8anDFHSWBxng5Jwac=;
        b=D5637sc4sXQKl4jNYMA4hTJlJjJquDV4Q/+t+lhxwJcLCxD8XHIw04bjLtlmOuoG3K
         uwxdLmzJ9Fm2JVUCreMGHOZ5xtPglMUHXaxAUZeYtc6fdgF4VUMtijZJn2MQgJt7+Lmw
         qFFfCGKfwCTFKz6A8S1+Upj0oFnpWGsvy5glygeqtawhP9L9e5MhPf2YBMzzi1Wi77+b
         ATyoUu5jzHlxzGTNKvdvsveFsMBcRqxzMhOpYgtjVSpkfMdTjdLk3ftQvkdPFJnMooYW
         7hAzbdSPzh5be5ox+1qNv48PHp/8TybmvlizqiU8uf0w7WnxK7/9gneeJMJ2uc1mHItr
         Kivg==
X-Gm-Message-State: AOAM531v0VB83GZ4yEpNclYmtH6kdLaY9B7aAaWRdzyyg7EKceh7UZjY
        byaZyKd9nP9hIlqX/gw4ycZlQ1J8ePp9ivfxtA/jmg==
X-Google-Smtp-Source: ABdhPJyHs56CGDl8ro/bvC8wCPGXjqMFzrf4zkecyaHKTPWrCYSJk7Xl8Ol3tNmm5cWwTHdBhkyJ1bFqwou2YOv2q/4=
X-Received: by 2002:a5d:9493:: with SMTP id v19mr24296286ioj.34.1637611050436;
 Mon, 22 Nov 2021 11:57:30 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-6-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-6-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 11:57:19 -0800
Message-ID: <CANgfPd8nRH+6ovkNETgx6fLjf4bNsHjHCMMq7ZVxtuU-J30UrQ@mail.gmail.com>
Subject: Re: [PATCH 05/28] KVM: x86/mmu: Check for present SPTE when clearing
 dirty bit in TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Explicitly check for preset SPTEs when clearing dirty bits in the TDP
> MMU.  This isn't strictly required for correctness, as setting the dirty
> bit in a defunct SPTE will not change the SPTE from !PRESENT to PRESENT.
> However, the guarded MMU_WARN_ON() in spte_ad_need_write_protect() would
> complain if anyone actually turned on KVM's MMU debugging.
>
> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1db8496259ad..c575df121b19 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1246,6 +1246,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                 if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>                         continue;
>
> +               if (!is_shadow_present_pte(iter.old_spte))
> +                       continue;
> +
>                 if (spte_ad_need_write_protect(iter.old_spte)) {
>                         if (is_writable_pte(iter.old_spte))
>                                 new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
