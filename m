Return-Path: <kvm+bounces-26869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24735978A19
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 22:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 492D01C22361
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C513E150980;
	Fri, 13 Sep 2024 20:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="zfDQR15W";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oxn6Y8pS"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh3-smtp.messagingengine.com (fhigh3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3200C2F860;
	Fri, 13 Sep 2024 20:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726260073; cv=none; b=Grcx38CfHGtvzGE06piQQAAoVB+eua/JKDBAPoaen3z9HQ0689lPxdwdqvhDsnlGKqPcym8MpDBM4yXHCbrZt2gUZ09MyG4hcXdc3JaSP1p/8gbea1MvQvXxH+zVsAghBmn7J9QWHBeeOYkuDelbd+k1sl0W1Cli36I2mr8wyrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726260073; c=relaxed/simple;
	bh=CxkMsd4bJJkWrqyEQFy6R/lqvKTJ2ykNLfa/bCFXErY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JCgLQ4UKt5DXVpU+OuYMtruA9vgnNlWkFfgsztaM9e4Si+rviVwDSm1QNeilf4v12OYlDctarXFcpHz0AY1cvWpeOlvHmhwjTOZ7UNk3wB33Qpi+lJlBsbl7f91YUfoUat+UXPQEPhkzMwe45um1J52lTbJvk3SyK5VSMaOFcPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=zfDQR15W; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oxn6Y8pS; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AD14F1140322;
	Fri, 13 Sep 2024 16:32:43 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Fri, 13 Sep 2024 16:32:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726259563;
	 x=1726345963; bh=g3uETlfiUWlB/YD2dw5l2NaggelTzlICuj+8WCWMJOw=; b=
	zfDQR15W9GgDGLw+xPSBUhQLQ7ybsf5n5IEPACOZXj5xhBUeMeIlwsBolckNOnOF
	L9AvkfDMiNi47PkaqkiZwFkSyQ66iKHikRcS36WjChVMzjea88bltatpvWO1FNGo
	wskDfdOUMNekET7JMDPoJURnV//GS2vAzoewgwDF1mnHj3jXdj4ViCJ5BT/cBPz3
	mq69GegPQZmm+mLBfNEfqvm2jYkIAh2qQ+ZPN8MwrPJ281beBnwl86WDZPFMASR1
	lZo017HYZcjU4KmrPt1agSSDACofKvTH7BCTyxTTj33lZRjD0RCjSrIsLUC/T5BN
	p5zWwzRJx7lKwugtiXFcZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726259563; x=
	1726345963; bh=g3uETlfiUWlB/YD2dw5l2NaggelTzlICuj+8WCWMJOw=; b=o
	xn6Y8pSqtYQ87QSkAP8/04rm4eP5m9ce1jgaYE5KOvkG4i2JXacARtXl7VzAZjGY
	6BlMXTvEDLFB2p6zr/abvDhvizP0E5GyHDX7SZKVppzZIOBbjYnZa+7NfT4rjsvt
	cwh1fineSh5iCpUZbCxRKzNMx8N5S5DPE483qXgyhbXgpIEctRUE2LTq5ErU7bHo
	XG22Vqy8hxwjIKz0VsHp9U3g/Y3b35hf0UNeADEdctMqQE3xWFKbvPg/WCC02+e6
	17twGoMvtwnqFh3FpJ4EzodaFAyzU0QNt6LW2iX1owUFXzfW6EkJU5EgF7j6/boP
	qD7955vs67jibcDfImRpQ==
X-ME-Sender: <xms:a6HkZtiBJb53SH4sMQ62pA6XfGPQTQSFrw8ZRXcfdqg6rh5rNQOxZg>
    <xme:a6HkZiB1tvP59GpoHdtK16tm-g8tlgaDij_LE-tvdSJ13iAffVWO9ByRQcQi3MEy8
    0hc4GdA7ZDYsuXU9bM>
X-ME-Received: <xmr:a6HkZtH2ymID7_0wxcmYTPiKZRlW7yXdxHA1upknOf3xyXySz3csP16gK-WtDEKDUWs>
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
X-ME-Proxy: <xmx:a6HkZiRJunUHwCwc67q5YmFPNA-4RsgLxpKyypqqBtjwBEE6WQRVcw>
    <xmx:a6HkZqxAe18SnJja2vPphmkRwN14tNs-r4z3dfB6l1zKVxZxmsRZPw>
    <xmx:a6HkZo6tC6shUsnswSUMdmtxgawsrDrZsW3iwKybM4l6ZIj15qNvbA>
    <xmx:a6HkZvwKbOcOcFuwKsgPqZdCybev11hw3wMYWSb01CXBgspnZdPhFA>
    <xmx:a6HkZlrCYLuGAfBYxu3oArvbb9qV3oHYsQ3ANS75_k29H8T42x3V0To4>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Sep 2024 16:32:38 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Fri, 13 Sep 2024 21:32:05 +0100
