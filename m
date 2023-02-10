Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BB969159E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBJAeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjBJAda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:33:30 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80C860331
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:41 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id v23-20020aa78097000000b005748c087db1so1770355pff.2
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T/UerwQEfGQ6ukyZTZGTyb45H/ylk3/l1LtZ4//l0d4=;
        b=rplEd0JY5QtWrqEvlJVu1JobeJWDbvpgObNM1O1mRNIK1hMyw8fLr0S5jWfjz8m4N1
         NBLYL1+OCDE/E6PftHc5JRK2NOqyekYjPhonKL2CQdBfD+amuWo5T6MnQSCBHh7elFcV
         /c67IKrupSWuqUqhOrndgPZBl8NRN1KHb9pOYZfJrqtH57Gn6+ZF/f0h1WmJbdREzQEB
         33L3Z8w4OVTVHVzsmFqwLQBuSEr1HL/VHpd04qn1S7DWJs4LqLpAddtAh4ZeBxVf3Akg
         tIiJLoYv4p8WHaq8+JL5ndl+QFh6eIncRLr01uGRzXV9fBHNklO1Ny8t7DILVUnyVOJ8
         ycrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/UerwQEfGQ6ukyZTZGTyb45H/ylk3/l1LtZ4//l0d4=;
        b=6Q5qH/AUM00MaBZQ1ytVI1ze0Uc1gyoZSvzceAjOsxemq9fbKd/h/kE0H+uOAUq680
         mUqH/pU7YkHgncY+ZPuKH4CX6+Y9VKgI5s67IkorQaLzRUpINc9a5bzrlG4sCMvX0Pst
         Un20a+pdwX5cacR1zBHydJvyxMvut5dFQFIALMk0T4sZHfSIluzPzQGQSetwGEjgweUX
         BPEDRVaJWcFSgPJkHZmucx/SPH4UTAJCoK5i+yZY8iXgGAXZO5gm15s3z1pPtpC/ERgM
         70o3MGkLQrvtNi2NDNjrL5Rg7cn6lCGtfm6gFJoOSauW5vVbfm/YOWCKJk1KHKJy93mf
         YP4w==
X-Gm-Message-State: AO0yUKVSNIOJsZM2/MFJ0ujiiXr06OnzRpnzHR+0hH01ipbBEIo1MqTI
        nHH5F9kMgF/2ErQcKNLu/6RLlYZ4yb8=
X-Google-Smtp-Source: AK7set/hIh5XI11TrLn8niHD6cLvpVN7xNs2K6AXFlFsylpTDyIq09h5jMw/u2D4zr57xsRoDgQFWhl8nuM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d716:b0:230:ee6f:28bc with SMTP id
 y22-20020a17090ad71600b00230ee6f28bcmr11586pju.1.1675989142716; Thu, 09 Feb
 2023 16:32:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:46 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-20-seanjc@google.com>
Subject: [PATCH v2 19/21] KVM: selftests: Refactor LBR_FMT test to avoid use
 of separate macro
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Rework the LBR format test to use the bitfield instead of a separate
mask macro, mainly so that adding a nearly-identical PEBS format test
doesn't have to copy-paste-tweak the macro too.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c        | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 6733d879a00b..38aec88d733b 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -19,8 +19,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define PMU_CAP_LBR_FMT		0x3f
-
 union perf_capabilities {
 	struct {
 		u64	lbr_format:6;
@@ -169,7 +167,7 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
-	uint64_t val;
+	union perf_capabilities val = host_cap;
 	int r, bit;
 
 	for_each_set_bit(bit, &reserved_caps, 64) {
@@ -184,12 +182,13 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
 	 * KVM only supports the host's native LBR format, as well as '0' (to
 	 * disable LBR support).  Verify KVM rejects all other LBR formats.
 	 */
-	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
-		if (val == (host_cap.capabilities & PMU_CAP_LBR_FMT))
+	for (val.lbr_format = 1; val.lbr_format; val.lbr_format++) {
+		if (val.lbr_format == host_cap.lbr_format)
 			continue;
 
-		r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
-		TEST_ASSERT(!r, "Bad LBR FMT = 0x%lx didn't fail", val);
+		r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val.capabilities);
+		TEST_ASSERT(!r, "Bad LBR FMT = 0x%x didn't fail, host = 0x%x",
+			    val.lbr_format, host_cap.lbr_format);
 	}
 
 	kvm_vm_free(vm);
-- 
2.39.1.581.gbfd45094c4-goog

