Return-Path: <kvm+bounces-53300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AED9AB0F9E0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE9911897EF2
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813A128505D;
	Wed, 23 Jul 2025 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="k00OOPEB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF05A24676B;
	Wed, 23 Jul 2025 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293284; cv=none; b=DSi+KqrLiZH9JNLxCWOkjc49CRPUfL27UWfpo034rVGW6Jc5Zf/M9MCUlKzHR3PNu0TkDh8zzSdqVprxpz66N5roZbEIzzIaM/YES9NqSiXigD8gOde0dPRtWrHoPBzOoNdxbzuHHmq2kTeXwEdZRVwGT72mXF/mDpDyhqpADl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293284; c=relaxed/simple;
	bh=W5o/OUKop7lpPijc+jePVwalOlSLc5kpKcUB/E+lIzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAOrr8kAWeBWzxY6es5OWs5KZXW7fy6RyLxaRNx+cr8JUkK85+Yoz+0JsPjHWXz+NCvKfdFDVgHitUOGMs8zp7SYHiGO8YSwY1Jzsb44Sz01bO8sidf5mLDLHqirHq+Q9xAeHak7YKa6XhWu9Ri7xvU6Hy2Sj6oWDd0u2jdN5ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=k00OOPEB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf011284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:55 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf011284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293236;
	bh=wxUSqO5rVkPGALqMssLFUw98Nnali0t1xB3+MDyXIlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k00OOPEBKIz62NSnQcMA8sPN9ZWRgUnqEc6omi7PYHhb2qy4xmfXO59JBQA8OLnZA
	 COnM52gQOu0iK9dhW98heR/mVAj1fmrSCCczgJ0+M4bEYVn+Yokxid6SSPwTL/EzKS
	 HPuEFRamKRmOdyaWGXbnl61piRCxYd9/M1pdkGiTVbOH5vVuYNSW1Qme+tynJokuQx
	 WBWTqxn/0ECFiKzyt80yuEaZrjMETRvWidN6QZ0Xe9iUmDRL18MEQ1JkxhwioLqe0L
	 MaMNwxs5aC4qNsJLt2zrkqbztNNEcap5X4NSGvu/UtVt6Ee6QnbB1pbBKXDU9faqIL
	 goe0TqjjPMPQg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 11/23] KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
Date: Wed, 23 Jul 2025 10:53:29 -0700
Message-ID: <20250723175341.1284463-12-xin@zytor.com>
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


