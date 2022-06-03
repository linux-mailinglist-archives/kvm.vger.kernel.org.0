Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EAB53C2AE
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiFCA5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbiFCAsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:48:37 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C544120198
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y1-20020a17090a390100b001e66bb0fcefso3258633pjb.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hdFyPWZi0ai17pbodYXg7vj/r9AKBRzYNtm6bYFX3dw=;
        b=koKlrfu+kFaLqmk6swDwBDY7pYy61KO/1h5fyD6UCFuwb3mzt0oWDlYcLL8kRJGc8b
         90Qxw7zwPYhdkNv9XseJhYhsKNQPmgIOFary1q1IuoUFYXv+oYIpDXeVfr2Q/KgwmQoy
         dhDIP0ziYm4y+fDQIrGNI+CFwC7mFtU0yFneEMzFEFqTBKNPxjTXL7mEpzYK0ZewYVN2
         MbPgYc/DBbesPW6spgHetX+tw4N4hr/pBt5whZvFKbBkjgq5/s5fLAJ/QyS0cU9YS0u0
         vSWwcaIOrdJYf1vAKIv8AIPOYc4ox7f4k5g9D78P0QXiXoGBqx1elRBp9X6ttyCSk+Xv
         ogsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hdFyPWZi0ai17pbodYXg7vj/r9AKBRzYNtm6bYFX3dw=;
        b=VEpA8skDFO1+TwD9GJGAsuXqqXBPjDiDWFxcQuDthOg5RUnEX5atPDVFgNBMb7PIQv
         7KfbcUQfAkcPIa64nZ+myQqI0FgSvXWHibb/J8mrALUV4sLw/Rpzy5NH+0qzYDlypte4
         dZea/3yH6zrJ12QlKnvso4QsVmJr8MU+B0Sd+KNnyrSfQCLJLnrOdHsObLbnVr90BCwd
         ttaATk1F79nGHW1sx3nSTdXBKkrUDhHXVe7hSMMlOAo/11gHuSFhRkj2Unmq8Q1tRMYt
         PB8EP4/WZvRrT0LWQQGWd3T7vp7ZIHqe6nxWROGSkGtLWXPNYpptuGyKNOBs0cB2J+wG
         fpFw==
X-Gm-Message-State: AOAM532/FZickNuzkErE4ct6QqxLCJ9v3dsKUFjOx/hOUyFcFfC7wKOi
        xfs2P7RbNCsnmGiGsUqCeKdOzzLfbJY=
X-Google-Smtp-Source: ABdhPJwR7XfuNqWR0Id/AqJcevxNjb2zPVz7bScoF6P9w77H1tpOEY9S02I9azhdW8nRpzbGF086KrfDJ7Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:d45e:0:b0:51b:4d60:cda4 with SMTP id
 u30-20020a62d45e000000b0051b4d60cda4mr7686562pfl.17.1654217221863; Thu, 02
 Jun 2022 17:47:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:01 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-115-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 114/144] KVM: selftests: Convert hypercalls test away from vm_create_default()
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

Use a combination of vm_create(), vm_create_with_vcpus(), and
    vm_vcpu_add() to convert vgic_init from vm_create_default_with_vcpus(),
    and away from referncing vCPUs by ID.

Thus continues the march toward total annihilation of "default" helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/hypercalls.c        | 51 +++++++++----------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 44ca840e8219..fefa39dc9bc8 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -150,23 +150,19 @@ struct st_time {
 #define STEAL_TIME_SIZE		((sizeof(struct st_time) + 63) & ~63)
 #define ST_GPA_BASE		(1 << 30)
 
-static void steal_time_init(struct kvm_vm *vm)
+static void steal_time_init(struct kvm_vcpu *vcpu)
 {
 	uint64_t st_ipa = (ulong)ST_GPA_BASE;
 	unsigned int gpages;
-	struct kvm_device_attr dev = {
-		.group = KVM_ARM_VCPU_PVTIME_CTRL,
-		.attr = KVM_ARM_VCPU_PVTIME_IPA,
-		.addr = (uint64_t)&st_ipa,
-	};
 
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE);
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+	vm_userspace_mem_region_add(vcpu->vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
 
-	vcpu_ioctl(vm, 0, KVM_SET_DEVICE_ATTR, &dev);
+	vcpu_device_attr_set(vcpu->vm, vcpu->id, KVM_ARM_VCPU_PVTIME_CTRL,
+			     KVM_ARM_VCPU_PVTIME_IPA, &st_ipa);
 }
 
-static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
+static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 {
 	uint64_t val;
 	unsigned int i;
@@ -176,18 +172,18 @@ static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
 		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
 
 		/* First 'read' should be an upper limit of the features supported */
-		vcpu_get_reg(vm, 0, reg_info->reg, &val);
+		vcpu_get_reg(vcpu->vm, vcpu->id, reg_info->reg, &val);
 		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
 			"Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx\n",
 			reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit), val);
 
 		/* Test a 'write' by disabling all the features of the register map */
