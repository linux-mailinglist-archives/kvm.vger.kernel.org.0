Return-Path: <kvm+bounces-26866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C779789FA
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 22:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A28091C21A87
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2002E154BFC;
	Fri, 13 Sep 2024 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="gBqRFvxv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="J2E6KkJ1"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A4C14F9FD;
	Fri, 13 Sep 2024 20:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726259561; cv=none; b=LJgHobQ42SJM28sG3LxT1PqO5IxcgCUnXJxf33h0JlbQYLHnHJTRXKliLbph14hQ5muf4YHeYsYSQHdDkUzqWvXGtSxtjjj/4fwAXRYwk/gtO4txwe3iYU5EPSUBisvIrAB6IyqFYO+VOilPRgOBsPPuRuQYWBzsBVWfcLSWyo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726259561; c=relaxed/simple;
	bh=R3vGKKP2k/8FDG76DaGfeG84fWyFmyAZsDiDvQedQFE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KS16MVrJaI0rRPreI2aCoMuhrXZm0Tyc3L0gCzWOqWXjVvZb38eDaPxOqtRmzD0E2PT+A+eP/wqFrYOBytOek0kjs1HPxgJD2EU439KZEHDz5YCb9SfThwltv1htHvjVToC06Ymh8fgP97pojrSeV6BWiiIePychdFeXLSeQ55w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=gBqRFvxv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=J2E6KkJ1; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CD8B51140331;
	Fri, 13 Sep 2024 16:32:37 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 13 Sep 2024 16:32:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726259557;
	 x=1726345957; bh=iw68DIBfVtliWARvyI5TKPIRK/P4hwpUfZK5MvSS+54=; b=
	gBqRFvxvNrHl3ORsrO9V+emrEaWR6MPLeRe3+mUtJd6l7oIP/ThgvHcz5OMSYGjX
	1YLd56n+amc3X6PmTY1mRly/vL21Yn6qeMTTPIxbKWY36o12S1tFM2RLf5s7QALD
	YO04xDDs05L0WY/2mW4jpswT+BLDxfcBISfyOX7ylKbwg/A0TgOynTE2bQ4/6Bm1
	AgVa1xnYn08+oAiEdvfnV50fF8PQQutyKI6i5vd8QatTFxxptAT+vuo2zQhGYrYy
	2/SB/UIoozcQnPwR4bnhbz7/yu6ZxMrr4HV7T6bOEkAVff7awnHHzJZo1RmotYqS
	XgHcYDWVABDmrkHeUfuWiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726259557; x=
	1726345957; bh=iw68DIBfVtliWARvyI5TKPIRK/P4hwpUfZK5MvSS+54=; b=J
	2E6KkJ1OSNv5r+M6Y/J4fmV16H/fzTSapJ0oIU92h+rakThiz6Lmbvwml9ik8KQF
	ayIWH8YUCYqRVIPZvkT4wvIrvJigBS4CSETb4J7ByP0xlwppdxktAZLeYcQHl0g8
	d5wCQdiYSgrd9kKOwNNQPhG7p/lNRp9W5e8MCzULzmGLrVOAzEByP59qdFwbzYFN
	6aiIazS+A6+84rqzVZw47h+LI/4BHvH+E8LnY/dl4GWQKdqfXc0hwIhi4gVIbkvV
	0n5UITdBdQzArwdceTTFAoUz80tO7/HHxt0qOrl0JhrCIJBueuQVqJubVSB30qWF
	fhhKvouD3rzWG2QFvqF1g==
X-ME-Sender: <xms:ZaHkZoQzoamnmmSTYv9lLC5cTRuRWB8WyEAkbOt8w-ptIR3aBDGADg>
    <xme:ZaHkZlyjkUsBghHsyVv8hBfMNxefvlGZZh9LW1rXooGtMQuljAo91z-xEoO5wlXY7
    bis6X9hAKzGvMNbRuc>
