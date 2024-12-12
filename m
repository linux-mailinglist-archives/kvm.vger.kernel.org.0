Return-Path: <kvm+bounces-33662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C97E9EFDB2
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:57:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F46A164C9A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13ED1B0F14;
	Thu, 12 Dec 2024 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="N3V2wTpN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316301ABECA
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 20:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037021; cv=none; b=LNXoNsYJwjAaY/hJnIQV46q8T8A/MwDgEv2Piguk5Qb7YIcH3v/BbZqq/2nVM6Fsr2HHc/YG8LrE3rK+3QKAxt4z8sZ1HeoNSG/jHQQTnX5id7M2cRxOZz9UxHXUoAapGGGCiyya1EdPWlsMgvf07VHJ0rZFhTQ5HPaH5N23Y38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037021; c=relaxed/simple;
	bh=OOwZCUb+iP3kBmv9zRpt0uMTiqTyzgTaYygvmgcQ7CU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gGRQd/7VLdDLMW8VzpFAdHcc7cpnbW94usZ5JH1ByHPTlDVtEnTm1eJ4F7WaEBHBtwaecfAoTfWXOx65MZzF8TV1c+lkIPIWAaCph0RlSs+x2wA01yrG0+05dhiukbXDuiM9uzbrmBSgFIsmJa4FryR2Ua3dMFR5jNORHSC1pA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=N3V2wTpN; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21649a7bcdcso10750615ad.1
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 12:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1734037018; x=1734641818; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tN0Np0I/Y4AvFV8aJjEc8kjQ4MihsgPm5ajnYSHONIQ=;
        b=N3V2wTpNs+XSHNF9t34zBhvFL5jHoyelGlhjxQ+aFxhlyPBQ8EDlooUdhNpDuMJIER
         VdOyyAnRzUiuwSLBLzEm8rkGwf4Lue/yJRAFrpM7KHY/j4sHmfxcnFTx6BuefphjY+jA
         NSfXAmRPCFZB0vZJHdqeewQnDHJn6UYZKbQKgbL2JABuDGjcRt50cJCKhKdS9rUqC9k7
         WLfCELhMrdvMUUhAylxcN5Z5z+TBcLQcWwZzrsfjGRZiMYpPQkezqW2cqW7yyQrd6Hoa
         3sW/YP/3eN8LAy5R+83NNGQQXVFw8k9RE9bZm+XDIyk/zaWoj4T3Aru2jgwRZPmugnQA
         DewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734037018; x=1734641818;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tN0Np0I/Y4AvFV8aJjEc8kjQ4MihsgPm5ajnYSHONIQ=;
        b=h9dffN5YATZqrLT9iS9wiPeFUPiNgXBYfXa7odcTTBbYlrFTNwcT/scePdgW8jbZi8
         S2p+4yp8Ayy08dDQbJCewyImNIAUEirLaUIIU7t1JTIEP5E9rREgM1gPo7drX+rxTUg1
         CXpcdPqm/lDpYuNtTPYxNo7sG585G7lj6H7lgMcmtJT/MjqeDQv6PCT8kRDfeNNuqqib
         /JULlrrQQlwBpDoGGhB2CVSTv5IiUePems3LUNk9sort0j4VfHUHkDe9jMSzIx3Z6bkB
         l2/vr39TGtoCdopSL+XKXcWonkKCKHnlSvetgYA0hNWs1pRVuHB8H7Bw2mvDJoKlS8kF
         GBPA==
X-Gm-Message-State: AOJu0YzQWM1c1jH1DuPlFxn1UeV38G3nfPnM1rwWgiV7+HWtnWsTLvic
	Z7lO1iWfoaIFh/3HgXtMgeI55ib3VOuaDAIBSdXa4CUpydq7SmxGToYSDdR5NqEHB7jV/e1aq3I
	z
X-Gm-Gg: ASbGncuO/xl3b6+W3dmmlCuIs8FNAWWYaxCGABN4umz/aRDdOvlCt3dRGvPxslD2Kcc
	G8kDArknbnYCprNOoP6vFlMBj22jRX69RJwb/oCaHLjXnmHrV5i35SttZE5KasRRamAabQQs3xL
	EMLUlqXh+R0dUk5DlF5z4nYHq89a62i2vZ6rC3hsZdyS52Wp8nK7KReDpP0nEu2UutoMmcxvcj+
	MBaDAbDj+yJke5+Zm7R5CZl5z1ASBrvQOLDB8mRfvNw78WGmVTD+UuUMzdGmxhhE5s57A==
X-Google-Smtp-Source: AGHT+IEXAiBGQzLsJG95dn4oVog9wDVG/U9w68CWre1GKqNIKH0u3bVdjPlSX71Hw1mqCrUyOUt07Q==
X-Received: by 2002:a17:903:22c7:b0:212:67a5:ab2d with SMTP id d9443c01a7336-21892a3fdf8mr2207705ad.44.1734037018404;
        Thu, 12 Dec 2024 12:56:58 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2162e53798asm94019785ad.60.2024.12.12.12.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 12:56:58 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH 0/3] Collect guest/host statistics during the redirected
 traps
Date: Thu, 12 Dec 2024 12:56:53 -0800
Message-Id: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABVOW2cC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxNDI0Mj3eyy3Pj00tTikvjiksQS3aRkEzNLMzPTJBNDAyWgpoKi1LTMCrC
 B0bG1tQDWHDJDYAAAAA==
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>, Quan Zhou <zhouquan@iscas.ac.cn>
X-Mailer: b4 0.15-dev-13183

As discussed in the patch[1], this series adds the host statistics for
traps that are redirected to the guest. Since there are 1-1 mapping for
firmware counters as well, this series enables those so that the guest
can collect information about these exits via perf if required.

I have included the patch[1] as well in this series as it has not been
applied and there will be likely conflicts while merging both.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Atish Patra (2):
      RISC-V: KVM: Update firmware counters for various events
      RISC-V: KVM: Add new exit statstics for redirected traps

Quan Zhou (1):
      RISC-V: KVM: Redirect instruction access fault trap to guest

 arch/riscv/include/asm/kvm_host.h |  5 +++++
 arch/riscv/kvm/vcpu.c             |  7 ++++++-
 arch/riscv/kvm/vcpu_exit.c        | 37 +++++++++++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 5 deletions(-)
---
base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
change-id: 20241212-kvm_guest_stat-bc469665b410
--
Regards,
Atish patra


