Return-Path: <kvm+bounces-47527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4324AC1DF4
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC2CEA25EB3
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 07:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB91C283FE8;
	Fri, 23 May 2025 07:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lzNjg/eh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA2517A30F
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 07:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747986900; cv=none; b=QNW8kerR3P2Q2QDMpROzZCdRprWww7fnMAp0aStNqGwIALCqGaelZ3N4QX6lxB7mh03oxBrKr0EjMnI0B2Xy9oZ/t4BVS0Krs4xomvXv4jtqVf0Nq6BiClD5MTOk5RpZPgn5IRIpkvssXyWbuYybOsQupjBQBMk/hCS3F1MgWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747986900; c=relaxed/simple;
	bh=h+58KxNbLgnFbzMKkwHrPOrO35Dxf152eJACsQZx8FA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dvyug0rxYGo2l3dEFSx+PaD3jfbSRY3q4s4217g1OLArYi3DivNCPujhfTu0WFylXvFa9Nlr38Rg9EvsR3ZgGFZkrVJe8hsXC/8P7DKMoOrbQjccf7f3u0DwbvXH2a6HiOFIIgbahVJTHEJ2fWWLITpD6GtHLUXO2DAjwKSSQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lzNjg/eh; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30e8feb1886so7348307a91.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747986897; x=1748591697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YdKIs/OPWingmzjqwsRAF+gbP4NwJYTmT7Tn9PtuJtk=;
        b=lzNjg/ehL/QdqvTCFM6TPGtRUzizTzzUlwvdfErmbuXfje5+ppjVuzg1Q6GSSon4b1
         baEfds1kPctc7nyYkhH59iwEtm1BXMmjeqtx6uZCC0WkwPr43I1udd5cBEzc2fyCrq19
         dQCdzLQZdm2gZb+8fmMwqznr8KlZWyjRg1nY2Uz9DIBd/64UnBDa5xVWoC0KL4g8wcGf
         Ua9yDU383ECVneD+FZ2lzNeG8kC/W5XDhcm41U/bejVkldSBtFryU0ZuDEMkQixTm/Uy
         Ylq4TSJnNZTy3yjcB2V001JVDmevFz9od7W+Jo1c4SbbYZHb9r9enJvw6mk98CooFJJT
         Ydyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747986897; x=1748591697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YdKIs/OPWingmzjqwsRAF+gbP4NwJYTmT7Tn9PtuJtk=;
        b=H4IcTgS0untoNgYU1EL+x/ubtGnEC16PO9i2EIN3sbcRFMjwgfznZXh5vW6iE/1RGu
         49YE89GPCIo0tXCC+IkRR/4SQmBOVMZUj8QviZaGfYr5Ub4w5ruEA7W+upalIBr6J0pi
         WxaMG6ssHVQl77YDzxnHRFBRAqz43sb/aj7TUC+PwzMBRRov3O6kAW5BEXWyHuX1hWry
         ZKwokQ+ipby0DXxNgahVlgwG2j/aweLRwWwD3KLq9oRE8ELczPjS0ocV21Ls4+1e+YJ0
         KBAsIXqAvRjWnlkbLOJKtARMmlnVWYhG+28L+EYxgegXCjhFrvO6TbBpivgxbnP34QQm
         vMKg==
X-Gm-Message-State: AOJu0YxcN+kSyyXKW6f/AQly9SfqKD36n4Ra5NEXLgYUyD7ULMdPT8tA
	OiGIIZJoTy1j7u6nncmosVbYWlhN/jS8cBL9Oh8ddzFGNSEvEGJIzrMjltP3eDUs1wBnzNv5y7c
	eGlPGZ9M=
X-Gm-Gg: ASbGncv42FcWLRKi0ETeg8Ln4a/5S9HGf5r2c0dsIxnYm0NqNveu5JEhCCL1xxzBTeR
	2HgsKon/2QkrDBexxwQ7p+MjNeetEShTTCIO4gyfkgINofI0D6rhKkDasF0NusCTfLrgwd0R9TY
	Sz/JOl/Jbw5a7M5ba1DowQw3funqdUuw3ctbOwU8kxVCSPYYRQssr6MSm9e8GkWyI202wbkVPM9
	xUdznQ0mD/s5Fv1mnRsQgklMDDcN1yKMxaE1pJnQN1dxZHAERP/zBuD1I8MCTsGXwZUMDA9TEaW
	Nw+tjC9rXcz5wuvwHY8mgv2mZF2RToLMFcChZH/WrOC2fgGHZmWFA267Hb+AbaQ=
X-Google-Smtp-Source: AGHT+IGiy+ea0mbWmBO14R6NBy/k6e1sev9uX2CBS8vsXn8mhFotQ0Eap6uVkvQg93itJl3+Yi805A==
X-Received: by 2002:a17:90b:58e7:b0:310:d980:7a84 with SMTP id 98e67ed59e1d1-310e96e74dfmr3309172a91.19.1747986897230;
        Fri, 23 May 2025 00:54:57 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f36513bb7sm6767204a91.46.2025.05.23.00.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 00:54:56 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [PATCH 0/3] riscv: Add double trap testing
Date: Fri, 23 May 2025 09:53:07 +0200
Message-ID: <20250523075341.1355755-1-cleger@rivosinc.com>
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

$ qemu-system-riscv64 \
	-M virt \
	-cpu max \
	-nographic -serial mon:stdio \
	-bios <opensbi>/fw_dynamic.bin \
	-kernel riscv/isa-dbltrp.flat

Clément Léger (3):
  lib/riscv: export FWFT functions
  lib/riscv: clear SDT when entering exception handling
  riscv: Add ISA double trap extension testing

 riscv/Makefile      |   1 +
 lib/riscv/asm/csr.h |   1 +
 lib/riscv/asm/sbi.h |   5 ++
 lib/riscv/sbi.c     |  20 +++++
 riscv/cstart.S      |   9 ++-
 riscv/isa-dbltrp.c  | 189 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi-fwft.c    |  49 ++++--------
 riscv/unittests.cfg |   5 ++
 8 files changed, 240 insertions(+), 39 deletions(-)
 create mode 100644 riscv/isa-dbltrp.c

-- 
2.49.0


