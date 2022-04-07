Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC574F8896
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 22:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiDGURo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 16:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiDGURl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 16:17:41 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E94882D0
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 13:14:11 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id p135so2314170iod.2
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 13:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kPv+ZIqzYvRek0cRdeMz/lWApF7cflqzGAwQSPk+D1g=;
        b=Vwbqolr+6WT9PZrvXSXV5eov3RfxCF9Upd51VWIyqZ1pqFcKZHmhRT9XnGsCkAHh05
         77l+zhWDpahLE5pUMG2B9j/nHIow4aw7XhZE+CsSD6z70hacoC3z1u+YNAcvKOfmrl3z
         fozVlMJs5iyRJSBg08fuwghJvWzY560AYZL5ZuaFcEn1PyVflPyG6JqaZHWqg2VH9Dfm
         OsUOi04iKG8rhuloDFnUSFpDocTzzSV6TJdRNMR01P/OfGl0U+E/ZBMTWX3uW0CSCFhQ
         si22K91rT3Z2Gb69hvZGq6tifarLk26cRL26z+WGWPuJmDLabL4zz9Fz0utJth5ajpZ/
         o2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kPv+ZIqzYvRek0cRdeMz/lWApF7cflqzGAwQSPk+D1g=;
        b=4CBfVz3wDi2O2ROEbzDLheBaptlN3qK0KpPbQkmpGHV4QALH5tx6ODPWqw5W0+G/11
         iy3d0qkntSm+gMPhDT8Prd7LtsfsnE5UeKiuDhB0AbrGyA1LMVqFJ8CQR//p8n94wu2M
         Cx9seMIb3FmeEUjA7nPK4yTJ2iohV5lxcm3brBOZCPUftoAu42AA3TO3nljX7FTD1QyT
         jpnPy5fUb3YmahdBmZ4LOKMM7yi0wJSGNtsTZ8JpCKn1FEqsYA6m+ruC28jzYw9Z8Cku
         sRVYypA2m3WeYtopVdJYd07GGKGlf/BcA4wo9b+3/toPeeMQTQZSarzbcuCTiMkz3OLs
         mRKg==
X-Gm-Message-State: AOAM530Tt8zz1mcRWxKB5sXcASuB/GfB7wZd08V+9XAMaSJCfunrJj4h
        TvL9XS6l2h0GFWYMztB8FnKbIg==
X-Google-Smtp-Source: ABdhPJx5V2vUqUS2eTOHLtK7IH0eyx7bh5pFcMTMmAj8gSnHQ2ix1EFqPmZe47max8+jfJKS65ClQQ==
X-Received: by 2002:a05:6638:d47:b0:321:460a:88c8 with SMTP id d7-20020a0566380d4700b00321460a88c8mr7430290jak.175.1649362406410;
        Thu, 07 Apr 2022 13:13:26 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id m9-20020a0566022ac900b0064cf3d9f35fsm8889296iov.35.2022.04.07.13.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 13:13:25 -0700 (PDT)
Date:   Thu, 7 Apr 2022 20:13:22 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 1/4] irqchip/gic-v3: Exposes bit values for
 GICR_CTLR.{IR,CES}
Message-ID: <Yk9F4jkfmYKdvUHz@google.com>
References: <20220405182327.205520-1-maz@kernel.org>
 <20220405182327.205520-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405182327.205520-2-maz@kernel.org>
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

On Tue, Apr 05, 2022 at 07:23:24PM +0100, Marc Zyngier wrote:
> As we're about to expose GICR_CTLR.{IR,CES} to guests, populate
> the include file with the architectural values.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  include/linux/irqchip/arm-gic-v3.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 12d91f0dedf9..728691365464 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -127,6 +127,8 @@
>  #define GICR_PIDR2			GICD_PIDR2
>  
>  #define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
> +#define GICR_CTLR_CES			(1UL << 1)
> +#define GICR_CTLR_IR			(1UL << 2)
>  #define GICR_CTLR_RWP			(1UL << 3)
>  
>  #define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
> -- 
> 2.34.1
> 
