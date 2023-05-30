Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EAB716E2B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 21:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjE3Ty7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 15:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjE3Ty6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 15:54:58 -0400
Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [IPv6:2001:41d0:1004:224b::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283EEB2
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 12:54:57 -0700 (PDT)
Date:   Tue, 30 May 2023 19:54:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685476495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=htwngbgIM6ZN3m6ZvTP5t2aYi4SJcXt18PpdVgVHy80=;
        b=Nwl2017bgJ899tFHJGB9HffKOzY3lgGKfnWiGeFSxr5rZCDIHtgQL/uvnQ9zbnW80mmi7w
        4Ls9VxkU7VgpAQ3DwWx8PgiwSRxnWknxVEk4+ZOg13JRGX94IrtSeYqxTTtdJN3FMqThqX
        q4QsyL705SyPIvgUeorNLzAnkXgbXBo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 02/17] arm64: Prevent the use of
 is_kernel_in_hyp_mode() in hypervisor code
Message-ID: <ZHZUi/4kXxRmCa7a@linux.dev>
References: <20230526143348.4072074-1-maz@kernel.org>
 <20230526143348.4072074-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526143348.4072074-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, May 26, 2023 at 03:33:33PM +0100, Marc Zyngier wrote:
> Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
> mistake. This helper only checks for CurrentEL being EL2, which
> is always true.
> 
> Make the link fail if using the helper in hypervisor context
> by referencing a non-existent function. Whilst we're at it,
> flag the helper as __always_inline, which it really should be.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/virt.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 4eb601e7de50..91029709d133 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -110,8 +110,13 @@ static inline bool is_hyp_mode_mismatched(void)
>  	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
>  }
>  
> -static inline bool is_kernel_in_hyp_mode(void)
> +extern void gotcha_is_kernel_in_hyp_mode(void);
> +
> +static __always_inline bool is_kernel_in_hyp_mode(void)
>  {
> +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> +	gotcha_is_kernel_in_hyp_mode();
> +#endif
>  	return read_sysreg(CurrentEL) == CurrentEL_EL2;
>  }

Would BUILD_BUG() work in this context, or have I missed something?

-- 
Thanks,
Oliver
