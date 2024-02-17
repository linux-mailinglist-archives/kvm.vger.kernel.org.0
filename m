Return-Path: <kvm+bounces-8924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD33858C27
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 908541C2130B
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F571D553;
	Sat, 17 Feb 2024 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="g8rH5Ppg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0351CFA7
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131509; cv=none; b=IgT9/pDQ8VGe7cBWLl8VXalEsKhptda6+P6Ws57Ko6YayMPRgpTdOV7Z3+uzdEytDnwK0FaoPVnd2OtbEX17DFVjSvrn1jedUUlDvQMwk3ZSeO/uYndKQ/a5vIJ8DMmm5ywIEyv/22bBGHLVIMKahMh4W2AaLFoplUrDxFehjXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131509; c=relaxed/simple;
	bh=HwQLSOaSysKB57XjfW856whj8y+8/2+fgWJrX4Iklho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f6nB82PwzRyHbzDNSprx/lQDIkAiJbjZ2AzfPZ3EVQkxxcl7Vmiz1yJkQHXH2ccsjPRs2pokHPBD9pOLjczoCt0J1W2PIhc/eecw+HBvKe7px/7nkh+ZROHYXQ1xTONvoe6oIXQL1KMjfqqukNpqd9R5rkmBPOI/TPcVWwdOXb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=g8rH5Ppg; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7c48e13e0d7so65620039f.1
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131507; x=1708736307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tZxqoC10roX3FmWShwLO5FF28+Cew6bJztG9VlJd1gc=;
        b=g8rH5PpgVFeqkgsI9vorPN6vIDaoG6bmYjVOjyUjVR0fybhnZIpZpQUYadYAcyXs2a
         1RjFSh2RA4exO6fqgWfNa8uHkodI5tPLrjV2zVoQrL2zRS9WxcPkJ38nzhnsjUaxsCbj
         BAJ8Nbff8MqoAym8dWt4K1243RDBdcRoTNHv2saAqQJnQGwJlD3CnHZWTq8GLQ9GhlBU
         1kVYl6Y2KOdem1mmJcV1xMPdU0dk5Re+uExRWJCf5gLmNIE3YPmD5Q2yU2EQmy3Qwa8f
         lWCQDNxjXEDnuNcCw/uBOZ7KXM9wVf9bSIxjCw4juZDPPK9jSK7sTqfSRcQ6lPjXfDxj
         UgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131507; x=1708736307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tZxqoC10roX3FmWShwLO5FF28+Cew6bJztG9VlJd1gc=;
        b=wS7o5dNdvDSVaUFOuMdeePjR1qil/eaP4pk0fvxLPziARczRxWrH+KV2eg1RTaU66c
         MWtwdfKTlnBLi2FTMSYghmCjpUqf5EcIN4dgOCwGLsnAVh6NR/GI6Jq9MA3OgdSQ954t
         BweF/4DX5V2OSUyb4nUMkrrK/JUunlW2KAp3v/J7z0CGpdWgWVWlzjOl3IUPIUFYYZfe
         C+qTp48FBiyBz2fd4MKSO/eJjmsouRZZ3siNJCaOZITsidPfYvDbJ+9B3YeLyf8DRAXP
         o2wOqW/3tZMrLcOk0bBIZHtNaMyQRsnL6d3VhDTxBCKA8CKe1XCsIMr4vjrJD3A7Sak8
         xIqA==
X-Forwarded-Encrypted: i=1; AJvYcCUHsw6xrzptzLQaNxbxwI0+Mw9eaYdKkQdxszheJnyKmj0hZU40nBvo+5fq5LAU7B5fqy8mWcj9wRi9K5Gg405nsZpf
X-Gm-Message-State: AOJu0YyVoaf+FDtRBgqpnCuBodskjGQ0LsJhQdRmkSyn2oAt+3Gl0mYu
	371vK/l/TIpg2/jfJzbZTvKCdpdTMOjUjAXWS8RrMQdF1xTDFxkVZz9FPJjIg1o=
X-Google-Smtp-Source: AGHT+IEz0+A9x0GTcr1tO8p0VDE5KRpFc1BbSQ5HWLqCdx+AJgXr1jki3q4ZnbUMgc8MM5i0wwekUQ==
X-Received: by 2002:a92:c54d:0:b0:365:1563:c4e5 with SMTP id a13-20020a92c54d000000b003651563c4e5mr2552537ilj.9.1708131506838;
        Fri, 16 Feb 2024 16:58:26 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:26 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor@kernel.org>,
	devicetree@vger.kernel.org,
	Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com,
	Yang Jihong <yangjihong1@huawei.com>
Subject: [PATCH RFC 05/20] RISC-V: Define indirect CSR access helpers
Date: Fri, 16 Feb 2024 16:57:23 -0800
Message-Id: <20240217005738.3744121-6-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217005738.3744121-1-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The indriect CSR requires multiple instructions to read/write CSR.
Add a few helper functions for ease of usage.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr_ind.h | 42 ++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 arch/riscv/include/asm/csr_ind.h

diff --git a/arch/riscv/include/asm/csr_ind.h b/arch/riscv/include/asm/csr_ind.h
new file mode 100644
index 000000000000..9611c221eb6f
--- /dev/null
+++ b/arch/riscv/include/asm/csr_ind.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 Rivos Inc.
+ */
+
+#ifndef _ASM_RISCV_CSR_IND_H
+#define _ASM_RISCV_CSR_IND_H
+
+#include <asm/csr.h>
+
+#define csr_ind_read(iregcsr, iselbase, iseloff) ({	\
+	unsigned long value = 0;			\
+	unsigned long flags;				\
+	local_irq_save(flags);				\
+	csr_write(CSR_ISELECT, iselbase + iseloff);	\
+	value = csr_read(iregcsr);			\
+	local_irq_restore(flags);			\
+	value;						\
+})
+
+#define csr_ind_write(iregcsr, iselbase, iseloff, value) ({	\
+	unsigned long flags;					\
+	local_irq_save(flags);					\
+	csr_write(CSR_ISELECT, iselbase + iseloff);		\
+	csr_write(iregcsr, value);				\
+	local_irq_restore(flags);				\
+})
+
+#define csr_ind_warl(iregcsr, iselbase, iseloff, warl_val) ({	\
+	unsigned long old_val = 0, value = 0;			\
+	unsigned long flags;					\
+	local_irq_save(flags);					\
+	csr_write(CSR_ISELECT, iselbase + iseloff);		\
+	old_val = csr_read(iregcsr);				\
+	csr_write(iregcsr, value);				\
+	value = csr_read(iregcsr);				\
+	csr_write(iregcsr, old_val);				\
+	local_irq_restore(flags);				\
+	value;							\
+})
+
+#endif
-- 
2.34.1


