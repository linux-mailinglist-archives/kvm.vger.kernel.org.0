Return-Path: <kvm+bounces-40344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A75D7A56D51
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:16:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26AAB3A9066
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C8623AE9A;
	Fri,  7 Mar 2025 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Tf6PUaCW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AB323959A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364158; cv=none; b=ArQOOReIlh+qkEiMlQZugfFaN1xXONZmfQj9pmnJdlfn2QakoheLoN+NPgtM2VfkAE6u5Ia7Y9cn1AjlLMZx6D5mV2VdVzRmEzHktp/XgLo3RqqBPXsiJ6wWBqCgT5m4mt0qaM+7uV5JN5o6shP4kX9WESywdEfJ5Khx7qpud0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364158; c=relaxed/simple;
	bh=BiyKyIHm7l9GP+JDlcvuhxsmijeJ+nOu7K5c2SdsmUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K1rN31tsp8WRtSrt/TSUlypW1wIkapWlnqwgK+hWi7Ir5QqG6jMlI1CU8k9PD5cqoKTOpvhzQ7DlVJfuy0+I2Y1t5tsvgYoYjNz920DCVqSYFgDOPgp2EoVg9by5dFUAbReXyn/pfmt/dNy4ODjBmoLj4clLYH9tdNe1pgqZjz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Tf6PUaCW; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43bdc607c3fso12817615e9.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 08:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741364154; x=1741968954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCReb3cvg707HPbBwZSbIVzyvT4c2UyWOl9p1yzcaUg=;
        b=Tf6PUaCWy5bVasvNdOFO/ouOyXs2CysexMN+Y2m7gSDB7i1hme2WQz2GQTjK3yfZuu
         ct5WX9C7bvXYfD16p1UddtbIRI8YWL6h1CRnTeYzKgxO+jBSpRMQs5BlCfu6gibuHzPE
         Ai58SjiVt5C5gqNNLW9fQGqLHwTK8Am2Xdt4zT7HA++6MQS/g5swZmxs7WuWlYfq0jBu
         8QB7Ql7Cz5dzpT/uS9v5JZ8oJf6Cu/QWP6230/bCQ+wopCguL2mSWawr5cixMf21WDaW
         YNlNEyeh8bgJ9N3KiBRycQsvRZKUiUon8zQVBU0HQf1CdR3J9JWXZUref0b3PxJBWSJE
         aEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364154; x=1741968954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCReb3cvg707HPbBwZSbIVzyvT4c2UyWOl9p1yzcaUg=;
        b=PJOP4qX70UWsFwv2tl4u8QsbJOa5QUe/BtSZRTJ12e6RlAiisEFeJlojckOiTYsO70
         F2qfzkCfr+YfeT1eJ29GPP20xpJ9eEBDr5w+nMhl2xFdaeCzs1G/Iw9UVdfs7+ZNgU2Q
         t7tnZCVLbJ9ZmhQO94Mt/bsJmcPMR1vzi2ywIV7aQDdixT2p5PTpG6Fdf+bpvW6xgAv4
         At2/VD+5lHnCven9ubcXGrmkoJ4l1WW6fWxE3V1uVKwF09xWHKZDKrcQ6stF1W6yf5lB
         4/p34pijqVg3EorOhsYCQB16DBsBBisQ5YaHPIBlncMT3wEaFD5I92vW2NItr0PC9h/7
         HRMg==
X-Gm-Message-State: AOJu0YyjlvywKPot+GnQogjS1OH80qFobV5WCVhsHLv2JQegKxV3WLMC
	7AwUQPZXE+u2wiMzo/BKToQGwnP+YdjXFQvoi8lEQIr2DZt53X5UIaj1+9TulehcD6a7zCwy1xa
	n
X-Gm-Gg: ASbGncvUv9CQi+4wCHLpN5vX/HkQUpvt1rFjSWdX4IgJ47aZo8mgKNwX1XlgmWKvdLH
	PhjhyGv6SZTgIep2QnWhfr9p0dQ2DJAyOh0R8enfNZ5PVNi7qposJlyvmq3FQsCW05qCGaLcT8p
	Ju/wKl2JekJUm+6zdMvejS4+6eFcEKBuv5/CoNmig2mQhAbPyLFlUv26EBUfF0xvMdZ3U97c70Z
	PnTiPjejFohnmhjzFWwnfIYBGeADoOpmHa50fVInZShGBKKm1Vo8NC4TqSCEOj85hR/dIsWwDg2
	dus+zZPBM8enLi6gt/WV76O6NEk9CJwhlR+dX6UKwqyYlw==
X-Google-Smtp-Source: AGHT+IG9PL3mSCAWphM76+/MO36a6gjgduMu7busd7CtSobZbrw6wfyMhJnicGa7Y/w+ulU7H5lAKQ==
X-Received: by 2002:a05:600c:198b:b0:439:b7e3:ce56 with SMTP id 5b1f17b1804b1-43c687027f5mr28095125e9.29.1741364153686;
        Fri, 07 Mar 2025 08:15:53 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8daadbsm55496245e9.21.2025.03.07.08.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:15:52 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v8 2/6] riscv: Set .aux.o files as .PRECIOUS
Date: Fri,  7 Mar 2025 17:15:44 +0100
Message-ID: <20250307161549.1873770-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250307161549.1873770-1-cleger@rivosinc.com>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When compiling, we need to keep .aux.o file or they will be removed
after the compilation which leads to dependent files to be recompiled.
Set these files as .PRECIOUS to keep them.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/Makefile b/riscv/Makefile
index 52718f3f..ae9cf02a 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -90,6 +90,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
+.PRECIOUS: %.aux.o
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
-- 
2.47.2


