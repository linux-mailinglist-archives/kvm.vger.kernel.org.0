Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845A64D888A
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 16:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242758AbiCNPwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 11:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242754AbiCNPwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 11:52:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197D841F94;
        Mon, 14 Mar 2022 08:50:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647273052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eHa8uBo2dOC/GF+D9znnombschZWnVMuqBcTJw3T+WM=;
        b=DjsaTqrXZ94+z7hKUrn/i5p2dKoprwNnph6knuv9/8OoD0WmioTvYQ1I8COlRSXpkn8zTc
        LBkUlypG+CB46tNXRvebDO8D6J3Up0OKH68DidAjEWh9Dup6Wdpu/cuH/hSXJevVqHRE7p
        5KDyKSU1ah4EbZ66dW+MJp2nocTPeEYlTNvtQdMnU3yv0YE0/yzCigoObBn9hhR18fNAAn
        1eI1A01LIXPTFGsvZeLGIr+1DggjByFLiAByuSUfnVcdhisXQkY2xm0v96H4E/iPPvDD33
        f/6aKDJ/VYzyPrCQEjTt1A4SaxbV4gYh17BRHT/R/nPS++aXUAKR6sxGqPfkhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647273052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eHa8uBo2dOC/GF+D9znnombschZWnVMuqBcTJw3T+WM=;
        b=Ym8kcXhUrvscVkKD3kpSpxEcykx13Nd0h+U9OGdQHERjo5nuSvtmHzI+f4Q0rdDsCPVfX+
        fmMcEXR7Gk1BjwAg==
To:     Junaid Shahid <junaids@google.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, luto@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 04/47] mm: asi: ASI support in interrupts/exceptions
In-Reply-To: <20220223052223.1202152-5-junaids@google.com>
References: <20220223052223.1202152-1-junaids@google.com>
 <20220223052223.1202152-5-junaids@google.com>
Date:   Mon, 14 Mar 2022 16:50:52 +0100
Message-ID: <87pmmofs83.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22 2022 at 21:21, Junaid Shahid wrote:
>  #define DEFINE_IDTENTRY_RAW(func)					\
> -__visible noinstr void func(struct pt_regs *regs)
> +static __always_inline void __##func(struct pt_regs *regs);		\
> +									\
> +__visible noinstr void func(struct pt_regs *regs)			\
> +{									\
> +	asi_intr_enter();						\

This is wrong. You cannot invoke arbitrary code within a noinstr
section. 

Please enable CONFIG_VMLINUX_VALIDATION and watch the build result with
and without your patches.

Thanks,

        tglx
