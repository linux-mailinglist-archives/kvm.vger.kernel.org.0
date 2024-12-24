Return-Path: <kvm+bounces-34368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E953D9FC278
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 22:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58F3E188342F
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 21:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACC6213242;
	Tue, 24 Dec 2024 21:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hpcUQrYF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE6818DF86
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 21:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735074303; cv=none; b=C+T3pMUY0DBMMk3SroL15ImtGG6q6ag4XYSNCsk5/ZpcpyqyuZkokUzPOVUhEZyLAPJ13VEkv6K0Oir69hViLomDMvSbAkhE2KDaK8vtj9cNRvD7PcNwppAwVU+ArDeuczNJ1IkB5jIJ+d/MocUdk3Wlh+zZSaLHeVFvZ++B2a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735074303; c=relaxed/simple;
	bh=M437SXZ2O94opX4oWAk/sDei1xuGsYTd1JJ9zXzI3mE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=teVqHyA7ZqDZW2z++93T73jBNLLc+HEcVtNldquwdjht7v7FJ06w67IMq9ZexkQS4+fjQsMU/ZBtd1ZXpcImbpziDwxc266CsPUBhkK/upqzzMpAqe4WFNyuKF1FFTebWmz9tWB+jyObqjEcaNONZUJsny/XO4yWRNmlC1HtuX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hpcUQrYF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2163bd70069so56214205ad.0
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 13:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1735074298; x=1735679098; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sI1JaJkunk7xEX9+Xf01iHnjfpujHUUVPbR0FhepJuw=;
        b=hpcUQrYFz8rRn3cF3Cqjriv6dxY515s4p38yz0jpoVbUTP+a07sapOyCp1u1+sksi6
         FRRG736ukrZpHPZvLR4Sbu6aTqschrgt8lLpn3k8Rwh55uZUQGrV7v0hDoZZFHL4Q1WE
         aUuxyZqLmQbyhy/m1xwhEJgk3HYgfib0gYDQBe8fduxtb/UJn5Go+lhZzJXNNOfXjbr0
         P4V0kij33Qp1CPitwuklfXT2GDgaTn0g08ooJNenGho2nYsXG2B95dW5ddRZY8Z9siMG
         yVbex1JRqCD86ccJru/S/VMtd1KXEEi+qmdZbKElcYqm8R4RK1FvADjulqWNZ8j7oZcM
         WLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735074298; x=1735679098;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sI1JaJkunk7xEX9+Xf01iHnjfpujHUUVPbR0FhepJuw=;
        b=fMGezPYQrZTtV8ZFrthWM2Jdv3PcvVj1LhJFzlOpWHEZ7AfuxzPuAqBq/L1X8pLixn
         gnzDqVNyFLnn885kIVeUf0qEoWlthu3MPHJT7Pwgx9HWZ1QTM7QeJHENIgQCcUrww8Dq
         I3aHYOPqIl6icqmYsLY3ibhjwi5UwvLoc1B3ZFWIaCvBOEHLtqTaxg6YfHaaWcgTDqiC
         +Ovghn+ZQy/mqpFALTNGOXCoMQ6ZPSA2gBUXdAw9Gl88RGLBF0QDmZPe1vAFgqh1y+2T
         aCGIqVkntkFGLcAv0E/ToHd11mbmUQEJoIRVdj1wIVZxyJ6wZ2V59DgpuxIZHLDiIuZb
         i7Ow==
X-Gm-Message-State: AOJu0YzAgvGMcT508sux3Rjl1erfonNVSe/Ole1IDwdRYyK8SEcW9mbo
	M+b71h+0p243e3rI5XwPuDzViVnpdBuPzwokHXQi6aGrvPN1tfrCkvED7ZO3PwA=
X-Gm-Gg: ASbGncvluJtc8apO37ROTG6Z6qYIQ8xZYRrZYS80VT2zqQyzl31fRHM5uiObNwfSOz/
	P7rHrH4HBpFCbpWpVS+MEN5n+O6vIbKv1Bcgnf8saoBIERTxCGrXbljvBxOSxMAcfB5EH54r9jA
	pUAsZ4Ze5wVGto4j9K3979OFXHevx9+ARfFjVXEdgQFaTvApeXPJ6rs8vhbmmF+zCYdU0wOOtX4
	u55uKg72RMdzYM4SW+/ZQivOwDd2G0JLB8WC5cVK8dxQbK4yjGUkUeL6WrpyoMV/y2p7g==
X-Google-Smtp-Source: AGHT+IFPEALDBCpfdEtIoSSL0284tS67mJTa+n5sXWkYGZrMoWfeQCLlRAzW2Jd/Ci42z7TCaOpkTw==
X-Received: by 2002:a05:6a21:680d:b0:1e1:ac4f:d322 with SMTP id adf61e73a8af0-1e5e0484559mr28688385637.14.1735074298296;
        Tue, 24 Dec 2024 13:04:58 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c344sm10445925b3a.186.2024.12.24.13.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2024 13:04:57 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 0/3] Collect guest/host statistics during the redirected
 traps
Date: Tue, 24 Dec 2024 13:04:52 -0800
Message-Id: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPQha2cC/3XM0QrCIBTG8VcZ5zpDxUl11XvEGE5tO8Q0PCbF8
 N2z3Xf5/+D7bUA+oSe4dBskX5Awhhby0IFdTJg9Q9caJJdKSCHZo6zj/PKUR8oms8kqfda6n5T
 g0E7P5O/43sHb0HpByjF9dr+I3/qXKoJx5oTRjtuTlq6/JiyRMNijjSsMtdYvpm/dGa8AAAA=
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
Changes in v2:
- Improved commit messages in PATCH3. 
- Added RB tags.
- Link to v1: https://lore.kernel.org/r/20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com

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