Subject: [PATCH v3 2/4] LoongArch: cpu-probe: Move IOCSR probing out of
 cpu_probe_common
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240913-iocsr-v3-2-81a57f60350d@flygoat.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3243;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=CxkMsd4bJJkWrqyEQFy6R/lqvKTJ2ykNLfa/bCFXErY=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQnC6PPHFaLeGKy3nenkkaU9V1Rx/ZCQY+eHOkbl+RmW
 XWazD/ZUcrCIMbFICumyBIioNS3ofHigusPsv7AzGFlAhnCwMUpABPZncbwP6hjX27j5l7PJOOt
 uccEnzyUM1iiYV5nkdYu2O4/OSRVgOEPb133Svm2nZ0H8t41Zm4/Izij1KY47rtp6b19Kvd87kx
 nAAA=
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

IOCSR register definition appears to be a platform specific
spec instead of architecture spec, even for Loongson CPUs
there is no guarantee that IOCSR will always present.

Thus it's dangerous to perform IOCSR probing without checking
CPU type and instruction availability.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/loongarch/kernel/cpu-probe.c | 50 +++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index a5473bb673e5..8a868a10df9c 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -182,22 +182,6 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	if (config & CPUCFG6_PMP)
 		c->options |= LOONGARCH_CPU_PMP;
 
-	config = iocsr_read32(LOONGARCH_IOCSR_FEATURES);
-	if (config & IOCSRF_CSRIPI)
-		c->options |= LOONGARCH_CPU_CSRIPI;
-	if (config & IOCSRF_EXTIOI)
-		c->options |= LOONGARCH_CPU_EXTIOI;
-	if (config & IOCSRF_FREQSCALE)
-		c->options |= LOONGARCH_CPU_SCALEFREQ;
-	if (config & IOCSRF_FLATMODE)
-		c->options |= LOONGARCH_CPU_FLATMODE;
-	if (config & IOCSRF_EIODECODE)
-		c->options |= LOONGARCH_CPU_EIODECODE;
-	if (config & IOCSRF_AVEC)
-		c->options |= LOONGARCH_CPU_AVECINT;
-	if (config & IOCSRF_VM)
-		c->options |= LOONGARCH_CPU_HYPERVISOR;
-
 	config = csr_read32(LOONGARCH_CSR_ASID);
 	config = (config & CSR_ASID_BIT) >> CSR_ASID_BIT_SHIFT;
 	asid_mask = GENMASK(config - 1, 0);
@@ -240,15 +224,10 @@ static char cpu_full_name[MAX_NAME_LEN] = "        -        ";
 
 static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int cpu)
 {
+	uint32_t config;
+	const char *core_name = "Unknown";
 	uint64_t *vendor = (void *)(&cpu_full_name[VENDOR_OFFSET]);
 	uint64_t *cpuname = (void *)(&cpu_full_name[CPUNAME_OFFSET]);
-	const char *core_name = "Unknown";
-
-	if (!__cpu_full_name[cpu])
-		__cpu_full_name[cpu] = cpu_full_name;
-
-	*vendor = iocsr_read64(LOONGARCH_IOCSR_VENDOR);
-	*cpuname = iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
 
 	switch (BIT(fls(c->isa_level) - 1)) {
 	case LOONGARCH_CPU_ISA_LA32R:
@@ -284,6 +263,31 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 	}
 
 	pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], core_name);
+
+	if (!(c->options & LOONGARCH_CPU_IOCSR))
+		return;
+
+	*vendor = iocsr_read64(LOONGARCH_IOCSR_VENDOR);
+	*cpuname = iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
+
+	if (!__cpu_full_name[cpu])
+		__cpu_full_name[cpu] = cpu_full_name;
+
+	config = iocsr_read32(LOONGARCH_IOCSR_FEATURES);
+	if (config & IOCSRF_CSRIPI)
+		c->options |= LOONGARCH_CPU_CSRIPI;
+	if (config & IOCSRF_EXTIOI)
+		c->options |= LOONGARCH_CPU_EXTIOI;
+	if (config & IOCSRF_FREQSCALE)
+		c->options |= LOONGARCH_CPU_SCALEFREQ;
+	if (config & IOCSRF_FLATMODE)
+		c->options |= LOONGARCH_CPU_FLATMODE;
+	if (config & IOCSRF_EIODECODE)
+		c->options |= LOONGARCH_CPU_EIODECODE;
+	if (config & IOCSRF_AVEC)
+		c->options |= LOONGARCH_CPU_AVECINT;
+	if (config & IOCSRF_VM)
+		c->options |= LOONGARCH_CPU_HYPERVISOR;
 }
 
 #ifdef CONFIG_64BIT

-- 
2.46.0


