Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644A153C200
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240342AbiFCAqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240136AbiFCAoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:55 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947F037A2C
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d12-20020a17090a628c00b001dcd2efca39so3407311pjj.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nJYDyIQlf43tnO29QtGw5+/JwyZGgarjVqW9ae910lU=;
        b=BhsHU27O0y5pb/oAsD9J6/+9IuGPasnzQt5aGw3tGq4kynzlPn2c6E6apW/lmB1UMu
         S7P2pqNgaAaLH7apUAkEm7a+fc3HDXIHLROwWkQ9L3G0pc9VFxuaLj9z8tvHwvjWjQeA
         oMHUU53QTppyztjJ/3KPo4JtnESJfdyTFzZyeSHj19d0si5pDLJAj35ZkeA8j7QBaADt
         JYulzFT1HvNilCCsOrkwT17RdaAcA/nGQ3q+ZOl0caGz3hiyGM02MLInsrWT40Rf9c+f
         ym+6By+oriXt7Hb+FwKQ7W6uYlWwG3oOhbEJcMaXtyKZMewX2cZ8NeviHmbTQ74labvZ
         Ropg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nJYDyIQlf43tnO29QtGw5+/JwyZGgarjVqW9ae910lU=;
        b=28FTnEbl3yxuEw6+rEoGPydwqg5W9fWd/7FEbG6eAVDaTc0N6lcKZbVRXt+e6uP6IW
         j5ZluHbRIxzeaTGdOpP//QQ+hcwA+opUB8yN0pcoWlZzu2MEjLdXfj0om9yoWznVm9nH
         NIU7qKtYhvKhQxb39bC2e08A50Z6yu7ATFy+3/FdwJMgwDRmzbUZocUPgukeVHcNRKDk
         UahAP4WztQnp6q2ei+8r1k1IT8AvbTgRvwimNvOd509MYL/Yb2fldJnv5ySsHr3orqrq
         GYsxOC1pDy6kURwKlG/dXGzKsBNIuK7p0uOHd8zy0dUAoCR+w4zmFiorKjavtnML0OA5
         mB4g==
X-Gm-Message-State: AOAM530M5dfSSvyaaBsg4X3DioXfONFGomazcVeS0eWv14tDOuw/gP1g
        jq5V1Fliwit0uVUHLwq1oWk3tYUE/e4=
X-Google-Smtp-Source: ABdhPJxX+yxFeLnyVhqRi1E5gZaRVysi/pa49vkeW8EBzDi0YSpm8f9eLfRkfNI+M5WeReQz4F1qmdTgeEU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f688:b0:163:ee37:91c5 with SMTP id
 l8-20020a170902f68800b00163ee3791c5mr7812180plg.86.1654217082066; Thu, 02 Jun
 2022 17:44:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:43 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-37-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 036/144] KVM: selftest: Add proper helpers for x86-specific
 save/restore ioctls
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

Add helpers for the various one-off helpers used by x86's vCPU state
save/restore helpers, and convert the other open coded ioctl()s to use
existing helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  54 ++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 126 +++++-------------
 2 files changed, 91 insertions(+), 89 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e4268432cfe8..1d46d60bb480 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -432,6 +432,60 @@ const struct kvm_msr_list *kvm_get_feature_msr_index_list(void);
 bool kvm_msr_is_in_save_restore_list(uint32_t msr_index);
 uint64_t kvm_get_feature_msr(uint64_t msr_index);
 
