Return-Path: <kvm+bounces-49853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 291BEADEA65
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F5533BF608
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B68D2E54DD;
	Wed, 18 Jun 2025 11:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bHDqBI3/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53502E54A2
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246573; cv=none; b=LcQVynhLLxmlkQ+xjya2/UvdSuizEY1zkt8s+n0b2r1lpHL4kzCz4ZQGxOgu+Jcf6oebmE6310naVo3apCYmCgR/EEeEyKRoHaQrQhKzOxz0ZI8PTkdR9Is1UpcRT9VJehc4jbmtvqw+uthFylN6P3ZBV6RzC6bdC3zvchSaGhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246573; c=relaxed/simple;
	bh=Tt/vawDYZjRbm2u92sK4nUF168I+VRBgzlUXAX+PzHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpqOHeKhznTu5SRVYGTniESgoOTuAycfNB+bMCby6PnIilAqsSCd37y93jWwBG24kyUE8nz1E7Oq7BczG3iikQ6z67YW05DjWiUUMUcTCi2yVgkT3/d8Jyc7bTaAxRLxB2SUM7hxHBMu9z4h8o+kCBhcqlQGRh2qX8fiD+FgxNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bHDqBI3/; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3138e64b3fcso5960009a91.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246570; x=1750851370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ernJHGr8wUUltKH2OhtBcW3LIbI4jpB3xEJEU1yumiA=;
        b=bHDqBI3/PWOj7OXSVPzXvwS7SPoaJQK5RH8Zse+fTrPR+8WqbemX+ffo5io9sz/fQT
         ndWr3cT+1XY5wCXuI0zdIinvJ7Jrqkr/BUZgKZeJhThOf5G/ioTleTg37BSheTEMdrrY
         f+sqYkYHnYSZyKo54BmSPIK/C2iZAgoPj152CPD1a0sKETReSO9ouwc5pz+S6BGYiJGB
         rE4SC0XYyGOeqahW6T9eoWcmeGlLvAwUna23BwZQi6biKeJTB0IWEcrLyRT5aDSdybon
         zj8cPZyJg3NIP89d1Hl0mrFBEM2/VvoUxOSr0P/Wfn4WM10CqjnpwRvx9q+qGnPzSUEG
         UA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246570; x=1750851370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ernJHGr8wUUltKH2OhtBcW3LIbI4jpB3xEJEU1yumiA=;
        b=qgaMD8+O+e6Tn331P4K6uqVXKNryA6q4SaasxUUSI7+oJNa8jjnOr1aVv0pyR4tObw
         +N/edwjnt5J2qRosAMK9Lnd89bEgUPIz20HvdmjZ9etLYuAaTXs3kddnKMjPStIqrDvF
         rQYLniqWrbfXkJsR5AVIXjUiu3BXR7+epP8IX4JERZ/JTYC8gogKepAxbcNJiZbcS4yV
         Ezekqsq8cw7Nq8QgXupifbAsITyfxKgkrzeOq2s90zOrfc7SeXBOD5ZFXKIFxpoQ1Cg0
         0RaeqUXyuYiAivJNdvkiKx7KD4YUMDr371PUebGDV1CqCoD51MlSWu0mmflCHH9J39/a
         ydYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxZO7E+TKcXY3xbEZVb42SLg86ErMTCKo6kzH7pTCP+G7Gi1LUnAlBaBvxFildt5reiKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPmUYTDpCqytkfTcec44KJ1Xz1ZKF4Z8VKFeo5WysImx0VHfgY
	5dTw6Eomw70a+aj4of5HR5JbKO+GQ3WcT5w8+cPJwMqqG05OeqmtKoXKK95B5u9YEHY=
X-Gm-Gg: ASbGncs9pPyMUQG3BG2rEWcAtsDdyV3d22pf92El0dqSPsGzbg7BbaOBA3M8qgfULXy
	f8qh/+BTRKH802EPc/n+SdYPL/QIbJch52NeWdPKPgCWBaWJzmrd8k/oRcRMssrS8E211ujV/Ut
	BPhkQm/K28+/Uihf/1QDUWsmGojCHxsb8Otnbm8Y3zZs3ddeWgjJZmG//nAt+3FHOmASFUMs1tb
	Aa41qVusHyUdKIHmSnEfDebb9Ntam1AT83Mfl0AZBxJGj5ZIcrB9t++3ItqwjK0LKxIx2pEcj9M
	gV2BKqgaANyNNBPO5L+oadaTDlzL/+pdfiwr51RprWFjF6/D5fr/mrVvd93xWtYzvT09Qle/Qy3
	lOd8QMJ2Erp2U25FuaPPXx6ux6i0y
X-Google-Smtp-Source: AGHT+IED2oGexk/JFxqAVuWpL/++/t8pIqk6FimHQhJH+vt07+Mbc0bPBQs0X+EavqGGcAYnWQlaQw==
X-Received: by 2002:a17:90b:1a87:b0:311:abba:53c0 with SMTP id 98e67ed59e1d1-313f1c03004mr26620231a91.9.1750246569846;
        Wed, 18 Jun 2025 04:36:09 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:36:08 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 05/12] RISC-V: KVM: Don't flush TLB when PTE is unchanged
Date: Wed, 18 Jun 2025 17:05:25 +0530
Message-ID: <20250618113532.471448-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The gstage_set_pte() and gstage_op_pte() should flush TLB only when
a leaf PTE changes so that unnecessary TLB flushes can be avoided.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..29f1bd853a66 100644
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
@@ -229,7 +231,7 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
 			  pte_t *ptep, u32 ptep_level, enum gstage_op op)
 {
 	int i, ret;
-	pte_t *next_ptep;
+	pte_t old_pte, *next_ptep;
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
 
@@ -258,11 +260,13 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
 		if (op == GSTAGE_OP_CLEAR)
 			put_page(virt_to_page(next_ptep));
 	} else {
+		old_pte = *ptep;
 		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
 		else if (op == GSTAGE_OP_WP)
 			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
-		gstage_remote_tlb_flush(kvm, ptep_level, addr);
+		if (pte_val(*ptep) != pte_val(old_pte))
+			gstage_remote_tlb_flush(kvm, ptep_level, addr);
 	}
 }
 
-- 
2.43.0


