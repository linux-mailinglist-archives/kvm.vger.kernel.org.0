Return-Path: <kvm+bounces-9810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F360B8670E1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A1001F29CAC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D145B67A;
	Mon, 26 Feb 2024 10:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgAw7geM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF015B5DD
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942381; cv=none; b=l/slmDkGMnZ+uKj213wYMV4uhodS+bky8dlh+qS1CQobr8hM4HKHQ8XiTZCKIC/Kpu2mFE7KysHo9Zc1Ax1Z4SvQVWvRRDpWoTWO7q3DHXpoifk0LpLURro4aYDKzfgZMklfa8AxfUpTCsyU2AsiKPP0qaw9BOAiUEENqgJ8T6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942381; c=relaxed/simple;
	bh=w+qxqkxLDeUSt+QsfxSGX2krcf8rTRx2nGfi9y4qRZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J84+GserznNxkZDb99MsDIQPe2WKFXL2y8sGbx+qp9BS6TduRyJCk0SncAjZYouwk2kc02POm1nwzmhvnuT1BMEJMzihQXmz3x+LvP9RL7bENL1vJ6Nb7n3+OW5Fy/v0aevRPePQuLoSybn3i+nfNP+DHZ6du96/rN5gL2FLAKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgAw7geM; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e45d0c9676so1584423b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942378; x=1709547178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYYmGQCWnlpJEukXy2vYcJR+/wrg4VAxzNQfnU8r/po=;
        b=SgAw7geMD40VaFYt6iM0YFROUQvlYQmTZxthlwpcPPBZf2qvcTwV0slhnJlBwliy+g
         KufFiciwbali6TKjuqepw1Yd7nrYM92fQdyUNonzKfcdB4ibfN+YTIyehik/W0ukTegL
         mseR9t3DyVsxWk0iD/MNf2Z4r5BF0yWgQICGcSb/vurEiZF8jow+Uc3biEgyFiYBOYcz
         P2XvzKEtEINqEEqAQWqjGm3kVID5pehfLNn5KvGEVTjdEdM6vtjVDf29qzPPeLRCqwTe
         iBpjUDve20Ky03yz0H+f97BozEiDZULGjW3OqjZMcLh04YfQjd1yC6P3MKC8zQMsw4bl
         FiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942378; x=1709547178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYYmGQCWnlpJEukXy2vYcJR+/wrg4VAxzNQfnU8r/po=;
        b=eGSO9KxARt2BK1b4tHCcBpfc5TRrtxAYq0kgM4TH9df10Sokkb8XQcdnDtc9MloP/d
         0377q6rQyUQC0c4GtyJvDbxHRxuFc9rWy1kmtG7q0PC8DuBAaDAlvDQtgGTkmgr6x8VL
         E+hktDb4LD0L+X5Y2ewFbi9X+G4NRZMkCBBhd6e26rWHwVvPSzZ/MnEgzf0cUKYO3pjy
         9RmqePsjvzUGsv4DwQ8WyWkCVdwWN59S9zmDudNdJfl3Xa5mHhyYI5LilxOIa8cULu5L
         O3fv5b9oERRDY/yWb8PwECokiKpnQBcDp6fShU+YrYQ02xCEM7mBkI6BGNNiNxbFYy0b
         0VFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUnkGjH4K80gRat3/Mjs4jVzGh/WtT8qUdoOf1BOqyQWcGCJibSFWdb55eCiYfcl+xfqnPqBM/lCID5uItWfGgDu20
X-Gm-Message-State: AOJu0YzBph3at/UZ6LAnkKjYuj5liPRh/F42XQvZLxd/qTGK5G13P1CB
	XtcAic5Dm38OL5KivGzMmgYYpyCt9pMZBSKbNqwyOsGoH00AZnh3
X-Google-Smtp-Source: AGHT+IEdq4zwxsW8SPU0gdKBe9h+J7t4LmwoFVeI/toZj4vdfpvFCD1WPX+CV3G2UU394dvRvp4LYw==
X-Received: by 2002:a05:6a20:daa8:b0:1a0:eb43:421b with SMTP id iy40-20020a056a20daa800b001a0eb43421bmr6637808pzb.28.1708942378024;
        Mon, 26 Feb 2024 02:12:58 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:12:57 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 06/32] powerpc/sprs: Specify SPRs with data rather than code
