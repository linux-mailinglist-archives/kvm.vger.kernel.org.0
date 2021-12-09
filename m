Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA3A46EC0B
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbhLIPrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbhLIPrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:47:48 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40ECEC061746;
        Thu,  9 Dec 2021 07:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cbf31VZp/BNeO379tb08hGLaCNwxgpsR+fp1ai8P2XY=; b=DpvXgGQnvw4mjktYjHGpHWN3K/
        a2aUpEVNxwGBwdMfdrkrlql8nw8D0Te2hN40jreJw3R7KsL8jM3kLcnE0s/ZbzS4rMeFyW4xcAfxP
        cavpqq0x3mwbX176fMAlo0Yrg5yCWitHV7eiTldNAk2EvuBdrna3kz1cWQyfk5vrfFjt27STmQUrI
        dzBeEZ1RhKBV98u7DePw9M3DF67NY4J7GhE7btIF2sgaWnJ3Ps9Uutv6Dlj+KfaqM6AePRplXvB6h
        wMWqtMKA1KloUYSKAgEp5ONCMOtf7x7YhkbG1wOGRSxLBu55019F+k5zHdIsKQIHW23TY5N/lbJKA
        n+9wM/7w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvLaH-000O9j-6q; Thu, 09 Dec 2021 15:43:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7B0DE30026A;
        Thu,  9 Dec 2021 16:43:47 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 66BF82BC1CAF5; Thu,  9 Dec 2021 16:43:47 +0100 (CET)
Date:   Thu, 9 Dec 2021 16:43:47 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: Re: [PATCH 08/11] x86/tsc: Avoid synchronizing TSCs with multiple
 CPUs in parallel
Message-ID: <YbIkMyNeb72R4Ma6@hirez.programming.kicks-ass.net>
References: <20211209150938.3518-1-dwmw2@infradead.org>
 <20211209150938.3518-9-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209150938.3518-9-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 03:09:35PM +0000, David Woodhouse wrote:
> diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
> index 50a4515fe0ad..4ee247d89a49 100644
> --- a/arch/x86/kernel/tsc_sync.c
> +++ b/arch/x86/kernel/tsc_sync.c
> @@ -202,6 +202,7 @@ bool tsc_store_and_check_tsc_adjust(bool bootcpu)
>   * Entry/exit counters that make sure that both CPUs
>   * run the measurement code at once:
>   */
> +static atomic_t tsc_sync_cpu = ATOMIC_INIT(-1);
>  static atomic_t start_count;
>  static atomic_t stop_count;
>  static atomic_t skip_test;
> @@ -326,6 +327,8 @@ void check_tsc_sync_source(int cpu)
>  		atomic_set(&test_runs, 1);
>  	else
>  		atomic_set(&test_runs, 3);
> +
> +	atomic_set(&tsc_sync_cpu, cpu);
>  retry:
>  	/*
>  	 * Wait for the target to start or to skip the test:
> @@ -407,6 +410,10 @@ void check_tsc_sync_target(void)
>  	if (unsynchronized_tsc())
>  		return;
>  
> +	/* Wait for this CPU's turn */
> +	while (atomic_read(&tsc_sync_cpu) != cpu)
> +		cpu_relax();
> +
>  	/*
>  	 * Store, verify and sanitize the TSC adjust register. If
>  	 * successful skip the test.

This new atomic_t seems superfluous, there isn't any actual atomic
operation used.
