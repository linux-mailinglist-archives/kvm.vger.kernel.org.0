Return-Path: <kvm+bounces-53287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B08FB0F9AE
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A03951CC1615
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C082356B9;
	Wed, 23 Jul 2025 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="UrZaDzKH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEAE22CBE6;
	Wed, 23 Jul 2025 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293261; cv=none; b=dhA46eS/DDMP1t3iJikuamuqi29kSnBSGsGkG1JIx6JwmIcjsV9zHFjZVdDsiROqmcTIDqxhwd57po5ASMjJKEPtvZsgLGhH2cCwbNKNRgA1o2ZiGGFXPZjS+5fsAEFVEFTMve5BJL+f1PGPBgYtpCxCo2xjDLs6sqsL2++ek0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293261; c=relaxed/simple;
	bh=2TyfVb5NWoLz0GzMyEcofpBwEtaePovaJCJXs/9B8uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5HrHBj7Vz2WkqOtmlEcmIogd7z7NA3OFYiMdUMEcPuc9w9HwTV7LkXr8W+/5blK/HM7yqczcnvQ9ZNdlVUkiaLCQjXw3DP2VE6r7W87t3gzVpeogi4J8Tn4mPo3vYmA+HmEeSYb6Z764fzlwYiM/NwrWS8hrFy5NioEe9ydDcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=UrZaDzKH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf061284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:54:00 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf061284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293241;
	bh=62h60ISMF6N+mZatzpXWdS4PjakRmhWqSbMYln3oONs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrZaDzKHrr+whGR2XJxmJ1KhYCZ/TvEirK6FwpD7XfZxtAGA3DTS1vZ9fUxWGbjI4
	 BAzLn2FAtxcjT4MuVvuYTd3sjFC39pPe4DmoPhV18v6cjgB4xMS1DBa+RvePTS1Hyg
	 f5VIllUBi6Db5giaUrYuJA8uO5QqBWB7h20qTPnsaksDbFxsomqOuqkhH/m2KmTIh4
	 n+qf7fs/xqWnFNB/m0GUZVx88TGqDwTZIN+0aiw/AzqHTG4h7oaTz1LSPSHJqRclQT
	 qYKBhEf9X9GAooPsJ7Em7DCOIl4VJUlLjkwJo+/zj1wRqWj5CgZoCSU3uWnkjzLjxA
	 Ao7lCEKDKALpA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 16/23] KVM: x86: Mark CR4.FRED as not reserved
Date: Wed, 23 Jul 2025 10:53:34 -0700
Message-ID: <20250723175341.1284463-17-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
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
index 8e8d4ba77afc..0805ad9ccf97 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -142,7 +142,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP))
+			  | X86_CR4_LAM_SUP | X86_CR4_FRED))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a573f6079ba7..aff93c5b2484 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -672,6 +672,8 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		__reserved_bits |= X86_CR4_PCIDE;       \
 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
 		__reserved_bits |= X86_CR4_LAM_SUP;     \
+	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
+		__reserved_bits |= X86_CR4_FRED;        \
 	__reserved_bits;                                \
 })
 
-- 
2.50.1


