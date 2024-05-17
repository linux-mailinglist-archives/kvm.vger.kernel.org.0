Return-Path: <kvm+bounces-17656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D85D98C8B4F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E290282F66
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F044B13FD94;
	Fri, 17 May 2024 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IdIccW2H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978E713E8A4
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967594; cv=none; b=NQ5HeAuELniP6cGNnJpxvG8m6/XedVU85kon9Hwmq1j+mpQsLXYTk4zOLD+p/JdbKASed85s/HU9+grV0Y0Z2hOLSdD7Ui2vm8sxS1/GmlN6FfT0MpaO4j3daxTDPdetLov5A5xawscZZGVAVfsnyGwXnnXTtVqPhSNxHrl35zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967594; c=relaxed/simple;
	bh=1NGVeFJTwnKqwtkUG/0Mo2/yDSBezb4ZOJiMgBnbNBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sdGLCom4bUHChKIdDoBdk0w9IUP/BNNCIkM18zS0IR8KiowRKbMn9CD/nyjYiBfDViFvTtAZyedLVPqfXTWa5njv0c1RLyXcaNaQm1pGfFwf+BHqE8aWg7CgDjCk6+Ybv9cwhmrbNeop2pA6sa1hWxic6xYXfWdQ1PCUn+S7aho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IdIccW2H; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-62a379a7c80so5436021a12.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967592; x=1716572392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WlHXFrxNvUU8/ovGwpioncXLO5B94WPjDBBVkcyaDOo=;
        b=IdIccW2HvyAN8HiAxYSZ7V7oBjWnFlm253DvcP0rRjIHc9Er8ewwx9EME3Td/Ubkbw
         ofUqtjIyAYgu7DnlVGmHgvAwn301RYGZCcgvpiMpaFbFw+htIe0Ki1LF4Zp7dMsd4ydo
         oToeHoa3PBIqK1DGgSQFDLDuPoe3WUZ2hVg7euYkjWFOwPJqlCrfrBI/CVVpBesg07pw
         scv+VLAhqndFL73kiVs3IhPlx+UzhIWynqqAjF0T0PEW6aQUVphSQVmcf/VfDKbkdOhu
         JlyTE1xPThtNJth64WsPpbt3IICzgiO4KteRQZzWNrnICQ6bsN4Osy1rBV5rTOGmEkhc
         8U0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967592; x=1716572392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WlHXFrxNvUU8/ovGwpioncXLO5B94WPjDBBVkcyaDOo=;
        b=dhLtWofGeFpJTwku9ucQ3U7sC2CLD1ZTGqQvJ6KANtL3kOWfo1B4obnocSdR+4Ll6O
         0Z9NOUtbc8JgMeZ+1IXKerTPPK80qTJkMLqUVxPtBwwKedgsIYsdLcPN3kf9lhv7O+1h
         1qBgVLiJXfH0xn8vO+Ewsdhq6MN7q9x/k34GiDRXd6if5+hkv/2JkTUuVtSXPMLMVaWQ
         METapaib3aaokrfIrDXB4DuKlA1p9V3tjaSbPc3HhO/8ssDLCHfb++dv+DyS2Kis32w5
         lzZqtvifSEEj3ZJBATciGo6Db3nLlIqUB7Xb5WUoH35CN+wmfasKNzyGQe1Suti8ryUL
         8TTA==
X-Gm-Message-State: AOJu0YzSI76YGQBZv2tngDKJfIOx+Um9aCNY+0S3LfD6oHu5if6ruaNx
	pEbcSfZpo5P31tPX0FAw68jsfO8x0xfYz+YhLonZwfIQTMSHnMpNhCpsjPPZzcTmin0Ps68dZbW
	LwA==
X-Google-Smtp-Source: AGHT+IEo/ZT8iksXsl2NGXbckjhVrzEeHvidOdAipz5skx6UAULtkHeIsjq3fj4r2tsy29GoQwhPZhMcV0o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:90d:b0:65b:c48c:154c with SMTP id
 41be03b00d2f7-65bc48c163emr12702a12.5.1715967591942; Fri, 17 May 2024
 10:39:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:41 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-5-seanjc@google.com>
