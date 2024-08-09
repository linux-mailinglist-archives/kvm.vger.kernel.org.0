Return-Path: <kvm+bounces-23691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B5494D156
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12303283C00
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 13:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F6A1953AB;
	Fri,  9 Aug 2024 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jlPgC/W+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBE0194C75
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723210489; cv=none; b=dilWyaSPXRM6imMcChzQw0svqOumMnjgd7wcxdy+Nc7isgtX5IfPRzYwgx2E7qEEDuQJxadmkpE0D5GMxnaj8+klRrjJTVTWLnRhGJnNQ42aU5Pj7Fmnqtw/Fgzy54ALT7JUMIWcc1gC/3043gsC8CporuwnvB3+E3Om7zgZbVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723210489; c=relaxed/simple;
	bh=szjuCoB6Ao+oirQWsHSLj+0zpmxlKcYViWWAq1BoTHc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pcU0tl91WdMZvwWBkjuAPI9KN3vteRm7ZPl6mUQ4EJBGaKYtkl8wzUdW0c1JXG3c66pBdpl1f2KuausJs0W6OSrAfBaKYbbozgrcnXlOdTir3pYQGGiMx7PS7sheZjyJQFVl5vcFdh5ByihNRfK0bqRBwOTdnmxP9JC6XCWF/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jlPgC/W+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fd66cddd4dso20765495ad.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 06:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1723210488; x=1723815288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m3GCJPKK+Qr1DFwXjnal/knFf/Uo58D3YmzoLVsBSv4=;
        b=jlPgC/W+RpkonTgdntLd+IICu0sUSNXrl/4k9y8lqCysJ1wsKQagKgeauc0OoIzlA7
         SqchvAXw8j3mFDkepmga9Oj3RAR+6FaTwv9rE9HCeaY2kIfuc520LYwaewD8r5+Vs7SR
         BfIB41fAS0dfkez4ipRO1YzCUnrp8Psn9mzT9uNXtI99duKPAlovn+qBdSO+L6w2hRFu
         o+4xhlcureePJrfeY7mvArcIvmGWkdMuvGcqFOSJkwxMYk79N7DJSGjZBBEjFzci5uRv
         /2FsbEpoxaJmBRzUOF/q+WXnSRssz8isvIAdVtg0T5hG59rTmsCLAlb4JYZhk49DMSBe
         PsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723210488; x=1723815288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3GCJPKK+Qr1DFwXjnal/knFf/Uo58D3YmzoLVsBSv4=;
        b=GuWRkAg0gVGV1IHMEkIu/ty0tE4hVaCQ6S9gbgBmdZpMJAjMTbzsRW0+mOmfftk8GW
         bMQt6H5FNQQiW0L3gKhhPjqVuffjBVSSc5Mhc4UvcICMjWuLiUzB/2HWKzQsu3yuZO8y
         +T+ji7fB43EvoXIVqRJax+YMBgHDB75LfU5516mOw/QsHaFi8arzBnus+zovRmsfQG1+
         ROJFHl+lSSi8y6JMfMkgAFzcT7cVfEMrJWe4ntcatQIexjKxkDV6UQVh12myJiS0+Tlk
         wLEn9zbADAtmQXFXS9sfq18Z/QnI/gJL+evcIbt2wN2etjpGTjDRQlO5lFkq7+X0r+Gm
         sGWg==
X-Forwarded-Encrypted: i=1; AJvYcCXN1LEBRl4AmxJxr4Suvu8NrAacXUfjgxbyligZGT9ZS0WLZ/aJ/Vvzo6zk0j74fhc0MoiV8VCykbjhUz+biA1Qqf8o
X-Gm-Message-State: AOJu0YyJLIAM4JNRZGjebE7mdO2vjOaszBmLJGWMNGI/cqONH6WYGdCD
	QKcDbC6Py9x91hZmZ814aUq+iXpGL6mN3p6g6vRVhWQ0yCSGvuk0iScs6CfSN6U=
X-Google-Smtp-Source: AGHT+IGjtdqIFdePxRZgC3nUP9DHkS4TBJzg6Z+Xbo57EP2J7V4U6niKFTB/nDhZHaKNla/bDjIltA==
X-Received: by 2002:a17:902:ce8f:b0:1fb:7c7f:6447 with SMTP id d9443c01a7336-200ae5455afmr17364875ad.25.1723210487318;
        Fri, 09 Aug 2024 06:34:47 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f26f4bsm142107075ad.34.2024.08.09.06.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 06:34:46 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 0/3] Add RISC-V ISA extensions based on Linux-6.10
Date: Fri,  9 Aug 2024 19:04:28 +0530
Message-Id: <20240809133431.2465029-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for new ISA extensions based on Linux-6.10 namely:
Sscofpmf.

These patches can also be found in the riscv_more_exts_round3_v2 branch
at: https://github.com/avpatel/kvmtool.git

Changes since v1:
 - Included a fix for DBCN

Andrew Jones (1):
  riscv: Set SBI_SUCCESS on successful DBCN call

Anup Patel (1):
  Sync-up headers with Linux-6.10 kernel

Atish Patra (1):
  riscv: Add Sscofpmf extensiona support

 include/linux/kvm.h                 |   4 +-
 include/linux/virtio_net.h          | 143 ++++++++++++++++++++++++++++
 riscv/fdt.c                         |   1 +
 riscv/include/asm/kvm.h             |   1 +
 riscv/include/kvm/kvm-config-arch.h |   3 +
 riscv/kvm-cpu.c                     |   1 +
 x86/include/asm/kvm.h               |  22 ++++-
 7 files changed, 171 insertions(+), 4 deletions(-)

-- 
2.34.1


