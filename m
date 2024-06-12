Return-Path: <kvm+bounces-19491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BEA905A8F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 20:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 920162843EA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 18:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC94A433DC;
	Wed, 12 Jun 2024 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="goUngthI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492C3D967;
	Wed, 12 Jun 2024 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718216184; cv=none; b=OAPj4Y2gZKHGA3TbtKimOhcFSQr30+YGU/1YlNFKTI+BzOXwXMSxsUKGmUunt3X819zW8b3B1z5R6KUKDYoc1/4UB3duHDIeOaRqLWf4XcKOnVYGAlRkiherC0PFrA6tXQEYt2N+Lw18ttKB8/AKCSZ2V5bP8aIL3O91zBR60ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718216184; c=relaxed/simple;
	bh=SF5DpOGEftLmV3KQzNi9Cf3JLfmjurXdf5dkqbh0oVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LtUegHSOQPPAI4SZYIFLQT512TNRnZLT8Ym4NX6geXDCFFNV0RnrxJjZxH7buFR3sNS4YSEyeOCd7YUUlzkctGEzKulO866PTOUpiqMZKkg3y3cUl3sgWUnURfAgc4uFxz8X/y8KOxUWCzLlfTbsRdGzuZkrZsKAOPBXO9zXxeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=goUngthI; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718216182; x=1749752182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SF5DpOGEftLmV3KQzNi9Cf3JLfmjurXdf5dkqbh0oVY=;
  b=goUngthIVoTHAkeXaRv2uvAi8ee94A+dC8Zr7Cp1W0RXAckQZUaG1ois
   AFFumM+X+SO0VwG+nADYz+2B0aH2LmDzsfEmBcdDD1uelRv8dsD4RfTTx
   vE8CVo4nmYk0vlMOflMizprbp0u8oauwsu8Y3PAiWavexGnOksi0oW+hu
   0lxUr0GDKnnOwXLsrpMT8erQiRiQICqgSUnylHiKGc0LP7PT1Mw6qQMEj
   hxiDvx7vuEDQrhJGpNqqR46ulyvD6zJ5WnGt098FjnbyqeWaGxyexE0R3
   EqnkVzNekj8OWk5LjBEKle00rWevxyi9h3FgbNsSdIVqS83u+9dl4vrQr
   Q==;
X-CSE-ConnectionGUID: ZW3iteYgRymyyw6ulvh96w==
X-CSE-MsgGUID: IY+O0t81TPOELMUsB0bdgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="14875087"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="14875087"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:16:19 -0700
X-CSE-ConnectionGUID: 3j8zj76WQgaZmXa2n2JbUw==
X-CSE-MsgGUID: cCXTFn3OSp62+VG+bY/CsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="39823175"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:16:19 -0700
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
Subject: [PATCH V9 1/2] KVM: selftests: Add x86_64 guest udelay() utility
Date: Wed, 12 Jun 2024 11:16:11 -0700
Message-Id: <5aa86285d1c1d7fe1960e3fe490f4b22273977e6.1718214999.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1718214999.git.reinette.chatre@intel.com>
References: <cover.1718214999.git.reinette.chatre@intel.com>
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
Changes v9:
- Change tsc_kz type to uint32_t (was unsigned int). (Sean)
- Change type used to store number of cycles to uint64_t
  (was unsigned long). (Sean)
- Add GUEST_ASSERT() in udelay() used in guest to avoid risk of
  udelay() unexpectedly doing nothing if something went wrong
  during TSC frequency discovery. (Sean)
- Use TEST_ASSERT() when checking for KVM_CAP_GET_TSC_KHZ. (Sean)
- Use TEST_ASSERT() to enforce that discovery of TSC frequency
  must never fail. (Sean)

Changes v8:
- Use appropriate signed type to discover TSC freq from KVM.
- Switch type used to store TSC frequency from unsigned long
  to unsigned int to match the type used by the kernel.

Changes v7:
- New patch
---
 .../selftests/kvm/include/x86_64/processor.h    | 17 +++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c        | 11 +++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index c0c7c1fe93f9..383a0f7fa9ef 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -23,6 +23,7 @@
 
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
+extern uint32_t tsc_khz;
 
 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
@@ -816,6 +817,22 @@ static inline void cpu_relax(void)
 	asm volatile("rep; nop" ::: "memory");
 }
 
+static inline void udelay(unsigned long usec)
+{
+	uint64_t start, now, cycles;
+
+	GUEST_ASSERT(tsc_khz);
+	cycles = tsc_khz / 1000 * usec;
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
index 594b061aef52..aaadda1ebcad 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -25,6 +25,7 @@ vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
 bool is_forced_emulation_enabled;
+uint32_t tsc_khz;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
@@ -616,6 +617,11 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vm_post_create(struct kvm_vm *vm)
 {
+	int r;
+
+	TEST_ASSERT(kvm_has_cap(KVM_CAP_GET_TSC_KHZ),
+		    "Require KVM_GET_TSC_KHZ to provide udelay() to guest.");
+
 	vm_create_irqchip(vm);
 	vm_init_descriptor_tables(vm);
 
@@ -628,6 +634,11 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 
 		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
 	}
+
+	r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
+	TEST_ASSERT(r > 0, "KVM_GET_TSC_KHZ did not provide a valid TSC frequency.");
+	tsc_khz = r;
+	sync_global_to_guest(vm, tsc_khz);
 }
 
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
-- 
2.34.1


