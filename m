Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E11651DE2
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiLTJrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiLTJqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:46:32 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4800CF57;
        Tue, 20 Dec 2022 01:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yty8ngXs7Md4XfIPXQ3stkVPahwwXV961hO25HdOnVA=; b=IuOejSTU6Xbgfu804q+t96rvyf
        n0PrW5jRCupq+/t81JJcX9y5ZMc/j3MUhzthuEXbc2lOQANX4iDcBk2Dwo+XQJ8K8rNpQpeV1YVZg
        0kDXF/wvPoPeyo6J9LglaJeqz4I11u5QXRa3M/ByPsGSQHhpRgU7vLKk+ahgcHG/bOVK4UKB3vtoW
        3NfU/NH2D5hW+h/RsoUDjtHddaSz1naHikBINHub+oVHzWHi85SASxI0atZ82gKugHrEtM4XzWXIG
        n3iNILYmN7urrOiTe3u6fozJeT4Q3tIOn/LodVlJKRdNaVUz+NJnuWeHtzI1cYQ5E6cjXEnKz01PO
        GodK13+A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p7ZBY-00Cwpk-3A;
        Tue, 20 Dec 2022 09:45:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7FA29300023;
        Tue, 20 Dec 2022 10:45:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 687A72C5F840A; Tue, 20 Dec 2022 10:45:19 +0100 (CET)
Date:   Tue, 20 Dec 2022 10:45:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [RFC PATCH 22/32] x86/fred: FRED initialization code
Message-ID: <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-23-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220063658.19271-23-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 10:36:48PM -0800, Xin Li wrote:

> +	wrmsrl(MSR_IA32_FRED_STKLVLS,
> +	       FRED_STKLVL(X86_TRAP_DB,  1) |
> +	       FRED_STKLVL(X86_TRAP_NMI, 2) |
> +	       FRED_STKLVL(X86_TRAP_MC,  2) |
> +	       FRED_STKLVL(X86_TRAP_DF,  3));
> +
> +	/* The FRED equivalents to IST stacks... */
> +	wrmsrl(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
> +	wrmsrl(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
> +	wrmsrl(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));

Not quite.. IIRC fred only switches to another stack when the level of
the exception is higher. Specifically, if we trigger #DB while inside
#NMI we will not switch to the #DB stack (since 1 < 2).

Now, as mentioned elsewhere, it all nests a lot saner, but stack
exhaustion is still a thing, given the above, what happens when a #DB
hits an #NMI which tickles a #VE or something?

I don't think we've increased the exception stack size, but perhaps we
should for FRED?