+static inline void vcpu_msrs_get(struct kvm_vm *vm, uint32_t vcpuid,
+				 struct kvm_msrs *msrs)
+{
+	int r = __vcpu_ioctl(vm, vcpuid, KVM_GET_MSRS, msrs);
+
+	TEST_ASSERT(r == msrs->nmsrs,
+		    "KVM_GET_MSRS failed, r: %i (failed on MSR %x)",
+		    r, r < 0 || r >= msrs->nmsrs ? -1 : msrs->entries[r].index);
+}
+static inline void vcpu_msrs_set(struct kvm_vm *vm, uint32_t vcpuid,
+				 struct kvm_msrs *msrs)
+{
+	int r = __vcpu_ioctl(vm, vcpuid, KVM_SET_MSRS, msrs);
+
+	TEST_ASSERT(r == msrs->nmsrs,
+		    "KVM_GET_MSRS failed, r: %i (failed on MSR %x)",
+		    r, r < 0 || r >= msrs->nmsrs ? -1 : msrs->entries[r].index);
+}
+static inline void vcpu_debugregs_get(struct kvm_vm *vm, uint32_t vcpuid,
+				      struct kvm_debugregs *debugregs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_DEBUGREGS, debugregs);
+}
+static inline void vcpu_debugregs_set(struct kvm_vm *vm, uint32_t vcpuid,
+				      struct kvm_debugregs *debugregs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_DEBUGREGS, debugregs);
+}
+static inline void vcpu_xsave_get(struct kvm_vm *vm, uint32_t vcpuid,
+				  struct kvm_xsave *xsave)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_XSAVE, xsave);
+}
+static inline void vcpu_xsave2_get(struct kvm_vm *vm, uint32_t vcpuid,
+				   struct kvm_xsave *xsave)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_XSAVE2, xsave);
+}
+static inline void vcpu_xsave_set(struct kvm_vm *vm, uint32_t vcpuid,
+				  struct kvm_xsave *xsave)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_XSAVE, xsave);
+}
+static inline void vcpu_xcrs_get(struct kvm_vm *vm, uint32_t vcpuid,
+				 struct kvm_xcrs *xcrs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_XCRS, xcrs);
+}
+static inline void vcpu_xcrs_set(struct kvm_vm *vm, uint32_t vcpuid,
+				 struct kvm_xcrs *xcrs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_XCRS, xcrs);
+}
+
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9268537f9bd7..5c92e96300c5 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -815,13 +815,11 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index)
 		struct kvm_msrs header;
 		struct kvm_msr_entry entry;
 	} buffer = {};
-	int r;
 
 	buffer.header.nmsrs = 1;
 	buffer.entry.index = msr_index;
 
-	r = __vcpu_ioctl(vm, vcpuid, KVM_GET_MSRS, &buffer.header);
-	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_GET_MSRS, r));
+	vcpu_msrs_get(vm, vcpuid, &buffer.header);
 
 	return buffer.entry.data;
 }
@@ -958,28 +956,26 @@ bool kvm_msr_is_in_save_restore_list(uint32_t msr_index)
 	return false;
 }
 
-static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
-				 struct kvm_x86_state *state)
+static void vcpu_save_xsave_state(struct kvm_vm *vm, uint32_t vcpuid,
+				  struct kvm_x86_state *state)
 {
-	int size;
+	int size = vm_check_cap(vm, KVM_CAP_XSAVE2);
 
-	size = vm_check_cap(vm, KVM_CAP_XSAVE2);
-	if (!size)
-		size = sizeof(struct kvm_xsave);
-
-	state->xsave = malloc(size);
-	if (size == sizeof(struct kvm_xsave))
-		return ioctl(vcpu->fd, KVM_GET_XSAVE, state->xsave);
-	else
-		return ioctl(vcpu->fd, KVM_GET_XSAVE2, state->xsave);
+	if (size) {
+		state->xsave = malloc(size);
+		vcpu_xsave2_get(vm, vcpuid, state->xsave);
+	} else {
+		state->xsave = malloc(sizeof(struct kvm_xsave));
+		vcpu_xsave_get(vm, vcpuid, state->xsave);
+	}
 }
 
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	const struct kvm_msr_list *msr_list = kvm_get_msr_index_list();
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 	struct kvm_x86_state *state;
-	int r, i;
+	int i;
+
 	static int nested_size = -1;
 
 	if (nested_size == -1) {
@@ -998,102 +994,54 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu_run_complete_io(vm, vcpuid);
 
 	state = malloc(sizeof(*state) + msr_list->nmsrs * sizeof(state->msrs.entries[0]));
-	r = ioctl(vcpu->fd, KVM_GET_VCPU_EVENTS, &state->events);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_VCPU_EVENTS, r: %i",
-		    r);
 
-	r = ioctl(vcpu->fd, KVM_GET_MP_STATE, &state->mp_state);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MP_STATE, r: %i",
-		    r);
+	vcpu_events_get(vm, vcpuid, &state->events);
+	vcpu_mp_state_get(vm, vcpuid, &state->mp_state);
+	vcpu_regs_get(vm, vcpuid, &state->regs);
+	vcpu_save_xsave_state(vm, vcpuid, state);
 
