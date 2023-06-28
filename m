Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5C37411F0
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjF1NJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjF1NJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 09:09:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA4A2118;
        Wed, 28 Jun 2023 06:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/wef/ORaePi5rraYqwEm/o3Nv/tMCObZmjkD+rQugnw=; b=PDi20WW3Y1qeIx2VS+PtiQ/riF
        a1d08NY4ejV640VZefmowE9KddBTfmHnYsiApZPVzGglYLPKeXQOlBRLiql9G8ofhJEBwY5+H2VZf
        y2cGKzXwgshcigUPgBZQoiFfuSD98Q0I23DrmseJ0k5Oz0lfXp56xozo0UQ9QKvdWMh3rvKW8VqwF
        5+Cb+ojDCAlHi6sgYBj4O6K0XMU1KIVtgZ2+qA07W4WXy+PlFmCvzssazUEWK1Ealz9JQ2zfBC7aS
        X7/a115gTN0JPsxvPFIi9GSSWpxAR9HNgThP/IVFUctW/eqMJuiZv8iiJgd0Nu4Am0OnksPDIY9WP
        hF9YjD4A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qEUuF-003nSs-Sq; Wed, 28 Jun 2023 13:08:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 17BF33002C5;
        Wed, 28 Jun 2023 15:08:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F40A527F62BA3; Wed, 28 Jun 2023 15:08:22 +0200 (CEST)
Date:   Wed, 28 Jun 2023 15:08:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ashok.raj@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230628130822.GD2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:37AM +1200, Kai Huang wrote:

> +/*
> + * Do the module global initialization if not done yet.
> + * It's always called with interrupts and preemption disabled.
> + */
> +static int try_init_module_global(void)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	/*
> +	 * The TDX module global initialization only needs to be done
> +	 * once on any cpu.
> +	 */
> +	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);
> +
> +	if (tdx_global_initialized) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	/* All '0's are just unused parameters. */
> +	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
> +	if (!ret)
> +		tdx_global_initialized = true;
> +out:
> +	raw_spin_unlock_irqrestore(&tdx_global_init_lock, flags);
> +
> +	return ret;
> +}
> +
> +/**
> + * tdx_cpu_enable - Enable TDX on local cpu
> + *
> + * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
> + * global initialization SEAMCALL if not done) on local cpu to make this
> + * cpu be ready to run any other SEAMCALLs.
> + *
> + * Call this function with preemption disabled.
> + *
> + * Return 0 on success, otherwise errors.
> + */
> +int tdx_cpu_enable(void)
> +{
> +	int ret;
> +
> +	if (!platform_tdx_enabled())
> +		return -ENODEV;
> +
> +	lockdep_assert_preemption_disabled();
> +
> +	/* Already done */
> +	if (__this_cpu_read(tdx_lp_initialized))
> +		return 0;
> +
> +	/*
> +	 * The TDX module global initialization is the very first step
> +	 * to enable TDX.  Need to do it first (if hasn't been done)
> +	 * before the per-cpu initialization.
> +	 */
> +	ret = try_init_module_global();
> +	if (ret)
> +		return ret;
> +
> +	/* All '0's are just unused parameters */
> +	ret = seamcall(TDH_SYS_LP_INIT, 0, 0, 0, 0, NULL, NULL);
> +	if (ret)
> +		return ret;

And here you do *NOT* have IRQs disabled... so an IRQ can come in here
and do the above again.

I suspect that's a completely insane thing to have happen, but the way
the code is written does not tell me this and might even suggest I
should worry about it, per the above thing actually disabling IRQs.

> +
> +	__this_cpu_write(tdx_lp_initialized, true);
> +
> +	return 0;
> +}
