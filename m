Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A872251C
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjFEMBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjFEMBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:01:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66ACE6;
        Mon,  5 Jun 2023 05:01:43 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685966501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h4OZ3iLYHxReFPvztjUlD1+oBk6ePtunu/TercMZOm8=;
        b=MHdXCxiCz42WshZ/iM+tn8F3EezcXTGkuT1+RpiAiAWpdJi3sAmZzjPZQEgxb6ooriwwSB
        oXsU0nNFHTp6fXxDrkDFnZ00k8fUJMErszOgqwiyElc3zhrGdwxNZswvUGMnc97DElpG7J
        Qg2wpeaSik7lmRTLKxgxIJ8/GdXD9GIor9wGAXJmCqBudArYB0VyaUbnqN5zKGZMpzMOpF
        Scw1+JUpcd1jcDkoMQYmgWSzKIkmfFSNp6VpINBo4y9V9KaURHJ5+VGAxxJVI8uEwVJvxl
        ajwCx9jy5O98NxIneLfn0j+u4H2hRiUPqs7RNXLkq3nQ9bKz0YL+HrOSDbdkgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685966501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h4OZ3iLYHxReFPvztjUlD1+oBk6ePtunu/TercMZOm8=;
        b=SEGwxgOB/DBnjUJ6azNKXdLqel8ICX32HyriNqwhZj2ZV/1EiZZajNXlGLtG00EumznZJq
        5fDczQnlOvjBXtAw==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 09/33] x86/cpu: add X86_CR4_FRED macro
In-Reply-To: <20230410081438.1750-10-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-10-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 14:01:41 +0200
Message-ID: <87r0qq6rtm.ffs@tglx>
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

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:

> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
>
> Add X86_CR4_FRED macro for the FRED bit in %cr4. This bit should be a

s/should/must/ no?

> +/*
> + * These bits should not change their value after CPU init is finished.
> + * The explicit cast to unsigned long suppresses a warning on i386 for
> + * x86-64 only feature bits >= 32.
> + */
>  static const unsigned long cr4_pinned_mask =
> -	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
> -	X86_CR4_FSGSBASE | X86_CR4_CET;
> +	(unsigned long)

That type cast is required because:

+#define X86_CR4_FRED		_BITULL(X86_CR4_FRED_BIT)

Bah. Fred is 64 bit only. So why defining this as 1ULL << 32
unconditionally and stripping the bit off on 32bit via the type cast?

#ifdef CONFIG_X86_64
#define X86_CR4_FRED		_BITUL(X86_CR4_FRED_BIT)
#else
#define X86_CR4_FRED		0
#endif

would be too obvious, right?

> +	(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
> +	 X86_CR4_FSGSBASE | X86_CR4_CET | X86_CR4_FRED);

Thanks,

        tglx
