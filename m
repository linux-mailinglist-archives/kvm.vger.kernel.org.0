Return-Path: <kvm+bounces-26768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD3A97731E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 22:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F7BC2825D6
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D441C2DC4;
	Thu, 12 Sep 2024 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="fjynIgDq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="R19YsL+N"
X-Original-To: kvm@vger.kernel.org
Received: from fout8-smtp.messagingengine.com (fout8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E940F1C242F;
	Thu, 12 Sep 2024 20:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726174589; cv=none; b=DpVMpFd/2Sl0Qgh2AkPUPwav6twUuTostZSsLuWMkZMHolAZzBdler8O1mjEJQhsrd6XNdeh9Z53jKZ5CjFMYznCf8cO2LrDjK10Scy1M9zTIbQ6Cth3za6z4PYqXPnh3zUuIQTA8fv1Be8stw6fs24q2ygF80tj5P5BfCzKi9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726174589; c=relaxed/simple;
	bh=7kW0y1NHB2fQVkpctuFfg0V/Ye36qaSzqoLCC/fpVB4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jZJvxz21LIUlFMDZiyaWkSO0I6fP1WnOJGAUXrpzFoIQG6JT4QjP5F5eDsukIweFAHNXH/lFmB3tPzjxZfaw0wDEeWqiKnlFpl42/F4VBo60MwcQwoYwnQiO1Vpr5/BsyEeKGr9RDC2IjaJqt1CMDcKISuKSHec32LCDWIFr1Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=fjynIgDq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=R19YsL+N; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 27D0B13804B6;
	Thu, 12 Sep 2024 16:56:26 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 12 Sep 2024 16:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726174586;
	 x=1726260986; bh=DnUm5Y215poN8ylXsIUu+Ch7S5y7gO7zCsEWwSS402c=; b=
	fjynIgDqHTOAmbJRcWG7VL0BbSWUY8Ct5Ux0nAUyDPo+gO2udJkLt+BeqC0pomN2
	bxgdTxCgL1eYcHj6XOGZDNac5aiZ9zy/1uyj6AM3umyb0G1rqmVgORE0GwsB25WU
	W02/nfYuXFpcO4ynmAGHT1bKaToOK+BEIQpAra+JdFmFZWFGQa3oKjhBXMCP2JxX
	V8sptCE5wNzMMFfEZOwozLpWpqUp7BudgYGRYMC1Eksdexsk/9tKA6xC/zMc9K6y
	w0Ja+XIIIQKLSQOQ8v1KVvHmo02nCPPyWB3BlUB29FlYOCR3HHTfoJjNETgFigiL
	WwPk51k+ZEy40852tgnNyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726174586; x=
	1726260986; bh=DnUm5Y215poN8ylXsIUu+Ch7S5y7gO7zCsEWwSS402c=; b=R
	19YsL+N23shVwA0ZPoFqId4MMahxRw6duMuO+YeT2pgHUYy9kfwfh9VEN6BCu0xt
	JeGViOqul/uRnK6kOpNGmZCiXb2ZSKTIrfQueHk94VeukcHoI+OE49+Te6NxB9oU
	dqcxn4lqjgwfby/ypNDBMqMgDyVVYtnnFdx7oNMsAH8bYCFHNO6ojGmER8ZErNpS
	BwG6b7FY2ya35a+PphOIviOnzTuvAX0NVqedBTUhulhCLemfZZtEIRlBaNeFGAcF
	lbwzQNyfYV3QGv8tPVcHfjaFucqadAHA99+iuvPH59FrFPUtXY+7KOC6YpdNNmsG
	bzmZ5EseiCrulP/+Sd3Vg==
X-ME-Sender: <xms:eVXjZhMERNA6vJi0Zg2f3OI3lSfKvYClLxV7xP9TWpGClVn4nDrQ3A>
    <xme:eVXjZj_qGEwIl0qwwNDCWg73gwYGcQBwHIO1bswNeQ0PC4VkdIVM6gVX6KgGckjic
    cqIyFCp99ga65mFX4Y>
X-ME-Received: <xmr:eVXjZgSvhFRtxIW_VKTiZCF80WQCdLJV3nAT8BSDSOAV4pJFn9odzP-sPwOsELrGZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejfedgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhfffugggtgffkfhgjvfevofesthejredtredt
    jeenucfhrhhomheplfhirgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflh
    ihghhorghtrdgtohhmqeenucggtffrrghtthgvrhhnpedvkeeihfefveekueevteefleff
    keegudeghfdtuddugefhueevgeffgedukeejleenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorght
    rdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtoheplhhoohhngh
    grrhgthheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhp
    mhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgr
    nhhkvghnrdguvgdprhgtphhtthhopehjihgrgihunhdrhigrnhhgsehflhihghhorghtrd
    gtohhmpdhrtghpthhtoheprhgrfhgrvghlsehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:eVXjZtuIT0bFDzZYmCTIkM5T2sbhZ1e5DCzyyyPwOCx9Guh-P3Rd6Q>
    <xmx:eVXjZpfL-bQHDnPk9lCoXlRcky5aYXkxf-jbkg4Bi79vLePC2QhlqQ>
    <xmx:eVXjZp31X50_NBsEU0h3KBNICpuR7d1qTIUlO4bwimEADBfA-VhTpA>
    <xmx:eVXjZl8z4D2a1aGTszH3TAsywbO_d9hD6NGV7kPIoOQ5-J-N36l8mw>
    <xmx:elXjZn3JCwT13soynUXB8jozUpzYFNRqHJRkbH-TSwxSbLmvoF9xuphX>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Sep 2024 16:56:24 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Thu, 12 Sep 2024 21:55:55 +0100
Subject: [PATCH v2 2/4] LoongArch: cpu-probe: Move IOCSR probing out of
 cpu_probe_common
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240912-iocsr-v2-2-e88f75b37da4@flygoat.com>
References: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com>
In-Reply-To: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3242;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=7kW0y1NHB2fQVkpctuFfg0V/Ye36qaSzqoLCC/fpVB4=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrTHocU3ejmOtMsxTnnyNtZr+vuZNk8z1zbzTvwewVtY7
 irbzrWso5SFQYyLQVZMkSVEQKlvQ+PFBdcfZP2BmcPKBDKEgYtTACbilMXI8MTB6JWZlsr+hhca
 ZjfPGnzivZKqu2LC6emXG3YWqBo7TmNkmL2vM5FppiPzzA27/EVcHpfmXdjDmfi9IORY2Jdlu87
 KcwAA
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
index 5dc8ca3c4387..d1a9bb77145f 100644
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
 
 	switch (c->processor_id & PRID_SERIES_MASK) {
 	case PRID_SERIES_LA132:
@@ -290,6 +269,31 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 	}
 
 	pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], core_name);
+
+	if (c->options & LOONGARCH_CPU_IOCSR)
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


