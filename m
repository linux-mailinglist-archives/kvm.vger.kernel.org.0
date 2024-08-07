Return-Path: <kvm+bounces-23564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4994994AD6E
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64030B2190F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8AD12C46F;
	Wed,  7 Aug 2024 15:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Yiz+cnlc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B87C328B6
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723045789; cv=none; b=Je6exKrfFNFvSbJPbosG+xRkJnO3GRMuxt/dcMBpm7Sn/Ra3tocEeARJIrImBEE/lba9nVQlRyc0/edWDdxPPK5TxTlK9aKVFLTpQE93vnqF8nPf3FFMNWUY8VhrcVBr4ewLaNAjS0zePiblzz8rWf2ihxun7bhDzpuvXYezT9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723045789; c=relaxed/simple;
	bh=lYXohf6wMY4JUEHAV5nXDvVLwxR5UBHN+KF1D+k82JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=so7yCw+j5GJMmEWlyo5LqPtetrCut+3PCFdv4VgsoPaPrTaDZWyBx3RYei/R40FMXhnUt+kZhH9wMcjKyUuvhpnC9YT9oMNPSM2z2dIsKipfMlnUKaRoLrlna2rfKoN1AZluwG1V8WMugZLtv4z8+kW1wsrEKk5yXZzSUlKH+5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Yiz+cnlc; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52f04b3cb33so4537846e87.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 08:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1723045786; x=1723650586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RYvpj69+AWcct2kjGgzqVMRUV32rPbq2i4gj3uwAY8M=;
        b=Yiz+cnlcKDqkzXDGsKht7P1tlVxdGzUKSCsjy0x2t8AL06RawMoLp/VIfQV+8+wgiP
         LV71D5OQgwrxnlw03go3jXSfLZpN723HYab+7H67kZteJqPP52ZAgXOzAbNfba904mKn
         42kW9+b2qBUa9tDhJ180pqEIzSvAtp1KXmn4RCKQHV3Bh58rACPBwHpSBQe/ylNYD0KT
         ByaOT2XptQh12GQXI+ZuEBuY2pPfR91YkQdK1Dj0IzwIhMgwabjxoiFKQj1kUBgZYPqk
         oLZglvGXHehxX0MTybVMoCCn2gHEXjlL8x5P04RqErw1K5wqZQbDC+z1nNxFcnzIF4xp
         Aulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723045786; x=1723650586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RYvpj69+AWcct2kjGgzqVMRUV32rPbq2i4gj3uwAY8M=;
        b=dFuReqCQdn4rqlm0+y9rs5NJEUL0rCS/ifBi9y+Bchzq3S+V5uAEShq3ZfaVwm/7cx
         rhqKjdze/D11T+/r4JMVOplG2Cht1+EzCtR5p93cXXgh4jRgUrZXmUWHyar0ulpLYApx
         YJfyAZORRqfsH0eggBPkyfs9ADp1XdCmg7z17zGNRe+hPW5i7xBq4I/ADhqKTIIxkitE
         h9QcYHw5ltM5eG/2GN9KDCU6g+naABZzL0Gh8EfPlH/ZyVZdFilbPbt41OjdDzp6+8fq
         Ou+6VLT2oKAFX/8xIKclldxrDbUXHeKDFBglcMtldy5rfzYb3e7Iz8EfQENDa2X5EcMS
         Dl+g==
X-Gm-Message-State: AOJu0YwbSJtX7WVOgGAuGXfy7QyS35Bdr2VrwdfNrDnIpG+zYWnO8FnU
	cPTZyT/R+xpzDUdSPnjvIT9E3QANzdekEQDX9+Qd1NFw5S464JUxicK5GT22u8N11oWlTC4vtWM
	ygd4=
X-Google-Smtp-Source: AGHT+IG/0qTiu3D4l4sc2pZF393ojWtcrWrltEaCHTsPfg6qHZ7oxPP+gwhZxN/GnQhjbENhLsFuKw==
X-Received: by 2002:a05:6512:398a:b0:52c:df83:a740 with SMTP id 2adb3069b0e04-530bb38cfc7mr15457604e87.30.1723045785551;
        Wed, 07 Aug 2024 08:49:45 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bc3c9asm649751966b.37.2024.08.07.08.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 08:49:44 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [PATCH] RISC-V: KVM: Fix sbiret init before forwarding to userspace
Date: Wed,  7 Aug 2024 17:49:44 +0200
Message-ID: <20240807154943.150540-2-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When forwarding SBI calls to userspace ensure sbiret.error is
initialized to SBI_ERR_NOT_SUPPORTED first, in case userspace
neglects to set it to anything. If userspace neglects it then we
can't be sure it did anything else either, so we just report it
didn't do or try anything. Just init sbiret.value to zero, which is
the preferred value to return when nothing special is specified.

KVM was already initializing both sbiret.error and sbiret.value, but
the values used appear to come from a copy+paste of the __sbi_ecall()
implementation, i.e. a0 and a1, which don't apply prior to the call
being executed, nor at all when forwarding to userspace.

Fixes: dea8ee31a039 ("RISC-V: KVM: Add SBI v0.1 support")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 62f409d4176e..7de128be8db9 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -127,8 +127,8 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	run->riscv_sbi.args[3] = cp->a3;
 	run->riscv_sbi.args[4] = cp->a4;
 	run->riscv_sbi.args[5] = cp->a5;
-	run->riscv_sbi.ret[0] = cp->a0;
-	run->riscv_sbi.ret[1] = cp->a1;
+	run->riscv_sbi.ret[0] = SBI_ERR_NOT_SUPPORTED;
+	run->riscv_sbi.ret[1] = 0;
 }
 
 void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
-- 
2.45.2


