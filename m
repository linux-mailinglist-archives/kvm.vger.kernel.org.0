Return-Path: <kvm+bounces-41276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAD0A659F5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EFA87ABF33
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8F320299E;
	Mon, 17 Mar 2025 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ofsUQIZx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310411FECB6
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231305; cv=none; b=Y2dN5mElN8voOcxlim1UJGpX2KIzgne00pYyxAWin4StYlVsYiNBeW5NDjANJRWsHKsQMBCdCUxEG2nn8IcsINMc2V4gJFJte4y6rjiWkfXczmmVbzmeHDTRle3ugRJlR32x6zGRHQsYkAmZG81voxkPtNhmylf3Rr6m5XmBDqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231305; c=relaxed/simple;
	bh=Nf3XuDar9gitRVwziVjGXEjo/ltPNzme/nCKwMDO140=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZuGUQADIsr0FoJ4dEu8i600gezI0L7inQ95Sk1KotQGwN7xoYXR0kHlFAe+HMuxfZDpgr6MKlmLVgPtL5ufDU59dFylqej3yjqEvr+EAQKjljA1Xn8WHpAbOZq3aSHQueWGjeWiESSNfTj7YIpiUCpnl3q0ci+rQGvpI7bKlVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ofsUQIZx; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38f2f391864so2685454f8f.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231301; x=1742836101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pNqCCOYMsZxxXyyqHIS5snuORKLAQN1trvRZ+awEuI=;
        b=ofsUQIZxvs8LTJ56g982crtRu6dTuFCOkCYZVrQCWEM9tNwWGc1A6HRz94CH1V87MH
         B4CtaDJ5EA8iRA8aj+Qw3axJREL5n9xqwSCj4nwn01RplBuROB7Lz67ZX7QT6akWUHah
         gopoaQKzRnZugbRPKYYYXR9uq1Hc0tC6QABH79m51W+4O9+a8g0LjEB6zxWDTjNyB/Fj
         8BcvwfOE83wsZKwYkLJpajNNfRWPrcq2hcAp7fU9fDhGmQfXVMFfgX1MmzlbctXI6MSL
         8XvmcW/VO12HZtFd+jtyTPhMJXyqBxV95XQk0bhtTKu5XLpIdVZmbhetpI9hvCzkqvpJ
         qfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231301; x=1742836101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pNqCCOYMsZxxXyyqHIS5snuORKLAQN1trvRZ+awEuI=;
        b=K/GN4M49pbGaoPJLBtYcCW2UC5f9E31wNGZHbQjGluw1gpDCnkGg3GA2fnulZPTQSa
         n4nraNWehQBBJ5C3jPoZ39VjkVV0SJ0MSAtQXuj4VLCMORVa+8fdgWbGhbYQCh18mrkx
         ZnmRKRCCjo+viXxvJACZAcQmFfjeRatxjq89qtWL7ccG68qxp14xsDZ3gvRNpoj9jdcf
         tv+VlkXQd1u28aYTJax75BL7h4JPEH74//ZL9S/Hl86EoNxmSqh1dVTVIR5ilcTMJjE0
         bOGTV61IkUDXNmzggCT0TRAeOrBInhdIxtygk5wFv1xYKQYbPqMzHbT2L8uIW2ZeRmIT
         BgPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEzp5tR9e2bQMiXgGxq7NbHdoZ4P0nfuHTSaAE95iqKI26CY+zHYVL8l/OiVpjX4St2/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN3sTMCPPp783VZFSMWNQcieFwyYWcyODHNEqE6IGrIFX47oIZ
	AyiTjoU6RX/GW68ewm51pGvcUnzDcObx6/WQHjqP6zOb1hTcoxgosLhwD9B9n+Vy1RftfrMT1U6
	W+gw=
X-Gm-Gg: ASbGncvLlf042KoGKrYIhmqKju75YwkKOF/sqZfjLKjANlFC1Zg26cCJKJCpXju6/fl
	yfSsN636Fw9bdDMItAqfIo2Gis9vCYaRjPFvl66feqJW+fjDiz1JwXrsnyET67RTLaXtVKeqWHj
	cQ9/lr+YPFadoPBchv8MEBMvQZhxj7jUu/HL6WRkArdg4IkOBTGTJ4hVvxwsdzJj+SE2sQCJ/nb
	1wYwiniSKW3k4N5nYl14b8xhm8sUaHTNanNOvPIifBFXlz12x2NpXxflRnWfGwg1gMC3pTH0sBj
	SM6faS5s2B/jo8lXGqj+48et9wvuDeYtKmKOP3Ih+XGfpg==
X-Google-Smtp-Source: AGHT+IE6X4Zl2SvCnLBWCWxVkBGrawQ8DSM4qV1sZG6LsJ3FF5B07Zi+O2FlbpqV8a0E2j6PRS6VBQ==
X-Received: by 2002:adf:b183:0:b0:390:f88c:a6a2 with SMTP id ffacd0b85a97d-3971f12cd8emr13396928f8f.39.1742231301480;
        Mon, 17 Mar 2025 10:08:21 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:20 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 13/18] Documentation/sysctl: add riscv to unaligned-trap supported archs
Date: Mon, 17 Mar 2025 18:06:19 +0100
Message-ID: <20250317170625.1142870-14-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

riscv supports the "unaligned-trap" sysctl variable, add it to the list
of supported architectures.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index dd49a89a62d3..a38e91c4d92c 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1595,8 +1595,8 @@ unaligned-trap
 
 On architectures where unaligned accesses cause traps, and where this
 feature is supported (``CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW``; currently,
-``arc``, ``parisc`` and ``loongarch``), controls whether unaligned traps
-are caught and emulated (instead of failing).
+``arc``, ``parisc``, ``loongarch`` and ``riscv``), controls whether unaligned
+traps are caught and emulated (instead of failing).
 
 = ========================================================
 0 Do not emulate unaligned accesses.
-- 
2.47.2


