Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249667411E3
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjF1NDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjF1NDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 09:03:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576FC1FFE;
        Wed, 28 Jun 2023 06:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YRmXGRO7v2q8teN6iRwJ9n9mRadW5UVlq2nlH+dKy24=; b=Y5SPXY5m7lDhE2wc93WRe+e82x
        pv4oSOcQfUupKrpjY49BQmwgwIVmZlqJny4rHJoFWuJrOF9y3XU8lUfG5KqM/NLW2YtZvHViL43Od
        fjfBes3FJOTYbfrb5jbks6t5CFuXSCtnusKItAP94u5QHO5xYgCMIk42sn0aNHpmZB+G2r316+Csb
        qb3qE5USZfBo3U6hO0nsW73qUXQKHEgbEnk8rtUy5VyUjRjy9Nczo+6xn8livWnufRo5nGXUlHsPZ
        rrPtKWSy2YWG8VIZLtKMznwjClUgfd8QOfvgcjl6q8GGHL2bQRt3espQed2cH7VnM45WmGs7LXo5V
        ySd+/mKw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qEUoz-005eGG-12;
        Wed, 28 Jun 2023 13:02:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E9BB73002F0;
        Wed, 28 Jun 2023 15:02:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D1AB727F62BA0; Wed, 28 Jun 2023 15:02:56 +0200 (CEST)
Date:   Wed, 28 Jun 2023 15:02:56 +0200
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
Subject: Re: [PATCH v12 06/22] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Message-ID: <20230628130256.GB2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b5bf58246659572bd68d46b14e90e9e5b37f7f93.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5bf58246659572bd68d46b14e90e9e5b37f7f93.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:36AM +1200, Kai Huang wrote:

>  	cpu = get_cpu();
> -	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +
> +	/*
> +	 * Certain SEAMCALL leaf functions may return error due to
> +	 * running out of entropy, in which case the SEAMCALL should
> +	 * be retried.  Handle this in SEAMCALL common function.
> +	 *
> +	 * Mimic rdrand_long() retry behavior.

Yeah, except that doesn't have preemption disabled.. you do.

> +	 */
> +	do {
> +		sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +	} while (sret == TDX_RND_NO_ENTROPY && --retry);
> +
>  	put_cpu();
