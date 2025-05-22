Return-Path: <kvm+bounces-47409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5E4AC158D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 330FD9E499A
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCDA23BF9E;
	Thu, 22 May 2025 20:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nGbg04aF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE59238C11
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 20:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946141; cv=none; b=chdIJc0cxbZAxNKWdZbKVs1BSQz8f022muXnKYski2YyOAoglimAPGEeEOtgZ1tXksUC2PY6t8f8auB3OY/MbNUc5csZA2eSIVV+meqr0bVPg8vzfL/fA2P70Q3ypTGeLSO3TnWny6gQx8TNyemuWzUKcfU2Jtcdw0yyHPq71ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946141; c=relaxed/simple;
	bh=EFdSobWGtskk4ad2fNYUv4Ufa2xIyvSV+W2ctGlJ3Yw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=geXRPDC07iIWjptwU/6vQ0Qm6zfUuDopxbSJiLzlUwS2hy9DLSD+U+PFO4NO+fDAgxsF+BVAty4dIcWSeMYl9NAYJk2oXU85TPF2V2mGrE0ed78jKhiBz4dMgV80opLLY9nY/6e4VnbTwy0QEHEKcuIuVIbQUkaqbADbDv5PJh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=nGbg04aF; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-30e8f4dbb72so7129296a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747946137; x=1748550937; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mJeI3hczrGcorf0zoQdD5/qF+d8TPGNC2tDxL+T9ilg=;
        b=nGbg04aF2A0xxxPBnvwg26ERlp1dRkHJIdBAbDWErHVq3r8GL1zLpBt/huMO+S7Civ
         47yXdPUPyfKNc8l77LtBISjbgBCwgL8ZYsQoBbEhhtMpzmR/WExPZgblAxyjT8nHQ75u
         5kXN6qTeifSunRt2ZIaeshj8TEtUSHD7gDtoaQFnDuzDWHYLQwM4axNlcnWXuqMzzftM
         4w1qT1GFNNbPOsNlquPNrdSiskbOp6nYWWmra06wyJMsGFJG+vP0nRVPzFBqRwSD8VDd
         970P9q6xs5KfIx8u5fLYsNHUJaGHLSj+o++H17SAzmnYuNlRB0UqJSQH5OAng2pTv3+4
         5rkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747946137; x=1748550937;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJeI3hczrGcorf0zoQdD5/qF+d8TPGNC2tDxL+T9ilg=;
        b=SFzFtmNf/KZM6vqwRXMJR8umbhfVg9IjtgS6yZ5+nXGgerQ3N8EHHIRwaDsCGha3Bs
         y0DKhvh7sH7+mz44LDrMqCCHX8AIpZmIqDQUuIMZH0+i49olJDYA1IL6G5aRO3Ftjs8p
         V4tKD4eXjHuvOYnfxK4ukPOK3ghmwFg925NF62vdBcx4g2KbKK1k2wpLC9E9XXYcJZ6H
         fekE8QPhWo9WWLFxw3GY3pmrcCSRjRiBmSmoy/XP3WTLTKs/gHEtL64zzMs5X/S+2Fwd
         xkrVuKdrg/thg2x615VNEQ/gE566OgUu2GZuUyTN78M785YHlvsek9T9WfzPtcswmysK
         Zojw==
X-Gm-Message-State: AOJu0YyCaZy3+3VozRBOvQahDauEkOJyVzzXQzd8INSGFErns5lGoTLy
	xY0QBMsTlWs3OP0SCrAboU8BMY6hVY0+jM80GPoDO/yaq9Vq0YA6bLfBgdSnmSf6Jiw=
X-Gm-Gg: ASbGncsYdEi2FXWOT07fyW7ikBkTPcj78QGOdkAirOCfC8INupG6t7qXfSbSvjl+e3g
	fhgIu/tnA6qq2ivmp+493TAuIhx9nP/XRlnQWOL6SR7uXsITFbyDtO87IbFNMSOpYf7YcqlEGJn
	Xufrt3fFTSshTTfOEQGoneAfz+1KkKJK2IzN6kVvHiYMpC6/D0vRhDGHrpqmq2FrjU035fH+Xpl
	UFdl7SQGAK6ZSpgTym+G+imO3OesvFxCK9Nihp/r+jnMwYkhH+Wbw03zH7aNVLnD5t+wREqiljv
	4oTpTMEc8D/FqG/z1LafJHk/rqqf1nEE8ry3d3/ENG4KsvwKEzhMQsj6EJ5RL/AOInoGYxsDbA4
	=
