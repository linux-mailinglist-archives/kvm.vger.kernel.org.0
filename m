Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D1E7761A6
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 15:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjHINuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 09:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjHINug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 09:50:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3669C1BF2;
        Wed,  9 Aug 2023 06:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Yst4B8hD/79MvOiF+5jRhmcwmW6MZ3WcmPh0i3Qo7GI=; b=eEvJyL8PbwGPUTKsMVl0u6B/Y6
        +4+5cPPONCvyflJvBQ+VaTti1/aTTC5G7U+ozCA9csJzELMe6OL4WlAqRGEVnkfego00LlkCIqqTA
        UQuODJmsDl/TcSiyo8n9z5FWWAkIzRefYv4nnqN8C2996h4bPvuHBYdXgq5NR4PEoZ3zi7jQY0c3e
        iLdY3UY3GroItDuiZ8RLxGENTD2EZnyRLmjsSczT7J2HuPPLdRwqBT8/Xh8iSIF1BjXBhi7p2eVO0
        WNn1Pd91X6VW8usw7Pdxnt9vfmIOXKSLpcOVmeCNsl4fgqWQs4ItOOg0MJUl35BbQoNk0hiIVCYHo
        JjecXlpg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qTjZG-006Vfb-Dx; Wed, 09 Aug 2023 13:49:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1438C30003A;
        Wed,  9 Aug 2023 15:49:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F340D20208EAB; Wed,  9 Aug 2023 15:49:41 +0200 (CEST)
Date:   Wed, 9 Aug 2023 15:49:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mihai Carabas <mihai.carabas@oracle.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 5/7] arm64: Select ARCH_HAS_CPU_RELAX
Message-ID: <20230809134941.GN212435@hirez.programming.kicks-ass.net>
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
 <1691581193-8416-6-git-send-email-mihai.carabas@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1691581193-8416-6-git-send-email-mihai.carabas@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 02:39:39PM +0300, Mihai Carabas wrote:
> From: Joao Martins <joao.m.martins@oracle.com>
> 
> cpu_relax() is necessary to allow cpuidle poll-state to be used,
> so select it from ARM64 kconfig.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> ---
>  arch/arm64/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 87ade6549790..7c47617b5722 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -105,6 +105,7 @@ config ARM64
>  	select ARCH_WANT_LD_ORPHAN_WARN
>  	select ARCH_WANTS_NO_INSTR
>  	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
> +	select ARCH_HAS_CPU_RELAX
>  	select ARCH_HAS_UBSAN_SANITIZE_ALL
>  	select ARM_AMBA
>  	select ARM_ARCH_TIMER

Uh what ?! cpu_relax() is assumed present on all archs, no?


