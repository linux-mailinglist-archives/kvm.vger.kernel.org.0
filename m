Return-Path: <kvm+bounces-42020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A66FA710DB
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94FAA3B91E8
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BC3194C86;
	Wed, 26 Mar 2025 06:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ih5tFkQP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E218FDA5
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972218; cv=none; b=ovzsEjbbXDrH3MwAhQM1hepHW/yNz5g4Xagezgt4c0CNcypdaNjSYRxyqglNe0geeNel8F91CVRZcb3CVBmM+USzYxyhPT9BTPs92EfMMtrLweq75+/ouUbp2IlR9b3HEOw/cwDvOA4EoyNj17ykxDwAZK9TYzP/kuecGkt8NL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972218; c=relaxed/simple;
	bh=RFVCHytHkIoLi99e5O06L0bOi7UtE5FEHa+1FXwm5BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lBrlm5lpZ9UhzJrHkMTdxTyplizjCsQQdPVib+cdcale9qfuceZyGkw7zhPzjbup9rUdwZI46n6oRK76pjgm3EAJGoMZLN5QV8hnRYlgXxMoXykJtRKqPuWfPuMPHiQAAPfSzY6AZooODF3v3cc1pcpLCiCgv3xI8wG5adwfHKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ih5tFkQP; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-227d6b530d8so57219575ad.3
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972216; x=1743577016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sfmrNsfpk3u7jxX/pak7OLdb/sRu187l8xujoBmYZpc=;
        b=ih5tFkQPnomaOVsCwlW779RnIbGQkkqgZ10Sy44G/9zRL8lUQuzYtjk2W7V75HRD7C
         HfMOmhf737hZDEy1jLQt4DdiO73cvMFG16QlTFDHSLXLoklHOImHHPrwXkyzLT8atYc4
         eESz2QHe0P+yju+msQnfGoyoOj7ga17Tv12hEr7rA4eDyuJELskPvNHQwM87hJASvY1L
         0tPphW+idHHdro9Wzwoypnw7yljtrWPxqGGPrBGPdiX8BJeN+qZ6iacDTOD4G0XIWUle
         eC6x43sm6bQl5qB5vZhonvF/lh7fRBTL8WyKX0mXTj6P+h+yny+hTdj1s3ZhjPOaDJKw
         B9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972216; x=1743577016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sfmrNsfpk3u7jxX/pak7OLdb/sRu187l8xujoBmYZpc=;
        b=BLmHjmzU8KFIAdQ6EcIwMdVpQGHOyasFHGSHMQVHrCXcDqiHtXH/JfGNEZFlfnK5kO
         cg8mOenK4hMKRn8AQosVqzh7XtNvAsglBblNuaC/fekVoa26o5h7FcZs5Gd2S7asJ8S5
         zLq1Es3MS+YwrUjZVLJSr+eT1UbsQqE+ivI2MbHfBpgGAgQpah1Ao5dTxswcZL0YZoq0
         PpD+Gnw5mcEJHUdAWSMlfzya7ssz2NVRbs+zTojKgL/TKuQlhxsMwaiAqwnp6HpK9Mg0
         6DdULBOn/CAHunriMhWHrgjZy0B4eR9+Ijy/PBcgUa9HdJhvX9ZLouYkxCn38dG6WoWC
         5n6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWU4W8fWNUsEPJioHBxFRu9Mon6Woww8pQaqarjtSivFChibPX5rY24l+3J8G89TryYYr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLsnv2BwNEN78v1AylKBOx6uJ5ygChFT0ss+BAjP5VtaJmU6lk
	v3rgK9Ob+FOaAM5b0O4pRCrPMZp8IPpwXSoucggeSebEyw4v0Z6NG4Iwkubguys=
X-Gm-Gg: ASbGnctpenJRBQkQKwAsT4/UbE//SFJve+kZo7wl1U8ye5WwWCk1dzE+RC8u6bqIF9y
	9xIOV+IIWs2VG40XEGXTTiuj2LhNGkYfZT2ny8drNLb9fZBlOvK9U3tQe4Tcz9Ozq3lm0At8hsa
	f2Ik/UvZIrJV0frqf5rPxpkyQmz4BzcCXlXSu/xRNpFs1qYhfar66AsGfYzI0ok0FsRM9onDhAX
	iVRN2lEwVcEL8gmsYnpURHy+CnL9OtjBiSyXl/11ieRxSKAFMcgU/PQnapEC6XvaEx0aGuw8VZJ
	5GSBE0mMvx84LyEN+kYiI5Qqo8S6bZP//FuhPky1NcjOGrSIEtGZTj+5kYcUODH5McZChaZwCd2
	P+5zedQ==
X-Google-Smtp-Source: AGHT+IE2eMw8BQuhBGFL7WlqYAYwOfpD0RWRv+6XYnYowDEDGfdkOuVDdDkDSMWRKqNPPKOtXVF9Nw==
X-Received: by 2002:a05:6a00:a8b:b0:736:57cb:f2aa with SMTP id d2e1a72fcca58-7390599d5a7mr31035878b3a.13.1742972215853;
        Tue, 25 Mar 2025 23:56:55 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:56:55 -0700 (PDT)
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
Subject: [kvmtool PATCH 00/10] Add SBI system suspend and cpu-type option
Date: Wed, 26 Mar 2025 12:26:34 +0530
Message-ID: <20250326065644.73765-1-apatel@ventanamicro.com>
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

These patches can also be found in the riscv_more_exts_round6_v1 branch
at: https://github.com/avpatel/kvmtool.git

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

 arm/aarch64/include/asm/kvm.h       |   3 -
 include/linux/kvm.h                 |   8 +-
 include/linux/virtio_pci.h          |  14 ++
 riscv/aia.c                         |   2 +-
 riscv/fdt.c                         | 247 ++++++++++++++++++++--------
 riscv/include/asm/kvm.h             |   7 +-
 riscv/include/kvm/kvm-arch.h        |   2 +
 riscv/include/kvm/kvm-config-arch.h |  21 +++
 riscv/include/kvm/sbi.h             |   9 +
 riscv/kvm-cpu.c                     |  36 ++++
 riscv/kvm.c                         |   2 +
 x86/include/asm/kvm.h               |   1 +
 12 files changed, 268 insertions(+), 84 deletions(-)

-- 
2.43.0


