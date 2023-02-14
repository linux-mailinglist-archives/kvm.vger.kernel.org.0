Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAEF696808
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 16:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbjBNP1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 10:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbjBNP1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 10:27:16 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D89279B7;
        Tue, 14 Feb 2023 07:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IH80qlTe1cFPwjVJIJZot//fxjYJDEIjUb/VdqFD4+c=; b=TC8aWVdMva/8ea0OrH6dMRmPOS
        4MPUP+ZzRT7OlvOWzzKm8qZA1Rj4iJtr9r/eeTJBYM93wqgu/zoDRqlrzzYVyKhIYX9c3ldNHGf5K
        YM+Ivy2alULIgfnICY1EOfz/09mnfU/ez3ahZQc7oxhwSd19I/FqhR+5V1P8/19SSJZvpG1DcU7r1
        RgDUxSCh/0rpF/sJ12OIXHJHCj6Y7a4RCtEA6cGG5Ii/a6k6XA/n9YRUcNECYcQn3UhDisRuawX1a
        SUlzbtj5jOdNfJ2xtr+xKC4Pqx5m0giVjUrZlyEzTSjniRveidA/7U/smiREkAtdLgDL6BmXGYceg
        gWwzZEHQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pRxC3-009fh1-13;
        Tue, 14 Feb 2023 15:26:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 29CEE3033F3;
        Tue, 14 Feb 2023 13:59:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1087D23BDBD82; Tue, 14 Feb 2023 13:59:22 +0100 (CET)
Date:   Tue, 14 Feb 2023 13:59:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Message-ID: <Y+uFqYRZELDquAJ7@hirez.programming.kicks-ass.net>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 12:59:14AM +1300, Kai Huang wrote:
> +/*
> + * Call @func on all online cpus one by one but skip those cpus
> + * when @skip_func is valid and returns true for them.
> + */
> +static int tdx_on_each_cpu_cond(int (*func)(void *), void *func_data,
> +				bool (*skip_func)(int cpu, void *),
> +				void *skip_data)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		int ret;
> +
> +		if (skip_func && skip_func(cpu, skip_data))
> +			continue;
> +
> +		/*
> +		 * SEAMCALL can be time consuming.  Call the @func on
> +		 * remote cpu via smp_call_on_cpu() instead of
> +		 * smp_call_function_single() to avoid busy waiting.
> +		 */
> +		ret = smp_call_on_cpu(cpu, func, func_data, true);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

schedule_on_each_cpu() ?
