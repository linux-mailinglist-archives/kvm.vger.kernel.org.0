Return-Path: <kvm+bounces-27878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E4D98FADA
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 638711F2169D
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1161D1747;
	Thu,  3 Oct 2024 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u5hU6+iO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6C1D0E38
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727999027; cv=none; b=ErxIEC10q4QYcbLhtmOFEGeA1qeWpjMxu2jaHetH2q6jYhtHk2bemYMvLPelI3SSTnn95bPYvZwF99x8i2HVMjzdSwCNfbL3DiamR4VBb0iD98pkQ2WAlgbC0aFcNzc4+CgLEetI+n5Ej9Qxbx3g8mARjHrygQjpA7i4Kb1ANhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727999027; c=relaxed/simple;
	bh=WciSfpUtADL53emwfW+NrL/3Wm17IVfAZmunZlqHwnU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aq3Aro7DraAlv/pAAQqnc9qL3VKVPGq22/AlpmzHIE/m2FUotO5VoNBp/2xHa2wKCIhuKImFKLn2PjQvzQnzuUBdz1ZZKrFPL4bEhp0KVsEcaDjycvTt+qVps5E9SYg3KdixhRRSaVbVgC2XxOCDMRZaKHHq0hdkStsgHKw91NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u5hU6+iO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e29b4f8837so20306307b3.0
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 16:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727999024; x=1728603824; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KgYrDB8FMNlYemVzZTKJ7rr9scMDlTxRH27Xvf6zHWk=;
        b=u5hU6+iObg+a+jfwQtRHfoaLs2uU4Y0FgzRGObj4WiEebRvq9D5nJy1Xj5VcUjcBaQ
         GooYy5lJqlVUqdGKdGz9hdr78/096iRaMMkQRO0GNuybGRpPRGsbWeQS9IiXiIhUgtGH
         M30XP2k1n0dz8qhlt1CLam2X6sQR8JjP+VWlxMS09tr9IuP9dvFF7u3Da7IvOKv0FFph
         HyALqIiqVBuIhrJfrpHVVw3jJhTIKt2VS9CcRED08M1zUISLqG8Wbbk6IzAnkBlyF5T7
         Ym1q3UAzJ0BS+GB4JF2EyqhDtvQpsZ1bI3vFberJ4QFc2fgu/VpyjiDaoLNk3F9ukkg5
         LoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727999024; x=1728603824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KgYrDB8FMNlYemVzZTKJ7rr9scMDlTxRH27Xvf6zHWk=;
        b=PH6WFwozwqSs0wqi1d0tC5ZRjmBS/QxJFvXusJhUTMS/1T5DHUVk6vO04et5dhr2Ej
         R9WHqMD53Q1b5KtI/bhqCsSqgGdD36+tPc+YzKzlX9C9CkMjnKUggLG1obOFx1lmLHAT
         EM9WId+n5lWZDsh6wmq0toxIGW3ETDG1cMG79vpWFXILJXhgkjh0F1v7ROJwHFNKS2T6
         lY8NSzlxEbUlfwb4o3hlzle647tEzsJAp6jnplQoWXo9K9HcS6USkSVYbbIKTaomAfTn
         h3xEIQuTnOnA7OKqjpAKgG37bz2h48qC3zPNSiuVx3bS3TR9rXqm04O7m3LyOZByx24m
         vJNQ==
X-Gm-Message-State: AOJu0YyDVNfWhmCpCaKYGtFw6SAucFUNhqfzpnQgIrlqE8Am3vmktP2q
	esSbJAS6PNNQRXbs7iCCnUJ/WdHiQ0IqUZOIhGBRz5Ri0X9CSTdbJNcntJ3cwTgxrbpaQs/BtkY
	KEw==
X-Google-Smtp-Source: AGHT+IHaEIz62SUDBPFamT7iUN294iPXv9WrqsT0+w4WLCmg7tFXE882wAH7QsU3DqZOyCv/lJrcMqX4V+o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:7202:b0:6d9:d865:46c7 with SMTP id
 00721157ae682-6e2b531f429mr1481757b3.2.1727999024502; Thu, 03 Oct 2024
 16:43:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Oct 2024 16:43:28 -0700
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241003234337.273364-3-seanjc@google.com>
Subject: [PATCH 02/11] KVM: selftests: Precisely mask off dynamic fields in
 CPUID test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When comparing vCPU CPUID entries against KVM's supported CPUID, mask off
