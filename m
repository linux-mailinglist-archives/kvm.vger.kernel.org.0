Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17822DB3BE
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731564AbgLOS3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731330AbgLOS3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:29:37 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830AC06179C;
        Tue, 15 Dec 2020 10:28:26 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v22so22079662edt.9;
        Tue, 15 Dec 2020 10:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BxbWIyImdzA25H+jox/xdDou7lPmQDmqOAV4NhorkHw=;
        b=anIFo0HqTUq6Q8OaS1iLz+7sCpz1Y4IOXhJShH09+NYu0z9Rr0qoEuOoDxbrJ7gzyb
         2a62VVwMNDulYctUXaNPfBDjKX50+5yIqhSUXnJz/cZefSNG7nlkbHKbWCvjt5cg+jY1
         6TeVsaZa2rrMsBB0GnJXUNPw7kKlXJkMOJpiucQdaCgmg/ooxGyzw6hViXA2EnW000j/
         M4rvd0QxEI7vCFFRXZYNvc2sx43swlLmKhMKkxtojgpTrNQI9qt1pbbKo2PgtNTAhhdp
         PDvIBld6sAdaVONM7RLJ/oPYJZSpWwzvaHHcxhLpE5hP8d4J+wc3uucVsI5eQlzWTfvZ
         gKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BxbWIyImdzA25H+jox/xdDou7lPmQDmqOAV4NhorkHw=;
        b=BzlUoHHgyrlTkMykKVGgrGLMvb0VAswGgLfCaPDpUwKWaw152NF0ZQV3+3SBARhZY6
         +GsmCujFEceapsgEi7cRQU3H1PDvHPT76iy/jNw496Q5bMZ8tbVPWAyZncy2i8JVQ2Db
         +Ya/S+ygi6b3hweRL5RDZxYSu8su4l55ZOkp0WGxu+m/JrpYzaQrAR4ihS9U4kPGX2Qk
         YXoNiP7amzigEN5x1jL9tbSEnf3Xcxw+Do3AtMR5nwRcKFa8D86gFGg8mg52n99/NcPN
         Gn4CJpmmbomk6I8z15DTLbupgNaMxSNDlNWXS/ue2298v6KTuoa852Qk7X10+V/3X32O
         wuMQ==
X-Gm-Message-State: AOAM533+3qzm9gOx5NGwjK31UM5o+A/Bmpka2vPOjLCVBgfjtb3Bwd92
        HH/2tubl7bQWssQeehawH14=
X-Google-Smtp-Source: ABdhPJyox0k1n+HV1FwaAD5wwobWoXwd0wa0XsldkrCgtmGdlyI4j0i36Yg+iy3nzoqOjwxlEchmOQ==
X-Received: by 2002:aa7:d750:: with SMTP id a16mr31144433eds.252.1608056905681;
        Tue, 15 Dec 2020 10:28:25 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id r21sm7369228eds.91.2020.12.15.10.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 10:28:25 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 1/3] asm-generic/atomic: Add try_cmpxchg64() instrumentation
Date:   Tue, 15 Dec 2020 19:28:03 +0100
Message-Id: <20201215182805.53913-2-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215182805.53913-1-ubizjak@gmail.com>
References: <20201215182805.53913-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instrument try_cmpxchg64() similar to try_cmpxchg().

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 include/asm-generic/atomic-instrumented.h | 46 ++++++++++++++++++++++-
 scripts/atomic/gen-atomic-instrumented.sh |  2 +-
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/atomic-instrumented.h b/include/asm-generic/atomic-instrumented.h
index 888b6cfeed91..396d4484963a 100644
--- a/include/asm-generic/atomic-instrumented.h
+++ b/include/asm-generic/atomic-instrumented.h
@@ -1793,6 +1793,50 @@ atomic64_dec_if_positive(atomic64_t *v)
 })
 #endif
 
+#if !defined(arch_try_cmpxchg64_relaxed) || defined(arch_try_cmpxchg64)
+#define try_cmpxchg64(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+#endif
+
+#if defined(arch_try_cmpxchg64_acquire)
+#define try_cmpxchg64_acquire(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64_acquire(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+#endif
+
+#if defined(arch_try_cmpxchg64_release)
+#define try_cmpxchg64_release(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64_release(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+#endif
+
+#if defined(arch_try_cmpxchg64_relaxed)
+#define try_cmpxchg64_relaxed(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64_relaxed(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+#endif
+
 #define cmpxchg_local(ptr, ...) \
 ({ \
 	typeof(ptr) __ai_ptr = (ptr); \
@@ -1830,4 +1874,4 @@ atomic64_dec_if_positive(atomic64_t *v)
 })
 
 #endif /* _ASM_GENERIC_ATOMIC_INSTRUMENTED_H */
-// 4bec382e44520f4d8267e42620054db26a659ea3
+// 28b0549ca119ed58a9b61da6e277ee30de18bdfc
diff --git a/scripts/atomic/gen-atomic-instrumented.sh b/scripts/atomic/gen-atomic-instrumented.sh
index 5766ffcec7c5..ade2e509b5eb 100755
--- a/scripts/atomic/gen-atomic-instrumented.sh
+++ b/scripts/atomic/gen-atomic-instrumented.sh
@@ -186,7 +186,7 @@ grep '^[a-z]' "$1" | while read name meta args; do
 	gen_proto "${meta}" "${name}" "atomic64" "s64" ${args}
 done
 
-for xchg in "xchg" "cmpxchg" "cmpxchg64" "try_cmpxchg"; do
+for xchg in "xchg" "cmpxchg" "cmpxchg64" "try_cmpxchg" "try_cmpxchg64"; do
 	for order in "" "_acquire" "_release" "_relaxed"; do
 		gen_optional_xchg "${xchg}" "${order}"
 	done
-- 
2.26.2