X-ME-Received: <xmr:ZaHkZl2O913ol1TYdRszU555eEY1DWlmVu1ovRv4wi3-u_XGIfeJhA_u5yUkN3febKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephfffufggtgfgkfhfjgfvvefosehtjeertdertdej
    necuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhi
    hgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepvdekiefhfeevkeeuveetfeelffek
    gedugefhtdduudeghfeuveegffegudekjeelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdr
    tghomhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtth
    hopegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhhvmhes
    vhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmihhpshesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehvihhrvghshhdrkhhumhgrrhes
    lhhinhgrrhhordhorhhgpdhrtghpthhtohepjhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomhdprhgtphhtthhopehlihhnuhigqdhpmhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehkvghrnhgvlhesgigvnhdtnhdrnhgrmhgvpdhrtghpthhtoh
    eprhgrfhgrvghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:ZaHkZsCX7pRkY4b3M6q_tkYMDFrTbK_cHLvxexZaTCzDDkxZRUmF7w>
    <xmx:ZaHkZhjhMGdYUBQd-Qe27dD0MiQ8PjlliHMqBM1KC1U4Zvo9E2qRBA>
    <xmx:ZaHkZooDEq1Bc-Hbf47XX-GKWLEe6Jr8shUQHi6OmhE8MMc3o7lCtQ>
    <xmx:ZaHkZkgPr0F8Hu_lerkatT0kCvWLaDFSw3Wo3RnIF6Vdd5rRg-N_EQ>
    <xmx:ZaHkZqZx3Z687lB4m1aUGBFnWCBszEWDl8fhx6EYoW80AZiYLW-1q1mx>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Sep 2024 16:32:32 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Fri, 13 Sep 2024 21:32:04 +0100
Subject: [PATCH v3 1/4] LoongArch: Probe more CPU features from CPUCFG
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240913-iocsr-v3-1-81a57f60350d@flygoat.com>
References: <20240913-iocsr-v3-0-81a57f60350d@flygoat.com>
In-Reply-To: <20240913-iocsr-v3-0-81a57f60350d@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5981;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=R3vGKKP2k/8FDG76DaGfeG84fWyFmyAZsDiDvQedQFE=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQnC6M/3C8vnRJiedr55pnM5BU1v/lYfdT3XGc5GLsw2
 FmhS0Oko5SFQYyLQVZMkSVEQKlvQ+PFBdcfZP2BmcPKBDKEgYtTACby35SRYes8R400jk+v1r0Q
 28hV8Tox1Dw9dPs3ie8BPxLu7IplbGZk+NKRIP2ph3m2Q+2sWc8ELjv//n9t0Z/D6Zyvf/s95fB
 X5QIA
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Probe ISA level, TLB, IOCSR information from CPUCFG to
improve kernel resilience to different core implementations.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/loongarch/include/asm/cpu.h       |  4 ++
 arch/loongarch/include/asm/loongarch.h |  3 +-
 arch/loongarch/kernel/cpu-probe.c      | 70 +++++++++++++++++++++-------------
 3 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/asm/cpu.h
