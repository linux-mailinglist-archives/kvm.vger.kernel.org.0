Return-Path: <kvm+bounces-48479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F7EACE9F6
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 831DF3ABC0B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D8620F097;
	Thu,  5 Jun 2025 06:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ylf3eFcf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8BB20E031
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104134; cv=none; b=FZmH7pDKztMF+7w3Hiutp0is1kdkYFsHjvG//kpLtrPyrev5wh+W1YiWwBit7YDRKts0QdnAWnQh6UhbGbvCIUCSNM+2uhE1BdVGj4tIhifBvhyub4Pc0D1YfSHQdkEkiXm85mhWCdt7aySUFvwZ/hqVEIXSSlNd/jSCEkmqIM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104134; c=relaxed/simple;
	bh=vt95taIBAE6xHdLS/+LEWFyOT14BvSlPFxy5vZtFS28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcwVWF75e1AaX0rz0D/PqYucpjBDNLXEAkMeDruQQA6mx2GeuvKMGCETT0QwsB1iBZClIqPUKYvacaX+nKNMBNMX+mQcaVVHiZdMa+Wsz5Muyv3LOWpOdLzPFrq66JFizljf1WN3jPRX9dUQGxD7IVj+kbH4AP4UrfVWP7szsN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Ylf3eFcf; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3109f106867so766257a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104132; x=1749708932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=297HQlUGPdF+XZ67B7Ks8toSmyeODGGOfBIq41lD5gM=;
        b=Ylf3eFcfpnwCoYDdQCw8fmtYL6IHSxyfO7JtwA0xf0h0Re07jV+2ps1edN4QR2zaZM
         SWyld5q1sBej93iRQfKFyAazCSzorUvC2khIyUf49HzcOnimINKp9aCmUsorRQWt42sK
         WHbjdVi1gPurDHfEhFPUNERSY1nPHMkAmhT5F+gzEEfpkRVSM+77EIDP+uMVAsAmHbFa
         NFkXcLdAhjEToMyAA3fJEx8JHLL9AOS2/W9p7im00Lo/jGrboL4v73rfWGQBvUDa0TA0
         2TVJyfsQ3ktM+a0EgSyb7abta1QaNJeLyyQeY0XqwC4XjFxsbvzR2H69wSH/QCdsTQDU
         lbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104132; x=1749708932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=297HQlUGPdF+XZ67B7Ks8toSmyeODGGOfBIq41lD5gM=;
        b=FkpPZXiYDpkQ7t6LNk6crP7pxDpu3MhWq5i3U429XxQc/2VuEZ08pCoJiz51M82Z1j
         C2NrZJAD3Iis/vzB7/d5aU7bXEQ4GCJSM2dwCZEo38ijZsH/Kvcfp3xCnNtQfDRgqx6Q
         /24MMRDk7NnjZRpjGGc/ppzN/IcZ8txHbGEnbG/hBcUH0DxSuJYM6e788HofzRbG2tgt
         N3eP3Rfq6/WbhcXz4LIbNfbCoFKck3DhIrut6te82w4dye7U2UMZj4qp7assQIA0KqKN
         K2rBniXSs05YUdNw9CbS8DlVrVNY3gdkAGf6GXbLDW0FHmGrarEkP/acmfbGKTtrPuCw
         /dsw==
X-Forwarded-Encrypted: i=1; AJvYcCU8Z3oiXD7KOXXQ7JsEfn4iEravsP5DM+Ygx7epBU2MmtwqdCplg/BctLiSh28R2ntqB7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoMqx0MmLvFYYhkGL9OKRFFP+O06oT78EYFzuCXB06BWolf4XN
	3ddA6sz6CW8L42eOnX2JMtyBNhVmHcHZN9KNBeDtIc/Ow4kz9N1/cTBSij9cOkNJMvU=
X-Gm-Gg: ASbGncu+rR9IwuZIWg2x4sQFgqjn07xrNX89CFs6YE5fvfPmAAmnYAoTADSWrJczvCM
	5eeGLGH+gyTNDEP/Law3UgaflG7uVVvC4VKNwgnY5gVzFsPeJWiEKdUpog3kOoQjfnGsR2cp6Q5
	9kcHj9RbmdhjYMlOJdsr1LzeEUCux3DHQdnawvnHkRaA8vrO/1pIaj89cMVoKYiqYHd0f9wzBHx
	Cd2YQW1GYKIzn5TrZWBE1c4/ai8PA1waGPdsyl7V4eXbi4MepJBZdoCco58Rf+WvD1iNamc5C+z
	4HQ9B+eLv73yVTpFpc37O18W978+3WPIRALNl50FhLViriS2Jz5v4BJpbGSijq3UhT7TuvL5cgX
	ItgOyxg==
X-Google-Smtp-Source: AGHT+IGaQDp4t9Rc9PacdM1BZZoSLCIgCU7kc4zabKe3J73B2NovkDFU1CUL1ahoIxkagRn4o+A2cg==
X-Received: by 2002:a17:90b:2641:b0:311:9c1f:8516 with SMTP id 98e67ed59e1d1-3130cd2c648mr8923161a91.15.1749104132103;
        Wed, 04 Jun 2025 23:15:32 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:31 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 07/13] RISC-V: KVM: Don't flush TLB in gstage_set_pte() when PTE is unchanged
Date: Thu,  5 Jun 2025 11:44:52 +0530
Message-ID: <20250605061458.196003-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The gstage_set_pte() should flush remote TLB only when a leaf PTE
changes so that unnecessary remote TLB flushes can be avoided.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..d4eb1999b794 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -167,9 +167,11 @@ static int gstage_set_pte(struct kvm *kvm, u32 level,
 		ptep = &next_ptep[gstage_pte_index(addr, current_level)];
 	}
 
-	set_pte(ptep, *new_pte);
-	if (gstage_pte_leaf(ptep))
-		gstage_remote_tlb_flush(kvm, current_level, addr);
+	if (pte_val(*ptep) != pte_val(*new_pte)) {
+		set_pte(ptep, *new_pte);
+		if (gstage_pte_leaf(ptep))
+			gstage_remote_tlb_flush(kvm, current_level, addr);
+	}
 
 	return 0;
 }
-- 
2.43.0


