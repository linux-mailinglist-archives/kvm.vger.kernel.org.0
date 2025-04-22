Return-Path: <kvm+bounces-43786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00145A961CE
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 237CD3A25EA
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83AE277808;
	Tue, 22 Apr 2025 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="QKcrrs1C"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D87268684;
	Tue, 22 Apr 2025 08:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310243; cv=none; b=rzyNG42neckEQ4mVg/wFzpCEBS8qG5bDvvYRBYx258kvnWNvNlpQz01rgeDITTgRytihMtFqDBymmeNdW42em88cMbybtY3DTaGSLvLaJPlu6YfJjx23mIR07FJKsoV1HCIh4BoOKHtvQF9JwgM+o9xIKPk0zttPIXj8GOpAJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310243; c=relaxed/simple;
	bh=eCu+m7zBbJAkqm4TZtPyOH/iZjKrV+2z+Fto4mzxhmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/KJF3DveTCxHpjLo28F/ZENNZMZ+yg0s/+Wsz39ekwC3ErSLEQFrc2bamV5c0uWK5MXMIM2qkulJxtiOT3aVwoVUtexGyCCBp2aPXTQfjNnwPyV09TxcF05UGfz3kPwOqzwHYBOG7SQ2+vcQM1qsbpVyn53B0MPZEujI4YmblI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=QKcrrs1C; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9l1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9l1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310210;
	bh=WuTf4DKpHMtSM1ra3KvkSmb+zvqoPj+dUC25U2G1occ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKcrrs1CLj1GklRXrRY5aS2PCtwaEhGTlYpiDyTQTjEtLCtpGP6PF4lU6okTlCAxs
	 YcOPgbljQyNdip4ad/TqaWX7E6oaZNhnbuHaO/9CAxKWtXtH5IcEpsPeCqrhCapA2j
	 7/sjlQ+echmy0OGy5x+sG8HYkRhBfTDD46yscv1eNtFvuMspT3EJZSfGIsXT9FuHEP
	 lwGS4cuq9Pl52a1bmYOQrcwDRDzLfN6Hjtx3Y5PSt1EOkUcnE2fwjGxqtkl4sfrZ/e
	 1E4b3AKvled+9XSPax5BGjZyR4j5ep8Tvn55jTFJhcMHXdiudbJQjCPXUevI1KzTbM
	 JdJzBLsp4NdOg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 33/34] x86/msr: Move the ARGS macros after the MSR read/write APIs
Date: Tue, 22 Apr 2025 01:22:14 -0700
Message-ID: <20250422082216.1954310-34-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the ARGS macros are no longer used in the MSR read/write API
implementation, move them after their definitions.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index b4447ba4d6c2..be593a15a838 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -38,23 +38,6 @@ struct saved_msrs {
 	struct saved_msr *array;
 };
 
-/*
- * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
- * constraint has different meanings. For i386, "A" means exactly
- * edx:eax, while for x86_64 it doesn't mean rdx:rax or edx:eax. Instead,
- * it means rax *or* rdx.
- */
-#ifdef CONFIG_X86_64
-/* Using 64-bit values saves one instruction clearing the high half of low */
-#define DECLARE_ARGS(val, low, high)	unsigned long low, high
-#define EAX_EDX_VAL(val, low, high)	((low) | (high) << 32)
-#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
-#else
-#define DECLARE_ARGS(val, low, high)	u64 val
-#define EAX_EDX_VAL(val, low, high)	(val)
-#define EAX_EDX_RET(val, low, high)	"=A" (val)
-#endif
-
 /*
  * Be very careful with includes. This header is prone to include loops.
  */
@@ -559,6 +542,23 @@ static __always_inline int wrmsr_safe(u32 msr, u32 low, u32 high)
 extern int rdmsr_safe_regs(u32 regs[8]);
 extern int wrmsr_safe_regs(u32 regs[8]);
 
+/*
+ * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
+ * constraint has different meanings. For i386, "A" means exactly
+ * edx:eax, while for x86_64 it doesn't mean rdx:rax or edx:eax. Instead,
+ * it means rax *or* rdx.
+ */
+#ifdef CONFIG_X86_64
+/* Using 64-bit values saves one instruction clearing the high half of low */
+#define DECLARE_ARGS(val, low, high)	unsigned long low, high
+#define EAX_EDX_VAL(val, low, high)	((low) | (high) << 32)
+#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
+#else
+#define DECLARE_ARGS(val, low, high)	u64 val
+#define EAX_EDX_VAL(val, low, high)	(val)
+#define EAX_EDX_RET(val, low, high)	"=A" (val)
+#endif
+
 static __always_inline u64 native_rdpmcq(int counter)
 {
 	DECLARE_ARGS(val, low, high);
@@ -571,6 +571,10 @@ static __always_inline u64 native_rdpmcq(int counter)
 	return EAX_EDX_VAL(val, low, high);
 }
 
+#undef DECLARE_ARGS
+#undef EAX_EDX_VAL
+#undef EAX_EDX_RET
+
 static __always_inline u64 rdpmcq(int counter)
 {
 #ifdef CONFIG_XEN_PV
-- 
2.49.0


