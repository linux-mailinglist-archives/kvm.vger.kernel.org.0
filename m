Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF304617634
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 06:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiKCFcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 01:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKCFcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 01:32:14 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC40BBC2
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 22:32:13 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f63so769959pgc.2
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 22:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=plrjvAdTS0nKqwkjAzFhlx4V983yw9yOIJecZW8zvnc=;
        b=NcV+yCiuxWOVxIsZo319+y5TyEFngethA6CQP6BOwGlsAkmNTjQraFrrswRtPZlkpD
         SJRUCsZfHhroDFuc1HWmkqwVEVc2RVFlGiP5zvsmzzPynvcbshB4QamTuDtUOEEi6JX4
         BmUNoa7MFmnhIEnLohD39eY/9J7H2XyS5v3+5c2obyaUdJSs75ghA1uFF39Ky7NSG8YJ
         Fs1aAEnOM6YE3UXbpbHYeTtl8vatHs5B63YYsi93lW77Z447BjQnB4MN173r79lfZNfs
         EeCfl2gHHg6Bb2KUGH/aEOT1ThtG05EipcaO2uura2cCTvv3plIIwNol/Hx+i5Ii5y9/
         Z3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=plrjvAdTS0nKqwkjAzFhlx4V983yw9yOIJecZW8zvnc=;
        b=ITjXq8I8YvNb5Z/eJVbmqDOJsWTZKOj2VxEAS786aUXSkZQ0+Jmhh71PJkVVJc4klz
         PvGbUSeqB0rX1/EEfZJXAPwbi1cmmQ3OwmcPyZkUpCaSGrGHXOo0ZakFI+VAEB18HAPE
         Aqz+YSU06ea9shI9/4+yXc1xKsVASCVktQPU0sOJUJffnH2O81vRIFj8ou/cQFzvR8/I
         jx5W8P3P7BooPIAUUHHQkF3ky+3QaVwi8Rxfq742cXIOHKEwgAvi3Mpbng+XUj8QVFKA
         64KX+4g3F6dxuAY2QzI/XiFIAAmy/GMklccGCawO2d6yBcqQblT/ckXgKm310r9OM4h0
         Cg6w==
X-Gm-Message-State: ACrzQf1UQMlzmeYtp9/e/NRiUssU4f5TsadBzX2K8XFxuUn+1FaJEwhj
        mtpOmFmcq+glnRkO5y3MkVCs6s1xLe/M/+xI/3jWtA==
X-Google-Smtp-Source: AMsMyM4AzbIHrwu7GJ3+G6SgGpmo5sXra8QVKVVvusdM6c9LC+09ZHIwSIQNdprt/hyAqQXhcjpMftwwP6uibr705Fk=
X-Received: by 2002:a63:db58:0:b0:443:575e:d1ed with SMTP id
 x24-20020a63db58000000b00443575ed1edmr24344874pgi.468.1667453533101; Wed, 02
 Nov 2022 22:32:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-12-maz@kernel.org>
In-Reply-To: <20221028105402.2030192-12-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 2 Nov 2022 22:31:56 -0700
Message-ID: <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Oct 28, 2022 at 4:16 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7a4cd644b9c0..4fa14b4ae2a6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1247,6 +1247,40 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +                              const struct sys_reg_desc *rd,
> +                              u64 val)
> +{
> +       u8 pmuver, host_pmuver;
> +
> +       host_pmuver = kvm_arm_pmu_get_pmuver_limit();
> +
> +       /*
> +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> +        * as it doesn't promise more than what the HW gives us. We
> +        * allow an IMPDEF PMU though, only if no PMU is supported
> +        * (KVM backward compatibility handling).
> +        */

It appears the patch allows userspace to set IMPDEF even
when host_pmuver == 0.  Shouldn't it be allowed only when
host_pmuver == IMPDEF (as before)?
Probably, it may not cause any real problems though.


> +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
> +       if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver)
> +               return -EINVAL;
> +
> +       /* We already have a PMU, don't try to disable it... */
> +       if (kvm_vcpu_has_pmu(vcpu) &&
> +           (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF))
> +               return -EINVAL;

Nit: Perhaps it might be useful to return a different error code for the
above two (new) error cases (I plan to use -E2BIG and -EPERM
respectively for those cases with my ID register series).

Thank you,
Reiji

> +
> +       /* We can only differ with PMUver, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd);
> +       val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +       if (val)
> +               return -EINVAL;
> +
> +       vcpu->kvm->arch.dfr0_pmuver = pmuver;
> +
> +       return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1508,7 +1542,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         ID_UNALLOCATED(4,7),
>
>         /* CRm=5 */
> -       ID_SANITISED(ID_AA64DFR0_EL1),
> +       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
> +         .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5,2),
>         ID_UNALLOCATED(5,3),
> --
> 2.34.1
>
>
