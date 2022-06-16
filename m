Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDA854DF14
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 12:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiFPK2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 06:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359684AbiFPK2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 06:28:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD7418E08;
        Thu, 16 Jun 2022 03:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IzpU0kY7tUMjtcFH9NwocxDzMvWVXiIhnYZnqlAGHvM=; b=DyFv66yjBbkwUwrYUk3RvcTcJ/
        gC+GejpeBAQSO2HKrjfdHbLk3nZdfnNhcsJElCrmVJR338C4Bi2h6RB6cmtXh+mvHorw4YkmRFcDC
        q/ahoAFr8wwDIacCoOo61vlMdlIbfNZMUkCNcIpOwYUJZcRnG1K+cOOXhLomoDRWmjSasjUodrkR3
        jidNajaK9IrObf/UGpaA3cQwxxxK9RE07Af8qlqRkFVleWknZXVyz3CzGiCVhVY7qI+Cbi7WOXrcl
        acPmkF0cDBnHexpd57y6nR2gH0VDYIfnORbiYdw76rJk5tptcZT4wKQjhq2Gf+ndmfFbuGLCuC1W5
        1HnkllHw==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1mj5-001rv0-QJ; Thu, 16 Jun 2022 10:27:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 34582302D3E;
        Thu, 16 Jun 2022 12:27:47 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1D2AC200B5F27; Thu, 16 Jun 2022 12:27:47 +0200 (CEST)
Date:   Thu, 16 Jun 2022 12:27:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 04/19] x86/fpu/xstate: Introduce CET MSR and XSAVES
 supervisor states
Message-ID: <YqsFo+PdIlXfnJQM@hirez.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-5-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616084643.19564-5-weijiang.yang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 04:46:28AM -0400, Yang Weijiang wrote:
> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> index eb7cd1139d97..03aa98fb9c2b 100644
> --- a/arch/x86/include/asm/fpu/types.h
> +++ b/arch/x86/include/asm/fpu/types.h
> @@ -115,8 +115,8 @@ enum xfeature {
>  	XFEATURE_PT_UNIMPLEMENTED_SO_FAR,
>  	XFEATURE_PKRU,
>  	XFEATURE_PASID,
> -	XFEATURE_RSRVD_COMP_11,
> -	XFEATURE_RSRVD_COMP_12,
> +	XFEATURE_CET_USER,
> +	XFEATURE_CET_KERNEL_UNIMPLEMENTED_SO_FAR,
>  	XFEATURE_RSRVD_COMP_13,
>  	XFEATURE_RSRVD_COMP_14,
>  	XFEATURE_LBR,
> @@ -138,6 +138,8 @@ enum xfeature {
>  #define XFEATURE_MASK_PT		(1 << XFEATURE_PT_UNIMPLEMENTED_SO_FAR)
>  #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
>  #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
> +#define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
> +#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNIMPLEMENTED_SO_FAR)
>  #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
>  #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
>  #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)

I'm not sure about that UNIMPLEMENTED_SO_FAR thing, that is, I'm
thinking we *never* want XSAVE managed S_CET.
