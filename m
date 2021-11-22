Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F14596DE
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 22:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhKVVsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 16:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhKVVsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 16:48:24 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC69C061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:45:17 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id i9so14103178ilu.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYp+2FQ9kEUUYn5etdjt0S74MkYWDopaecoN+XmZ9MI=;
        b=rFj2UjwziV5n3HfSTQDoq+pBzkhpC7GeCierENOXBNmX1ito9ab6QG+bSslB6dhOKe
         CHUXpEF1BO74A6d7TGCo9Pt3MfOU0TpIWplMXt9CRCs03QqpINJDR4T4BlSa//AU3Dpx
         uZomX3lDMA6+zY9YQ7q8L+bHH2yRvucUKluIlQMAgw3e7uJR9Yc5MwgZMnmOVRuFbtiy
         rBteKFsGmWS6BE5lSy9awq2n9e4cE42bmHoqzoULE2BV35Of6mKSxnO6LtOFSEcLW3DT
         GmGPfrfkjNl+FW5fE8H1a9fXvmu+6T+rPP+a5xzOlP2GQ8ko7r72ljClAmeVN3eQEnCp
         DvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYp+2FQ9kEUUYn5etdjt0S74MkYWDopaecoN+XmZ9MI=;
        b=2rz8xwHdgDE0aLd+98ujlJgdylXfbrgloigs8xiXs8QmphSL474XgL2v02I30JSf93
         2tSFabcyGgOD5pba3Dh6mqztbWZocKzacwkDcFiKRfYLLk6q0U08vo8a6SXAosMltICQ
         fVF6kaR4XChwNVmGo32exNciScsFKBaOI9p9Ic6uDfZrm5lndEqAmfVb8v+56mor3O/H
         xqITvzwGaLAulAKheZ2jFLYQ9Fs5GmVZfAfJfxajIVSCr0F/kkloWbK8vrkUUQB/65PP
         f1vvDuIUZj2ZWE0OlfQfbKuOoDySz9qQAFkL1wnosAVyc/N3mWkbv+qFkv+y5ZPmo7a/
         wNmQ==
X-Gm-Message-State: AOAM5337vhx0lKfltJ8YXwSvODJQdj/8D/u4nIYlqB4soifZAC51pwFZ
        QxHRkNs4K1WREeQwgl/dgQ5ILgkVLigLfqyZEfSTcQ==
X-Google-Smtp-Source: ABdhPJwpl6MJzOLQ0iyNZlqmcZDIclkCWWjM+ZidA98o0UeFwYvSbDYyan3axZG/cMJRE+NyISI92Oxbhf0f74cuXQk=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr127511ils.274.1637617516748;
 Mon, 22 Nov 2021 13:45:16 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-13-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-13-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 13:45:05 -0800
Message-ID: <CANgfPd8NRY++QuLxZvk+T+rxFw_09tSsMBes_09B4R90wdrtUA@mail.gmail.com>
Subject: Re: [PATCH 12/28] KVM: x86/mmu: Batch TLB flushes from TDP MMU for
 MMU notifier change_spte
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
> Batch TLB flushes (with other MMUs) when handling ->change_spte()
> notifications in the TDP MMU.  The MMU notifier path in question doesn't
> allow yielding and correcty flushes before dropping mmu_lock.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

This seems very reasonable to me.

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8e446ef03022..06b500fab248 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1182,13 +1182,12 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>   */
>  bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> -       bool flush = kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
> -
> -       /* FIXME: return 'flush' instead of flushing here. */
> -       if (flush)
> -               kvm_flush_remote_tlbs_with_address(kvm, range->start, 1);
> -
> -       return false;
> +       /*
> +        * No need to handle the remote TLB flush under RCU protection, the
> +        * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
> +        * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
> +        */
> +       return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
>  }
>
>  /*
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
