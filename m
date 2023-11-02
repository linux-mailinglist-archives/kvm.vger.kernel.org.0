Return-Path: <kvm+bounces-420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C38E87DF7BD
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30581B21310
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E8D21369;
	Thu,  2 Nov 2023 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AmaOE2qt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949B821340
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 16:34:03 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AC013D;
	Thu,  2 Nov 2023 09:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698942839; x=1730478839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=8b2lW3eo74qPEH0+9VzElndbmy1zGlp6Ujy7Gd2vHyU=;
  b=AmaOE2qtMikWedmjeBqGgVzNTdBFuLxpQy3Z+vKKxz3rPsIqsd1ttYZD
   PONBMZx6TwYQKPs5CSptGksGlzVgCMXrGu/7Dm7Zb4KsjQ0yhliHDvWsm
   Mc0zjo/PkDyNLe1LXFy+Igetso837e6ZIWBNonnwX80fyVch16q13pWzf
   eVur08M1fYy2OH82ZrLDeVSOAMdFHxpwsHtjYdT2IS3ZbBK68Fk5P9/L1
   +Xs2m1aQVRt3Yr3dpaiSF5zNsE0nsADM71EcKq/bLp8tezuAlHC4UTqwe
   T598HG2GRO6FJKidRpuXkiwmCsTvUZjG0aRsDax4YdfPPFvdGhe2yhkgH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="388571110"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="388571110"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="9448535"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.159.65])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:34 -0700
From: Zeng Guang <guang.zeng@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Zeng Guang <guang.zeng@intel.com>
Subject: [RFC PATCH v1 7/8] KVM: selftests: x86: Support vcpu run in user mode
Date: Thu,  2 Nov 2023 23:51:10 +0800
Message-Id: <20231102155111.28821-8-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102155111.28821-1-guang.zeng@intel.com>
References: <20231102155111.28821-1-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Introduce vcpu_setup_user_mode() to support vcpu run in user mode.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/lib/x86_64/processor.c      | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9c8224c80664..2534bdf8aa71 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -800,6 +800,7 @@ static inline void cpu_relax(void)
 struct kvm_x86_state *vcpu_save_state(struct kvm_vcpu *vcpu);
 void vcpu_load_state(struct kvm_vcpu *vcpu, struct kvm_x86_state *state);
 void kvm_x86_state_cleanup(struct kvm_x86_state *state);
+void vcpu_setup_user_mode(struct kvm_vcpu *vcpu, void *guest_code);
 
 const struct kvm_msr_list *kvm_get_msr_index_list(void);
 const struct kvm_msr_list *kvm_get_feature_msr_index_list(void);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 7647c3755ca2..c84292b35f2d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1071,6 +1071,25 @@ void vcpu_load_state(struct kvm_vcpu *vcpu, struct kvm_x86_state *state)
 		vcpu_nested_state_set(vcpu, &state->nested);
 }
 
+void vcpu_setup_user_mode(struct kvm_vcpu *vcpu, void *guest_code)
+{
+	struct kvm_sregs sregs;
+	struct kvm_regs regs;
+	struct kvm_vm *vm = vcpu->vm;
+
+	vcpu_sregs_get(vcpu, &sregs);
+	kvm_seg_set_code_64bit(vm, USER_CODE_SELECTOR, &sregs.cs);
+	kvm_seg_set_data_64bit(vm, USER_DATA_SELECTOR, &sregs.ds);
+	kvm_seg_set_data_64bit(vm, USER_DATA_SELECTOR, &sregs.es);
+	kvm_seg_set_data_64bit(vm, USER_DATA_SELECTOR, &sregs.ss);
+	vcpu_sregs_set(vcpu, &sregs);
+
+	vcpu_regs_get(vcpu, &regs);
+	regs.rsp = vcpu->stack_vaddr - (DEFAULT_STACK_PGS >> 1) * getpagesize();
+	regs.rip = (unsigned long) guest_code;
+	vcpu_regs_set(vcpu, &regs);
+}
+
 void kvm_x86_state_cleanup(struct kvm_x86_state *state)
 {
 	free(state->xsave);
-- 
2.21.3


