Return-Path: <kvm+bounces-44400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 085D9A9DA47
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57F3E9A2835
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D7E227581;
	Sat, 26 Apr 2025 11:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kcr9p85l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF031E519
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665441; cv=none; b=iT9pG70jRj9pS8aTUSWzMMQjuHslfimQXQIplEtL+jnPUcW4tkeo0d+n48HUcTeY2TA53NTPIqOUTiaaZpYznd4khygsr11csEFPbXFsOwkLXLIUwSXRqBW0jIMHwxKProUwrjKOgRmTv7PVzklB8/nP6gUkgLA7hXPOJ2BmPKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665441; c=relaxed/simple;
	bh=MP20YkRdz4/gRZSWSY6ziOC/FFouRzOP6RyrgDpBcAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LikY0xQW+svDzkDCTw2egWkMwdBHKnkbmu0A/pg/R70OZrZ9ZEzJ6PnI1Dl5C0ds9NQy2H1reMwdd66RksilzWiuZFTlgpyAsZmF36iw+1DZjqAxoXV0WwPeSj1RXvL2EyklhMJhOJ/+2YHkWI33awetxJ11R5+hnBkgBIKgTHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kcr9p85l; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-22423adf751so34432425ad.2
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665439; x=1746270239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mcoBwM8KJxhwkXcnebD3xKE1klc/hF03i5YT3vBn/hY=;
        b=kcr9p85ltXdDYhUtRFTrC76kMakA6SELaGLqU0dAi7EyFozkbTuMCAobtgHnGj6sfc
         cac5iQ1zPJnHAvKh/O1LsWzP+R5IG52wt9ZaYoIy8o5YBlB68fJr0Gu8nCyjv87/tkk8
         yk20okf6RUyWMZ/C6q45S6MGg63mf7e9aoZBXknGDdZJLXLQtnMJ8YWVedPlLK7+9Qsq
         vEsZTManXt5XRVBV9MRGwJ6qxRUQuvmWI6if+YUPbf3vwgGXZZu6QylnDzTOesn8b8HO
         KDKICCwwo/ydMS+LVagTlRvlWFIE1L3JDfUgeRykR/1XKqNmAfPp1p+FN15m7Z6hESwn
         BVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665439; x=1746270239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mcoBwM8KJxhwkXcnebD3xKE1klc/hF03i5YT3vBn/hY=;
        b=MfRanduojXtkTv4+SoCak4rv2R6Emhr7B/IUB8zuwKlWIeHHIkiLl+kLwRpiFrGaem
         jvRJC8Ci53IVzpcqGX8WaYVSjxFNpm1+Fk2IvPLqGNyjZ4tkn80eM/8XGIs3oXYJmHyd
         H6sjz8tIf2RUyg3MXuOgvjh5OO632MbDjH47YRJyl82LjnDMuLHR96Tf3LeLlR+FwT0h
         7Yzf1QstFJ5UAAUMEdM1jx1QWUgs1W6Ihw+c0IfToIOQlbOimz+11A9QC2dW8vG+YDfQ
         bjX8au6/BfUgwQqSO4MLja66/awxKW1EtFWKOS7ZjOR0a8NlrYOU0Iz7wo2QPfNEaQ2a
         8l6g==
X-Forwarded-Encrypted: i=1; AJvYcCVr3M1lPu2M6dvEMRi34AfTmHxTNqO2vSRwRtf6E7Ld2SdEOn48g3/dO/uxszNTrjd1LU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGP2xqAbF+KWAwx1ED1DroJjz1wzCSYYovGIVjBadWD12rGSsv
	GxFTeleIhDbuyouKqAXLNrbZFnu5hFTWCvSW02bEnXeWe3dGDRChCYrywTJ+vY8=
X-Gm-Gg: ASbGncvN6Kdmx8yAyPs2fVT15DSkwRBRkQS4k4nbYtCBsj7ntkOhsrD0cwxtpyNPUto
	jI4mPcE6OE80P25hSICEfEDpzZFyW0x7WO0GtKszDhDfaf3jiYeKnPwTjzAC9wWx9zM8143lNat
	GPu9isPsSprQMWhueXs0pPIsCm82odGy+Nxq8BlYNY5ZalFCoDxIv1OZSxMbBURRDALdasmoHVu
	4cEUPJEs7UT1bXTasFU4D99czZfHsFpOgSBR+oUFkBFP2Tyr5FxvUeKg22b6a8gcckOBnmfvd5C
	ttOowWubH3MzyUmWusG9W6SObi1sBtZ+sfL2Zw3s0yYCYLaLOer6ET8IIt6ikPvcVUlnm/ldTym
	rrn4i
X-Google-Smtp-Source: AGHT+IFXsiCw6Q4lQhwQgknZZbJY5BlIlkPcP5A9MUp0n1Tdm8Xe74w70rAnDcwYIU5gkiN5GSXDkw==
X-Received: by 2002:a17:902:ec8e:b0:224:1c41:a4c0 with SMTP id d9443c01a7336-22dbf5d9ecbmr73907875ad.9.1745665438966;
        Sat, 26 Apr 2025 04:03:58 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:03:58 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 00/10] Add SBI system suspend and cpu-type option
Date: Sat, 26 Apr 2025 16:33:37 +0530
Message-ID: <20250426110348.338114-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series does the following improvements:
1) Add Svvptc, Zabha, and Ziccrse extension support (PATCH2 to PATCH3)
2) Add SBI system suspend support (PATCH5 to PATCH6)
3) Add "--cpu-type" command-line option supporting "min" and "max"
   CPU types where "max" is the default (PATCH8 to PATCH10)

These patches can also be found in the riscv_more_exts_round6_v3 branch
at: https://github.com/avpatel/kvmtool.git

Changes since v2:
 - Addressed comments on PATCH10

Changes since v1:
 - Rebased on latest KVMTOOL commit d410d9a16f91458ae2b912cc088015396f22dfad
 - Addressed comments on PATCH8, PATCH9, and PATCH10

Andrew Jones (3):
  riscv: Add SBI system suspend support
  riscv: Make system suspend time configurable
  riscv: Fix no params with nodefault segfault

Anup Patel (7):
  Sync-up headers with Linux-6.14 kernel
  riscv: Add Svvptc extension support
  riscv: Add Zabha extension support
  riscv: Add Ziccrse extension support
  riscv: Include single-letter extensions in isa_info_arr[]
  riscv: Add cpu-type command-line option
  riscv: Allow including extensions in the min CPU type using
    command-line

 arm64/include/asm/kvm.h             |   3 -
 include/linux/kvm.h                 |   8 +-
 include/linux/virtio_pci.h          |  14 ++
 riscv/aia.c                         |   2 +-
 riscv/fdt.c                         | 240 +++++++++++++++++++---------
 riscv/include/asm/kvm.h             |   7 +-
 riscv/include/kvm/kvm-arch.h        |   2 +
 riscv/include/kvm/kvm-config-arch.h |  26 +++
 riscv/include/kvm/sbi.h             |   9 ++
 riscv/kvm-cpu.c                     |  36 +++++
 x86/include/asm/kvm.h               |   1 +
 11 files changed, 265 insertions(+), 83 deletions(-)

-- 
2.43.0


