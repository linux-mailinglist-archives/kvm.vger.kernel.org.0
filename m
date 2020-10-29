Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8352929F2A9
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 18:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgJ2RKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 13:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgJ2RKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 13:10:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979E3C0613CF
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 10:10:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 189so3274867ybp.12
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 10:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=l8eIoaaUnZd6d2xO5UkZkCplg4SEHOvTFFZSknr9hKw=;
        b=YgaPoj/XrpsdPD7VRiwTVLQf2cSGa65dkmUuHrmnobnDUgJfRP71xV5RtV/nvJymuq
         olBm5ifdxU/tr1tQOL7aj5Pr0n7u6RO4RUuZOGliuyKEtWjIRklDbjNaOqGJVhvwsiPN
         fLePFdlmA/WP1mI8iLSoaLMCwJOFN1e3RpFCx52mvYdgcEqHkE07jGtmAiUagkasLpuW
         8DByqdKa0oSJQe8CoDOkidtuOSf1I5LbIWls20/1l6CCwqx4ig7v08D5lMSuE3LTe8lj
         cSpkN3pc7EqRhYcy5A13dngfOMZm/9pudMxToAaqsxOWRCBLvj3ScboMwZSUWOeqzPG1
         t4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=l8eIoaaUnZd6d2xO5UkZkCplg4SEHOvTFFZSknr9hKw=;
        b=tNFKoYbA2fEPz0XZJAuq0MIWP4Id8jsx7IV1yqJufbfriT0MnYAdtxMU/Gyfn9dgrA
         EdoP6iYd0mnIHZ0ZPzKooPyc+Srg7UtwlO2/WNtsRdZCA9YjaZdFW8sq5KGDw3ty4YRZ
         Sz5IXaBthaTAYCDhuCzOwimeQPSiLvE7QThfTNP9zXz4rIvwdaQfT+gM34G8Gb9s+vA1
         QZOa4G61k8Z8KvVuhbDJSk6zOqIir3vRN1RUam/AULCmjVv1YsHb0/mKbhNLE7ONeyri
         QXcnmYE1QKaBJFOcSJfWsOge0FPV0hGK1d3MYBS2O4DB90ANUPCniC/d81gh5aim4zCO
         Ry9g==
X-Gm-Message-State: AOAM532Qsfa8k+Jzz4448McvYak+LsO6NUnNw0Mf1oh1SyzW9phJyB8W
        Aw0rKk6QmzaSoF3S4jAZ/E6EdwhYcCss5mTDUh+qeLmuF+WOx9w+NP7nKG++Lb8onP/JvH5+jb9
        oxg7uZjeeZGiuiUr7oxD+nOZ+d0yVgUylKyVYAGaR+m2icFAbKzJieMlBuM7JaWQ=
X-Google-Smtp-Source: ABdhPJxxovbfs/W4E5Fg9eCPn1dymlqPWtmG/deCMqhh3eaQJguiLOfXNdGn3knHNelJ4xRMSclrjJRtzBbtGg==
Sender: "jmattson via sendgmr" <jmattson@turtle.sea.corp.google.com>
X-Received: from turtle.sea.corp.google.com ([2620:15c:100:202:725a:fff:fe43:64b1])
 (user=jmattson job=sendgmr) by 2002:a25:d345:: with SMTP id
 e66mr7065387ybf.307.1603991431788; Thu, 29 Oct 2020 10:10:31 -0700 (PDT)
Date:   Thu, 29 Oct 2020 10:10:23 -0700
Message-Id: <20201029171024.486256-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: vmx: Add test for L2 change of CR4.OSXSAVE
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If L1 allows L2 to modify CR4.OSXSAVE, then L0 kvm recalculates the
guest's CPUID.01H:ECX.OSXSAVE bit when the L2 guest changes
CR4.OSXSAVE via MOV-to-CR4. Verify that kvm also recalculates this
CPUID bit when loading L1's CR4 from the "host CR4" field of the
VMCS12.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 lib/x86/processor.h | 52 +++++++++++++++++++++++++--------------------
 x86/vmx_tests.c     | 34 +++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index c2c487c..79ebbd1 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -26,30 +26,31 @@
 #define PF_VECTOR 14
 #define AC_VECTOR 17
 
