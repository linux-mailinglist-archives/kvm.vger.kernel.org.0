Return-Path: <kvm+bounces-27715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0A298B333
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8DBC283F7C
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2D51BBBE2;
	Tue,  1 Oct 2024 05:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="fywBXWQT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C301322E;
	Tue,  1 Oct 2024 05:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758936; cv=none; b=ixqzn25kVbx3rvpOfuDkMh3kNCAZWxVgfJ77xqqsVa2fHOzQKD2OJpExtRVDsBLCqq0mGIUXRo6hssNbyOFjA6lwjqdFGo75RMmqMHzIEPZUCnXwyU+RHeRIZPxNqcpyUodkiMxopNOvCkONIJtecMN22T4X9YmI9oLCVKmkYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758936; c=relaxed/simple;
	bh=WcA6m/Yx90+CLRQ2TAp3UxKRvYuyJoHgvwfYIpMVil8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r30TSYo44B/sDc3ItiTmgKoIN8DrNCRI5UlXgbMIyM+xQypXBLBKbsSrUv7uTcEIu5IAWSwuJzdtNJdOkS9itSFTjyPcBF6BMP5InETH0Fdkm5XWxghL1JYUDFJi+w22KLSe7Ehz6pos423uZn0stj1UfIIemWaAnuv/EIoUBNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=fywBXWQT; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7c3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7c3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758889;
	bh=S2anEe6gVhX8RpVekZcYrZwLDqpmlt2eOrTn5hH3hT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fywBXWQTEL2POH0qz4N+/pCr/+ptIZUSOkqy3nVYI4gf3Ldo0f78XDYsv3HJSKJM0
	 y23vl6htUKaJ8OooodQM1DhCD7fccqBGLH0nljmJAPl3ZEljsbNCN/zBt7Imfa6SLF
	 g+WEvZb2QTWK+d9l1fzYr5NFuD2s0/VDIpdPGo/9PaHqZk772ykz/LozxSuMrjrFOj
	 zthEYc7mH7lXU50AcVEZCQZKFTgMOmpyyctJvRk5V+iuxQwI1S0mo/pG94dB27uAC+
	 DRiJSdbiG/CiyHek6aXi7E2xZTTrBbrhAcTHBXeQRrnTaPwJ8kJLQ90rAofOqCsIOq
	 O7ESO8FTUmoGg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 13/27] KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
Date: Mon, 30 Sep 2024 22:00:56 -0700
Message-ID: <20241001050110.3643764-14-xin@zytor.com>
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

Add is_fred_enabled() to detect if FRED is enabled on a vCPU.

Signed-off-by: Xin Li <xin3.li@intel.com>
[ Sean: removed the "kvm_" prefix from the function name ]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index b1eb46e26b2e..386c79f5dcb8 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -187,6 +187,21 @@ static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
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
2.46.2


