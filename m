Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE9753D46A
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350137AbiFDBWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350125AbiFDBWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:18 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CC859300
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:42 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x11-20020aa79acb000000b0051b9d3136fdso4726973pfp.1
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BQRfL0mcKRLOvZlHcCsiY1NJyzCw53bZY+TKm1ziE0s=;
        b=tjVtRaKDo0BEgyFGm+IZYnF4c+4jP1xVcbJ66WWUeZGoc5NuSTaNvgexhmX5pWbEWW
         Zf3PJ/De7Xj/BnPZz/U6Q3Q1SGT/IgQsKRa8YQEpIzhJ1oZGhXyBj6y9Mzl6Za6/fRC+
         R5X/zzAUTS+T52MKM3U2hkVGNrcUwkKv/2sTmc4Lw0pmNqro/lJ8uQ6c5T+G07geNRky
         NN6Yssh/O52Gob70HgpjB+Ox67/pvFI9+wY7WkZjXpV4dfZlHx1DIqqH41nVtOHrWJF9
         xiIsXfEwtYhuRpnttanw7QCqcrkFldug2Y4v+aImITbur4H7BNnNIvnpdxtr6fWXI7oD
         rfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BQRfL0mcKRLOvZlHcCsiY1NJyzCw53bZY+TKm1ziE0s=;
        b=WUIS/4CXHn66iZH7d2ObydpwC2wZUyo/TNG/yRKeWIlIX8uTjUKds4w8XyYZnR7A67
         ffdzFAUkSaoLrLuSLEefb11rEQinLYHppLnE9gsUpHHGKfDtj9XypmZ3Bg4tL82u0Vnk
         NVasgHt7ERiruovUX4i1ZGahhWYygpur/bfdvkW/uxxeT3dEDn4Zv4KO0Ia5mkP3FnEv
         yvdDTl7WKb+CoGVq++gy6JzbsCjET2/w9NRIX4Qb9JBeSfz1gC+7kXSCL75hvcH02w1w
         6zibw9IxGmspSPNVfUZ976nkIqOyvUBj0fHYoHUrW7aO5VhXDlpiBSFu6JJkLZc5xMRq
         JXtA==
X-Gm-Message-State: AOAM530yTbVxvFiMctf0wkk2Vh3jbSzcmBWF5D1bakMQJgnqfFFc5EPx
        jXZOYRIhBCJHyWoZ+ZiQfQHsmmGYB0U=
X-Google-Smtp-Source: ABdhPJz36R8MRDTsFSI4sOua56XcUrbw7Bk751Wtkbo+spsn+gfYei04OSuvnUr1yLvEPaN6mdbD3T3wciM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e788:b0:163:73fc:5140 with SMTP id
 cp8-20020a170902e78800b0016373fc5140mr12462386plb.88.1654305702378; Fri, 03
 Jun 2022 18:21:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:40 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-25-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 24/42] KVM: selftests: Add and use helper to set vCPU's CPUID maxphyaddr
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

Add a helper to set a vCPU's guest.MAXPHYADDR, and use it in the test
that verifies the emulator returns an error on an unknown instruction
when KVM emulates in response to an EPT violation with a GPA that is
legal in hardware but illegal with respect to the guest's MAXPHYADDR.

Add a helper even though there's only a single user at this time.  Before
its removal, mmu_role_test also stuffed guest.MAXPHYADDR, and the helper
provides a small amount of clarity.

More importantly, this eliminates a set_cpuid() user and an instance of
modifying kvm_get_supported_cpuid()'s static "cpuid".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c     |  8 ++++++++
 .../testing/selftests/kvm/x86_64/emulator_error_test.c | 10 +---------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 61b8047243e0..d6ffd625513b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -656,6 +656,8 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
+void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
+
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 				     struct kvm_x86_cpu_feature feature,
 				     bool set);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5383ccdeb8e2..06ae7542f2c9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -763,6 +763,14 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 	vcpu_set_cpuid(vcpu);
 }
 
+void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr)
+{
+	struct kvm_cpuid_entry2 *entry = vcpu_get_cpuid_entry(vcpu, 0x80000008);
+
+	entry->eax = (entry->eax & ~0xff) | maxphyaddr;
+	vcpu_set_cpuid(vcpu);
+}
+
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 				     struct kvm_x86_cpu_feature feature,
 				     bool set)
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index bb410c359599..9d08ccdf6604 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -151,8 +151,6 @@ static uint64_t process_ucall(struct kvm_vcpu *vcpu)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *entry;
-	struct kvm_cpuid2 *cpuid;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t gpa, pte;
@@ -166,13 +164,7 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	cpuid = kvm_get_supported_cpuid();
-
-	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
-	entry->eax = (entry->eax & 0xffffff00) | MAXPHYADDR;
-	set_cpuid(cpuid, entry);
-
-	vcpu_init_cpuid(vcpu, cpuid);
+	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
 
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
-- 
2.36.1.255.ge46751e96f-goog

