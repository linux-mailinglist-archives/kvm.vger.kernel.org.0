Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A650F53C21A
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbiFCA5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240783AbiFCAuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCD9252BD
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h13-20020a170902f70d00b0015f4cc5d19aso3466405plo.18
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=K/GapKt00lK/b4VH6VZbwUeiACCV/Jp25wTU5LlSjEo=;
        b=X2IXT0RmsF0zY/r3+rcg0G7C0hrE6iS6V7KKD9p/Np9QtCskPO4GV3cO12gYN9WkuQ
         NmrQkBRkm0xx/qNrO+qcpzNeA3OWYrg4Wdf2MOUFsqs6NABGXuoYzjQ9LbTkx1Cz0nw/
         tDFNbiEEiAgSx9ThpMfoOAjWs1dLWr8MAymUezFgk/+tw2hG83Eu85WG5ozbm/ibnvpo
         XRVvbALpSWY9OXefaPMAzOuehDGC3S0BQGbDhXw0vBxzaN33WJfDfxE345WhdQTz+p61
         8SUjfqRjN2lBSGP4ijOgwaR95ECZJcwb9SYgp71aVhFNvbZXcdbC44OEfNM3Gakd4TZZ
         a+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=K/GapKt00lK/b4VH6VZbwUeiACCV/Jp25wTU5LlSjEo=;
        b=nG7h2iB7s3akftcSmFfWwwBr/ycw0TGzrAScOKgUxyBRiG3E9G8oSH+WSJj/xaDXbL
         L03lvd0R6viOQeav6Mozuj5H8QNXBUSVutIcQ09evmybzoRpoPyfsd8fXWVNFJd9cNRP
         Q22GjEQR8OFKHTsDDBkYBMVtSOhHvJM40mv93rJEU4eW1fYlEUoc/+Q7cKkcJOhab56T
         U5jiNeYQLQHw2RwlyvVP4dJYgeWfIJ7IjzQ7wvxVtxzR7CpPrwM4JyXGxnw/sYqFRdOL
         o7KndXLIy/Zl17wCPHqwoeIW2x5Ek6759OpYGL5YjbvRSmNs0sJoalPJNdsKBydj0lTh
         9Xag==
X-Gm-Message-State: AOAM531jU3DMvpsOeOCJ3d9qRsQNb8o1SUfrSt+fVqhzcXpP/ucB4ZW+
        eTimY7rZxqkqX3YCMKRBBjrhGgcw3bE=
X-Google-Smtp-Source: ABdhPJz0oMbc6PF/cdXfz2aYoOC70tde2qgRd6ZW7Z+zU99O3rq6X7xmmqJ8NqW4An1irf8rGoJk5djhIqU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a4a:b0:518:bbd5:3c1d with SMTP id
 h10-20020a056a001a4a00b00518bbd53c1dmr7756741pfv.64.1654217233017; Thu, 02
 Jun 2022 17:47:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:07 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-121-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 120/144] KVM: selftests: Convert tprot away from VCPU_ID
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

Convert tprot to use vm_create_with_vcpus() and pass around a
'struct kvm_vcpu' object instead of passing around vCPU IDs.  Note, this is
a "functional" change in the sense that the test now creates a vCPU with
vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100% arbitrary
and added little to no validation coverage.  If testing non-zero vCPU IDs
is desirable for generic tests, that can be done in the future by tweaking
the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/s390x/tprot.c | 25 +++++++++++------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
index c097b9db495e..4caa77388033 100644
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -14,8 +14,6 @@
 #define CR0_FETCH_PROTECTION_OVERRIDE	(1UL << (63 - 38))
 #define CR0_STORAGE_PROTECTION_OVERRIDE	(1UL << (63 - 39))
 
-#define VCPU_ID 1
-
 static __aligned(PAGE_SIZE) uint8_t pages[2][PAGE_SIZE];
 static uint8_t *const page_store_prot = pages[0];
 static uint8_t *const page_fetch_prot = pages[1];
@@ -182,14 +180,14 @@ static void guest_code(void)
 	GUEST_SYNC(perform_next_stage(&i, mapped_0));
 }
 
-#define HOST_SYNC(vmp, stage)							\
+#define HOST_SYNC(vcpup, stage)							\
 ({										\
-	struct kvm_vm *__vm = (vmp);						\
+	struct kvm_vcpu *__vcpu = (vcpup);					\
 	struct ucall uc;							\
 	int __stage = (stage);							\
 										\
-	vcpu_run(__vm, VCPU_ID);						\
-	get_ucall(__vm, VCPU_ID, &uc);						\
+	vcpu_run(__vcpu->vm, __vcpu->id);					\
+	get_ucall(__vcpu->vm, __vcpu->id, &uc);					\
 	if (uc.cmd == UCALL_ABORT) {						\
 		TEST_FAIL("line %lu: %s, hints: %lu, %lu", uc.args[1],		\
 			  (const char *)uc.args[0], uc.args[2], uc.args[3]);	\
@@ -200,28 +198,29 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	vm_vaddr_t guest_0_page;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
-	HOST_SYNC(vm, STAGE_INIT_SIMPLE);
+	HOST_SYNC(vcpu, STAGE_INIT_SIMPLE);
 	mprotect(addr_gva2hva(vm, (vm_vaddr_t)pages), PAGE_SIZE * 2, PROT_READ);
-	HOST_SYNC(vm, TEST_SIMPLE);
+	HOST_SYNC(vcpu, TEST_SIMPLE);
 
 	guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
 	if (guest_0_page != 0)
 		print_skip("Did not allocate page at 0 for fetch protection override tests");
-	HOST_SYNC(vm, STAGE_INIT_FETCH_PROT_OVERRIDE);
+	HOST_SYNC(vcpu, STAGE_INIT_FETCH_PROT_OVERRIDE);
 	if (guest_0_page == 0)
 		mprotect(addr_gva2hva(vm, (vm_vaddr_t)0), PAGE_SIZE, PROT_READ);
 	run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
 	run->kvm_dirty_regs = KVM_SYNC_CRS;
-	HOST_SYNC(vm, TEST_FETCH_PROT_OVERRIDE);
+	HOST_SYNC(vcpu, TEST_FETCH_PROT_OVERRIDE);
 
 	run->s.regs.crs[0] |= CR0_STORAGE_PROTECTION_OVERRIDE;
 	run->kvm_dirty_regs = KVM_SYNC_CRS;
-	HOST_SYNC(vm, TEST_STORAGE_PROT_OVERRIDE);
+	HOST_SYNC(vcpu, TEST_STORAGE_PROT_OVERRIDE);
 }
-- 
2.36.1.255.ge46751e96f-goog

