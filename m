Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F9D54DF08
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 12:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376528AbiFPKZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 06:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376565AbiFPKZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 06:25:47 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CBB5D66B;
        Thu, 16 Jun 2022 03:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qCNpGrURBOL5WaNoLGR+TiQCsTHpJ5I4gKVYyIhMhq4=; b=FsauEinDYWkzDJi5mojX/TZe65
        lhNmxUtxP2pUmxCmju1Svy+Zmfw6k0+HME+T5kz5y4DaZqL05DXRBDPQ5ZBbCXAleYGmk9c+ISABJ
        J5sEYMTRGp6rEB1nBt2TizrfHTYSaJWQtMsqtzTA6/8Zdk7rwXvjFW3Apao5lsWmfd3U4j1cpuMBU
        hVSmagMn9QAetw44+3uC+xxcyxo63NcoZSgoSa2g+JaomriVlZo1++TmZMHPHk3n0pewhqHA6J2sE
        c7/UdTd6L1wY9gS/UVnxWgIAO4/wJXsoSGAStjuG5QM6NFJ2amnzE4/iuapdRVSeUR68XHDt8Z/8s
        tTaPelNg==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1mgz-008OHI-SP; Thu, 16 Jun 2022 10:25:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 84116302E4D;
        Thu, 16 Jun 2022 12:25:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 75FC92019864B; Thu, 16 Jun 2022 12:25:37 +0200 (CEST)
Date:   Thu, 16 Jun 2022 12:25:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Message-ID: <YqsFIRDPvaEKMqIh@hirez.programming.kicks-ass.net>
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

>  static __always_inline void setup_cet(struct cpuinfo_x86 *c)
>  {
> +	bool kernel_ibt = HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT);
>  	u64 msr = CET_ENDBR_EN;
>  
> +	if (kernel_ibt)
> +		wrmsrl(MSR_IA32_S_CET, msr);
>  
> +	if (kernel_ibt || cpu_feature_enabled(X86_FEATURE_SHSTK))
> +		cr4_set_bits(X86_CR4_CET);

Does flipping the CR4 and S_CET MSR write not result in simpler code?

>  
> +	if (kernel_ibt && !ibt_selftest()) {
>  		pr_err("IBT selftest: Failed!\n");
>  		setup_clear_cpu_cap(X86_FEATURE_IBT);

Looking at this error path; I think I forgot to clear S_CET here.

>  		return;
>  	}
>  }
