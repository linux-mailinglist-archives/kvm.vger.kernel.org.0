Return-Path: <kvm+bounces-4393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F6F811FFC
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 21:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F712827DF
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 20:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF4F5A10C;
	Wed, 13 Dec 2023 20:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gZ68dQNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F6E100
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:30:18 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-33621d443a7so3699690f8f.3
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702499417; x=1703104217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i+467Loz3LrvYEdXAV5s12LMqcUY9odwCyEv1IdVOvU=;
        b=gZ68dQNw/RKx0d/oICoetz555Ra/uNpzcF7W/+PXeUdEN8b28FE0zRdTMG7aZcvOd3
         khRv3oWfsZ8UFA3eDrp8OWX0SgZQb4PHzky2v/sMMIgKbOJVVs4lY5FXM+RqFemkmXsu
         fV8tPbNPboESY07Bv6Bb5vQnFSCSDITsEyyLGf/D4TOiDiWLydRuU6PemOJMXrckW41Y
         6ehCVKWYTa9883sRrWJzRXxEiPtzrv0hPQvjFyuEhVvxwXRrS285HsCrPyTrmEQt1JXg
         IVaGD8fJ0oQbSL3OpHtATR3by/loi94TtYmySiThArcC4hEQ4UMXNWEgLLPIqW56IoCk
         MKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702499417; x=1703104217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i+467Loz3LrvYEdXAV5s12LMqcUY9odwCyEv1IdVOvU=;
        b=ZH6aczQvcViId0RERXDksj2vJ//ZySBVQMDMiQgKtd1RKCJMHdRnbNog00sdcj2W0x
         G8DiGwlrUfoqvTRMbE4Xnir5GNF1sp3sAz1gDsC8Sh01ljnStZCqCa/5FOaQrBJ0kr0m
         1h1wfLe3u2RJJ+LvVqqhSsjeZJ4V/ytHvVUo2d8xVChZL867bDlgeItV+NfHfOuRnztd
         FNU5Bm9FDOsVlf6GXt9TyOgQQssvHBcJ/DCxv7pi4XVJXOaqsN466RmXPxxvwxRgR/dH
         AfvHKoyQLVXDbu2tIPrVtzkTG3rLL/idGZzVifvrKKlmEXMO1bou58txOl+EFLqpJkK+
         T+jg==
X-Gm-Message-State: AOJu0YypXcTBayri1EwYuDXYAQVY4AMkr6WaIABVEk0LLxv2LWcCO0nJ
	o08mL8ekKLno/GZcgpzaeKOe4A==
X-Google-Smtp-Source: AGHT+IGBLga6z9pG2jLj7Eh24QZCKuh/cAtflhfd+Zgtj1tOF9StAT24MMOv0TqcLPwKldvFFyI7jA==
X-Received: by 2002:a05:6000:10c1:b0:336:38ef:1e91 with SMTP id b1-20020a05600010c100b0033638ef1e91mr917003wrx.128.1702499416911;
        Wed, 13 Dec 2023 12:30:16 -0800 (PST)
Received: from alex-rivos.ba.rivosinc.com (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id x10-20020a5d444a000000b00336371fafe6sm2945256wrr.16.2023.12.13.12.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 12:30:16 -0800 (PST)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Russell King <linux@armlinux.org.uk>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v2 0/4] riscv: Use READ_ONCE()/WRITE_ONCE() for pte accesses
Date: Wed, 13 Dec 2023 21:29:57 +0100
Message-Id: <20231213203001.179237-1-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is a follow-up for riscv of a recent series from Ryan [1] which
converts all direct dereferences of pte_t into a ptet_get() access.

The goal here for riscv is to use READ_ONCE()/WRITE_ONCE() for all page
table entries accesses to avoid any compiler transformation when the
hardware can concurrently modify the page tables entries (A/D bits for
example).

I went a bit further and added pud/p4d/pgd_get() helpers as such concurrent
modifications can happen too at those levels.

[1] https://lore.kernel.org/all/20230612151545.3317766-1-ryan.roberts@arm.com/

Changes in v2:
- Fix the kernel test report on arm32
- Remove the pte suffix patch
- Fix pud_offset/p4d_offset which were missing the use of accessors
- Rebase on top of 6.7-rc4

Alexandre Ghiti (4):
  riscv: Use WRITE_ONCE() when setting page table entries
  mm: Introduce pudp/p4dp/pgdp_get() functions
  riscv: mm: Only compile pgtable.c if MMU
  riscv: Use accessors to page table entries instead of direct
    dereference

 arch/arm/include/asm/pgtable.h      |  2 ++
 arch/riscv/include/asm/kfence.h     |  4 +--
 arch/riscv/include/asm/pgtable-64.h | 22 +++----------
 arch/riscv/include/asm/pgtable.h    | 33 +++++--------------
 arch/riscv/kernel/efi.c             |  2 +-
 arch/riscv/kvm/mmu.c                | 22 ++++++-------
 arch/riscv/mm/Makefile              |  3 +-
 arch/riscv/mm/fault.c               | 16 ++++-----
 arch/riscv/mm/hugetlbpage.c         | 12 +++----
 arch/riscv/mm/kasan_init.c          | 45 +++++++++++++------------
 arch/riscv/mm/pageattr.c            | 44 ++++++++++++-------------
 arch/riscv/mm/pgtable.c             | 51 ++++++++++++++++++++++++++---
 include/linux/pgtable.h             | 21 ++++++++++++
 13 files changed, 157 insertions(+), 120 deletions(-)

-- 
2.39.2


