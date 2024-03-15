Return-Path: <kvm+bounces-11948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C5B87D727
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC8A9B214C5
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE235A10C;
	Fri, 15 Mar 2024 23:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtGOwhCP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254805B1F4
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543954; cv=none; b=L5G+vHkBZ3YtHoOMwhVlW72ZE79DyXckPG0uqHr1UGF2JQh5MtXPI5tFR24V+jGXwA3s6l9igQ4cwgPYg4ZkV0PrmRevoapVhzZxkJljFgLRHP/q9TOxEzNGzvXoarpj9Pp+E2rb3ZFXZ8g1T+4+ekMbKZTpg/A2O5tlQDbuIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543954; c=relaxed/simple;
	bh=DrjjQDQmTQ6MfjqFz5UMMoMg+e9wqNZYRrpOZI0Q134=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KKjPPlmeNWaMIqbHDrKsnWcbpdcrqebr9FWwcIPGtmf+Im/xV62BXD3+URK67MpGVkWWdup8c+Id/cuLLy23Ly5ya3eQVR8OrcEuYbBYr9TX/DYSiPaELdMUeI/gl73Cl+Soby0uURQASOVrkUgkNuFmOh/eOd5o9qmV7bCNRaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtGOwhCP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cc8d4e1a4so46890617b3.3
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 16:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710543952; x=1711148752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wGLRgFhMbgZdEh1jhanrBdvdUugPHHTzVEIVM0gop9E=;
        b=NtGOwhCPs3AsySU/kFGCGM2fY/qrgr83MhfAvjctMUFZuJir23Yv67q0M6PozNgFLb
         TbBX2ha9Nxc9x4BuJIUSnmYcV8RbfXfnnDtoFY1tJU/EE33LkyrAhDGsFapk6Sjydhnd
         zp44Q2hvZauh6eADRc0XnLzyC43MpnRUiPpNTIw3vEVPAZINk6Hg1kDFv88eH3Zv4hb2
         xQMBTI6U3AsV8RtRift9LgLrlXlTQU9v+J/wkr8NO4can3k2smH7G5KJdQ1goS3DIKzh
         J6IgBRoDnRvdDtmfts489VaEzHh0VpZvBKiMgo3mqBRRTQ92LgNAxRFWxqAP17/PDbpE
         4cKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710543952; x=1711148752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wGLRgFhMbgZdEh1jhanrBdvdUugPHHTzVEIVM0gop9E=;
        b=QPGpQVCJpNGcHMsQtx/bSs/EtFR7tdx0uQURJ7LL/T6tTHjE1HB/Hb/VWPb9Jcosl7
         Oked1bOyzCtO9IJq5CSnybEYY5N+fZI4WxWH7bKmoKI4QRAZSy5W2/bnwbXon98wNGnX
         qM+h77X/JVBBE6f6X/tiF6YSEi3/S/kXfc4rA0R+lehsG8Ctu9PRi9R/tTQHebkYC8Su
         YgEbypNIqMDpAxqrdfYbYg02BNdbQkv62cQw5Qmy2/RK33a6oRh5AFP6g+Hh2MniHGBm
         p4S6uDPFOnlDcJ940Ou03alCW/tgXknspIVsEpcKg8x2qhLzXXrD0oAhx849i3tuVEW5
         kDuA==
X-Forwarded-Encrypted: i=1; AJvYcCVSTGJB1e7Zy5IPy54hHsXBbd3DI7p5psi0IkE1DWO5kbxseeOavnxgThhgLZ8GmWNpg5xzA255vw/DOjSfrNVZOaWH
X-Gm-Message-State: AOJu0YyKdpMeYHGDw/mqK+yX2+zWx8ErgDkaA3zBTjSSQNwEgdQzoFGp
	Vc9wTFoVuNH3TEo8zqYiLPZoTyPz+W733iP1EHCCoHK+HW/Y3AhI/mJGAC6yHjZY8lD8PNBhy4N
	JhW5lQFp6rQ==
X-Google-Smtp-Source: AGHT+IET3wnOuPzj06SPr66uFtMl9XQns+Gvge1Pv6RXnrDimezDYFhd+WpwQybR/shVDEPqnsfUUqqx8bDwog==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:e252:0:b0:60c:29b7:41b5 with SMTP id
 l79-20020a0de252000000b0060c29b741b5mr1328282ywe.6.1710543952272; Fri, 15 Mar
 2024 16:05:52 -0700 (PDT)
Date: Fri, 15 Mar 2024 16:05:41 -0700
In-Reply-To: <20240315230541.1635322-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240315230541.1635322-5-dmatlack@google.com>
Subject: [PATCH 4/4] KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_test
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend vmx_dirty_log_test to include accesses made by L2 when EPT is
disabled.

