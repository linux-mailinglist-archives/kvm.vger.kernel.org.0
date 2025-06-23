Return-Path: <kvm+bounces-50342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F70AE41CC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CE033AC6CE
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E30024EAB1;
	Mon, 23 Jun 2025 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="x5+M7WuG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB2E233D8E
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684308; cv=none; b=ZW9ghf11Pp57jtNTbk+zz56qb44T9YA8rX0aBWCtmyFJi7ga/Xw1inn/GPKvnhYO8+UEy6kh8p/fdAjKRJYc7i78xCHDnW1O1/XMmlqyckgyi1HOT5kqJTapZgwy2RSxcIykjIXa6NWCu7S4GKnSEpAao3alMQm6GG3nZrDfFbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684308; c=relaxed/simple;
	bh=U98w3KfGziYYC2qVR5vvulHodDxjYIA28gkK5vxVVvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e4OQvy66rwkM5fxZ1eQ83mEPWptF3omZJCw69iZOhRNJVF4LTV7nzbTahNih64jj4KITXdd6BCmddzyfkyaOERip+XkE2Na5rLvRKhJdJ7yBqTLXP5TdSwMeDAsn7OVkIOQpJylgb+HkmYqwVXMA3Smr2aKjaFXdGlsgQVyu1XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=x5+M7WuG; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2353a2bc210so35052795ad.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750684306; x=1751289106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V2Gakwz5CFCLNwFITFXbkWwDIUGq5jqZEA16EMP/fpY=;
        b=x5+M7WuG+QVsW/Kiqbi7lHNBPvfQKAlpMYpoIZXZEqSjqPjLvvmDI9vwAn4xZIQV3j
         hOnlIhRzzwTWwZacOumfAdVScWOSDtke//NcvqbrmZrT8yo4Ud8E4aANkdw8KJTNb+d9
         SAaD89sWi04l5AV4HpI6EA5JMBD0B7Mq06227j1GUHMFyXeMHk71eSf+E6EBbfcCzlPQ
         WVT6Ko4BhTAmlEXDaLRQ0cM6nz4rH8ogUzugbSAuXvTWAwSjRMqwphpPg2sbA+2iPT7/
         XsTGeNeSKu1cBmtt81QwmAt7zs7BKJg8nfawbH4Mzpo3D2ErXK0Icyd/dni7HBLiet0H
         l6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750684306; x=1751289106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V2Gakwz5CFCLNwFITFXbkWwDIUGq5jqZEA16EMP/fpY=;
        b=EPeAMLMlijdMXPVkaS5nOWlLcCRq7ZbU0RX656+w0bp96DTrT18/48XqUz6/Y2r/SY
         9Ufka5AwFrUPFDRSUG/gY/VKbI1LciSx3bPAD8tXkEAG84ciadinuAqhIBpzmMB37SjA
         1KbkDGhULS5vBXL+DwQn+TgdAhnwAa6AJ7rMVzDCMySSThhm0TOYbXDQRy5t9SgYTMlY
         j1ytSktafwlunQdTeb4uzopwX3yXjVZoiykV1EzEaip749QSsLH1+ooyKLEw9ynM7o2e
         XtmnrhLoCUMCH5hzL5J4C7N9vBzGAf/FxFT7mkqlPaLnGG8Ja7a1Y8NkJa4ZshISKdNv
         Y/Mw==
X-Gm-Message-State: AOJu0YxDh2d5viSEbsFFSvpMq9CgFmMYQg2ihOovl332wwYVCxd+G37F
	I+1Di6qzHM4T4qFyGM099TRz/fO7j78MA3r5agWfv0M7K2E1L3PhNJ8og+XogwtXNe7UBhCVAm9
	6NeM3Hz8=
X-Gm-Gg: ASbGncsMVTknk9HK3wO2BXKV0lJRxYFK0fwpoTZg6e2nhbosNFxHKwRqJLXcHu+/AO9
	H3k7vIcCxU/H4zSV9KM7E6wdgQIKpfbCokfNrpDZfUCZctl5AjUESaxAAaXaCLimvVW8Ehf4P1x
	C50QLPllI9qua/nCUP37guQYp8VYhjXTtzh35dgRaIlCzQ//Jx7qWtgfS+TXn5+fn7OGQjxWg50
	2e54QIjkiTZZRRLmoPgLcOYAsibAABqzETrZDN+J/yurfDG3/HtDVtTHT9AvQNw5ci2kOfsGhub
	e+cFTWH30znzn7EUQFsy0JY3ltrH6QbwpLGyEfhKf+Ob4f/uXoT+s/vf8q0fIq8tfMQX0FWg04U
	yFw==
X-Google-Smtp-Source: AGHT+IHifC/+PjsI1B5WmpXuq47QUumhunagfoijQE93mDmfc0naQ+JWhbzZsBvWPaNEXXfgZDBV6Q==
X-Received: by 2002:a17:903:b88:b0:234:c2e7:a0e4 with SMTP id d9443c01a7336-237d9779f3dmr156241565ad.3.1750684305746;
        Mon, 23 Jun 2025 06:11:45 -0700 (PDT)
Received: from carbon-x1.home ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8673d1asm84314385ad.172.2025.06.23.06.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 06:11:45 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [kvm-unit-tests PATCH 0/3] riscv: sbi: sse: Fix some potential crashes
Date: Mon, 23 Jun 2025 15:11:22 +0200
Message-ID: <20250623131127.531783-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While validating another SBI, we encountered a few crashes and errors in
the SSE tests. Fix SSE stack freeing as well as handler call checking.
Also add READ_ONCE()/WRITE_ONCE() for some shared variable.

Clément Léger (3):
  riscv: sbi: sse: Fix wrong sse stack initialization
  riscv: sbi: sse: Add missing index for handler call check
  riscv: sbi: sse: Use READ_ONCE()/WRITE_ONCE() for shared variables

 riscv/sbi-sse.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
2.50.0


