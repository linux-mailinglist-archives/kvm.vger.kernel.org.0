Return-Path: <kvm+bounces-45834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89975AAF58F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 10:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBD4A1BC3B94
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 08:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD0B230BC0;
	Thu,  8 May 2025 08:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bzgr6yYI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BBA223DE7
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 08:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746692544; cv=none; b=EUJXNYhoDRLunLYedooEuO6H9qbqM+U0GKRCknMDE5V+cZIzYonYcCmnjNHyOJtPS74wA35pQw9/powFPDATtISfDdMjHo1+8R0rujjtJVgpclt0086fy+jpQYMDCPTTLIJrOwjptrYTTy0kZfPpCtafh4yKEuhNAFAGNI8+OVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746692544; c=relaxed/simple;
	bh=32IEuUAXPJzi6W6IHpGdsA6y2xGwNiuxqo8F2Gdi/N4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=rN0R9e4dgAH9LqB9uUrIJMiP/iQdJl9qRyhsraxTayYFQsH0Ty60ESDOg1s8Fv60bIg/s/i7UpwPjEIvpErTd7ohLLXcr70VEO2Wis75xtqi1fUsZAHumrnK485LW18SyF+MER2qmGnqyxrwt5QyU2bonzek3vmiyFOQxkOXWg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=bzgr6yYI; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a0b933f214so282978f8f.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 01:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746692539; x=1747297339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ONdFAQ5P5cYSHok4vt/xoWp2gEIdFn3GfsMoftwXziY=;
        b=bzgr6yYIaNeAUDeD0K+lpIPqJ+Hu3BGBTbhsGcQta7P5zrsleDVU4EfTVKqqvPUDyD
         fzRSq4kMqKVWz0lH/LLpWnw1Q2CP7HVhzyrW7TQZBqh8yNhaq0rrtDFiTy+hhUpQ8kJE
         c5eCvPVkKMTHXiyyPWsr+R6jAhMQGco1BnuK3KYGuQSblFBdXs7galIcDmDYzrn/AOg1
         MdnH2CPS784m3uBBOMWa3FPQyCOAhEC2Erbu9y4jyaQkUFEjbP7HaFa2PmJ62AmgYA85
         l2rPgaKH8muqjtfcABgdGmXv+hBBUxHC0ITbrMMdDesur98ySKy8mjz9OHjw6GYkVs2K
         qQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746692539; x=1747297339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONdFAQ5P5cYSHok4vt/xoWp2gEIdFn3GfsMoftwXziY=;
        b=S5bNZBbnkcX5xOI0nl6dUwdstlv74xb8j6c+AXO/F5v0aIsJV1s9TuKsYvFxr0aAb4
         qNyUvG8hyrRmODRchT/0Ba4hneSmKGZIkb/BpZ2NxhIQ/JHCAeOyumwn6iDk/xSK8F7d
         529QFGw6gp+4vG3xURdJlilhqxeTBrEm2YG5fNKFWfWPQy6hOVnL0QcXWA7x3G2rOa0N
         CQU684YUNOlm5W28hFipCgsDh15ZLMP4IKuhhbKTRDoeIi31qG8qmEDCBhdTD/ju2ZDY
         oD7/5EdHwN0r7Z8a54wL6YPxjkH8293hc1f3m2b5ir0235rTc8Dv3z1wZzvnTaNg2RMQ
         NmtA==
X-Forwarded-Encrypted: i=1; AJvYcCUMwKQlLoJwERjriJhwQB/gthqGYotSYQ+fxhR0nnTrQVNNuK+RLRVCidKrZ7JPt/KUSBs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv/+xxnjWA8J5aYRe4mJgcu/TA9iz5ZOm5l8gfswhpLf8/p1Ng
	uxbOx22P0FyIdbzKmq/pdQLa7wVm60Ape+kiACgVk4eKUrFQep/5XWUDKoBAOjc=
X-Gm-Gg: ASbGncvK2gQmDhg8+aYUMJKGOETr11Mz/dT9N3a5dxz3dxd7L/eDGBHLWbn+xYgevXg
	Kvk11KX4n22X/F9xl2K5R/6OL3K+YenSEPTq9cGBjaMBu+Jp9RdgpcsKZB0qEFf+NK28xTcUg/O
	NzOYfgDtl9gH33zCpMuE26l+Hq7kY7Ndpj+WHvrVWIsIGsT7AGWxELzjcr/ltgCnRDs4g0hVbeb
	tMuFGmsImc2JUVwSMq6uAdOO9jSIdKXhewXe1x3tgIZ8uFFNBtGThalERbhQA2ZOZOW1oIfeOm5
	sYxSVV60IwDKfgmJOoJXmmEiZYDu0FQXl8psPOi7YtEnnME4y/s=
X-Google-Smtp-Source: AGHT+IG8ZUsqDihvY3hcYFCE6vFamKLpHiAoEt3SaBH65DeVtZsbz9VqIVxia3B+zR7RdSZEbZEKJA==
X-Received: by 2002:a05:6000:1acc:b0:3a0:8295:9e0f with SMTP id ffacd0b85a97d-3a0b4a186cfmr5374862f8f.54.1746692539617;
        Thu, 08 May 2025 01:22:19 -0700 (PDT)
Received: from alex-rivos.lan ([2001:861:3382:ef90:e3eb:2939:f761:f7f1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae0c25sm19695125f8f.17.2025.05.08.01.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 01:22:19 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v2 0/3] Move duplicated instructions macros into asm/insn.h
Date: Thu,  8 May 2025 10:22:12 +0200
Message-Id: <20250508082215.88658-1-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The instructions parsing macros were duplicated and one of them had different
implementations, which is error prone.

So let's consolidate those macros in asm/insn.h.

v1: https://lore.kernel.org/linux-riscv/20250422082545.450453-1-alexghiti@rivosinc.com/

Changes in v2:
- Rebase on top of 6.15-rc5
- Add RB tags
- Define RV_X() using RV_X_mask() (Clément)
- Remove unused defines (Clément)
- Fix tabulations (Drew)

Alexandre Ghiti (3):
  riscv: Fix typo EXRACT -> EXTRACT
  riscv: Strengthen duplicate and inconsistent definition of RV_X()
  riscv: Move all duplicate insn parsing macros into asm/insn.h

 arch/riscv/include/asm/insn.h        | 199 ++++++++++++++++++++++++---
 arch/riscv/kernel/elf_kexec.c        |   2 +-
 arch/riscv/kernel/traps_misaligned.c | 137 +-----------------
 arch/riscv/kernel/vector.c           |   2 +-
 arch/riscv/kvm/vcpu_insn.c           | 128 +----------------
 5 files changed, 181 insertions(+), 287 deletions(-)

-- 
2.39.2