Subject: [PATCH v2 04/49] KVM: selftests: Update x86's set_sregs_test to match
 KVM's CPUID enforcement
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Rework x86's set sregs test to verify that KVM enforces CPUID vs. CR4
features even if userspace hasn't explicitly set guest CPUID.  KVM used to
allow userspace to set any KVM-supported CR4 value prior to KVM_SET_CPUID2,
and the test verified that behavior.

However, the testcase was written purely to verify KVM's existing behavior,
i.e. was NOT written to match the needs of real world VMMs.

Opportunistically verify that KVM continues to reject unsupported features
after KVM_SET_CPUID2 (using KVM_GET_SUPPORTED_CPUID).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/set_sregs_test.c     | 53 +++++++++++--------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index c021c0795a96..96fd690d479a 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -41,13 +41,15 @@ do {										\
 	TEST_ASSERT(!memcmp(&new, &orig, sizeof(new)), "KVM modified sregs");	\
 } while (0)
 
+#define KVM_ALWAYS_ALLOWED_CR4 (X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD |	\
+				X86_CR4_DE | X86_CR4_PSE | X86_CR4_PAE |	\
+				X86_CR4_MCE | X86_CR4_PGE | X86_CR4_PCE |	\
+				X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT)
+
 static uint64_t calc_supported_cr4_feature_bits(void)
 {
-	uint64_t cr4;
+	uint64_t cr4 = KVM_ALWAYS_ALLOWED_CR4;
 
-	cr4 = X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE |
-	      X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE | X86_CR4_PGE |
-	      X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT;
 	if (kvm_cpu_has(X86_FEATURE_UMIP))
 		cr4 |= X86_CR4_UMIP;
 	if (kvm_cpu_has(X86_FEATURE_LA57))
@@ -72,28 +74,14 @@ static uint64_t calc_supported_cr4_feature_bits(void)
 	return cr4;
 }
 
-int main(int argc, char *argv[])
+static void test_cr_bits(struct kvm_vcpu *vcpu, uint64_t cr4)
 {
 	struct kvm_sregs sregs;
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-	uint64_t cr4;
 	int rc, i;
 
-	/*
-	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
-	 * use it to verify all supported CR4 bits can be set prior to defining
-	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
-	 */
-	vm = vm_create_barebones();
-	vcpu = __vm_vcpu_add(vm, 0);
-
 	vcpu_sregs_get(vcpu, &sregs);
-
-	sregs.cr0 = 0;
-	sregs.cr4 |= calc_supported_cr4_feature_bits();
-	cr4 = sregs.cr4;
-
+	sregs.cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
+	sregs.cr4 |= cr4;
 	rc = _vcpu_sregs_set(vcpu, &sregs);
 	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
 
@@ -101,7 +89,6 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
 		    sregs.cr4, cr4);
 
-	/* Verify all unsupported features are rejected by KVM. */
 	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_UMIP);
 	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_LA57);
 	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_VMXE);
@@ -119,10 +106,28 @@ int main(int argc, char *argv[])
 	/* NW without CD is illegal, as is PG without PE. */
 	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_NW);
 	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_PG);
+}
 
+int main(int argc, char *argv[])
+{
+	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int rc;
+
+	/*
+	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
+	 * use it to verify KVM enforces guest CPUID even if *userspace* never
+	 * sets CPUID.
+	 */
+	vm = vm_create_barebones();
+	vcpu = __vm_vcpu_add(vm, 0);
+	test_cr_bits(vcpu, KVM_ALWAYS_ALLOWED_CR4);
 	kvm_vm_free(vm);
 
-	/* Create a "real" VM and verify APIC_BASE can be set. */
+	/* Create a "real" VM with a fully populated guest CPUID and verify
+	 * APIC_BASE and all supported CR4 can be set.
+	 */
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
 	vcpu_sregs_get(vcpu, &sregs);
@@ -135,6 +140,8 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(!rc, "Couldn't set IA32_APIC_BASE to %llx (valid)",
 		    sregs.apic_base);
 
+	test_cr_bits(vcpu, calc_supported_cr4_feature_bits());
+
 	kvm_vm_free(vm);
 
 	return 0;
-- 
2.45.0.215.g3402c0e53f-goog


