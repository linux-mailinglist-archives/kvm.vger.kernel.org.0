Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0071E3677B5
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhDVDGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbhDVDGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:06 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A634C061344
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:32 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id o15-20020ac872cf0000b02901b358afcd96so14407952qtp.1
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EMph4t9SyrI9bTzUMJDc6xZ7plWzVLao+xDDwxYob5M=;
        b=ZpPD1qCoY84i2y7XuZsXMULEayI/WQeMF+JSCPFMAaloy3v+vKTKxIENA2QHDPOiVR
         oEKpCZ49AAv6jzRkJCKXRiyrRnH5vZMPr3v/HDDqTBSvS9VYXdeyi46TfxbhihV6Qrlk
         F/D0Eq2N6sAjzBdOuRR7QmVWcUjvgJiAVc5RLKKcP2sudJfuf0B+eRB8Oh8rbaqbgbKB
         dfO4lkusFT0Ngmw75YXHCfuuEV+JWEJb+DHe96mtoYcLYs3oSrfxiOo2wgqI1n14H7iy
         192Tk8SLNYMfNU0MEVXxF6kuJnGytouYf4tJa3qZxVe67FZdqeYLLhef7sjDooCna10/
         IjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EMph4t9SyrI9bTzUMJDc6xZ7plWzVLao+xDDwxYob5M=;
        b=I0XCq6E8zQOomvxF3pY8IAjPn0yLr093VRx/gQyuPULsJ+Cu+eSTtGwSj9/gS1DlBm
         3OVlpZEaq3LAeiIOvFs8fUGz/DMX42kzBCe+ACKCKIU5qW46Z16B6DaanwyidIkE+/o7
         8HcVPXgV/sZ4307JwD92kXDZaRdajlvCrm8hBNQTJdk5Aksx9ClAi5+B31BvKdjgJFMG
         SjYQv1n7XpgzzxGcJCvm96gou2UqQirOhIcoXjfqY4+4LfrpMLNt6/eAGRRv1sDFPgN6
         uVAlkqM0gN2NJAVun5AvP4Qw6VrfxGalRslj8w9ZE5oDKFYH7mEEag9y2hICE8YRq4lt
         L3lw==
X-Gm-Message-State: AOAM533gOv2y5rtrQ3DsbjyIbusVIi82j+mY7LISXzq9G0IX93FosP7X
        tL3utn2m0rtCAE2Fj8QV8VulWDyJIPs=
X-Google-Smtp-Source: ABdhPJwZxQzr0ayK5d16ooyFj33NjsexkuZxdkYf4+fpKweC8xWZOTnUiEmNGPRnaafN8rgKr4oHyUK1GsA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:ad4:58b0:: with SMTP id ea16mr1098994qvb.45.1619060731436;
 Wed, 21 Apr 2021 20:05:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:05:00 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 10/14] x86: msr: Add builder macros to define
 MSR entries
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add macros to define the MSRs to test, primarily so that the stringified
names can be auto-generated.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 74 ++++++++++++++++---------------------------------------
 1 file changed, 21 insertions(+), 53 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 9031043..4473950 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -7,59 +7,33 @@
 struct msr_info {
 	int index;
 	const char *name;
-	struct tc {
-		int valid;
-		unsigned long long value;
-		unsigned long long expected;
-	} val_pairs[20];
+	unsigned long long value;
 };
 
 
 #define addr_64 0x0000123456789abcULL
 #define addr_ul (unsigned long)addr_64
 
+#define MSR_TEST(msr, val)	\
+	{ .index = msr, .name = #msr, .value = val }
+
 struct msr_info msr_info[] =
 {
-	{ .index = MSR_IA32_SYSENTER_CS, .name = "MSR_IA32_SYSENTER_CS",
-	  .val_pairs = {{ .valid = 1, .value = 0x1234 }}
-	},
-	{ .index = MSR_IA32_SYSENTER_ESP, .name = "MSR_IA32_SYSENTER_ESP",
-	  .val_pairs = {{ .valid = 1, .value = addr_ul }}
-	},
-	{ .index = MSR_IA32_SYSENTER_EIP, .name = "MSR_IA32_SYSENTER_EIP",
-	  .val_pairs = {{ .valid = 1, .value = addr_ul }}
-	},
-	{ .index = MSR_IA32_MISC_ENABLE, .name = "MSR_IA32_MISC_ENABLE",
-	  // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-	  .val_pairs = {{ .valid = 1, .value = 0x400c51889 }}
-	},
-	{ .index = MSR_IA32_CR_PAT, .name = "MSR_IA32_CR_PAT",
-	  .val_pairs = {{ .valid = 1, .value = 0x07070707 }}
-	},
+	MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234),
+	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul),
+	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul),
+	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
+	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889),
+	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707),
 #ifdef __x86_64__
-	{ .index = MSR_FS_BASE, .name = "MSR_FS_BASE",
-	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
-	},
-	{ .index = MSR_GS_BASE, .name = "MSR_GS_BASE",
-	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
-	},
-	{ .index = MSR_KERNEL_GS_BASE, .name = "MSR_KERNEL_GS_BASE",
-	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
-	},
-	{ .index = MSR_EFER, .name = "MSR_EFER",
-	  .val_pairs = {{ .valid = 1, .value = 0xD00 }}
-	},
-	{ .index = MSR_LSTAR, .name = "MSR_LSTAR",
-	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
-	},
-	{ .index = MSR_CSTAR, .name = "MSR_CSTAR",
-	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
-	},
-	{ .index = MSR_SYSCALL_MASK, .name = "MSR_SYSCALL_MASK",
-	  .val_pairs = {{ .valid = 1, .value = 0xffffffff }}
-	},
+	MSR_TEST(MSR_FS_BASE, addr_64),
+	MSR_TEST(MSR_GS_BASE, addr_64),
+	MSR_TEST(MSR_KERNEL_GS_BASE, addr_64),
+	MSR_TEST(MSR_EFER, 0xD00),
+	MSR_TEST(MSR_LSTAR, addr_64),
+	MSR_TEST(MSR_CSTAR, addr_64),
+	MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff),
 #endif
-
 //	MSR_IA32_DEBUGCTLMSR needs svm feature LBRV
 //	MSR_VM_HSAVE_PA only AMD host
 };
@@ -102,16 +76,10 @@ static void test_msr_rw(int msr_index, unsigned long long val)
 
 int main(int ac, char **av)
 {
-	int i, j;
-	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
-		for (j = 0; j < ARRAY_SIZE(msr_info[i].val_pairs); j++) {
-			if (msr_info[i].val_pairs[j].valid) {
-				test_msr_rw(msr_info[i].index, msr_info[i].val_pairs[j].value);
-			} else {
-				break;
-			}
-		}
-	}
+	int i;
+
+	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++)
+		test_msr_rw(msr_info[i].index, msr_info[i].value);
 
 	return report_summary();
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog

