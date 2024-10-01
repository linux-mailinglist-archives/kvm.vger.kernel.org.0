Return-Path: <kvm+bounces-27738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8729398B369
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 363172840BE
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5A6BA33;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="QITtegD9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4BF1BC091;
	Tue,  1 Oct 2024 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=qeA05Kjkq5TEzst1elHostm8t2BDer/TWUIR5KqzXQXDEgsH9o+DoySEnwTUyng++WgmwPlaVh8yKLrYScfVpjpCRPjhlNbidr7V69VpxdY/rfe7JLrj6hsy/WcVo5PWXla+nV83aFZpg5Snq6b1wGvLs9wcOtEBEyfhHp3I4dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=cCXS3QGJ3gGL/feyhUz/mholtXE/la9yMJrsJIIa3Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFoTfrXXXUul3Zt3RPvTKyXS/c+vAVgcG+9fFZnSL5WpvHhD8TXqpxAQqHv/7UL1t2DH31k8ZrqhepFX/E87i5lDMaObiOfm1pNpvfbiXB7pFmasQi4pjQ+ItS89wr5NBsghaOsE/y90fP3J21Fl3M3x91D+zJNUoSd8xGFReVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=QITtegD9; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7g3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:32 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7g3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758893;
	bh=UYAkdDGgqqEL7Q7x/r0wK+q8dSQmiECINofEe79ZVk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QITtegD9RMAjCLagc7MIyxSEcq6XAQBaZEjdFbyKoYl5jNyirtuGTieqtNlwWM8xD
	 DAKv3wccYOa66wR1PHKWBIHjos1AX3coG1V8z8zyGnrwsrbhoGG/L6bDSk7VTxG/kO
	 HEFRhw/PP0uiLMdUtgGhaCUqhkjSbwkhqwZ7ei+o6ko+MtmFSxO7c3JkOXPzC9tc5I
	 SBtQ+De1WSSWx0/FM3K8XFJgBiL34ErT1fZa3fAhqEQWLNMM91g9L/NkZrju1KOxP+
	 an27O7U/AAj/AH22Y8cFNYGgKrd1Mde2VSZtmUQKuKDDo20gQYWRVlTUo8el76pDoT
	 plDhi9IadUp2Q==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 17/27] KVM: x86: Mark CR4.FRED as not reserved when guest can use FRED
Date: Mon, 30 Sep 2024 22:01:00 -0700
Message-ID: <20241001050110.3643764-18-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when
guest can use FRED, i.e.,
  1) All of FRED KVM support is in place.
  2) Guest enumerates FRED.
Otherwise it is still a reserved bit.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Changes since v2:
* Don't allow CR4.FRED=1 before all of FRED KVM support is in place
  (Sean Christopherson).
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 4 ++++
 arch/x86/kvm/x86.h              | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3830084b569b..87f9f0b6cf3c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -136,7 +136,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP))
+			  | X86_CR4_LAM_SUP | X86_CR4_FRED))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 03f42b218554..bfdd10773136 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8009,6 +8009,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_FRED);
 
+	/* Don't allow CR4.FRED=1 before all of FRED KVM support is in place. */
+	if (!guest_can_use(vcpu, X86_FEATURE_FRED))
+		vcpu->arch.cr4_guest_rsvd_bits |= X86_CR4_FRED;
+
 	vmx_setup_uret_msrs(vmx);
 
 	if (cpu_has_secondary_exec_ctrls())
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 992e73ee2ec5..0ed91512b757 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -561,6 +561,8 @@ enum kvm_msr_access {
 		__reserved_bits |= X86_CR4_PCIDE;       \
 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
 		__reserved_bits |= X86_CR4_LAM_SUP;     \
+	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
+		__reserved_bits |= X86_CR4_FRED;        \
 	__reserved_bits;                                \
 })
 
-- 
2.46.2


