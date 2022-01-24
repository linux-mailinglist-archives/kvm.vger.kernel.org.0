Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5FF497AD3
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 09:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbiAXI5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 03:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbiAXI5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 03:57:20 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46413C061401
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 00:57:20 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id e81so24446465oia.6
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 00:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LOYL+rXbKkBxwKnxxUJRI+JYuYrzmRIZD8R7ss33Fo=;
        b=mOOM32JvhyWHxDNT1yl3o3ilV91m8p0sbxYBFE2MaJPRhEDNPFjsP2l/9YgR1e4n/j
         /+Ki5Wm3HUJjPfHmtoyeLbLIo740NpCjaxlELrLzkpxjvTtLVLgFWh8GpXYSEC2vg8xw
         iALRbAuJMSsqq2pRpY9vxpEREZ4RJi0zTV/KM0ihwHpDnu4BVD/4YzgHzVTpsoFaN6M/
         fUNijqYnsFrEFtdDqrP8v+9Q5RTA3dsVOlW+tn4g5RcNPn2AzUI2B4k2Th2N4rlXs+NR
         YVgFC+bMIftycOG+A/gPsTHZFp/9Ps/r6PvQpOeBiH4RaPhbQKDlyKSAj7xOc1Q1HQYY
         XRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LOYL+rXbKkBxwKnxxUJRI+JYuYrzmRIZD8R7ss33Fo=;
        b=uOr++SJJ5uNbiya0UIUUkfX7alRpBtOXYGroSYCMOzuhFveBOfSX0xUEDaQRV4ygoM
         WQZ16R7lvWiiTz3xKoDsNSFruEWQGVzl0FwV8FX7mHUvr7KS98AH518LSy35cnq7qS9h
         4hTQVAqo5929G05LjmAzxmI5X5AlmtxlvC7rN3cQrK33JqaVqkpFAHhCpYOPezDmT0HZ
         jFA11rPgmGVa1SsMDWOoyqRBlTMrUDt1Tl26HWsZCI3rNHv3bLNhBJeuSGrX1ndJC610
         guPlY3pDvclnOI0VFPClwz9YP6r9ACAHa6H/QgLj+/usR31nd1/cYHH3vnT70nMyOf0d
         ouVg==
X-Gm-Message-State: AOAM532bH88r9v+k+LQ74S8+zqAVWyIOlQf92Pthb2pPSOy2zuVkx7+F
        qRTwlyoqPDGIvkUi1xpUDx5bF46pE9WpTGKwVQfCEg==
X-Google-Smtp-Source: ABdhPJxyYrXLQdtFig50Jm9MpWiRAsg7rBHxdCaoci5ZAoy/TpI9NboFii/+p4yqn/MGRoXXtldKiGH6LOsbJbsLU20=
X-Received: by 2002:aca:1e14:: with SMTP id m20mr640396oic.14.1643014639400;
 Mon, 24 Jan 2022 00:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20220121184207.423426-1-maz@kernel.org>
In-Reply-To: <20220121184207.423426-1-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 24 Jan 2022 08:56:43 +0000
Message-ID: <CA+EHjTzks6CpViFPc=xCq4SGpdiEPy_88L3MTjikmNA-9bC0Tg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions
 on !VHE
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jan 21, 2022 at 6:42 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Injecting an exception into a guest with non-VHE is risky business.
> Instead of writing in the shadow register for the switch code to
> restore it, we override the CPU register instead. Which gets
> overriden a few instructions later by said restore code.

I see that in __sysreg_restore_el1_state(), which as you said is
called after __vcpu_write_spsr().

> The result is that although the guest correctly gets the exception,
> it will return to the original context in some random state,
> depending on what was there the first place... Boo.
>
> Fix the issue by writing to the shadow register. The original code
> is absolutely fine on VHE, as the state is already loaded, and writing
> to the shadow register in that case would actually be a bug.

Which happens via kvm_vcpu_load_sysregs_vhe() calling
__sysreg_restore_el1_state() before __vcpu_write_spsr() in this case.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> Fixes: bb666c472ca2 ("KVM: arm64: Inject AArch64 exceptions from HYP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/exception.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 0418399e0a20..c5d009715402 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -38,7 +38,10 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>
>  static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
>  {
> -       write_sysreg_el1(val, SYS_SPSR);
> +       if (has_vhe())
> +               write_sysreg_el1(val, SYS_SPSR);
> +       else
> +               __vcpu_sys_reg(vcpu, SPSR_EL1) = val;
>  }
>
>  static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
> --
> 2.34.1
>
