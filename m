Return-Path: <kvm+bounces-26065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E24397019D
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 12:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46CBB284F09
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 10:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863EC15B97D;
	Sat,  7 Sep 2024 10:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="ESj2jLG/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="I4y2+nOL"
X-Original-To: kvm@vger.kernel.org
Received: from fout7-smtp.messagingengine.com (fout7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93D415855B;
	Sat,  7 Sep 2024 10:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725704235; cv=none; b=QqLlOFx0u94qCIcti6HJ6ZLFn93ZmdyzCpwUccgHFRbR2fT/ON7muHa8BLAm5JfcTJPhbqboRilk8fOOnfKFWd/Aq24fax1XUGZRFbFSUNKYe/QMivMyrVoKXXXPRVrVb8C+KW6/NpfdbzTO9YcX6seEVMMZYdnmcSlFDxjMlb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725704235; c=relaxed/simple;
	bh=dGuxM8PZ+MkpKKAh5LWup1ti6kx4IwMUcMWFV7XToMY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZyyblTz6dQ36rH9uEA1g6pv9M1Aie3qBN5AcJtiJDAZOqSdNQ2Vrcwgqo5uKla3iBTTZeUOdrgM327/JftQzjCfELqmsoZvU3Y8EWy2Npk+NiFfJA03bhExnlytTUUcNm9Pxu1r/JO4iIf8QNg5IeAKXMH/Z2ll45YXu0PkUcIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=ESj2jLG/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=I4y2+nOL; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id EA3C61380313;
	Sat,  7 Sep 2024 06:17:11 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sat, 07 Sep 2024 06:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1725704231;
	 x=1725790631; bh=g18dTpnsZcS8drCZ6SuD1OxTNXBCkwaw+UxY/uw2PNw=; b=
	ESj2jLG/GfIvEZs1djVI9ihIWMmB8e4PI4Fe2UOfbSWwSAc/QDfK5O/SJ9CiOpJf
	hUTEo/PH4T6NK/vBNaaUHbIVl6jadmUcLLZv2TT4VlGDUojviGtuQ6jrvs9Pz5Dm
	1KkRS+tCmpKIwyE1BqcCTb0AVbgq/gupxPMgQYB1a+MEwkOaPj5ifidO4mBNGQD8
	9epHBKjavp3CWcFNoIFjODPHPLPlbKrPXggXt5uQmMLyq7cqMj7QfXcczI5wv6yP
	vg4hZnWXZVSSSc6+hryo7kt0NVYal4cpdFn6Mvrb+kgcCE/bLJCXcEHq8KLRxCB3
	8f1TskXRrtzjkwrzZ1fxMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725704231; x=
	1725790631; bh=g18dTpnsZcS8drCZ6SuD1OxTNXBCkwaw+UxY/uw2PNw=; b=I
	4y2+nOLZ0kIy4Y4nos+zZ1NS5wM9t3J+dfQOsfSHiUky61nL4wGSLdlT2F3V90kT
	hjc2FIc0PI1reJoVr1WAjQ1j6WlU88Lyu0+IIemBKKmqq9MEQQFzmWdRcMztGYqm
	EcxhMOj10UeK7k2lAi5Wv87tgO4fIZEqpGvEL1FkXxBumbvg63izNFqvQe/27vXV
	Kj5GQ3J9tLMFB8LkL7OZZZmFGd4R9okhe9I8k8EdTa37JAsW7WZyfBJHSd1z+RtQ
	YP9yhzsVXppCOHzMr4vfbIO1aRdQgvY386ojnMIpft8Gn3Wj5bXdD2cKQ97fIU8p
	he5kVqS/2iwBLFqUn4wcw==
X-ME-Sender: <xms:JyjcZvYkYYPd6DOVfr2od6iwktB9n0tUGjvzBbTeJHdRnWtX77MQHw>
    <xme:JyjcZubcT-aPJGF0Fuw0gW-8oW8WQe8K1tYDmfV2oTlAPbAojFRufZWxaik9olrmR
    4hsxINuMJ5T00D0OBU>
X-ME-Received: <xmr:JyjcZh8K4N-3BllzOm_MkJ--sMnjRFqg1gbBnEmrSz9DvOwHvcwJ--oI8__L2a-0MhE>
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
X-ME-Proxy: <xmx:JyjcZlqV8xZ8gVp3ZFk0EYYHCgQjQX30R27Xx97h4vOL2SGxs5yAaA>
    <xmx:JyjcZqo3IZVbjDgfrajZnAspvUjAQ9LOZPMrpuBnbcydjvHmCE1Xeg>
    <xmx:JyjcZrQLxpTlI41qX5C13lG0aLMhDitLo7Waf0iSKenHzCTcxsbfsA>
    <xmx:JyjcZipFZJuSVEyM1Mfwa9Gs_eILYInML1Omtl124ARxlzAot3OasA>
    <xmx:JyjcZgjks_piEYdA0C76s-flyFe-7Vucq7tCV2InvDggVOIR4oSeCDD6>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Sep 2024 06:17:10 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Sat, 07 Sep 2024 11:17:04 +0100
Subject: [PATCH 2/5] LoongArch: Probe more CPU features from CPUCFG
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240907-iocsr-v1-2-0c99b3334444@flygoat.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4645;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=dGuxM8PZ+MkpKKAh5LWup1ti6kx4IwMUcMWFV7XToMY=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQ7GkqmCz2jHJz9OBTndJn0lvxZ5drxo7fJYdUs8W929
 gKTfj7qKGVhEONikBVTZAkRUOrb0HhxwfUHWX9g5rAygQxh4OIUgImwMTL8zz+yQW3asld6b7kP
 1H+ZvC7+xsRnc27vap+8aOGsP3PnBD9jZHg/0SmIadtObqZ/s5LktK5ea+eWONr5ksGXxeG4os/
 8LawA
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Probe ISA level, TLB, IOCSR information from CPUCFG to
improve kernel resilience to different core implementations.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/loongarch/include/asm/cpu.h  |  2 +-
 arch/loongarch/kernel/cpu-probe.c | 47 ++++++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/asm/cpu.h
index 7c44f4ede3a2..31a2de821236 100644
--- a/arch/loongarch/include/asm/cpu.h
+++ b/arch/loongarch/include/asm/cpu.h
@@ -86,7 +86,7 @@ enum cpu_type_enum {
 #define CPU_FEATURE_LBT_ARM		11	/* CPU has ARM Binary Translation */
 #define CPU_FEATURE_LBT_MIPS		12	/* CPU has MIPS Binary Translation */
 #define CPU_FEATURE_TLB			13	/* CPU has TLB */
-#define CPU_FEATURE_CSR			14	/* CPU has CSR */
+#define CPU_FEATURE_IOCSR		14	/* CPU has IOCSR */
 #define CPU_FEATURE_WATCH		15	/* CPU has watchpoint registers */
 #define CPU_FEATURE_VINT		16	/* CPU has vectored interrupts */
 #define CPU_FEATURE_CSRIPI		17	/* CPU has CSR-IPI */
diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 4446616d497c..6a82ceb6e321 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -91,12 +91,23 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	unsigned int config;
 	unsigned long asid_mask;
 
-	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_IOCSR |
-		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
+	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_VINT |
+		     LOONGARCH_CPU_WATCH;
 
 	elf_hwcap = HWCAP_LOONGARCH_CPUCFG;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG1);
+
+	if (config & CPUCFG1_ISGR64)
+		set_isa(c, LOONGARCH_CPU_ISA_LA64);
+	else if (config & CPUCFG1_ISGR32)
+		set_isa(c, LOONGARCH_CPU_ISA_LA32S);
+	else
+		set_isa(c, LOONGARCH_CPU_ISA_LA32R);
+	if (config & CPUCFG1_PAGING)
+		c->options |= LOONGARCH_CPU_TLB;
+	if (config & CPUCFG1_IOCSR)
+		c->options |= LOONGARCH_CPU_IOCSR;
 	if (config & CPUCFG1_UAL) {
 		c->options |= LOONGARCH_CPU_UAL;
 		elf_hwcap |= HWCAP_LOONGARCH_UAL;
@@ -222,6 +233,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 {
 	uint64_t *vendor = (void *)(&cpu_full_name[VENDOR_OFFSET]);
 	uint64_t *cpuname = (void *)(&cpu_full_name[CPUNAME_OFFSET]);
+	const char *core_name = "Unknown";
 
 	if (!__cpu_full_name[cpu])
 		__cpu_full_name[cpu] = cpu_full_name;
@@ -232,40 +244,43 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 	switch (c->processor_id & PRID_SERIES_MASK) {
 	case PRID_SERIES_LA132:
 		c->cputype = CPU_LOONGSON32;
-		set_isa(c, LOONGARCH_CPU_ISA_LA32S);
 		__cpu_family[cpu] = "Loongson-32bit";
-		pr_info("32-bit Loongson Processor probed (LA132 Core)\n");
+		core_name = "LA132";
 		break;
 	case PRID_SERIES_LA264:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA264 Core)\n");
+		core_name = "LA264";
 		break;
 	case PRID_SERIES_LA364:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA364 Core)\n");
+		core_name = "LA364";
 		break;
 	case PRID_SERIES_LA464:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA464 Core)\n");
+		core_name = "LA464";
 		break;
 	case PRID_SERIES_LA664:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA664 Core)\n");
+		core_name = "LA664";
 		break;
 	default: /* Default to 64 bit */
-		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
-		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (Unknown Core)\n");
+		if (c->isa_level & LOONGARCH_CPU_ISA_LA64) {
+			c->cputype = CPU_LOONGSON64;
+			__cpu_family[cpu] = "Loongson-64bit";
+		} else if (c->isa_level & LOONGARCH_CPU_ISA_LA32S) {
+			c->cputype = CPU_LOONGSON32;
+			__cpu_family[cpu] = "Loongson-32bit";
+		} else if (c->isa_level & LOONGARCH_CPU_ISA_LA32R) {
+			c->cputype = CPU_LOONGSON32;
+			__cpu_family[cpu] = "Loongson-32bit Reduced";
+		}
 	}
+
+	pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], core_name);
 }
 
 #ifdef CONFIG_64BIT

-- 
2.46.0


