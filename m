Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223F3C2B0F
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbfI3Xo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:44:29 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:55747 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732438AbfI3Xo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:44:27 -0400
Received: by mail-qt1-f201.google.com with SMTP id o34so15648572qtf.22
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 16:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0o2sDG2onspAdLwyFGUwXv4nf0zyggeaKnQ8TCNpMBU=;
        b=wCynY8suLurhEP7wm6IueYAn/IwyDcEakAXk0edrFlxH6cXPEkdcpvnT5UdwXYkPR7
         V6ezBXzv8hOtW+zkyO2K9HzpDMt1yv2nMa/C0Y+57zM2RZOWqaYmHyWRq6SKlbIaMwKs
         qb5W2W1qb87tutUMCaT0zTWISywAwJsvfvMrkRO9rPYHqewSotL0zg0N3wMWMJ1w6HN0
         gr7dzmhJIgu9UTALgQWzTU7FcMD1uxUryHHpx9vvXB6eyCbMEcWUGDyuab+TfF/lLCyG
         PXPTQ5ST4ddKx+feoMu/MomFrqPO0pO7rLnsFewvS/WE6ppde92rUVjZf9SJIMgNECAW
         xuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0o2sDG2onspAdLwyFGUwXv4nf0zyggeaKnQ8TCNpMBU=;
        b=r/Qt9JKULfK8y4tvNrzqV07IqsYgge8//D8q26W7trmS60MMm9YS0a+clbx9QWPYIu
         kkEvbucKhqml295rkbjAe0W65Ojr7xE0MeXrKCd+Mvm3iEyi11ySMTT/975eTKB2kZS4
         4fJvD03vx3pjz6irIF89wqp1J6lfXJDp+gaaYN/JWeXrI4CfDeN09LgyzNC+oxoktH/2
         /PejtcSc+RRqxK+f5OojtdngQdgRllPmQvNm6jIVF8TwajTgoRSAQAAN1FPq+Jiylmyj
         P1mi3Xn8qt6+lmIWUHCpEjYkANFz0Nq0hKHJUp5xblR+b0YVBTcBni7DsTjFeoqy1i+w
         FsVg==
X-Gm-Message-State: APjAAAUoOsw8FL1pChwh/jKDDe5v3xGTWPmZMQmA+20takm6PgUmVGH8
        Dd4Y6hkSO+C26WJBvIKsG7JDZcTRYqaP+TN20WFJS1LFF9FIkdamXfwlngCGP+jwBnZYfudZ5Wk
        WQvyRmgPXeug4Pvb0TIv5jLdOiF7984N8XWRnxa7SbqySW7GfCGismRLUMY8oiIw=
X-Google-Smtp-Source: APXvYqysnC8iWp8kv3PDj10qcTikP/WlC84GKiZEYgeRujY22YpJyxAosMFwQqteQ3WlWotL7dIMUaxefhyNRw==
X-Received: by 2002:a05:6214:1549:: with SMTP id t9mr23091655qvw.68.1569887066151;
 Mon, 30 Sep 2019 16:44:26 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:44:22 -0700
Message-Id: <20190930234422.159577-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH v2] kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>
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
---
v1 -> v2: Changed the way that kvm_cpuid() determines whether or not
          leaf 0BH or 1FH is defined.

 arch/x86/kvm/cpuid.c | 82 +++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 63316036f85a0..218d14d590f65 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -969,53 +969,63 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
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
+		 * subleaves. Leaf 0BH or 1FH is defined when ECX[15:8]
+		 * is non-zero for subleaf 0.
+		 */
+		if (function == 0xb || function == 0x1f) {
+			entry = kvm_find_cpuid_entry(vcpu, function, 0);
+			if (entry && (entry->ecx & 0xff00)) {
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
2.23.0.444.g18eeb5a265-goog

