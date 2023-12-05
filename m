Return-Path: <kvm+bounces-3616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F53805B46
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D264CB2115F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7576168B92;
	Tue,  5 Dec 2023 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WDBNWqql"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA87122
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:45:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1d0b2752dc6so18722755ad.3
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 09:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701798326; x=1702403126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kw9lx7rfek+Fyxn9H19uerjKbw2z7hmkxzJlnytvErY=;
        b=WDBNWqql9NiU4jkiHD9ELllh/11U0sprAf8mGDETKohzMidA7U/9wHS5jqMN2P/jTD
         jpoizCzKx+aVuF3IfEwLj4JEMO76lH/TbraMr5Hm8c2oB0AmQczveHk3WGt3LUgEQED0
         g1YHijGF96hbLH/8X+Ltj1FS3itYAzqS1colNkPujDTpNKzEQL50DFhpA8sSnnQLpGnH
         WINQ4Zcafg0Jk3WRpjLOaGN3k5TSzsS0cjrxeTkt8vaTBqiaZI9jplgeOMkBAIG9Jpby
         V2tAZ+IFShgxlFiMScfetBTwxgJBlyup8YCTJh443st8rTT7DA68mSEqU1uTznO1Ouro
         J5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701798326; x=1702403126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kw9lx7rfek+Fyxn9H19uerjKbw2z7hmkxzJlnytvErY=;
        b=f+WAAxJbPR2ApcZTRV3vndy35Mx6M3WYnKZNhDN1IGHV6phUULtjPZOVziRTwtHOSq
         IUinrJXwpfmYzUyT94n4xFlQPRfD2HUdau7cT6KiUmcEp+Q/bhYTU8/gZPP+OkPeb+Xe
         gzRMk1IQ/SS7dI+Lr6ChjQav838Z7/lb7r+qD6hg5cSDmRuFQ20WNsJlxdPkIE1/pux9
         +MjTTaRrMUwp6PbWNA23VUbioigxmUlLg484F8k46mWrmrKqTlaAm+LS/mGUnithMagR
         ZKOu6ys5ozaZEg1PqmTjyTAhoxmg/t1iPaRBavTaenSrQRYDkabDwrglBg0fC0DN7XEP
         373w==
X-Gm-Message-State: AOJu0Yy4w3G97Q48r/rV9pWRAGsROS/U+fNulIHJPLszLoEjq14MZIXE
	avRfrqss9u+nGEfMu+LLvbiX9eYP6xhtZqFLK8M=
X-Google-Smtp-Source: AGHT+IF7Y/RolGBXnpDHkOsMt/rkm/fe03CCbMCd5KOY+xnFrO9TY+7df1EdMH6EfJJh7i6FHHqd2Q==
X-Received: by 2002:a17:902:e804:b0:1d0:98db:6fd4 with SMTP id u4-20020a170902e80400b001d098db6fd4mr4578699plg.56.1701798326243;
        Tue, 05 Dec 2023 09:45:26 -0800 (PST)
Received: from grind.. ([152.234.124.8])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b001c74df14e6fsm10465705pll.284.2023.12.05.09.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 09:45:25 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 1/3] RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
Date: Tue,  5 Dec 2023 14:45:07 -0300
Message-ID: <20231205174509.2238870-2-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
References: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
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


