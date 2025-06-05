Return-Path: <kvm+bounces-48561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EC4ACF3FF
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D191E171440
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D981F5820;
	Thu,  5 Jun 2025 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BxfudR4A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF5F1DA60F
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749140291; cv=none; b=FPwj9vh0Dz9n6KKm1FiZUWx/UAWNSTZusX3/3c0eSkp8CNgALWsPeeHw3WvHmEti26OdEj7q4iGbmM76B15X/U6WJ8c19Dglx9+Smuy2Fvekohf8W0rhqXSNj3fFcvWOR/fyftLkHA06oOeQLUUOUxVwiwMtxF7XO4tyXWCIL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749140291; c=relaxed/simple;
	bh=R17KALMsjjzAwfh5723HN1SLkUQzWPSnAKPnTmEEdPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZ6VoEnYLoQkvAtFzFnz0mb7ftnNBM955FJ6OYmtfqEJZlw2lU/7SEzgzCTQdcPLP6OdLsKrfHQwuT5IPkONneBoQwthyW14VYotxYypPKK0/S5PoeJgxICnzEiHi9OkGJ+OzPAu5bdQbO7jTCtAJS9yKe1pn9knIXXR4I7CxWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BxfudR4A; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-48d71b77cc0so13475591cf.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 09:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1749140288; x=1749745088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6bcQy7gPSkBnevmxMbb5LF8ShmOv1KLO/XGyCnpQumw=;
        b=BxfudR4ATzM5OnZQvEkDwv854ZhgS7hYRXPfjR8W9tblzpXaTfvgMGA1aIr50cn00B
         EN86fwYmjoYuR/SPE45sYzW6QjY+jGsh1ruzLA0aZDhlwek6g/pWem8mTWDusIfbiT7n
         94zk/UduqfCQETkvSuOuVbER14TmggYvsf1f9cng3yR18AXpLU0AwH+PFd1ke7mdGfzL
         E4wPNCOeHZcgITFwmRI96+E59zDIg16zuRba/OTlQjxVhcNctwc5t8JcKfbWDxDjGSZe
         WnWAB1hdRq2lv6zuKH1muK8sl1wS8REqOyDS69+2GAOaN1T8I5JF6VstG+GGNPd5SSAG
         +kow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749140288; x=1749745088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6bcQy7gPSkBnevmxMbb5LF8ShmOv1KLO/XGyCnpQumw=;
        b=WiBtSRu6vbuJiPDE/vUfeCYTizwcJoTHDnHyR1BXzMr8FN9ADo1CuGKpSUp5rDJOsW
         p+9AdIkmEqP6oxwwmThmI31OkL6d3f1/aJcr5PkyPQ9vPs63yFyjxOW5XLcPOmEhYL+v
         H5iD8T70cYK5nX7CTS9mMwF8urLxxftehYnIr/aZueD1UtyVg02KyFfXd5gBciasq4pe
         /JjJHrL3JsIRHBQ6b03A5lNSeAgH9et/0l7kN0MgkbFvgoWHv82vPkBwoEl5hjl4t3TR
         zEAPacqBBzkUVIb00I7KyjqVQ+V8FmlxEACy6W6CIDyQFiBX+vYHv8CyWALkc7FdVx3M
         bhPQ==
X-Gm-Message-State: AOJu0YxKiZzoBBT6K/gr8+kuEuuouqXFXsCusUtjn6xEFDVIlVBJ//yo
	hMSEqT3CywJRzYe4Ebqp+pdrC+JBLxkeCNj/LfaubX4tupI0IXOPNUhbKm/oHx/+0B9t8t3Bbd+
	DWbYP
X-Gm-Gg: ASbGncugaRlju6MeaYwV3itkHo8u38rMywjxhh++99uKswH7rvgOuHWWj883uCNOFfL
	H2Ev53dp+3QhQFcn48u1D88IOMRAQtO/9lzWt4DL6N6bYihb075uMNM6kuKaM51pdVfUTEzexdJ
	L0ouS5YRa1pF8KsvNtZe38EOjta+At5PouIJf5rScjYhS0H4x4eqvQKo3ZjgqVLjW0PqVrOnV9X
	18YeGmz/CcmFoL1kJRolwEQk1JWR4YbkAzJfQJBz/njsr1AWFuedkWEIZzp9SdXg3AG7jBt8qD0
	l61rC7UYGqp4S0HsIK1h2TWnJCl9ffzJu45hV7u5zTsOu8tK7K005QpIQH7G3tmYQlOm8M87y2E
	WUO2Rc4KQJafU0FdydWQI2+LYFd/ogVty8ICd9A==
X-Google-Smtp-Source: AGHT+IGagtTXHkeQ0OodJZSC8xG5sdbF/6dv3bvtybwawwSAoeJrgu7/hP6ErOxbMaXTuJabouxgmg==
X-Received: by 2002:a05:622a:551b:b0:4a4:22a1:dab8 with SMTP id d75a77b69052e-4a5b9e0048fmr6122691cf.11.1749140287803;
        Thu, 05 Jun 2025 09:18:07 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com (pool-108-26-224-24.bstnma.fios.verizon.net. [108.26.224.24])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a435a8435esm112334771cf.78.2025.06.05.09.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 09:18:07 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: Atish Patra <atishp@atishpatra.org>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Jesse Taube <jesse@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v3 1/2] riscv: Add RV_INSN_LEN to processor.h
Date: Thu,  5 Jun 2025 09:18:05 -0700
Message-ID: <20250605161806.1206850-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When handeling traps and faults it is offten necessary to know the size
of the instruction at epc. Add RV_INSN_LEN to calculate the
instruction size.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
 lib/riscv/asm/processor.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 40104272..631ce226 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -7,6 +7,8 @@
 #define EXCEPTION_CAUSE_MAX	24
 #define INTERRUPT_CAUSE_MAX	16
 
+#define RV_INSN_LEN(insn)		((((insn) & 0x3) < 0x3) ? 2 : 4)
+
 typedef void (*exception_fn)(struct pt_regs *);
 
 struct thread_info {
-- 
2.43.0


