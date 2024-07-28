Return-Path: <kvm+bounces-22464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1544293E8A8
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 18:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96F102816F0
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 16:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DAF5E091;
	Sun, 28 Jul 2024 16:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0kxpKLn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D577A35
	for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722185433; cv=none; b=r4PRtN169TPEaN2FkwfW/zD96uCynjaIZEIuMddo2X9Lr1TC7Cnmrx6Wrpi30CHGazkWWP4rLT3zxu9Q049KhXRWiWuMSrlX9ZSAanFT1Pi5HwtSvOmPLvVzJCQe/+/e3GCN81reSKpauOEhfJGpGfXws/d4aEdOSZEb5H+wqtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722185433; c=relaxed/simple;
	bh=TKgrOufOLCyUtSwhicXLYU9FldU36d1rxvHMCDZe3a0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OWqvryNq4mP8AHbQuchSHJB6pMY0ZQ8jsgtVXASX1NVOM0qVfeGbXLaer2HSifLZjy92LD3EHeeMECDWmas5yp+Wg6xydTuB6D6Zmor48EJLnFjwnk9L6kJWeWuqr/V/aojmABn/QX2lLQKTrQveNeUCQQq05ul/LJnh8POFA5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h0kxpKLn; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7928d2abe0aso1701588a12.0
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 09:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722185430; x=1722790230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7lWILylB+d29+SZkAzOSHZGqzgRyRrgM8ClITfKM3Tk=;
        b=h0kxpKLnPsKttI9ExFw0+fV3j9BHzRI8anJDkZcnPtacxFQCKSP42SVju9AatvIX4N
         OwEW1nbF2g9+V3tEngFpjFbCeK02WPkVX0m3fvIOzi771uaSQPJbibXugDReMukzJgIX
         6J5NEVTJla62cERa8Ooa05ggpJDkCYWnh4DPdtSnqNrWfsZrl/vwCYRbHHWeazkRcFNP
         fqYE+AN+qJGKOeUw0zpcevsJKwX6oIEKEtO1WEWx3O1XrMesmnAnPSPo9M/Gjxa0OQ7+
         RWohvyuEiaUo3akm++97onspLS+0ChGYeQNmyULhuNe707SOLXGdRoWOj8iSNq5SfLMH
         FncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722185430; x=1722790230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7lWILylB+d29+SZkAzOSHZGqzgRyRrgM8ClITfKM3Tk=;
        b=SMCMP4SRcEz/Wu6fr9vWen7cZQz4P89iKXXQDjc8Ku4TepiVBFn0f6zH1CZu/FMblU
         +ZbjzLdrp+dPHSQTzWyAeKYXQ7vT7MVJ366hkUok8b0hwiZfv3PdFtCfpQvLpQTSGV3c
         9D5a0JPmC2fShvJ4jJyfDrbItHG96ysL5504O5sdBG0ys9gS2mUwnPfTtdaX8rk9Yq1d
         MoO4qNr8pr46VCp1UG3hqU6I+IttOW5BPgduWmCEM5QhoZL5Iu/JHFrB6HQKv0ZowGT6
         L91emgaVH3541Y6eqfNKGWDTDSvpIKNPDKLg4OpK9kL54ddOD+yUE+sdydt99pSoPEcL
         u7eA==
X-Gm-Message-State: AOJu0Yz4bquP5gqdr7Wm0PqVK4xzQaF0OXp14d4vnUxjjD/CTyHAEp8Z
	StJ102Vi14SAPyMGfZNic9vPuOtxFBKOEbwpSuX7vPN72CDZkzVDD4PbV80FwlA=
X-Google-Smtp-Source: AGHT+IF5LrM64BYWaUtbv+fvygiXWM8/aynLNkQ4S89GBOXKhKkMT97fLa3IXqcij8PU9f1Me3aNUg==
X-Received: by 2002:a17:90a:bb84:b0:2cb:5fe6:8a1d with SMTP id 98e67ed59e1d1-2cf7ceafd79mr9187851a91.9.1722185429433;
        Sun, 28 Jul 2024 09:50:29 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c7b0besm6969413a91.14.2024.07.28.09.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 09:50:28 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 0/5] riscv: sbi: Add support to test timer extension
Date: Mon, 29 Jul 2024 00:50:17 +0800
Message-ID: <20240728165022.30075-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing the timer extension as
defined in the RISC-V SBI specification. The first 2 patches add
infrastructural support for handling interrupts, the next 2 patches add
some helper routines that can be used by SBI extension tests, while the
last patch adds the actual test for the timer extension.

v5:
- Addressed all of Andrew's comments on v4.
- Updated the test to check if `sip.STIP` is cleared for both cases of
  setting the timer to -1 and masking the timer irq as per the spec.
- Updated the test to check if `sie.STIE` is writable for the mask irq
  test.

v4:
- Addressed all of Andrew's comments on v3.

v3:
- Addressed all of Andrew's comments on v2.
- Added 2 new patches to add sbi_probe and the delay and timer routines.

v2:
- Addressed all of the previous comments from Andrew.
- Updated the test to get the timer frequency value from the device tree
  and allow the test parameters to be specified in microseconds instead of
  cycles.

Andrew Jones (1):
  riscv: Extend exception handling support for interrupts

James Raphael Tiovalen (4):
  riscv: Update exception cause list
  riscv: Add method to probe for SBI extensions
  riscv: Add some delay and timer routines
  riscv: sbi: Add test for timer extension

 riscv/Makefile            |   2 +
 lib/riscv/asm/csr.h       |  21 ++++++
 lib/riscv/asm/delay.h     |  16 +++++
 lib/riscv/asm/processor.h |  15 +++-
 lib/riscv/asm/sbi.h       |   6 ++
 lib/riscv/asm/setup.h     |   1 +
 lib/riscv/asm/timer.h     |  24 +++++++
 lib/riscv/delay.c         |  21 ++++++
 lib/riscv/processor.c     |  27 +++++--
 lib/riscv/sbi.c           |  13 ++++
 lib/riscv/setup.c         |   4 ++
 lib/riscv/timer.c         |  28 ++++++++
 riscv/sbi.c               | 144 ++++++++++++++++++++++++++++++++++++++
 13 files changed, 317 insertions(+), 5 deletions(-)
 create mode 100644 lib/riscv/asm/delay.h
 create mode 100644 lib/riscv/asm/timer.h
 create mode 100644 lib/riscv/delay.c
 create mode 100644 lib/riscv/timer.c

--
2.43.0


