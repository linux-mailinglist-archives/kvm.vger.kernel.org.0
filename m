Return-Path: <kvm+bounces-46662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5652EAB807C
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:26:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E88F317F963
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F63297A73;
	Thu, 15 May 2025 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Yk6WHYJT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2AC29373E
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297437; cv=none; b=fob9jmrvzrGn3An8VJFRLYOjndQOUntAzrJyeRHMecU7ypjwxWQk9mEc6nTRniDPuKmUE2EYRy1vMGI4L+rYQNBtKWhGLtXz6X+lnDuh0DHEOEbNZ3iGl3LwQktlMpip7xQreb1jRYakoBCqYANJ7WYYJEAmh0IPTUjmR6ujU1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297437; c=relaxed/simple;
	bh=uz1riMVMX6ESvcly3DK7ZVeRESfNcHcQ1KO1rEuMiRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ugDTlS7xmAnOzGrvZQzO9gg4kCU90xhG6sy0tzGv2GASbSs9hQV8q2jhyGzlwJRVD1J1jI0KSMTyLaIux/IHjBIJSmFxexT9UZfuKujiiRERoa1hIkDzzJwxzKeDoZrzjK2+w6qYl9xyX2r9YmZ/5gFg2INIVgJ2EMuACoFsj4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Yk6WHYJT; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so6999455e9.3
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 01:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747297433; x=1747902233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rW3Gt5ot6i3Z0vibD5tiRCC8lZra7MrDIFxKpe4L2VI=;
        b=Yk6WHYJT4QdCmQSEWOroBrq/gu2itGDi2XdFnjsBzYiaAd5vxtI74pNgsjV5RyvOWm
         MNg8j2rZCgcmPtaXNrFX58zkli73L0D6C2s7mbqnAm2Nj7KS2W2TJ1/ioIDGb/5fgOCX
         FTqtkc7KPN1umDaN5WsKhUzKGuxlsO1j8Bk9B6231AVbtEP12bSazPKKAXcy4A1yiVKc
         OEtRaZ7eNskiMMWJqT22sLlXYJNOeGvPHWjuG1Vjpvh/rrdKpvJ/Ehut4uvCdXmzNThh
         5KI3DhYsYJWGcxyrAPAb/7WWLg8BGVe5J5CDxKJG1BcBdFjcvNxiQ4tGsL+2LQ5nTJ4z
         nNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747297433; x=1747902233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rW3Gt5ot6i3Z0vibD5tiRCC8lZra7MrDIFxKpe4L2VI=;
        b=E0itSkeq4CDfxzEKnNjkNZFaKWapdnPFvfZSiOj4u/K2C0S/kHgFyJG+4Zp3FL4HXy
         QBZ+pKx2xCcZ7pNtKc2HBzHCpdW0YIE/N9FACZvz33xJkCB7SXGjLry9lqP3bL28gW4Z
         QgdA7x59WjiGBCUQpcwgttEDhSUY80WU4XbhnfhS+dvvefgna6EBXfk+/0Fvlv4VnlGY
         o0TTgzZebqxB4oWni9u+3Kr/Muym8Aeggaq3GK6j+rF1XwPTmKVooTUrkpuf9qTtDcRg
         90zmxC5K0Y3rBFeW7Kh6/CjyGw/e+/iNFTj06wuAMLBUwgw6TN+42lzyzlgaKE48T3je
         3MTg==
X-Forwarded-Encrypted: i=1; AJvYcCX7YoFHp9AYm9nONeX4QrhNQOzQ4qKmPCf5Q6r+W5OoMqgQhJcOL+iTR0wo4vZGlY7mTJc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtaPc15p4PNF/oopvFV1l3s0iRPA3dM37OdnF52gD72VSHVMCe
	1B+BnJ6UX8JKwyEhzSgJofW0r3OOnadag7E/rb4kmJ3AmkNGLE1LVLP+uV15+kA=
X-Gm-Gg: ASbGncuFxAgPuDXxwbxteSboMgbzJPurvYSiSpZ4L5/k5++pMJgI+M3BjkE/DTNpOCs
	TcN0fZY3na+xqo9NfuiGquzPOr8Zvj9mnZLLfMAqadX5WD+GN0Zr+Yw2J2XOnA2scW26/XIpKm9
	gBfLAA7PDIgZ/jFIvfJC7aewnXDMzZLMDqEDOhvWx1JQ2by0tSf4mlYIgtbiRfKDrxh3vXXTEH2
	Dn7/GKvVTcADpyTtkZtci5dTUNz3sZ29sWx6EsM7ZwCicxrUMpYZLQ09lw+iQC9Z9GZXr8GV0xg
	BEANeq8WoKX5+ONMjfr8g6HzZy/Pw6AB7TMCbAGSPXTseDa5FM0=
X-Google-Smtp-Source: AGHT+IEkMTLzUmbcaQoV7fBGhKB8oDf174vYHHp/il10qE0/kSBDkuCpwfLuKVtfldQPVM2OqN3Neg==
X-Received: by 2002:a05:600c:a07:b0:43c:e481:3353 with SMTP id 5b1f17b1804b1-442f96eca92mr14271065e9.17.1747297433494;
        Thu, 15 May 2025 01:23:53 -0700 (PDT)
Received: from carbon-x1.. ([91.197.138.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f395166fsm59310785e9.18.2025.05.15.01.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 01:23:52 -0700 (PDT)
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
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH v7 08/14] riscv: misaligned: use correct CONFIG_ ifdef for misaligned_access_speed
Date: Thu, 15 May 2025 10:22:09 +0200
Message-ID: <20250515082217.433227-9-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515082217.433227-1-cleger@rivosinc.com>
References: <20250515082217.433227-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

misaligned_access_speed is defined under CONFIG_RISCV_SCALAR_MISALIGNED
but was used under CONFIG_RISCV_PROBE_UNALIGNED_ACCESS. Fix that by
using the correct config option.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/traps_misaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 34b4a4e9dfca..e551ba17f557 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -369,7 +369,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 
-#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
+#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
 	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
 #endif
 
-- 
2.49.0


