Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A310A4E380B
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 05:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiCVEnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 00:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbiCVEnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 00:43:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB53985BF9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 21:41:55 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id jx9so854514pjb.5
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 21:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I30fMtOFrftRRp+ZK8GvM5pRdzD/fkbHxTk7j1WjRNU=;
        b=U6GwH72H5Gth87PY0906tE1wnf+Z+7E4ybKfeq6vtJry2Bs4Ml3VrJdPDd4aGlhpIe
         0wQbFHzDGdg5UIo+9SkGPfwd8fqzDsNgSuRtGbhHa+l5g49SGtFxrqI6Mfn+FTNPhCDF
         JhrD1h2yojsa9gwk1D2N0r/r67BJIc6pymK4haewk8lHLOjD4CykZ+DunoelIQhkDeuT
         eKxgoqRTSfF4Kse8e20k7BEq8XHvNbZQXBzogtYOGqBQpqlJGn0J5V/wVd70kb8YCh5v
         4l9dHMHSbX5qyH0wCY/4QUOYt1U1Tw6atyohBgT4r5dbpUdlsfReDzrGVLTJvaTQ5w8/
         4s2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I30fMtOFrftRRp+ZK8GvM5pRdzD/fkbHxTk7j1WjRNU=;
        b=8Dcx3uMVGYfW82WjTQ50ehjX5u9tLiRU3y/fccRgFifjBUtMwnWS3/jLkdhixUS/TH
         0tKJmmK4Z/Ux0ypaBa6qwc4pK2NuYmK0TjB9Q+MIpiqpitPFmBtAeyQXpFHm3W+eNUJX
         VDW/0zdHatAmtz5CjXRwPrh/ICS6ZwLWWatvRRoT9DffbpFvwNoBvTj8FRkuGnhQgYKt
         80+X+KgvyM+sajFL3NqKvYyDl124tZvBgHp+zEeCFa+Wjhd7UUzlJnch769Os7GQpdkE
         fHOCDOiS2odl8PzdwKDStOcKJ/X+2z9i8+QOv9LSNaFibXZnpX7iwceVDuTgq2GOth96
         124w==
X-Gm-Message-State: AOAM531ZQZdqnBySUyoMHb0Ye9jtvC/H7D/x7XIZ0sbInHAvKB0j7u/c
        ykkaEPUF/WpqtYXSsxUJVNGycv1PYAtbpImmIhI1RQ==
X-Google-Smtp-Source: ABdhPJyGjOgv68/pB4ZQ6ie/RkmNrofIEy9Np05CrErKIjvd8UHlcfRLPU14yC2Z5KMc1SrLQK+oaTiM1zXYrATE5Ec=
X-Received: by 2002:a17:90b:1a8a:b0:1c5:f707:93a6 with SMTP id
 ng10-20020a17090b1a8a00b001c5f70793a6mr2804463pjb.110.1647924115093; Mon, 21
 Mar 2022 21:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com> <20220318193831.482349-3-oupton@google.com>
In-Reply-To: <20220318193831.482349-3-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 21 Mar 2022 21:41:39 -0700
Message-ID: <CAAeT=FwR-=U_0WvKqV4UTCmo8x1=atBVtTQeirwiF3XCo+S=1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
To:     Oliver Upton <oupton@google.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>
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

On 3/18/22 12:38 PM, Oliver Upton wrote:
> The SMCCC does not allow the SMC64 calling convention to be used from
> AArch32. While KVM checks to see if the calling convention is allowed in
> PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
> unadvertised PSCI v1.0+ functions.
>
> Check to see if the requested function is allowed from the guest's
> execution state. Deny the call if it is not.
>
> Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

BTW, considering the new kvm_psci_check_allowed_function()implementation
in the patch-1, it might be better to call kvm_psci_check_allowed_function()
from kvm_psci_call() instead?  Then, we could avoid the similar issue
next time we support a newer PSCI version.

Thanks,
Reiji


> ---
>   arch/arm64/kvm/psci.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index cd3ee947485f..0d771468b708 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -318,6 +318,10 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
>       if (minor > 1)
>               return -EINVAL;
>
> +     val = kvm_psci_check_allowed_function(vcpu, psci_fn);
> +     if (val)
> +             goto out;
> +
>       switch(psci_fn) {
>       case PSCI_0_2_FN_PSCI_VERSION:
>               val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
> @@ -378,6 +382,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
>               return kvm_psci_0_2_call(vcpu);
>       }
>
> +out:
>       smccc_set_retval(vcpu, val, 0, 0, 0);
>       return ret;
>   }
