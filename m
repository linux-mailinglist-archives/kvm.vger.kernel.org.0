Return-Path: <kvm+bounces-25010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6EF95E480
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 19:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4BEC1F2101F
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 17:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E036155C88;
	Sun, 25 Aug 2024 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMmRIg9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F2B2119
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724605717; cv=none; b=CfdKfHfgY58CnGNSmX+2Qm3c1+jtOUK+j3oHEMqAQFZzK+XrQfuQ9QAzQU2As9/2qC+nIiZY5l8PG+SE69n+DOfFnslLgPzDodq2ohW7lNlbrkJncDeTNCbYq4pSaq1SSH3GIkwBUw3ROsXpOrz24/vd9eDZhPksK0EpIhSYXxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724605717; c=relaxed/simple;
	bh=hZIXnKIJCOfKE9gKpIhwiY4ZRv0mibH2oSmW2E7Jgw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JKIXPxVw+l4uEs3SH4BMHvpG4Z4nDS3B03o94ZIl377L0o/KeqiZIePT6fG/+qfe3Cr9G1Yfld/Y8JDLkwvXDytRrqoyLmkD3vu4z91LMp2CJZWFpHIyF91AeHpA180zdSeY4f3NMzP6UBGn+2glNxozeLptBGMQFI23Mh0o7Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XMmRIg9x; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2021c03c13aso25912405ad.1
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 10:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724605715; x=1725210515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dWCPCLLSts+HhR/bTFxF1IcNGPvTQBN/gTkk/5G+m9Q=;
        b=XMmRIg9x5bU2SSNWxeqIF8mjtJ6IaBhzdifkS3xtPNuzQFamkPVYmgsb6y/xuTNgqR
         p153sPqCGzduHeaygYRLlvCTQTcpc4W6VQjc5nau/OvNtD+s3OnQJOvnkA4ylbn3zaKB
         Q/1tsd5lmktOnqs8acZ1MsaCJPfyrcpALLYYciE5ETN3EoyxOag2dcVN4XrNhWVEQbt+
         1LvvuM1hFt2Rdxag0vkEdRAVzK2SgC9oG3c1hrDtu1Mr1azNcV0rz/tGCNJ2QyNXV+RZ
         jGHJ9qlQU9Y6U42Gcq2M1hVEvgsPc0ffFy1cKrfnCNni9YE2L9Ssl+5eqLOAWS0GTLuR
         LSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724605715; x=1725210515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dWCPCLLSts+HhR/bTFxF1IcNGPvTQBN/gTkk/5G+m9Q=;
        b=jlQJNgmKil2wim5He7r36iHi7wrkIJlnvfWPVn5yJwaV4ZWqWgDx+n8JQO0TuIQ6gv
         b+EaYPXzNYxDg+tF3uo9q9KWGNGn0EX06LgHRTJzA8lDTi3UXTdFUdR8uEA3jG9HbTO5
         TWj4qlz114VR+5akcx5sCvuqcxQElYrMZuRORjVLc1ZPxgJ21TFFNXwBtrV3gAxHN8DM
         CgMpV1rnssteBz0WY3FdN+JqQIgpsWjafqoSBLFXuHshjGbsP5hiYsRLfSJPFfGrJyz+
         92cljmyoy7FucdZa9VnE1ZML/DdNyi3bBd2BXPsOnlqIV1/yTELkXElWpVLJ8Iy2sKmQ
         Y8kA==
X-Gm-Message-State: AOJu0Yw+6Vk42kb9+zPkUvRnQ4rdLjebkF2WAYUMH4GXjz1vOQYWDiLI
	UH7bJz+ANDrKBzLUZmbmEpgxUy9M/Oi2/Z7gCFUucQ/v/uCP2U1fLA2XqYeG
X-Google-Smtp-Source: AGHT+IGJntGbDgxpQEq8TnYe5sA7tKgYAjo/sZLx/r9HefuHaDiRQ/GGa60ACwgSczL3kREYyLHxIg==
X-Received: by 2002:a17:902:d2c6:b0:202:3617:d52a with SMTP id d9443c01a7336-2039c324606mr178543175ad.6.1724605714405;
        Sun, 25 Aug 2024 10:08:34 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dd985sm56083165ad.164.2024.08.25.10.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 10:08:33 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 0/4] riscv: sbi: Add support to test HSM extension
Date: Mon, 26 Aug 2024 01:08:20 +0800
Message-ID: <20240825170824.107467-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing all 4 functions of the HSM
extension as defined in the RISC-V SBI specification. The first 3
patches add some helper routines to prepare for the HSM test, while the
last patch adds the actual test for the HSM extension.

James Raphael Tiovalen (4):
  lib/report: Add helper methods to clear multiple prefixes
  riscv: sbi: Add IPI extension support
  riscv: sbi: Add HSM extension functions
  riscv: sbi: Add tests for HSM extension

 riscv/Makefile      |   7 +-
 lib/riscv/asm/sbi.h |  23 +++
 lib/libcflat.h      |   2 +
 lib/report.c        |  13 ++
 lib/riscv/sbi.c     |  15 ++
 riscv/sbi-asm.S     |  79 +++++++++
 riscv/sbi.c         | 387 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 523 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-asm.S

--
2.43.0


