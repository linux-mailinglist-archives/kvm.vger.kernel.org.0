Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EACE72ECF3
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 22:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbjFMUa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 16:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239334AbjFMUau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 16:30:50 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F801BDA
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:30:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-651afaa951fso2945979b3a.3
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686688246; x=1689280246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Zzdys5k5KJj6ZEXXs45R2qHcPA65FOjyHbJm9EXzp+k=;
        b=PryqDWmks+6mZSV+2BVD4P2SSeys4GtwYV5Nul3IEElaQHaf6MlF5Ebz3mJeJ0W2Kx
         iZpOIDa0H13TYxDdWa+hri7CXMpD6WGjE+gDbGMhWCfAogHp84BYcAJ+EyMozC+hoN0R
         DYFnigYazKizwapeNOcfDeRbCjOMJUJsQqGRTrEiOP1avVUcM5aLeLysn0hPIzjk9suz
         xApuvaIRVjTiIT7vPcr25z61lmYuAgT2FwP6RrAt3IsR0yY76EzVweWV7hQ4YKSi+/Fk
         WPY8Rr1J/1G8PiHQvM2xaZyurDRHROv2Uv3s88soz4AER3HHFRXtwOjTAUSbgoJAne3G
         mmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686688246; x=1689280246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zzdys5k5KJj6ZEXXs45R2qHcPA65FOjyHbJm9EXzp+k=;
        b=lF9q9Foh47MSA4k4o1MfqJdzwKAyvXvbIP9fIduMi/49XzliaKDt0YfdSc23O5I+iH
         fcYNkjIDr2986ck6DbD3IdDbaBgcGEOaSKWC8SS77NZ9ISkd/HqCdiUThCnANrTfUyBC
         Q2Q4UGy5J5dDBOeIp9LupstwHh3zIcLw8m/f9ilTw4pTrp4nPB26Qwx6EiIgAHyWVohX
         XBxGf3UdfEiuH+A8d1c2YMqm+8xe96abjwZwWXsLqV/FEk+GnGiT0lLH6xSMwgLveFhQ
         0sxafN2zafmxfP7r44IqUjGcL+1fAGnlsBF4HMurBuelOChOduqZApohVyj6rRoDLHxQ
         bCDQ==
X-Gm-Message-State: AC+VfDyUMXCxLKLmLYN3vXF7CmblWZrcmVlHgB0WCdP9ChoKitAAprn5
        drBZr+sGf5fPv7KTKBD0Q9NGCruD8JQ=
X-Google-Smtp-Source: ACHHUZ4wI76kQYC2NU60zHZkCREsyVDiL5cVBghI/tCti8omxBkAV1Xf67oPmd43BpaLEXA4z2C5stkigAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3a1c:b0:666:43b2:7021 with SMTP id
 fj28-20020a056a003a1c00b0066643b27021mr18956pfb.3.1686688246476; Tue, 13 Jun
 2023 13:30:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jun 2023 13:30:37 -0700
In-Reply-To: <20230613203037.1968489-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230613203037.1968489-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230613203037.1968489-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: selftests: Expand x86's sregs test to cover illegal
 CR0 values
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add coverage to x86's set_sregs_test to verify KVM rejects vendor-agnostic
illegal CR0 values, i.e. CR0 values whose legality doesn't depend on the
current VMX mode.  KVM historically has neglected to reject bad CR0s from
userspace, i.e. would happily accept a completely bogus CR0 via
KVM_SET_SREGS{2}.

Punt VMX specific subtests to future work, as they would require quite a
bit more effort, and KVM gets coverage for CR0 checks in general through
other means, e.g. KVM-Unit-Tests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/set_sregs_test.c     | 70 +++++++++++--------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index a284fcef6ed7..3610981d9162 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -22,26 +22,25 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-static void test_cr4_feature_bit(struct kvm_vcpu *vcpu, struct kvm_sregs *orig,
-				 uint64_t feature_bit)
-{
-	struct kvm_sregs sregs;
-	int rc;
-
-	/* Skip the sub-test, the feature is supported. */
-	if (orig->cr4 & feature_bit)
-		return;
-
-	memcpy(&sregs, orig, sizeof(sregs));
-	sregs.cr4 |= feature_bit;
-
-	rc = _vcpu_sregs_set(vcpu, &sregs);
-	TEST_ASSERT(rc, "KVM allowed unsupported CR4 bit (0x%lx)", feature_bit);
-
-	/* Sanity check that KVM didn't change anything. */
-	vcpu_sregs_get(vcpu, &sregs);
-	TEST_ASSERT(!memcmp(&sregs, orig, sizeof(sregs)), "KVM modified sregs");
-}
+#define TEST_INVALID_CR_BIT(vcpu, cr, orig, bit)				\
+do {										\
+	struct kvm_sregs new;							\
+	int rc;									\
+										\
+	/* Skip the sub-test, the feature/bit is supported. */			\
+	if (orig.cr & bit)							\
+		break;								\
+										\
+	memcpy(&new, &orig, sizeof(sregs));					\
+	new.cr |= bit;								\
+										\
+	rc = _vcpu_sregs_set(vcpu, &new);					\
+	TEST_ASSERT(rc, "KVM allowed invalid " #cr " bit (0x%lx)", bit);	\
+										\
+	/* Sanity check that KVM didn't change anything. */			\
+	vcpu_sregs_get(vcpu, &new);						\
+	TEST_ASSERT(!memcmp(&new, &orig, sizeof(new)), "KVM modified sregs");	\
+} while (0)
 
 static uint64_t calc_supported_cr4_feature_bits(void)
 {
@@ -80,7 +79,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t cr4;
-	int rc;
+	int rc, i;
 
 	/*
 	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
@@ -92,6 +91,7 @@ int main(int argc, char *argv[])
 
 	vcpu_sregs_get(vcpu, &sregs);
 
+	sregs.cr0 = 0;
 	sregs.cr4 |= calc_supported_cr4_feature_bits();
 	cr4 = sregs.cr4;
 
@@ -103,16 +103,24 @@ int main(int argc, char *argv[])
 		    sregs.cr4, cr4);
 
 	/* Verify all unsupported features are rejected by KVM. */
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_UMIP);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_LA57);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_VMXE);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_SMXE);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_FSGSBASE);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_PCIDE);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_OSXSAVE);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_SMEP);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_SMAP);
-	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_PKE);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_UMIP);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_LA57);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_VMXE);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_SMXE);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_FSGSBASE);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_PCIDE);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_OSXSAVE);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_SMEP);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_SMAP);
+	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_PKE);
+
+	for (i = 32; i < 64; i++)
+		TEST_INVALID_CR_BIT(vcpu, cr0, sregs, BIT(i));
+
+	/* NW without CD is illegal, as is PG without PE. */
+	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_NW);
+	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_PG);
+
 	kvm_vm_free(vm);
 
 	/* Create a "real" VM and verify APIC_BASE can be set. */
-- 
2.41.0.162.gfafddb0af9-goog

