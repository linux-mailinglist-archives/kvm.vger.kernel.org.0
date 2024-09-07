Return-Path: <kvm+bounces-26064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43317970198
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 12:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE79728504E
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 10:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92A215956C;
	Sat,  7 Sep 2024 10:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="wakxfG+K";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BEPvx2xU"
X-Original-To: kvm@vger.kernel.org
Received: from fout7-smtp.messagingengine.com (fout7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1545F2B9B1;
	Sat,  7 Sep 2024 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725704232; cv=none; b=LgEVUaJ+va+TgUWC7M36V93MvPhj/UQNczWW098coT/ltaMM9+LdLdbeBTpVjiQ2GeJbn1sDQhe3lsl2rC35ftlM0+zdijr8DMZOkjejUlJPXmj0iCY1V+S1372e9yQ+mPU0rvaFqWhB52XnNoRiAf746bGSiq+I8ibGS9UQA5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725704232; c=relaxed/simple;
	bh=wNTWbaQ3JwwfsBAMFy/hbQ4QwVJklrQxDjLfp0v17+I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pQJMUEQDXjAXrfo17cyCRrk5YvW4TdP8D+T9yle4psgrUMOxa3rIWAiKA3RAl9wR3D1p/5ILjXIbdoxj6zgP5enVhJsLtmHSF2pbVLmLio6GFJc0FiVJP/OnutGNhe7M3snKLpgKJ7Edtx6R90mefyP11tDac0aNYbVtCzhdw9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=wakxfG+K; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BEPvx2xU; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 3AFEC1380232;
	Sat,  7 Sep 2024 06:17:10 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Sat, 07 Sep 2024 06:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1725704230;
	 x=1725790630; bh=zpvJucUqs7I/38ybPNaItJ/O65uxnCT7g9kZGtXgeRE=; b=
	wakxfG+KM1Jh+ZBGYBmgyVxtOem0RBnis1HbyaxckmKH2kJzVcOszWSiL6Sz6KAP
	SuGLQcBSz4ugs4cUmu/TJcGWHddXS6fYzWF+vXhA25o+YKjYQW3osZTbtHQY0aEZ
	SwZeayWyetFhdHT71+hg55F5BLhp5ijZPKF6Pz2Ca6MwANjLpBJTbS9gq7Ej34YM
	w8X1/m+5aEj2tI5uHwkAtL8tBnLDpL9P2fRm397TCbFemBrj5APKog6ZigFdzavc
	zq6OeGR48Sh80BFhBqmMeZ5ea11w8UsjZM5sljpB8koDjmNTuP5vzQ1AiEnKBizb
	jlDb57QcFi8onwUHo+MnpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725704230; x=
	1725790630; bh=zpvJucUqs7I/38ybPNaItJ/O65uxnCT7g9kZGtXgeRE=; b=B
	EPvx2xUNjdZNbQepcyCa2IgFNnUIU/eMHC6DA+7NbnfARYn2tQNp9iiKMtRP4V3o
	g9TWYHRcS6OGOX3ryIV4qc9oIfJqVEmV+A1D7h3E2J1x3F4k1KPRTWkv4LrHNz+i
	1Yp+4pQRl0yxXKgY+bz8Z+m+7vuTTTrvyxyzLu2BlfUA7EPbZtIeWmg8DkghnIY4
	xbu2pXpsAdUQcOpbvWC69882cNXFqwbEB7XbaEE/d2W/ybO7GRLfS4XhfLNVr6HM
	pckOomUNWxhbbaEjwsiQ1gF/GW5yDQ+AfP3T/mld1pxi7eXt2DTU2GGxzQq1D2OM
	acqpuYNYVtzrf26BLUPCA==
X-ME-Sender: <xms:JijcZhsbMB_9xI3IjyQt-duNPHlO1GKT1dg0Vprwnnkl8zx9U7h5Ig>
    <xme:JijcZqfory6-SRnTwy4brDyFP_M6EzGyvj8_o-gVFq2yyrsD2jCYnyD9t9R-mCVwW
    cI35WvDd4suvZXdkZE>
X-ME-Received: <xmr:JijcZkxxQC8inXqmRwa1sGsM5_LhXJOK8xXpdDGPcelEVQd6w49K69cZZT_liJMe3Pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeifedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephfffufggtgfgkfhfjgfvvefosehtjeertdertdej
    necuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhi
    hgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepvdekiefhfeevkeeuveetfeelffek
    gedugefhtdduudeghfeuveegffegudekjeelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdr
    tghomhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtth
    hopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehl
    ihhnuhhtrhhonhhigidruggvpdhrtghpthhtoheptghhvghnhhhurggtrghisehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehvihhrvghshhdrkhhumhgrrheslhhinhgrrhhordho
    rhhgpdhrtghpthhtoheplhhoohhnghgrrhgthheslhhishhtshdrlhhinhhugidruggvvh
    dprhgtphhtthhopehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmpdhrtghp
    thhtohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgrnhhkvghnrdguvgdprhgtphhtth
    hopehkvghrnhgvlhesgigvnhdtnhdrnhgrmhgvpdhrtghpthhtoheplhhinhhugidqmhhi
    phhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:JijcZoPxLaNQTQtxEXINKHZFf3N_tX-gi6mMYGPCbKLFvlLy5CVXPA>
    <xmx:JijcZh9Lkzzs1lsu4leRUGjGz4At-v-czat2PbEmt1EwX3b5dz5iGQ>
    <xmx:JijcZoVyr8P9Qc006b4_vXtxE1D9G_l_kCqs6RHH60eL8u36f1Hmfg>
    <xmx:JijcZifS0E08CpgKfNrTDcPoeiby7ZcmVTz45cCJPCZRbkxVTF1YwA>
    <xmx:JijcZkWqAeTqKzJ3kKqNWd160fU57qfif1mJLif5wBiFqG6M5ILyLNM->
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Sep 2024 06:17:08 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Sat, 07 Sep 2024 11:17:03 +0100
Subject: [PATCH 1/5] LoongArch: Rename cpu_has_csr as cpu_has_iocsr
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240907-iocsr-v1-1-0c99b3334444@flygoat.com>
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
In-Reply-To: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2334;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=wNTWbaQ3JwwfsBAMFy/hbQ4QwVJklrQxDjLfp0v17+I=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQ7GkpTdvr/Phjcp7IvsXXKlsMMZ6+01e5Oqwmp+3825
 Mwr9TNTOkpZGMS4GGTFFFlCBJT6NjReXHD9QdYfmDmsTCBDGLg4BWAiEj0M/531r/zcvdvmwtOn
 V+6+WhZ9qrg1Zs7eB7dW2Dzad2Pi98q7DP+zUivDDv8R1Y9lu3ItrU3pi9Y3znUcW+6XxpQtk73
 4rZgHAA==
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

It meant to be IOCSR as CSR is not optional for LoongArch.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/loongarch/include/asm/cpu-features.h | 2 +-
 arch/loongarch/include/asm/cpu.h          | 2 +-
 arch/loongarch/kernel/cpu-probe.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/cpu-features.h b/arch/loongarch/include/asm/cpu-features.h
index 16a716f88a5c..0190ed28a647 100644
--- a/arch/loongarch/include/asm/cpu-features.h
+++ b/arch/loongarch/include/asm/cpu-features.h
@@ -50,7 +50,7 @@
 #define cpu_has_lbt_arm		cpu_opt(LOONGARCH_CPU_LBT_ARM)
 #define cpu_has_lbt_mips	cpu_opt(LOONGARCH_CPU_LBT_MIPS)
 #define cpu_has_lbt		(cpu_has_lbt_x86|cpu_has_lbt_arm|cpu_has_lbt_mips)
-#define cpu_has_csr		cpu_opt(LOONGARCH_CPU_CSR)
+#define cpu_has_iocsr		cpu_opt(LOONGARCH_CPU_IOCSR)
 #define cpu_has_tlb		cpu_opt(LOONGARCH_CPU_TLB)
 #define cpu_has_watch		cpu_opt(LOONGARCH_CPU_WATCH)
 #define cpu_has_vint		cpu_opt(LOONGARCH_CPU_VINT)
diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/asm/cpu.h
index 843f9c4ec980..7c44f4ede3a2 100644
--- a/arch/loongarch/include/asm/cpu.h
+++ b/arch/loongarch/include/asm/cpu.h
@@ -115,7 +115,7 @@ enum cpu_type_enum {
 #define LOONGARCH_CPU_LBT_ARM		BIT_ULL(CPU_FEATURE_LBT_ARM)
 #define LOONGARCH_CPU_LBT_MIPS		BIT_ULL(CPU_FEATURE_LBT_MIPS)
 #define LOONGARCH_CPU_TLB		BIT_ULL(CPU_FEATURE_TLB)
-#define LOONGARCH_CPU_CSR		BIT_ULL(CPU_FEATURE_CSR)
+#define LOONGARCH_CPU_IOCSR		BIT_ULL(CPU_FEATURE_IOCSR)
 #define LOONGARCH_CPU_WATCH		BIT_ULL(CPU_FEATURE_WATCH)
 #define LOONGARCH_CPU_VINT		BIT_ULL(CPU_FEATURE_VINT)
 #define LOONGARCH_CPU_CSRIPI		BIT_ULL(CPU_FEATURE_CSRIPI)
diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 14f0449f5452..4446616d497c 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -91,7 +91,7 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	unsigned int config;
 	unsigned long asid_mask;
 
-	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
+	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_IOCSR |
 		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
 
 	elf_hwcap = HWCAP_LOONGARCH_CPUCFG;

-- 
2.46.0


