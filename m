Return-Path: <kvm+bounces-34609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 741B3A02C18
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC88B7A021B
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DDB1DEFE5;
	Mon,  6 Jan 2025 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="NOil2j/F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C861DED49
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178579; cv=none; b=Et8gUvRmhhfeflDX7f+SZo6SBq6pp6ddU5bGbHIEz1M9IpUxuN8HMFZP+VGb59H6+1lcEbAJXSQFR5ZLRUpu8lG4CcUo0e+4FrorABfTG5APzpTTUrberdQ+82KXp/iwCzoPq4lbkPgI0SMVA72M3BvNUGttbQAXGeSfcovafYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178579; c=relaxed/simple;
	bh=wAyylKrJoHKJ4K8tjIr0buB0/0rlmDZDbg+0t9SMuuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cq9buQBMcq3lEQcRJJkh+7VQqF2MVweuyW75KeFfXSNVJr/qk3eyCrn0QGMA9A/Km8J90RUJcFPQhUVBByc7k7nEJrTIO/1z0Dmp9P/4PDRJ+WLJsp8TGR8XjJ5/C82Tq/OW36O6NxacEHUhbDWUTzSjsW3o5/CplWnrQf/w3dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=NOil2j/F; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21661be2c2dso190890125ad.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178578; x=1736783378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcVyV1LOtw6V8Ho5gVIQl8YkyD+SXwNo0hQboe95Nr0=;
        b=NOil2j/Fci1ZcTQV4RxOl1D044MkVM3QJqH6+IrkAZW5CpjbvYZ5LD+Sz7hZlDyvjC
         g85LmBZppA0IZXSvXLFOGS9JA2kniL4rmmGrH0A/PIF72nEBIsgGJWBebqnwLrG9mniT
         tHBJ9uH28U39N0W8q7SUO3H46G4RfpvnHJehh3gNv7FWwHzHdkgQc9qRKRw0qJQJ6siZ
         PQ/EqGVZrSuNXNy2g3HdpCfSrqwNOo9G/sYAczHtXiNYDC2ee7QAVQVy8V6ZDBULqFgy
         NdwZ6qLI42KPQLwcOOCUA5YVPzwmS9jaOkp9i+uie787PtaztRVdUDZdKlgYH/SCsfbL
         FOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178578; x=1736783378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CcVyV1LOtw6V8Ho5gVIQl8YkyD+SXwNo0hQboe95Nr0=;
        b=j5u4LIwfKex9PZjBC0pLBY9Dk4HEeKEmL9v98tOvWgVzgeTf061QtkABbPfheeh+V9
         8/GEBj30QMojrRU7/XHg4avjEnPf1kDzrJN2J7ip024THVxVd7GfiVBXt1smgWQ6giEg
         EHvoJ/bMqNPRkGfNJQN6AR7MjbxsjKtzHPT7p/FdbP+/BL0h/0lsQr7oUg+a4QRAlGfr
         RmYx8aIIw95DnThOUGSb1SsA25CTVP2yQ6rDQKeUNtgge8Vrec7P3DZfG5pFSd3gSM7c
         3AIiA5oHpwsjLpkc9+Nr3ZyoC8Fxb8P3BzEP4SXW3uqBwlM0dPRmhtW5AkVNcGmbh78m
         hhgw==
X-Forwarded-Encrypted: i=1; AJvYcCW1nQEnf0V9lGmtpBwpDubR7PEcJLQLdehQcCKulgP+nCrZy5ojUeNopwWZviQTODUfg9c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpnpxT+SNCh2dadTR3ueS5aTnF93CnWEq6fA1u4UnSbMLR+dBm
	lL3GMmNdqaEcHs+EDM/TPJdgCPxI7WARbrSVtPFt/vhWw3IJChK1yuq+GZI6PE8=
X-Gm-Gg: ASbGncvOxUyI8/1WmcXuzMsucf/VmUoSFhLooU7uBtOEUrquRDqSMuMzBjguzh1x2y0
	ZXXbCo//mFZtesafv7EOpgIQpzoKlSXA7vPkGmQzyFo/ZoiMMF5exzeWZlA3F/rY4jItiItmhsv
	darQbO+TjNHdRCvOAYfTwvMYvmtg698ozLomYAtC9tYJtuDY9Z32EkawW4hxRhNd2DGgbIpJvL6
	xEyDdYImeUp2sCY9IaWhduOBWi9Hvy22ImyfghfZwYJCqpYKKNmFoGZ1Q==
X-Google-Smtp-Source: AGHT+IFsXBphfyy9s3JHMbepbPzIKCpal6gBIDcIfNIg+T9QhHs1bx0Q0ootfBFREr+mo3N4LGUQPA==
X-Received: by 2002:a17:902:fc8e:b0:215:522d:72d6 with SMTP id d9443c01a7336-219e6f0e605mr939915245ad.38.1736178577712;
        Mon, 06 Jan 2025 07:49:37 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6967sm292479535ad.214.2025.01.06.07.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:49:37 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH 5/6] riscv: export unaligned_ctl_available() as a GPL symbol
Date: Mon,  6 Jan 2025 16:48:42 +0100
Message-ID: <20250106154847.1100344-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106154847.1100344-1-cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This symbol will be used by the KVM SBI firmware feature extension
implementation. Since KVM can be built as a module, this needs to be
exported. Export it using EXPORT_SYMBOL_GPL().

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 4aca600527e9..7118d74673ee 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -684,6 +684,8 @@ bool unaligned_ctl_available(void)
 {
 	return unaligned_ctl;
 }
+EXPORT_SYMBOL_GPL(unaligned_ctl_available);
+
 #else
 bool check_unaligned_access_emulated_all_cpus(void)
 {
-- 
2.47.1


