Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99387094ED
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbjESKe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjESKeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:18 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E571610D9;
        Fri, 19 May 2023 03:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=q8KX/nmGPO6A9N1mK4qTgAMVm27t7iwShesZJrnat4g=; b=RUkLbIsJVPK/qLcIE1IdakqBHq
        VlobrljSWru4F3SJO5gMX7c7PZIX1pB8sUkaYe50E7aHq3d+yyKPHzkGio/P8TWpAKfciEdoPxtnc
        KFZ2sVG/B370biDNoG3HePiHHXT7Yx9Y2B007XJnAEISMPp+Ho6Y2i9489Y6GDqopu057qwAbbAYU
        WbHY+vozrxyGh6JapKw0khAbEJaQ2oOrvICif05nNEW+CzocVAN9T1Esij5670JeY4Yfnr2fxw/pS
        oFXMcQ+q42zF3VDJjPv3I1aXwqPimtcc73By5nS8BkQMH4auTMutFdCpmVk3lhJEhlVKu3oKukt5H
        Y3MGXwAA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzxPv-00FrWV-2D;
        Fri, 19 May 2023 10:32:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F24813033CB;
        Fri, 19 May 2023 12:32:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id BADF1235EF095; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.368919762@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:01 +0200
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
Subject: [PATCH v2 03/13] arm64/io: Always inline all of __raw_{read,write}[bwlq]()
References: <20230519102058.581557770@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch will want to use __raw_readl() from a noinstr section
and as such that needs to be marked __always_inline to avoid the
compiler being a silly bugger.

Turns out it already is, but its siblings are not. Finish the work
started in commit e43f1331e2ef913b ("arm64: Ask the compiler to
__always_inline functions used by KVM at HYP") for consistenies sake.

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


