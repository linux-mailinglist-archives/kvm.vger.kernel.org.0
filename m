Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2486C1D1E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjCTRDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbjCTRCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:02:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206511C310;
        Mon, 20 Mar 2023 09:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ss3pf4bw0TX+NsOEXdlAuLxz+g7l7ioANkWaEdO4Rho=; b=Syk0qamgSajvba6KPCkW3IFwxF
        51I7q6SCzuEvk5g8fN4wxiSzwf340m5ARex+1lMcoyh35XGdgkGidX/vyvYl8cvgKs2t+qNpM8R5G
        qWSL08Tch/Go0ZufM1mFChOncQjezMvd3t5kmZGHepXbdHO6kCGKpXJbJrKYeOoOnNnBcmdtK3wkJ
        HrdgwuoB2EvwTWT3xe8URohshQe6cMQdeZSOFzBfgbC+Nygo1bRkyg7JGTdpo6c0mHlSdiUUCcXwH
        H/DtxUhgR/xNVT6d63cpA6maGUixTxsXwoCoLMjy3kne0Z1yxznfSD2LtWIzA6xDtJZXMHlBh7pT3
        zcmRVh6A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peIlv-003zuP-3C;
        Mon, 20 Mar 2023 16:54:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 89015300642;
        Mon, 20 Mar 2023 17:54:11 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7B021200A76E5; Mon, 20 Mar 2023 17:54:11 +0100 (CET)
Date:   Mon, 20 Mar 2023 17:54:11 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 25/34] x86/fred: disallow the swapgs instruction when
 FRED is enabled
Message-ID: <20230320165411.GT2194297@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-26-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307023946.14516-26-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 06:39:37PM -0800, Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> The FRED architecture establishes the full supervisor/user through:
> 1) FRED event delivery swaps the value of the GS base address and
>    that of the IA32_KERNEL_GS_BASE MSR.
> 2) ERETU swaps the value of the GS base address and that of the
>    IA32_KERNEL_GS_BASE MSR.
> Thus, the swapgs instruction is disallowed when FRED is enabled,
> otherwise it cauess #UD.
                 ^^^ --- new word :-)
