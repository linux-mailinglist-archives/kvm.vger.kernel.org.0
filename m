Return-Path: <kvm+bounces-44204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D8BA9B545
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E0EE164E69
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F88C28F518;
	Thu, 24 Apr 2025 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gKbkbaRd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C8B28E5EB
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516036; cv=none; b=kiuaiZUD0Z3G07X5wdhleusIAZzDlCpUKiWa12DcEY1zSd5VoxX7jvcXF0eyiW5H7xvmklF2Yn5QSvcdatGkG3v38g5AKoCs8/hMfOdYAHya+anVK1BN/fRs92TeBAJbBya7lONwa3cviuI6WliqQL8oH76RvAjnJ1tp12WVG6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516036; c=relaxed/simple;
	bh=Hvkg2vuWcLH+loCVg3KfVBlKpSfZ+GMWX4LieYFjwwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNUsd4ra+iKvLJ8GmnAOO9gph9m3zCollWkutebbaFlxvbUwhHgJhB8SQw6qfWkvHI/VleVLbrNCB+KMDhzceU1RN157JQGNkU8R+09dtgAjaAiLA7+JwjZDEEYsGyPvCeq6JNTJHX4zxAo4k1bfw1FqVqHoYWoNAGhET9vGLY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gKbkbaRd; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22c33e4fdb8so14776775ad.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516034; x=1746120834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvf5XOciI2RxholK/olnAUr6RSsyRw+cO5ZQm+/Dg/Y=;
        b=gKbkbaRdJYoVwsyPc3EomBxUmPD6s2gSEj8UW55j1mMS/jZ9Akw/CBTGI3I/tmi8c8
         QRUe1lirj8vIgl15mVPVE2tf7SI0WbtfYAJXfwbt01Trm1oRIyXdX/aaQRQ4wBguaf3m
         PjML0brUMIJj2+XlNO5u8gUO0FiB5vYmxNNCxvZWQvczN/TePt2/+MG+8pHVBX1148Tf
         EC8ho4ME1cz6M4BfdnPgSPZ4YFq7WTPuGm6p9GwgAYRdV0ABS21SpRY19liNIKeitbXR
         Pqy2OXZ5JwdhycOf8ZpGDvPLTKAdp5uGj5lOBBYf066LLebU4TVHGdsIjGSz65cs6UtR
         mJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516034; x=1746120834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvf5XOciI2RxholK/olnAUr6RSsyRw+cO5ZQm+/Dg/Y=;
        b=WBQqX5oUDYOwrI0OWT4GZvNqTUSmf3vsxJ14ouPWYWINwFjPHyxp28knc33YOqb0oM
         LI0v+HDqWJgZT9HCJuRmJdonoGXsIg6bUXhiGy5xYevJXEovAl99UppgaW8RRRaBUy4X
         RWckWBs41DJsKaszzyHmG853Ar4YUWxCe8D7/z7d+c1rqaXeqYE6Uopk8LxLWQId+n26
         64EuHezo8ZT7Ru6z9CjbjEzLnqaEzvXM5mJyCtMORFsufkhI40xsQxG9IvLTDq/Mjt6D
         XtbMRrgjJqVe1n9IfNdeXnpeUnaO2ctCgiyeiystkUbMK15NIfvKgKPTkSVxCAGFGTH8
         219Q==
X-Forwarded-Encrypted: i=1; AJvYcCVXfxN4IsD9JRwMecHxQzkKLsdQaL0PgRzigrbSQKDkVm5vpfAv0utc+hymTD4NX/wk8Vc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjNyQ11kaWPqMFOSerKZoHp7w+b4CJ4PCJe5b0GgAww/CQL5aM
	0f0p5vBvIiTSguFpMLxWIsUSr2jKtDDN554sRnGvn9Iavkw8SUZPL5v1sfDfFyM=
X-Gm-Gg: ASbGncs68kSWsqylPx0EHFJ7JsXLtXD/v1Jw9Q8jcLq5cZXcYyHcl7ujE1vENFt89Hs
	u47BAv6j1Z7+NGf47mAt6QC3itIZWxnscuOZiybJvHwQJOY+Y3dgxRSJC6WdAqV7uAXoZU6HTDC
	h7hfTQTDkVIdFInVtBDHQ3zIgSJq4pLvYXxMfTEeoHB2q9sHp500HCmtSaxItdstKM8dHD7jsVU
	glOKzvV9tlAMVe86GnEbM7p5RAk9D7ThbTt97zuDjYiKKHsCD2yZFFjgETh3yeyvlibIlAaMaSx
	ydZcfBbNW5mE3BfbbIsR1tX8W7ZJFTWZ8MwwqKH7CA==
X-Google-Smtp-Source: AGHT+IHaM8bzJfRRvw0MkUxc3QW2tm+twyY3rgnrMs/7xPlJBt/0WAycPUEFxVys/K0zq71dkmTO4g==
X-Received: by 2002:a17:902:d489:b0:22d:b243:2fee with SMTP id d9443c01a7336-22dbd415915mr4178995ad.13.1745516034428;
        Thu, 24 Apr 2025 10:33:54 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:33:53 -0700 (PDT)
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
Subject: [PATCH v6 02/14] riscv: sbi: remove useless parenthesis
Date: Thu, 24 Apr 2025 19:31:49 +0200
Message-ID: <20250424173204.1948385-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424173204.1948385-1-cleger@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A few parenthesis in check for SBI version/extension were useless,
remove them.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/sbi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 1989b8cade1b..1d44c35305a9 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -609,7 +609,7 @@ void __init sbi_init(void)
 		} else {
 			__sbi_rfence	= __sbi_rfence_v01;
 		}
-		if ((sbi_spec_version >= sbi_mk_version(0, 3)) &&
+		if (sbi_spec_version >= sbi_mk_version(0, 3) &&
 		    sbi_probe_extension(SBI_EXT_SRST)) {
 			pr_info("SBI SRST extension detected\n");
 			pm_power_off = sbi_srst_power_off;
@@ -617,8 +617,8 @@ void __init sbi_init(void)
 			sbi_srst_reboot_nb.priority = 192;
 			register_restart_handler(&sbi_srst_reboot_nb);
 		}
-		if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
-		    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
+		if (sbi_spec_version >= sbi_mk_version(2, 0) &&
+		    sbi_probe_extension(SBI_EXT_DBCN) > 0) {
 			pr_info("SBI DBCN extension detected\n");
 			sbi_debug_console_available = true;
 		}
-- 
2.49.0


