Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD2DBE950
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 02:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbfIZAE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 20:04:29 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:53767 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733141AbfIZAE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 20:04:28 -0400
Received: by mail-qk1-f201.google.com with SMTP id g62so566908qkb.20
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 17:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0aiAhoNw7rgiXm4ReXuu/I7OpOSCaP8Se4pfHqvUc7o=;
        b=FZ33j6yhM793vppuNUJ9eG0snnRS4NCqlhG5FAi4ykVYuzZIJU0X82/o4XRchT08q5
         hhvT1EE+SfGeuv04QsX2h08Clq95IfQZz4l5xfbnGT+ntVsR255IFyUIqiZTAMMlqcIJ
         0h6H15f+74Sj5CmhgSvdPYY+xYZP/sLwRmd/hTkjndwUf5/2SQtYz+61RF3cJeVNYN3o
         x46ChISCwdKDzhqxeKwhalNozHauDMkxiRaFztYT7/OpTTrsLJgk2EON40LIO8+rXJ1r
         UeZhqOrHSSsosQh0LNC8NIUXU63MGXtexfnM1tiEudCkd5DsQ5d28a8jo84IQe/iMTXv
         mXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0aiAhoNw7rgiXm4ReXuu/I7OpOSCaP8Se4pfHqvUc7o=;
        b=Wo1YGI0VKQ2uWFzt5cGbSryLEocxOMgkhJ0ykaV3eF2TGqfzFE78EUIIgt9Nb+Kkgy
         bOYYzc/edMVj7E7Mrzz1yz1Ct1SrzmSu5k48Ynor/sbhRwbkrs1097gWD/OCJL2difQ2
         GFt+c8I6m7Cl5CBu7yTJDvcmiOTfffKp4jGaMTW1jsH+etz6TGAXdxqTNvLXDgplIYOq
         oweovlL4DLVFcdHGiQeOCmkglXsiEXP1eJn+yyCnbeFCpGvPL3OK6iNBylqiGMn6cWx+
         Es4DGPDfvNYmmkSBjFem0hD0EXslRxpyiS0SEtR1R9v6qOL4tmpTNyzSYQKilQnJgTa9
         p2qA==
X-Gm-Message-State: APjAAAXZ67/j/rYw4Lq/6rf6eMbJN26V1LJ9R2r7n0Hz17Q3DarBocOF
        SQEI9VBVcTprS0fVfqquBcz68j8UUjyBKKq4sgMmjFjUC5z+MT6ffMCWVd/XEXR3JlRascaC/Lb
        9tzS/ugs2+P8uutwNJkOPS85um7eZ7Vir9cXC3wldXis4RBi8x4vWog1CDBpoaCY=
X-Google-Smtp-Source: APXvYqwV/ff1pFk/QG7OJ4dfX+tMHLc3N+0sDlTyyzdy2GU5+St5jjQGj3Yin7FYJgTVbov9tmPmtH17c5EMdA==
X-Received: by 2002:ac8:7244:: with SMTP id l4mr1254814qtp.40.1569456267027;
 Wed, 25 Sep 2019 17:04:27 -0700 (PDT)
Date:   Wed, 25 Sep 2019 17:04:17 -0700
Message-Id: <20190926000418.115956-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH 1/2] kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For these CPUID leaves, the EDX output is not dependent on the ECX
input (i.e. the SIGNIFCANT_INDEX flag doesn't apply to
EDX). Furthermore, the low byte of the ECX output is always identical
to the low byte of the ECX input. KVM does not produce the correct ECX
and EDX outputs for any undefined subleaves beyond the first.

Special-case these CPUID leaves in kvm_cpuid, so that the ECX and EDX
outputs are properly generated for all undefined subleaves.

Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 83 +++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd5985eb61b4c..35e2f930a4b79 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -963,53 +963,64 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 /*
- * If no match is found, check whether we exceed the vCPU's limit
- * and return the content of the highest valid _standard_ leaf instead.
- * This is to satisfy the CPUID specification.
+ * If the basic or extended CPUID leaf requested is higher than the
+ * maximum supported basic or extended leaf, respectively, then it is
+ * out of range.
  */
-static struct kvm_cpuid_entry2* check_cpuid_limit(struct kvm_vcpu *vcpu,
-                                                  u32 function, u32 index)
+static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 {
-	struct kvm_cpuid_entry2 *maxlevel;
-
-	maxlevel = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
-	if (!maxlevel || maxlevel->eax >= function)
-		return NULL;
-	if (function & 0x80000000) {
-		maxlevel = kvm_find_cpuid_entry(vcpu, 0, 0);
-		if (!maxlevel)
-			return NULL;
-	}
-	return kvm_find_cpuid_entry(vcpu, maxlevel->eax, index);
+	struct kvm_cpuid_entry2 *max;
+
+	max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
+	return max && function <= max->eax;
 }
 
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit)
 {
 	u32 function = *eax, index = *ecx;
-	struct kvm_cpuid_entry2 *best;
-	bool entry_found = true;
-
-	best = kvm_find_cpuid_entry(vcpu, function, index);
-
-	if (!best) {
-		entry_found = false;
-		if (!check_limit)
-			goto out;
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_cpuid_entry2 *max;
+	bool found;
 
-		best = check_cpuid_limit(vcpu, function, index);
+	entry = kvm_find_cpuid_entry(vcpu, function, index);
+	found = entry;
+	/*
+	 * Intel CPUID semantics treats any query for an out-of-range
+	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
+	 * requested.
+	 */
+	if (!entry && check_limit && !cpuid_function_in_range(vcpu, function)) {
+		max = kvm_find_cpuid_entry(vcpu, 0, 0);
+		if (max) {
+			function = max->eax;
+			entry = kvm_find_cpuid_entry(vcpu, function, index);
+		}
 	}
-
-out:
-	if (best) {
-		*eax = best->eax;
-		*ebx = best->ebx;
-		*ecx = best->ecx;
-		*edx = best->edx;
-	} else
+	if (entry) {
+		*eax = entry->eax;
+		*ebx = entry->ebx;
+		*ecx = entry->ecx;
+		*edx = entry->edx;
+	} else {
 		*eax = *ebx = *ecx = *edx = 0;
-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, entry_found);
-	return entry_found;
+		/*
+		 * When leaf 0BH or 1FH is defined, CL is pass-through
+		 * and EDX is always the x2APIC ID, even for undefined
+		 * subleaves. Index 1 will exist iff the leaf is
+		 * implemented, so we pass through CL iff leaf 1
+		 * exists. EDX can be copied from any existing index.
+		 */
+		if (function == 0xb || function == 0x1f) {
+			entry = kvm_find_cpuid_entry(vcpu, function, 1);
+			if (entry) {
+				*ecx = index & 0xff;
+				*edx = entry->edx;
+			}
+		}
+	}
+	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
+	return found;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
 
-- 
2.23.0.351.gc4317032e6-goog

