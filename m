Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418CD53D443
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349987AbiFDBVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349946AbiFDBVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:11 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC67856753
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:07 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lw3-20020a17090b180300b001e31fad7d5aso8050647pjb.6
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lREshGWquZfBEtYBUkE28FoLZlAZCU5tdVBzH/ZOWRY=;
        b=ftn8Ddo8JpTu6+Gk9x/UhN9nOArl6VdD2w1pzA5HLc3fBiXRouIx9s5El5rqnc+jhu
         cbjfmOScRMZRwlUHlT8Q4H3+QKJD1d9hKxRhP+j7hcYu5k7vRkx1OgM7LiglnLIAQ5Ph
         yzqIzaazMExB4dK2yrCqabLaI1J4HNnrdJ6gLGJ59vYwyClkn9VFZ2vsheeJn6JvC2dO
         D5hTRFbDZ4PXuSe6ofCKkDhHSEj+zDP/hHzpxsC66Tpy+lfFFHivHQeE/kbE/ppQbwCh
         EnSBmLeoZ0kln+RgNm4vPAXzQJYc+qKpNoY8YZ0ts+8dwFreNa1V4W2oCoToykEWhDe2
         O3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lREshGWquZfBEtYBUkE28FoLZlAZCU5tdVBzH/ZOWRY=;
        b=zFtLknZmMUQURYL9UA7o75CVaNOepHmdUBH2JhGUn07eIVIGuKjM07FdHVd1lXQxPj
         6yClzrYihfBdooafcOoPeaxDDM6Iv3uPQv96xcQnO5s0mPkII7xflov8OALxYTgwp5Qk
         ekFyvK05xrr05NQyFih1hUQRZVrlFKdNdULIl+ALArDKVCh0iEOTuTnzvB7Ap/UJUpRO
         72x+oKDmSRnwquPY7kvsqUpSh/mVloApgYpCI4EJbCBRMgwLGRoeFwQQPT8CD+gA4e3T
         IhXipPKDlfLWKVDyTbJaMojdNvRp6xjvBs/mA/0f7RN/6qPDH0qwTab8k+ZQCjQNuhK/
         0/vw==
X-Gm-Message-State: AOAM533qmip/SQS53VYOr7nSh3RXRPeEUD1gDOkRRBkESPok+R2NgtOJ
        de5M49CThbzwwFV1FHID63cPgH7Na6w=
X-Google-Smtp-Source: ABdhPJyhYgCAxSQU/gKQDofAmbxl4N3GVumvmrnJPX0i/eqa2iLFdtnAVR6GQEK6d4qDudAHSQ9QfHGOaAs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1901:b0:518:916e:4a85 with SMTP id
 y1-20020a056a00190100b00518916e4a85mr12703010pfi.65.1654305667281; Fri, 03
 Jun 2022 18:21:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:20 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 04/42] KVM: selftests: Use kvm_cpu_has() in the SEV migration test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_cpu_has() in the SEV migration test instead of open coding
equivalent functionality using kvm_get_supported_cpuid_entry().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h        |  2 ++
 .../selftests/kvm/x86_64/sev_migrate_tests.c        | 13 ++-----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 59ae869814b7..24ffa7c238ff 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -127,6 +127,8 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_PAUSEFILTER         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
 #define X86_FEATURE_PFTHRESHOLD         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
 #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
+#define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
+#define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
 
 /* CPUID.1.ECX */
 #define CPUID_VMX		(1ul << 5)
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 76ba6fc80e37..56a5932165ce 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -393,23 +393,14 @@ static void test_sev_move_copy(void)
 	kvm_vm_free(sev_vm);
 }
 
-#define X86_FEATURE_SEV (1 << 1)
-#define X86_FEATURE_SEV_ES (1 << 3)
-
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *cpuid;
-
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM));
 
-	cpuid = kvm_get_supported_cpuid_entry(0x80000000);
-	TEST_REQUIRE(cpuid->eax >= 0x8000001f);
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
 
-	cpuid = kvm_get_supported_cpuid_entry(0x8000001f);
-	TEST_REQUIRE(cpuid->eax & X86_FEATURE_SEV);
-
-	have_sev_es = !!(cpuid->eax & X86_FEATURE_SEV_ES);
+	have_sev_es = kvm_cpu_has(X86_FEATURE_SEV_ES);
 
 	if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
 		test_sev_migrate_from(/* es= */ false);
-- 
2.36.1.255.ge46751e96f-goog

