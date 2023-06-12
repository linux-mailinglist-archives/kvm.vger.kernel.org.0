Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B8E72CC39
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbjFLRQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 13:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbjFLRQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 13:16:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CAA1727
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 10:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F86862087
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 17:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DA5C433D2;
        Mon, 12 Jun 2023 17:16:20 +0000 (UTC)
Date:   Mon, 12 Jun 2023 18:16:18 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 03/17] arm64: Turn kaslr_feature_override into a
 generic SW feature override
Message-ID: <ZIdS4o1H6ePRLaKp@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-4-maz@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 05:21:46PM +0100, Marc Zyngier wrote:
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 370ab84fd06e..8c93b6198bf5 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -138,15 +138,11 @@ static const struct ftr_set_desc smfr0 __initconst = {
>  	},
>  };
>  
> -extern struct arm64_ftr_override kaslr_feature_override;
> -
> -static const struct ftr_set_desc kaslr __initconst = {
> -	.name		= "kaslr",
> -#ifdef CONFIG_RANDOMIZE_BASE
> -	.override	= &kaslr_feature_override,
> -#endif
> +static const struct ftr_set_desc sw_features __initconst = {
> +	.name		= "arm64_sw",
> +	.override	= &arm64_sw_feature_override,
>  	.fields		= {
> -		FIELD("disabled", 0, NULL),
> +		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
>  		{}
>  	},
>  };
> @@ -158,7 +154,7 @@ static const struct ftr_set_desc * const regs[] __initconst = {
>  	&isar1,
>  	&isar2,
>  	&smfr0,
> -	&kaslr,
> +	&sw_features,
>  };
>  
>  static const struct {
> @@ -175,7 +171,7 @@ static const struct {
>  	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "
>  	  "id_aa64isar2.gpa3=0 id_aa64isar2.apa3=0"	   },
>  	{ "arm64.nomte",		"id_aa64pfr1.mte=0" },
> -	{ "nokaslr",			"kaslr.disabled=1" },
> +	{ "nokaslr",			"arm64_sw.nokaslr=1" },
>  };

I think structuring it as a sw feature makes more sense and I don't
think it breaks anything (as long as people only used "nokaslr").

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

As a side note, I was wondering if we should add a SW_FIELD macro to
define width of 1 for such fields (and probably the field extraction
functions need some tweaking) so that we define
ARM64_SW_FEATURE_OVERRIDE_* in increments of 1 rather than 4. Anyway,
that's something to worry if we get too many such software features.

-- 
Catalin
