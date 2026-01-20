Return-Path: <kvm+bounces-68596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7445D3C353
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE9DE501C94
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C5E3D2FE5;
	Tue, 20 Jan 2026 09:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="IDkxIKqk"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29252FFDF4;
	Tue, 20 Jan 2026 09:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900570; cv=none; b=mVbJd2FYQWjI4linLtAMlZpfJUDhLGvW7RXB5kb3k7UgdYkUlMsWEkSYC8BOvu0E79+GGxk7ffGeo50p2SeXqJkh6Wx8cxXOhEUPQLGR9gapCiGtzMJRVQom/T7UhdcMKsbeOoeoDykV/ca7OfCvBftzj8mIY+D5QQQba+CqYMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900570; c=relaxed/simple;
	bh=C52bEq3TH6+WHwZGbu1J0ND/tgmNrbDcmiG6ddcdr3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uikzVvAscaWb7DSStO/jvKayLijvdEKKrYwrCstltlOvjZjbd56a72yC8H+avIbwm66n7o+j814F7rI7k3C8ETL4jHRF9TMqKtjCJVmtWeb9B3TZHndnALT+28Ip+AalyOzxqgVw7ZJRogc9vAP6RGeKdTxIN6UqOCFzyb2uty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IDkxIKqk; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7Z
	X6gO4s1/g6DTK9BvrcJ2ewwGz0oC37XJnSwSguWaE=; b=IDkxIKqkehwn+oTOWM
	cnDSdutlOLh0dhotRPwJTvS25O0xdfodJ31fZvyCOTUUKJqJ8NGSQB5EfKVYmWCu
	E6frdMIy9TVjf++bteTZzd7srLFKKtD3drIKk+2zsPYHFXpRYuWfsAwa4+afM0e2
	+Hm2K9ZkeZECN0yWBEF85iGR4=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCn5zu4R29pIOfPGw--.26432S3;
	Tue, 20 Jan 2026 17:15:41 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH 1/5] KVM: x86: selftests: Add CPU vendor detection for Hygon
Date: Tue, 20 Jan 2026 17:14:44 +0800
Message-ID: <20260120091449.526798-2-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120091449.526798-1-zhiquan_li@163.com>
References: <20260120091449.526798-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn5zu4R29pIOfPGw--.26432S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFW5Zw48Zr1xJF4kWr1fCrg_yoW5Jw45pF
	ykAr1rKF10gFnxta4xXr4ktryxWrZ7Wa10q3yUZry3Aa12yry7Xrs7Ka4jvrZI9FWrW3s8
	Zas7tF4YgFsrZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRVVb-UUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbC6h43IGlvR77HQgAA3Z

Currently some KVM selftests are failed on Hygon CPUs due to missing
vendor detection and edge-case handling specific to Hygon's
architecture.

Add CPU vendor detection for Hygon and add a global variable
"host_cpu_is_hygon" as the basic facility for the following fixes.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 6 ++++++
 tools/testing/selftests/kvm/lib/x86/processor.c     | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 57d62a425109..9ac18e0fca54 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -21,6 +21,7 @@
 
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
+extern bool host_cpu_is_hygon;
 extern uint64_t guest_tsc_khz;
 
 #ifndef MAX_NR_CPUID_ENTRIES
@@ -701,6 +702,11 @@ static inline bool this_cpu_is_amd(void)
 	return this_cpu_vendor_string_is("AuthenticAMD");
 }
 
+static inline bool this_cpu_is_hygon(void)
+{
+	return this_cpu_vendor_string_is("HygonGenuine");
+}
+
 static inline uint32_t __this_cpu_has(uint32_t function, uint32_t index,
 				      uint8_t reg, uint8_t lo, uint8_t hi)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 36104d27f3d9..bbd3336f22eb 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -21,6 +21,7 @@
 vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
+bool host_cpu_is_hygon;
 bool is_forced_emulation_enabled;
 uint64_t guest_tsc_khz;
 
@@ -671,6 +672,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
 
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
+	sync_global_to_guest(vm, host_cpu_is_hygon);
 	sync_global_to_guest(vm, is_forced_emulation_enabled);
 	sync_global_to_guest(vm, pmu_errata_mask);
 
@@ -1303,6 +1305,7 @@ void kvm_selftest_arch_init(void)
 {
 	host_cpu_is_intel = this_cpu_is_intel();
 	host_cpu_is_amd = this_cpu_is_amd();
+	host_cpu_is_hygon = this_cpu_is_hygon();
 	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
 
 	kvm_init_pmu_errata();
-- 
2.43.0


