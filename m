Return-Path: <kvm+bounces-45846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00182AAFA84
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FA1B466F2A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 12:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C6A227B94;
	Thu,  8 May 2025 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Xic5zdvG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A8E22A7E2
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 12:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708728; cv=none; b=PBPIedc7IgsvfPi2PiRbvz8xAvBAYH8ZCP39+YCIMXGXgT0c58gTUstYgHKxCDLbikH65FzNw2V1zT555r3tYVeBO7FhYDtjD1ZoDlf0M8ro8U7f+wp7qw4qO0GBj5Pg5odhjGcocp2FGcLGrfal4vjNT+N97vq4uZuwCOG+FSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708728; c=relaxed/simple;
	bh=NT06B1X/FUUW5+CqHRQJz4Mu4vdWZmihoXCWuyZQcj8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HROQhU5AoGRii3hjDavEUygOvI7LK53JI/a5tDVX2l9WD0tHgz++WEmo5ZW1e9XP6rihqsl53hjkeyeCQCunOGk6/7+s3qnceu+35OEdceztpPk5cKr+G00J5MdkWEoliMk1WEnAkwwAeh7y1/8x+BTE1vD1tAe2PbNnd6meVEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Xic5zdvG; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a1d8c0966fso78461f8f.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 05:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746708724; x=1747313524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KdVvIx+2NUw1S7/yaZTlAzKdxyvipEaCZdSyfI4dcfc=;
        b=Xic5zdvGHQhyWLtYvEb4aR6OZyoLgtBqlhBGT0ezvFbvd9qGo/fk7NVWJmCbs28YAw
         xqvi+16JclTRNxBR6o7GEqENaOlzGZNEEIF98m/rsglLkSzyW2UvkBjos8ZFyfSWgt+F
         1/VDQV8hak+Wf/HykomHlczyLeryH8fuCbQzIS7PpKQ+VAEWK4+JLVk8SbX/8dWqxEB/
         GwfaiTaQ4hItq88kRKD8QKu+hzPzXQgRTNb4ZuyCBFvcKFyTjqbHFzqqSJDtLY5fq1gA
         9wU0I1PCBqTKEZlhnrP7OldrPvVjVIprKfnjgPmChwX8qoWHRDrMYwSjKxZ6v8ndijWm
         6+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746708724; x=1747313524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KdVvIx+2NUw1S7/yaZTlAzKdxyvipEaCZdSyfI4dcfc=;
        b=wQfMp7TGBiu56/lMrcT391YG8h7ZgpiBqsvfBsxO+CiCvVUwrfQUQ8UiuQGUFIJ3Up
         B+AhPUdJY6NDin2/JLNPOrgho6We0a8lArXsZZpjIru2kmPjHLgycBcy1orTbkZBemzC
         TGwIRoUtSmFyuHNUlcmnAyTFv07uAaFGGLoq6viqYCm71Ycwolb+7BJrfkKUp3bJkry/
         9y36+sqbB8hi3n/YYiRXiQFLFLcL8uiAJpNmlu74d9EIraRhbq68N+YqyjkR+7jI/v6N
         kYhthm2O8z0awPybhhCtWkpZZk2qQVmJvnpaToThSgz+ABAmSuC9F9W5PIaRS+KXg2wS
         Rg0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUrTXlI/w3V6JbraZwSIugJ8u5nmGhiIu4KAipm97aUiP2WezKdS88Ul5Hi6tiSpK1fsGY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZNhGhvmb5lDIYd1BuJmPpZi134cEN+DSyR4vVGftycWUaxC01
	oWt3JLP91kNwsV6snT4S4MeQMTQ//jdovqvhBtsc4UJmW1U6hnAARtSXqm4Nwf0=
X-Gm-Gg: ASbGnctCeQXbxV0LyFOWCB9ng70HANbJaDU1+w6fGt0cF4dc4+hEe9oQoLODpWHCpy8
	3cH70TSOGyiruVcNFTBr+EvjFosbCpOyDz3RxgJcO66XWbBYJWXspHBRwUP/RuIUFh67kloh7SA
	+/ZjguM2ggnJcla2I/xv3oF7xI6DF46+tgNuHpEGTMzMTK2yTJ61QVvib3b9gyqDHkkyrtIyFh5
	rlGgx02jsT8DcTmVmAgGt/L805bhNPzZX1hM18G/EXFFlJOGrCItcMZifn+8l13zIHJEtbQQ1JM
	XTc69+2ZIY6lcU7LSKYTHLMKbjF0+rloZziocVgGVHNxJxOC4lY=
X-Google-Smtp-Source: AGHT+IGVKMnGQaI/zbUmSTKxGatnQCUnEpGyEkFy3V8+2H2zyIaYBb7YrCU27l4UnVxFxrTx/IplyA==
X-Received: by 2002:adf:f18f:0:b0:3a0:aeba:47d8 with SMTP id ffacd0b85a97d-3a0b994eb78mr2407869f8f.29.1746708724035;
        Thu, 08 May 2025 05:52:04 -0700 (PDT)
Received: from alex-rivos.lan ([2001:861:3382:ef90:e3eb:2939:f761:f7f1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0b6c9915csm4486425f8f.29.2025.05.08.05.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 05:52:03 -0700 (PDT)
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
Subject: [PATCH v3 0/3] Move duplicated instructions macros into asm/insn.h
Date: Thu,  8 May 2025 14:51:59 +0200
Message-Id: <20250508125202.108613-1-alexghiti@rivosinc.com>
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
v2: https://lore.kernel.org/linux-riscv/20250508082215.88658-1-alexghiti@rivosinc.com/

Changes in v3:
- Fix patch 2 which caused build failures (linux riscv bot), but the
  patchset is exactly the same as v2

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


