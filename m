Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124E121BE4E
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 22:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgGJUHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 16:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbgGJUHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 16:07:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC2DC08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:07:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u64so8370073ybf.13
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FxTh+Uy8ShoEPdiTzUZw1gLA0UctO3xQ6htNhpRyfMc=;
        b=Wj1GQeHI3JJJIf0NUnIyokTf+rFQ3aBh5XH+UsuEqh3z+aU3BR6aIWMUcg5S6dxSdO
         7bB/pkkNDjrL1qLCZ4k07IEmyd3KaZEay4VWdPOfh4Q3a7bvB/J2nPG/3yzjnEwXB9lt
         Lko7ir9Z9/m40B5jgZoxqQ9DRXs6oM8dh+qm6u1wI8jc6qo9U5tHzZraxyJgfkU2fzUk
         xxwsNzr7tzxpKYHuj8O8figQuQvh1YOnL+icQcCGpVllvAEwCzFtg12ZaJXFxcJaClc0
         o3St+9pPB7ZeHQUrCv3EZSQAHQo2MtnYPt05VwO5DLkXWJRm+QE5pd8ZeB0zKjcc29gV
         49hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FxTh+Uy8ShoEPdiTzUZw1gLA0UctO3xQ6htNhpRyfMc=;
        b=dt+wTbPGQfjNqWCIF7fxqfly+/xHsYZR8BHQO91MlnWpxarZkVZjY7msttbUc/duTT
         H2t2/i8ui3X9r5ccAmO/4bwghKpBeDmw3NGEZOpzqgymzj8Kd2zLHyb7AvgWjliCyniu
         FdYSNVzTUVUudNq85cqeDnUssm1Ebl/NIbHLhrH+luPRewA3Ey9NGwjhzJ8maeoZiJ06
         OVSAWIFyHVy2dY4Xm0aaazKX6eD1WzyWk11t8fAU83BdtzbbMfDDWNcItl7aC56fQ0Zy
         1XauaFIp6MQX0TQwB9OAFbKzEwCOOXQxP16RK/pt6H6Xw62sKZVNmeieRn4D4antVeem
         wOIA==
X-Gm-Message-State: AOAM532rdHe8c9/DTJmsunKokKNsVLgLNk0ZTjOwSROX9CXqMO073Dgd
        tGs8xQ4+FIN9GaE+TL4poQCysmdZwChjUhdjmm7PyHXds7pccT1VZxUY825p79laVoWuOFKa97c
        mRpoVU0pH2QGiCA0vgncaNEPHlef3d9DmAVUcZ3vb7tb7YzfE2I7m30V+cw==
X-Google-Smtp-Source: ABdhPJxz9KDyHl+Zem3OwLp1yDEje2Fs2nbuq/3slWP8BEp46vxNffKrzo2cR/K4SAoKmITBdE0xwTirbV4=
X-Received: by 2002:a25:5d04:: with SMTP id r4mr107750102ybb.290.1594411669417;
 Fri, 10 Jul 2020 13:07:49 -0700 (PDT)
Date:   Fri, 10 Jul 2020 20:07:42 +0000
In-Reply-To: <20200710200743.3992127-1-oupton@google.com>
Message-Id: <20200710200743.3992127-3-oupton@google.com>
Mime-Version: 1.0
References: <20200710200743.3992127-1-oupton@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 3/4] selftests: kvm: use a helper function for reading cpuid
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Derived from kvm-unit-tests.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 .../selftests/kvm/include/x86_64/svm_util.h       |  7 ++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..316fbd4700ef 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -338,6 +338,21 @@ uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 
+struct cpuid {
+	u32 a, b, c, d;
+};
+
+static inline struct cpuid raw_cpuid(u32 function, u32 index)
+{
+	struct cpuid r;
+
+	asm volatile("cpuid"
+		     : "=a"(r.a), "=b"(r.b), "=c"(r.c), "=d"(r.d)
+		     : "0"(function), "2"(index));
+
+	return r;
+}
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index b7531c83b8ae..47a13aaee460 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -38,12 +38,9 @@ void nested_svm_check_supported(void);
 
 static inline bool cpu_has_svm(void)
 {
-	u32 eax = 0x80000001, ecx;
+	struct cpuid r = raw_cpuid(0x80000001, 0);
 
-	asm("cpuid" :
-	    "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
-
-	return ecx & CPUID_SVM;
+	return r.c & CPUID_SVM;
 }
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
-- 
2.27.0.383.g050319c2ae-goog

