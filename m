Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4051B36A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352023AbiEDXEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380269AbiEDW7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:53 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629AA56F9A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:07 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id f7-20020a6547c7000000b003c600995546so782858pgs.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5DAJlGNKe8aX3EmZHon3SRjMD9ccYXNvX9H64hVT1+A=;
        b=Hki4o5RLSB468iQLRnZhCPLw3xUA6dR+tqQVMGQ6ypwvf23CSxeip172ChxT/i/8Bq
         TqJIOFJERX1LDyvx4aytdMe3PfI8OItrhsFwK7SSjoR4Nx8sTndPHqvvnUE3+n7kGJ8z
         cZFFEgBH6HB5idGJT9aa28lcBArxAOnn2BzrFUP5QFbTe5MlVuLNOxqkSJwb2b23UUjr
         +Z9sMbMboDUDZBptZf0LCIZPJC43jgzCI8l9jx4EwA+KAVjmUivvoDcKqThp+jDgY8yk
         oivXUMvjFmUTKb5a1Uh4mzvdVXMTZ7d1nfkDHk3gO0N8YB/+ToA9H6R1KQ2+TuiHDIqK
         9ZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5DAJlGNKe8aX3EmZHon3SRjMD9ccYXNvX9H64hVT1+A=;
        b=nMti2F2jMGnQQXQg7crRbKSeRjW68h5fxlUyCNASHNmNJbfDWTkxuH5mHmwOS8zrdR
         JWEOqVr+5R8/Lc68axVlmto4bvV0INQOeN35RjZiFDZWgCoDl7mKL0/PZ2bHx1+kuO1+
         KCY6fxTcQTW83Azyejl0BAFOsFCbVIlh5ZwIzELOlJAwW83UauXNZTaxnjza9Fk9UPl4
         iLDww10z/EKhKgZxkpap+AL/y74TIQmxQ1zqGDK6ZsNUx137BP5I3BRKkxuzoiGmpcpZ
         B/LL3TpewlD8Cwtzz6caYwRtAk+n1amM1Dianlo5zBghTGPlx1w2IHKjdzzRG+15lSGN
         HPXQ==
X-Gm-Message-State: AOAM533jErxE3jfc0AqDMZmrLNlqWm7JEmtBnZOn22txKse6U8kuB6w4
        6XhcM3CpBOQDxS+frVQc3sm3IHtqiFk=
X-Google-Smtp-Source: ABdhPJyzfctc2eyR5HnXUMoP63671DjI9Rgwc3rmUeZUs2u9V++XpkQ3kve8+q3f5fZc1hZakHSoPzkEnkU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3ecd:b0:1dc:945e:41b1 with SMTP id
 rm13-20020a17090b3ecd00b001dc945e41b1mr2212660pjb.208.1651704757437; Wed, 04
 May 2022 15:52:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:54 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-109-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 108/128] KVM: selftests: Convert tprot away from VCPU_ID
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
2.36.0.464.gb9c8b46e94-goog

