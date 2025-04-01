Return-Path: <kvm+bounces-42363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A5AA7801D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 986661891CED
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277C7224AEB;
	Tue,  1 Apr 2025 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e8ltetUC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E4224895
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523954; cv=none; b=KAFb0MRXYV6bV2Kh63OPUrwHEbwU3VWpreT8k8jxTV1o4YxuUViEE9i9LL2jB+Tt4h0lVcv4owi550XWBd94uuHTPz616NHcKCEKiqRMYYs/TX3Oy5tAb5bIsWFNsUFx4/SflkdFY0XmBNb6qlTuV3WwVfjUNyt7OrIYXdcQ0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523954; c=relaxed/simple;
	bh=qiOLED8BkRze4KF+KMmrHA+MJ7cag8ndXy7QMTI4Sw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afEhdOCC2dvo0TCxk5xyc4NVAP0mzw5HhgqprbKPJZCEqqKq2lcZEOW7wzxtt9SzrvWNA7ZiyQ5n76fkMEwGtYv0NTPutUa73zCqx3GVh1lzPMzm2RxpTPVCV3LpwBYym4ydMywrsCGd7Lb3q3DXx2P9mr+NZgvSCcgtutMtamA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e8ltetUC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tPLDTEU28EVlLVRImtt+kppWrpwzBYCScgMp8fqLlvI=;
	b=e8ltetUCCmMGBy/1mpEaWFftDwNG9z4/kkdfB+8Cv+M8SLU7KESbJFUHmCS6cfg3P4h94Y
	In4/2KWLQOOCKu2U/p1HRrJqoudu3nduG/jWcU6WGvZj+XLRqzbk5JBk1f6kD3os456DXM
	LNosIUg9Lp/u8iP5bBfydTso8VShbS8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-6VgV04jHMdaA2dctVKFQPg-1; Tue, 01 Apr 2025 12:12:30 -0400
X-MC-Unique: 6VgV04jHMdaA2dctVKFQPg-1
X-Mimecast-MFC-AGG-ID: 6VgV04jHMdaA2dctVKFQPg_1743523949
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so47376495e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523948; x=1744128748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tPLDTEU28EVlLVRImtt+kppWrpwzBYCScgMp8fqLlvI=;
        b=lFEHkP/XYb/mnbTYqoOjuzPhtqMV5APJjEgrd2duDDTXvH7kEP56VqSpA5v/zn19vt
         AZ7w6oMkjIFJNZBuQEPSwehvCI7aMsRizc5K+U8mWMMdHezud34FyTn1+gZL0WSq6Eem
         k7DN6hyIgR/Oxc6j2WMBtd8Ao40J381lm7TOGqSzNAEJX2QFF7RidvaAzppqNDerqc/k
         G70xfPAbRiXpRSjvCxlZIsoiaxB0w/x7ujYiR/woWi++3gq1pOmxHKtgyB3uDpot/Uqe
         IH9qGbGJI/FRRY9fYal1xKQRuBeSb2f9mayrYczdkCeC4/Ff5KaX6k8AsfbyS0piE6To
         Xj7A==
X-Forwarded-Encrypted: i=1; AJvYcCULqXrji7NBTTjKmap8ntd7CN3uAQCcvlA+LzACOslwSdcA1LhWxfvr1lKh4w1rWizBvlA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhk1958XolezEGvoiuc/Pk/YJEsHJh3rDgu623qP6gSuNd62aP
	kHxtLR0QmPV+Bfk7nOCvblO7cdyfCSoxjtPPs2BUWLoqHgDtuhGaZMFuZKLlwxpIMMJpQP2kcT2
	d53kcL4v+3haa54d2PoqitcvHb98Qnu0YiPfTcuCtVVd3LJ8Jni/Aw2tr7w==
X-Gm-Gg: ASbGncuTgDF06oBJTYB/f3ddbZ615dLUJINPY02Y1KnRPgX1jm9+3IwRqt5Ljzt3khn
	2Hy8mHEIeQXJzimvegCjQKIlx9WEW2Ubj3MqoLCMWz1o93ZS2ytOKT/GI9vqcQDor49P1hPa95X
	Yv2lfUFIC53VL1isRktoVRNquYx24aR1XFb6p1l1HXF5Q9oFpi3P2MLCHYLVY1S06jCjiW5IdRv
	MX00lpcXMBOEOw9tnWF78GqZxdmD+ntko2euX/TVEbpdmRh+4VmoycBjy01hUwgUfo6Kq/dejo1
	OSOd1wOWXaDgCalMVVhGYw==
X-Received: by 2002:a05:6000:2913:b0:391:122c:8b2 with SMTP id ffacd0b85a97d-39c120e1566mr11925035f8f.31.1743523948530;
        Tue, 01 Apr 2025 09:12:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEasAFSdvxOC3yWEZX6iq1LZ/fATrSFrxZYBcxLlTIQzYSIpNJNzx61Lq79fmq0JTbS0oYjw==
