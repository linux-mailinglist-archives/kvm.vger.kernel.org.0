Return-Path: <kvm+bounces-39400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 313C0A46C56
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5F96188CF86
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C8E1256C80;
	Wed, 26 Feb 2025 20:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="aN6dn1Pj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E972755E0
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 20:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601513; cv=none; b=BM4vs9LfC3rFwPHW+5Ye4u9YPgiR7fmC0dnRT5iNDNngeC5vSaWKeBevxHUZRin2RjR7KWvGxbfjQdWRUX9r89XHm6vr/SvRB1F64DGZmZ57rYSMrrMZUdp9us+FpiOWzJLIwTFwXQRUmf1AfflZMteLI/Z+6/UtGr23nQjAN0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601513; c=relaxed/simple;
	bh=yOcQZkrZis4oPMTtV8S4se5F1ZKwXkbDx7myJ+Yf7Ck=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jcm4YtSHtRcp24CGUJsp6P5ZkBj004OF6r4dBuGBkihNuAj2sgfY9ijbV67xt/WLMeA+VPtqxD9qjExNKxxJ/CpwiIcs9SxP9rpxBylU+sYJIGymoJEGBXfRjcj7LZPRE8Eus4KKpP2TST32mdBK463ReyeN82OzQ2vsHC2FsH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=aN6dn1Pj; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2232aead377so3753145ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 12:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1740601510; x=1741206310; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vJfRhZEo2RIsfouA3ZbiUgm3ilY6Xa6tZ9F+JSMVv7o=;
        b=aN6dn1PjypZ0jQ5nNomEVa5i5fmA/Svbi1mljVduCK/K2AP1n7Qk8J9JItBWeG2LoU
         3agWvhMMtKi8UPVsu9BSR+JeUEMWGHCGJonTxk7Ex+K90Pbf3DxFf7wCq1HWPh7I0zBI
         r9EwTrdM4dqLppglovkSn/R0Zbal9xzRjWXG2yD23oaZqbG/FZrux1ncTS/b1qNH8yab
         fbE8gE4hd6e/DndzjyTb6B8kpe18HgO2NgtjwATenbs69IrxwMl1zmo3e5DFC5QtXTkr
         2fFiVOhkAruagWzjbRo0i8e4eLfkg9/2WUpL8va0oq1mc5UZ6KtwqLw0ItbHca6zaoHp
         js6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740601510; x=1741206310;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vJfRhZEo2RIsfouA3ZbiUgm3ilY6Xa6tZ9F+JSMVv7o=;
        b=exNpNV+z2pZiUY/lO2HVd7xn/3piXTQ7RB2Ef/aPnElAyjuOalytEmnwZbudq04wzG
         RNxNcZDZCYtmE7qCGd4Tzcp4T/KE1Mm+NplkdC0aqeKo5y99ypjKw8Ccn4jVMiqke4RY
         oAsv/4a9RSNdydz9vXhpusNh9nL65kd5ryJkSpopm+a7vnP2UdU/1Dz/ccoHlsV8Pjsl
         z2vCl3+yMpA/vZUDnz37rZ7825MGml+Ah0t4Um/whWxgDP4k8wTg2t3UJDx6ipyO60RV
         NGo3QARXgcxOjHTkKgyu0CRI0Qz3p14yGx6pHbV+r0tCSZPnTRxg2Vo+Xy+adCAXGpAK
         QPuQ==
X-Gm-Message-State: AOJu0Yxbn14Rzc3YgLctrFPsq9wNlKP/tJYVddI7sLM0O598wqzrZfzS
	7j8/u9Z+MEohVwrI/uHSFg/bBt/tpIbmjr01dE4GOuTMH2yrDu4dC0ihXHSWEto=
X-Gm-Gg: ASbGncuknWr4TKq72k+Ot9iCR+FZ0nnjE2rRT9D1eEw2PgbKVu8Ge6rPILn3ckQTV9d
	KwclesIA/VJv8BpfVhGQHhgyAyGBoBP/dMa78JKw5MFziAC+EjkbfoJfqQM/M+vSmEM6sVTuhv3
	y1f93LqyaWTrYgjF3MiWeK2sR3fqzthGCbAPqSrWJc9Q72QEhmnW3/OSN/g9OOhuVpw1upuEYZf
	2DOtnm6cxpWEnjxCrauQbBfzTaySrl+trapme4ET4/m3WB6UOUZe7/1/f7OKm2euOOQJ8nx8XOb
	6KsAT03LPXE9UaMkQU2lrB0wpZcNrlOsM4/TAFQ=
X-Google-Smtp-Source: AGHT+IGBMBO+u+81QuNJ5bB+1erdTCTpC0irRH+rlBfJ+nJ9B7BPIr1HT+61UNH4TSBhiFyqAE9NUw==
X-Received: by 2002:a17:902:ccc1:b0:223:2aab:4626 with SMTP id d9443c01a7336-2232aab496bmr63446705ad.11.1740601510471;
        Wed, 26 Feb 2025 12:25:10 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a7f7de2sm4100963b3a.106.2025.02.26.12.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:25:10 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH 0/4] RISC-V KVM PMU fix and selftest improvement
Date: Wed, 26 Feb 2025 12:25:02 -0800
Message-Id: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ54v2cC/x3MQQqAIBBA0avErBNsSoiuEhGVYw2hiZIE4d2Tl
 m/x/wuRAlOEoXohUOLIlyto6gq2Y3E7CdbFgBKVRFTiTHb29p7Z+nAlEsYYLdt+xU52UCofyPD
 zH8cp5w8fth87YQAAAA==
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

This series adds a fix for KVM PMU code and improves the pmu selftest
by allowing generating precise number of interrupts. It also provided
another additional option to the overflow test that allows user to
generate custom number of LCOFI interrupts.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Atish Patra (4):
      RISC-V: KVM: Disable the kernel perf counter during configure
      KVM: riscv: selftests: Do not start the counter in the overflow handler
      KVM: riscv: selftests: Change command line option
      KVM: riscv: selftests: Allow number of interrupts to be configurable

 arch/riscv/kvm/vcpu_pmu.c                        |  1 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 81 ++++++++++++++++--------
 2 files changed, 57 insertions(+), 25 deletions(-)
---
base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
change-id: 20250225-kvm_pmu_improve-fffd038b2404
--
Regards,
Atish patra


