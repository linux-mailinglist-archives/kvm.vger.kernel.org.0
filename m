Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8284C53C2C1
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbiFCAuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240445AbiFCArP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D070037A92
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so5600569ybp.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gw9bm2rKSvX9BYr6V51bZUm+zZe+4ZNQvzUvW3D6+Yk=;
        b=MxGXGVFEYRhWN5azl/fmvEy7jUuUFja+3FDOp5yrd2n+Uer8FJ6HKRIMhOWcCFdWyN
         aaYUt4Cr+BQYPy62H1Buc1rGU+KCIoBifhJ6azJmXhYVX53EMgcUtBdBa04o32kxhPpe
         5wZRquSOfmfF07r1LvSGcDTl3pi0K3/FsBI3HXDq0UO+TuTrmEH+L5uEE1Nzyir5oAn5
         qNqzN3W30pa2lpUhqMX+ObHmbEZ7+8NoCECnWXWt/eVSFLhM88Q1LvEgMLJXRhkacStW
         Dl4IjxxWdfGyH45d1ZL7ynriQu2EZ1mlM3aFz98HpHEjIdS10IC3Ue/B/GqAsP2v827L
         fQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gw9bm2rKSvX9BYr6V51bZUm+zZe+4ZNQvzUvW3D6+Yk=;
        b=q67QYS5Lb/fan++HPT0e9SIYXUI3Osyi/TlDqdDRH2UgpstFRi67t43D+zL3SUd5+n
         0TP/5llMwVW0Jh6PFcqHyzecYRw3BJZ0jCfQYlNXsJi9DhNaYybmmyB0JGCRpjxgzKlb
         tbUSUz6RmZY95a2LN+v2q/WSXCkz1DnovtKvPDB21wRzvSlw32Nrl37lavVfyxUzyx+Z
         efUqmxwQgDFiu3gMGtmZwmQ+wejH9iy9SAOcfK8rf4Bct3H4Jee0zJi6aZDB6pVwBcPA
         KuHkGyfm8e9b3/2jL1NtwA6dkotSNwrTDt2z2Bz9BFNjtSO9w+6KjMwXOs10CUyOOEH9
         AoVw==
X-Gm-Message-State: AOAM533rJdVob6MnVMakb5JDlYbH2pWRfFDNe0PtdAMjfgrf+dvdg68N
        n74SWmJpnvx1XFNPDAC3Q3g/oPaetPg=
X-Google-Smtp-Source: ABdhPJw52BMApMyNQo1WvYxD9eLl49NnS31Jd30HtVB+5ClClQ1c4EMYtaGBVGZlX18i0rCPSu5poyVEbmM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:9081:0:b0:64d:d424:a811 with SMTP id
 t1-20020a259081000000b0064dd424a811mr8180425ybl.298.1654217169512; Thu, 02
 Jun 2022 17:46:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:31 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-85-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 084/144] KVM: selftests: Convert cr4_cpuid_sync_test away
 from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Convert cr4_cpuid_sync_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note,
this is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing non-zero
vCPU IDs is desirable for generic tests, that can be done in the future by
tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c  | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 6f6fd189dda3..d5615cd0b81b 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -21,7 +21,6 @@
 
 #define X86_FEATURE_XSAVE	(1<<26)
 #define X86_FEATURE_OSXSAVE	(1<<27)
-#define VCPU_ID			1
 
 static inline bool cr4_cpuid_is_sync(void)
 {
@@ -63,12 +62,12 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct kvm_sregs sregs;
 	struct kvm_cpuid_entry2 *entry;
 	struct ucall uc;
-	int rc;
 
 	entry = kvm_get_supported_cpuid_entry(1);
 	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
@@ -79,25 +78,23 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
 	while (1) {
-		rc = _vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
-		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Unexpected exit reason: %u (%s),\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			/* emulate hypervisor clearing CR4.OSXSAVE */
-			vcpu_sregs_get(vm, VCPU_ID, &sregs);
+			vcpu_sregs_get(vm, vcpu->id, &sregs);
 			sregs.cr4 &= ~X86_CR4_OSXSAVE;
-			vcpu_sregs_set(vm, VCPU_ID, &sregs);
+			vcpu_sregs_set(vm, vcpu->id, &sregs);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("Guest CR4 bit (OSXSAVE) unsynchronized with CPUID bit.");
-- 
2.36.1.255.ge46751e96f-goog

