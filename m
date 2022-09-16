Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84A45BA628
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 06:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIPE7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 00:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIPE65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 00:58:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269D877550
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:58:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k126-20020a253d84000000b0068bb342010dso17716958yba.1
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=d5LwRjV7DdKcsn5XLPeYFH5ubqhtVVQS6ixOFLlJHpc=;
        b=pjGkeZS1M0pZn5rxAC8u92BEcb2IZzGh+0bZhIqBGD5HIJTKOAhqW8QE1t3WdJLYj+
         HqitiywleZaCUEF6XMF1qPDqSZMOSCOmScsguwxfTUoZfBe4QwolRcAstG89qMdR0+x4
         4Oa63kdrJdu5kdXhEPi2WMvvXlnbL3Ebd4SAdUYEuLR16gCGEag2ePA7E2FyFF2sTQHM
         x8r9uxORJ5Hd/GJ7zPF4kwl9IkyQoHOw92FFA4xVllzSXErODfNLT6z5hxzXr+Z4Mr0J
         hub6x5qdbg8olJhsoahrPZth6XtMK+9xyVawD7H6EAAp6lE194e5QW/qCI9I65wrRqAf
         y45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=d5LwRjV7DdKcsn5XLPeYFH5ubqhtVVQS6ixOFLlJHpc=;
        b=bRDlojCFZNrTCuG9C/7HSooPMtPjFrP7HAEe0ICsPLS/LAG8k7uvG/9m476MuW9l62
         4hSjL38i2VqlzB6oQgugLaRR4ZTV+DGWJkuaLXnwTcvcv0nbzBDF1Ct9BvQzqFMDMoCn
         CXVHdQsNjWq7ekYm6bNzaMv72IrLWosdk/3o71tOsN6ncpqwvm48TpK2WGq05ViqJEFt
         9ZmVkt/aHw2KnWt6LcViWmvox8VNFOEE3xpFNPgaEyTf/isM6xBasEzvTfw52fV3cRrv
         Kb5oX1s/z0m3GoFQJ2/kkFFlAclhzmVcrUBz0oYFIM8tkC88N6zTUucNB72X8KWGwquo
         qxAw==
X-Gm-Message-State: ACrzQf3IuE3OSNSg30F0q31e2n29oX3haSTPSZOJskihHpvc8Gt1T3Rw
        fqrvGZRXCig0FI28zD6ValcP0A3+m/qIPQ==
X-Google-Smtp-Source: AMsMyM7taiRNCajYl2BjHFX4O9FQcKsPOvQZQ5+DmV43r3eOLv4usqTCNm2CC2+3WQGNXLYPUnpLia7C4QlMvw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:2e50:0:b0:669:9a76:beb with SMTP id
 b16-20020a252e50000000b006699a760bebmr2846065ybn.597.1663304335461; Thu, 15
 Sep 2022 21:58:55 -0700 (PDT)
Date:   Thu, 15 Sep 2022 21:58:29 -0700
In-Reply-To: <20220916045832.461395-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220916045832.461395-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220916045832.461395-3-jmattson@google.com>
Subject: [PATCH 2/5] KVM: svm: Disallow EFER.LMSLE on hardware that doesn't
 support it
From:   Jim Mattson <jmattson@google.com>
To:     Avi Kivity <avi@redhat.com>, Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org
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

KVM has never properly virtualized EFER.LMSLE. When the "nested"
module parameter is true, it allows an SVM guest to set EFER.LMSLE,
and it passes the bit through in the VMCB, but the KVM emulator
doesn't perform the required data segment limit checks in 64-bit mode.

With Zen3, AMD has dropped support for EFER.LMSLE. Hence, if a Zen3
guest sets EFER.LMSLE, the next VMRUN will fail with "invalid VMCB."

When the host reports X86_FEATURE_NO_LMSLE, treat EFER.LMSLE as a
reserved bit in the guest. Now, if a guest tries to set EFER.LMSLE on
a host without support for EFER.LMSLE, the WRMSR will raise a #GP.

At the moment, the #GP may come as a surprise, but it's an improvement
over the failed VMRUN. The #GP will be vindicated anon.

Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..7c4fd594166c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5012,7 +5012,9 @@ static __init int svm_hardware_setup(void)
 
 	if (nested) {
 		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
-		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
+		kvm_enable_efer_bits(EFER_SVME);
+		if (!boot_cpu_has(X86_FEATURE_NO_LMSLE))
+			kvm_enable_efer_bits(EFER_LMSLE);
 	}
 
 	/*
-- 
2.37.3.968.ga6b4b080e4-goog

