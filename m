Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E564E5911
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 20:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344164AbiCWTXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 15:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiCWTXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 15:23:47 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72374888FB
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:22:17 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e22so2899191ioe.11
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JlMssrBS5MsWzr4IlAQ1DcKlCFmfRWojcGydLqsuTtY=;
        b=SMG6cDmX+eXpRQ94AqhVqDKxEoEuWDo5YwwCRBPkxeUSTJIBdfNA7sSU3zJkicwEgb
         aHqD6tW07HceqvJp6mNptONcqESdKtAJ4t4iK3VaQCsSF0JIO8nocEaUyLVKxno1lDKp
         6jbLYrMGLdeGqdhZ7MJissy9yA8ijNrm81J9D8pA8iklFPVM1EdLrAGKIt4r+cOZDoq/
         ZStvN0KQGX3lb7eNnqtliwowc3pZHjYv1PYJECBaXM0/o50dQdb25DOueNGYXNr9fPZp
         BMdZg0S7oX94Ty2B1QvUD17nhtXKWcKacDcl0Vr8Nix9ZDHa/GzSMHOmW+53X80mxxh1
         lVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JlMssrBS5MsWzr4IlAQ1DcKlCFmfRWojcGydLqsuTtY=;
        b=rR4sxSARosvBnNKodi3AKfAYncZt4EAbFSFeFw0FK1HYY+IURq6cxIp+bB6BXOjdC8
         Bl/gSsK5TkYeqKDXwaxSmadhqkoEGZcPn6cpvTCq2nDlDkZWG+1fWmMPO58vD7j/oj3Q
         5cdhKSQ3DG1anLAeyu8eICSeFdK2KFX5uqoBIE4drAKA2NaDgizvywJtt7iLWtnHt1J2
         FGTvi9UhGi5qUqSxx4jk7PPrN2RRnFiKL1ho1ScjnVCekf0o/q2YPW51M2bg2MDNE3uZ
         iAN//FqdLDYGZfr7lf5v37NbfF4Y51kBVrujnDdbupL2Vf17kzN5ce6E6fdXHoaeKKQC
         9mkg==
X-Gm-Message-State: AOAM532FqnTWDUF0REhCmwEuXcEs2H4aEmojFPJt2t59JgLSvoKBXRi+
        tLFI1N48ClJuznrKCHX5C4urgg==
X-Google-Smtp-Source: ABdhPJwngJg/5LHhODSUq+zIVlvVV5bBB3J5MW1sVvzghvqD9c55m4X7Zxu6PadTGaeTnZhTx2kmgQ==
X-Received: by 2002:a05:6602:1493:b0:649:1890:cffd with SMTP id a19-20020a056602149300b006491890cffdmr844378iow.167.1648063336566;
        Wed, 23 Mar 2022 12:22:16 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id d3-20020a056e020c0300b002c7b42b4b0esm422584ile.65.2022.03.23.12.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 12:22:15 -0700 (PDT)
Date:   Wed, 23 Mar 2022 19:22:12 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <YjtzZI8Lw2uzjm90@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311044811.1980336-3-reijiw@google.com>
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

Hi Reiji,

On Thu, Mar 10, 2022 at 08:47:48PM -0800, Reiji Watanabe wrote:
> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> Use the saved ones when ID registers are read by the guest or
> userspace (via KVM_GET_ONE_REG).
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 ++++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/sys_regs.c         | 65 ++++++++++++++++++++++++-------
>  3 files changed, 63 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2869259e10c0..c041e5afe3d2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -101,6 +101,13 @@ struct kvm_s2_mmu {
>  struct kvm_arch_memory_slot {
>  };
>  
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.

Doesn't the Feature ID register scheme only apply to CRm={1-7},
op2={0-7}? I believe CRm=0, op2={1-4,7} are in fact UNDEFINED, not RAZ
like the other ranges. Furthermore, the registers that are defined in
that range do not go through the read_id_reg() plumbing.

> + */
> +#define KVM_ARM_ID_REG_MAX_NUM	64
> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -137,6 +144,9 @@ struct kvm_arch {
>  	/* Memory Tagging Extension enabled for the guest */
>  	bool mte_enabled;
>  	bool ran_once;
> +
> +	/* ID registers for the guest. */
> +	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];

This is a decently large array. Should we embed it in kvm_arch or
allocate at init?

[...]

> +
> +/*
> + * Set the guest's ID registers that are defined in sys_reg_descs[]
> + * with ID_SANITISED() to the host's sanitized value.
> + */
> +void set_default_id_regs(struct kvm *kvm)

nit, more relevant if you take the above suggestion: maybe call it
kvm_init_id_regs()?

> +{
> +	int i;
> +	u32 id;
> +	const struct sys_reg_desc *rd;
> +	u64 val;
> +
> +	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {

You could avoid walking the entire system register table, since we
already know the start and end values for the Feature ID register range.

maybe:

  #define FEATURE_ID_RANGE_START	SYS_ID_PFR0_EL1
  #define FEATURE_ID_RANGE_END		sys_reg(3, 0, 0, 7, 7)

  u32 sys_reg;

  for (sys_reg = FEATURE_ID_RANGE_START; sys_reg <= FEATURE_ID_RANGE_END; sys_reg++)

But, it depends on if this check is necessary:

> +		rd = &sys_reg_descs[i];
> +		if (rd->access != access_id_reg)
> +			/* Not ID register, or hidden/reserved ID register */
> +			continue;

Which itself is dependent on whether KVM is going to sparsely or
verbosely define its feature filtering tables per the other thread. So
really only bother with this if that is the direction you're going.

--
Thanks,
Oliver
