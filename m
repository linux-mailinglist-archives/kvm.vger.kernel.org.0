Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707D075D586
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjGUUTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjGUUTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6A730DD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c361777c7f7so5867512276.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970763; x=1690575563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BxIdNivQmBNQSOlXPPIQGt5Qzqr/3+s4YS24y1+Qiwc=;
        b=Gu6EPZofnedmVcu0puGF5uwGMb+h5xD1qVMdFfjhDXwf0ojqQzZcD1qu3BQJegbXvr
         KLDtNr2gxNXiIGG01q1nWzcC8TWglrMhxSng4NJhIYe0BpCdke22vxvfKTVbuomgvUAN
         S0b2LRn9a7StmxWvePSakXfo0f6VjA0axqDjd3pZE1xoRBMdZO313rBIR4eu9qDLo1wM
         usH/HLHPIkA/2/CyF4G08TZ7X9D3vVMe5uXA535W675kmFLdT8+6jOaYRnBeap6S3TBj
         xg8Pj92dho+Sxc3VU4JDANpOH3JDVZFimXcHgJArCZfVA+xuGI+5RJ5z3B3A6VLxOY+a
         DVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970763; x=1690575563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BxIdNivQmBNQSOlXPPIQGt5Qzqr/3+s4YS24y1+Qiwc=;
        b=FmCMGsca+EI43n8e+FpMrWRGG7gR75PtwqvJCLNWlqOi1ynXrLxZ/joO/pTzdyagLR
         ZNzGeexcschf/22gzBTYByXxMTtd68jAMPKSp9IQFCo+eq8GgK1RpCXTpIzBMX3gkpMs
         S+NJKiwZqX+epYmiwsaw0knAKqFvCI02XFlf4B+qjrH1foRq6p7trMrEOEFVP18ylBJ0
         atNz3NmLP3EEzbWPG+QOccHUBpKMWGNlTlKpRd8H7OmLRA2//AmLm5Uk+KD3PnNSsjsv
         NUlgHLhuhPLOCANgqF1dOy6LpaFosryCK0TNSB3wGA2388mJ/QZJl//avCnaZRzqVF8H
         TjRw==
X-Gm-Message-State: ABy/qLYXe9mkn7D5gwIgwtOYGUJRAXMOfcm+myx5rcoP6rOkJWPST5/o
        I72kYJ6/tDghLSnvNj6JaxZ35pkYhgo=
X-Google-Smtp-Source: APBJJlH+JZBH+A2VRttCcgXplZCHJDHZLy6DgW6Igx6xsBqN18TpvDYqMpdpfHZnvHRh1rUMWWVU6dzjIzg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:a8d:0:b0:d04:6d5e:4ded with SMTP id
 h13-20020a5b0a8d000000b00d046d5e4dedmr25333ybq.6.1689970762838; Fri, 21 Jul
 2023 13:19:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:49 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-10-seanjc@google.com>
Subject: [PATCH v4 09/19] x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
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
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold the raw CPUID check for VMX into kvm_is_vmx_supported(), its sole
user.  Keep the check even though KVM also checks X86_FEATURE_VMX, as the
intent is to provide a unique error message if VMX is unsupported by
hardware, whereas X86_FEATURE_VMX may be clear due to firmware and/or
kernel actions.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 10 ----------
 arch/x86/kvm/vmx/vmx.c         |  2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index aaed66249ccf..b1171a5ad452 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -22,14 +22,6 @@
 /*
  * VMX functions:
  */
-
-static inline int cpu_has_vmx(void)
-{
-	unsigned long ecx = cpuid_ecx(1);
-	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
-}
-
-
 /**
  * cpu_vmxoff() - Disable VMX on the current CPU
  *
@@ -61,8 +53,6 @@ static inline int cpu_vmx_enabled(void)
 }
 
 /** Disable VMX if it is enabled on the current CPU
- *
- * You shouldn't call this if cpu_has_vmx() returns 0.
  */
 static inline void __cpu_emergency_vmxoff(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 682c20b33a96..71571cd9adbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2718,7 +2718,7 @@ static bool kvm_is_vmx_supported(void)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (!cpu_has_vmx()) {
+	if (!(cpuid_ecx(1) & feature_bit(VMX))) {
 		pr_err("VMX not supported by CPU %d\n", cpu);
 		return false;
 	}
-- 
2.41.0.487.g6d72f3e995-goog

