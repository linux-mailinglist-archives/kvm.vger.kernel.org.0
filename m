Return-Path: <kvm+bounces-48310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3868ACCA83
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDC0F1886B55
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3671023C50C;
	Tue,  3 Jun 2025 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="z73orzfE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D452D182D2
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748965634; cv=none; b=bSIQDayXcEzRIOA0YzboaQ8KYROTf0UNINtlMwUaSpzCEUX4UwJ72YV8dcGW7uabT+Ev5NJbLXiypVYHUVb2en/zhlwhgCp6tJ7F0OevVMboZH7Zhc+g+6XiRmxz2D/3HIle1/duNlAGwVA1/otz2NemCnAVjp+Wn+R4+SximG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748965634; c=relaxed/simple;
	bh=myimSa3Coa0VDYb9YC5nX0n55yCoRi0EO/GbsDCZBgE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ht75c4eeA9bNIXnAaMrv511GDOoDbqyo0+amQeY+PDL4bHXxw+CIyjszpvk09iME9AUjpxBeqf5ufzttRI9uBBZdSzp9V6OsTxdEkyml2plUz1Szpt/jV8P391QMd+oSO1Sv0YAnLbs2KIRNIj62bTN4M3nCKN0lwNuotp/9TVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=z73orzfE; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-747d59045a0so1942880b3a.1
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 08:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748965630; x=1749570430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uAZRYq1Ut1OdjviQhLtiG1Y1zJCF/nlXagPu6jbCZyo=;
        b=z73orzfEIqoUj6EsKgYWIBvKGURstx05NqPWBEg86dmCKV3n81+XzRkb1mzilH5hr/
         Ea7xN2WrAeX7vE/ypNMwjVo4F1/o/G/L4Gb9Qq5r3n6oxgIowsZPpRJ/YHsZU5+KAe5z
         VlZNVg4nLrl3w80llzd3jO+TXIEl2aLk7/kZIuouSOczqL45NN3Wr05WFurwFNpfGwTp
         zyvsZaNUDvdZ1LLaB6ZGE5MfIX+hUj2hdnCFHIQSadg+t5mJ3XdyjpXF2CG1rqaQeoLe
         5N9e0Ujjk2C9/zZqGgNahQsmbzKnKW7ZW11MN2ldeQAg7uSL6hmgfk95GNHrITN3AqZW
         HEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748965630; x=1749570430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uAZRYq1Ut1OdjviQhLtiG1Y1zJCF/nlXagPu6jbCZyo=;
        b=dADiA6prVOkSt87ZooVNv36St2U7Jx1O/+hiJeidXX6SL6poYI/dB84QS7/UaRT1UD
         FuGLH1tMQ0MaZSJkkDWTrqofbdugX0q1+1A1qc4xwMHPeIdVj3PDCIAYTGx4KC/ThVqz
         taV7/PvUKX56b/MFSfIAVJPLs3q20ifJje+BaGAhRqGRxSvCKm1h0Fj6Ggq8ht+IGrCQ
         3Z9Ro0jzmLVX/7uJdpFyShZ4cfyPr/zdeXLrcAl0YgdxVgcyRYRAODDyPRI8LfP1yjPz
         yUN3aZieoPC95mDUTIeXf0+8MVprcIZ/KFm5JucY0V7cUGHj8GBbZPkXi+qj3gD8kDCZ
         x9AQ==
X-Gm-Message-State: AOJu0YxrBXSgxEy5rRftoNEJ+DMqc5ArFVLtefyWaJ5Rb1L7VnoiazZR
	vMOhegXtnRkyNk4rknmdnDdzExNYRklvyvoQt8dDTIsVZyxOPUz+6kb/wyBZuY8zHiJ4FVKwWnj
	R5CQDetM=
X-Gm-Gg: ASbGncuHXc/t4qbK8V+12IVuIq8EwH5gghVbndyDncnXju3WODHDCfVjZHj3LVriGzH
	+Zgi/dn4vCFm1IDyFms4pClkEv2LrHaun0CTXyRK2V0IEs0JWjFh4Lglo8J9+EiAPygRhi/40Bj
	ceos/6iwAanE80/NMLwFsZz/6cSGXL1JN9OMmYY2sH1ptyueW3jR2yx+UXnrBIEWWBZ0ZwgoQx3
	NvPK/UTNQUJsR+H/ohiQpLB3PKvhjSE95TcA71HEcrK+RJVGIxQGtFD62q1WvrW23FrKMeNrtta
	WmZO00JZ8gNHr3M8H/aXjN3qnEcRfThRUarj2vbdQEzbW8djqUkI
X-Google-Smtp-Source: AGHT+IFk55Tqv0nEFS/cl9Itdt9glV+n1TFbN/ZApJ5R2VK626y+Nd86g4lTdFOyyqbshXN0CvfxsQ==
X-Received: by 2002:a05:6a20:3944:b0:1f5:8622:5ecb with SMTP id adf61e73a8af0-21ae00c7013mr32303197637.34.1748965630424;
        Tue, 03 Jun 2025 08:47:10 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2eceb9711asm6306066a12.57.2025.06.03.08.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 08:47:09 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [kvm-unit-tests v2 0/2] riscv: Add double trap testing
Date: Tue,  3 Jun 2025 17:46:48 +0200
Message-ID: <20250603154652.1712459-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a test that triggers double trap and verify that it's behavior
conforms to the spec. Also use SSE to verify that an SSE event is
correctly sent upon double trap.

In order to run this test, one can use the following command using an
upstream version of OpenSBI:

$ QEMU=qemu-system-riscv64 \
  FIRMWARE_OVERRIDE=<opensbi>/fw_dynamic.bin \
  ./riscv-run riscv/isa-dbltrp.flat

---

v2:
 - Use WRITE_ONCE/READ_ONCE for shared variables
 - Remove locking flag for last test
 - Fix a few typos
 - Skip crash test if env var DOUBLE_TRAP_TEST_CRASH isn't set
 - Skip crash test if SSE event unregistering failed
 - Remove SDT clearing patch
 - Fix wrong check using ret.value nstead of ret.error

Clément Léger (2):
  lib/riscv: export FWFT functions
  riscv: Add ISA double trap extension testing

 riscv/Makefile            |   1 +
 lib/riscv/asm/csr.h       |   1 +
 lib/riscv/asm/processor.h |  10 ++
 lib/riscv/asm/sbi.h       |   5 +
 lib/riscv/sbi.c           |  20 ++++
 riscv/isa-dbltrp.c        | 211 ++++++++++++++++++++++++++++++++++++++
 riscv/sbi-fwft.c          |  49 +++------
 riscv/unittests.cfg       |   4 +
 8 files changed, 266 insertions(+), 35 deletions(-)
 create mode 100644 riscv/isa-dbltrp.c

-- 
2.49.0


