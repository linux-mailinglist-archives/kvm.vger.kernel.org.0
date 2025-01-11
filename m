Return-Path: <kvm+bounces-35170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B32A7A09FA6
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:47:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DFE1188F2C7
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56033184E;
	Sat, 11 Jan 2025 00:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="CLcKmrAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B6634
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556427; cv=none; b=StgZ45ubxhIni66vlG1S76mRbFQtTlLAplV/LZjTmnv+9GQoUDYJgOOc8PabY3HTjsfU04A1BS7GNP/gYcbz4MepbpMWplT2YPRsGq6K3XDsuCJwG990GDoOhqauOel8/NDvUIzEpnnNgvZif0VSVKvVX+xHR3QCx6jtn4ZUC68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556427; c=relaxed/simple;
	bh=4nGJhcOEM/lwZrie9kVshVDRzRWUhzXLizV2DiEWhSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cODOXfMPIs3f5EPkk+uPssS2ffpgzYKT69pwRi9obXsT6qMU8kz+25xeKlIXcAPOqxwnNAIOo8pJw5AyD/nKgSFa42WEClaqsknQgtZXrImH8eC1yvSJpEyLChw2L7YmGfj0jKxpncTRddIaJRN+6uTUCe1mdUuCIk6YcIbp6oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=CLcKmrAg; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2f42992f608so3744663a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736556424; x=1737161224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4h+oYTtB9STcgJt5s9KFyAqha4KcHVl9vU+KomymzjA=;
        b=CLcKmrAgShxdAL7R93Lgs7/SHWlwgmA9V1VIEa1DiADpYVS3oDiAGvrqd+wgC2GWCT
         S5HFHxcLA4XOnqt39a3CMt7b9Jg92OOuNmYc9PXx2ebL4oyJInCBFa3ZvKvCmlxa3Jxg
         9KXwb/TfsH1J73Y0pxfz2BG58NlXQDTVn6IzfnDy+XSRjpWATyvj1qHRIn4Vh6AeBSfw
         gqnkGDcb673LSy/XNoVoxmKJS9LaEbEvhQWAN1TYM2CXMpBkcqI2elBt23QTlViSlfsA
         LzbIGwFKfGMxJbcTFjCz95oxDGgZTF9JojpF7/NVd/FeFHw4lbS2MdTiR/UWQj08DUq1
         IqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556424; x=1737161224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4h+oYTtB9STcgJt5s9KFyAqha4KcHVl9vU+KomymzjA=;
        b=JZgxmDq/3z2F8RG9UMxUJDC0P2iy1XEIqY6PKfB31HbMZjRdPxqHuEAmhgOdDnTlhG
         WhlI65XW6hWEtUuHffIVFhYTPW1dCe/J0j4rllkWOkNUqbTtRfm+PqjCa9YmHjwF9BcK
         VYE0o4hdVpeZXJs/RCcJStZO6UqbOaLsrIs5aW6PSKotNMuHgD8hlFMHces+Lspy8Dmy
         hXgkmWRICEKkHByCguXCn3zN76qOek5x7hF0Ae06EQ05kghgdWqR4Ed/pBuAQomrSeRA
         pkg6OOcY+Fi3vTVJOFHMmXqAwo+XAgNZDiNlTYHxF20NFo15RT3d4pQzX70Jvet+41qT
         sDUg==
X-Forwarded-Encrypted: i=1; AJvYcCV51LNvdtNQAxnMXDVuBuRUv0XCgwU1tV/aqT2KpBLunrO+XoPJS09YeCgk6xf+XKc0aVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuGIcvWlHs6lHViMQ7zb7rMy2nTqt1SIpUNoGBSs0cVVtvu91l
	UKlEAE8/Kj6OgVanrwR5POJqqY4lJzmyMukhil44GbOgC7tV8S3Krm7yxR4S5dj4Ko9zOv8vePO
	u
X-Gm-Gg: ASbGncugottmmEm+4bO+VEhRDeqnSLyDrvj7/gRpgbT1egfyG6/4a0psjOmjZ+AAwUb
	xUorVRVPj/UpIRcCugGbTOs60hydZ8Q4b+5o5gzOQAlspmQLlBHVBrTYjmlsl5pU/Pueke6NWt4
	NKQwv4r0YkLA24zx5gjeb4MCpbj2FyLv/SwscNNVEQK02iHEU8HonD3F07RXcFI8Hq1RZl7dHQM
	DaT0DP3Y66xvuzBxsqAiMk0NdnzI+/v/Yo3Kf186spSqqQHO9JovGPOVUoIoOZxVgk6ZVs6eDhs
	Mx8=
X-Google-Smtp-Source: AGHT+IHAZr0xNEPgPAWybCIes9Jl2csw7eIRzGzKkykORR+Jkm5P3UKWnrgjOIPEypC2vNZx8PlCXA==
X-Received: by 2002:a17:90b:2588:b0:2ee:c9b6:c26a with SMTP id 98e67ed59e1d1-2f548eae05amr18861868a91.11.1736556424149;
        Fri, 10 Jan 2025 16:47:04 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a28723esm6064295a91.19.2025.01.10.16.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 16:47:03 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] RISC-V: KVM: Pointer Masking Support
Date: Fri, 10 Jan 2025 16:46:57 -0800
Message-ID: <20250111004702.2813013-1-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds support for pointer masking in VS-mode inside KVM
guests using the SBI FWFT extension. This series applies on top of
Clément's "riscv: add SBI FWFT misaligned exception delegation support"
series[1], which adds the necessary infrastructure.

[1]: https://lore.kernel.org/linux-riscv/20250106154847.1100344-1-cleger@rivosinc.com/


Samuel Holland (2):
  RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
  RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN

 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +
 arch/riscv/kvm/vcpu_onereg.c               | 84 ++++++++++++++--------
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 70 +++++++++++++++++-
 3 files changed, 124 insertions(+), 32 deletions(-)

-- 
2.47.0


