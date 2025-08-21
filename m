Return-Path: <kvm+bounces-55424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 149FBB30963
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74B2E1CE0B44
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8522D2F39C5;
	Thu, 21 Aug 2025 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jD/zGROb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1B42EA754;
	Thu, 21 Aug 2025 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815881; cv=none; b=bthatTldZpTdqYHZfWbwWmnbabgx7MCUeAMxwt8dzj/YqCjjSt/ZebrNR0OTPPgJMBI9Z9zZBtVw5DtQEGwrVKwz1PQxmjXDiC2qlqtxnRAiADqSUnVojOf1E9IiKe7pVV8Z49Er1aytYAn2mCsJrd52Ka2FpX5xXxqlqTNsA1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815881; c=relaxed/simple;
	bh=U4wg6bOm2m/HVDn3dgmX332I0PObfM6g46MMo75qTM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PV8BacTiyFx8NnUMOppj/XOEM4Aigbze2NFqIr4YETw6kMEohqaFGpvMhqOohWyNltOqbWi+XYvE9xfxMht/jTjYpC3oBdQ9YoH556ElQA0ubjjb+AIVc6Qk1eG/fTv3iss4l/Td0rJkCvg4G16/z+5wDdqkWh8ZtQ+JlFW26F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jD/zGROb; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOb984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:53 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOb984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815814;
	bh=kXZsNCNQxnlS0l40K6SZBC5tiDx2L8eSoG9y6lUMtaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD/zGRObtbnU9ywo2xk67zwGb9lfJcqmP3+yuwY400Yr52FCYaIHiYlXTSUuMuz9t
	 c17NY1+4DwczmcPpciWwX9ULNNpiBk0tnx1zMg4PH9jnR3K/v6ndjpLKWEetMsUnWy
	 uUhFNN2h6I5xi/ThZVr7vGln6kromtHmlV5w26aqFDMr6UOSaGqsvm+gbPCwoljIfD
	 qg6dqy2QaggK2d4c4lFG9pPZZRHT8mhnS/YtW+W38NCwuOLO3tNojQ2HNMlUbRpZat
	 6EckIc5HMZ+3V9qhahGrI7X8/1msxDwGQDbrkdeASigG6EsZlPSQnqSy3wp59vh5yh
	 Yoq8Dv/VL1Htw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 13/20] KVM: x86: Mark CR4.FRED as not reserved
Date: Thu, 21 Aug 2025 15:36:22 -0700
Message-ID: <20250821223630.984383-14-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when
guest cpu cap has FRED, i.e.,
  1) All of FRED KVM support is in place.
  2) Guest enumerates FRED.

Otherwise it is still a reserved bit.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change in v4:
* Rebase on top of "guest_cpu_cap".

Change in v3:
* Don't allow CR4.FRED=1 before all of FRED KVM support is in place
  (Sean Christopherson).
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.h              | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7549e5143249..0b5857997b22 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -142,7 +142,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP | X86_CR4_CET))
+			  | X86_CR4_LAM_SUP | X86_CR4_CET | X86_CR4_FRED))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 685eb710b1f2..c9f010862b2a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -688,6 +688,8 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
 	    !__cpu_has(__c, X86_FEATURE_IBT))           \
 		__reserved_bits |= X86_CR4_CET;         \
+	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
+		__reserved_bits |= X86_CR4_FRED;        \
 	__reserved_bits;                                \
 })
 
-- 
2.50.1