-	r = ioctl(vcpu->fd, KVM_GET_REGS, &state->regs);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_REGS, r: %i",
-		    r);
+	if (kvm_check_cap(KVM_CAP_XCRS))
+		vcpu_xcrs_get(vm, vcpuid, &state->xcrs);
 
-	r = vcpu_save_xsave_state(vm, vcpu, state);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XSAVE, r: %i",
-		    r);
-
-	if (kvm_check_cap(KVM_CAP_XCRS)) {
-		r = ioctl(vcpu->fd, KVM_GET_XCRS, &state->xcrs);
-		TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XCRS, r: %i",
-			    r);
-	}
-
-	r = ioctl(vcpu->fd, KVM_GET_SREGS, &state->sregs);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_SREGS, r: %i",
-		    r);
+	vcpu_sregs_get(vm, vcpuid, &state->sregs);
 
 	if (nested_size) {
 		state->nested.size = sizeof(state->nested_);
-		r = ioctl(vcpu->fd, KVM_GET_NESTED_STATE, &state->nested);
-		TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_NESTED_STATE, r: %i",
-			    r);
+
+		vcpu_nested_state_get(vm, vcpuid, &state->nested);
 		TEST_ASSERT(state->nested.size <= nested_size,
 			    "Nested state size too big, %i (KVM_CHECK_CAP gave %i)",
 			    state->nested.size, nested_size);
-	} else
+	} else {
 		state->nested.size = 0;
+	}
 
 	state->msrs.nmsrs = msr_list->nmsrs;
 	for (i = 0; i < msr_list->nmsrs; i++)
 		state->msrs.entries[i].index = msr_list->indices[i];
-	r = ioctl(vcpu->fd, KVM_GET_MSRS, &state->msrs);
-	TEST_ASSERT(r == msr_list->nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
-		    r, r == msr_list->nmsrs ? -1 : msr_list->indices[r]);
+	vcpu_msrs_get(vm, vcpuid, &state->msrs);
 
-	r = ioctl(vcpu->fd, KVM_GET_DEBUGREGS, &state->debugregs);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_DEBUGREGS, r: %i",
-		    r);
+	vcpu_debugregs_get(vm, vcpuid, &state->debugregs);
 
 	return state;
 }
 
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *state)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
-	int r;
+	vcpu_sregs_set(vm, vcpuid, &state->sregs);
+	vcpu_msrs_set(vm, vcpuid, &state->msrs);
 
-	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
-		    r);
+	if (kvm_check_cap(KVM_CAP_XCRS))
+		vcpu_xcrs_set(vm, vcpuid, &state->xcrs);
 
-	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
-	TEST_ASSERT(r == state->msrs.nmsrs,
-		"Unexpected result from KVM_SET_MSRS, r: %i (failed at %x)",
-		r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
+	vcpu_xsave_set(vm, vcpuid,  state->xsave);
+	vcpu_events_set(vm, vcpuid, &state->events);
+	vcpu_mp_state_set(vm, vcpuid, &state->mp_state);
+	vcpu_debugregs_set(vm, vcpuid, &state->debugregs);
+	vcpu_regs_set(vm, vcpuid, &state->regs);
 
-	if (kvm_check_cap(KVM_CAP_XCRS)) {
-		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
-		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
-			    r);
-	}
-
-	r = ioctl(vcpu->fd, KVM_SET_XSAVE, state->xsave);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
-		    r);
-
-	r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
-		    r);
-
-	r = ioctl(vcpu->fd, KVM_SET_MP_STATE, &state->mp_state);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i",
-		    r);
-
-	r = ioctl(vcpu->fd, KVM_SET_DEBUGREGS, &state->debugregs);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i",
-		    r);
-
-	r = ioctl(vcpu->fd, KVM_SET_REGS, &state->regs);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
-		    r);
-
-	if (state->nested.size) {
-		r = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, &state->nested);
-		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_NESTED_STATE, r: %i",
-			    r);
-	}
+	if (state->nested.size)
+		vcpu_nested_state_set(vm, vcpuid, &state->nested);
 }
 
 void kvm_x86_state_cleanup(struct kvm_x86_state *state)
-- 
2.36.1.255.ge46751e96f-goog

