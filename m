Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1191633806
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 10:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiKVJKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 04:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiKVJKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 04:10:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451F618B13;
        Tue, 22 Nov 2022 01:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=04mH2hDCkvHpLAW6koCu4FNsbF6qrp83kpM2X4j6UkE=; b=k9zuYNijeiPPZQgyzXcFeWVzjf
        2kRDb8PjFNnE3rml8UaKa2fpc2ojYbhduPE/0bMcz9S3UjP4c3qRlLNCJKEGJdXarG9GScWgmn7Tt
        vRktddCb9AdXAYCNM16jwhdF0wkK9N5B1dQl4GAufPTiQP9Qx3OSqnQ22tmQyECNSjZBVjb+fnING
        x7igpnSIxEqEwPu7Fc+rSWOo0FI5GGRFCJ0Kv9/qjws+Kp5WirAQriU844RUHMwkuq+EEor4RTOoO
        GuTlt3CeDJ7Avm1OIUXK6L7KyYMtSxQcVgK6xlZ1raqY51Db6NnBU3mPRgFvHwl8eQghb987Yb0iB
        14zkWEOA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxPIR-00699A-NU; Tue, 22 Nov 2022 09:10:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9DD45300282;
        Tue, 22 Nov 2022 10:10:20 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 835852D669367; Tue, 22 Nov 2022 10:10:20 +0100 (CET)
Date:   Tue, 22 Nov 2022 10:10:20 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y3yR/NQwLYfIqode@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:

> +/*
> + * Data structure to make SEAMCALL on multiple CPUs concurrently.
> + * @err is set to -EFAULT when SEAMCALL fails on any cpu.
> + */
> +struct seamcall_ctx {
> +	u64 fn;
> +	u64 rcx;
> +	u64 rdx;
> +	u64 r8;
> +	u64 r9;
> +	atomic_t err;
> +};

> @@ -166,6 +180,25 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	}
>  }
>  
> +static void seamcall_smp_call_function(void *data)
> +{
> +	struct seamcall_ctx *sc = data;
> +	int ret;
> +
> +	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9, NULL, NULL);
> +	if (ret)
> +		atomic_set(&sc->err, -EFAULT);
> +}

Can someone explain me this usage of atomic_t, please?
