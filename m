Return-Path: <kvm+bounces-19030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B41608FF3F8
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 19:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48E4528BC9C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A799199391;
	Thu,  6 Jun 2024 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UpIqTmSp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F4C1991D4;
	Thu,  6 Jun 2024 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717695757; cv=none; b=hE5XiNsGt0XZj3i6cMIcyVwBVZcIqYnlwCfGzQCZO8cVCFCMUpxN4jDMxLh23Ny4W4gwDWL/NjpF4zV3A75HRrhyUVKUaK3K8n+dmMtknWHvZJeMzPym+S8dhN+ACMnh/UPYE9njh/79U6YApeqc463O2hyxCafPsPXKQ/Ict3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717695757; c=relaxed/simple;
	bh=5Pj7zTeZntRFpcC5dEi2EowgGG7W9Bb977zKSLhyAaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MNbUnrlC/wJpUzxKCvrI/eEQahK893IUwXdeWnceo0e+25B0e31G1Gc24Bsl5Jn6LciV4LxhyIwalV3cmyhgDNm1UcifvkEuhFUV/TgYCh3HizLT5n4F6jX/DBTsRbH7Ku+P+vuRQ2D/iPWO9Gyonm7XVyqYZ98Nfto8HoB49TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UpIqTmSp; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717695755; x=1749231755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Pj7zTeZntRFpcC5dEi2EowgGG7W9Bb977zKSLhyAaM=;
  b=UpIqTmSpuQzwL1dfyYi8Ndrd4Kxd/z9kp+uFcmybbqAut6bzPGdhLO2H
   di/yBwIKP4rc4amQUsPzBhybbB1Ag4G1O65fDKPBFjlItYuJlPmtgTSg+
   /MTXoQ32XMCKInLt+ZH0OVUz9kXSx3wUWwlhsRRlDlCvX1HS5DFnTJI32
   pKrPmy3oKK3j42OmFEgzyFI8vsKzf5QaZutBTFdIW9s/XM07HJkhA+4cv
   E9HodIZt93q7sJvfTnK4mDMi92lyWmwx9edh/J2HOH8FPsPlAWPAKJul4
   A3OHaSSw6oydN9p1ACdSqd95g9oUEa5moQxgFw8sCHHhUjmHlwZYqYjlD
   w==;
X-CSE-ConnectionGUID: AviwQCOcRie20tQsrt7tfA==
X-CSE-MsgGUID: GobDaQQ5T3uM2U9RCpTk2g==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="25792267"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="25792267"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 10:42:32 -0700
X-CSE-ConnectionGUID: v1MyvWkCTlOWQr3aOSX98g==
X-CSE-MsgGUID: XtAc5vCNSmyt5XTDFXGr2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="61254862"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 10:42:32 -0700
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
Subject: [PATCH V7 1/2] KVM: selftests: Add x86_64 guest udelay() utility
Date: Thu,  6 Jun 2024 10:42:00 -0700
Message-Id: <6cd5b8bba5905813dacf71249865b316146dd1d2.1717695426.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1717695426.git.reinette.chatre@intel.com>
References: <cover.1717695426.git.reinette.chatre@intel.com>
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
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/processor.c  |  8 ++++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8eb57de0b587..f3a5881dd821 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -23,6 +23,7 @@
 
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
+extern unsigned long tsc_khz;
 
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
index c664e446136b..6558fece8a36 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -25,6 +25,7 @@ vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
 bool is_forced_emulation_enabled;
+unsigned long tsc_khz;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
@@ -628,6 +629,13 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 
 		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
 	}
+
+	if (kvm_has_cap(KVM_CAP_GET_TSC_KHZ)) {
+		tsc_khz = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
+		if (tsc_khz < 0)
+			tsc_khz = 0;
+		sync_global_to_guest(vm, tsc_khz);
+	}
 }
 
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
-- 
2.34.1


