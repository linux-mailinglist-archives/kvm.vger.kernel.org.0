Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3446308DD
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 02:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiKSBxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 20:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiKSBwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 20:52:47 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FADC5B6D
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:35:05 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id p7-20020a631e47000000b0047691854a86so3954013pgm.16
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tD2ZlexlcX0KfmQHE0mJ5LR6ZJYKnXIf8Otqhyd2XwU=;
        b=MB9MhSdwME1l5f01zL+yqUNJf3WE7Wu0+w8g0OhQMoRgcdFNMiEl2Posb3nwOUuTuD
         +tDRTwe89VCBh4TUUBZYFwPkQegSk7I3pM8hr0OWMKYHJXHnIW5iyWHzAp1baiIvkL+M
         xvWAhhFwW2Yf1Gj5279lBpactxhKOCQ0IEInrZiBKCsvP5jjloBw2bf5pvCQbaP/a02E
         HctMjGFpVqM0zObrPX67hF9ozKCMkdYoLheziBuZphT1nqQ1b2UPE5GWbP6p2+JrfcJy
         4NPgcWYf4DFDp2d5yS3j2Vy/fKpDMxIRtkJbIs7JiWbVyohddhm+ah4g1/MDsxL6xsfT
         dFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tD2ZlexlcX0KfmQHE0mJ5LR6ZJYKnXIf8Otqhyd2XwU=;
        b=upGeRKXu1UqAXY9LGeVnne3cCRXVYA4WV7GN3gfdmGbRV8FCtjTvdSt8sDSz7YVSYk
         feBesya8vIxl07QFT/Cth1y3AH3GBjDoIq4GM0knQbrLxt8ekFDu5RWDcgueJ5Cxbgt3
         aC1CHOtPvwS8Xq9TqQ/YgvrrA06X6FQdNkzGeObcMFa6TWVhxTNT3q5q50VRtJ4q01Pg
         lsvRF5PzSa8974TZAoZkgjYkl6Tyf4ifAKFOy6JQF/64UJxEqq1v7MiqoC3J2w3sZT+l
         lmsre+oHCPyV3bZbqnMmI/huz92KsP+JXdEoNfKWU37+C19IqG0RGPYQilogJhf40Xfg
         TR9w==
X-Gm-Message-State: ANoB5pk7SoK72TUNVrONsS0Rn8Hh92Q1JrLjOh/lTXmT0c9Sb3XhAVUq
        kFtC6fsDGWcB6p3AwtB45CUC9PDqXeY=
X-Google-Smtp-Source: AA0mqf4s6WDEnZBoY+6XZCe4HZOEbOD1f6H/JunJuats/BV6uCd/5C6MD5Uo30NfHWTAU95c5mftoaNq5KY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:16d4:0:b0:572:6b5f:bdc2 with SMTP id
 203-20020a6216d4000000b005726b5fbdc2mr10383566pfw.36.1668821704620; Fri, 18
 Nov 2022 17:35:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 19 Nov 2022 01:34:48 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-8-seanjc@google.com>
Subject: [PATCH 7/9] tools: Drop conflicting non-atomic test_and_{clear,set}_bit()
 helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop tools' non-atomic test_and_set_bit() and test_and_clear_bit() helpers
now that all users are gone.  The names will be claimed in the future for
atomic versions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/include/linux/bitmap.h | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index 65d0747c5205..f3566ea0f932 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -77,40 +77,6 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 		__bitmap_or(dst, src1, src2, nbits);
 }
 
-/**
- * test_and_set_bit - Set a bit and return its old value
- * @nr: Bit to set
- * @addr: Address to count from
- */
-static inline int test_and_set_bit(int nr, unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-	unsigned long old;
-
-	old = *p;
-	*p = old | mask;
-
-	return (old & mask) != 0;
-}
-
-/**
- * test_and_clear_bit - Clear a bit and return its old value
- * @nr: Bit to clear
- * @addr: Address to count from
- */
-static inline int test_and_clear_bit(int nr, unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-	unsigned long old;
-
-	old = *p;
-	*p = old & ~mask;
-
-	return (old & mask) != 0;
-}
-
 /**
  * bitmap_zalloc - Allocate bitmap
  * @nbits: Number of bits
-- 
2.38.1.584.g0f3c55d4c2-goog