X-Received: by 2002:a05:6000:2913:b0:391:122c:8b2 with SMTP id ffacd0b85a97d-39c120e1566mr11924994f8f.31.1743523948129;
        Tue, 01 Apr 2025 09:12:28 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ea8d2bc7fsm13944985e9.0.2025.04.01.09.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:26 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 29/29] selftests: kvm: add x86-specific plane test
Date: Tue,  1 Apr 2025 18:11:06 +0200
Message-ID: <20250401161106.790710-30-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new test for x86-specific behavior such as vCPU state sharing
and interrupts.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   1 +
 .../testing/selftests/kvm/lib/x86/processor.c |  15 +
 tools/testing/selftests/kvm/x86/plane_test.c  | 270 ++++++++++++++++++
 4 files changed, 287 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/plane_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index b1d0b410cc03..9d94db9d750f 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -82,6 +82,7 @@ TEST_GEN_PROGS_x86 += x86/kvm_pv_test
 TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
 TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
+TEST_GEN_PROGS_x86 += x86/plane_test
 TEST_GEN_PROGS_x86 += x86/platform_info_test
 TEST_GEN_PROGS_x86 += x86/pmu_counters_test
 TEST_GEN_PROGS_x86 += x86/pmu_event_filter_test
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 32ab6ca7ec32..cf2095f3a7d5 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1106,6 +1106,7 @@ static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 
 uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index);
 int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value);
