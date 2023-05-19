Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7540E7094F8
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjESKeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjESKeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457D710F4;
        Fri, 19 May 2023 03:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=giIQX2Zs4VTp0HoKM0lBH5Aj6/hHWaqvN+LCMp+82bc=; b=CA71o9xgUhDALWVpBZL3Kbb0us
        w28SqK/pSvpC8QCgu0cE5pQhHZtssq8nLJkLI3nn9B0xHjOLG5romDSz4bfcIqeKXpUhn7chPpoFP
        G82NWMaRlMLIomwhAnwgXykMyjFllI8R44sXXNauaW2R2+69VDJthz1fNlJ2Ah3OZTG1UkX44rZ1M
        t6/glWLZdH9w+df3kaRipZFxE2x8sn1A3AQVMI9u3N7PTr2SDj2lpRbBH3heuqhke29k6v4QVs+8w
        nBoFuK9RU64bsZwe0cbHuXq+4EXZYfKM0cENPc/LAEE0lzuRLi4+x9pysDMkYMay8uXWK2hK5X8lC
        ACU4n1tw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzxPv-00FrWW-2I;
        Fri, 19 May 2023 10:32:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 224B4306138;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id CEB67235EF0A9; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.637420396@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:05 +0200
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
Subject: [PATCH v2 07/13] math64: Always inline u128 version of mul_u64_u64_shr()
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

In order to prevent the following complaint from happening, always
inline the u128 variant of mul_u64_u64_shr() -- which is what x86_64
will use.

  vmlinux.o: warning: objtool: read_hv_sched_clock_tsc+0x5a: call to mul_u64_u64_shr.constprop.0() leaves .noinstr.text section

It should compile into something like:

  asm("mul	%[mul];"
      "shrd	%rdx, %rax, %cl"
      : "+&a" (a)
      : "c" shift, [mul] "r" (mul)
      : "d");

Which is silly not to inline, but it happens.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/math64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -168,7 +168,7 @@ static __always_inline u64 mul_u64_u32_s
 #endif /* mul_u64_u32_shr */
 
 #ifndef mul_u64_u64_shr
-static inline u64 mul_u64_u64_shr(u64 a, u64 mul, unsigned int shift)
+static __always_inline u64 mul_u64_u64_shr(u64 a, u64 mul, unsigned int shift)
 {
 	return (u64)(((unsigned __int128)a * mul) >> shift);
 }


