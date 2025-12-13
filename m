Return-Path: <kvm+bounces-65927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D3E9FCBB0A9
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 16:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D9983071955
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 15:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B268E25FA10;
	Sat, 13 Dec 2025 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TwoyYj/z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709EB26299
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 15:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765638549; cv=none; b=ZHVCokSGMmmMS5VpoOLTmSUrX/UQRL+eY7lqp7xUWvSH7G/A1DchfWq58I6nhE7B7Y4Pt6jkCeQ7yrKvqrB7//MDkRCuEQ6tFepb5qqKfE2FsgtASMfGib7/DlhU4HzNmNPsUdhQTTzwjcfckoSxs7vZdPoBB3KrUGeSPmUJlOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765638549; c=relaxed/simple;
	bh=GgtuIYUjGPK79CbZIX7+aBVNz8LYZ6rzxrVq8TeJkAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B8Xs9TW2HiMBHz/0n815O43Rc//FeFv5epHTiNywBqMMO6UDHhMbiDiJBnT3G0YN48YWOa3KFeV06iRkJ6a2MvNknlEh26u8HeNLOPu0gFkCE2/NC5X9JByyxtQgSKOKAkvghUpf4hk5Z4eXKLzJATMc1sh8eMDWWDJm5Jv9t/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TwoyYj/z; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29f30233d8aso16368035ad.0
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 07:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765638547; x=1766243347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LpiaxQ88oSu49YC1S31RLxm6uhn7aR359oZeGdfAIAE=;
        b=TwoyYj/z+GRk965YGnei+0qd8tGJ5ZfbrV8dXgRci8iVE67TKxsshFb4AUiaCpnosQ
         l0qc99+TMWnd2O9nNUqA1ik1azRncq3nYqhGlKYwQ60ptBPLVoBUv3Y4cZCqj94J+vDY
         Rlm4XfMYIfuFHI0lJdtq53Sie1+WRg7GFHrkOKHOeafw2Y7lvvZ5MlyWpTZRDsHsmmSy
         wtT+1F9XeO7hDfwODMTIsqqf/HT+I/ROTwQGpFgVRsIwcIWNkwjUqlI9AMrUYkcuTbcT
         SKyjEbXTWuIvIgw7depGBqSATU4ledMtQJPH7MvyKzuMLE55NrpahCLsixEYoTaC4BTL
         KXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765638547; x=1766243347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpiaxQ88oSu49YC1S31RLxm6uhn7aR359oZeGdfAIAE=;
        b=Y3PsSHVQ/WOpRLNDigidiyuQ798lWP7maHQmgu+NY6OHbd/CvM/fp0OdIwIQmVWvFr
         QHjKSwQoxXAZiMAZBF6byFJ6opAnzsp+9XIiVXmhi4kjGgE+JC4k6ukJMaMjV0VKxWpy
         e5vsBNlMlAgaMCPONuXhRPBi35vZ7CiD+d6cLxQ+cLg9ff2Zd+4VPR72CMjio01JXbIk
         G4A05dZr10hrUIKGGnESz/BiURTrd+ntImJIwAlYAQ2S7F4mmN5Qn/dgb4/e1x3uyVaO
         Y8IgtxEFuHUevjPUdWQbUgy5kCeArICVQTChV0s4yKrgF5SAcNBWIWSM2y/xSAdM9ytw
         SzqA==
X-Gm-Message-State: AOJu0YxJf1xEh/MWbkUJa/5GTYTALbJDJ/+hpTBMo74mVrq8X7Nvgtp9
	0dWCnHcn7rSi8mg5YPCu3rnXBeouqAst2zNfUkYS9gKjBHFf2K++YbJjqBhGgVVFOxHR1Q==
X-Gm-Gg: AY/fxX7DTqE7txmdTGIi1dHaz40TS0KP00X5Ocw4hps9aVdtXZg/VekxGENqlIMT1qM
	g0xYZSFTl9XNedmhaykLUXczabJygAt2sEnUgZCs5emeZYd13aRhr4aFqTpwKKZ+9oz8lrJ3CRs
	56JPwuMIn/sNnGbQdvTBAFmVgVboc8ksyuk14mWT++mYW8SFmUoWzhR4pCwH7cAb27T/xewk0e6
	CYAAzm8dADhKGKuob2jDk2UVBb7Z5+HoW2BnqqlHJTiDdsQQ1XcBZP6TIVDTaOFaCz8F8RFLxyy
	ZQk9L7h+VtI0nkh3cy3jDo664Iu5zT1vcy65HlravVR+eqMEvEo8rWi57W+TGhDBv2i50r9HZPK
	997SUgOTZcGC/zEKYtGFV2lilLW1j2bXURVhpu3nL55+FxJu4HNi8zksHA+AwDxbCOlhA9Y+sHE
	v+Mjo6XqR/r+LhhbL3kLiSuiHtUb0=
X-Google-Smtp-Source: AGHT+IG0wSA/k6rR6FYauaioJj0C4bTfp7lKrMBL3Wv+JIXImMjZIDmkmFg1qZ34i3GgGlAAqw6vYw==
X-Received: by 2002:a17:902:db04:b0:2a0:a8c3:5f0c with SMTP id d9443c01a7336-2a0a8c35fc4mr10070005ad.16.1765638547217;
        Sat, 13 Dec 2025 07:09:07 -0800 (PST)
Received: from JRT-PC.. ([111.94.32.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016c6esm85494715ad.59.2025.12.13.07.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 07:09:06 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 0/4] riscv: sbi: Add support to test PMU extension
Date: Sat, 13 Dec 2025 23:08:44 +0800
Message-ID: <20251213150848.149729-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing most of the SBI PMU
extension functions. The functions related to shared memory
(FID #7 and #8) are not tested yet.

The first 3 patches add the required support for SBI PMU and some
helper functions, while the last patch adds the actual tests.

James Raphael Tiovalen (4):
  lib: riscv: Add SBI PMU CSRs and enums
  lib: riscv: Add SBI PMU support
  lib: riscv: Add SBI PMU helper functions
  riscv: sbi: Add tests for PMU extension

 riscv/Makefile      |   2 +
 lib/riscv/asm/csr.h |  31 +++
 lib/riscv/asm/pmu.h | 167 ++++++++++++++++
 lib/riscv/asm/sbi.h | 104 ++++++++++
 lib/riscv/pmu.c     | 169 ++++++++++++++++
 lib/riscv/sbi.c     |  73 +++++++
 riscv/sbi-tests.h   |   1 +
 riscv/sbi-pmu.c     | 461 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |   2 +
 9 files changed, 1010 insertions(+)
 create mode 100644 lib/riscv/asm/pmu.h
 create mode 100644 lib/riscv/pmu.c
 create mode 100644 riscv/sbi-pmu.c

--
2.43.0


