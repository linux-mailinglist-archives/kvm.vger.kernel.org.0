Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C530D54DED4
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 12:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiFPKYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 06:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiFPKYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 06:24:31 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA2E5A2D3;
        Thu, 16 Jun 2022 03:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ONvx+l+n21mU4SRMI+oxjSdQZ0rMJlHHALZTxjAM1Bg=; b=YlxyFmKu9FBt9QLtgjDJ36ZcVP
        lYzM3bMHpkozc7Vb4eCjlCw8vGWfVrvU/Og+v/+FE/o8TKG6Gi/IgUkt4oFrb406ou9q08mfRXzse
        xLRlkn4l58cdVNRLICUm3WXDkUtmwBNnztn0CP/DeQiI8j/cHhl2+R2lHzg0RSDzD2MLgoTDIiTfj
        sX+HL9O612L+2EhT9onFJo1LMZCY6m5d6pl5Psej0ZbO7qY9QLaYYqU0coZknMyvXX88fUqL1nFjS
        i7ZIx/ZmajGpa+fHturGlwgIHlrTxXcvHueci+T+FgXjROkU+flekWQrbpCkxg9hI6LTLHZokpP7z
        Vm+DiywQ==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1mfb-008OFr-Gk; Thu, 16 Jun 2022 10:24:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 02615302AC0;
        Thu, 16 Jun 2022 12:24:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E04912019864B; Thu, 16 Jun 2022 12:24:10 +0200 (CEST)
Date:   Thu, 16 Jun 2022 12:24:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Message-ID: <YqsEyoaxPFpZcolP@hirez.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-4-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616084643.19564-4-weijiang.yang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 04:46:27AM -0400, Yang Weijiang wrote:
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -74,7 +74,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
>  static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
>  #endif
>  
> -extern __noendbr void cet_disable(void);
> +extern __noendbr void ibt_disable(void);
>  
>  struct ucode_cpu_info;
>  
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index c296cb1c0113..86102a8d451e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -598,23 +598,23 @@ __noendbr void ibt_restore(u64 save)

>  
> -__noendbr void cet_disable(void)
> +__noendbr void ibt_disable(void)
>  {
>  	if (cpu_feature_enabled(X86_FEATURE_IBT))
>  		wrmsrl(MSR_IA32_S_CET, 0);

Not sure about this rename; it really disables all of (S) CET.

Specifically, once we do S-SHSTK (after FRED) we might also very much
need to kill that for kexec.

> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 0611fd83858e..745024654fcd 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -311,7 +311,7 @@ void machine_kexec(struct kimage *image)
>  	/* Interrupts aren't acceptable while we reboot */
>  	local_irq_disable();
>  	hw_breakpoint_disable();
> -	cet_disable();
> +	ibt_disable();
>  
>  	if (image->preserve_context) {
>  #ifdef CONFIG_X86_IO_APIC
> -- 
> 2.27.0
> 
