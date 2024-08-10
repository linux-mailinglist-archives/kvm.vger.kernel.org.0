Return-Path: <kvm+bounces-23810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E337994DDD9
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 19:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D8991C20C0D
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 17:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB59C16A95A;
	Sat, 10 Aug 2024 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dprpAVHz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D172F2A
	for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723312676; cv=none; b=hBRENKDQB58lLsWiqBR+qnCEqR9Q+8mHGyoBS+5MAe3L044h0cIanJHX+OfKXPil3ujm2tfeMgkDP397RMFMHDy05s1VQInODq2Y9o2AvGiW/zD7woSA7LlYSKenCV+L8FAadtbM9rjWAnKBrRECLSOAeSmhI6VJfuLLu37xIsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723312676; c=relaxed/simple;
	bh=/LeXakUf7jYFiu+YgyaNgCZpku0KK6p5sU408tSemnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g0NKKUYvM/zExqyM4yGcJ8D6TL5LDsDCa3XCbZVIkkbpBr8E1ufDO/aR5WjwZ5adE5YzTY2YW3PDellWcLTx9+TiUZ9CLYNkl3csCkDZa99EfAb6xOP+xlndN/rS+MzpR90UOJr3loKFJt9oXQCtPihLLqZl9FD8lQIk7Q8STCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dprpAVHz; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5d5b1e33fa8so1800582eaf.3
        for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723312674; x=1723917474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLVxumGBH2HYK6DD1Pe/gz0ElqjPI437EKuRr21CBGA=;
        b=dprpAVHzLFSYZC0IhhshdNEYkAPPwRbi/k5xC0TRSAW+BWb9aaay9NNKGtJTPU9SAm
         CycxLFclg1Yq0tDdwng010Wg0mDccmtj5zekdFZC13uRICjhieEuGB3kav1LmZASTOWO
         RTgiQ9mbMY1QDu6iJF8jKIyjzgu661ot3pExchmrAGkB4l77bd0ioFeKvnJ7QS18prZZ
         nJK0Srq1L+Ok1u7FoSknRRs1p1oqMtqgKsqSQ6GM0csB7PX9kse4KF7BweeZmGyZfja6
         CHESLDqGu7FR6jkOyQByUsWI76qZ1RGiByeex2eCx+xRno47YrQlG/nQJ3eDMfEZBvE+
         QKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723312674; x=1723917474;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLVxumGBH2HYK6DD1Pe/gz0ElqjPI437EKuRr21CBGA=;
        b=SPUIoy0qauY9Ni8O5MfIj+vt7UzKiDz6JMfPaE2ps4crwJSzlubjRBxpqZDYzEuXMp
         aT5tl32se+KJaU3zoZ04ReExhMBzH9He09k4GtzBocJU16Bf7BtPSv2jNfyXzLCNaUX/
         uffAyWCiZrm122CLBFD3ejFq6I5JK/Us1MApJU/fVdObr74QAzmWjwwEPQzSHYTvbX+T
         9f18vipf+ESX42A9hkH3C+2qWjz+Yea6BHto0bI6LJUWHv8WG5kTnhwYVc3WdW1CpZYU
         AbdRi5JIIXnJ127iGxoC7tD+/ZFcIWHkE6Q9cL+MUQmOzcCWU7Pf/pCI8DgNgEtFQc65
         2+Iw==
X-Gm-Message-State: AOJu0YwRKIdVpcwoTorOeJkO6QPfIKt0oBBVzCMu+Z+MDeffvkbhItun
	FoRhfZxfng/3DVeOT4lEsyXbPaXUtuDf01wJ/w70KWCKyfJJa5JnNBxt6GododY=
X-Google-Smtp-Source: AGHT+IFP9VXmTxgPKnCAePmbSnGqFuZNSOl41cw5EyVDSBQTSCcbw53cbnRv4cXFu2s5RoO3tG7+pw==
X-Received: by 2002:a05:6358:618e:b0:1af:15b5:7caa with SMTP id e5c5f4694b2df-1b1771643d5mr749892855d.21.1723312674074;
        Sat, 10 Aug 2024 10:57:54 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8fd807sm14107795ad.80.2024.08.10.10.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 10:57:53 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 0/3] riscv: sbi: Add support to test HSM extension
Date: Sun, 11 Aug 2024 01:57:41 +0800
Message-ID: <20240810175744.166503-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing all 4 functions of the HSM
extension as defined in the RISC-V SBI specification. The first 2
patches add some helper routines to prepare for the HSM test, while the
last patch adds the actual test for the HSM extension.

James Raphael Tiovalen (3):
  riscv: sbi: Add IPI extension support
  riscv: sbi: Add HSM extension functions
  riscv: sbi: Add tests for HSM extension

 riscv/Makefile      |   7 +-
 lib/riscv/asm/sbi.h |  23 ++++
 lib/riscv/sbi.c     |  15 +++
 riscv/sbi-asm.S     |  38 ++++++
 riscv/sbi.c         | 285 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 365 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-asm.S

--
2.43.0