index 843f9c4ec980..251a15439cff 100644
--- a/arch/loongarch/include/asm/cpu.h
+++ b/arch/loongarch/include/asm/cpu.h
@@ -100,6 +100,8 @@ enum cpu_type_enum {
 #define CPU_FEATURE_HYPERVISOR		25	/* CPU has hypervisor (running in VM) */
 #define CPU_FEATURE_PTW			26	/* CPU has hardware page table walker */
 #define CPU_FEATURE_AVECINT		27	/* CPU has avec interrupt */
+#define CPU_FEATURE_IOCSR		28	/* CPU has IOCSR */
+#define CPU_FEATURE_LSPW		29	/* CPU has LSPW */
 
 #define LOONGARCH_CPU_CPUCFG		BIT_ULL(CPU_FEATURE_CPUCFG)
 #define LOONGARCH_CPU_LAM		BIT_ULL(CPU_FEATURE_LAM)
@@ -129,5 +131,7 @@ enum cpu_type_enum {
 #define LOONGARCH_CPU_HYPERVISOR	BIT_ULL(CPU_FEATURE_HYPERVISOR)
 #define LOONGARCH_CPU_PTW		BIT_ULL(CPU_FEATURE_PTW)
 #define LOONGARCH_CPU_AVECINT		BIT_ULL(CPU_FEATURE_AVECINT)
+#define LOONGARCH_CPU_IOCSR		BIT_ULL(CPU_FEATURE_IOCSR)
+#define LOONGARCH_CPU_LSPW		BIT_ULL(CPU_FEATURE_LSPW)
 
 #endif /* _ASM_CPU_H */
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 631d249b3ef2..23af28f00c3c 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -60,8 +60,7 @@
 #define  CPUCFG0_PRID			GENMASK(31, 0)
 
 #define LOONGARCH_CPUCFG1		0x1
-#define  CPUCFG1_ISGR32			BIT(0)
-#define  CPUCFG1_ISGR64			BIT(1)
+#define  CPUCFG1_ISA			GENMASK(1, 0)
 #define  CPUCFG1_PAGING			BIT(2)
 #define  CPUCFG1_IOCSR			BIT(3)
 #define  CPUCFG1_PABITS			GENMASK(11, 4)
diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 14f0449f5452..a5473bb673e5 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -92,11 +92,29 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	unsigned long asid_mask;
 
 	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
-		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
+		     LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
 
 	elf_hwcap = HWCAP_LOONGARCH_CPUCFG;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG1);
+
+	switch (config & CPUCFG1_ISA) {
+	case 0:
+		set_isa(c, LOONGARCH_CPU_ISA_LA32R);
+		break;
+	case 1:
+		set_isa(c, LOONGARCH_CPU_ISA_LA32S);
+		break;
+	case 2:
+		set_isa(c, LOONGARCH_CPU_ISA_LA64);
+		break;
+	default:
+		pr_warn("Warning: unknown ISA level\n");
+	}
+	if (config & CPUCFG1_PAGING)
+		c->options |= LOONGARCH_CPU_TLB;
+	if (config & CPUCFG1_IOCSR)
+		c->options |= LOONGARCH_CPU_IOCSR;
 	if (config & CPUCFG1_UAL) {
 		c->options |= LOONGARCH_CPU_UAL;
 		elf_hwcap |= HWCAP_LOONGARCH_UAL;
@@ -157,6 +175,8 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 		elf_hwcap |= HWCAP_LOONGARCH_LBT_MIPS;
 	}
 #endif
+	if (config & CPUCFG2_LSPW)
+		c->options |= LOONGARCH_CPU_LSPW;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG6);
 	if (config & CPUCFG6_PMP)
@@ -222,6 +242,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 {
 	uint64_t *vendor = (void *)(&cpu_full_name[VENDOR_OFFSET]);
 	uint64_t *cpuname = (void *)(&cpu_full_name[CPUNAME_OFFSET]);
+	const char *core_name = "Unknown";
 
 	if (!__cpu_full_name[cpu])
 		__cpu_full_name[cpu] = cpu_full_name;
@@ -229,43 +250,40 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 	*vendor = iocsr_read64(LOONGARCH_IOCSR_VENDOR);
 	*cpuname = iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
 
-	switch (c->processor_id & PRID_SERIES_MASK) {
-	case PRID_SERIES_LA132:
+	switch (BIT(fls(c->isa_level) - 1)) {
+	case LOONGARCH_CPU_ISA_LA32R:
 		c->cputype = CPU_LOONGSON32;
-		set_isa(c, LOONGARCH_CPU_ISA_LA32S);
-		__cpu_family[cpu] = "Loongson-32bit";
-		pr_info("32-bit Loongson Processor probed (LA132 Core)\n");
+		__cpu_family[cpu] = "Loongson-32bit Reduced";
 		break;
-	case PRID_SERIES_LA264:
+	case LOONGARCH_CPU_ISA_LA32S:
+		c->cputype = CPU_LOONGSON32;
+		__cpu_family[cpu] = "Loongson-32bit Standard";
+		break;
+	case LOONGARCH_CPU_ISA_LA64:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA264 Core)\n");
+		break;
+	}
+
+	switch (c->processor_id & PRID_SERIES_MASK) {
+	case PRID_SERIES_LA132:
+		core_name = "LA132";
+		break;
+	case PRID_SERIES_LA264:
+		core_name = "LA264";
 		break;
 	case PRID_SERIES_LA364:
-		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
-		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA364 Core)\n");
+		core_name = "LA364";
 		break;
 	case PRID_SERIES_LA464:
-		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
-		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA464 Core)\n");
+		core_name = "LA464";
 		break;
 	case PRID_SERIES_LA664:
-		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
-		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA664 Core)\n");
+		core_name = "LA664";
 		break;
-	default: /* Default to 64 bit */
-		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
-		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (Unknown Core)\n");
 	}
+
+	pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], core_name);
 }
 
 #ifdef CONFIG_64BIT

-- 
2.46.0


