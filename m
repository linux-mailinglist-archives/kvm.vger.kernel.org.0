Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A02A411666
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhITOK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhITOK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 10:10:58 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2E2C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:09:32 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id y47-20020a4a9832000000b00290fb9f6d3fso5918429ooi.3
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qzAdTsGqrarKrbZiLgQ+yqd08O5g2KPS2fQJ1adRAbE=;
        b=Lc5yTDdu4Z3ESLWgSn8P+Yyo1JXoXNnAwo7xIH57GWzVa7TVzjcFv4yNw2009ZQ5Zi
         qPA1ibsjJp5bIhAVuwjxCm+Io/CPD9HVF9biAgL65DiCGnM2XTe164wB+IYCSfsDWDMk
         DcyLd1ntMHf4fpszz2py6D2mpdB1vdmF37E/L3X8eMeFn/pBrbTbOe1RIETYK3xbIFzX
         ghTEMZjdySpQv9CTWdSzOTNizZM8UNm5hpPfuLRX0Wz6WSkFn4Mm2smHwmgdc90PHDvv
         j/GV4JfTTPPhj2rff2ZLrbFlVqSC4hudG78SAJBcHQvskuD3oP2bzCfDPf76nCRDOp+I
         W1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qzAdTsGqrarKrbZiLgQ+yqd08O5g2KPS2fQJ1adRAbE=;
        b=c9TV4oJ6tjORfssV9HhgdbQwrb0hLi5JgqSnSYAArmyxQxcdIEy/huVAMiaRKeW16N
         yJ5kA5vWwCcZpKJZuO+X9oaaulsDFL82pyk7QQvPmj7w68m1lC1PDOHogrFjtwkLWAxZ
         kUIwI4s/Ab1m/zwlSN+P7WndJvJiUrWNpKpWmKryx3R7WaP04hDCj5ANWmHsdko9+TF7
         tZvMhpLFZXhIuIHUDVQROsK18sxuOxfKPbVnvSCp2gtbwAk7zU+kc7mWPyAOP4osGibb
         IOvZU02gewwOEUpKhlch7OY1/+p4fnw09bYdtQBNe5EFpXWrTUQFiYZVGG7rlP/2Wj3s
         mJQQ==
X-Gm-Message-State: AOAM533o6BY143VMw5jzmaA/lmjIPuOSXwWa2QcC0q06ZhUMXjMEW56m
        DyKcDRqz2K5EFPbsMjlJ3yTAhWLttECkkWKt8D7OVg==
X-Google-Smtp-Source: ABdhPJzcGkhhRgG63cEAKiVJaDA4QJ+7e3xmIVMV1M65aTlgH1dCw2yj+iWheoNkqPW9cH7sK0KJqPYXfV3EypeyiR4=
X-Received: by 2002:a4a:b6c2:: with SMTP id w2mr17432044ooo.59.1632146971367;
 Mon, 20 Sep 2021 07:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com> <20210827101609.2808181-2-tabba@google.com>
 <87pmt3v15x.wl-maz@kernel.org>
In-Reply-To: <87pmt3v15x.wl-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 20 Sep 2021 15:08:54 +0100
Message-ID: <CA+EHjTx3_rdfGn6d079ZG2W48eibknHiQyBZSCNyb9ukqHS63A@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] KVM: arm64: Pass struct kvm to per-EC handlers
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 0397606c0951..7cbff0ee59a5 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -163,7 +163,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
> >   * If FP/SIMD is not implemented, handle the trap and inject an undefined
> >   * instruction exception to the guest. Similarly for trapped SVE accesses.
> >   */
> > -static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
>
> No, please don't do that. We already have function pointers for each
> of these, so by doing that you are forcing the compiler to emit the
> code *twice*.
>
> Instead, call into the relevant EC handler by using the base array
> that already does the non-protected handling.
>
...
> > -static const exit_handler_fn *kvm_get_exit_handler_array(void);
> > +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
>
> Why? What breaks if when this is static? There really shouldn't be
> anything else referencing this array.

For the two points above, the reason I did that is because later
patches call these functions from the newly added
arch/arm64/kvm/hyp/nvhe/sys_regs.c. That said, I think that the code
that calls them more naturally belongs in
arch/arm64/kvm/hyp/nvhe/switch.c instead.

I'll fix that, rebase on 5.15-rc2, and respin.

Thanks,
/fuad


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
