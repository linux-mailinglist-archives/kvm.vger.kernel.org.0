Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3B51B2D5
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379598AbiEDW4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379257AbiEDWxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:37 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F021853E15
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z11-20020a17090a468b00b001dc792e8660so1317119pjf.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dsqd2BC0he8cu3KMlN3fGhXr8Guk3V++LSAF0rvZtfQ=;
        b=pmSzKDfTWyW5D0ejUbtOpzAu5j7OkBtuF8fIUi0PswzOGWlXJYJ4pUwpHHAAr1P+XH
         rL8AHdGmlEeoJGRDagq6c6NMEzln75pR2TGRwOuZk5qPF10RnH5A5dluP0pn9CCPdvwv
         8Din/NAEgPbDmDxyKBLYxMnGYiRKYUqbo7f2S/Rr1R7zc6ku7orxluaZg/96o7pCDrPv
         lV0TQMeXbDL5pr+IHswjr/PUN7rDJPv85sHCGLMqZEh6fQExh84LHGM/Y8qWV/wB2TB+
         1mhvHBSaVJpj06d6Cp187gbyQLyHOgcjqbGwgg8ihi3nAiJSybDiAJ9utdP8P511lIEQ
         doWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dsqd2BC0he8cu3KMlN3fGhXr8Guk3V++LSAF0rvZtfQ=;
        b=hY67uOzhQOXoZtFrzY0s0/2leBPoW/GZy3y2dmYZj9juWx3lS7mqBkHnSgcD3AmnHs
         mXagJ2/RLFxyuz5G6wn3faCennuYgk399Z2I7QPWZIY1wdtpaGMw+w2BfAN8p94Gp7ez
         C8qSmTJ5MwcnCUMclSHtQbyBmFtVXEFnQnpmS4Wn46sGWYJAUmezM8ThkV/gfZAFOf13
         MFBD1g1q5B6/1Xy42IBgl/XAsXaj18C67ke/2ccyNtHUr5w6nnYJkDIm5GmRekxzalW+
         p0L/cAzKGPQ3Dh0tJgPbkkjdgZGt/FiTiZMZCbsyswSudnp/CC4yPW1qJ4i+jvUOnkm5
         JFew==
X-Gm-Message-State: AOAM530CLP7EBXQMtf8pDkCHctZE0onPFnnCjiXwuxmcZBSQOiD9OP7T
        lR2O1Awpmj8MU+G5oJ0wdMi/0Lr/je8=
X-Google-Smtp-Source: ABdhPJyr59EMatyWhqepevXEWefEjBJYSvGWE9KtZe3WD/Mr8qKZTtnUx6xIQ634iaTVd0I9Y2gUYjfSa/4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf0b:b0:15a:2681:9180 with SMTP id
 i11-20020a170902cf0b00b0015a26819180mr24015658plg.137.1651704594480; Wed, 04
 May 2022 15:49:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:19 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 013/128] KVM: selftests: Add vcpu_get() to retrieve and assert
 on vCPU existence
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

Add vcpu_get() to wrap vcpu_find() and deduplicate a pile of code that
asserts the requested vCPU exists.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 56 ++++++-------------
 .../selftests/kvm/lib/kvm_util_internal.h     |  2 +-
 .../selftests/kvm/lib/s390x/processor.c       |  5 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  4 +-
 4 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 73123b9d9625..940decfaa633 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -561,23 +561,7 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
-/*
- * VCPU Find
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to VCPU structure
- *
- * Locates a vcpu structure that describes the VCPU specified by vcpuid and
- * returns a pointer to it.  Returns NULL if the VM doesn't contain a VCPU
- * for the specified vcpuid.
- */
-struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
+static struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu;
 
@@ -589,6 +573,14 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
 	return NULL;
 }
 
+struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "vCPU %d does not exist", vcpuid);
+	return vcpu;
+}
+
 /*
  * VM VCPU Remove
  *
@@ -1568,8 +1560,7 @@ void vm_create_irqchip(struct kvm_vm *vm)
  */
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	return vcpu->state;
 }
@@ -1610,11 +1601,9 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 	int ret;
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
 	vcpu->state->immediate_exit = 1;
 	ret = __vcpu_run(vm, vcpuid);
 	vcpu->state->immediate_exit = 0;
@@ -1656,14 +1645,9 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid)
 int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 		 unsigned long cmd, void *arg)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, cmd, arg);
-
-	return ret;
+	return ioctl(vcpu->fd, cmd, arg);
 }
 
 void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
@@ -1676,15 +1660,11 @@ void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
 
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu;
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 	uint32_t size = vm->dirty_ring_size;
 
 	TEST_ASSERT(size > 0, "Should enable dirty ring first");
 
-	vcpu = vcpu_find(vm, vcpuid);
-
-	TEST_ASSERT(vcpu, "Cannot find vcpu %u", vcpuid);
-
 	if (!vcpu->dirty_gfns) {
 		void *addr;
 
@@ -1840,9 +1820,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	return _kvm_device_check_attr(vcpu->fd, group, attr);
 }
@@ -1859,9 +1837,7 @@ int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			     uint64_t attr, void *val, bool write)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	return _kvm_device_access(vcpu->fd, group, attr, val, write);
 }
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index a03febc24ba6..0c7c44499129 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -69,7 +69,7 @@ struct kvm_vm {
 	uint32_t dirty_ring_size;
 };
 
-struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
+struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid);
 
 /*
  * Virtual Translation Tables Dump
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index f87c7137598e..7cc1051c4b71 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -208,10 +208,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	if (!vcpu)
-		return;
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
 		indent, "", vcpu->state->psw_mask, vcpu->state->psw_addr);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 27c40b5ab01d..bd9d1b63b848 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -996,7 +996,7 @@ static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
 
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 	struct kvm_msr_list *list;
 	struct kvm_x86_state *state;
 	int nmsrs, r, i;
@@ -1079,7 +1079,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *state)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 	int r;
 
 	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
-- 
2.36.0.464.gb9c8b46e94-goog

