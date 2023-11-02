Return-Path: <kvm+bounces-422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C9F7DF7BE
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:34:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B76991C20FE3
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA96C21374;
	Thu,  2 Nov 2023 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gbewLks/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F592134E
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 16:34:04 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE08185;
	Thu,  2 Nov 2023 09:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698942840; x=1730478840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Nbhi+Lxa9AGjvct6KXRPu7ZYORV4sX+cH5+O4Ji6OnI=;
  b=gbewLks/8QT5Uf9CVVVDqRPSe7I34IZH4YpKdYn8dyn/oguXuNdq2JF+
   MvG5DIZxNffE44fgACwdg+2RFLLpdzpJRbmq9bqJiT6MsKAg/6c/J8agv
   Y4JIKi1gE5N9LJJcRAbpGwwrQimn2SYbyomRCx5sn1bzJvwJ7dD8leuyQ
   +CXIGIEVnK/iK8bogWzlwSzDrwmeFi7iXzRFfsQJ9FraO0NbqtV2abJ84
   nQnTGfCayONpdq+NWleCidIS6/EGbAEShGLun6e0a94/sjp1HULoxWLK+
   xmTWs6aA6OcPsJvgQQac5OYp8OPQq9HS1M44dJuDamafg8oXxou9U1Vu4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="388571121"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="388571121"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="9448555"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.159.65])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:42 -0700
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
Subject: [RFC PATCH v1 8/8] KVM: selftests: x86: Add KVM forced emulation prefix capability
Date: Thu,  2 Nov 2023 23:51:11 +0800
Message-Id: <20231102155111.28821-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102155111.28821-1-guang.zeng@intel.com>
References: <20231102155111.28821-1-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Introduce KVM selftest exception fixup using forced emulation prefix to
emulate instruction unconditionally when kvm.force_emulation_prefix is
enabled.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2534bdf8aa71..a1645508affc 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1110,6 +1110,10 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+/* Forced emulation prefix for KVM emulating instruction unconditionally */
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+#define KVM_FEP_LENGTH 5
+
 /* If a toddler were to say "abracadabra". */
 #define KVM_EXCEPTION_MAGIC 0xabacadabaULL
 
@@ -1149,6 +1153,22 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	"mov  %%r9b, %[vector]\n\t"				\
 	"mov  %%r10, %[error_code]\n\t"
 
+/*
+ * KVM selftest exception fixup using forced emulation prefix enforces KVM
+ * on emulating instruction unconditionally when kvm.force_emulation_prefix
+ * is enabled.
+ */
+#define KVM_FEP_ASM_SAFE(insn)					\
+	"mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"	\
+	"lea 1f(%%rip), %%r10\n\t"				\
+	"lea 2f(%%rip), %%r11\n\t"				\
+	KVM_FEP							\
+	"1: " insn "\n\t"					\
+	"xor %%r9, %%r9\n\t"					\
+	"2:\n\t"						\
+	"mov  %%r9b, %[vector]\n\t"				\
+	"mov  %%r10, %[error_code]\n\t"
+
 #define KVM_ASM_SAFE_OUTPUTS(v, ec)	[vector] "=qm"(v), [error_code] "=rm"(ec)
 #define KVM_ASM_SAFE_CLOBBERS	"r9", "r10", "r11"
 
-- 
2.21.3


