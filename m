Return-Path: <kvm+bounces-34606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1042AA02C1C
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 730E13A8144
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98B071DE4C7;
	Mon,  6 Jan 2025 15:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hopdBrqu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD9916D9B8
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178561; cv=none; b=C+M/mWyL79lQQN2HDG1opw3IHZZQVhqxv4Yrs0GDzjdaDunop7YV/rCOAaNvbdvUGrjux+T2TOzYg3bNC87O7rKi/PByKi4GPQknescgs6JxlNAsbagXPW805O5MLmbDR6oU648vBw9UsDPk80vANdcfAL/VtvAVl/1Wu7AFwCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178561; c=relaxed/simple;
	bh=wpnt0dYFW/QmOcPu7DwJHbFXJcaNGQ3V61Y7MK2RfEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVFOGc7WhyIMWBoYlEYHJgppXqeubiTmPsQFQK2FYm8N1Rpps680HtGgMqCOn9QQwHjPzWLH6ZjcRPDOJwzPc+YviW8F3LvjcqZO+B/YfEU7K+PPQXHhvXrT0MXAwQN+52SV83e9oVKUHZ+pza4pymZB41S67oZaSLnWOknYHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hopdBrqu; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2161eb94cceso147535955ad.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178558; x=1736783358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hUAp13cfLrcRgomb+YDwJflWyLOeBTRPSVeLvL2aSrw=;
        b=hopdBrquTptvhx9a6Ae/iSawSOVTVzk4NI0nQNHQwE47ECq/A4Fv0uyDZ4dwj8fZWM
         wlqoYGMYCBaZ2wNSFj0QabzLXb/FFNoX1McE1IOmOe4UJkbp1qQDFz0G1cVQHNklYbVL
         OnJEQ1qa50kxeqGyGaErEAbmIsLTA92QSUiB80WKa4o9CYxdIk/GroFSwXlgtd/hR7GR
         GKq63somwd4bIzQ+QqI097pGuxzDs3E5ePbmIAFIBWR0Dn1o6iMrCn+1fnQAKjntc98N
         52Qs9zdpatH++doyvGnGY/YKbHpn6WdVkh8/qj8GJujQEt7aNm20BAHaOCluW0rbTFO0
         i7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178558; x=1736783358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hUAp13cfLrcRgomb+YDwJflWyLOeBTRPSVeLvL2aSrw=;
        b=hCtJBfZyN5sSqnALeKFvOum6RouTIwjmAxgFbzClIf0ogLQY3ktrk1eKxnKPpO7M/K
         zusDGJiBzGZERbksGB4ww6Qwbwgv991pr7fVBf8FzKjSVTP/Nxc8ExYsCV6hwQc/go7F
         OCjX6306D0XcUmN5+6+ZXqZr3/XIBDOY+0MpXqfsNiu5FCRAOw4q7wlLc/PmT+lNg7QT
         DFb8q1NAqwZrT9wZ4tk3szekjLModjQ4ohmqfiLL93e7ayLKr4n/Xfs1inQC79YNIlhq
         73z2XSe7MMOmdu5Gu6YH/1RH8/H7rLleKlsz1FVkz5KnqCWEJrDw6rSXaFWhOXaUfWHt
         CaMA==
X-Forwarded-Encrypted: i=1; AJvYcCWR5oZ9vu1lgnjxym4ulDi/l3cGo5WeC3pxJ1PwKEUNsCRNOGsZA5+ojVwFmjoQ7AnB6mE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDCSkVrHdW/kILHl1IhW5qWCEZiW+lj6oB1A5+cEVHSkTmP3wO
	VUKmw6z5zrAAASRShvLVUJQCyFbHFiyhcP+PqxVBO8VEpZHszv/nnNTjl8TqAJ8=
X-Gm-Gg: ASbGncsIwTstqtD3b12yqjbb+XWJ5+iS53TlA0WtEJrNDwsPxn632AkEx+6j6czUaei
	7ue7mxpDv2+pR5cBia7kQ38NPsqyk+zvwLXG6y9ZiCbjbLf2aFxeuIJj7jpQFBIo27tlfKaYCCx
	0Zabcu6gOXdQKnn7CJSsOErIZTtqtpgsf0sQZtCA4VFMccMo38L5Vtf3wJG0BkdIO86nnLRW5AG
	2ki27jMvM4FkWOaN4Exw3oubPaS0HT2VaJUGYwtNxsZbuyl+C8YZ5Pcig==
