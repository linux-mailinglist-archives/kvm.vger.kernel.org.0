Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B14E51B357
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353325AbiEDW41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379585AbiEDWy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC2354682
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:15 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso1080008pjd.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l7RgxgcK25oFGZcZ40Qv2L/Egvma3T9JIfWOW4W25YI=;
        b=rvNJETqAvCr/W6REjHrnOcHJA0PIx/dBkgIKqtND9WeyY2wzNBFpS0RkwCm6Q1WxMP
         69LYkKPydVsVb9dDSkORXNW/4ZtRl9xlNB0HiTl+HJ48QHJP/eYEX9F36dopMl1TJvjc
         VAwcTSC6eQ2iXk3JzJaNxU4Ia5QfybfsObsAnvk30cFrFx0401uRFeM7S4342ddTNfpe
         AKFVdMB2JNJNC0ispzq1thswx7uohAe4s69+lfykjDyhhycs9aqhhbrxeEKQFUyKLuCR
         ZdVlVltRyopoOVq5E1EvzPu93JCG1HR3CG0ZJKqRPojZhgFq/4sfGnd7xdElyPxiiMtO
         Q0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l7RgxgcK25oFGZcZ40Qv2L/Egvma3T9JIfWOW4W25YI=;
        b=rUAmMoAG03KtNeFHodC1XNFzdFapIBe1F0iP8tSLzn+sQB5ROhZmbtlmUs+cfFyaXW
         JSXNOeb9wo8eayfnk0ebNbBWNRtvjDh+HwhJiRKVYjV8T0QRNBqqruUMQvokmiEh3xrL
         tOmLR0O9g8pmWM96OIKSyiS3Fgh+N19k2lCP0r01TtZSLXqgOx+OyO+dRIud6ioIns/Q
         Ak+flj1cImRh/CbnwWIEyXvbhMB7n0WkID2eA4F5mHk79wclUGk7yDT+jA7BNHtlro41
         Jf/1lQgVs3VKuzXcztuL3YDquJi8XbZ6WtE9hFN/lslyl1cF6YPO3LC1yrkbCb1F9dF2
         v9UA==
X-Gm-Message-State: AOAM532BqKpLfLOXJYt/OYhG1Vw4GPX+0C8eImFWzU+v8OEDv6XLMQls
        l2fVbbLuonvybcgxt7F5kDHwM7s32RM=
X-Google-Smtp-Source: ABdhPJzAzczJf3PuYGvXg6q7ed5A7KZ4mIFwaUf4tasOkcS+rW9K3tQI8j/lhHCJAbyo4cMxOqOv1wX3Ei4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:38d2:b0:1dc:9636:ad29 with SMTP id
 nn18-20020a17090b38d200b001dc9636ad29mr2194907pjb.193.1651704674553; Wed, 04
 May 2022 15:51:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:06 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-61-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 060/128] KVM: selftests: Convert set_sregs_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Convert set_sregs_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/set_sregs_test.c     | 45 +++++++++----------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index f5e65db9f451..8a5c1f76287c 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -22,9 +22,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID                  5
-
-static void test_cr4_feature_bit(struct kvm_vm *vm, struct kvm_sregs *orig,
+static void test_cr4_feature_bit(struct kvm_vcpu *vcpu, struct kvm_sregs *orig,
 				 uint64_t feature_bit)
 {
 	struct kvm_sregs sregs;
@@ -37,11 +35,11 @@ static void test_cr4_feature_bit(struct kvm_vm *vm, struct kvm_sregs *orig,
 	memcpy(&sregs, orig, sizeof(sregs));
 	sregs.cr4 |= feature_bit;
 
-	rc = _vcpu_sregs_set(vm, VCPU_ID, &sregs);
+	rc = _vcpu_sregs_set(vcpu->vm, vcpu->id, &sregs);
 	TEST_ASSERT(rc, "KVM allowed unsupported CR4 bit (0x%lx)", feature_bit);
 
 	/* Sanity check that KVM didn't change anything. */
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vcpu->vm, vcpu->id, &sregs);
 	TEST_ASSERT(!memcmp(&sregs, orig, sizeof(sregs)), "KVM modified sregs");
 }
 
@@ -83,6 +81,7 @@ static uint64_t calc_cr4_feature_bits(struct kvm_vm *vm)
 int main(int argc, char *argv[])
 {
 	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t cr4;
 	int rc;
@@ -96,43 +95,43 @@ int main(int argc, char *argv[])
 	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
 	 */
 	vm = vm_create_barebones();
-	vm_vcpu_add(vm, VCPU_ID);
+	vcpu = vm_vcpu_add(vm, 0);
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 
 	sregs.cr4 |= calc_cr4_feature_bits(vm);
 	cr4 = sregs.cr4;
 
-	rc = _vcpu_sregs_set(vm, VCPU_ID, &sregs);
+	rc = _vcpu_sregs_set(vm, vcpu->id, &sregs);
 	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
 		    sregs.cr4, cr4);
 
 	/* Verify all unsupported features are rejected by KVM. */
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_UMIP);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_LA57);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_VMXE);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_SMXE);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_FSGSBASE);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_PCIDE);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_OSXSAVE);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_SMEP);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_SMAP);
-	test_cr4_feature_bit(vm, &sregs, X86_CR4_PKE);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_UMIP);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_LA57);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_VMXE);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_SMXE);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_FSGSBASE);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_PCIDE);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_OSXSAVE);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_SMEP);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_SMAP);
+	test_cr4_feature_bit(vcpu, &sregs, X86_CR4_PKE);
 	kvm_vm_free(vm);
 
 	/* Create a "real" VM and verify APIC_BASE can be set. */
-	vm = vm_create_default(VCPU_ID, 0, NULL);
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 	sregs.apic_base = 1 << 10;
-	rc = _vcpu_sregs_set(vm, VCPU_ID, &sregs);
+	rc = _vcpu_sregs_set(vm, vcpu->id, &sregs);
 	TEST_ASSERT(rc, "Set IA32_APIC_BASE to %llx (invalid)",
 		    sregs.apic_base);
 	sregs.apic_base = 1 << 11;
-	rc = _vcpu_sregs_set(vm, VCPU_ID, &sregs);
+	rc = _vcpu_sregs_set(vm, vcpu->id, &sregs);
 	TEST_ASSERT(!rc, "Couldn't set IA32_APIC_BASE to %llx (valid)",
 		    sregs.apic_base);
 
-- 
2.36.0.464.gb9c8b46e94-goog

