Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25846FB9D9
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbjEHVfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjEHVe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:34:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF3C129;
        Mon,  8 May 2023 14:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=bEROWOrEuHGtVGNiYWuINxVA4qSy8ulUpF6Cr1VtAOk=; b=Rw8MxGzMcck/SmtNHPxJBTkUJ2
        glIi2eVEv3SEs7dwl7ZznmvfLWL/+hcH6+HqoI/0OpRAKtLEwozOzJIP1ucdO77zKFOBYmn2HAeik
        Q9dVu9HEGaXeNwVh9YkItAwMOYPP5acMOrWwhH140v6BsV7TML3Gh6CG7Esu0OG6hyOvl9rB+1wb5
        nA2pozVz0eUelrQmFssZEfx0yQZGfDWONRB5yt5jJnnXeSQ68+9CxDgZTz/0A9VMRaQiqImxK6CE9
        BWcxxygJsv3c8ji0Cuzqxdn6Fvj3pVdTCleFQKnOhQuG3y4YayiE6ujN/Xz0m7h3YRbQcyTHwR5gI
        ptGi/ITg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pw8UZ-00EW3p-Dg; Mon, 08 May 2023 21:33:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 93D41306137;
        Mon,  8 May 2023 23:33:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 356B62482941D; Mon,  8 May 2023 23:33:48 +0200 (CEST)
Message-ID: <20230508213147.583344579@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 08 May 2023 23:19:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     bigeasy@linutronix.de
Cc:     mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, peterz@infradead.org, longman@redhat.com,
        boqun.feng@gmail.com, pmladek@suse.com, senozhatsky@chromium.org,
        rostedt@goodmis.org, john.ogness@linutronix.de,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, jstultz@google.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC][PATCH 3/9] arm64/io: Always inline all of __raw_{read,write}[bwlq]()
References: <20230508211951.901961964@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch will want to use __raw_readl() from a noinstr section
and as such that needs to be marked __always_inline to avoid the
compiler being a silly bugger.

Turns out it already is, but its siblings are not.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/arm64/include/asm/io.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -22,13 +22,13 @@
  * Generic IO read/write.  These perform native-endian accesses.
  */
 #define __raw_writeb __raw_writeb
-static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
+static __always_inline void __raw_writeb(u8 val, volatile void __iomem *addr)
 {
 	asm volatile("strb %w0, [%1]" : : "rZ" (val), "r" (addr));
 }
 
 #define __raw_writew __raw_writew
-static inline void __raw_writew(u16 val, volatile void __iomem *addr)
+static __always_inline void __raw_writew(u16 val, volatile void __iomem *addr)
 {
 	asm volatile("strh %w0, [%1]" : : "rZ" (val), "r" (addr));
 }
@@ -40,13 +40,13 @@ static __always_inline void __raw_writel
 }
 
 #define __raw_writeq __raw_writeq
-static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
+static __always_inline void __raw_writeq(u64 val, volatile void __iomem *addr)
 {
 	asm volatile("str %x0, [%1]" : : "rZ" (val), "r" (addr));
 }
 
 #define __raw_readb __raw_readb
-static inline u8 __raw_readb(const volatile void __iomem *addr)
+static __always_inline u8 __raw_readb(const volatile void __iomem *addr)
 {
 	u8 val;
 	asm volatile(ALTERNATIVE("ldrb %w0, [%1]",
@@ -57,7 +57,7 @@ static inline u8 __raw_readb(const volat
 }
 
 #define __raw_readw __raw_readw
-static inline u16 __raw_readw(const volatile void __iomem *addr)
+static __always_inline u16 __raw_readw(const volatile void __iomem *addr)
 {
 	u16 val;
 
@@ -80,7 +80,7 @@ static __always_inline u32 __raw_readl(c
 }
 
 #define __raw_readq __raw_readq
-static inline u64 __raw_readq(const volatile void __iomem *addr)
+static __always_inline u64 __raw_readq(const volatile void __iomem *addr)
 {
 	u64 val;
 	asm volatile(ALTERNATIVE("ldr %0, [%1]",


