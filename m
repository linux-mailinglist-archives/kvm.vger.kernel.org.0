Return-Path: <kvm+bounces-38153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3863A35CCC
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D69E1890784
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7A6263C73;
	Fri, 14 Feb 2025 11:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XZNq0e2r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6101C263C6C
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739533501; cv=none; b=l450k3NuItnDoShpbsZE+CzDbUNoCPAJMH7tVkByfBcB24K1Q0MbUnFbocqW9LVABx5A5kX4SBhQYHentyMlUBH89p472U+xfSA2JAYpxEyDNe/yvfs3hnqJRdv2ep02MFVWNgVlN+enApKoqGZCLN3dSQS6xFLDPeboTkCfhsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739533501; c=relaxed/simple;
	bh=BiyKyIHm7l9GP+JDlcvuhxsmijeJ+nOu7K5c2SdsmUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OsUFbWrbrYGuH/zHWv/KwIsnZFUcXTrkBD/RMjCg46tSUcwsZ/p+3iAKcphotSJk5m5UHPW3lF4ZigfR+A6SpqK3Hhc68034Cs3Cv+vLM8X/5cWnD9pmAlXyN4SDDf2iQrD+kJrBloyuI86j7w8uU/61kChFLH17unJM5NzrhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=XZNq0e2r; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fc11834404so2503843a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 03:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739533498; x=1740138298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCReb3cvg707HPbBwZSbIVzyvT4c2UyWOl9p1yzcaUg=;
        b=XZNq0e2riGqEVp5HAMdwOEiIhdMTp3f6bUNf8CU+AiuxtOTWee7spSOKjc27Huu8qT
         PRi+aH6hlAKE9giqesEaI4SGW9/ueBfGZeBDvvdnXrhQme65Qu7vQv4bgIIcAwpsplvi
         XuXWTa1da58MNqfI7nSR9iVptVosKSz1R/Tpi2GipHNZ9wycRXaIC9IS1KCa9Crmy0n0
         cfO2G5HCz7dEsfHySsPqO0K9n0lW1XdBGt8xzPkbGGOVy8F7KrMKC8EkrV2/3xJkWKpN
         GAdrmNSP8Y3MQp9f1O1dJ81m7IOeaNBAMRZkT0UJI52EGUQXmDZLKj1Nv8exXBqdEnFS
         9uAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739533498; x=1740138298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCReb3cvg707HPbBwZSbIVzyvT4c2UyWOl9p1yzcaUg=;
        b=Jr9RLnrW67PebtLvPNT949TBqLtKoJPUjlqMlVdsRaLUxeyi1LLimeWFlBfybkmhx3
         jo3zdzoLy7o0ji6PVPEDSobGKOpyBC0vmf77+/7bkMenolzgPk162l1Ztz1B/+rsuc9S
         tB1hB2LEcBgjhpQNuRQ/Ctnh8wpRwqX+LX06AKIdw5sJF08GbF+5u5mjBxrCAQUL59F7
         4Jh3h1RRcKQ2uvworHY6Vgpl35NeJUMmwTTbynb8oIiwF2Tm2z98Ri7voi1wo0jax4yQ
         WlV7mNXz7uw9wN/fliF1OfarJOzme+igKDBmRa1BQFUxSE/PFE5GTZXH5wsL7TnVpVuj
         Pxtg==
X-Gm-Message-State: AOJu0YwcdJ5cgUotWXA2RSoLFSETGtrSh+6YEJYsZL8PAg10zxy2wG2F
	CjZnObt6kN8+a43JYfop5FfNyexPNff+MPsCXa6y4baJmqUfAcdeoaaxjiiC2UkGRrEVRXOqsCS
	lh/Y=
X-Gm-Gg: ASbGncvhT1gPaJFnPybYl9E0iBsk2zaASW0hvM9UxV0DoPr/ouTL8s44ylYd+K+2umm
	qja8gxVJxjMcUJy2YH5CBEO7LtwAevz3Q+2RrojuCwJWYsW2wfCJ1yAPUei0QAPuC25C8G4KjQl
	KWzvrvokyEOxrvCd92Jo5sU9p/dnCfbOTKp1CHI0ANe9yMMQnNRA3W0WTS8OlZ97vIWXdVxMKdV
	CWorCk1hJmm995W0MGIRl2VCFexFx5xaemXLSiAjoU2MzWwK1cCFwspOXih1sQ7yj/aAfj5VVhn
	JZ5p3sIaH84Wz2fD
X-Google-Smtp-Source: AGHT+IEFLobxG/BCLHywnrzNtfVd4bGo5LbKUHk1gDEPSL7O/HmCPgInYxOwh1OyU+I+GVVMEI2OQQ==
X-Received: by 2002:a17:90b:2742:b0:2ee:693e:ed7c with SMTP id 98e67ed59e1d1-2fbf5c6b76amr19554909a91.33.1739533497797;
        Fri, 14 Feb 2025 03:44:57 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98f6965sm4948862a91.29.2025.02.14.03.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 03:44:57 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v7 2/6] riscv: Set .aux.o files as .PRECIOUS
Date: Fri, 14 Feb 2025 12:44:15 +0100
Message-ID: <20250214114423.1071621-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250214114423.1071621-1-cleger@rivosinc.com>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When compiling, we need to keep .aux.o file or they will be removed
after the compilation which leads to dependent files to be recompiled.
Set these files as .PRECIOUS to keep them.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/Makefile b/riscv/Makefile
index 52718f3f..ae9cf02a 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -90,6 +90,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
+.PRECIOUS: %.aux.o
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
-- 
2.47.2


