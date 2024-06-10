Return-Path: <kvm+bounces-19255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D019D9028A3
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 20:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 820C71F21D05
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC4114F9CA;
	Mon, 10 Jun 2024 18:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G4rKjK8h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9821914E2E3;
	Mon, 10 Jun 2024 18:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718043948; cv=none; b=fOs/Jm4LjWyDNHTNlZ5nZ9RQ1dqYzprT2aOd6FM0f3B96peCIgJdIOS/kG6UCbPTpyz29vPMl8TFEw+CaXG8gco81Rwkmm18TT/Mvxbic6l3kdxZRAYMtOdN4H80ILVhsW56U7pYUqISw+8OAB5fxFcPbfhyVZBFIp6J8Cx6ePE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718043948; c=relaxed/simple;
	bh=TU8+y4Cz7hX5wmWVWkYbyljjHQ109brdQA4MR9+Pj7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p0NOZbhdnUXvcZEJf6ply3KxWC5YwYdRBuhwmRWGNFAMaMbXoZ5Q5Adylw5jPqUrG0lPJOQz9JVkxf02bBZlsndQmI5Q7MpgYJFvUI9Xg5vmMkGSyvmI+mFPknrs+v1UIA+F5+M3anIG+eBuCA/ELj8z6NUrTTi+G+H9UUiL9Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G4rKjK8h; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718043946; x=1749579946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TU8+y4Cz7hX5wmWVWkYbyljjHQ109brdQA4MR9+Pj7k=;
  b=G4rKjK8hVBN40xJvbqoDUG6/T0UArXniZZFujPQa0RPUfi3xafaCIl66
   r6jzMbPk8+5Yvl8fdim8Fl+z+k8IcH7Tcmc0FGy6orACjMX4iy1bIe8B1
   RsuGaVKuIsEQrheanTPeaD5bTmJypNVpo0eIwgm4Eiw0+cI3AqD//TcXP
   kZqKACY6tjPEMPP3wn9Y8B0a2b8Ze3CixfrMFMTsE8xkoUL6Ae4kxWPEE
   NRRwoOahC6cGCZNJdQfg6+2HL9NG1hKo1lBvXOgcUYllLeevj8MEH5Slg
   dQLQ2j5haVJFsowxBH0BlB4DhA3bGK4jwBCgbfqqv3PLJQY0c8iq41J3U
   w==;
X-CSE-ConnectionGUID: +R2QVbWeQHCIe0U5Ys2Q+A==
X-CSE-MsgGUID: K6ImCOPkQHSDuC+A0ZQRVg==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="14875071"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="14875071"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:25:40 -0700
X-CSE-ConnectionGUID: DYmqaNW7TgyWfvW4Yo6akQ==
X-CSE-MsgGUID: ZFFVw/2PRUumWSCJac800A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="44072146"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:25:41 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: isaku.yamahata@intel.com,
	pbonzini@redhat.com,
	erdemaktas@google.com,
	vkuznets@redhat.com,
	seanjc@google.com,
	vannapurve@google.com,
	jmattson@google.com,
	mlevitsk@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	yuan.yao@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V8 1/2] KVM: selftests: Add x86_64 guest udelay() utility
Date: Mon, 10 Jun 2024 11:25:34 -0700
Message-Id: <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1718043121.git.reinette.chatre@intel.com>
References: <cover.1718043121.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create udelay() utility for x86_64 tests to match
udelay() available to ARM and RISC-V tests.

Calibrate guest frequency using the KVM_GET_TSC_KHZ ioctl()
and share it between host and guest with the new
tsc_khz global variable.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes v8:
- Use appropriate signed type to discover TSC freq from KVM.
- Switch type used to store TSC frequency from unsigned long
  to unsigned int to match the type used by the kernel.

Changes v7:
- New patch
---
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 12 ++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8eb57de0b587..b473f210ba6c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -23,6 +23,7 @@
 
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
+extern unsigned int tsc_khz;
 
 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
@@ -815,6 +816,20 @@ static inline void cpu_relax(void)
 	asm volatile("rep; nop" ::: "memory");
 }
 
+static inline void udelay(unsigned long usec)
+{
+	unsigned long cycles = tsc_khz / 1000 * usec;
+	uint64_t start, now;
+
+	start = rdtsc();
+	for (;;) {
+		now = rdtsc();
+		if (now - start >= cycles)
+			break;
+		cpu_relax();
+	}
+}
+
 #define ud2()			\
 	__asm__ __volatile__(	\
 		"ud2\n"	\
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c664e446136b..ff579674032f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -25,6 +25,7 @@ vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
 bool is_forced_emulation_enabled;
+unsigned int tsc_khz;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
@@ -616,6 +617,8 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vm_post_create(struct kvm_vm *vm)
 {
+	int r;
+
 	vm_create_irqchip(vm);
 	vm_init_descriptor_tables(vm);
 
@@ -628,6 +631,15 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 
 		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
 	}
+
+	if (kvm_has_cap(KVM_CAP_GET_TSC_KHZ)) {
+		r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
+		if (r < 0)
+			tsc_khz = 0;
+		else
+			tsc_khz = r;
+		sync_global_to_guest(vm, tsc_khz);
+	}
 }
 
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
-- 
2.34.1