X-Google-Smtp-Source: AGHT+IEAi4C08D2uh9ehheSrgZdf7WN1M3JGxvQSdR5w+ojassJn4RAe3pkLwbVvSQ+6CKRXrqzn6Q==
X-Received: by 2002:a17:903:946:b0:216:2af7:a2a3 with SMTP id d9443c01a7336-219e6f27157mr1007178485ad.53.1736178558552;
        Mon, 06 Jan 2025 07:49:18 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6967sm292479535ad.214.2025.01.06.07.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:49:17 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH 2/6] riscv: request misaligned exception delegation from SBI
Date: Mon,  6 Jan 2025 16:48:39 +0100
Message-ID: <20250106154847.1100344-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106154847.1100344-1-cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that the kernel can handle misaligned accesses in S-mode, request
misaligned access exception delegation from SBI. This uses the FWFT SBI
extension defined in SBI version 3.0.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/cpufeature.h        |  1 +
 arch/riscv/kernel/traps_misaligned.c       | 59 ++++++++++++++++++++++
 arch/riscv/kernel/unaligned_access_speed.c |  2 +
 3 files changed, 62 insertions(+)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index 4bd054c54c21..cd406fe37df8 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -62,6 +62,7 @@ void __init riscv_user_isa_enable(void);
 	_RISCV_ISA_EXT_DATA(_name, _id, _sub_exts, ARRAY_SIZE(_sub_exts), _validate)
 
 bool check_unaligned_access_emulated_all_cpus(void);
+void unaligned_access_init(void);
 #if defined(CONFIG_RISCV_SCALAR_MISALIGNED)
 void check_unaligned_access_emulated(struct work_struct *work __always_unused);
 void unaligned_emulation_finish(void);
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 7cc108aed74e..4aca600527e9 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -16,6 +16,7 @@
 #include <asm/entry-common.h>
 #include <asm/hwprobe.h>
 #include <asm/cpufeature.h>
+#include <asm/sbi.h>
 #include <asm/vector.h>
 
 #define INSN_MATCH_LB			0x3
@@ -689,3 +690,61 @@ bool check_unaligned_access_emulated_all_cpus(void)
 	return false;
 }
 #endif
+
+#ifdef CONFIG_RISCV_SBI
+
+struct misaligned_deleg_req {
+	bool enable;
+	int error;
+};
+
+static void
+cpu_unaligned_sbi_request_delegation(void *arg)
+{
+	struct misaligned_deleg_req *req = arg;
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
+			SBI_FWFT_MISALIGNED_EXC_DELEG, req->enable, 0, 0, 0, 0);
+	if (ret.error)
+		req->error = 1;
+}
+
+static void unaligned_sbi_request_delegation(void)
+{
+	struct misaligned_deleg_req req = {true, 0};
+
+	on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
+	if (!req.error) {
+		pr_info("SBI misaligned access exception delegation ok\n");
+		/*
+		 * Note that we don't have to take any specific action here, if
+		 * the delegation is successful, then
+		 * check_unaligned_access_emulated() will verify that indeed the
+		 * platform traps on misaligned accesses.
+		 */
+		return;
+	}
+
+	/*
+	 * If at least delegation request failed on one hart, revert misaligned
+	 * delegation for all harts, if we don't do that, we'll panic at
+	 * misaligned delegation check time (see
+	 * check_unaligned_access_emulated()).
+	 */
+	req.enable = false;
+	req.error = 0;
+	on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
+	if (req.error)
+		panic("Failed to disable misaligned delegation for all CPUs\n");
+
+}
+
+void unaligned_access_init(void)
+{
+	if (sbi_probe_extension(SBI_EXT_FWFT) > 0)
+		unaligned_sbi_request_delegation();
+}
+#else
+void unaligned_access_init(void) {}
+#endif
diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 91f189cf1611..1e3166100837 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -403,6 +403,8 @@ static int check_unaligned_access_all_cpus(void)
 {
 	bool all_cpus_emulated, all_cpus_vec_unsupported;
 
+	unaligned_access_init();
+
 	all_cpus_emulated = check_unaligned_access_emulated_all_cpus();
 	all_cpus_vec_unsupported = check_vector_unaligned_access_emulated_all_cpus();
 
-- 
2.47.1


