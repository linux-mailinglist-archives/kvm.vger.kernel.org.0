Return-Path: <kvm+bounces-39937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0873A4CEC9
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 23:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 911BF7A80DE
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319B223ED66;
	Mon,  3 Mar 2025 22:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="eC5Ah8SC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEFA238D28
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 22:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042394; cv=none; b=KqjwwXIz6sOzi4LHDblz9DGEpuD69UxznLVK4DXhhhBYwsPy3p8yAiZ1osPaBqva2KLR5ClnVE9lXOltWOm9lmeejmWQYenTNkY0wuBpkCTVYB0Jb64Ohkaz5gelLwWu3QA5d8Cuv63YxSdx6Q/qYDURHOPn2QXgT/X98tJr8p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042394; c=relaxed/simple;
	bh=/5XukNlXJKyGVREeQdU7wG2r6Y2lbVhDem2XgJQlNlw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=c05njnHkj2qEmMWtwfx6LfkcONE0llAzpTM5X7jKmJuI2Dl7Umys8aIHJ09kj8+BcEBEVCikux6jxees/P6zMR+6XYO+V7Z7Q1Rte7iqZUlplkL2yqEJ2tjM/vWx+rKUvHvQGVoy6JkfdZTzK861OVWb3571IBADU+SjEpmphCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=eC5Ah8SC; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22374f56453so82802885ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 14:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741042392; x=1741647192; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rHRREGcSp2krqTtJr5eO01PBlpy/oFOdFDc6Qvhwm80=;
        b=eC5Ah8SC6TMYOUVmlaMcM1AwBDdWEVI5AmzthZHRqMyA8yy8WYZ5ktV6BBKAEeRCR6
         rwbNySYdv3leiCupxi9m9pMANdzLBLvC1a40wJzax/uSuWqf3Z5Xc2jKimK1QSKVLKC4
         fALS2U97NGJHd01JfqMxqQQ7LZX1q0SFNZMunQyerZp67EOQj2BetMoCYgaVrfGwWOCK
         RqUNunYS4RLoilcVkVvtbnKPU2vCB7yP5MrLkhaWTZSBlc5eUj6Y4XYA4hKJr3S1wJla
         FzAKSJglFqXgwoTe/0uGqBoc0zQK3wLvl6wP3LXIxcrgGtiTf0CPvVTt2eHcTxjWlS0R
         4dDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741042392; x=1741647192;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rHRREGcSp2krqTtJr5eO01PBlpy/oFOdFDc6Qvhwm80=;
        b=ZcWEsVhdcNCMKxm5++gRGK1SjiyafQkk/03PjslJ4w6XRTMJiVqSWz86VUNquvrRgu
         3gUC805EzyAMdZ9Ik/C2NF5mEF0rFIPi3hupSZ3AwGWl738mSdn3JSXUfCf0+gRU1PLe
         Hg1rXKptKeiW+V7dqoNuoxRBR3Qt0cnbWr2pOvQuGgUNdDngaDwqLi8NWCN4tfs/tUZz
         eSowv4YjYia6PdvbwUk86TIegkKQT3x+zeqHqmsRlrAU6sy7bNcjOiCaaOEl6oiY6TXS
         /JyYnJkJ7+K1VSBardPk2OqDWYPQe+8PDWEeHwqUS8TE5xdqmsUPcQiI4P88zj0nF3Ut
         nkBw==
X-Gm-Message-State: AOJu0YzLeuAx0kONGvZREa2wKbldm1noj9Uqzy6wIRF8PZO47TOxpvX8
	7rt5EE7+xKwx7I3LGnvUabFm/nR7GEzv/T3G7D4E4SQjtjPu/aRSH7sMiG1NxDA=
X-Gm-Gg: ASbGncvO0vYSeOKvZui3eu/pqDC0qu1hjmAm/2tOPgsMR28Wp7oOc5CU7aKWcJXRN/B
	yCvLjqh9+Z++skt1GERe7XUn1zJELTOlh4QOhRplFf4GSM3lelqNYAJw4E0YOLBme9tSLnN5qrx
	VAwykuDPMxVXCodpl9y7wJqRUKgLaYIGWX0Mf628FkC8AyYXBqGJdbNLS+71orG0cuCHmbmGuFn
	Q0GC/ZwUxCzzykh8nuf+c0lwqRYgZzTL5SNwsumuclCqt0qOh16mZ4LoP6hXy1Qwr6z2SF3DusJ
	Y/2KB78hfW4M5UwZEwBiC7EC+B9lQHNgrAb6HXydgmWClo0OXbTdtHGyhQ==
X-Google-Smtp-Source: AGHT+IFTnPiC8gGn23TPq+Loy5LwqUVXrpZ/genl7BFYk1BAOqQRQeXw3l+mF/ky73QXi/CT689qMQ==
X-Received: by 2002:a05:6a00:a91:b0:731:e974:f9c2 with SMTP id d2e1a72fcca58-734abed5bbfmr23190306b3a.0.1741042391979;
        Mon, 03 Mar 2025 14:53:11 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a003eb4fsm9440601b3a.129.2025.03.03.14.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 14:53:11 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 0/4] RISC-V KVM PMU fix and selftest improvement
Date: Mon, 03 Mar 2025 14:53:05 -0800
Message-Id: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANEyxmcC/2WNywrCMBBFf6XM2kg6JrW48j+kFJuHHSRNSDQoJ
 f9uLLhyeQ7cc1dIJpJJcGpWiCZTIr9UwF0Dar4uN8NIVwbkKDmiZPfsxuCeI7kQfTbMWqv5oZ9
 QcAF1FaKx9NqKl6HyTOnh43s7yO3X/lrdXyu3jLOjUFz2Cifb6XOk7BMtaq+8g6GU8gGwP2/cs
 QAAAA==
X-Change-ID: 20250225-kvm_pmu_improve-fffd038b2404
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

This series adds a fix for KVM PMU code and improves the pmu selftest
by allowing generating precise number of interrupts. It also provided
another additional option to the overflow test that allows user to
generate custom number of LCOFI interrupts.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Changes in v2:
- Initialized the local overflow irq variable to 0 indicate that it's not a
  allowed value. 
- Moved the introduction of argument option `n` to the last patch. 
- Link to v1: https://lore.kernel.org/r/20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com

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


