Return-Path: <kvm+bounces-41043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6A7A60FA3
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:10:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF24A4606DD
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100771FDA9B;
	Fri, 14 Mar 2025 11:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="3Vxpa1W5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1071F4288
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741950643; cv=none; b=uj/a0Y19QPjmNw6DhHnYGkvZX30zGgGG1BHslzbtAsem3EbaJkJ08J/8sdJ7FyMQ2E5KXjq6dV8zRJZ0DdaEgo3BYldvsHFx8tC+RBfDUz0lD3PScmmQPp9gdInAe3rA2au4hMdcSA6GSLYAxOzYyJNJpJjliAP3bc6YqXMJbEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741950643; c=relaxed/simple;
	bh=DjyTf8rvGg+sxlrtrvr2LrWvnoCj1tzl8p+htzo4Khs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ocs2t5oQGpD3YhTpFOxtrynxHJYXy67lslr+vwuIQNjD+WjeYvXRQ99+LchaD9CBdtGcbHJszp7khr9Uqf8amvoHNAZ4i6GlMnO1fHC1BOf3yS3NfcUdrmqYzpFqYPOoQNj4gQWa9V66bjJNUUY2/rTUsvMh36cXRLDup9LNEB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=3Vxpa1W5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d0a5cfd7dso13145695e9.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741950638; x=1742555438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gp1/a4HJMNi1Mi5InH5hHHDY+xPb3C4W59LQWScL2LY=;
        b=3Vxpa1W5vY7X8eitKCXgDEh9DVDg3LGQKDnUkXpQ+Z/YxCKmCDZKpx/05G7xUr3n+B
         Y7eymKYyen8W9c/wQqOYUo90878k3/Tm0v4sMFbh8jIevVNk1kNk1MAO8YeZbW+fEpBR
         PwWl+tLX5X/AWuicguG2x5+yUl/o1QzC9w7/CFy5kU3MxynVAaUURP9gUPXxm1dfz7Cf
         Frm1WrNitiFYGkx1uSRFlAlPNL2j6BYG27DylWc4idMJ8q5/MyUo1e/zl3GIiUvBclsC
         Zm9teV2fcf6CaqMpVPI8xwrsNv0h5fnn5Aa/Q728ASRjOWcfIdgT9bqw6UGeD2C4dBdY
         iJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741950638; x=1742555438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gp1/a4HJMNi1Mi5InH5hHHDY+xPb3C4W59LQWScL2LY=;
        b=Z/D9u0el+FYbY7eF5Qtc58sl+RB3stvZTJSDcb2tSAlWOa/2FkHHfjDXjz5DiyWK8f
         LIxo9afzqlVvy00ygmLRWiKwf7AAOy8HHQEurmPyKJBeAMiw9n0jKmSeWumHtOTmUSSj
         BUwjHUUBnkxsVNLzbyE2yodHpbPTIAe9EZq07561v7+8FAMzaULQbZJOrGt8weuqiQNT
         LHuW0nMmyW6aYniW8KYm9YFjDtojXlXTEVLQmhd9xL0U4Wzhm1zfr0U1uQx9MIYr2bRY
         YvAe1gl9EVoc+k07CcJxs/pBQ+aJsyQi2RkqYID9c3qaPYfGTo5/80gW0d4BfpYL89n3
         eLNA==
X-Gm-Message-State: AOJu0Yyy9KDpR5lmU7h/8zwEgJ6r/xcMe8F1JrwZ3u6BaGCBkZs13Hur
	70ENmFgk17uRhzDnhL3F3Nu4xnBDI+bzFELbD2yTYno4TtBjxJKozaGH+aLGxWiHQHhgmIcFgf8
	Qal4=
X-Gm-Gg: ASbGncu8oJ6ZKi5YaX8XVzdh7Z70GbzDtY5Q28XXhcl2+o+myebADbr4MTat+KW2HIF
	dBSfZJ8ZpCz7dXQOblQo4ANCnHrLRbbW+OUdTLRUgbStLeWY/iiySRbwYioDcb25JSC1rkQlcm8
	bl7ufoez3o4lV+iUClR3Ooh3f0pgTfAE0LJII7g2VjeVfAAF3y7Gr3w/LZDj1sHWq0dQeFx+9dY
	terBMTl+zsDhGx6cL1nw5jJvSGoqUC6og6gcSoAbQ8Hp1UQb5qc1+R63hKOZz0a9iafv52RxJc4
	mqeHXca+lq9hWHKiT0YjF559RkAgdy0t2KWRelEgtmPL2w==
X-Google-Smtp-Source: AGHT+IEc9bVKQjP8LFKBn9o8XzyPNxvekNKBXKTZ6w8EQ6LJ1oTbhl5A33KtEPlIQggrNtpIXe/5VA==
X-Received: by 2002:a5d:5f85:0:b0:391:306f:57e4 with SMTP id ffacd0b85a97d-3971f9e4947mr2605885f8f.34.1741950638331;
        Fri, 14 Mar 2025 04:10:38 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb3188e8sm5299203f8f.65.2025.03.14.04.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 04:10:37 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v9 2/6] riscv: Set .aux.o files as .PRECIOUS
Date: Fri, 14 Mar 2025 12:10:25 +0100
Message-ID: <20250314111030.3728671-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250314111030.3728671-1-cleger@rivosinc.com>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
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


