Return-Path: <kvm+bounces-72809-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KB5JL0VlqWlN6wAAu9opvQ
	(envelope-from <kvm+bounces-72809-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:13:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E12210641
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:13:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 255CB30C7330
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 11:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9372315D3E;
	Thu,  5 Mar 2026 11:08:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47354374745
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 11:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708915; cv=none; b=Ve/SBOnErttoeAgXQPqOljiOThkgLnboEflOLFMBgnu+Wjl1iQHbiTxtoCGxWOtxAUnIfXDEOahXcBPbGhPTbkFZUQPt0BPHdMIqBN78DiFEWJS4x+eG0i+ND3v9NPmfwAKS3NnF9/Q3+ZkdQ/lX8yqygQKDEekQ0I+gyCozwq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708915; c=relaxed/simple;
	bh=zBc9PRKN+MIyuZ+ZbzzSoKwLmB/YeSKOUhuShP6fTzw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OYwLaQT4Ggjp1thlOp0Dw/1+zdV9+mUhZkr67HQjQwvjGCf9OXk3r0ASFJiIug+7YK2juXF0WcH8V2FM+AzmbGx0j70XyuwX1tFi6+8AaBmwAYVVbZzp8GOTsOfjpJBXXI9nU9rsxRlSM106uZ0t8kRApqR2oKQcwhk3zboVJmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1772708905-1eb14e758427d50001-HEqcsx
Received: from zxbjmbx1.zhaoxin.com (zxbjmbx1.zhaoxin.com [10.29.252.163]) by mx2.zhaoxin.com with ESMTP id NDK15eeJDHBY6M3y (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Thu, 05 Mar 2026 19:08:25 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 5 Mar
 2026 19:08:25 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Thu, 5 Mar 2026 19:08:24 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.163
Received: from ewan-server.zhaoxin.com (10.28.44.15) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 5 Mar
 2026 19:05:19 +0800
Received: by ewan-server.zhaoxin.com (Postfix, from userid 1000)
	id 661592D00050; Thu,  5 Mar 2026 06:05:19 -0500 (EST)
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <cobechen@zhaoxin.com>, <tonywwang@zhaoxin.com>
Subject: [PATCH] KVM: x86: Add KVM-only CPUID.0xC0000001:EDX feature bits
Date: Thu, 5 Mar 2026 06:05:19 -0500
X-ASG-Orig-Subj: [PATCH] KVM: x86: Add KVM-only CPUID.0xC0000001:EDX feature bits
Message-ID: <20260305110519.308860-1-ewanhai-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 3/5/2026 7:08:23 PM
X-Barracuda-Connect: zxbjmbx1.zhaoxin.com[10.29.252.163]
X-Barracuda-Start-Time: 1772708905
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3101
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155408
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
X-Rspamd-Queue-Id: 28E12210641
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[zhaoxin.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72809-lists,kvm=lfdr.de];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ewanhai-oc@zhaoxin.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zhaoxin.com:mid,zhaoxin.com:email]
X-Rspamd-Action: no action

Per Paolo's suggestion, add the missing CPUID.0xC0000001:EDX feature
bits as KVM-only X86_FEATURE_* definitions, so KVM can expose them to
userspace before they are added to the generic cpufeatures definitions.

Wire the new bits into kvm_set_cpu_caps() for CPUID_C000_0001_EDX.

As a result, KVM_GET_SUPPORTED_CPUID reports these bits according to
host capability, allowing VMMs to advertise only host-supported
features to guests.

Link: https://lore.kernel.org/all/b3632083-f8ff-4127-a488-05a2c7acf1ad@redh=
at.com/
Signed-off-by: Ewan Hai <ewanhai-oc@zhaoxin.com>
---
 arch/x86/kvm/cpuid.c         | 14 ++++++++++++++
 arch/x86/kvm/reverse_cpuid.h | 19 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..529705079904 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1242,8 +1242,12 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
=20
 	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
+		F(SM2),
+		F(SM2_EN),
 		F(XSTORE),
 		F(XSTORE_EN),
+		F(CCS),
+		F(CCS_EN),
 		F(XCRYPT),
 		F(XCRYPT_EN),
 		F(ACE2),
@@ -1252,6 +1256,16 @@ void kvm_set_cpu_caps(void)
 		F(PHE_EN),
 		F(PMM),
 		F(PMM_EN),
+		F(PARALLAX),
+		F(PARALLAX_EN),
+		F(TM3),
+		F(TM3_EN),
+		F(RNG2),
+		F(RNG2_EN),
+		F(PHE2),
+		F(PHE2_EN),
+		F(RSA),
+		F(RSA_EN),
 	);
=20
 	/*
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 81b4a7acf72e..33e6a2755c84 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -59,6 +59,25 @@
 #define KVM_X86_FEATURE_TSA_SQ_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
 #define KVM_X86_FEATURE_TSA_L1_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
=20
+/*
+ * Zhaoxin/Centaur-defined CPUID level 0xC0000001 (EDX) features that are
+ * currently KVM-only and not defined in cpufeatures.h.
+ */
+#define X86_FEATURE_SM2             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 0=
)
+#define X86_FEATURE_SM2_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 1=
)
+#define X86_FEATURE_CCS             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 4=
)
+#define X86_FEATURE_CCS_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 5=
)
+#define X86_FEATURE_PARALLAX        KVM_X86_FEATURE(CPUID_C000_0001_EDX, 1=
6)
+#define X86_FEATURE_PARALLAX_EN     KVM_X86_FEATURE(CPUID_C000_0001_EDX, 1=
7)
+#define X86_FEATURE_TM3             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
0)
+#define X86_FEATURE_TM3_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
1)
+#define X86_FEATURE_RNG2            KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
2)
+#define X86_FEATURE_RNG2_EN         KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
3)
+#define X86_FEATURE_PHE2            KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
5)
+#define X86_FEATURE_PHE2_EN         KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
6)
+#define X86_FEATURE_RSA             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
7)
+#define X86_FEATURE_RSA_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 2=
8)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
--=20
2.34.1


