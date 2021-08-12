Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6423C3EA8BF
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 18:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhHLQsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 12:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhHLQsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 12:48:35 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A126C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:48:10 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e186so9244372iof.12
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvJ9x4SLfenexXQQA9JFifSbykJiiyHkKwAxOj9DqUA=;
        b=lrAhMH+t9sGAoPAFE5RJh+ziEafVJJARhDWK1fUgGew1wWGRWeyQSmT8+CC8xemO+d
         x7arzC0WWE6fQ1qV4K6/icgkxMh4rP8lFIdPqrrwtNtSOrtRMfu2Kg1U+WtnDY4BRPmF
         U71o7oC/yKl52sHkInoq7OdIQxNfVjMjsbt2/79IlPndC7kOQQvZwmj2Dr2G5k16Y9He
         AiavkhxuSJM7Ohxz7YhO+3LjaIUJlChXqnarB4TiIXeIZFWtG8vESQcMIrssE3VxyVhG
         XYcKmymXk7yiBX0ANdIvFfrJOzJ/LALzr6TkCKJgXSHmzr8Xbj4gUl/jRULG68O3Vj2o
         itZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvJ9x4SLfenexXQQA9JFifSbykJiiyHkKwAxOj9DqUA=;
        b=HCHYiexKmG4EDndW8gmR8l6Hbq1E1Qy+K8XMwePLXZ9mHQ5e5Mv/OKihGqAwhteGim
         nNPKQQV/po+7Oy3gV9lc/JrAC24V6j2ZoGL21n+E90hfGq3gxNmujmj0iRd9rkLGMCBq
         DFdz3mHVI3UnfxUvOG+HLXyl1i8Dyqo+eI1Ln2guDZeVu33Ru5YasM1QSoR6mbnRaTBQ
         PdC4kWM6cZNX8oLEexDJV3kMQoz1fpp+byEDuZqQaEDlgEPZ/06n5UBKv3snJnwzLPyo
         M3Ckyf4rOXOJ3vC1EZxuQxbHHUTHCTLlbrXnWhjHw5C5/Nnm5WT9Vl/ggEHU7yD7EVrs
         5Akg==
X-Gm-Message-State: AOAM53057abRBfJ7cQGgj4d9xpDaevixJCYviOZp3hNyJ/KYS/Y0tCJA
        hw/kSJ8wharMH35DTWIphC+PSTf41kJDwimka7lOag==
X-Google-Smtp-Source: ABdhPJzUWWKReTHuxY5UHPYpQMnFevojGRj0IgqDZjGAv71TQUSZo86oKdo3DGmaq0zjFEpa9BeE75ZcGV7mxbOEluo=
X-Received: by 2002:a02:2243:: with SMTP id o64mr4666627jao.40.1628786889496;
 Thu, 12 Aug 2021 09:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210812050717.3176478-1-seanjc@google.com> <20210812050717.3176478-3-seanjc@google.com>
In-Reply-To: <20210812050717.3176478-3-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 12 Aug 2021 09:47:58 -0700
Message-ID: <CANgfPd8HSYZbqmi21XQ=XeMCndXJ0+Ld0eZNKPWLa1fKtutiBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Don't step down in the TDP iterator
 when zapping all SPTEs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 10:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Set the min_level for the TDP iterator at the root level when zapping all
> SPTEs so that the _iterator_ only processes top-level SPTEs.  Zapping a
> non-leaf SPTE will recursively zap all its children, thus there is no
> need for the iterator to attempt to step down.  This avoids rereading all
> the top-level SPTEs after they are zapped by causing try_step_down() to
> short-circuit.
>
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

This change looks functionally correct, but I'm not sure it's worth
adding more code special cased on zap-all for what seems like a small
performance improvement in a context which shouldn't be particularly
performance sensitive.
Change is a correct optimization though and it's not much extra code,
so I'm happy to give a:
Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6566f70a31c1..aec069c18d82 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -751,6 +751,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  {
>         bool zap_all = (end == ZAP_ALL_END);
>         struct tdp_iter iter;
> +       int min_level;
> +
> +       /*
> +        * No need to step down in the iterator when zapping all SPTEs, zapping
> +        * the top-level non-leaf SPTEs will recurse on all their children.
> +        */
> +       if (zap_all)
> +               min_level = root->role.level;
> +       else
> +               min_level = PG_LEVEL_4K;
>
>         /*
>          * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> @@ -763,7 +773,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>
>         rcu_read_lock();
>
> -       tdp_root_for_each_pte(iter, root, start, end) {
> +       for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
> +                                  min_level, start, end) {
>  retry:
>                 if (can_yield &&
>                     tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
>
