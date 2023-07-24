Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA8C760115
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 23:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjGXVU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 17:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjGXVUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 17:20:55 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45816139;
        Mon, 24 Jul 2023 14:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eygDX+Dak0hX6wMmwhav7dSyFRNIJ5Acv7NgHDwNRpc=; b=WGEXN2JUsOgpzIB3RZJCo0vMkf
        CLh9IxjQq548vMnPN/rkTvygms33yuOdLFJgKJ8T/rqSSJqUzEV6RBhVpaE+dw5bR2uKad3Yl0scJ
        77rki0hyuUHSbXyBctykRCLHJ9rSPFyXFixhB1D8v3qjlq0fHhcTiBT3zlooXIcs7VPcw+WNV7/wD
        OMz6kAOm5HmfWJl0Db4Z7vKVum3zvkbRxIEwv129+nu2hM/iYGgovQqUQWTDJ5/UsYlyPEfqp5hgk
        xlziLL8XfOeSezF0MqWNFMWRFpNtYF3ZTYI2dGC5yNKGK5X5xHFZu2l2mHgHVGnujra0NnjQAEzhj
        MF0EoczQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qO2y7-002ibB-2t;
        Mon, 24 Jul 2023 21:19:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1D7D630020C;
        Mon, 24 Jul 2023 23:19:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 079B2265C4A2D; Mon, 24 Jul 2023 23:19:50 +0200 (CEST)
Date:   Mon, 24 Jul 2023 23:19:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v4 05/19] x86/reboot: Assert that IRQs are disabled when
 turning off virtualization
Message-ID: <20230724211949.GG3745454@hirez.programming.kicks-ass.net>
References: <20230721201859.2307736-1-seanjc@google.com>
 <20230721201859.2307736-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721201859.2307736-6-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 01:18:45PM -0700, Sean Christopherson wrote:
> Assert that IRQs are disabled when turning off virtualization in an
> emergency.  KVM enables hardware via on_each_cpu(), i.e. could re-enable
> hardware if a pending IPI were delivered after disabling virtualization.
> 
> Remove a misleading comment from emergency_reboot_disable_virtualization()
> about "just" needing to guarantee the CPU is stable (see above).
> 
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kernel/reboot.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 48ad2d1ff83d..4cad7183b89e 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -532,7 +532,6 @@ static inline void nmi_shootdown_cpus_on_restart(void);
>  
>  static void emergency_reboot_disable_virtualization(void)
>  {
> -	/* Just make sure we won't change CPUs while doing this */
>  	local_irq_disable();
>  
>  	/*
> @@ -821,6 +820,13 @@ void cpu_emergency_disable_virtualization(void)
>  {
>  	cpu_emergency_virt_cb *callback;
>  
> +	/*
> +	 * IRQs must be disabled as KVM enables virtualization in hardware via
> +	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
> +	 * virtualization stays disabled.
> +	 */
> +	lockdep_assert_irqs_disabled();
> +
>  	rcu_read_lock();
>  	callback = rcu_dereference(cpu_emergency_virt_callback);
>  	if (callback)

Strictly speaking you don't need rcu_read_lock() when IRQs are already
disabled, but since this is non-performance critical code, it might be
best to keep it super obvious. IOW, carry on.
