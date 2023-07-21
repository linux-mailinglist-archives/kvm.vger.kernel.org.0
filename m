Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673F675D58C
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjGUUUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjGUUTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9523C10
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d06d36b49f9so311901276.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970769; x=1690575569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=crVRYHKBiix+9k25sqJYwYQ0PSqShcL9j1oDpcsA6Dw=;
        b=RBMLDqiHzxUqzpaXDgFLDPjpgSNfDoJR5XmTJs6L39FY207ornlD4wCggqqn+VPvnX
         obC6S0TQlHfM4bAlkMqGJoQfHMjSkF5rRIvGYLw0fKnXaYAG4jlkOuczjYzK20mkYAdj
         2YUb2v/3KZQC34lVsFniXRfYO+rQiS7vKyeoW2e8jLhiydA8oIrl9Lk83BpOAAzGHwsS
         yQz2W/AOA95nN24PfMg8quSvL9++qNmgUOm8rU4FPZqMM/ZKEf4dQ+KjsJIEJm7VODr3
         hN10+m9kznfjnNbZSm7xnVwZJq9pQnA6bgdEHbuu2VCvgb2oKlx6c+qOmdjYfoKCXoAa
         vzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970769; x=1690575569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=crVRYHKBiix+9k25sqJYwYQ0PSqShcL9j1oDpcsA6Dw=;
        b=ZzV2u2cTo49uuh2yEXDkvyaoLnbM+uAxXi8szARe3cI1eUdtA6ph/O74a2kgr4hi1d
         mus2WLB/xSuR8VLSBTWANePfTu55thO9uhLJvTMFW3UC/RGflWuqpW3ceDEhmf10fx0V
         X6lcrhl65bxqWKXROF6paV6BZ1uHr6n1btzfNtxeg1JDK1hw92bGC+ZJC9LHRw/A5Pcd
         9IdF8q58JjPJI3Jk4fEJoQUBxfi6cwci2d33y4W+zFhmydwbs0xrPObK7vlHPPPP9pD5
         FAPblFydcFmBPI7CIERSgOrLDT/zOdyVFYFJ/hCQraBBOIxcisE7fihvct2XDyl9C8Rr
         lfBw==
X-Gm-Message-State: ABy/qLaV6KRUCuA3So9EI471diESitq98sDe0nMZRSx7OWYoWHZe0wSO
        URkuhOFBH8GQP9wDbHrTq8dIh0J31Do=
X-Google-Smtp-Source: APBJJlE6O9VWoBAfPXKasyFdCqfa4t7wQIuYDKMRbknWhJoZeoUSwoDVta8TzLzKwebv41u+QzA8IEe4eCk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:188b:0:b0:cab:e42c:876b with SMTP id
 133-20020a25188b000000b00cabe42c876bmr18130yby.3.1689970768563; Fri, 21 Jul
 2023 13:19:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:52 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-13-seanjc@google.com>
Subject: [PATCH v4 12/19] x86/virt: Drop unnecessary check on extended CPUID
 level in cpu_has_svm()
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the explicit check on the extended CPUID level in cpu_has_svm(), the
kernel's cached CPUID info will leave the entire SVM leaf unset if said
leaf is not supported by hardware.  Prior to using cached information,
the check was needed to avoid false positives due to Intel's rather crazy
CPUID behavior of returning the values of the maximum supported leaf if
the specified leaf is unsupported.

Fixes: 682a8108872f ("x86/kvm/svm: Simplify cpu_has_svm()")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index a27801f2bc71..be50c414efe4 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -39,12 +39,6 @@ static inline int cpu_has_svm(const char **msg)
 		return 0;
 	}
 
-	if (boot_cpu_data.extended_cpuid_level < SVM_CPUID_FUNC) {
-		if (msg)
-			*msg = "can't execute cpuid_8000000a";
-		return 0;
-	}
-
 	if (!boot_cpu_has(X86_FEATURE_SVM)) {
 		if (msg)
 			*msg = "svm not available";
-- 
2.41.0.487.g6d72f3e995-goog

