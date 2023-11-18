Return-Path: <kvm+bounces-1996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA6C7EFFDD
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 056471C2099A
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F091944C;
	Sat, 18 Nov 2023 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NPrj2+sZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B0D127
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:25 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6be1bc5aa1cso3018185b3a.3
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700314165; x=1700918965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KG9fE/ulNJd1c12EDFqGAOQoZRizdjFhQ3bpRl8KTVg=;
        b=NPrj2+sZ3odzlDtaPjxlJEhtYkXAosIzzwT6Qm1/LrsHOQ3WaHd9D8r5TyFRC4HiuR
         ZkE8Vznb3w0awtr+7ngVLw8r4IlcPo9GLNbgkuARZ+DonI+Crgr9UT5n+Ayfn6DHm6TG
         3Fx8zsBiXD/+nmLdZdy/UzCP218QNxZvS8YliC3UhFRPSGnG5/Hnoim9IEXYp/sCErw6
         k078fzUCW/v0DctClCxWgHbExlk29CEEl6dsXl84sTBQFCGaakziabZ6uGRHjHY2QCQc
         5WLQzl+kw9SZxXMlKtPm2R3is0do8hRpXvDdambRWySzsPEu+R3zrDT49qExVwc9zmJZ
         omrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700314165; x=1700918965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KG9fE/ulNJd1c12EDFqGAOQoZRizdjFhQ3bpRl8KTVg=;
        b=vgHEDSRSkm4JC6UjgwGRTf67etLceT48s0UMez8ehoVstyaJFQfqKVu9bom1iRvd9p
         FBnpxV6/JXKPqfqHfskj28t00+NVfR+/KqvxvUlfYREhYduzcqbOhgJPi4bczz9c6b4j
         JAvsrEpt1hRWaY84Fq5GRUyNWpo9ZrAIQRD2+p5XcqewV+U8GbF4wVzyAsedXyZQnPTs
         aBKtTszQ1tvpKNPTR2PcJsqCGcdgYI0N2wOw7t2TkT9V9KwPlqesth7p62o7js9t/iS5
         j4H2QRiks6QIk7r17ouZy0CQxTht/z2DwzbY6y/J6YL4ix3CO3WtmZ2GUwzoht5VcI3X
         n3lg==
X-Gm-Message-State: AOJu0YzJkif4dZp1p3Zq3X1BQmzyqp5HprGQlv9OxQfu5035VIFjhCqi
	gENei5eumeEDjcUJDKvgfJKFwQ==
X-Google-Smtp-Source: AGHT+IHFsG2c9osDnSidM/BrblH3pHYZcc3UVFAjJBJDCvyZqHLV1Hw+spba4FwPjuVWvt78yBuQUA==
X-Received: by 2002:a05:6a00:3903:b0:6c2:cb4a:73c3 with SMTP id fh3-20020a056a00390300b006c2cb4a73c3mr3199868pfb.11.1700314164602;
        Sat, 18 Nov 2023 05:29:24 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.80.108])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b005b944b20f34sm2627262pgf.85.2023.11.18.05.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 05:29:24 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 6/6] riscv: Fix guest/init linkage for multilib toolchain
Date: Sat, 18 Nov 2023 18:58:47 +0530
Message-Id: <20231118132847.758785-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231118132847.758785-1-apatel@ventanamicro.com>
References: <20231118132847.758785-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For RISC-V multilib toolchains, we must specify -mabi and -march
options when linking guest/init.

Fixes: 2e99678314c2 ("riscv: Initial skeletal support")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index acd5ffd..d84dc8e 100644
--- a/Makefile
+++ b/Makefile
@@ -223,9 +223,11 @@ ifeq ($(ARCH),riscv)
 	OBJS		+= riscv/aia.o
 	ifeq ($(RISCV_XLEN),32)
 		CFLAGS	+= -mabi=ilp32d -march=rv32gc
+		GUEST_INIT_FLAGS += -mabi=ilp32d -march=rv32gc
 	endif
 	ifeq ($(RISCV_XLEN),64)
 		CFLAGS	+= -mabi=lp64d -march=rv64gc
+		GUEST_INIT_FLAGS += -mabi=lp64d -march=rv64gc
 	endif
 
 	ARCH_WANT_LIBFDT := y
-- 
2.34.1


