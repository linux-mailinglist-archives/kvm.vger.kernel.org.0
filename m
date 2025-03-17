Return-Path: <kvm+bounces-41250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 055A0A6593B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:57:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D9171888B02
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFD71FBC89;
	Mon, 17 Mar 2025 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qmr5xCPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0991F8726
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230185; cv=none; b=YFXszmxkJHH8pKFNuSws+M1S9sthHTCDjTvFCay2+5Xhf7UDigM2+i3X0l+7Gjm+ynatQd9AR6Y+1aQzZFOSie4pzpKDXcnnFMVVmwoPKbUdfQZDJoGhp3Yw0mA9ld9d/sw0CsTtUJScw0fJTJGXJfoyLLKDxh9pCUs2D1nrYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230185; c=relaxed/simple;
	bh=DjyTf8rvGg+sxlrtrvr2LrWvnoCj1tzl8p+htzo4Khs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2RiYYQO+26ZFIGxFuEXomWUrKJCLmd1uS/47p045x7YST1D7q6qSlw0Ic41Jas6RNSPn8br2bDhvehdRhtLkoKscg+ww6uA1KYDly0iXVdN6xrh4FMdLzXX8ZYq67LXqwTuolkyp+9JwtjplRsAma26IL8JrMYGUQWG2k9ZPok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=qmr5xCPJ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3913cf69784so3979091f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230181; x=1742834981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gp1/a4HJMNi1Mi5InH5hHHDY+xPb3C4W59LQWScL2LY=;
        b=qmr5xCPJZb+IDEM/SqiLrDxiIB0lj/h+VN+NJS7EDam8KlF5RNmFsy0mxeQ36JoB+e
         35Vokm8ES0WGIt+H9Gh5iQB5QTsdEQYAwCZCgl4KkrkuQJWnRZZfmoAV88CR+uvq2V2A
         /8Hd7fji0l03hJdcBlSgMhRndSoz3r1zAjJrG9xDC0qMQ6qwM6NJcJ7EKJzbh/8eNVGw
         /z6H0HUf8uE46bDN+IeVh+Q1iNLhy4bPwBRNE+UQZ84yCRYsLbWI2Ew9XwxyMtqiRMaC
         DYJKIHsR4d1K/mLRhXVlo0Vl5tjjMz1YkmCaW19B0npJyPDHgx8ckfTckxJA8d03Qu/V
         UkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230181; x=1742834981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gp1/a4HJMNi1Mi5InH5hHHDY+xPb3C4W59LQWScL2LY=;
        b=GrkSuHLBxoCk+4vaCMSsROA5DJSX/T7Inw5pZFp4kLkwQ9UbQD3NFmgWMYBeFUNP2h
         lGMB+MsLyVFpiuNZqneKqO4GoaDdBQacqref4y/FN62Y3qkqHZf/8aCQHI4M5UZ490QB
         dsM3CMcnpAT1EpIhTxXsbSuCdl3xu2uOUOTpgZLLTxlXckYhZ+wwWYg+FQ81OBsKHJFT
         38G9coZQARJxXrth5L5Z/kKJWjWlCfxwFGoj9h40rJp+mPiu+iEbtLVMiwdchOeq9nOx
         NLKpWbbZgfW+RacZhqSRC4Quf2Q3MGH8vUU0fiCoiv/hgQhVWqTpN/2qZ5ou2Uljz9OJ
         oCEQ==
X-Gm-Message-State: AOJu0YwwMsujiqawWEPUByYcUKyYUoZCnhR4aMJjJSzkNSRSFLsy+1wI
	9jmuQSbI8DpJIQzguLYPh4sAf0MKlzGfudtvtbG38ufGpkjcLlE0zd0EvD4oMJvtFlEDK4upXDQ
	S+qI=
X-Gm-Gg: ASbGncu0WF6G3fbkTDP4CIR3qfOgNdpLZRBI3smUphD9N1hpIaIoK91tPowvXLAsQ+w
	7f1ululZnvniWEDBA1CGzYM/imtGQhvJAsScKyboQQmhgn8KcmjKQMNx0RoYtaFIB4+t9bTWNz3
	JDY/jqkEPx4sGnDFcu9fE07xp6KJyK6lH/IYD4znM5I6lFTFfqHW/f03PCqQRWsF1iNvz9V0xQ/
	mkFLxkYm8ZDBQchH87ijEUCcyRQNnS0EQkILP77wEr6MRghwZVJbKBGaSVsEIqCMXtvuec5ifXT
	ogIlCRaLfRtEHnIjrdbX6tv+kvtQ59yYfAgkkSZgA6Pc7A==
X-Google-Smtp-Source: AGHT+IEh8zHBaUIIXKuvqFdTMq+3vL10WSh07vIZILI17IOXbqDNPXZu4MtQo86xNhPGSU1HmXD2bg==
X-Received: by 2002:a05:6000:1a85:b0:390:e9b5:d69c with SMTP id ffacd0b85a97d-3971e876827mr15899371f8f.25.1742230180661;
        Mon, 17 Mar 2025 09:49:40 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:39 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v11 2/8] riscv: Set .aux.o files as .PRECIOUS
Date: Mon, 17 Mar 2025 17:46:47 +0100
Message-ID: <20250317164655.1120015-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
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
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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


