Return-Path: <kvm+bounces-41269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D01EA659DC
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:10:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F8251686C9
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17201ABEA5;
	Mon, 17 Mar 2025 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RSSH4PMR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774DF1C861B
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231297; cv=none; b=GCJ2KBIuNsDkq1RelJCAxk7N+wGTNyZGyWyWvaD0HpoDJ1uPtHIvfCxWNORvsxvccN5dZdFd7dWnsbPLGFwhDGECUt33og4TegroIsNXt+kPWfqrtn3nGJgvpI2ANF6FhnmdzkrU8j/5XAZ2AY7WKS8KGgrOMvdri5qd0sSaauk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231297; c=relaxed/simple;
	bh=m22pBr3V6eaVlLVIX44rOw00wFDH5N5l1rGKB3m4pxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cB8a3WfYtC2z/a3vN5TQUCXxxhdv1qH2l0UlvGhP0zeQcUE/ZhPz3mIjbDFQyzlpknhT6FnBmPMyao1lRPC3jS5+oAeFGFBhoHwUMnKYdcN8dXGaJNGDBQ/o27S2MHM0Hrk7bviqhOjztf+5thZ9wehprq9xb0HS5eGohUYf18U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RSSH4PMR; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so17261855e9.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231294; x=1742836094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjeBRUPbBkNgIlDeDsLglyk/HEJX/vNaDwxAgvCJumI=;
        b=RSSH4PMRsfeCZiWscD1JYj+yEnxbSVZ/bWe7EvT8f5S4lgd00i0g3osurYR7gu0lKS
         1KaI9sbd4XugSVanJWNMV7w1ZTkE3HkmR/Cj1JNB6CsZxXqm1z/y8YJjFF5kmGqCZd4m
         zI61GGTPhlXelbPiO9LekJhFT/0hmhG/LIf0azpeyKuYcEVF3z13ezHEP2QpkzWBbPpF
         76oCXswhS7q0OcxGmFW/Y9tKMbXqKFD+62dPAXNqt35ZODalW92kXYPZbHV4g5ZL6lx3
         5MjfXUMoercuOjOCWWf51HYIaVDvMK5b9kDCjhUd2DH0UBt57xd9vFsnXeE7r1fo/VAv
         ix7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231294; x=1742836094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjeBRUPbBkNgIlDeDsLglyk/HEJX/vNaDwxAgvCJumI=;
        b=NekVD29GVeZSZDyndqEQOcGaMrqbGCmpmZnkrqwDrDaKbPKXd3gagNgWvuFwNOcxz4
         VNPyP+eybvXJuwCojRrerb0QKyAZtHOspWqGUpkZvwHoKksjci3SQiD9VMt34pAGsmzp
         Cra8EXrEzgAzF5VZxeXSMmG9qGnLbW9p3yfaAVDzKHoEhedJYPb5GuJXTvXjBTlW42Pl
         QDSAxAaG7LyN6V/L72D4I9bWwFGiKwmtmTXEmIQnC7zs7qy600Kup51uHaHfIU0mMzUT
         +K2coDVffyEx+77/R2u2psfCRMzOD2zlUXLlSSFAF7O77+YHI9ebrEWuI9Wsypv7SPiU
         GquA==
X-Forwarded-Encrypted: i=1; AJvYcCW3QKOxEjyqx5jlPF8wK5kOnx2eXcm1gQUf0v3GnzCnNeDncb8rAQjJqfDaHOKSw7FliC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuepBkG3CijYcy1OpAStd2ZzRqedElrmbYJ6E+AxqRSp520wMg
	7murWDju4+fq73FBSP0IFI46Ri2qxmg0lxRoElF2Kaw2MhjSsjGXFOSmxh8C5og=
X-Gm-Gg: ASbGncs268Zk0zOQXKhJXpVhwYQ3J/uTOPuReK6FSLK+LfPFDhGwWgCwOVKwwhepsuL
	GCFvzoB6r5Iu+9YonTwrRtBcVv21I8Oi89ldUq8dYZzEbTtp2irX79Bi3+Fvw4pzaCBEfjCvmpD
	Gf728Lu312AeQXC2Evy5FApo4iybhlTtfoyR6K2ZkfoDGi19KuEecEMT20ZD/Nns1OkvUeaiNHT
	S4BGwQ2PWIjbDoayjnvgQmVGPaRqc0VMeduY+gWcupwMT5W6XEomQ042Z4fwkN555RxmCUvJqC4
	iTSaXjukhS5j5cstkIs5jkTXd6f7xd+Zjn/PZWccsA6siPlw2XUSrO0W
X-Google-Smtp-Source: AGHT+IEAV1SSYPsskoq8q0qrPU5Tio7ya8gNR4WNeMxWQDKOPXJ0cX+p31upeUPN82mA8abBVPNApw==
X-Received: by 2002:a05:600c:4ed3:b0:43c:fe15:41cb with SMTP id 5b1f17b1804b1-43d1ec80917mr153430805e9.15.1742231293673;
        Mon, 17 Mar 2025 10:08:13 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:13 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 06/18] riscv: misaligned: use on_each_cpu() for scalar misaligned access probing
Date: Mon, 17 Mar 2025 18:06:12 +0100
Message-ID: <20250317170625.1142870-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

schedule_on_each_cpu() was used without any good reason while documented
as very slow. This call was in the boot path, so better use
on_each_cpu() for scalar misaligned checking. Vector misaligned check
still needs to use schedule_on_each_cpu() since it requires irqs to be
enabled but that's less of a problem since this code is ran in a kthread.
Add a comment to explicit that.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/traps_misaligned.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index fa7f100b95bd..4584f2e1d39d 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -616,6 +616,10 @@ bool check_vector_unaligned_access_emulated_all_cpus(void)
 		return false;
 	}
 
+	/*
+	 * While being documented as very slow, schedule_on_each_cpu() is used since
+	 * kernel_vector_begin() expects irqs to be enabled or it will panic()
+	 */
 	schedule_on_each_cpu(check_vector_unaligned_access_emulated);
 
 	for_each_online_cpu(cpu)
@@ -636,7 +640,7 @@ bool check_vector_unaligned_access_emulated_all_cpus(void)
 
 static bool unaligned_ctl __read_mostly;
 
-static void check_unaligned_access_emulated(struct work_struct *work __always_unused)
+static void check_unaligned_access_emulated(void *arg __always_unused)
 {
 	int cpu = smp_processor_id();
 	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
@@ -677,7 +681,7 @@ bool check_unaligned_access_emulated_all_cpus(void)
 	 * accesses emulated since tasks requesting such control can run on any
 	 * CPU.
 	 */
-	schedule_on_each_cpu(check_unaligned_access_emulated);
+	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
 
 	for_each_online_cpu(cpu)
 		if (per_cpu(misaligned_access_speed, cpu)
-- 
2.47.2


