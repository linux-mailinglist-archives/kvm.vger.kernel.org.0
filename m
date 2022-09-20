Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94825BEED9
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiITU76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 16:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiITU7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 16:59:50 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3517112741
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 13:59:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s68-20020a632c47000000b00434e0e75076so2273918pgs.7
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 13:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=CtU5neKaHkcR+gqY0FDNg95nKTzPwcdnVlYYcQLqv5g=;
        b=UYZJTSuMWgBQGJVkNbAFEyDxsNpyBWKX9jfmgCGxoRLs7PKm+0eEZJGyY0mdAYQafd
         dC7CEpZdCc42AoQvxPOYoBTkb44cDre9QBj1E6VgTpo98rvF3EnnPpqkb0JdbAHo52Ah
         jFIZacTMz62sOB6yJfGJ49I0ih38iONGjiJMGAyGxzQxQ9ApdS6mp06S9xNclBShEF4L
         SB5HE3+0FOzwFG3hH1aF16oWc/YzHlpwEGVbqCCMygd5NKtcM8+quTQNUly8pj68M+Ms
         eFjdkFHnh0Fh77qc4k+Y880x5nAN0cTmDIaKIh+1IKqqqKLoTLvqHn192Ji7v5/HJ9Ba
         b6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=CtU5neKaHkcR+gqY0FDNg95nKTzPwcdnVlYYcQLqv5g=;
        b=l+iREQUgFHSrp0hbzI3Z9w03p6ZSjk7hTHTUWPgbH4STvNORtILkgCpPeRkLzUbnso
         XZi7CyJU0LOHZfhpffn4Uuy3lxjjQK/Q6oNzbHQxI6ClQ3qUlQq2f4iYCZOosy7nNdfq
         DPfmvsleCDw4oDsC7mmDd49gMkQs/oYG59+1xwHVIemaMFu2eRBR3ukDy+Af3XT+OhHM
         WbdIfj1Ee9slodFZ/+mszxRe5y1aoLo6XfxTKuYSavIFYbXFYgfW5cvI1d1kaz1+ygP3
         Gf7o8nYsT2L0SYWSLFurA1OOXh5UX+LEKapuJh4p8J1plEOqlOo4KohPQ1gG7ema/O6X
         qThg==
X-Gm-Message-State: ACrzQf0MlLqQz4O8D7oMCrx+hgb7q2NmJ2Vak0RpguFxiOK5RRnji2Cq
        Zwe3WOrM6R9te0o6dr1Ph+SbSezQNY7uUw==
X-Google-Smtp-Source: AMsMyM5sn0kmQvUal8aWjiFqlURJCVv+OEf2bD7ub022kJG8AKCl1w0qs18psU0JIpmC+qtnnJez34np53SDtw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:aa7:8892:0:b0:540:edcb:4773 with SMTP id
 z18-20020aa78892000000b00540edcb4773mr25226885pfe.19.1663707587772; Tue, 20
 Sep 2022 13:59:47 -0700 (PDT)
Date:   Tue, 20 Sep 2022 13:59:22 -0700
In-Reply-To: <20220920205922.1564814-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220920205922.1564814-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920205922.1564814-4-jmattson@google.com>
Subject: [PATCH v2 3/3] KVM: SVM: Unconditionally enumerate EferLmsleUnsupported
From:   Jim Mattson <jmattson@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
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

CPUID.80000008H:EDX.EferLmsleUnsupported[bit 20] indicates that
IA32_EFER.LMSLE[bit 13] is unsupported and must be zero.

KVM doesn't support "Long Mode Segment Limit Enable," even if the
underlying physical processor does, so set that bit in the guest CPUID
table returned by KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3af360fe21e6..0bf6ac51f097 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4945,6 +4945,7 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+	kvm_cpu_cap_set(X86_FEATURE_NO_LMSLE);
 
 	/* AMD PMU PERFCTR_CORE CPUID */
 	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-- 
2.37.3.968.ga6b4b080e4-goog