only the dynamic fields/bits instead of skipping the entire entry.
Precisely masking bits isn't meaningfully more difficult than skipping
entire entries, and will be necessary to maintain test coverage when a
future commit enables OSXSAVE by default, i.e. makes one bit in all of
CPUID.0x1 dynamic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 61 +++++++++++--------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index fec03b11b059..f7fdcef5fa59 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -12,17 +12,16 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-/* CPUIDs known to differ */
-struct {
-	u32 function;
-	u32 index;
-} mangled_cpuids[] = {
-	/*
-	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
-	 * which are not controlled for by this test.
-	 */
-	{.function = 0xd, .index = 0},
-	{.function = 0xd, .index = 1},
+struct cpuid_mask {
+	union {
+		struct {
+			u32 eax;
+			u32 ebx;
+			u32 ecx;
+			u32 edx;
+		};
+		u32 regs[4];
+	};
 };
 
 static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
@@ -56,17 +55,23 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 	GUEST_DONE();
 }
 
-static bool is_cpuid_mangled(const struct kvm_cpuid_entry2 *entrie)
+static struct cpuid_mask get_const_cpuid_mask(const struct kvm_cpuid_entry2 *entry)
 {
-	int i;
+	struct cpuid_mask mask;
 
-	for (i = 0; i < ARRAY_SIZE(mangled_cpuids); i++) {
-		if (mangled_cpuids[i].function == entrie->function &&
-		    mangled_cpuids[i].index == entrie->index)
-			return true;
+	memset(&mask, 0xff, sizeof(mask));
+
+	switch (entry->function) {
+	case 0xd:
+		/*
+		 * CPUID.0xD.{0,1}.EBX enumerate XSAVE size based on the current
+		 * XCR0 and IA32_XSS MSR values.
+		 */
+		if (entry->index < 2)
+			mask.ebx = 0;
+		break;
 	}
-
-	return false;
+	return mask;
 }
 
 static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
@@ -79,6 +84,8 @@ static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
 		    "CPUID nent mismatch: %d vs. %d", cpuid1->nent, cpuid2->nent);
 
 	for (i = 0; i < cpuid1->nent; i++) {
+		struct cpuid_mask mask;
+
 		e1 = &cpuid1->entries[i];
 		e2 = &cpuid2->entries[i];
 
@@ -88,15 +95,19 @@ static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
 			    i, e1->function, e1->index, e1->flags,
 			    e2->function, e2->index, e2->flags);
 
-		if (is_cpuid_mangled(e1))
-			continue;
+		/* Mask off dynamic bits, e.g. OSXSAVE, when comparing entries. */
+		mask = get_const_cpuid_mask(e1);
 
-		TEST_ASSERT(e1->eax == e2->eax && e1->ebx == e2->ebx &&
-			    e1->ecx == e2->ecx && e1->edx == e2->edx,
+		TEST_ASSERT((e1->eax & mask.eax) == (e2->eax & mask.eax) &&
+			    (e1->ebx & mask.ebx) == (e2->ebx & mask.ebx) &&
+			    (e1->ecx & mask.ecx) == (e2->ecx & mask.ecx) &&
+			    (e1->edx & mask.edx) == (e2->edx & mask.edx),
 			    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
 			    e1->function, e1->index,
-			    e1->eax, e1->ebx, e1->ecx, e1->edx,
-			    e2->eax, e2->ebx, e2->ecx, e2->edx);
+			    e1->eax & mask.eax, e1->ebx & mask.ebx,
+			    e1->ecx & mask.ecx, e1->edx & mask.edx,
+			    e2->eax & mask.eax, e2->ebx & mask.ebx,
+			    e2->ecx & mask.ecx, e2->edx & mask.edx);
 	}
 }
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog


