Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3A722554
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjFEMP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbjFEMP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:15:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E999C;
        Mon,  5 Jun 2023 05:15:27 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685967325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JoudT+AdU0Ws+QSwN1SBTdwy6Vmg7eTtWGfmIGNYxT8=;
        b=jUWdFgaFbghhqynIQWDCI6OaFTOq39+leYg3swzXM8amANFKHqT2rFnvK5IzPWqwffJ9lz
        WWLK563F0/1iZHR6SkgtTLXi8yd/gjnqt14XE8M1ZgRS0LrGdNL60ur52z7EB3p3wX7fdG
        +44dciYN00d2HD+gnDssnuXM7lg3Tojd+4Myiwx/yBujqwdD8z0Rd1TVjgfQIFfltokncF
        0gwNyGs4k8cxLIBOaovNMHekaFdUOpunIS02ydN7i41D9yK7mErOMcZ8GAaJt+x+6/+xoo
        ZLuUctDpy3tsdPk/2PXCvgrrQ+oNsOGk0f5O/21EHupTOrjf/sxi5e/5+/LwyQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685967325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JoudT+AdU0Ws+QSwN1SBTdwy6Vmg7eTtWGfmIGNYxT8=;
        b=b5TK60DL6+9N2hDuMdzVIjQrfXCDUjO0EoEqoOgjqkuvZej0u8i+Ld/yQX20qddnLKMNVD
        FaX8eBrX0gfnIyDg==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 21/33] x86/fred: FRED initialization code
In-Reply-To: <20230410081438.1750-22-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-22-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 14:15:25 +0200
Message-ID: <87jzwi6r6q.ffs@tglx>
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
> The code to initialize FRED when it's available and _not_ disabled.
>
> cpu_init_fred_exceptions() is the core function to initialize FRED,
> which
>   1. Sets up FRED entrypoints for events happening in ring 0 and 3.
>   2. Sets up a default stack for event handling.
>   3. Sets up dedicated event stacks for DB/NMI/MC/DF, equivalent to
>      the IDT IST stacks.
>   4. Forces 32-bit system calls to use "int $0x80" only.
>   5. Enables FRED and invalidtes IDT.
>
> When the FRED is used, cpu_init_exception_handling() initializes FRED
> through calling cpu_init_fred_exceptions(), otherwise it sets up TSS
> IST and loads IDT.
>
> As FRED uses the ring 3 FRED entrypoint for SYSCALL and SYSENTER,
> it skips setting up SYSCALL/SYSENTER related MSRs, e.g., MSR_LSTAR.

So how is this supposed to work? FRED is enabled in Kconfig, the feature
is detected and FRED is initialized _before_ the rest of the required
changes is in place.

Documentation/process/* is not just there because people have nothing
better to do than writing pointless documents.

Thanks,

        tglx


