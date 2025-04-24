Return-Path: <kvm+bounces-44185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C73A9B25A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 788335A2813
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE031A8412;
	Thu, 24 Apr 2025 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YGzlc+m2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ACD198A1A
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508730; cv=none; b=Ps0SfZzJxWZXPGQ/NPjwbVhbAqYp2enr43OyBw6/7yuGVairgIjfbvcMNn7b2lMetE1qO7p/DCS/Gocd1NcqUhydPA6DaW7UVEH7ju+3z9tQfg2lKP77m09XdqMMBvbK7pmX4bNd3oAgC0hQuxQrDSCkxH++Ms8Ic3HU6ogu9L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508730; c=relaxed/simple;
	bh=psfT3YDLzNDBzHssPLeu6J7wqhhEUGMfm4D5rhBg5Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MhJCZBnpIwB6xJ3IEyjgRBAl90trfbNHZ7+FxdCxROiKUSqQJnUdegeAAZmH0PNo6G6ozXkxA5LgOpJU3fGrYVOrDYut9XWVBEnwbEXBKYOEepjspWTdvw7VVP88KofiRVcLNitkobp6odYeQCGCLwQTRmREeX2rZQnSN4cr8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=YGzlc+m2; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-736c3e7b390so1213112b3a.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508728; x=1746113528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0oClxd3Eqcg8INMrYeT0VTSG7eSwzuIOPz2EiOMFj4Q=;
        b=YGzlc+m2VtpmLqk12V44faQJOOcui4XS8UfXKKw2FoEm+ysIi9JcIa8DXyv1BFf+I0
         UnqTOQ0I7zGe8ZINHwtry+k/xAe1oLzz7s94H0+qF0Dlfjal+vsdfLMmP1Eq9x0tuabg
         LQb194k+Q00rJcZ1PCqCUpNHNsWm4dHzQEaEaaxbEz6X+5Abv9vv4XJlrsHDC89gdxKn
         1UwNePvIdR4YsAQwa7kVGZMxMGaje64Dpd25+CQqA0kkTWFcyAANQto0ZyRMrs9X9bK7
         gikxgIAukFamZD75ofRkrbnz2wvfJ2h/Vm47KGcF+jA4ohq9qM0IGeMK5oOOkP7Vkm6Z
         6SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508728; x=1746113528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0oClxd3Eqcg8INMrYeT0VTSG7eSwzuIOPz2EiOMFj4Q=;
        b=khwrI7tpJLEv0au+x9GkBxUxaiKLs/W8T2Dw5/n3wEqc9gZ/RyvNoG5dXxFIofozs2
         fRzfk3lvveOZaKn+DZ+gOXkYsaH+iRT81GweMFbCfjkzdUqpOcojr5yh3Q22VA2JJ+nT
         Bogi1iE37nxmm0PPZnm7FwG8TdDeZmfcInt2L2satFp74DGFrAN4wo7HOM1gxey9d2GC
         qfIORtXEEA4x/fZINQFjD4QqyHLzyd+6nZU7GnoMEsoQNrl3bANIQmgjEDzny+uL/B7B
         +qYo6fgVd4f5xRvCsHuJU7SiXuBAWOZORkP/AdJv6OCoEMY4WZwDL9UzR9QCUSBuklgp
         LbrA==
X-Forwarded-Encrypted: i=1; AJvYcCXXIxrH0ZlkS6hmCRAXUSCWJcUVxh9vdv+qEZXJMJNA9YmhMOt1GXIWf5wzPzABqfVC6Bc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWo5D+kLflqEhy6ifCD07MKWkCH49xojPQAM1zthYGck+VMybv
	v7vk35Eix7r3eYuhN65cuaEeWfXwk3F9a3DfMnTbJz6HyEg4t3xX8yz0dpMl6wU=
X-Gm-Gg: ASbGncsvO/FJyz4CwtE3eXp5gqIvDNPR9pfmN3v05l8QszXpg10T3Zp1N9qxLOxDu6S
	I6qYqv60Tm3lYzaFcI2Fzzlyt6g85EdrGqw+Tu9/9DL/2kQ99ctK4njjkcKK1PE0m4CjlU4TqXC
	GG2bAo8iZsIYufCaDJDZT0Ul5Z59ASczECk9Y3D+744BsFluFa8U358XKEjMNsrVxojygLmlOQn
	ZHA6oPHNi+3z1g7VeHb5oOgbmoRbI3vGqPoXeYr9h0H4Ki4tpYaeA10nQ4nZfceGuHR2iqVjQBB
	ccfsM00Esd9uI9L0Gsb7pSZVziLA57CiKq13kCEVj2bkM5MEC0iQy0e6PanL6qB4raorM0yodMz
	k4Arw
X-Google-Smtp-Source: AGHT+IGn2lMxrkFCENEf07ZZ1qMSmFt5r0YXLBuVTZeTQRd8e6liRvutCssLcoZZasc3BOr9s7qAbA==
X-Received: by 2002:a05:6a20:9189:b0:1ee:8435:6b69 with SMTP id adf61e73a8af0-20444e7ac6dmr3777420637.1.1745508728437;
        Thu, 24 Apr 2025 08:32:08 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:07 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 00/10] Add SBI system suspend and cpu-type option
Date: Thu, 24 Apr 2025 21:01:49 +0530
Message-ID: <20250424153159.289441-1-apatel@ventanamicro.com>
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

These patches can also be found in the riscv_more_exts_round6_v2 branch
at: https://github.com/avpatel/kvmtool.git

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
 riscv/fdt.c                         | 241 +++++++++++++++++++---------
 riscv/include/asm/kvm.h             |   7 +-
 riscv/include/kvm/kvm-arch.h        |   2 +
 riscv/include/kvm/kvm-config-arch.h |  26 +++
 riscv/include/kvm/sbi.h             |   9 ++
 riscv/kvm-cpu.c                     |  36 +++++
 x86/include/asm/kvm.h               |   1 +
 11 files changed, 266 insertions(+), 83 deletions(-)

-- 
2.43.0