Date: Mon, 26 Feb 2024 20:11:52 +1000
Message-ID: <20240226101218.1472843-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A significant rework that builds an array of 'struct spr', where each
element describes an SPR. This makes various metadata about the SPR
like name and access type easier to carry and use.

Hypervisor privileged registers are described despite not being used
at the moment for completeness, but also the code might one day be
reused for a hypervisor-privileged test.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/reg.h |   2 +
 powerpc/sprs.c        | 647 +++++++++++++++++++++++++++++-------------
 2 files changed, 457 insertions(+), 192 deletions(-)

diff --git a/lib/powerpc/asm/reg.h b/lib/powerpc/asm/reg.h
index 6810c1d82..1f991288e 100644
--- a/lib/powerpc/asm/reg.h
+++ b/lib/powerpc/asm/reg.h
@@ -5,6 +5,8 @@
 
 #define UL(x) _AC(x, UL)
 
+#define SPR_SRR0	0x01a
+#define SPR_SRR1	0x01b
 #define SPR_TB		0x10c
 #define SPR_SPRG0	0x110
 #define SPR_SPRG1	0x111
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index a19d80a1a..8253ea971 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -30,229 +30,458 @@
 #include <asm/time.h>
 #include <asm/barrier.h>
 
-uint64_t before[1024], after[1024];
-
-/* Common SPRs for all PowerPC CPUs */
-static void set_sprs_common(uint64_t val)
+/* "Indirect" mfspr/mtspr which accept a non-constant spr number */
+static uint64_t __mfspr(unsigned spr)
 {
-	mtspr(9, val);		/* CTR */
-	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
-	mtspr(274, val);	/* SPRG2 */
-	mtspr(275, val);	/* SPRG3 */
+	uint64_t tmp;
+	uint64_t ret;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mfspr	%1, .LSPR		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp),
+	  "=r"(ret)
+	: "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr");
+
+	return ret;
 }
 
-/* SPRs from PowerPC Operating Environment Architecture, Book III, Vers. 2.01 */
-static void set_sprs_book3s_201(uint64_t val)
+static void __mtspr(unsigned spr, uint64_t val)
 {
-	mtspr(18, val);		/* DSISR */
-	mtspr(19, val);		/* DAR */
-	mtspr(152, val);	/* CTRL */
-	mtspr(256, val);	/* VRSAVE */
-	mtspr(786, val);	/* MMCRA */
-	mtspr(795, val);	/* MMCR0 */
-	mtspr(798, val);	/* MMCR1 */
+	uint64_t tmp;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mtspr	.LSPR, %1		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp)
+	: "r"(val),
+	  "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr", "xer");
 }
 
