Return-Path: <kvm+bounces-46903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3397BABA59F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1144D3AC6B7
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8C7280A4C;
	Fri, 16 May 2025 21:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pzm6RbEU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9056280007
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747432761; cv=none; b=SYY/+kUyhFFZAxTo0yWbHaMmOlJCHkj5pdKXBx2cYDbUDe0sOaP7xIjMH2EAzzaSyeyjsl7XAjmHS7awY/FO+VzS4w7jXOQiHJG3Iwuwdazzl3BU4NKIEFB2Yj8KmGnGGfsqf+IHqwyZLCpcHRZvJSI9aCpU9oX4EVZOd07TwXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747432761; c=relaxed/simple;
	bh=g/go1qPaDWwik2ajMGyD/ChS9WlSP8Y7lcyUF+0Lue0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Aa9gXpVg3jECbbLMnDI4Jm56+58HkwhPtKpaMtHFrbGPOBBCbQ/sLW3ZjtDj4W1JX7wX4vamFRwKpEk/K6K4wDS/gNE4hmvhPBeAbs5FwR2PN/yv/8vKsbI44X/0FJPlxoMvr/AW+kgaLKopIHabzvsVIsZPgnsXaY3GKe4SUdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pzm6RbEU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so2727529a12.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747432758; x=1748037558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l3nNlVUvO2lcUj8RcxSSosFUJbxSSdk1JxW52pofM28=;
        b=Pzm6RbEUF5kup/TBRdxt8XmPIezpvmicI/K2OqPonTDnu5bvsMrgLkU+RVgc4pvKnE
         5BRKmDO9OQZkDzakLqc7TVy0s6Q5CbZNqt8+nQRDOq7WkSrga88T7LrnEq48WBOJmL5D
         KE8vFtQRklnZRzlSuFMZbq392NfQOnLURX7TwKeegIeFDrgF5ucXuzyln0MJdP901XTr
         x7z2YodYGSMAVF2F1tRjfcjbqmJ1RSPwkaNvrtlmiqiaR7GM6jiAXpAy7ccoGZoAzW9Z
         JNNgGC/GMQVPqm3pKo62AMnkj7utOZQUiCTNnXcGnRg18TFvciUJH+AMFdpT6h+CVuzk
         pOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747432758; x=1748037558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3nNlVUvO2lcUj8RcxSSosFUJbxSSdk1JxW52pofM28=;
        b=Jk78FAnFTXhKeUUY/pJeovFwLqtgrKb54ZbXKzuQfGBHK1taTDzUi7Bj4b1Fs9aEws
         mPbz/4BlOdMIop6lK9xY5sN/LXBp0qZc596ZzvBWJ58p6F/J7uVTEtyhsSFmF9Utxish
         rUEhhhpZ4gg7w6cpFkhjiQRI5Tk6vXbPF43TgNlfDYGHWa0qGBEnWial/nM1Y62RJCCh
         NW5WSYLjb7bMN81iWVQ+7WMV1iSzadeo7pwI9WEb4Ya0n3o/+A8OXErsraMK67lsC7x9
         ATc0mRu4vF4As/FH6ZUxcSjtVNT54Q/bDEsQeoS0xAFlx5hJ3Xs1DsIZprwMCZm/aqQE
         pCgA==
X-Gm-Message-State: AOJu0YwaEW2c1PSs6dwyWtZQGlEYuL3SfAo0rD73Vgin3erdWmTcwAxc
	HNjwywoNYmitmKFmoINo5Kk6F1y/osqsY0hCiS8v2Ng0rPg9M1lwvGLPlBpNXoypo0qyWnt4D/y
	MAVBtfA==
X-Google-Smtp-Source: AGHT+IHUOTee0P07hQeTysg+Uvi4l85B+YRvOoTaJtEIwFy4sXiKwr45OYiwajuSHQOORPy4lBm1AX3WxDI=
X-Received: from pjbpd3.prod.google.com ([2002:a17:90b:1dc3:b0:2f9:e05f:187f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d47:b0:2ee:9e06:7db0
 with SMTP id 98e67ed59e1d1-30e830fbe8fmr5513546a91.11.1747432758258; Fri, 16
 May 2025 14:59:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:59:06 -0700
In-Reply-To: <20250516215909.2551628-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215909.2551628-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516215909.2551628-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: selftests: Verify KVM is loaded when getting a KVM
 module param
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Probe /dev/kvm when getting a KVM module param so that attempting to load
a module param super early in a selftest generates a SKIP message about
KVM not being loaded/enabled, versus some random parameter not existing.

E.g. KVM x86's unconditional retrieval of force_emulation_prefix during
kvm_selftest_arch_init() generates a rather confusing error message that
takes far too much triage to understand.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h    |  6 +++++-
 tools/testing/selftests/kvm/lib/kvm_util.c             |  3 +++
 tools/testing/selftests/kvm/lib/x86/processor.c        | 10 ----------
 .../kvm/x86/vmx_exception_with_invalid_guest_state.c   |  2 +-
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index b11b5a53ebd5..2efb05c2f2fb 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1150,7 +1150,6 @@ do {											\
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 void kvm_init_vm_address_properties(struct kvm_vm *vm);
-bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 struct ex_regs {
 	uint64_t rax, rcx, rdx, rbx;
@@ -1325,6 +1324,11 @@ static inline bool kvm_is_forced_emulation_enabled(void)
 	return !!get_kvm_param_integer("force_emulation_prefix");
 }
 
+static inline bool kvm_is_unrestricted_guest_enabled(void)
+{
+	return get_kvm_intel_param_bool("unrestricted_guest");
+}
+
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 50edc59cc0ca..b21ba80e3015 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -64,6 +64,9 @@ static ssize_t get_module_param(const char *module_name, const char *param,
 	ssize_t bytes_read;
 	int fd, r;
 
+	/* Verify KVM is loaded, to provide a more helpful SKIP message. */
+	close(open_kvm_dev_path_or_exit());
+
 	r = snprintf(path, path_size, "/sys/module/%s/parameters/%s",
 		     module_name, param);
 	TEST_ASSERT(r < path_size,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index a92dc1dad085..d4c19ac885a9 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1264,16 +1264,6 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 	return min(max_gfn, ht_gfn - 1);
 }
 
-/* Returns true if kvm_intel was loaded with unrestricted_guest=1. */
-bool vm_is_unrestricted_guest(struct kvm_vm *vm)
-{
-	/* Ensure that a KVM vendor-specific module is loaded. */
-	if (vm == NULL)
-		close(open_kvm_dev_path_or_exit());
-
-	return get_kvm_intel_param_bool("unrestricted_guest");
-}
-
 void kvm_selftest_arch_init(void)
 {
 	host_cpu_is_intel = this_cpu_is_intel();
diff --git a/tools/testing/selftests/kvm/x86/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86/vmx_exception_with_invalid_guest_state.c
index 3fd6eceab46f..2cae86d9d5e2 100644
--- a/tools/testing/selftests/kvm/x86/vmx_exception_with_invalid_guest_state.c
+++ b/tools/testing/selftests/kvm/x86/vmx_exception_with_invalid_guest_state.c
@@ -110,7 +110,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 
 	TEST_REQUIRE(host_cpu_is_intel);
-	TEST_REQUIRE(!vm_is_unrestricted_guest(NULL));
+	TEST_REQUIRE(!kvm_is_unrestricted_guest_enabled());
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	get_set_sigalrm_vcpu(vcpu);
-- 
2.49.0.1112.g889b7c5bd8-goog


