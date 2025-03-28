Return-Path: <kvm+bounces-42188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 098E9A74EED
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47CDE188C322
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09881DE8A9;
	Fri, 28 Mar 2025 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="eGdHRMcR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3391D86ED;
	Fri, 28 Mar 2025 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181994; cv=none; b=jiiBQGUXogsBVmHpuAek0p3BgrRqsTN0BZHd5DWufa4w+aeCvz0Xy4L+u4m5u4mHMoQZ/Jo1qnc/UcZzNjhqJLWO1kqO7sBNVu/PYuU4GJEIHSQce/NnWe+/Dct0ORqt2gNm5FpL1DeBeHP3f6r//eyqwM+YGS8A8+3wJbp+dlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181994; c=relaxed/simple;
	bh=D27g3GbFsGP1ueqotFWFhrkC9wOZyBrwQ4/QwqZ7Dkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7ZFKmrXHluiAYxIeFaq8kFZICgVbXd/nwnAogNyPZn+zNqUjo3GXGz96ej0D3wh1ss09c64s92CQQLU/EKdRXneaQq6kvtgjdVS/UbvTAqkHkItYakIhdhHaEYmYQWN7oHaRQqCHSw4Z+Z+xDbzz+boZGZxCMxa9JC83hwloX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=eGdHRMcR; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vf2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vf2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181942;
	bh=DjBlyZ5mwB/HsznQ/SDlFyM6S2m0XXMYnjG9WyZFm0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGdHRMcR6PuvcHYiWwVYbp7/ZkD7illAsukIarcbooWfxxpk2H/EpBslJ/3ThXZz6
	 Iu5JZU0Ij/UahmAEW8USLLZSgj6n6Qik4OHuUx+AFBJlYLZjwLGaeiWQIh34VOY0kS
	 JkygC9fYaPfxEaSVC9PjLWTZ/TvFHwQxjWxJJVoo5+YY1LzK7M19wpgx+ymtxE0x1G
	 HZG0p6g4I4HIFge/jyDScW1hQD+V+FIjyfqf++YtniOwPxYYvQUVKFxkcDY5UxWoWW
	 Ms4nHjz4tdhO/lav2o/nkUJlTgkfW8RVPS7lj4hmOfNyVc60POLAA70SNwR+8oGfaA
	 rG84fkRDSZpYw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 09/19] KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
Date: Fri, 28 Mar 2025 10:11:55 -0700
Message-ID: <20250328171205.2029296-10-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Signed-off-by: Xin Li <xin3.li@intel.com>
[ Sean: removed the "kvm_" prefix from the function name ]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 36a8786db291..31b446b6cbd7 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -204,6 +204,21 @@ static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
 	return !!kvm_read_cr4_bits(vcpu, cr4_bit);
 }
 
+/*
+ * It's enough to check just CR4.FRED (X86_CR4_FRED) to tell if
+ * a vCPU is running with FRED enabled, because:
+ * 1) CR4.FRED can be set to 1 only _after_ IA32_EFER.LMA = 1.
+ * 2) To leave IA-32e mode, CR4.FRED must be cleared first.
+ */
+static inline bool is_fred_enabled(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_X86_64
+	return kvm_is_cr4_bit_set(vcpu, X86_CR4_FRED);
+#else
+	return false;
+#endif
+}
+
 static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-- 
2.48.1


