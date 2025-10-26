Return-Path: <kvm+bounces-61119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A59BC0B2A2
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40AD83B92A3
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE42A30275C;
	Sun, 26 Oct 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="eRId25kd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568102F7AB1;
	Sun, 26 Oct 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510033; cv=none; b=k9qkLsEITHdFONj8LgLY2Ts9nOcNVNVy4buqVAiw0RWr6uV6tMLghIHAMPC3lqHTQm0i48qj7mJryFJss92kLtSHxvmy/VzgHb1KqG7tkk8MLEbOhPgVTZ8O6g4E2MburzrpgGF08NVqu+IQx0WgGlvfriuKbiz3yRUrZyWbdiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510033; c=relaxed/simple;
	bh=9VokAk414snLBXF3pyB7JHAuMHOkiiRHlOL/Ix4S4e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDbV25k7YisSz3j34+Iz4fN8KXuLjKp+nduYCyWyP4ZI7SX5vtlvLeHXyOxvvrDICRRJqG2KJKNcroHqyaP5dQOpkW4+NSKvdt375RZVKo+9bnuaeSsVbWiA80uGX8YwsJBJCVJPWB5isC1YinwNR32wKujUsunsYLS5I5/wpzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=eRId25kd; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkS505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkS505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509970;
	bh=8UDLl5WkXPSsKyh6NlsnUJ4bx5FWuZND7Ll3P/1c8gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRId25kdLnDWL+6fkOVYDtCjNl8lyo3QpaH4m2Ce940hAtXPcMUBtZi5nM508X/wY
	 SfjW//8NCJTYwYf5rFa/McYi9KVa/iDZrFA3v3W+tlWORuydptuYUcxgsJwqmM2qVG
	 sy6DXoX7yijkpjsbRE8HtMoT72EhSi4tB0K9a4ZZIKFuu3akqBlED0yKhQL7pEI82/
	 wMdakm/otgy+afqNmRx1vSz1EREIDY6GX14QEjRuXjl/lP/EVQ3TMspNye6qV3YmUX
	 4dcteTPGz2excBC01EtQlIjuuJgssAzCAX3CvikR0TCatMpif83Xb8NX8N+IoKo/bX
	 A3bHoV24/CmEA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 11/22] KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
Date: Sun, 26 Oct 2025 13:18:59 -0700
Message-ID: <20251026201911.505204-12-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
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
index 8ddb01191d6f..3c8dbb77d7d4 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -205,6 +205,21 @@ static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
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
2.51.0


