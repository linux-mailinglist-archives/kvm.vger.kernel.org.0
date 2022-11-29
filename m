Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32F263C9E4
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbiK2UwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiK2UwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:52:17 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C07313D58
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:52:16 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d3so9645384plr.10
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=52SMROLRGWbt9mwpSBUjPx/3msXb6vFt7ItVy/cqB1k=;
        b=VhKagD+9381ydRAyKPEL5EsmY+AM67HAZZ/33h8VvA8l2VXlMlKxq+fM5BueYSKXKt
         MlYUlT1r2orjroDtbBdQLFNwyfElcb4r+5lE0sxkugaizGLV5rqQhubBgdx5ttpa3za0
         oliMzzN9b4nvEx2UounppSrAbCEbsdm/nmGfxJve0S1hIp8oK/34PAiQq2P0gRHNpQON
         Hed36jy70ZutuQ+XKz5nU9QmAvnQT6CmU+OyL+RjADMzi1jdYipeoPsS5VzO7M2oqh+q
         oUjXehpCZSlKTc1/n9q+Fw+1tkSNk+0rW8qA5VeEmwAbYZihapsyiUMqxDw9ljYAQ/PU
         SMqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52SMROLRGWbt9mwpSBUjPx/3msXb6vFt7ItVy/cqB1k=;
        b=4LWnibndTn+sqgZJBj95/okWTkWs6Dbm2tXIhYfmDNTQdqqymCtwNvROz8QvxYsNiB
         b7AL/DogfL1z7pzf+y50dgyWVImMhQoyER6JbzyrQoBMCh4flzgdGeqddgems5gKDLin
         YR8s3wyVr0+UlL9YVq8j6N6jqX2eqOjjLP9WQJjbhFlU4ii2xTwrFHXtJ1TgXhfViBTU
         TCPrR8dK7DH7/zHhsLyVZ2/epERye4x57WMYymVNjGlXo4I88MBOCQW+IsdGb5Ut7rIl
         0Y7QAiOCKOO8CCTjRBlrx1xmL3z2UtqmtuEvpAf/ATiOpN06pGwj6PWwo5wGCB2carUz
         DlGg==
X-Gm-Message-State: ANoB5pn4WHPoUdJW38noUuvGPGMl6RFwVpCuCV6jM3PdjoZBGA9J+leN
        rJNvEJGvA79V53K46PlafmXNoA==
X-Google-Smtp-Source: AA0mqf5zWdkH3xH2EphKKbDCqWzEBIeWxi3op3Of+IS1hUt3Omy1pEG69elJYrpi56m64lfNCX6qYA==
X-Received: by 2002:a17:902:7790:b0:189:9973:fb58 with SMTP id o16-20020a170902779000b001899973fb58mr5888074pll.59.1669755135786;
        Tue, 29 Nov 2022 12:52:15 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id c31-20020a17090a492200b00218b32f6a9esm1784905pjh.18.2022.11.29.12.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:52:15 -0800 (PST)
Date:   Tue, 29 Nov 2022 12:52:12 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4Zw/J3srTsZ57P7@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129191946.1735662-3-oliver.upton@linux.dev>
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

On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> Of course, if the PTE wasn't changed then there are absolutely no
> serialization requirements. Skip the DSB for an unsuccessful update to
> the access flag.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11cf2c618a6..9626f615d9b8 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1094,9 +1094,13 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
>  {
>  	kvm_pte_t pte = 0;
> -	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> -				 &pte, NULL, 0);
> -	dsb(ishst);
> +	int ret;
> +
> +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> +				       &pte, NULL, 0);
> +	if (!ret)
> +		dsb(ishst);

At the moment, the only reason for stage2_update_leaf_attrs() to not
update the PTE is if it's not valid:

	if (!kvm_pte_valid(pte))
			return 0;

I guess you could check that as well:

+	if (!ret || kvm_pte_valid(pte))
+		dsb(ishst);

> +
>  	return pte;
>  }
>  
> -- 
> 2.38.1.584.g0f3c55d4c2-goog
> 
> 