+int _plane_vcpu_set_msr(struct kvm_plane_vcpu *plane_vcpu, uint64_t msr_index, uint64_t msr_value);
 
 /*
  * Assert on an MSR access(es) and pretty print the MSR name when possible.
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index bd5a802fa7a5..b4431ca7fbca 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -917,6 +917,21 @@ uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index)
 	return buffer.entry.data;
 }
 
+int _plane_vcpu_set_msr(struct kvm_plane_vcpu *plane_vcpu, uint64_t msr_index, uint64_t msr_value)
+{
+	struct {
+		struct kvm_msrs header;
+		struct kvm_msr_entry entry;
+	} buffer = {};
+
+	memset(&buffer, 0, sizeof(buffer));
+	buffer.header.nmsrs = 1;
+	buffer.entry.index = msr_index;
+	buffer.entry.data = msr_value;
+
+	return __plane_vcpu_ioctl(plane_vcpu, KVM_SET_MSRS, &buffer.header);
+}
+
 int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value)
 {
 	struct {
diff --git a/tools/testing/selftests/kvm/x86/plane_test.c b/tools/testing/selftests/kvm/x86/plane_test.c
new file mode 100644
index 000000000000..0fdd8a066723
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/plane_test.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Red Hat, Inc.
+ *
+ * Test for x86-specific VM plane functionality
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "apic.h"
+#include "asm/kvm.h"
+#include "linux/kvm.h"
+
+static void test_plane_regs(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_plane *plane;
+	struct kvm_plane_vcpu *plane_vcpu;
+
+	struct kvm_regs regs0, regs1;
+
+	vm = vm_create_barebones();
+	vcpu = __vm_vcpu_add(vm, 0);
+	plane = vm_plane_add(vm, 1);
+	plane_vcpu = __vm_plane_vcpu_add(vcpu, plane);
+
+	vcpu_ioctl(vcpu, KVM_GET_REGS, &regs0);
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_REGS, &regs1);
+	regs0.rax = 0x12345678;
+	regs1.rax = 0x87654321;
+
+	vcpu_ioctl(vcpu, KVM_SET_REGS, &regs0);
+	plane_vcpu_ioctl(plane_vcpu, KVM_SET_REGS, &regs1);
+
+	vcpu_ioctl(vcpu, KVM_GET_REGS, &regs0);
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_REGS, &regs1);
+	TEST_ASSERT_EQ(regs0.rax, 0x12345678);
+	TEST_ASSERT_EQ(regs1.rax, 0x87654321);
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("get/set regs for planes\n");
+}
+
+/* Offset of XMM0 in the legacy XSAVE area.  */
+#define XSTATE_BV_OFFSET	(0x200/4)
+#define XMM_OFFSET		(0xa0/4)
+#define PKRU_OFFSET		(0xa80/4)
+
+static void test_plane_fpu_nonshared(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_plane *plane;
+	struct kvm_plane_vcpu *plane_vcpu;
+
+	struct kvm_xsave xsave0, xsave1;
+
+	vm = vm_create_barebones();
+	TEST_ASSERT_EQ(vm_check_cap(vm, KVM_CAP_PLANES_FPU), false);
+
+	vcpu = __vm_vcpu_add(vm, 0);
+	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
+	vcpu_set_cpuid(vcpu);
+
+	plane = vm_plane_add(vm, 1);
+	plane_vcpu = __vm_plane_vcpu_add(vcpu, plane);
+
+	vcpu_ioctl(vcpu, KVM_GET_XSAVE, &xsave0);
+	xsave0.region[XSTATE_BV_OFFSET] |= XFEATURE_MASK_FP | XFEATURE_MASK_SSE;
+	xsave0.region[XMM_OFFSET] = 0x12345678;
+	vcpu_ioctl(vcpu, KVM_SET_XSAVE, &xsave0);
+
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_XSAVE, &xsave1);
+	xsave1.region[XSTATE_BV_OFFSET] |= XFEATURE_MASK_FP | XFEATURE_MASK_SSE;
+	xsave1.region[XMM_OFFSET] = 0x87654321;
+	plane_vcpu_ioctl(plane_vcpu, KVM_SET_XSAVE, &xsave1);
+
+	memset(&xsave0, 0, sizeof(xsave0));
+	vcpu_ioctl(vcpu, KVM_GET_XSAVE, &xsave0);
+	TEST_ASSERT_EQ(xsave0.region[XMM_OFFSET], 0x12345678);
+
+	memset(&xsave1, 0, sizeof(xsave0));
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_XSAVE, &xsave1);
+	TEST_ASSERT_EQ(xsave1.region[XMM_OFFSET], 0x87654321);
+
+	ksft_test_result_pass("get/set FPU not shared across planes\n");
+}
+
+static void test_plane_fpu_shared(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_plane *plane;
+	struct kvm_plane_vcpu *plane_vcpu;
+
+	struct kvm_xsave xsave0, xsave1;
+
+	vm = vm_create_barebones();
+	vm_enable_cap(vm, KVM_CAP_PLANES_FPU, 1ul);
+	TEST_ASSERT_EQ(vm_check_cap(vm, KVM_CAP_PLANES_FPU), true);
+
+	vcpu = __vm_vcpu_add(vm, 0);
+	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
+	vcpu_set_cpuid(vcpu);
+
+	plane = vm_plane_add(vm, 1);
+	plane_vcpu = __vm_plane_vcpu_add(vcpu, plane);
+
+	vcpu_ioctl(vcpu, KVM_GET_XSAVE, &xsave0);
+
+	xsave0.region[XSTATE_BV_OFFSET] |= XFEATURE_MASK_FP | XFEATURE_MASK_SSE;
+	xsave0.region[XMM_OFFSET] = 0x12345678;
+	vcpu_ioctl(vcpu, KVM_SET_XSAVE, &xsave0);
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_XSAVE, &xsave1);
+	TEST_ASSERT_EQ(xsave1.region[XMM_OFFSET], 0x12345678);
+
+	xsave1.region[XSTATE_BV_OFFSET] |= XFEATURE_MASK_FP | XFEATURE_MASK_SSE;
+	xsave1.region[XMM_OFFSET] = 0x87654321;
+	plane_vcpu_ioctl(plane_vcpu, KVM_SET_XSAVE, &xsave1);
+	vcpu_ioctl(vcpu, KVM_GET_XSAVE, &xsave0);
+	TEST_ASSERT_EQ(xsave0.region[XMM_OFFSET], 0x87654321);
+
+	ksft_test_result_pass("get/set FPU shared across planes\n");
+
+	if (!this_cpu_has(X86_FEATURE_PKU)) {
+		ksft_test_result_skip("get/set PKRU with shared FPU\n");
+		goto exit;
+	}
+
+	xsave0.region[XSTATE_BV_OFFSET] = XFEATURE_MASK_PKRU;
+	xsave0.region[PKRU_OFFSET] = 0xffffffff;
+	vcpu_ioctl(vcpu, KVM_SET_XSAVE, &xsave0);
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_XSAVE, &xsave0);
+
+	xsave0.region[XSTATE_BV_OFFSET] = XFEATURE_MASK_PKRU;
+	xsave0.region[PKRU_OFFSET] = 0xaaaaaaaa;
+	vcpu_ioctl(vcpu, KVM_SET_XSAVE, &xsave0);
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_XSAVE, &xsave1);
+	assert(xsave1.region[PKRU_OFFSET] == 0xffffffff);
+
+	xsave1.region[XSTATE_BV_OFFSET] = XFEATURE_MASK_PKRU;
+	xsave1.region[PKRU_OFFSET] = 0x55555555;
+	plane_vcpu_ioctl(plane_vcpu, KVM_SET_XSAVE, &xsave1);
+	vcpu_ioctl(vcpu, KVM_GET_XSAVE, &xsave0);
+	assert(xsave0.region[PKRU_OFFSET] == 0xaaaaaaaa);
+
+	ksft_test_result_pass("get/set PKRU with shared FPU\n");
+
+exit:
+	kvm_vm_free(vm);
+}
+
+#define APIC_SPIV		0xF0
+#define APIC_IRR		0x200
+
+#define MYVEC			192
+
+#define MAKE_MSI(cpu, vector) ((struct kvm_msi){		\
+	.address_lo = APIC_DEFAULT_GPA + (((cpu) & 0xff) << 8),	\
+	.address_hi = (cpu) & ~0xff,				\
+	.data = (vector),					\
+})
+
+static bool has_irr(struct kvm_lapic_state *apic, int vector)
+{
+	int word = vector >> 5;
+	int bit_in_word = vector & 31;
+	int bit = (APIC_IRR + word * 16) * CHAR_BIT + (bit_in_word & 31);
+
+	return apic->regs[bit >> 3] & (1 << (bit & 7));
+}
+
+static void do_enable_lapic(struct kvm_lapic_state *apic)
+{
+	/* set bit 8 */
+	apic->regs[APIC_SPIV + 1] |= 1;
+}
+
+static void test_plane_msi(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_plane *plane;
+	struct kvm_plane_vcpu *plane_vcpu;
+	int r;
+
+	struct kvm_msi msi = MAKE_MSI(0, MYVEC);
+	struct kvm_lapic_state lapic0, lapic1;
+
+	vm = __vm_create(VM_SHAPE_DEFAULT, 1, 0);
+
+	vcpu = __vm_vcpu_add(vm, 0);
+	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
+	vcpu_set_cpuid(vcpu);
+
+	plane = vm_plane_add(vm, 1);
+	plane_vcpu = __vm_plane_vcpu_add(vcpu, plane);
+
+	vcpu_set_msr(vcpu, MSR_IA32_APICBASE,
+		     APIC_DEFAULT_GPA | MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &lapic0);
+	do_enable_lapic(&lapic0);
+	vcpu_ioctl(vcpu, KVM_SET_LAPIC, &lapic0);
+
+	_plane_vcpu_set_msr(plane_vcpu, MSR_IA32_APICBASE,
+			    APIC_DEFAULT_GPA | MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_LAPIC, &lapic1);
+	do_enable_lapic(&lapic1);
+	plane_vcpu_ioctl(plane_vcpu, KVM_SET_LAPIC, &lapic1);
+
+	r = __plane_ioctl(plane, KVM_SIGNAL_MSI, &msi);
+	TEST_ASSERT(r == 1,
+		   "Delivering interrupt to plane 1. ret: %d, errno: %d", r, errno);
+
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &lapic0);
+	TEST_ASSERT(!has_irr(&lapic0, MYVEC), "Vector clear in plane 0");
+	plane_vcpu_ioctl(plane_vcpu, KVM_GET_LAPIC, &lapic1);
+	TEST_ASSERT(has_irr(&lapic1, MYVEC), "Vector set in plane 1");
+
+	/* req_exit_planes always has priority */
+	vcpu->run->req_exit_planes = (1 << 1);
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_PLANE_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->plane_event.cause, KVM_PLANE_EVENT_INTERRUPT);
+	TEST_ASSERT_EQ(vcpu->run->plane_event.pending_event_planes, (1 << 1));
+	TEST_ASSERT_EQ(vcpu->run->plane_event.target, (1 << 1));
+
+	r = __vm_ioctl(vm, KVM_SIGNAL_MSI, &msi);
+	TEST_ASSERT(r == 1,
+		   "Delivering interrupt to plane 0. ret: %d, errno: %d", r, errno);
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &lapic0);
+	TEST_ASSERT(has_irr(&lapic0, MYVEC), "Vector set in plane 0");
+
+	/* req_exit_planes ignores current plane; current plane is cleared */
+	vcpu->run->plane = 1;
+	vcpu->run->req_exit_planes = (1 << 0) | (1 << 1);
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_PLANE_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->plane_event.cause, KVM_PLANE_EVENT_INTERRUPT);
+	TEST_ASSERT_EQ(vcpu->run->plane_event.pending_event_planes, (1 << 0));
+	TEST_ASSERT_EQ(vcpu->run->plane_event.target, (1 << 0));
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("signal MSI for planes\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int cap_planes = kvm_check_cap(KVM_CAP_PLANES);
+	TEST_REQUIRE(cap_planes && cap_planes > 1);
+
+	ksft_print_header();
+	ksft_set_plan(5);
+
+	pr_info("# KVM_CAP_PLANES: %d\n", cap_planes);
+
+	test_plane_regs();
+	test_plane_fpu_nonshared();
+	test_plane_fpu_shared();
+	test_plane_msi();
+
+	ksft_finished();
+}
-- 
2.49.0


