Return-Path: <kvm+bounces-29216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C30BD9A567B
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:49:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E3A5B232FE
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691FE199EBB;
	Sun, 20 Oct 2024 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="I5pCJdqA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9023199389
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729453677; cv=none; b=bbFNHVTkAkKs5qiKzikVP2eOziTboxC7L+nazb3XtA1eMPm+k7usYsKI31FhIcDbg2UQWybaprP1/BFYfRyhvCGrw+dnEVHDcFToaxgtvGfBRewl8Yd1D/enI8o5pAsLDvhZulN8zuhbvDPWncAU5pPEzw11DVcd8PmPhjO6c3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729453677; c=relaxed/simple;
	bh=XeJ4zURiPtRwRC7wqRQygMzynUWW7n969d9Luma7yik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6QmAeMp11CfxTzKdH9RJTFzGhMsY952ApoiubCdTLPCgz9tKPZF5oSx6Eu3Wr7TAk1k25urjh3N1lWCQUC27JCHLYsMDBX+06Ym6oNlHim2/8AmGq2jJg3XAhWltNEwAjkVkeTCtn5VI3MDm8jUkBfin+9DaxficghFo3ydJwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=I5pCJdqA; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e30fb8cb07so2760724a91.3
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1729453675; x=1730058475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=160oEn3Hw+w/iZ7EFhTc6TJAcZCL3iOZo0psz4xgbB0=;
        b=I5pCJdqAd2b3aGVebqpW8FkbzPcHmpz8scO/8DjliVrbGRjkqHQyLuuwCez7Bqc3fX
         01XvBIRvpM+15C86Tmcb1zEPTwe0okn7z9kLjybEn9+w1atNqJC2NUK/98/BYm7qHfnl
         k+yZ/Ca+e7dfLMjVhefNOrKGJjGtrxlZiopZHjp4futM8yw2BfcRXmOlIRjHeKvnkVC+
         53IVyb9iLmg2m+vZndIwbO+0ygevLcZmu8Am7MCR35dnzxJ61N1vB2XRQ2zSK0x10y4b
         HIyrBaM7lth8dW3+sLwqPbr1L6pOTaS04Jj34upU6aoOn8kFTsDrTDGPhdqGhnNSGCn+
         pBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729453675; x=1730058475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=160oEn3Hw+w/iZ7EFhTc6TJAcZCL3iOZo0psz4xgbB0=;
        b=K7yXtzisrjbE+reoRJ6JvmacQVHZU00elKWCYTuNSR6iXU58llYUR3UFXz0M1S5jdw
         0Ut0yYmNgm+L4rs0HGmhnFAm966l1moQMIdrqpb+pidYyoqwtIj3f+ND3qr2AowfAEXQ
         3EalB88ru+6Lt0UGLEjQOrFQbJZsLfQ0wnnTMMLUUoj6HM2E0vFX6Q3qob5hcnAewbv5
         ubs/cQdrcOL//fqBhhEvGY/Zn/kOkZ0PxsidwBg+S7c5AHejIkidEQHzuxKrjpFFfA2E
         Yqec/0KUtOGfQ+uUe/onBxsC9BbBgQsF5PyT31ETqV1lmb0LYyJCdphbrrOKviTLU5HZ
         FTiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiE/fIgEixfZCQrmfQ9d1wL4c4Rd72T3HoOZz0WfoV17uhE+/cmKz+wRrbL5Lh1DSx8Bk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw59e8Eco31gdWpoM9JUdOPgEzmyENBCfg8ATrBbHPdP+WesuoP
	HiVmfk77qk3I4n01Okc4EdU8hlPBlun20sM14fsmUibyp1HhM0QXoc3kVlLxfRc=
X-Google-Smtp-Source: AGHT+IFjSRTaADFfRKm/pM//eGuPDafKddIxjEZ6I/KXrnokbyilNV7LBvfBGmNKmpBhs1ancwD0CA==
X-Received: by 2002:a17:90a:ab0e:b0:2e0:74c9:ecf1 with SMTP id 98e67ed59e1d1-2e561718d7amr7870206a91.10.1729453674952;
        Sun, 20 Oct 2024 12:47:54 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([50.238.223.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm1933188a91.14.2024.10.20.12.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:47:54 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 06/13] RISC-V: KVM: Don't setup SGEI for zero guest external interrupts
Date: Mon, 21 Oct 2024 01:17:27 +0530
Message-ID: <20241020194734.58686-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241020194734.58686-1-apatel@ventanamicro.com>
References: <20241020194734.58686-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to setup SGEI local interrupt when there are zero guest
external interrupts (i.e. zero HW IMSIC guest files).

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/aia.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 17ae4a7c0e94..8ffae0330c89 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -499,6 +499,10 @@ static int aia_hgei_init(void)
 			hgctrl->free_bitmap = 0;
 	}
 
+	/* Skip SGEI interrupt setup for zero guest external interrupts */
+	if (!kvm_riscv_aia_nr_hgei)
+		goto skip_sgei_interrupt;
+
 	/* Find INTC irq domain */
 	domain = irq_find_matching_fwnode(riscv_get_intc_hwnode(),
 					  DOMAIN_BUS_ANY);
@@ -522,11 +526,16 @@ static int aia_hgei_init(void)
 		return rc;
 	}
 
+skip_sgei_interrupt:
 	return 0;
 }
 
 static void aia_hgei_exit(void)
 {
+	/* Do nothing for zero guest external interrupts */
+	if (!kvm_riscv_aia_nr_hgei)
+		return;
+
 	/* Free per-CPU SGEI interrupt */
 	free_percpu_irq(hgei_parent_irq, &aia_hgei);
 }
-- 
2.43.0