-#define X86_CR0_PE     0x00000001
-#define X86_CR0_MP     0x00000002
-#define X86_CR0_EM     0x00000004
-#define X86_CR0_TS     0x00000008
-#define X86_CR0_WP     0x00010000
-#define X86_CR0_AM     0x00040000
-#define X86_CR0_NW     0x20000000
-#define X86_CR0_CD     0x40000000
-#define X86_CR0_PG     0x80000000
+#define X86_CR0_PE	0x00000001
+#define X86_CR0_MP	0x00000002
+#define X86_CR0_EM	0x00000004
+#define X86_CR0_TS	0x00000008
+#define X86_CR0_WP	0x00010000
+#define X86_CR0_AM	0x00040000
+#define X86_CR0_NW	0x20000000
+#define X86_CR0_CD	0x40000000
+#define X86_CR0_PG	0x80000000
 #define X86_CR3_PCID_MASK 0x00000fff
-#define X86_CR4_TSD    0x00000004
-#define X86_CR4_DE     0x00000008
-#define X86_CR4_PSE    0x00000010
-#define X86_CR4_PAE    0x00000020
-#define X86_CR4_MCE    0x00000040
-#define X86_CR4_PGE    0x00000080
-#define X86_CR4_PCE    0x00000100
-#define X86_CR4_UMIP   0x00000800
-#define X86_CR4_LA57   0x00001000
-#define X86_CR4_VMXE   0x00002000
-#define X86_CR4_PCIDE  0x00020000
-#define X86_CR4_SMEP   0x00100000
-#define X86_CR4_SMAP   0x00200000
-#define X86_CR4_PKE    0x00400000
+#define X86_CR4_TSD	0x00000004
+#define X86_CR4_DE	0x00000008
+#define X86_CR4_PSE	0x00000010
+#define X86_CR4_PAE	0x00000020
+#define X86_CR4_MCE	0x00000040
+#define X86_CR4_PGE	0x00000080
+#define X86_CR4_PCE	0x00000100
+#define X86_CR4_UMIP	0x00000800
+#define X86_CR4_LA57	0x00001000
+#define X86_CR4_VMXE	0x00002000
+#define X86_CR4_PCIDE	0x00020000
+#define X86_CR4_OSXSAVE	0x00040000
+#define X86_CR4_SMEP	0x00100000
+#define X86_CR4_SMAP	0x00200000
+#define X86_CR4_PKE	0x00400000
 
 #define X86_EFLAGS_CF    0x00000001
 #define X86_EFLAGS_FIXED 0x00000002
@@ -609,4 +610,9 @@ static inline int cpu_has_efer_nx(void)
 	return !!(this_cpu_has(X86_FEATURE_NX));
 }
 
+static inline bool cpuid_osxsave(void)
+{
+	return cpuid(1).c & (1 << (X86_FEATURE_OSXSAVE % 32));
+}
+
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index d2084ae..301ca85 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8416,6 +8416,39 @@ static void vmx_cr_load_test(void)
 	TEST_ASSERT(!write_cr4_checking(orig_cr4));
 }
 
+static void vmx_cr4_osxsave_test_guest(void)
+{
+	write_cr4(read_cr4() & ~X86_CR4_OSXSAVE);
+}
+
+/*
+ * Ensure that kvm recalculates the L1 guest's CPUID.01H:ECX.OSXSAVE
+ * after VM-exit from an L2 guest that sets CR4.OSXSAVE to a different
+ * value than in L1.
+ */
+static void vmx_cr4_osxsave_test(void)
+{
+	if (!this_cpu_has(X86_FEATURE_XSAVE)) {
+		report_skip("XSAVE not detected");
+		return;
+	}
+
+	if (!(read_cr4() & X86_CR4_OSXSAVE)) {
+		unsigned long cr4 = read_cr4() | X86_CR4_OSXSAVE;
+
+		write_cr4(cr4);
+		vmcs_write(GUEST_CR4, cr4);
+		vmcs_write(HOST_CR4, cr4);
+	}
+
+	TEST_ASSERT(cpuid_osxsave());
+
+	test_set_guest(vmx_cr4_osxsave_test_guest);
+	enter_guest();
+
+	TEST_ASSERT(cpuid_osxsave());
+}
+
 static void vmx_nm_test_guest(void)
 {
 	write_cr0(read_cr0() | X86_CR0_TS);
@@ -10496,6 +10529,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_vmcs_shadow_test),
 	/* Regression tests */
 	TEST(vmx_cr_load_test),
+	TEST(vmx_cr4_osxsave_test),
 	TEST(vmx_nm_test),
 	TEST(vmx_db_test),
 	TEST(vmx_nmi_window_test),
-- 
2.29.1.341.ge80a0c044ae-goog

