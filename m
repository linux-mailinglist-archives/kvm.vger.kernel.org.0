Return-Path: <kvm+bounces-27598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BED5987C1E
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 02:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B614C1F2483C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BF512FB1B;
	Fri, 27 Sep 2024 00:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kskN3XVT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7448F3A1A8
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 00:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727396205; cv=none; b=V6c7eIZTDNQqRdw2MwiJr4cjQNHXUm7H/aYSUUA+AvyUnHeCSDLvqwdDzZd3c+dlY9Vcx/nE43Zb7bs6B1OKZQKS2mNKRcEbGVj1WPiJ/9FS69UlCQx1qtZEcWkfQs6UqC7fV+++UWEiNYZ406eWLQ6UvHcEO1EDdgS8qYsyHCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727396205; c=relaxed/simple;
	bh=eHthjJeKXXZNP/HJ44d3fT3ZNvSma+yqLbDWTWe268s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jjwA8Pp3ieiwcE0n6MZ67yauhBcY0p+cXSxWreX117D4HDBl6mEB0E6wJmc+j389Bnjb/DB1cq2Ev0Uo/FNbTYAZ+a+JTmJGF1LNqsrQjDerOw3asJoKRlTIF0JyZ84TbMRcQhnoG1pT2jmx2sI2CbakCyK39LO1hEAq1K1oGhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kskN3XVT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e08fca19b9so1530346a91.2
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 17:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727396204; x=1728001004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XLS/E/81Wzw3Za+L/Cr3978PALSFMwYPmSR0QYXFI1I=;
        b=kskN3XVTwZ5YI42rttRAtI71zyHwxzXFkml2vBwUHNtQR+0ZuOVofM3zjAFaMY0W6G
         a83zY2+SHA6gck1cwyahKVp1Hs2j4IjR8bgi7+UVlxs2AvVDVx/QSsHDFsw1H5PWzz5z
         xD0oDEffIgQXWfIiLfaJNsUivFbMt/IBnIJped+mudvyMuC2Tdfn+t6IuJa0qohorNZC
         ntWuo0qV6UUtJnruknDG0M7905juljbwfrGFyzQkxLiaaRliIX8rIdiTLm5wLojTXWEc
         4nRE2Wdtng4Fu49Z6lwZoU/fx4uuKxtPqsqv6MkF8N6OxwUXFEACX3JeK5/tMbLGpypK
         YqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727396204; x=1728001004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLS/E/81Wzw3Za+L/Cr3978PALSFMwYPmSR0QYXFI1I=;
        b=ZPsIVbSR3up7b+ihN1LIzKO/w7Yxzi6CKrDKIDhOeUCm26yaf/Bd9ttkaS/ORHCV+Z
         e1K0+57O0sCyrA4D1Py6bqnSbPdiG4YOsO7cqXuFZEeufKmdD7AnbpjyFw1hKrwx6Q9B
         jgs7MY/QWWePj81I9CfoACm5UG3p28e4tURbgkWrD/FpXmDBe6t36cyvzaU7MC91EaqR
         isLdMF5SG5kJeObvZg0m4NlMkWRmElzUqYDlZA5LhjqDt6/INSZytMgUr5HP6kVG58IE
         Lt69d6Mf5R1BG9OYwmqk4jigtJ5+XErNUfboIBkDW5bpba58SouunIvKHQPwzpYZwYpA
         Q0OA==
X-Gm-Message-State: AOJu0Yzb5DMeAZn2q7g3tL0SElVa1IxzHYVGudzoYx+izFEsPhgvpWvy
	G0pZ7mWqv8Bg/NApzG4N2SdsvqWWadN064AJDh+pBG4laI9gKz+CUrt/pCNoZnv/M51MXQSMQqS
	8Bw==
X-Google-Smtp-Source: AGHT+IFe3o5RCNOX4D2Pw1PUnAH3Si2msLGWgXE9du5TEjEDFpFJ9cNI9ayHRXGA2vwPaFgiysbMMEpCIEE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:f07:b0:2c9:7616:dec5 with SMTP id
 98e67ed59e1d1-2e0b8663061mr1914a91.2.1727396203647; Thu, 26 Sep 2024 17:16:43
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Sep 2024 17:16:34 -0700
In-Reply-To: <20240927001635.501418-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240927001635.501418-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Message-ID: <20240927001635.501418-4-seanjc@google.com>
Subject: [PATCH 3/4] Revert "KVM: selftests: Test slot move/delete with slot
 zap quirk enabled/disabled"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Revert set_memory_region_test's KVM_X86_QUIRK_SLOT_ZAP_ALL testcase, as
the quirk is being removed, i.e. the KVM side of things is being reverted.

This reverts commit b4ed2c67d275b85b2ab07d54f88bebd5998d61d8.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 29 +++++--------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index a8267628e9ed..bb8002084f52 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -175,7 +175,7 @@ static void guest_code_move_memory_region(void)
 	GUEST_DONE();
 }
 
-static void test_move_memory_region(bool disable_slot_zap_quirk)
+static void test_move_memory_region(void)
 {
 	pthread_t vcpu_thread;
 	struct kvm_vcpu *vcpu;
@@ -184,9 +184,6 @@ static void test_move_memory_region(bool disable_slot_zap_quirk)
 
 	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_move_memory_region);
 
-	if (disable_slot_zap_quirk)
-		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
-
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 
 	/*
@@ -269,7 +266,7 @@ static void guest_code_delete_memory_region(void)
 	GUEST_ASSERT(0);
 }
 
-static void test_delete_memory_region(bool disable_slot_zap_quirk)
+static void test_delete_memory_region(void)
 {
 	pthread_t vcpu_thread;
 	struct kvm_vcpu *vcpu;
@@ -279,9 +276,6 @@ static void test_delete_memory_region(bool disable_slot_zap_quirk)
 
 	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_delete_memory_region);
 
-	if (disable_slot_zap_quirk)
-		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
-
 	/* Delete the memory region, the guest should not die. */
 	vm_mem_region_delete(vm, MEM_REGION_SLOT);
 	wait_for_vcpu();
@@ -559,10 +553,7 @@ int main(int argc, char *argv[])
 {
 #ifdef __x86_64__
 	int i, loops;
-	int j, disable_slot_zap_quirk = 0;
 
-	if (kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_SLOT_ZAP_ALL)
-		disable_slot_zap_quirk = 1;
 	/*
 	 * FIXME: the zero-memslot test fails on aarch64 and s390x because
 	 * KVM_RUN fails with ENOEXEC or EFAULT.
@@ -588,17 +579,13 @@ int main(int argc, char *argv[])
 	else
 		loops = 10;
 
-	for (j = 0; j <= disable_slot_zap_quirk; j++) {
-		pr_info("Testing MOVE of in-use region, %d loops, slot zap quirk %s\n",
-			loops, j ? "disabled" : "enabled");
-		for (i = 0; i < loops; i++)
-			test_move_memory_region(!!j);
+	pr_info("Testing MOVE of in-use region, %d loops\n", loops);
+	for (i = 0; i < loops; i++)
+		test_move_memory_region();
 
-		pr_info("Testing DELETE of in-use region, %d loops, slot zap quirk %s\n",
-			loops, j ? "disabled" : "enabled");
-		for (i = 0; i < loops; i++)
-			test_delete_memory_region(!!j);
-	}
+	pr_info("Testing DELETE of in-use region, %d loops\n", loops);
+	for (i = 0; i < loops; i++)
+		test_delete_memory_region();
 #endif
 
 	return 0;
-- 
2.46.1.824.gd892dcdcdd-goog


