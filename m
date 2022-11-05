Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CFF61A79F
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 05:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKEE5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 00:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKEE5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 00:57:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF2B32BBF
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 21:57:17 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r10-20020a17090a1bca00b002137a500398so3110490pjr.5
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 21:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gZsOXIQ/ETlFCBETTe/elKVE4lpjamgAUlI2bZ+SvJc=;
        b=jB5l9Hayd7t9U2kjL83ltyjH3Fv+WtodRQcAlUj5Es6ZLiwVw+6vA0eIgG4QChDpWm
         qp97gIUIxTuhE8CWduUzsHWOHOaOc0cDlf58T7tROsRAsdnWkInlARWh8Q7AI3SF+UOf
         XIDyiMmkY9dKUGQuS0BWS6DlZ6s2LhcRrdf3AxedTUAp9uyDF8HyV7cPWu76Tc62OWgE
         +r333jvm8DKwfwdSxuekRtSS1+lkpnMhLgp9Re9QXOozWKUs8BUraLGvXaClX120fr+w
         iJm8sdJwJif+9C4KMMhykA94EhrQ4CEwxShXIwEqo6OQdiOR62eTPe43L1+UURPdKGE8
         lhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gZsOXIQ/ETlFCBETTe/elKVE4lpjamgAUlI2bZ+SvJc=;
        b=pWxiYu6edgFhE53BEWUsf/zc21hUQaTxRylI6mcAQp2vcSf8fUBzZU1JcNIsDKrxZX
         KlErpctB9fy/2EbgixYkJSZgOOR4uBEwo2qeGsB89W5H8CKJUYIW5318NejbKuKqu35v
         KvGWCCaDYcsohh6bwHwqegSTIZS8APvJ/SupU2SJQwK6inV4NNaL9SHLUUI1mOFCjF5/
         0VJx/nCENHEVT4oiurrHoF+aDP/dIAre4lHiY+tg7dTCXE8y1NT86k1zWwX9uo48Vz9T
         PlsTcqrpSXXL180eZU7n9qwsSqW2Gz1fJcJ2nrBDoYVcMoUqBOgMlfLKmeDdWuPB5M6R
         REPw==
X-Gm-Message-State: ACrzQf3puKKejofaIfW9YmZd1vGeIbw8RHaZtSqnFCTpZJtf1lNoPTSU
        tqTOKl7e1Mf/xgWN43N0OzenhigTOLH6
X-Google-Smtp-Source: AMsMyM6GW/7X0x4391P7gdBKlTG0oU4AiAlfthpj/AvnhYObrCwIFZxCcrHcQ/ggbAshvUS6jsR/1GvPBvbd
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:218a:b0:56d:1bb6:af4f with SMTP
 id h10-20020a056a00218a00b0056d1bb6af4fmr36690480pfi.11.1667624236628; Fri,
 04 Nov 2022 21:57:16 -0700 (PDT)
Date:   Fri,  4 Nov 2022 21:57:02 -0700
In-Reply-To: <20221105045704.2315186-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221105045704.2315186-5-vipinsh@google.com>
Subject: [PATCH 4/6] KVM: selftests: Make Hyper-V guest OS ID common
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make guest OS ID calculation common to all hyperv tests and similar to
hv_generate_guest_id().

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 10 ++++++++++
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c    |  2 +-
 tools/testing/selftests/kvm/x86_64/hyperv_features.c |  6 ++----
 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c |  2 +-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index 075fd29071a6..9d8c325af1d9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -9,6 +9,10 @@
 #ifndef SELFTEST_KVM_HYPERV_H
 #define SELFTEST_KVM_HYPERV_H
 
+#include <linux/version.h>
+
+#define HV_LINUX_VENDOR_ID			0x8100
+
 #define HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS	0x40000000
 #define HYPERV_CPUID_INTERFACE			0x40000001
 #define HYPERV_CPUID_VERSION			0x40000002
@@ -189,4 +193,10 @@
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
 
+static inline uint64_t hv_linux_guest_id(void)
+{
+	return ((uint64_t)HV_LINUX_VENDOR_ID << 48) |
+	       ((uint64_t)LINUX_VERSION_CODE << 16);
+}
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index d576bc8ce823..f9112c5dc3f7 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -104,7 +104,7 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
 
 	/* Set Guest OS id to enable Hyper-V emulation */
 	GUEST_SYNC(1);
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
 	GUEST_SYNC(2);
 
 	check_tsc_msr_rdtsc();
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 6b443ce456b6..b5a42cf1ad9d 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -13,8 +13,6 @@
 #include "processor.h"
 #include "hyperv.h"
 
-#define LINUX_OS_ID ((u64)0x8100 << 48)
-
 static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 				vm_vaddr_t output_address, uint64_t *hv_status)
 {
@@ -71,7 +69,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 
 	GUEST_ASSERT(hcall->control);
 
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 
 	if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
@@ -169,7 +167,7 @@ static void guest_test_msrs_access(void)
 			 */
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
 			msr->write = 1;
-			msr->write_val = LINUX_OS_ID;
+			msr->write_val = hv_linux_guest_id();
 			msr->available = 1;
 			break;
 		case 3:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index a380ad7bb9b3..2c13a144b04c 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -69,7 +69,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 
 	GUEST_SYNC(1);
 
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
 
 	GUEST_ASSERT(svm->vmcb_gpa);
 	/* Prepare for L2 execution. */
-- 
2.38.1.273.g43a17bfeac-goog

