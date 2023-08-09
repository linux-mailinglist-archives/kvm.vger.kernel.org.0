Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9319E77619B
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjHINt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 09:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjHINt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 09:49:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5887210CC;
        Wed,  9 Aug 2023 06:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZIIWPmBKtW+li6HQAqtxK4Jltz+CfG4J8ocJBflNFNA=; b=VyzM8KXzi1K5Ph0KB6gWdieklS
        ++lBvnbAYmuIT2XBkxPMYlgw0SqU2inqG6zNZagXCmseoLuZ2YGh+biVh4szwT7qNeHYA4ksLUrGd
        9cfBXhiAjHJvJs4OHCW4SYDw92cFJSRAYjsfJV2cZqcE323IIemtVhiOnR+gVn4C1rZst6Sp3kVzf
        8/hSSX9rYCrLm/IxdmMPsSGxZovAB7JU5/fK2DErL77HC+TzPsWKGoentjPAIeqAVQRJeQTRRxgA3
        tcgrdh/MjhlmyuoTc0dvdogHSnwJ8ox5th5iqhVY1QTVBYLamVIxbOKvh2bu/IjqWgq8KYEyOu47q
        Yz3iW3CA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qTjYF-006Vbo-2k; Wed, 09 Aug 2023 13:48:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 726EB30003A;
        Wed,  9 Aug 2023 15:48:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 59A8F20208EAB; Wed,  9 Aug 2023 15:48:37 +0200 (CEST)
Date:   Wed, 9 Aug 2023 15:48:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mihai Carabas <mihai.carabas@oracle.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Joao Martins <joao.m.martins@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] Enable haltpoll for arm64
Message-ID: <20230809134837.GM212435@hirez.programming.kicks-ass.net>
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 02:39:34PM +0300, Mihai Carabas wrote:

> Joao Martins (7):
>   cpuidle-haltpoll: Make boot_option_idle_override check X86 specific
>   x86: Move ARCH_HAS_CPU_RELAX to arch
>   x86/kvm: Move haltpoll_want() to be arch defined
>   governors/haltpoll: Drop kvm_para_available() check
>   arm64: Select ARCH_HAS_CPU_RELAX
>   arm64: Define TIF_POLLING_NRFLAG
>   cpuidle-haltpoll: ARM64 support

You have far too many SOB's on some or all of these patches.

Using poll_state as is on arm64 seems sub-optimal, would not something
like the below make sense?

---
diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..9ab40198b042 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -27,7 +27,11 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 		limit = cpuidle_poll_time(drv, dev);
 
 		while (!need_resched()) {
-			cpu_relax();
+
+			smp_cond_load_relaxed(current_thread_info()->flags,
+					      (VAL & TIF_NEED_RESCHED) ||
+					      (loop_count++ >= POLL_IDLE_RELAX_COUNT));
+
 			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
 				continue;
 
