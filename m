Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C9653C2F0
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240234AbiFCAp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240009AbiFCAoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EBC33887
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id l2-20020a17090a72c200b001e325e14e3eso3515446pjk.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tpsyQW12jmAgv3in7dKrEx0XzJmqC8wtaaXcKs50cw0=;
        b=fQ3b+dCpSd9d5Qeu1Scb2/xil7v+BDCrJI9u3G4vYHLuSNhmtHuKvh8/0TF0rP6AUx
         UPnAQw1Wnqy/xL3ylPKMieyu0itC2wpq5v3sRgmiwdv1PtZISEYl/CWn+cavurHPwwRx
         tgjHd996wYOKElB47oCugsWAVLZ1aa0MBQ6TNZwfmmwMT51AWtyKhFYq4Q9BcboKLm5X
         W7QShrvXiMae6hAfk/jmUr2l8RgGz74JWfkfocGy7Oy+kMkye+zAayN5hqABRGNYKTNn
         eunYG181Zk0GZ6YHiR4d4x7GkpiPB2+Fq359+XXX7KBgEGwQ1OAk+9gfQbB6ZLEo0GpY
         6dYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tpsyQW12jmAgv3in7dKrEx0XzJmqC8wtaaXcKs50cw0=;
        b=1mVcyjUSQj2qDhSvdW3me3U+ZBCJZ69AgXPEDN7BeaUwsmjZTztW/KVqCNv3iIIMBT
         NtPw4f0k3zOMYfOn2r4oMFtX+nukDlvqjqDhwSUuziqLFsd3aYUpffWGSuP6CNwrl6Xc
         yYnvKQGzzBFFR2Asbg0RouHblzY0xhRPgA0rxomILczmm/grWGcZgl4/EapB76Z0pH6S
         v+8lgK3v3dyobYoVNaMwJ4hgkukHo2ddn2AXnxGZExU3C8OQCfWtoVuGhRZLrf10G64H
         RR6hZ4mjH3TE4jxKkv2OGFVS9F0SSBzMCb2IxHIqQM8pWZRxQ55uCBH9AHFtvJKeqyyC
         iRBQ==
X-Gm-Message-State: AOAM530NkSWdTkk6q9yrILj7T1sMyOO1pfxi0IRkWmdTkDxc4XPGr0hh
        zvgnGh4pvUb7Yne9C/GqWgc6lHUYGB8=
X-Google-Smtp-Source: ABdhPJyLqYJ2WLLGQ8O6uIZlykZ8FpE+phkMnOc8VQueTLSJ5VfdpIfcezoHmp3eE4IwOaPLJuDMCIA850c=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9a2:b0:505:974f:9fd6 with SMTP id
 u34-20020a056a0009a200b00505974f9fd6mr7734217pfg.12.1654217041266; Thu, 02
 Jun 2022 17:44:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:21 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 014/144] KVM: selftests: Add vcpu_get() to retrieve and
 assert on vCPU existence
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
2.36.1.255.ge46751e96f-goog

