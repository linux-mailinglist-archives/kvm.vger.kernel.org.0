Return-Path: <kvm+bounces-38342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B94EA37D67
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91ABA7A3CAA
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B011ACEC7;
	Mon, 17 Feb 2025 08:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="P7a1/1M1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75361A9B52
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739781916; cv=none; b=doZs74g6hPZVJ1kxToPju8rqgYhUah7UR/2iHBdQNKH2Vonuijm6SqlZ7jnyM8ibQllRFojxlFeIuydKcF92N1j7rmucx6uH1r4GP5HptuUhYGI+iSpTpE7SY2vQWxmW8XIT9GumfANikq1Z/EadxCkLHQJXg7DzidiSXkQ20hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739781916; c=relaxed/simple;
	bh=TsyxZ34/uk8jH+7pi9gkNKFwME87qom8rRAB+x7I9U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBl/OihVcffiLRJswFGFsHmYurYJl+G9wA07v599/EwhlJ8cgkV6JtiN4pIuaQTGzwMawmKX8BVsfeqTx528VWRNKYSqD1nxJ35n63vNBi3AsA9cZODvw6aIYMOX2p42pROnKcUCbBoiZz2uaugP1LE8h6PeziLxTCW0fwyGgpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=P7a1/1M1; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38f1e8efe82so4454595f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 00:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739781913; x=1740386713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DPqGeqDxSe+aOIAEww9m1M//H8GA90MJiJy6W/MxoXw=;
        b=P7a1/1M1pYDRLeKVNPY0ep4MJaHT2Jhcs8cF7xKDEaPngx4NcBtJk4h9uv8HlC9qVc
         S6vHpkjQrouh/7iELXVSacCqyRbmRlWBpBC/7z+oQuTcS5zrAufDChgovbV+AhZ7Wk81
         IKmi36GG4iWtQxsN708WH4RSlQGKiQ9XhcQnA3+95ANm9CtOlqTKoQHeyVNQOC2ZVVrv
         1ZqevJCTwgYCUQ+j1JVEewKVVr7dEkDhGZa44yBcSZwJBaGjC89Kyzg974EmymOTRMfS
         zSUXrjlg8O5v03KqwMdig2MkBVNUxg/HSZvCezaa8H0Q2Z2iGxO1NlCELmdmSEO3lq2y
         mBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739781913; x=1740386713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DPqGeqDxSe+aOIAEww9m1M//H8GA90MJiJy6W/MxoXw=;
        b=YjJfQsIjrtRUjRl/QeN6u7ZtdppXY/lajNQIYnvWFR3HsfTb6VdsZABnJrGd5CuJy2
         qi/2HLw+uwWWVDzZGoACEggfOH5lDk1QrkSmfREwje/zicPrTX6tUvMr+o1ScXgDOE1b
         rchHdmsoE9HIozUX7tym4LftQZZrkxj5iqVWVSaEIYGVbVwCJS0iZcsLaA+PMqOcicWH
         Ue8oI9tLfFl2PAyo5lS7Kwg0M77lbq3iN5dBoha0MRhya+uhLhzOV9WU+azWU4Ii7hSU
         K3TxRk6L/sAgQV5Wxma6YALbFe5b+WmteCMQVOLQtebwuL3n3QkYplM4ucURJkvoHiR5
         42/Q==
X-Gm-Message-State: AOJu0Ywpvl38SIXeHr3vMQOB+dDIh0nqkzv6CWtyK75Wvw26u3Hfqqun
	hTkoBXrpR92soFVK4qt2uG1A1jzdT5AquucXLg3abNsqLeWQEWTwYI+obDtTtKqTP1nYnAEqzWY
	o
X-Gm-Gg: ASbGncv3hzFEJrjSOmLfQxoW2tF3/IZoAoll27NST004k2elXRxcsBijZ9VJhkPx1v8
	u4YN+IFHLOfqzxSMZ0bTfoMsl3iLSq/+4pUwmpd6//wo84cV8PyhnivuT088sP4ukVoMAiDR0VX
	ZlgfFwjmsgANdvG1gLV7HJ4AMvZUb6sPwYQdgizr3YnTYBR14H1D/syKgla0kyrigjfvT856IFc
	FrPp2hRQLAWjBDqcSjgiISEHRyyz3SlWZcL+GHviCThd+UupcOKEK64i0TdbFRm0JqN2HhEK9V5
	jos=
X-Google-Smtp-Source: AGHT+IFw2SQlG3mEiHsZKLXfCIe42+z2FtTbwXKzNb64tTScHuV6pXuwf02llElP/bUJfKsa7cfpqA==
X-Received: by 2002:a5d:648b:0:b0:38f:31fe:6d12 with SMTP id ffacd0b85a97d-38f33f295f7mr8268862f8f.19.1739781913174;
        Mon, 17 Feb 2025 00:45:13 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258ccdccsm11661079f8f.24.2025.02.17.00.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 00:45:12 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	cleger@rivosinc.com
Subject: [PATCH 4/5] riscv: KVM: Fix SBI TIME error generation
Date: Mon, 17 Feb 2025 09:45:11 +0100
Message-ID: <20250217084506.18763-11-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250217084506.18763-7-ajones@ventanamicro.com>
References: <20250217084506.18763-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an invalid function ID of an SBI extension is used we should
return not-supported, not invalid-param.

Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 74e3a38c6a29..5fbf3f94f1e8 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -21,7 +21,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	u64 next_cycle;
 
 	if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
-		retdata->err_val = SBI_ERR_INVALID_PARAM;
+		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 		return 0;
 	}
 
-- 
2.48.1


