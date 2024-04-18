Return-Path: <kvm+bounces-15076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 129E88A9A20
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2ACE283519
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88296161B53;
	Thu, 18 Apr 2024 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="F0vGwcL6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969415FD12
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713444243; cv=none; b=oiDckT2ngA4k17xlcwNmRUrAmXrkhEZAqK9iUfnBYNx8QPegPgtaiwTyPTCxrkzonl0Bqe5LwZeVzq6kTuouxN2Rgcx6q8u58AjWG1Ol4MZy1o4goaXtTPsq401tzK9lRw7neGw55iE9eU0UF4Mq+LHOKtXwI5jNP+oBMS74Yp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713444243; c=relaxed/simple;
	bh=SrpAxjIaY3RV8BXenxbFlBJKJmsCS8qPO2iasFfYMfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BzcVUVyAAFI4gwx4riatTt13XuzUxt7czdazcPBnPW8F1f6GuJt7K+LR1Ytefor05gKBKcaj3XvfbIWAkYtc45WM4y3YwTA+CngfpgejYBuFxLglntVdDZ6nuN5B808zi8s+EJgtppSoAPbQp9Wqbu2lAoqAY2Fylvjpcjh5ErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=F0vGwcL6; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-349a31b2babso94916f8f.2
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 05:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713444239; x=1714049039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAM+PbC/Wqgx6Q9RB0x39wuP2KdW0QgVrrLDnXaQ5i0=;
        b=F0vGwcL6w3PptZ6deCyKLtJ9QDT+nQmUG1cZnZJrU+mgbKRzgJSpnwGP+40BhVL3h0
         S0ncc8TRLr0qWrR4f2R6xIB6x62GeDnzSsOBUGCjtIDv700LNORnFz6MuIZBhlEbPR6G
         OA9YKwQQrX9ClTRxh50P9AhSBIw+HLEcW1+UHU2xCuKAPZpZivgrmoG1gtMI1kruOeo4
         eZ3KWIcBIfM2SdXTEXipBQ1n1k2gCiArxQO1cyXnCbWSs/if6iWVvQPOpNtGTtaGOvTR
         yUWaEV9J4A/0Iu1LiRpU1OkEPwcrYM+lZAUHTC3GQ1GC0urxOk7kMzMPCqsz5FJ1xXH+
         VZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713444239; x=1714049039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAM+PbC/Wqgx6Q9RB0x39wuP2KdW0QgVrrLDnXaQ5i0=;
        b=rgqMt1/Jp3beM6bDaCzga7RcEtvO9VhnsbkFxvK/9UadVDcRyvOudY9ZRzkmBvlb2R
         WRBY32rm1Xb391kJb398BAMSa9HwPtC9+4Iual7C7QVHoS+7tEBezAngAP9Ssh1nsGq/
         12OpC7YH9JkI8SSYekxq1qfXG0z31r2cgCL/9u6hXbg9afgiVEgKcIkZNPgXVAknOPHU
         3beC6zbQHo2aMsudON4aNnX27aR4DUDDTKYxGVwnKZ522t/jL9Yzi6xFPQeJGRbH/dlW
         mtqLns5IDIUz4JYtJc5IyYFH0IOA8EoyMdaqi9E8znlFuFmu2udEuvFnUlZvfATGXSut
         PIqw==
X-Forwarded-Encrypted: i=1; AJvYcCWA4NYUbUrG/M6MIQEMipAtp1KWRnTrKzEJoMBX7b0QMFl0gL73SQpijhkXa63/rwqUGFc5lRgAckf0yatdwIz1ajn1
X-Gm-Message-State: AOJu0Yxt1jlv5S8l0z65FaR98ksf4f+iQ37XteoT1tDDmtBzBiAAeuVd
	UaaqeyrgtFdr9DElT9p1soCsJcpJP/nrLuXevH6xuOIFryiNJv8BFcWouDEtzXE=
X-Google-Smtp-Source: AGHT+IEfRUjBsR081et3wJOadMgBsrPT+MF87MwTDvd2ymBdOvFDiLCp8AN/vnIfSdOc1TYzaATntQ==
X-Received: by 2002:adf:f60c:0:b0:343:3f59:c97e with SMTP id t12-20020adff60c000000b003433f59c97emr1553063wrp.6.1713444238851;
        Thu, 18 Apr 2024 05:43:58 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id bi18-20020a05600c3d9200b00418d5b16fa2sm3373412wmb.30.2024.04.18.05.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 05:43:57 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 04/12] riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
Date: Thu, 18 Apr 2024 14:42:27 +0200
Message-ID: <20240418124300.1387978-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418124300.1387978-1-cleger@rivosinc.com>
References: <20240418124300.1387978-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Zc* standard extension for code reduction introduces new extensions.
This patch adds support for Zca, Zcf, Zcd and Zcb. Zce, Zcmt and Zcmp
are left out of this patch since they are targeting microcontrollers/
embedded CPUs instead of application processors.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 4 ++++
 arch/riscv/kernel/cpufeature.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 543e3ea2da0e..b7551bad341b 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -82,6 +82,10 @@
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
 #define RISCV_ISA_EXT_ZIMOP		75
+#define RISCV_ISA_EXT_ZCA		76
+#define RISCV_ISA_EXT_ZCB		77
+#define RISCV_ISA_EXT_ZCD		78
+#define RISCV_ISA_EXT_ZCF		79
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 115ba001f1bc..09dee071274d 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -261,6 +261,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
 	__RISCV_ISA_EXT_DATA(zfh, RISCV_ISA_EXT_ZFH),
 	__RISCV_ISA_EXT_DATA(zfhmin, RISCV_ISA_EXT_ZFHMIN),
+	__RISCV_ISA_EXT_DATA(zca, RISCV_ISA_EXT_ZCA),
+	__RISCV_ISA_EXT_DATA(zcb, RISCV_ISA_EXT_ZCB),
+	__RISCV_ISA_EXT_DATA(zcd, RISCV_ISA_EXT_ZCD),
+	__RISCV_ISA_EXT_DATA(zcf, RISCV_ISA_EXT_ZCF),
 	__RISCV_ISA_EXT_DATA(zba, RISCV_ISA_EXT_ZBA),
 	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
 	__RISCV_ISA_EXT_DATA(zbc, RISCV_ISA_EXT_ZBC),
-- 
2.43.0


