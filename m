Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F3240EA77
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345103AbhIPS6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245256AbhIPS5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:34 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC6DC04A163
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:08 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id l22-20020a05622a175600b0029d63a970f6so63145487qtk.23
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Xw4+tgKVLmvm8JQWsGHVEpFbMf77zCGqq8rbz5yrSuw=;
        b=aqj3HRCmfQvWoQtSN5RzC1ysFfx+mQMpaBU2bf9JiwokiR0SsR1mjFVZwlMsYRWd5F
         S1wO4hvUJBxqXeG0m7E3iOLmvRhccSonfYKnGvnrmcxRXwiajJF8WrW/0OjYx2jBhPNg
         mSeQYdEI69TgXBb0UzLjUrlsKeOQachsm67AH76Wx+H8gHYl2PSGhNNq6W7jYvQM/XC3
         LXaisjjlREFlx0rMPKJ2YsgTBksZdWAA2o3kTilLBfa1XqxawES6tGn2os4UI+BOIu19
         gZFLCmlXEaeNDs7eyflXYmGj3j9j1rvbHboi2PjGfs2Sd46TUcfd88SDJvadas/9BxEe
         FnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Xw4+tgKVLmvm8JQWsGHVEpFbMf77zCGqq8rbz5yrSuw=;
        b=gAXhuD5iGX0CqoA+T25h6FLatFtZ02hWR8NE4JS0tLX08MKDVleEtoSLuuRoeLlxvD
         Sd/BgtybrLUqyAtrUjBIo2hN0EsvQthVYF/beR9ij8wPjzSK4Io8dmncvImEa6ngfapg
         zh4B5nrcd7iNuSzsb+fUcbAuxWCMlNUT8gc2K+icFFL8CLamSYZJzJrHS5I/6X4iE8oI
         gCEYScsy8d9gMkzAeI9ISU/mangfrUF25ne+c40Ms1Tujd90sAOhqG9XCEaxopaMALZx
         l+zrw4QCHdOUByQbs4+Mh6b2DqQWQ/WlZ1+dwSFeQxiWTJP6VY9Hj/gUz4PrH9+SMvCl
         ah0A==
X-Gm-Message-State: AOAM531ygagaE2FSS1aD4hwY1IavydhF5LTV6oW5+2VSHxavajacJutn
        S3TB4gDtk6sPWa0JaK/woxEtu+foqYAvXI8syOO89LvIWgpHKwIK/Pl+CbO0/LlTYNO5ZiCSEv1
        ozzSfmt0pObgd6b1tUFSNkgy1jGRAc8xfiGoWoygEC7z0bjPr6tkLblYQig==
X-Google-Smtp-Source: ABdhPJwwEMjf9bn2Y68JHX2UcSLI5bYpoUc13K4VaVdU55eP01YXVcQ93R0zLYLdVbktp7FtkAMXNw1xICs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1372:: with SMTP id
 c18mr4801098qvw.28.1631816167832; Thu, 16 Sep 2021 11:16:07 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:55 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-10-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 9/9] selftests: KVM: Test vtimer offset reg in get-reg-list
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that KVM exposes KVM_REG_ARM_TIMER_OFFSET in the KVM_GET_REG_LIST
ioctl when userspace buys in to the new behavior.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..4f337d8b793a 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -40,6 +40,7 @@ static __u64 *blessed_reg, blessed_n;
 struct reg_sublist {
 	const char *name;
 	long capability;
+	long enable_capability;
 	int feature;
 	bool finalize;
 	__u64 *regs;
@@ -397,6 +398,19 @@ static void check_supported(struct vcpu_config *c)
 	}
 }
 
+static void enable_caps(struct kvm_vm *vm, struct vcpu_config *c)
+{
+	struct kvm_enable_cap cap = {0};
+	struct reg_sublist *s;
+
+	for_each_sublist(c, s) {
+		if (s->enable_capability) {
+			cap.cap = s->enable_capability;
+			vm_enable_cap(vm, &cap);
+		}
+	}
+}
+
 static bool print_list;
 static bool print_filtered;
 static bool fixup_core_regs;
@@ -412,6 +426,8 @@ static void run_test(struct vcpu_config *c)
 	check_supported(c);
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	enable_caps(vm, c);
+
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
 	finalize_vcpu(vm, 0, c);
@@ -1014,6 +1030,10 @@ static __u64 sve_rejects_set[] = {
 	KVM_REG_ARM64_SVE_VLS,
 };
 
+static __u64 vtimer_offset_regs[] = {
+	KVM_REG_ARM_TIMER_OFFSET,
+};
+
 #define BASE_SUBLIST \
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
@@ -1025,6 +1045,10 @@ static __u64 sve_rejects_set[] = {
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
 	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
+#define VTIMER_OFFSET_SUBLIST \
+	{ "vtimer_offset", .capability = KVM_CAP_ARM_VTIMER_OFFSET, \
+	  .enable_capability = KVM_CAP_ARM_VTIMER_OFFSET, .regs = vtimer_offset_regs, \
+	  .regs_n = ARRAY_SIZE(vtimer_offset_regs), }
 
 static struct vcpu_config vregs_config = {
 	.sublists = {
@@ -1041,6 +1065,14 @@ static struct vcpu_config vregs_pmu_config = {
 	{0},
 	},
 };
+static struct vcpu_config vregs_vtimer_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	VTIMER_OFFSET_SUBLIST,
+	{0},
+	},
+};
 static struct vcpu_config sve_config = {
 	.sublists = {
 	BASE_SUBLIST,
@@ -1056,11 +1088,21 @@ static struct vcpu_config sve_pmu_config = {
 	{0},
 	},
 };
+static struct vcpu_config sve_vtimer_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	SVE_SUBLIST,
+	VTIMER_OFFSET_SUBLIST,
+	{0},
+	},
+};
 
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
 	&vregs_pmu_config,
+	&vregs_vtimer_config,
 	&sve_config,
 	&sve_pmu_config,
+	&sve_vtimer_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.33.0.464.g1972c5931b-goog

