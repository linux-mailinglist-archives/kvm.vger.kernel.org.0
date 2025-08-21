Return-Path: <kvm+bounces-55436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8F6B30976
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA9DB1CE4FE9
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F573128A6;
	Thu, 21 Aug 2025 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="hAYMmK7O"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3B82EAB97;
	Thu, 21 Aug 2025 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815883; cv=none; b=evzbIbfDjaQ5VIiueqQEyWBBiAXAuBUcpW7jY/ll3bORG9ee/K4H/mIdRa5vCdmmvNSH9zMU/0/8gj1axjqrlSuE62QVESY8lILByMkxs8yQONC7X70c6q9nsW9IGY39wAZXiavBz21SwPFgrVv7nNHA45vNvW5KqAhmViQYdgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815883; c=relaxed/simple;
	bh=W5o/OUKop7lpPijc+jePVwalOlSLc5kpKcUB/E+lIzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGRd/PglgJn0ysI6T3TARy0UfUQsWVuWCQwifFreCQMkLSET4wBRNy1H8BQlO+8fi4eu/6JJYiNVimzJE57VGintxWhe/Yvje9U0mzqmbPl6xRt2+h1Sg3uqRidaPXuqiTQfJ5bmp9nQfvGQpvnd6l369urTgow1L+SxQHH7pxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=hAYMmK7O; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOX984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:49 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOX984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815810;
	bh=wxUSqO5rVkPGALqMssLFUw98Nnali0t1xB3+MDyXIlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAYMmK7OnnP5dw9ateJoKThN9yuIXcttF9AOX/KWAoxPlaOeApE6IkbnujoY9Gzn7
	 TPK26zO5fDzFNMNyhFEHFxSiQuW8AoHQ670nL0HiKQW3f5Im93D2xao7fVFeTGamcX
	 SkkYe0o3amMBOJVzSC5uYG6vB3J0EynPeuceF+Udc0s42jTtgGtfDiTHfrLZn9UgEJ
	 g7quczWGxkMQ6LZJYjIL60nhAyXguV++U2uRkLwSjLsUgS6ZKevkyYQoknZvZK4QYJ
	 d2iMFUvwQiToHXfYw56tshhhcvjrUXEYPmJgVIDUZQQaT/TB0HOYfi9hkPbNq2GtHv
	 f2SatjF+dfYmw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 09/20] KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
Date: Thu, 21 Aug 2025 15:36:18 -0700
Message-ID: <20250821223630.984383-10-xin@zytor.com>
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

Signed-off-by: Xin Li <xin3.li@intel.com>
[ Sean: removed the "kvm_" prefix from the function name ]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.
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
2.50.1