-		ret = __vcpu_set_reg(vm, 0, reg_info->reg, 0);
+		ret = __vcpu_set_reg(vcpu->vm, vcpu->id, reg_info->reg, 0);
 		TEST_ASSERT(ret == 0,
 			"Failed to clear all the features of reg: 0x%lx; ret: %d\n",
 			reg_info->reg, errno);
 
-		vcpu_get_reg(vm, 0, reg_info->reg, &val);
+		vcpu_get_reg(vcpu->vm, vcpu->id, reg_info->reg, &val);
 		TEST_ASSERT(val == 0,
 			"Expected all the features to be cleared for reg: 0x%lx\n", reg_info->reg);
 
@@ -196,7 +192,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
 		 * Avoid this check if all the bits are occupied.
 		 */
 		if (reg_info->max_feat_bit < 63) {
-			ret = __vcpu_set_reg(vm, 0, reg_info->reg, BIT(reg_info->max_feat_bit + 1));
+			ret = __vcpu_set_reg(vcpu->vm, vcpu->id, reg_info->reg, BIT(reg_info->max_feat_bit + 1));
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
 			"Unexpected behavior or return value (%d) while setting an unsupported feature for reg: 0x%lx\n",
 			errno, reg_info->reg);
@@ -204,7 +200,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
 	}
 }
 
-static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
+static void test_fw_regs_after_vm_start(struct kvm_vcpu *vcpu)
 {
 	uint64_t val;
 	unsigned int i;
@@ -217,7 +213,7 @@ static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
 		 * Before starting the VM, the test clears all the bits.
 		 * Check if that's still the case.
 		 */
-		vcpu_get_reg(vm, 0, reg_info->reg, &val);
+		vcpu_get_reg(vcpu->vm, vcpu->id, reg_info->reg, &val);
 		TEST_ASSERT(val == 0,
 			"Expected all the features to be cleared for reg: 0x%lx\n",
 			reg_info->reg);
@@ -227,26 +223,26 @@ static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
 		 * the registers and should return EBUSY. Set the registers and check for
 		 * the expected errno.
 		 */
-		ret = __vcpu_set_reg(vm, 0, reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit));
+		ret = __vcpu_set_reg(vcpu->vm, vcpu->id, reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit));
 		TEST_ASSERT(ret != 0 && errno == EBUSY,
 		"Unexpected behavior or return value (%d) while setting a feature while VM is running for reg: 0x%lx\n",
 		errno, reg_info->reg);
 	}
 }
 
-static struct kvm_vm *test_vm_create(void)
+static struct kvm_vm *test_vm_create(struct kvm_vcpu **vcpu)
 {
 	struct kvm_vm *vm;
 
-	vm = vm_create_default(0, 0, guest_code);
+	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
 	ucall_init(vm, NULL);
-	steal_time_init(vm);
+	steal_time_init(*vcpu);
 
 	return vm;
 }
 
-static void test_guest_stage(struct kvm_vm **vm)
+static void test_guest_stage(struct kvm_vm **vm, struct kvm_vcpu **vcpu)
 {
 	int prev_stage = stage;
 
@@ -258,12 +254,12 @@ static void test_guest_stage(struct kvm_vm **vm)
 
 	switch (prev_stage) {
 	case TEST_STAGE_REG_IFACE:
-		test_fw_regs_after_vm_start(*vm);
+		test_fw_regs_after_vm_start(*vcpu);
 		break;
 	case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
 		/* Start a new VM so that all the features are now enabled by default */
 		kvm_vm_free(*vm);
-		*vm = test_vm_create();
+		*vm = test_vm_create(vcpu);
 		break;
 	case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
 	case TEST_STAGE_HVC_IFACE_FALSE_INFO:
@@ -275,20 +271,21 @@ static void test_guest_stage(struct kvm_vm **vm)
 
 static void test_run(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	bool guest_done = false;
 
-	vm = test_vm_create();
+	vm = test_vm_create(&vcpu);
 
-	test_fw_regs_before_vm_start(vm);
+	test_fw_regs_before_vm_start(vcpu);
 
 	while (!guest_done) {
-		vcpu_run(vm, 0);
+		vcpu_run(vcpu->vm, vcpu->id);
 
-		switch (get_ucall(vm, 0, &uc)) {
+		switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
-			test_guest_stage(&vm);
+			test_guest_stage(&vm, &vcpu);
 			break;
 		case UCALL_DONE:
 			guest_done = true;
-- 
2.36.1.255.ge46751e96f-goog

