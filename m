Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475186FC987
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbjEIOwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbjEIOwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:52:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6162B30FE;
        Tue,  9 May 2023 07:52:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73AD3FEC;
        Tue,  9 May 2023 07:52:44 -0700 (PDT)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.34.150])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 026403F663;
        Tue,  9 May 2023 07:51:53 -0700 (PDT)
Date:   Tue, 9 May 2023 15:51:51 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     bigeasy@linutronix.de, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 3/9] arm64/io: Always inline all of
 __raw_{read,write}[bwlq]()
Message-ID: <ZFpeBzFD4N5Cuwcb@FVFF77S0Q05N.cambridge.arm.com>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.583344579@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508213147.583344579@infradead.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023 at 11:19:54PM +0200, Peter Zijlstra wrote:
> The next patch will want to use __raw_readl() from a noinstr section
> and as such that needs to be marked __always_inline to avoid the
> compiler being a silly bugger.
> 
> Turns out it already is, but its siblings are not.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

FWIW, on arm64 we shouldn't ever end up with the MMIO counter being our
{sched,local}_clock() -- several things blow up if we don't have the "CP15"
version, and if we do have the CP15 version we'll use that as our preferred
clocksource (and yes, the code is a mess).

Regardless, for consistency I agree we should mark these all as __always_inline.

It looks like we marked __raw_{readl,writel}() as noinstr in commit:

  e43f1331e2ef913b ("arm64: Ask the compiler to __always_inline functions used by KVM at HYP")

... and it'd be nice to mention that in the commit message.

Thanks,
Mark.

> ---
>  arch/arm64/include/asm/io.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -22,13 +22,13 @@
>   * Generic IO read/write.  These perform native-endian accesses.
>   */
>  #define __raw_writeb __raw_writeb
> -static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
> +static __always_inline void __raw_writeb(u8 val, volatile void __iomem *addr)
>  {
>  	asm volatile("strb %w0, [%1]" : : "rZ" (val), "r" (addr));
>  }
>  
>  #define __raw_writew __raw_writew
> -static inline void __raw_writew(u16 val, volatile void __iomem *addr)
> +static __always_inline void __raw_writew(u16 val, volatile void __iomem *addr)
>  {
>  	asm volatile("strh %w0, [%1]" : : "rZ" (val), "r" (addr));
>  }
> @@ -40,13 +40,13 @@ static __always_inline void __raw_writel
>  }
>  
>  #define __raw_writeq __raw_writeq
> -static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
> +static __always_inline void __raw_writeq(u64 val, volatile void __iomem *addr)
>  {
>  	asm volatile("str %x0, [%1]" : : "rZ" (val), "r" (addr));
>  }
>  
>  #define __raw_readb __raw_readb
> -static inline u8 __raw_readb(const volatile void __iomem *addr)
> +static __always_inline u8 __raw_readb(const volatile void __iomem *addr)
>  {
>  	u8 val;
>  	asm volatile(ALTERNATIVE("ldrb %w0, [%1]",
> @@ -57,7 +57,7 @@ static inline u8 __raw_readb(const volat
>  }
>  
>  #define __raw_readw __raw_readw
> -static inline u16 __raw_readw(const volatile void __iomem *addr)
> +static __always_inline u16 __raw_readw(const volatile void __iomem *addr)
>  {
>  	u16 val;
>  
> @@ -80,7 +80,7 @@ static __always_inline u32 __raw_readl(c
>  }
>  
>  #define __raw_readq __raw_readq
> -static inline u64 __raw_readq(const volatile void __iomem *addr)
> +static __always_inline u64 __raw_readq(const volatile void __iomem *addr)
>  {
>  	u64 val;
>  	asm volatile(ALTERNATIVE("ldr %0, [%1]",
> 
> 
