Return-Path: <kvm+bounces-3573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8752B805681
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8D0F1C20FFF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8970161682;
	Tue,  5 Dec 2023 13:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="J4uy7eJA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E84D48
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 05:50:52 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6cc02e77a9cso5468175b3a.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 05:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701784251; x=1702389051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kw9lx7rfek+Fyxn9H19uerjKbw2z7hmkxzJlnytvErY=;
        b=J4uy7eJAkgHRXlMqjYrZm55vQhViwdQpXKbi3SYOvt3WK+47p9hVeubN3W7/oL9WRz
         O0ZNiZ2vbHMgKLw66y3ixNIV4kDzJNucmy7e4HzGXlrbdTXTEcRjECMANNgEQaIfqrfl
         ynpEih9FRvmOLa1d5Pvl59Uy2vyf95UlBfdvAeZZLU7xzwBdWR+f1yV/UFRUgrpjq8qJ
         kSdnipTOufEx2c+yCkAz9578cxGH2j5rXMuTM+LCezfqpr9D7i48YTOvPTcFGUuzIRGR
         jqEPfeI7pkUh8thv1y0yImnfKDSJpOgFZFgvlr5ODntB3yonPadhyCVjdsycvw+z9pLs
         NVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701784251; x=1702389051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kw9lx7rfek+Fyxn9H19uerjKbw2z7hmkxzJlnytvErY=;
        b=nFLdQApIc6w2qQ/V/jVaExl2sPDzYl77WU8xRfFB3EqfSpuGSowi6zmc0eK3QATZY/
         lYM+gsdGM2dPSV6ruMqeA1oFJtQCrWGMrd45QYGcuo4IDwWJX/uLWfJ7tEiAieLU6Qk5
         NpgR4gtLU1X6CVACdJvNE2Q+xjbnoMTBMwUqk+pL6MR+16jp2OOeLrqXEnBAGOsLBWpu
         Zv41OOsy8iybM8VwgEKcmwP7tfu/j78Sn5xNzUVQ7VICIRSA1MKorjbM1aR06c61/cN4
         ciZ6tWBf36b1UdSGN6VyOaEbek6k8n3+Rx94ADYZM98nprpDQjXLyD+oowyrjvLw5F8b
         61wg==
X-Gm-Message-State: AOJu0YyP7wtzWdceG1zUjqUFj4owxZAgHKL4G1yqbhPqsxRCbXSzwZsS
	BxMNunlXfJy1EqQa8/+PibWCOw==
X-Google-Smtp-Source: AGHT+IE+MGZNocJKukR2PL4jO1pcCHJx5zeZaiZzHpSE59/id3BPfziDyZviksjyycnDyDaRfgGFtQ==
X-Received: by 2002:a05:6a00:849:b0:6ce:60d4:234b with SMTP id q9-20020a056a00084900b006ce60d4234bmr1617686pfk.52.1701784251608;
        Tue, 05 Dec 2023 05:50:51 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id c22-20020aa78c16000000b006ce77ffcc75sm673641pfd.165.2023.12.05.05.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 05:50:51 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 1/3] RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
Date: Tue,  5 Dec 2023 10:50:39 -0300
Message-ID: <20231205135041.2208004-2-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231205135041.2208004-1-dbarboza@ventanamicro.com>
References: <20231205135041.2208004-1-dbarboza@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'vlenb', added to riscv_v_ext_state by commit c35f3aa34509 ("RISC-V:
vector: export VLENB csr in __sc_riscv_v_state"), isn't being
initialized in guest_context. If we export 'vlenb' as a KVM CSR,
something we want to do in the next patch, it'll always return 0.

Set 'vlenb' to riscv_v_size/32.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_vector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index b339a2682f25..530e49c588d6 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -76,6 +76,7 @@ int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
 	cntx->vector.datap = kmalloc(riscv_v_vsize, GFP_KERNEL);
 	if (!cntx->vector.datap)
 		return -ENOMEM;
+	cntx->vector.vlenb = riscv_v_vsize / 32;
 
 	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
 	if (!vcpu->arch.host_context.vector.datap)
-- 
2.41.0


