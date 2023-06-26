Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912DE73E54C
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjFZQhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjFZQhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:37:41 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BFCC5
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:37:41 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-34570b2d069so282285ab.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687797460; x=1690389460;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cP++u2u7KY7ZK6+tcwZISor8fnN58HL1TvWcpzIk3xs=;
        b=XyH96Gd+4Gw6XhqvKwemXQBkBenw9BvrxwI34u6QNHn6W7kOCt7a2lgWM2etDNoxwl
         3/xbPz+TCtO+xaq2zi0O+cK3iGMZgaHkkhu6EXegxUY2eLD5pYTocpkXXlS62baGJEwn
         8fVloR0JGVrgNAniJgLh5IHUKbVkGDVO6kwN83viwwD0/DwfliKQoMMhplFzOM2rB7sW
         J95AykV2QpWeD2t6AHeS263eUZGNg+TrgcmaqGy/td8qQjRrKcIHNqQUQ56ajgiv4GEE
         bZkSvuLCyptD12ZH1h1mlOsJVrTicM8K2DFitf6VhnncoyEaPXAryP7z4ouaayfBUm8y
         4gqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687797460; x=1690389460;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cP++u2u7KY7ZK6+tcwZISor8fnN58HL1TvWcpzIk3xs=;
        b=eZI0Us6oexyz6X0j//BaXU0llMthIob5+R7XODta0XLVo7+59E9ndUI14Ixw6lObSE
         A/hRGeSuf1/fl35fVJFgxTWTnnViNKbZKcmD8esi7FsXoyjJHvCIrfm3amxgbjOOB+Qr
         MK9zuGZFWYEzIbIqbzbgv+k3/P6Lc/meJHsdwSqEHRj+eOGgO1Flg3wHqBJLUzgA9lZm
         dnd+qCNjWz5axhfQTgSFqUgf2TTnb+jchJknFtZBBavvLvRnWfz2/a0td5Yms9kdNe6h
         2lVlkY8C5txZ8iFC+6KF96UoGnHEayfuMaQjQJd9Q5lmEfm/4nFauSHcUvn3RiBZiurv
         L7cA==
X-Gm-Message-State: AC+VfDzLuoQKT7qcndcrjTp7NWeOSxL7vLW/EAZ/O3Hf5V8TrMHpqqTt
        PrJjdXiycL09C4nq4YT1sjDe1/xFpFPAFmMHeDAIzA==
X-Google-Smtp-Source: ACHHUZ6JYlLXaQjhf27mTHQiG6Kq14ShrcBsXFHq9BTGqTLCQWA1X6IP86vIEv/UGQTdwMe3bFJvAcTGV1RZbWyu06Q=
X-Received: by 2002:a05:6e02:2142:b0:335:e50d:9b11 with SMTP id
 d2-20020a056e02214200b00335e50d9b11mr417735ilv.7.1687797460150; Mon, 26 Jun
 2023 09:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230623123522.4185651-2-aaronlewis@google.com> <ZJW9uBPssAtHY4h+@google.com>
In-Reply-To: <ZJW9uBPssAtHY4h+@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 26 Jun 2023 09:37:28 -0700
Message-ID: <CAAAPnDEb0dwdWsF6K9s1r=gZSQHXwo5Y8U9FWGzX52_KSFk_hw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: SRCU protect the PMU event filter in the
 fast path
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> Actually, on second thought, I think it would be better to acquire kvm->srcu in
> handle_fastpath_set_msr_irqoff().  This is the second time that invoking
> kvm_skip_emulated_instruction() resulted in an SRCU violation, and it probably
> won't be the last since one of the benefits of using SRCU instead of per-asset
> locks to protect things like memslots and filters is that low(ish) level helpers
> don't need to worry about acquiring locks.

Yeah, I like this approach better.

>
> Alternatively, check_pmu_event_filter() could acquire kvm->srcu, but this
> isn't the first bug of this nature, e.g. see commit 5c30e8101e8d ("KVM:
> SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid").  Providing
> protection for the entirety of WRMSR emulation will allow reverting the
> aforementioned commit, and will avoid having to play whack-a-mole when new
> uses of SRCU-protected structures are inevitably added in common emulation
> helpers.
>
> Fixes: dfdeda67ea2d ("KVM: x86/pmu: Prevent the PMU from counting disallowed events")
> Reported-by: Aaron Lewis <aaronlewis@google.com>

Could we also add "Reported-by: gthelen@google.com"

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 439312e04384..5f220c04624e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2172,6 +2172,8 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>         u64 data;
>         fastpath_t ret = EXIT_FASTPATH_NONE;
>
> +       kvm_vcpu_srcu_read_lock(vcpu);
> +
>         switch (msr) {
>         case APIC_BASE_MSR + (APIC_ICR >> 4):
>                 data = kvm_read_edx_eax(vcpu);
> @@ -2194,6 +2196,8 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>         if (ret != EXIT_FASTPATH_NONE)
>                 trace_kvm_msr_write(msr, data);
>
> +       kvm_vcpu_srcu_read_unlock(vcpu);
> +
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
>
> base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
> --
>

As a separate issue, shouldn't we restrict the MSR filter from being
able to intercept MSRs handled by the fast path?  I see that we do
that for the APIC MSRs, but if MSR_IA32_TSC_DEADLINE is handled by the
fast path, I don't see a way for userspace to override that behavior.
So maybe it shouldn't?  E.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 439312e04384..dd0a314da0a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1787,7 +1787,7 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32
index, u32 type)
        u32 i;

        /* x2APIC MSRs do not support filtering. */
-       if (index >= 0x800 && index <= 0x8ff)
+       if (index >= 0x800 && index <= 0x8ff || index == MSR_IA32_TSC_DEADLINE)
                return true;

        idx = srcu_read_lock(&kvm->srcu);
