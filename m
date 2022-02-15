Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEFB4B76AD
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbiBOSyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 13:54:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiBOSyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 13:54:09 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9BF8D68E
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 10:53:58 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id c188so25063804iof.6
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 10:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yx1B/cs7/hXpHc5o53p2VfNCQ8b83twxE6k0Rej+Yk8=;
        b=eAAyLSjaB5SUjk+1n/lRwJZogI1aqp2R5DvFmrEQYCGCf6geLREv7owAy5sYJpZn4N
         RXc11qrNNmvhuMoRR7Iz3p+76JR2CEhCqPCae+oW58ZndYMkAMrDp3vwWpaGYsydNs6l
         G5/vHS0A+vd9/pQj5TkbNLBjntdfQ7KdWAkDZOV9VsY+Q0I4dR+FQV3fcx4r3y8N4twT
         1ZipnLyI7ZEXovK6l81zFNw1qE6WIHXuEn51/aFFhUB4TsCMnkw6X1l4xwiFmyN7jRAI
         cL+MATrXMay6ss3mFgPrsiRqowhJXd7DCXd7noFnP+KXp11SApZA7miyQBPxyjRLCldQ
         kTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yx1B/cs7/hXpHc5o53p2VfNCQ8b83twxE6k0Rej+Yk8=;
        b=C9xseT6NhjGIAg+sqkQuzTn89TRJtc5c8XtEcrSzSKTlKGVfMGXQQ2He9Sen/TD/R+
         YDsyUfV6KKI9rzmsa5wI0/0OPzIvxV8uL38Z3vBKmjOxTcM3Ox3juw8EeosKQ4fVkW04
         Buf86QV4y9fqzip2t5pIJMqOTk5RwaYKXjvQlWqUSmaqt2L7g515u3P+JCHeb9SNR5ce
         SHH/hWyUCCHu/gT4QCtkS8lnng05Jr7aXfBJWmpMo1ssjIlU+1gJw4QWj97HGpotYXuN
         EuerYhiDJthlVAKkxs5oj073VN44ofdwp2qk1iKpDTTJA2tieMGU5WM4As36ptYKDM78
         lbFQ==
X-Gm-Message-State: AOAM530BddSw2Vidflc97Is48cQ45NMpybPlWJBfOtQ4eHsw3jB8poBy
        eB2Vu4NDqIRoB2/Hx3iFs6AY4w==
X-Google-Smtp-Source: ABdhPJzzeZLPtmDYqHqSvCizKyae+6eZF1KsXoBDzTL0pIOFtruI9XNo23MRTW5nI8sMZENvq4WhqA==
X-Received: by 2002:a05:6638:2217:: with SMTP id l23mr190891jas.190.1644951237062;
        Tue, 15 Feb 2022 10:53:57 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k9sm6734677ilv.31.2022.02.15.10.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 10:53:56 -0800 (PST)
Date:   Tue, 15 Feb 2022 18:53:53 +0000
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
Subject: Re: [PATCH v5 09/27] KVM: arm64: Make ID_AA64MMFR1_EL1 writable
Message-ID: <Ygv2wS8qdlu1YnA6@google.com>
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-10-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214065746.1230608-10-reijiw@google.com>
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

On Sun, Feb 13, 2022 at 10:57:28PM -0800, Reiji Watanabe wrote:
> This patch adds id_reg_info for ID_AA64MMFR1_EL1 to make it
> writable by userspace.
> 
> Hardware update of Access flag and/or Dirty state in translation
> table needs to be disabled for the guest to let userspace set
> ID_AA64MMFR1_EL1.HAFDBS field to a lower value. It requires trapping
> the guest's accessing TCR_EL1, which KVM doesn't always do (in order
> to trap it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which
> also traps many other virtual memory control registers).
> So, userspace won't be allowed to modify the value of the HAFDBS field.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4ed15ae7f160..1c137f8c236f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -570,6 +570,30 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int validate_id_aa64mmfr1_el1(struct kvm_vcpu *vcpu,
> +				     const struct id_reg_info *id_reg, u64 val)
> +{
> +	u64 limit = id_reg->vcpu_limit_val;
> +	unsigned int hafdbs, lim_hafdbs;
> +
> +	hafdbs = cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_HADBS_SHIFT);
> +	lim_hafdbs = cpuid_feature_extract_unsigned_field(limit, ID_AA64MMFR1_HADBS_SHIFT);
> +
> +	/*
> +	 * Don't allow userspace to modify the value of HAFDBS.
> +	 * Hardware update of Access flag and/or Dirty state in translation
> +	 * table needs to be disabled for the guest to let userspace set
> +	 * HAFDBS field to a lower value. It requires trapping the guest's
> +	 * accessing TCR_EL1, which KVM doesn't always do (in order to trap
> +	 * it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which also
> +	 * traps many other virtual memory control registers).
> +	 */
> +	if (hafdbs != lim_hafdbs)
> +		return -EINVAL;

Are we going to require that any hidden feature be trappable going
forward? It doesn't seem to me like there's much risk to userspace
hiding any arbitrary feature so long as identity remains architectural.

Another example of this is AArch32 at EL0. Without FGT, there is no
precise trap for KVM to intervene and prevent an AArch32 EL0.
Nonetheless, userspace might still want to hide this from its guests
even if a misbehaved guest could still use it.

--
Thanks,
Oliver
