Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9AB519772
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 08:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343894AbiEDGjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 02:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbiEDGjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 02:39:11 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDAF6397
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 23:35:34 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e15so572556iob.3
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 23:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5vzaRTCV35kUkQfzNk+SKbEZOUsmK/lhYqqKeLrO+iA=;
        b=nY7I8v9LmP+4+y+Pl5sP80ms0losTfV9G/Y4PGylKqQxcdscu+cYTM+ORUo92C4kUt
         O7aDwIZq9zv1kk5qQCYC3SS8FWkEGveM1Huk39aQLx02Mj20oi6WhjeLWZDBe9OV7EWI
         rdN57Mw0ScAJPvugQHwUwkv9Q1Qkba/kaBpkxO2DnP0t1NUTZEkbCqCxtbYadsfI7XYg
         EHwpwS70sBGfwALZnLVWWslcWVF0my2IMURLbG7/TLEMOvb9A4QT57ksbl1We5aIKhaK
         Re++9wvrBCNiT7UJ5yppLUpD6+2A3bhjBU12ZS2pfjMgS6OhmD3a3x2WJBNmVOScw/i/
         /ANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5vzaRTCV35kUkQfzNk+SKbEZOUsmK/lhYqqKeLrO+iA=;
        b=enKmvoXT92E4o7vHZ5mIXFNYhjbijRZUHTBdHZpjVrJ+u3EtM4Oft9QmYDHXDa/4KE
         YgQZ5/kaRfULqG/3N5EhjwP7+ESE9dH/Ib7/BfqKeaRx2HktaaeZmJTXAYRVSfp6WEmQ
         aysiB4HUk4u8HnS4bsV0LjwjV/Ck++1FzWzrvLKBqVJa4PhQzyRtYJjDiZXYD1Hts50s
         etqIqKWcp7k9E4j0sJM+2ucz91xWsKBoc/WPrT304DwLH7nAq41bhsp/uKSkbWLJ9a5S
         xVJW1AGtOY9kwaPnD8YudhltzAsxHaycRS3+rEyn1vDEFrwODsPNB3wfOJwd03+M09tN
         we3g==
X-Gm-Message-State: AOAM530pBMZm2gi8caDzyeEeDvDmAyuo48aUO0/IvO6XpwVp7v0vNCjR
        ufcsveo6J6WtFuKlwGUqAeBpZ6srPISFy4Lh
X-Google-Smtp-Source: ABdhPJwbDoRQpuN7Pfwdsey3kldhkCPsI++0DJuLGbXAwnQJK4QnnF38LPx899UzWmlKxd1ScbQAZQ==
X-Received: by 2002:a02:6f47:0:b0:32b:2be7:e3e4 with SMTP id b7-20020a026f47000000b0032b2be7e3e4mr7911068jae.305.1651646134045;
        Tue, 03 May 2022 23:35:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id w26-20020a02b0da000000b0032b3a781784sm4480757jah.72.2022.05.03.23.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 23:35:33 -0700 (PDT)
Date:   Wed, 4 May 2022 06:35:29 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>, h@google.com
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
Subject: Re: [PATCH v7 01/38] KVM: arm64: Introduce a validation function for
 an ID register
Message-ID: <YnIesawWNhBwZydM@google.com>
References: <20220419065544.3616948-1-reijiw@google.com>
 <20220419065544.3616948-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419065544.3616948-2-reijiw@google.com>
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

On Mon, Apr 18, 2022 at 11:55:07PM -0700, Reiji Watanabe wrote:
> Introduce arm64_check_features(), which does a basic validity checking
> of an ID register value against the register's limit value, which is
> generally the host's sanitized value.
> 
> This function will be used by the following patches to check if an ID
> register value that userspace tries to set for a guest can be supported
> on the host.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  1 +
>  arch/arm64/kernel/cpufeature.c      | 52 +++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index c62e7e5e2f0c..7a009d4e18a6 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -634,6 +634,7 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  u64 __read_sysreg_by_encoding(u32 sys_id);
> +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit);
>  
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index d72c4b4d389c..dbbc69745f22 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -3239,3 +3239,55 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>  		return sprintf(buf, "Vulnerable\n");
>  	}
>  }
> +
> +/**
> + * arm64_check_features() - Check if a feature register value constitutes
> + * a subset of features indicated by @limit.
> + *
> + * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
> + * an item whose width field is zero.
> + * @val: The feature register value to check
> + * @limit: The limit value of the feature register
> + *
> + * This function will check if each feature field of @val is the "safe" value
> + * against @limit based on @ftrp[], each of which specifies the target field
> + * (shift, width), whether or not the field is for a signed value (sign),
> + * how the field is determined to be "safe" (type), and the safe value
> + * (safe_val) when type == FTR_EXACT (safe_val won't be used by this
> + * function when type != FTR_EXACT). Any other fields in arm64_ftr_bits
> + * won't be used by this function. If a field value in @val is the same
> + * as the one in @limit, it is always considered the safe value regardless
> + * of the type. For register fields that are not in @ftrp[], only the value
> + * in @limit is considered the safe value.
> + *
> + * Return: 0 if all the fields are safe. Otherwise, return negative errno.
> + */
> +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit)
> +{
> +	u64 mask = 0;
> +
> +	for (; ftrp->width; ftrp++) {
> +		s64 f_val, f_lim, safe_val;
> +
> +		f_val = arm64_ftr_value(ftrp, val);
> +		f_lim = arm64_ftr_value(ftrp, limit);
> +		mask |= arm64_ftr_mask(ftrp);
> +
> +		if (f_val == f_lim)
> +			safe_val = f_val;
> +		else
> +			safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
> +
> +		if (safe_val != f_val)
> +			return -E2BIG;
> +	}
> +
> +	/*
> +	 * For fields that are not indicated in ftrp, values in limit are the
> +	 * safe values.
> +	 */
> +	if ((val & ~mask) != (limit & ~mask))
> +		return -E2BIG;

This bit is interesting. Apologies if I paged out relevant context. What
features are we trying to limit that exist outside of an arm64_ftr_bits
definition? I'll follow the series and see if I figure out later :-P

Generally speaking, though, it seems to me that we'd prefer to have an
arm64_ftr_bits struct plumbed up for whatever hits this case.

--
Thanks,
Oliver
