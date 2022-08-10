Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1A458EF52
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiHJPV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiHJPVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:21:09 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52DF491E2
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o6-20020a17090ab88600b001f30b8c11c5so1341408pjr.2
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=ZH7CdRWCIwNg0rfB6pUeUyBV2qfCWplRtlLFdh/iMUI=;
        b=apwXC/ww4j5CUuVFoJyNaoq+BSpD4U+4DscUXqUrLk78d+ARYidpwEa5ihZfml/1pS
         RF9y0n45tYrpC3MIhhZk0erLNzoxOIB7yzKbM9hLF4yWG1H6+9Be3jII4QPCzX71NspY
         8ER7PYUunxvMsZrp0iN+lF1j90zPZWLsyqTjoMMP+PVuK77dG36lodOSzGEJgc44BByN
         tMp2OicDylCbNQIB+0UYfBDeESFY7Ao0DoUwQ8bcyxrduRXq6sMIbzo34wx5Hsjgwe+l
         Rh0mEqgTh4Trsb8m8VoKxipFaGY2oEPhPnr0B4daIm7vKJzhcnby9pV09OHAUFyG4oEQ
         zHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ZH7CdRWCIwNg0rfB6pUeUyBV2qfCWplRtlLFdh/iMUI=;
        b=DdwK64bzDs1fea+02kh33bUtzmBglb6nr0aIq3xlVfCO2lfbfNQQIL1g5ROJhQz3ty
         y4vkAx+iex3PzXA3hLgQeLkFXSSE3k9uv6aNcpWjHsM2SGpixy5GIoapHoBX38awEsCx
         wTTEvQi/R8E3n6wCDuxgvMLznL0WmCBsa7sTh3l9hDfnUjZ53lww8UlnoKUfGPA/FWkc
         4fqwTmXCpMaR7bRxe5UvfMSazUvIK5Mtauk7mGxPd8Tsvq5tY4OZQqMjSQhWYd4O5BPg
         XIU+jCLDJL6OCVXEfY5EZaYx4ApVTTVSTCuQdQQOJRABIEqwdl/wmgIQcHsnvTNa4hkB
         971g==
X-Gm-Message-State: ACgBeo2H2XOCA5ak7m+C3Cj003hrzph5oGPTJWeJtuD2q5MapocrTN2/
        uBj6qaV5uJFNZeaI+EGRPOHVZptjz4Ai0OMAUK4DqXeLYYdOXO7fmubZHB/MLmt+npEfNTWka0J
        Jx0+nKZy6jYxEBHAbMAqag5cfeo4ysRaDmy7Nn84rCQTL/AWq8gjSr1AeoA==
X-Google-Smtp-Source: AA6agR7/peE3sNp+8R/sQNztbFbtY9gi/ShTyBHi6GxvE2QcV08n2v2+coOQi5Gc9nYsEInoAH6es2+2RJY=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a63:6cc4:0:b0:41a:ff04:661f with SMTP id
 h187-20020a636cc4000000b0041aff04661fmr23530639pgc.600.1660144853502; Wed, 10
 Aug 2022 08:20:53 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:31 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-10-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 09/11] tools: Add atomic_test_and_set_bit()
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

atomic_test_and_set_bit() allows for atomic bitmap usage from KVM
selftests.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
---
 tools/arch/x86/include/asm/atomic.h    |  7 +++++++
 tools/include/asm-generic/atomic-gcc.h | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/tools/arch/x86/include/asm/atomic.h b/tools/arch/x86/include/asm/atomic.h
index 1f5e26aae9fc..01cc27ec4520 100644
--- a/tools/arch/x86/include/asm/atomic.h
+++ b/tools/arch/x86/include/asm/atomic.h
@@ -8,6 +8,7 @@
 
 #define LOCK_PREFIX "\n\tlock; "
 
+#include <asm/asm.h>
 #include <asm/cmpxchg.h>
 
 /*
@@ -70,4 +71,10 @@ static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return cmpxchg(&v->counter, old, new);
 }
 
+static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+{
+	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, "Ir", nr, "%0", "c");
+
+}
+
 #endif /* _TOOLS_LINUX_ASM_X86_ATOMIC_H */
diff --git a/tools/include/asm-generic/atomic-gcc.h b/tools/include/asm-generic/atomic-gcc.h
index 4c1966f7c77a..8d9b2d1768bf 100644
--- a/tools/include/asm-generic/atomic-gcc.h
+++ b/tools/include/asm-generic/atomic-gcc.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -69,4 +70,18 @@ static inline int atomic_cmpxchg(atomic_t *v, int oldval, int newval)
 	return cmpxchg(&(v)->counter, oldval, newval);
 }
 
+static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+{
+	long old, val;
+	unsigned long mask = BIT_MASK(nr);
+
+	addr += BIT_WORD(nr);
+	val = READ_ONCE(*addr);
+	if (val & mask)
+		return 1;
+
+	old = cmpxchg(addr, val, val & mask);
+	return !!(old & mask);
+}
+
 #endif /* __TOOLS_ASM_GENERIC_ATOMIC_H */
-- 
2.37.1.559.g78731f0fdb-goog

