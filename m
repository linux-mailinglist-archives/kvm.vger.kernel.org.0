Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922404EAE98
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 15:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiC2Nik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 09:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiC2Nih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 09:38:37 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24FE4D610
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 06:36:53 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 5so30328293lfp.1
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 06:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sK7Bv0enNZHiUYvwnBleR2mEnCHV5OhHNBDPWeFOSoM=;
        b=hxmg270hpKoeWoqbPGY934y8sfl8R5GGyGznt4sQ9VewcKVEhpT2avtqbqnKKr5r2n
         yxgOPxPJWxAAjgTF/ws7wpdAy47HPS3TPeDkXaK8xVHByKO90ZUK6fo9q68b5Fn3Q3Gc
         NECfk4mv6PUm1HZuSK5V68fUfdxHqxV1456HSgAwjgvOP/wYc5vs3FfNuf8a09xpe+rZ
         nqO0xAY9BMbJzyrC/nYTSCeZJNV2OoKbTWZHRdZkhwX+EEnVBpcJLxC2RtjSR4prKGxv
         i9sv+p9kZOpmy6H31n19ugNZZsxZ0q3oXS7klG3MptUQX9PHbBIAR9b2+LRQdjQShRDj
         euHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sK7Bv0enNZHiUYvwnBleR2mEnCHV5OhHNBDPWeFOSoM=;
        b=HT0wdyqriaEqOqQ5BI7ZfWrqU5/eai+YuomGW5gfwO6OrYq1AOGqQ3Kaejg2Vzk9g2
         zLSt0c5KeRGvlYVpqrJojyVzZ95685DrIa5Res2NV0bqc6VvK2mWSXSzmzCXE2pcb8Wg
         AAB7vZS5ZvrybArtUBJ4qFtokVeuirFvfGCNrU5FBDjqu31f5gV9R8rZPnSMfEXAVe9g
         KGIG+RABZzwisI3XvEAXoYHzkhgcc07kfOHzRE8aaClwFU/zjMrn2LWgz1/9S7gXX5Tx
         lHePzT7xl7SVEsvQqF1oI31KiuVje2eQlCbUwNaLpBBxtpgpRVbGmR/hk61qyvvVEOEe
         fTRw==
X-Gm-Message-State: AOAM533XE9WjvhN4nxCmMJ0dYjxghHdx2QIDGg7FPT8bfn6nFEXHqF2y
        1J4icjcA1M1EfiVaNy9Ir2bLwqbstdOC2dS7zzo1Xw==
X-Google-Smtp-Source: ABdhPJxjyigrkTxPmeqzxtaaevkTllMZZ2xDBoOTpl1q5n1TCVoKq7IWuJTHuJmECCV1gc/9xlpV/i9pCn3rWKtnIZQ=
X-Received: by 2002:a05:6512:12c3:b0:44a:27ac:c7a4 with SMTP id
 p3-20020a05651212c300b0044a27acc7a4mr2766629lfg.150.1648561011920; Tue, 29
 Mar 2022 06:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com> <20220329011301.1166265-4-oupton@google.com>
In-Reply-To: <20220329011301.1166265-4-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 29 Mar 2022 06:36:40 -0700
Message-ID: <CAOQ_QsiKa4UUvsfypGqiMoFb0c5f5gtyk7ADv0M15E0Gi04QPQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Start trapping ID registers for 32 bit guests
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

On Mon, Mar 28, 2022 at 6:13 PM Oliver Upton <oupton@google.com> wrote:
>
> To date KVM has not trapped ID register accesses from AArch32, meaning
> that guests get an unconstrained view of what hardware supports. This
> can be a serious problem because we try to base the guest's feature
> registers on values that are safe system-wide. Furthermore, KVM does not
> implement the latest ISA in the PMU and Debug architecture, so we
> constrain these fields to supported values.
>
> Since KVM now correctly handles CP15 and CP10 register traps, we no
> longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> emulate reads with their safe values.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d62405ce3e6d..fe32b4c8b35b 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -75,14 +75,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>         if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>                 vcpu->arch.hcr_el2 &= ~HCR_RW;
>
> -       /*
> -        * TID3: trap feature register accesses that we virtualise.
> -        * For now this is conditional, since no AArch32 feature regs
> -        * are currently virtualised.
> -        */
> -       if (!vcpu_el1_is_32bit(vcpu))
> -               vcpu->arch.hcr_el2 |= HCR_TID3;
> -

This is obviously wrong. I deleted one too many lines! Will retest and
resend, this time hopefully with register reads _actually_ being
emulated :)
