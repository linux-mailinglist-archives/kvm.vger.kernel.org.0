Return-Path: <kvm+bounces-20636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FFD91B901
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1BCD281B31
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 07:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4913146D54;
	Fri, 28 Jun 2024 07:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="K8MLtgJy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C83145340
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 07:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719561127; cv=none; b=cCDg1dsrIWvObXS64Dq1sevfaT+2OG3J92LCpw97HW2wqsxX6SD0A1No1gNyJ4rGau4lgIyVLjH3tQ6MU+NrXyUU7NcWrDSFdVXJblhRCunBZaNyNIFXVnhSVpGNV94XJtS3MQD6aZjPc5DqxHfZ9BaI0/er4lSXPxJjiWXslwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719561127; c=relaxed/simple;
	bh=Ark6jD3S2s0EGCk/kplfkHpXwZMR4vMqPsKy7BXH++g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Te0roLUP9Q/8SqQm79b/PCb7NXxIIoFckNuHHiMfecYiy+1L5hdnUxT9222koFIRFLc08nFCKBOKLNUoBsh1rXbwEN8C5QC17oHEz1u/fxuqmolBP5eaVei/5lc4opc1p5PfDxkCVUHp7rm9WOilWJ+IukKc0YarJcMMsr06H+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=K8MLtgJy; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e02b79c6f21so270560276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 00:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719561125; x=1720165925; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eu+2wcx6ARI0Khk7sEf+LxSnsWz3kwiEgnTb6o13mh0=;
        b=K8MLtgJykJ6umJOFTmnh7i1rJ0JFUa2EJUnCBDKyJyVwabXGhCIUaHu7iofA4qsI2e
         te5ZDAz3DRBbn+Phaj7JETpQCxB7PkW4fx8SexCL4w138FEa43FrSA8Pc/bZh2bIRQm1
         maxY0NkVU/w0q4RI125XHdn0viFOqJiw68wgjakzpz6/wzV20yhBTXWB3O4aHzpSK+TP
         ih3SxkzZznifi60f6IaWvfGPr5laqppuSGejZB2nlG7rEXlxec3N3M9p31bemXsAZ2Y2
         DzuVQGrMG7UpHvYm5gQ/v8NOkBhpduTmYGq8j4mT/EMCtw/y0GRnVeWO3u6tKOlFTNFA
         9MFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719561125; x=1720165925;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eu+2wcx6ARI0Khk7sEf+LxSnsWz3kwiEgnTb6o13mh0=;
        b=vdXZu4cF8xgTatol3iIbXhgH2OqcNYbwj8squ+BRtfNVjk5k+ie5jB0d07Xn9DVRRb
         Hs0XLilHHzUunEWW/Tux/BytfooRvYoZ6dKJSJul4u7onDuM+b+YRY4L5tt9bw0klLq4
         z900Hwq/iIESAgwq29/60msIyABm9RPsYyOCy6PAA3aq4ll5JnliKdjjyqAEZj7gkj8L
         uZ26OKcR3jdWsVN3+AOBTUtv5j2FB0ahm8jXGYYJk4CDyMkDGzeS7v0YjcWCiFNeE63E
         3gF+YqqZ1pDmOQEoNAVri4LohrO6650yxnNmifGNLnTBjSrVDXZNWVdaeB7k76XFvHso
         c28g==
X-Forwarded-Encrypted: i=1; AJvYcCVMEIZ4zzNLrQOOOIjC7QjkxuM2zPdwWCypDXWO4oexKVDvAQh4OKMzbwKegwqPeje1dM49Xku2BsD4T3wYJ/eyiibS
X-Gm-Message-State: AOJu0YyoBH13hzpQmMP0M3jCDqO6drLfsVBDuFiQUVDrlHxhjr3E3jIu
	CY/CJhngh+oYi7RdNcxZ3UIaKywJXdHfz+G7XXJKlqsySASnlgybz61uEMmEmU8=
X-Google-Smtp-Source: AGHT+IEZUhwullYVKgF25a+0boKvH0ownItzxOgMvrt6D0RnS9rjqr16EhSB3iPBE5ZjBx8I+fBacw==
X-Received: by 2002:a05:6902:1701:b0:e03:48ed:d275 with SMTP id 3f1490d57ef6-e0348edd2d9mr4844561276.61.1719561125224;
        Fri, 28 Jun 2024 00:52:05 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c69b53bf2sm685068a12.2.2024.06.28.00.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 00:52:04 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 28 Jun 2024 00:51:41 -0700
Subject: [PATCH v4 1/3] drivers/perf: riscv: Do not update the event data
 if uptodate
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240628-misc_perf_fixes-v4-1-e01cfddcf035@rivosinc.com>
References: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
In-Reply-To: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
To: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org
Cc: Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Samuel Holland <samuel.holland@sifive.com>, 
 Palmer Dabbelt <palmer@rivosinc.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, Atish Patra <atishp@rivosinc.com>, garthlei@pku.edu.cn
X-Mailer: b4 0.15-dev-13183

In case of an counter overflow, the event data may get corrupted
if called from an external overflow handler. This happens because
we can't update the counter without starting it when SBI PMU
extension is in use. However, the prev_count has been already
updated at the first pass while the counter value is still the
old one.

The solution is simple where we don't need to update it again
if it is already updated which can be detected using hwc state.
The event state in the overflow handler is updated in the following
patch. Thus, this fix can't be backported to kernel version where
overflow support was added.

Fixes: a8625217a054 ("drivers/perf: riscv: Implement SBI PMU snapshot function")

Reported-by: garthlei@pku.edu.cn
Closes:https://lore.kernel.org/all/CC51D53B-846C-4D81-86FC-FBF969D0A0D6@pku.edu.cn/
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
index 78c490e0505a..0a02e85a8951 100644
--- a/drivers/perf/riscv_pmu.c
+++ b/drivers/perf/riscv_pmu.c
@@ -167,7 +167,7 @@ u64 riscv_pmu_event_update(struct perf_event *event)
 	unsigned long cmask;
 	u64 oldval, delta;
 
-	if (!rvpmu->ctr_read)
+	if (!rvpmu->ctr_read || (hwc->state & PERF_HES_UPTODATE))
 		return 0;
 
 	cmask = riscv_pmu_ctr_get_width_mask(event);

-- 
2.34.1