+static uint64_t before[1024], after[1024];
+
+#define SPR_PR_READ	0x0001
+#define SPR_PR_WRITE	0x0002
+#define SPR_OS_READ	0x0010
+#define SPR_OS_WRITE	0x0020
+#define SPR_HV_READ	0x0100
+#define SPR_HV_WRITE	0x0200
+
+#define RW		0x333
+#define RO		0x111
+#define WO		0x222
+#define OS_RW		0x330
+#define OS_RO		0x110
+#define OS_WO		0x220
+#define HV_RW		0x300
+#define HV_RO		0x100
+#define HV_WO		0x200
+
+#define SPR_ASYNC	0x1000	/* May be updated asynchronously */
+#define SPR_INT		0x2000	/* May be updated by synchronous interrupt */
+#define SPR_HARNESS	0x4000	/* Test harness uses the register */
+
+struct spr {
+	const char	*name;
+	uint8_t		width;
+	uint16_t	access;
+	uint16_t	type;
+};
+
+/* SPRs common denominator back to PowerPC Operating Environment Architecture */
+static const struct spr sprs_common[1024] = {
+  [1] = { "XER",	64,	RW,		SPR_HARNESS, }, /* Used by compiler */
+  [8] = { "LR", 	64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
+  [9] = { "CTR",	64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
+ [18] = { "DSISR",	32,	OS_RW,		SPR_INT, },
+ [19] = { "DAR",	64,	OS_RW,		SPR_INT, },
+ [26] = { "SRR0",	64,	OS_RW,		SPR_INT, },
+ [27] = { "SRR1",	64,	OS_RW,		SPR_INT, },
+[268] = { "TB",		64,	RO	,	SPR_ASYNC, },
+[269] = { "TBU",	32,	RO,		SPR_ASYNC, },
+[272] = { "SPRG0",	64,	OS_RW,		SPR_HARNESS, }, /* Interrupt stacr */
+[273] = { "SPRG1",	64,	OS_RW,		SPR_HARNESS, }, /* Interrupt Scratch */
+[274] = { "SPRG2",	64,	OS_RW, },
+[275] = { "SPRG3",	64,	OS_RW, },
+[287] = { "PVR",	32,	OS_RO, },
+};
+
+/* SPRs from PowerPC Operating Environment Architecture, Book III, Vers. 2.01 */
+static const struct spr sprs_201[1024] = {
+ [22] = { "DEC",	32,	OS_RW,		SPR_ASYNC, },
+ [25] = { "SDR1",	64,	HV_RW | OS_RO, },
+ [29] = { "ACCR",	64,	OS_RW, },
+[136] = { "CTRL",	32,	RO, },
+[152] = { "CTRL",	32,	OS_WO, },
+[259] = { "SPRG3",	64,	RO, },
+/* ASR, EAR omitted */
+[284] = { "TBL",	32,	HV_WO, },
+[285] = { "TBU",	32,	HV_WO, },
+[310] = { "HDEC",	32,	HV_RW,		SPR_ASYNC, },
+[1013]= { "DABR",	64,	HV_RW | OS_RO, },
+[1023]= { "PIR",	32,	OS_RO,		SPR_ASYNC, }, /* Can't be virtualised, appears to be async */
+};
+
+static const struct spr sprs_970_pmu[1024] = {
+/* POWER4+ PMU, should confirm with PPC970 */
+[770] = { "MMCRA",	64,	RO, },
+[771] = { "PMC1",	32,	RO, },
+[772] = { "PMC2",	32,	RO, },
+[773] = { "PMC3",	32,	RO, },
+[774] = { "PMC4",	32,	RO, },
+[775] = { "PMC5",	32,	RO, },
+[776] = { "PMC6",	32,	RO, },
+[777] = { "PMC7",	32,	RO, },
+[778] = { "PMC8",	32,	RO, },
+[779] = { "MMCR0",	64,	RO, },
+[780] = { "SIAR",	64,	RO, },
+[781] = { "SDAR",	64,	RO, },
+[782] = { "MMCR1",	64,	RO, },
+[786] = { "MMCRA",	64,	OS_RW, },
+[787] = { "PMC1",	32,	OS_RW, },
+[788] = { "PMC2",	32,	OS_RW, },
+[789] = { "PMC3",	32,	OS_RW, },
+[790] = { "PMC4",	32,	OS_RW, },
+[791] = { "PMC5",	32,	OS_RW, },
+[792] = { "PMC6",	32,	OS_RW, },
+[793] = { "PMC7",	32,	OS_RW, },
+[794] = { "PMC8",	32,	OS_RW, },
+[795] = { "MMCR0",	64,	OS_RW, },
+[796] = { "SIAR",	64,	OS_RW, },
+[797] = { "SDAR",	64,	OS_RW, },
+[798] = { "MMCR1",	64,	OS_RW, },
+};
+
+/* These are common SPRs from 2.07S onward (POWER CPUs that support KVM HV) */
+static const struct spr sprs_power_common[1024] = {
+  [3] = { "DSCR",	64,	RW, },
+ [13] = { "AMR",	64,	RW, },
+ [17] = { "DSCR",	64,	OS_RW, },
+ [28] = { "CFAR",	64,	OS_RW,		SPR_ASYNC, }, /* Effectively async */
+ [29] = { "AMR",	64,	OS_RW, },
+ [61] = { "IAMR",	64,	OS_RW, },
+[136] = { "CTRL",	32,	RO, },
+[152] = { "CTRL",	32,	OS_WO, },
+[153] = { "FSCR",	64,	OS_RW, },
+[157] = { "UAMOR",	64,	OS_RW, },
+[159] = { "PSPB",	32,	OS_RW, },
+[176] = { "DPDES",	64,	HV_RW | OS_RO, },
+[180] = { "DAWR0",	64,	HV_RW, },
+[186] = { "RPR",	64,	HV_RW, },
+[187] = { "CIABR",	64,	HV_RW, },
+[188] = { "DAWRX0",	32,	HV_RW, },
+[190] = { "HFSCR",	64,	HV_RW, },
+[256] = { "VRSAVE",	32,	RW, },
+[259] = { "SPRG3",	64,	RO, },
+[284] = { "TBL",	32,	HV_WO, },
+[285] = { "TBU",	32,	HV_WO, },
+[286] = { "TBU40",	64,	HV_WO, },
+[304] = { "HSPRG0",	64,	HV_RW, },
+[305] = { "HSPRG1",	64,	HV_RW, },
+[306] = { "HDSISR",	32,	HV_RW,		SPR_INT, },
+[307] = { "HDAR",	64,	HV_RW,		SPR_INT, },
+[308] = { "SPURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[309] = { "PURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[313] = { "HRMOR",	64,	HV_RW, },
+[314] = { "HSRR0",	64,	HV_RW,		SPR_INT, },
+[315] = { "HSRR1",	64,	HV_RW,		SPR_INT, },
+[318] = { "LPCR",	64,	HV_RW, },
+[319] = { "LPIDR",	32,	HV_RW, },
+[336] = { "HMER",	64,	HV_RW, },
+[337] = { "HMEER",	64,	HV_RW, },
+[338] = { "PCR",	64,	HV_RW, },
+[349] = { "AMOR",	64,	HV_RW, },
+[446] = { "TIR",	64,	OS_RO, },
+[800] = { "BESCRS",	64,	RW, },
+[801] = { "BESCRSU",	32,	RW, },
+[802] = { "BESCRR",	64,	RW, },
+[803] = { "BESCRRU",	32,	RW, },
+[804] = { "EBBHR",	64,	RW, },
+[805] = { "EBBRR",	64,	RW, },
+[806] = { "BESCR",	64,	RW, },
+[815] = { "TAR",	64,	RW, },
+[848] = { "IC",		64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[849] = { "VTB",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[896] = { "PPR",	64,	RW, },
+[898] = { "PPR32",	32,	RW, },
+[1023]= { "PIR",	32,	OS_RO,		SPR_ASYNC, }, /* Can't be virtualised, appears to be async */
+};
+
+static const struct spr sprs_tm[1024] = {
+#if 0
+	/* XXX: leave these out until enabling TM facility (and more testing) */
+[128] = { "TFHAR",	64,	RW, },
+[129] = { "TFIAR",	64,	RW, },
+[130] = { "TEXASR",	64,	RW, },
+[131] = { "TEXASRU",	32,	RW, },
+#endif
+};
+
 /* SPRs from PowerISA 2.07 Book III-S */
-static void set_sprs_book3s_207(uint64_t val)
-{
-	mtspr(3, val);		/* DSCR */
-	mtspr(13, val);		/* AMR */
-	mtspr(17, val);		/* DSCR */
-	mtspr(18, val);		/* DSISR */
-	mtspr(19, val);		/* DAR */
-	mtspr(29, val);		/* AMR */
-	mtspr(61, val);		/* IAMR */
-	// mtspr(152, val);	/* CTRL */  /* TODO: Needs a fix in KVM */
-	mtspr(153, val);	/* FSCR */
-	mtspr(157, val);	/* UAMOR */
-	mtspr(159, val);	/* PSPB */
-	mtspr(256, val);	/* VRSAVE */
-	// mtspr(272, val);	/* SPRG0 */ /* Used by our exception handler */
-	mtspr(769, val);	/* MMCR2 */
-	mtspr(770, val);	/* MMCRA */
-	mtspr(771, val);	/* PMC1 */
-	mtspr(772, val);	/* PMC2 */
-	mtspr(773, val);	/* PMC3 */
-	mtspr(774, val);	/* PMC4 */
-	mtspr(775, val);	/* PMC5 */
-	mtspr(776, val);	/* PMC6 */
-	mtspr(779, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);	/* MMCR0 */
-	mtspr(784, val);	/* SIER */
-	mtspr(785, val);	/* MMCR2 */
-	mtspr(786, val);	/* MMCRA */
-	mtspr(787, val);	/* PMC1 */
-	mtspr(788, val);	/* PMC2 */
-	mtspr(789, val);	/* PMC3 */
-	mtspr(790, val);	/* PMC4 */
-	mtspr(791, val);	/* PMC5 */
-	mtspr(792, val);	/* PMC6 */
-	mtspr(795, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);	/* MMCR0 */
-	mtspr(796, val);	/* SIAR */
-	mtspr(797, val);	/* SDAR */
-	mtspr(798, val);	/* MMCR1 */
-	mtspr(800, val);	/* BESCRS */
-	mtspr(801, val);	/* BESCCRSU */
-	mtspr(802, val);	/* BESCRR */
-	mtspr(803, val);	/* BESCRRU */
-	mtspr(804, val);	/* EBBHR */
-	mtspr(805, val);	/* EBBRR */
-	mtspr(806, val);	/* BESCR */
-	mtspr(815, val);	/* TAR */
-}
+static const struct spr sprs_207[1024] = {
+ [22] = { "DEC",	32,	OS_RW,		SPR_ASYNC, },
+ [25] = { "SDR1",	64,	HV_RW, },
+[177] = { "DHDES",	64,	HV_RW, },
+[283] = { "CIR",	32,	OS_RO, },
+[310] = { "HDEC",	32,	HV_RW,		SPR_ASYNC, },
+[312] = { "RMOR",	64,	HV_RW, },
+[339] = { "HEIR",	32,	HV_RW,		SPR_INT, },
+};
 
 /* SPRs from PowerISA 3.00 Book III */
-static void set_sprs_book3s_300(uint64_t val)
-{
-	set_sprs_book3s_207(val);
-	mtspr(48, val);		/* PIDR */
-	mtspr(144, val);	/* TIDR */
-	mtspr(823, val);	/* PSSCR */
-}
+static const struct spr sprs_300[1024] = {
+ [22] = { "DEC",	64,	OS_RW,		SPR_ASYNC, },
+ [48] = { "PIDR",	32,	OS_RW, },
+[144] = { "TIDR",	64,	OS_RW, },
+[283] = { "CIR",	32,	OS_RO, },
+[310] = { "HDEC",	64,	HV_RW,		SPR_ASYNC, },
+[339] = { "HEIR",	32,	HV_RW,		SPR_INT, },
+[464] = { "PTCR",	64,	HV_RW, },
+[816] = { "ASDR",	64,	HV_RW,		SPR_INT, },
+[823] = { "PSSCR",	64,	OS_RW, },
+[855] = { "PSSCR",	64,	HV_RW, },
+};
 
-/* SPRs from Power ISA Version 3.1B */
-static void set_sprs_book3s_31(uint64_t val)
-{
-	set_sprs_book3s_207(val);
-	mtspr(48, val);		/* PIDR */
-	/* 3.1 removes TIDR */
-	mtspr(823, val);	/* PSSCR */
-}
+/* SPRs from PowerISA 3.1B Book III */
+static const struct spr sprs_31[1024] = {
+ [22] = { "DEC",	64,	OS_RW,		SPR_ASYNC, },
+ [48] = { "PIDR",	32,	OS_RW, },
+[181] = { "DAWR1",	64,	HV_RW, },
+[189] = { "DAWRX1",	32,	HV_RW, },
+[310] = { "HDEC",	64,	HV_RW,		SPR_ASYNC, },
+[339] = { "HEIR",	64,	HV_RW,		SPR_INT, },
+[455] = { "HDEXCR",	32,	RO, },
+[464] = { "PTCR",	64,	HV_RW, },
+[468] = { "HASHKEYR",	64,	OS_RW, },
+[469] = { "HASHPKEYR",	64,	HV_RW, },
+[471] = { "HDEXCR",	64,	HV_RW, },
+[812] = { "DEXCR",	32,	RO, },
+[816] = { "ASDR",	64,	HV_RW,		SPR_INT, },
+[823] = { "PSSCR",	64,	OS_RW, },
+[828] = { "DEXCR",	64,	OS_RW, },
+[855] = { "PSSCR",	64,	HV_RW, },
+};
 
-static void set_sprs(uint64_t val)
+/* SPRs POWER9, POWER10 User Manual */
+static const struct spr sprs_power9_10[1024] = {
+[276] = { "SPRC",	64,	HV_RW, },
+[277] = { "SPRD",	64,	HV_RW, },
+[317] = { "TFMR",	64,	HV_RW, },
+[799] = { "IMC",	64,	HV_RW, },
+[850] = { "LDBAR",	64,	HV_RO, },
+[851] = { "MMCRC",	32,	HV_RW, },
+[853] = { "PMSR",	32,	HV_RO, },
+[861] = { "L2QOSR",	64,	HV_WO, },
+[881] = { "TRIG1",	64,	OS_WO, },
+[882] = { "TRIG2",	64,	OS_WO, },
+[884] = { "PMCR",	64,	HV_RW, },
+[885] = { "RWMR",	64,	HV_RW, },
+[895] = { "WORT",	64,	OS_RW, }, /* UM says 18-bits! */
+[921] = { "TSCR",	32,	HV_RW, },
+[922] = { "TTR",	64,	HV_RW, },
+[1006]= { "TRACE",	64,	WO, },
+[1008]= { "HID",	64,	HV_RW, },
+};
+
+/* This covers POWER8 and POWER9 PMUs */
+static const struct spr sprs_power_common_pmu[1024] = {
+[768] = { "SIER",	64,	RO, },
+[769] = { "MMCR2",	64,	RW, },
+[770] = { "MMCRA",	64,	RW, },
+[771] = { "PMC1",	32,	RW, },
+[772] = { "PMC2",	32,	RW, },
+[773] = { "PMC3",	32,	RW, },
+[774] = { "PMC4",	32,	RW, },
+[775] = { "PMC5",	32,	RW, },
+[776] = { "PMC6",	32,	RW, },
+[779] = { "MMCR0",	64,	RW, },
+[780] = { "SIAR",	64,	RO, },
+[781] = { "SDAR",	64,	RO, },
+[782] = { "MMCR1",	64,	RO, },
+[784] = { "SIER",	64,	OS_RW, },
+[785] = { "MMCR2",	64,	OS_RW, },
+[786] = { "MMCRA",	64,	OS_RW, },
+[787] = { "PMC1",	32,	OS_RW, },
+[788] = { "PMC2",	32,	OS_RW, },
+[789] = { "PMC3",	32,	OS_RW, },
+[790] = { "PMC4",	32,	OS_RW, },
+[791] = { "PMC5",	32,	OS_RW, },
+[792] = { "PMC6",	32,	OS_RW, },
+[795] = { "MMCR0",	64,	OS_RW, },
+[796] = { "SIAR",	64,	OS_RW, },
+[797] = { "SDAR",	64,	OS_RW, },
+[798] = { "MMCR1",	64,	OS_RW, },
+};
+
+static const struct spr sprs_power10_pmu[1024] = {
+[736] = { "SIER2",	64,	RO, },
+[737] = { "SIER3",	64,	RO, },
+[738] = { "MMCR3",	64,	RO, },
+[752] = { "SIER2",	64,	OS_RW, },
+[753] = { "SIER3",	64,	OS_RW, },
+[754] = { "MMCR3",	64,	OS_RW, },
+};
+
+static struct spr sprs[1024];
+
+static void setup_sprs(void)
 {
-	set_sprs_common(val);
+	int i;
+
+	for (i = 0; i < 1024; i++) {
+		if (sprs_common[i].name) {
+			memcpy(&sprs[i], &sprs_common[i], sizeof(struct spr));
+		}
+	}
 
 	switch (mfspr(SPR_PVR) & PVR_VERSION_MASK) {
 	case PVR_VER_970:
 	case PVR_VER_970FX:
 	case PVR_VER_970MP:
-		set_sprs_book3s_201(val);
+		for (i = 0; i < 1024; i++) {
+			if (sprs_201[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_201[i], sizeof(struct spr));
+			}
+			if (sprs_970_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
+
 	case PVR_VER_POWER8E:
 	case PVR_VER_POWER8NVL:
 	case PVR_VER_POWER8:
-		set_sprs_book3s_207(val);
+		for (i = 0; i < 1024; i++) {
+			if (sprs_power_common[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common[i], sizeof(struct spr));
+			}
+			if (sprs_207[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_207[i], sizeof(struct spr));
+			}
+			if (sprs_tm[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_tm[i], sizeof(struct spr));
+			}
+			if (sprs_power_common_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
+
 	case PVR_VER_POWER9:
-		set_sprs_book3s_300(val);
+		for (i = 0; i < 1024; i++) {
+			if (sprs_power_common[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common[i], sizeof(struct spr));
+			}
+			if (sprs_300[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_300[i], sizeof(struct spr));
+			}
+			if (sprs_tm[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_tm[i], sizeof(struct spr));
+			}
+			if (sprs_power9_10[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power9_10[i], sizeof(struct spr));
+			}
+			if (sprs_power_common_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
+
 	case PVR_VER_POWER10:
-		set_sprs_book3s_31(val);
+		for (i = 0; i < 1024; i++) {
+			if (sprs_power_common[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common[i], sizeof(struct spr));
+			}
+			if (sprs_31[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_31[i], sizeof(struct spr));
+			}
+			if (sprs_power9_10[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power9_10[i], sizeof(struct spr));
+			}
+			if (sprs_power_common_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+			if (sprs_power10_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power10_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
+
 	default:
-		puts("Warning: Unknown processor version!\n");
+		memcpy(sprs, sprs_common, sizeof(sprs));
+		puts("Warning: Unknown processor version, falling back to common SPRs!\n");
+		break;
 	}
 }
 
-static void get_sprs_common(uint64_t *v)
-{
-	v[9] = mfspr(9);	/* CTR */
-	// v[273] = mfspr(273);	/* SPRG1 */ /* Used by our exception handler */
-	v[274] = mfspr(274);	/* SPRG2 */
-	v[275] = mfspr(275);	/* SPRG3 */
-}
-
-static void get_sprs_book3s_201(uint64_t *v)
-{
-	v[18] = mfspr(18);	/* DSISR */
-	v[19] = mfspr(19);	/* DAR */
-	v[136] = mfspr(136);	/* CTRL */
-	v[256] = mfspr(256);	/* VRSAVE */
-	v[786] = mfspr(786);	/* MMCRA */
-	v[795] = mfspr(795);	/* MMCR0 */
-	v[798] = mfspr(798);	/* MMCR1 */
-}
-
-static void get_sprs_book3s_207(uint64_t *v)
-{
-	v[3] = mfspr(3);	/* DSCR */
-	v[13] = mfspr(13);	/* AMR */
-	v[17] = mfspr(17);	/* DSCR */
-	v[18] = mfspr(18);	/* DSISR */
-	v[19] = mfspr(19);	/* DAR */
-	v[29] = mfspr(29);	/* AMR */
-	v[61] = mfspr(61);	/* IAMR */
-	// v[136] = mfspr(136);	/* CTRL */  /* TODO: Needs a fix in KVM */
-	v[153] = mfspr(153);	/* FSCR */
-	v[157] = mfspr(157);	/* UAMOR */
-	v[159] = mfspr(159);	/* PSPB */
-	v[256] = mfspr(256);	/* VRSAVE */
-	v[259] = mfspr(259);	/* SPRG3 (read only) */
-	// v[272] = mfspr(272);	/* SPRG0 */  /* Used by our exception handler */
-	v[769] = mfspr(769);	/* MMCR2 */
-	v[770] = mfspr(770);	/* MMCRA */
-	v[771] = mfspr(771);	/* PMC1 */
-	v[772] = mfspr(772);	/* PMC2 */
-	v[773] = mfspr(773);	/* PMC3 */
-	v[774] = mfspr(774);	/* PMC4 */
-	v[775] = mfspr(775);	/* PMC5 */
-	v[776] = mfspr(776);	/* PMC6 */
-	v[779] = mfspr(779);	/* MMCR0 */
-	v[780] = mfspr(780);	/* SIAR (read only) */
-	v[781] = mfspr(781);	/* SDAR (read only) */
-	v[782] = mfspr(782);	/* MMCR1 (read only) */
-	v[784] = mfspr(784);	/* SIER */
-	v[785] = mfspr(785);	/* MMCR2 */
-	v[786] = mfspr(786);	/* MMCRA */
-	v[787] = mfspr(787);	/* PMC1 */
-	v[788] = mfspr(788);	/* PMC2 */
-	v[789] = mfspr(789);	/* PMC3 */
-	v[790] = mfspr(790);	/* PMC4 */
-	v[791] = mfspr(791);	/* PMC5 */
-	v[792] = mfspr(792);	/* PMC6 */
-	v[795] = mfspr(795);	/* MMCR0 */
-	v[796] = mfspr(796);	/* SIAR */
-	v[797] = mfspr(797);	/* SDAR */
-	v[798] = mfspr(798);	/* MMCR1 */
-	v[800] = mfspr(800);	/* BESCRS */
-	v[801] = mfspr(801);	/* BESCCRSU */
-	v[802] = mfspr(802);	/* BESCRR */
-	v[803] = mfspr(803);	/* BESCRRU */
-	v[804] = mfspr(804);	/* EBBHR */
-	v[805] = mfspr(805);	/* EBBRR */
-	v[806] = mfspr(806);	/* BESCR */
-	v[815] = mfspr(815);	/* TAR */
-}
-
-static void get_sprs_book3s_300(uint64_t *v)
+static void get_sprs(uint64_t *v)
 {
-	get_sprs_book3s_207(v);
-	v[48] = mfspr(48);	/* PIDR */
-	v[144] = mfspr(144);	/* TIDR */
-	v[823] = mfspr(823);	/* PSSCR */
-}
+	int i;
 
-static void get_sprs_book3s_31(uint64_t *v)
-{
-	get_sprs_book3s_207(v);
-	v[48] = mfspr(48);	/* PIDR */
-	v[823] = mfspr(823);	/* PSSCR */
+	for (i = 0; i < 1024; i++) {
+		if (!(sprs[i].access & SPR_OS_READ))
+			continue;
+		v[i] = __mfspr(i);
+	}
 }
 
-static void get_sprs(uint64_t *v)
+static void set_sprs(uint64_t val)
 {
-	uint32_t pvr = mfspr(287);	/* Processor Version Register */
-
-	get_sprs_common(v);
+	int i;
 
-	switch (pvr >> 16) {
-	case 0x39:			/* PPC970 */
-	case 0x3C:			/* PPC970FX */
-	case 0x44:			/* PPC970MP */
-		get_sprs_book3s_201(v);
-		break;
-	case 0x4b:			/* POWER8E */
-	case 0x4c:			/* POWER8NVL */
-	case 0x4d:			/* POWER8 */
-		get_sprs_book3s_207(v);
-		break;
-	case 0x4e:			/* POWER9 */
-		get_sprs_book3s_300(v);
-		break;
-	case 0x80:                      /* POWER10 */
-		get_sprs_book3s_31(v);
-		break;
+	for (i = 0; i < 1024; i++) {
+		if (!(sprs[i].access & SPR_OS_WRITE))
+			continue;
+		if (sprs[i].type & SPR_HARNESS)
+			continue;
+		if (!strcmp(sprs[i].name, "MMCR0")) {
+			/* XXX: could use a comment or better abstraction! */
+			__mtspr(i, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);
+		} else {
+			__mtspr(i, val);
+		}
 	}
 }
 
@@ -289,7 +518,9 @@ int main(int argc, char **argv)
 		}
 	}
 
-	printf("Settings SPRs to %#lx...\n", pat);
+	setup_sprs();
+
+	printf("Setting SPRs to 0x%lx...\n", pat);
 	set_sprs(pat);
 
 	memset(before, 0, sizeof(before));
@@ -299,18 +530,50 @@ int main(int argc, char **argv)
 
 	if (pause) {
 		migrate_once();
+		/* Reload regs changed by getchar/putchar hcalls */
+		before[SPR_SRR0] = mfspr(SPR_SRR0);
+		before[SPR_SRR1] = mfspr(SPR_SRR1);
+
+		/* WORT seems to go to 0 after KVM switch, perhaps CPU idle */
+		if (sprs[895].name)
+			before[895] = mfspr(895);
 	} else {
 		msleep(2000);
+
+		/* Reload regs changed by dec interrupt */
+		before[SPR_SRR0] = mfspr(SPR_SRR0);
+		before[SPR_SRR1] = mfspr(SPR_SRR1);
+		before[SPR_SPRG1] = mfspr(SPR_SPRG1);
+
+		/* WORT seems to go to 0 after KVM switch, perhaps CPU idle */
+		if (sprs[895].name)
+			before[895] = mfspr(895);
 	}
 
 	get_sprs(after);
 
 	puts("Checking SPRs...\n");
 	for (i = 0; i < 1024; i++) {
-		if (before[i] != 0 || after[i] != 0)
-			report(before[i] == after[i],
-			       "SPR %d:\t%#018lx <==> %#018lx", i, before[i],
-			       after[i]);
+		bool pass = true;
+
+		if (!(sprs[i].access & SPR_OS_READ))
+			continue;
+
+		if (sprs[i].width == 32) {
+			if (before[i] >> 32)
+				pass = false;
+		}
+		if (!(sprs[i].type & SPR_ASYNC) && (before[i] != after[i]))
+			pass = false;
+
+		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32))
+			report(pass, "%-10s(%4d):\t        0x%08lx <==>         0x%08lx",
+				sprs[i].name, i,
+				before[i], after[i]);
+		else
+			report(pass, "%-10s(%4d):\t0x%016lx <==> 0x%016lx",
+				sprs[i].name, i,
+				before[i], after[i]);
 	}
 
 	return report_summary();
-- 
2.42.0