X-Google-Smtp-Source: AGHT+IFc2kSfwF3mamOSnGj80fjCx3PhuRYqTPiDeh2Maj3FvlzMuzjpvViHalbc+sE51fOiA8fqhw==
X-Received: by 2002:a17:90b:1d45:b0:2ee:df70:1ff3 with SMTP id 98e67ed59e1d1-30e82fc1905mr45589271a91.0.1747946136890;
        Thu, 22 May 2025 13:35:36 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b229csm5932754a91.10.2025.05.22.13.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:35:36 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 0/5] Enable hstateen bits lazily for the KVM RISC-V
 Guests
Date: Thu, 22 May 2025 13:35:24 -0700
Message-Id: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIyKL2gC/3WNwQ6CMBBEf4Xs2ZqFxYCe/A9DSKmLbMTWtKQRC
 f9uxbOZ05tk3iwQ2AsHOGULeI4SxNkExS4DM2h7YyXXxFBgccCSUN3jox31e27Z6m7kNkx6Yra
 KyNRaHzVhlUNaPz338trMlybxIGFyft6OYv5tf86Uv86YK1TU9aZErKkic/YSXRBr9sY9oFnX9
 QNP+zsRwQAAAA==
X-Change-ID: 20250430-kvm_lazy_enable_stateen-33c8aa9a3071
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

This series adds support for enabling hstateen bits lazily at runtime
instead of statically at bootime. The boot time enabling happens for
all the guests if the required extensions are present in the host and/or
guest. That may not be necessary if the guest never exercise that
feature. We can enable the hstateen bits that controls the access lazily
upon first access. This providers KVM more granular control of which
feature is enabled in the guest at runtime.

Currently, the following hstateen bits are supported to control the access
from VS mode.

1. BIT(58): IMSIC     : STOPEI and IMSIC guest interrupt file
2. BIT(59): AIA       : SIPH/SIEH/STOPI
3. BIT(60): AIA_ISEL  : Indirect csr access via siselect/sireg
4. BIT(62): HSENVCFG  : SENVCFG access
5. BIT(63): SSTATEEN0 : SSTATEEN0 access

KVM already support trap/enabling of BIT(58) and BIT(60) in order
to support sw version of the guest interrupt file. This series extends
those to enable to correpsonding hstateen bits in PATCH1. The remaining
patches adds lazy enabling support of the other bits.

I am working on a followup series to add indirect CSR extension and move the
siselect/sireg handlers out of AIA so that other features(e.g CTR) can leverage
it.

Note: This series just updates the hstateen bit in cfg so that any update
would reflect in the correct VM state during the next vcpu load.
Alternatively, we can save the hstateen state in vcpu_put to achieve this.
However, it will incur additional cost on every VM exit while the current
approach just updates the configuration once per VM life time upon first
access.

To: Anup Patel <anup@brainfault.org>
To: Atish Patra <atishp@atishpatra.org>
To: Paul Walmsley <paul.walmsley@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org
Cc: kvm-riscv@lists.infradead.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Changes in v2:
- Added a preventive check for lower 32 bits of hstateen. 
- Link to v1: https://lore.kernel.org/r/20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com

---
Atish Patra (5):
      RISC-V: KVM: Lazy enable hstateen IMSIC & ISEL bit
      RISC-V: KVM: Add a hstateen lazy enabler helper function
      RISC-V: KVM: Support lazy enabling of siselect and aia bits
      RISC-V: KVM: Enable envcfg and sstateen bits lazily
      RISC-V: KVM: Remove the boot time enabling of hstateen bits

 arch/riscv/include/asm/kvm_aia.h       | 14 ++++++-
 arch/riscv/include/asm/kvm_vcpu_insn.h |  4 ++
 arch/riscv/kvm/aia.c                   | 77 ++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/aia_imsic.c             |  8 ++++
 arch/riscv/kvm/vcpu.c                  | 10 -----
 arch/riscv/kvm/vcpu_insn.c             | 61 +++++++++++++++++++++++++++
 6 files changed, 163 insertions(+), 11 deletions(-)
---
base-commit: fb13a11917ea679b12b0d51905dea1cec23c015f
change-id: 20250430-kvm_lazy_enable_stateen-33c8aa9a3071
--
Regards,
Atish patra


