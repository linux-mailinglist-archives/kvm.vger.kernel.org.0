Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502BC76954B
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 13:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbjGaLy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 07:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjGaLyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 07:54:24 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27F01A4
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:54:22 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-521e046f6c7so11643a12.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690804461; x=1691409261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gz0q8+TIeyvXDOgRq+KfnkJDaIgp0/SlphpP3zWMP/E=;
        b=XRNsIN1avnppiien8YxCEWFle10nCOmQ+kwurgqaTXK0d2hjk8sJ+Ez1rQAOq3cAGX
         b/Kd3eGu49FAfCui72UHxLWSCtAf6qJDx2di4Zfl60Y14XySIsSPy8mV+P76SFt+BpLa
         eHR3EWbi1KvWolPrA9VVohRqCOM6koDVX1cOGBtK+4ThU6XoZW/v4FnWXP+OVQ25lfwI
         DmErcvzFD3HDVpRQKPSzNEc+GltK8yySRKypZw9dKIx5BHmSu0cS9vqhQuG1LoLcpD06
         TaZg0uTME4TA9uAedn2CS7DEBVPlsDhIgYO19YgP/80uUvbfqMV0RObGTudCVNhI7IwJ
         1s4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690804461; x=1691409261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gz0q8+TIeyvXDOgRq+KfnkJDaIgp0/SlphpP3zWMP/E=;
        b=ifIZWRuvOAAjhHsY1B3eAeGzL6FPtxy5cEm2K8nsCQKK1jdOkmpRyOCsFAwgRnUVXh
         Ud+S02qURryGcOkODnbahKQBTlfiRYXaT/TRgljm8BOlq8DQgwBNVBa3NWE+pEDa2x+i
         FuE9totonw6p5vqG2Bz6IsPpoiufJmnfPZyjYtxc35ndDpajEE0oZjbGTvP1bhzowYmg
         Ux243HU75LCmv33L+6no98G1sfKjEGACIYpafrdGt2wnnJ7O8xGQbbzdtjStQ1FuixG+
         cpy/l5hJZZNaUbui53nAHNOwqeSmcGVMujLQv+EjqI2Yv3Tc/ykLvx2klwn27s007pwx
         bo/A==
X-Gm-Message-State: ABy/qLYwpGkRbgpnYQYipr7joTXRBynPWtwhuMmUXXVIlM8Q8AvNBu/J
        beNMbH3kEv7tCrYnQ4j+IR/7vUjKdUEtzPXP3PFsEA==
X-Google-Smtp-Source: APBJJlH9ttptvP7TRn9A19ifvlq3YB7zBN0BwZYm9jpsOz2Ht0ztBRLCTPm1vh9MkDMgZpKHpde9CgVynyUPQZ/Yfsc=
X-Received: by 2002:a50:f69e:0:b0:522:3c11:1780 with SMTP id
 d30-20020a50f69e000000b005223c111780mr155438edn.0.1690804460991; Mon, 31 Jul
 2023 04:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com> <20230728181907.1759513-3-reijiw@google.com>
 <ZMQckrDB7tg9gPfw@linux.dev>
In-Reply-To: <ZMQckrDB7tg9gPfw@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 31 Jul 2023 04:54:04 -0700
Message-ID: <CAAeT=FyC42s=kcS3QTC6A-s6EZjhoQL7XJyxWCb5YyisJrQvdg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: PMU: Disallow vPMU on non-uniform
 PMUVer systems
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

> This doesn't actually disallow userspace from configuring a vPMU, it
> only hides the KVM cap. kvm_host_pmu_init() will still insert the host
> PMU instance in the list of valid PMUs, and there doesn't appear to be
> any check against the static key anywhere on that path.

In v6.5-rc3, which I used as the base, or even in v6.5-rc4,
it appears kvm_reset_vcpu() checks against the static key.
So, the initial KVM_ARM_VCPU_INIT with vPMU configured will
fail on the systems.  Or am I missing something ? (Or is that
going to be removed by other patches that are already queued?)

But, right, it still insert the host PMU instance in the list,
which is unnecessary.

> I actually prefer where we flip the static key, as PMU context switching
> depends on both KVM support as well as the PMU driver coming up successfully.
> Instead, you could hoist the check against the sanitised PMU version into
> kvm_host_pmu_init(), maybe something like:

Thank you, it looks better.  I will fix this in v3.

Thank you,
Reiji

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 560650972478..f6a0e558472f 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -672,8 +672,11 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>  {
>         struct arm_pmu_entry *entry;
>
> -       if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
> -           pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> +       /*
> +        * Check the sanitised PMU version for the system, as KVM does not
> +        * support implementations where PMUv3 exists on a subset of CPUs.
> +        */
> +       if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
>                 return;
>
>         mutex_lock(&arm_pmus_lock);
>
> --
> Thanks,
> Oliver