This commit adds explicit coverage of a bug caught by syzkaller, where
the TDP MMU would clear D-bits instead of write-protecting SPTEs being
used to map an L2, which only happens when L1 does not enable EPT,
causing writes made by L2 to not be reflected in the dirty log when PML
is enabled:

  $ ./vmx_dirty_log_test
  Nested EPT: disabled
  ==== Test Assertion Failure ====
    x86_64/vmx_dirty_log_test.c:151: test_bit(0, bmap)
    pid=72052 tid=72052 errno=4 - Interrupted system call
    (stack trace empty)
    Page 0 incorrectly reported clean

Opportunistically replace the volatile casts with {READ,WRITE}_ONCE().

Link: https://lore.kernel.org/kvm/000000000000c6526f06137f18cc@google.com/
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c | 60 ++++++++++++++-----
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index e4ad5fef52ff..609a767c4655 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -28,16 +28,16 @@
 #define NESTED_TEST_MEM1		0xc0001000
 #define NESTED_TEST_MEM2		0xc0002000
 
-static void l2_guest_code(void)
+static void l2_guest_code(u64 *a, u64 *b)
 {
-	*(volatile uint64_t *)NESTED_TEST_MEM1;
-	*(volatile uint64_t *)NESTED_TEST_MEM1 = 1;
+	READ_ONCE(*a);
+	WRITE_ONCE(*a, 1);
 	GUEST_SYNC(true);
 	GUEST_SYNC(false);
 
-	*(volatile uint64_t *)NESTED_TEST_MEM2 = 1;
+	READ_ONCE(*b);
 	GUEST_SYNC(true);
-	*(volatile uint64_t *)NESTED_TEST_MEM2 = 1;
+	WRITE_ONCE(*b, 1);
 	GUEST_SYNC(true);
 	GUEST_SYNC(false);
 
@@ -45,17 +45,33 @@ static void l2_guest_code(void)
 	vmcall();
 }
 
+static void l2_guest_code_ept_enabled(void)
+{
+	l2_guest_code((u64 *)NESTED_TEST_MEM1, (u64 *)NESTED_TEST_MEM2);
+}
+
+static void l2_guest_code_ept_disabled(void)
+{
+	/* Access the same L1 GPAs as l2_guest_code_ept_enabled() */
+	l2_guest_code((u64 *)GUEST_TEST_MEM, (u64 *)GUEST_TEST_MEM);
+}
+
 void l1_guest_code(struct vmx_pages *vmx)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	void *l2_rip;
 
 	GUEST_ASSERT(vmx->vmcs_gpa);
 	GUEST_ASSERT(prepare_for_vmx_operation(vmx));
 	GUEST_ASSERT(load_vmcs(vmx));
 
-	prepare_vmcs(vmx, l2_guest_code,
-		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	if (vmx->eptp_gpa)
+		l2_rip = l2_guest_code_ept_enabled;
+	else
+		l2_rip = l2_guest_code_ept_disabled;
+
+	prepare_vmcs(vmx, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	GUEST_SYNC(false);
 	GUEST_ASSERT(!vmlaunch());
@@ -64,7 +80,7 @@ void l1_guest_code(struct vmx_pages *vmx)
 	GUEST_DONE();
 }
 
-int main(int argc, char *argv[])
+static void test_vmx_dirty_log(bool enable_ept)
 {
 	vm_vaddr_t vmx_pages_gva = 0;
 	struct vmx_pages *vmx;
@@ -76,8 +92,7 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	bool done = false;
 
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
-	TEST_REQUIRE(kvm_cpu_has_ept());
+	pr_info("Nested EPT: %s\n", enable_ept ? "enabled" : "disabled");
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
@@ -103,11 +118,16 @@ int main(int argc, char *argv[])
 	 *
 	 * Note that prepare_eptp should be called only L1's GPA map is done,
 	 * meaning after the last call to virt_map.
+	 *
+	 * When EPT is disabled, the L2 guest code will still access the same L1
+	 * GPAs as the EPT enabled case.
 	 */
-	prepare_eptp(vmx, vm, 0);
-	nested_map_memslot(vmx, vm, 0);
-	nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
-	nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
+	if (enable_ept) {
+		prepare_eptp(vmx, vm, 0);
+		nested_map_memslot(vmx, vm, 0);
+		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
+		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
+	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
 	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
@@ -148,3 +168,15 @@ int main(int argc, char *argv[])
 		}
 	}
 }
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	test_vmx_dirty_log(/*enable_ept=*/false);
+
+	if (kvm_cpu_has_ept())
+		test_vmx_dirty_log(/*enable_ept=*/true);
+
+	return 0;
+}
-- 
2.44.0.291.gc1ea87d7ee-goog


