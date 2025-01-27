Return-Path: <kvm+bounces-36653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BC8A1D68C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:24:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60C363A19E6
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 13:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F308D1FF7B5;
	Mon, 27 Jan 2025 13:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SOLlKlED"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49951FE479
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984282; cv=none; b=jzbtOBr/uyAhKV+YmoTX+OiJm1xagj+uKDT4fJ9OY3J9qwMXIqMPRMRRujutLbQhh5zlUXRmNNdWfmpiB5RwhXM8dU7K6GhyncE4zuIkCdMitSlojPrQG10hMxhQB8TQEPlym9XhtoDnVnsLS4Zm1nIyZMNgZaD8tW2MEIWZq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984282; c=relaxed/simple;
	bh=UH6ViICNSOQCalyoSxcIWqlxjkmzLt3kuNze3yp7SgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZpmJvH9ZBdYknWj8odc9xHAKcMcBdgZ1WclvzfzHZpTQCQ2tPWDYR1/AaHGNcRrLX8eQr3InmabOdhZmKWyKCRmLG8N9JaipnSKyaYNzrJ8dJfT19R761lYTg1NPEHefLf2tmx2OY2ikTDD88HQDGwHtDnJTB58hFqxMdZlH4Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SOLlKlED; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ee8aa26415so7565490a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 05:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737984280; x=1738589080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eUXaN0scouSUrZkXTp4+p8k/tO1/dvAg4qHYedENdVI=;
        b=SOLlKlED6ho+9IHV5pBaoKqhA/UqckWo7CbosRXqEyCMfwSHlKI0NkW1q36O13fLfi
         59wl+b6ZSLu0jVtnaNUQf7NXq9PcSPbrHo119o0Fr57IDPSuWCKuuJOAb4//Ss9oO2xA
         MU9gBY82hzCHMC6YQurmU7BDJccdhiUprGu24wcuxm5i07+Bm2T0OJ0A7f7P4wBX7t1V
         CQpx7MiIcyB+fL/xAOZ/p7byJTVFfBKV+eU8BPi44QoPI0z40KE1jpzhsPG5SgCwamWE
         NNVmOySMeQO3gNkSHkD1Mv6BeRqbiXJNGchMqGKxl7mIeTUGAWrg17bWN3lpZ/k15WUo
         Za4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737984280; x=1738589080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eUXaN0scouSUrZkXTp4+p8k/tO1/dvAg4qHYedENdVI=;
        b=VXBw8SZpOsUz0rpaMKigPH0ZXD0esqk3pzzvbcWiKsfoheIp0QGz7HoB6ELue7MYNe
         KYKBxZruUIRKZjfWamETLFuRdo5/O0fTM3H9aEl5aW+BtGHDWxwzpSpXDWpSMHGyz6Tt
         kcyxTCiO6u6SoOhOZsxzM3ISqCGmvQRmk20F0wj7iZZeO+X4LLaSUh6iVfcp8zbCaGIi
         ZbGJ8IprQl1Qi/uI6b4CjwcHddpPrsmGc+WcCEf1RtIhw+V0Rmj8ggigiKkU9SeNH+bu
         3WcDIyP3vIfpCaL6VlNwkEu6QG4P6I/GFsYTV1SjTdUVePWacdoy9iy1MrqpLfum1MBh
         KJTA==
X-Forwarded-Encrypted: i=1; AJvYcCWvvRJqxqRs9uRMIdr5Zmg8a3Ertxo6w4wnD10XJuzZcYFMhJCRScKT0H6LgKk0rNzUncM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRJA1Pp93nPlqvWTY1giUU3behysBAsBhArBFpTs7Dmju8Utde
	kO48ym9DYhoIjl3iCrWpEj+IpfiRtAP6ZrBnwa/8jOhSz2SUWWFVacXU2aHI55w=
X-Gm-Gg: ASbGnctDEq+hLc+KmNxdZE2RoOdDkC6Vy8q9A82nmyV4Nu2eyy7H5U+2uZapnpsZKc1
	OsPRFAtHscZLdQND97H0sqvingC0AnXpUmcmRzMGm93/P/k7KNz5wCwb+HBXWd2AQZ828wjt9bs
	IeIHKzvHcOexHZKi1OR7HV5KYjdOJ4G/DEKZYLOFYJO5LuJiEsZDu2HqbrAnP7pNCrg5fhI0unu
	6C5NlIIAMQlZQ81vKpH00ndwLS/Ru2kxKKvfuBlBnxHgttcMWS2EubVhKR+HFN4aV4ZI16+Lld9
	q+NDR9IMlOu23V1n+qHNiK7YYAQ9SMYb/YpIPTeMRmnS
X-Google-Smtp-Source: AGHT+IFkZeqpNSFIDBBZPwRSd12WNh4znlJPrXn1Gu2GGxftAJrkQzrZSGZtNCDW0T2AdYIKAjST1w==
X-Received: by 2002:a05:6a00:3c8a:b0:729:49a:2da6 with SMTP id d2e1a72fcca58-72daf9a6d2dmr62760073b3a.3.1737984278427;
        Mon, 27 Jan 2025 05:24:38 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b324bsm7268930b3a.62.2025.01.27.05.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 05:24:37 -0800 (PST)
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
Subject: [kvmtool PATCH 0/6] Add RISC-V ISA extensions based on Linux-6.13
Date: Mon, 27 Jan 2025 18:54:18 +0530
Message-ID: <20250127132424.339957-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for new ISA extensions based on Linux-6.13
namely: Svade, Svadu, Smnpm, and Ssnpm.

These patches can also be found in the riscv_more_exts_round5_v1 branch
at: https://github.com/avpatel/kvmtool.git

Anup Patel (6):
  Sync-up headers with Linux-6.13 kernel
  Add __KERNEL_DIV_ROUND_UP() macro
  riscv: Add Svade extension support
  riscv: Add Svadu extension support
  riscv: Add Smnpm extension support
  riscv: Add Ssnpm extension support

 arm/aarch64/include/asm/kvm.h       |   6 ++
 include/linux/kernel.h              |   3 +
 include/linux/kvm.h                 |   8 ++
 include/linux/virtio_balloon.h      |  16 +++-
 include/linux/virtio_pci.h          | 131 ++++++++++++++++++++++++++++
 riscv/fdt.c                         |   4 +
 riscv/include/asm/kvm.h             |   4 +
 riscv/include/kvm/kvm-config-arch.h |  12 +++
 x86/include/asm/kvm.h               |   2 +
 9 files changed, 184 insertions(+), 2 deletions(-)

-- 
2.43.0


