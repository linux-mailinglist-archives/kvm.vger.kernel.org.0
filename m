Return-Path: <kvm+bounces-33723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5969F0B34
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 12:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EDAA2834E3
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 11:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0151DF265;
	Fri, 13 Dec 2024 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ZSt1HQDo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A51AB528
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734089597; cv=none; b=av39605wZAsQ2R7fhz+ZCsuUI4AmRLY82ApAgAiGf4igSLP6fpCSgiLGO5RGMr/cy5MTxUKAPslOtdY73qztuJ68qgrpCqwdJ7H0m7Xx+a1Yb5T+A4csm7mNXs+3/U2w5mOvRCNa2lcORaRBUyWnDGYh27A9k9dM1cYorRhkYHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734089597; c=relaxed/simple;
	bh=tbP+jC6o0WUbBs5wzvPexsjiCSh2sPVpbTXynXjrfGk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=CFns60WdUSZSrN2+2N8WEiuxkrAbL0r+QTM4yPVWVTianigJDdP/al0NgoG1DYtR3Ay+QkVNYmPImgzqtYRqSJqxkdUY2nvuW1KcCLkQcvszsuvNGANzn0jXy59XYrN7sdMwPVWgYLUsfXRfhlGqEC4/dBxNQzeFf92RvKbTvac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ZSt1HQDo; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-20cf3e36a76so15665725ad.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 03:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1734089595; x=1734694395; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=26MbCcxBXRObwdyBKZjlPQXxYB9MTH5C48d0Ryy4x64=;
        b=ZSt1HQDoJSRx7q43X8bBcy0emGKMjRnLv7yf4uUnJa2vL+ZoQcI3wlPhquGpsp6ND9
         e/vntTexPmo+AWurBu2bPGvA3pwBdl3NhCLsZa65kWLFvV0tG3bB1nPjMvDWkUv/hHtJ
         5ZZ3T0WiLkpYM8fpV0CMa34FwIXrXiBiEtQKExKFjJREoVmka0FY1YV4dG3gbzQqgAsu
         mIhPaY6Wl5qNE/B9fKzkQL72Yp4KGzRnuj2zyMSsmsLptYk9/6x4XJCIQCuPKMQZQ2t7
         PTz0NF+xNSTxvlnkQOqRvnToyZATqzaDvYZNPogv9QAMR5d4WGq0x58fXsmxxl1HPSa6
         lvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734089595; x=1734694395;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26MbCcxBXRObwdyBKZjlPQXxYB9MTH5C48d0Ryy4x64=;
        b=pI6D06h1VktH2/wwcmJnureDfrewCy50v/s5PUBFsJSD5dZt8wrlstudsfvUubhLyq
         CKh7RikOf3AZ0VNORwQbHle9eawwOWCxmqKKxDy+HXXNDqfycBkk6CLHkWBWjP3PPghH
         nP8187I88E4aeYx6uk9k5FLzD5AuCrBPL/Rr6nxmJGLvhS9VCJLzt9aT4HF34pLIzvBI
         Um3U4Lc/4zSGGG1PCtHqvINkVufNGNjLVT2yuRHE0IKwrkEySGGC3UC+076W23XTUHbC
         aLB9szAzRXvSdZQMTmV9rK6KslEH9i+Biu4OSFq+Dn4/K8p3lvxlatQpiShR5MpSIkqO
         pXsw==
X-Forwarded-Encrypted: i=1; AJvYcCWY62vCv+wvLDm56+zYlogPNd3tYzS0roIS79+gS34qtunrwH9ri9/h7dt3M418Jlt9xVM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF+6FUvej0S9+3IPu/MrpAf8HtsdsWPYuhu2xqTO13AENDZPtA
	NQDphyXKX10VOiWmKaV1jRuNgnNcqbPxHsn7Zy3aEI82xvcSqpckHY7z7HO2NU0=
X-Gm-Gg: ASbGnctdROPf/9tCqAJ2F7oreZYOqulR9RfO0gTJ/DVW3Kt/NJX5cDbf0aL8vzfqVb0
	aP2nGu6EK3SHOGY8FHPSp+16MkwfbC3a8j2HVQBF8okxeVwLJc6Mk1iE6SI99XPRNfr56VTGvtQ
	jT+kUVZeZfMCbEsO7ou+HIJj09Atj+CrkG3lN3hu/JhqsYRANlBCAHXY9VsYD9G6/CMVfI8AsvJ
	FF4SGUsdXealZI9o/YQ+6Qoc2Byq8gSnq4A+imRAaJlRMQPUvD4tk0=
X-Google-Smtp-Source: AGHT+IE2aHmaFHTR9iBiCUjqMgt+u4ssTP/m0KwR0xBzwYlNhga7euk988OdWGvjpY5KeC8o/0oqRQ==
X-Received: by 2002:a17:902:d50c:b0:215:bc30:c952 with SMTP id d9443c01a7336-2189298a144mr36097955ad.6.1734089595266;
        Fri, 13 Dec 2024 03:33:15 -0800 (PST)
Received: from [127.0.1.1] ([210.176.154.34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21631bd2c2dsm103327125ad.263.2024.12.13.03.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 03:33:14 -0800 (PST)
From: Max Hsu <max.hsu@sifive.com>
Subject: [PATCH RFC v4 0/3] riscv: add Svukte extension
Date: Fri, 13 Dec 2024 19:33:06 +0800
Message-Id: <20241213-dev-maxh-svukte-v4-v4-0-92762c67f743@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHIbXGcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyTHQUlJIzE
 vPSU3UzU4B8JSMDIxNDI0Nj3ZTUMt3cxIoM3eKy0uySVN0yE11jE0MDw9RkSxPTVEsloMaCotS
 0zAqwodFKQW7OSrG1tQCcvFY+aQAAAA==
X-Change-ID: 20241213-dev-maxh-svukte-v4-34101ec945e9
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, Conor Dooley <conor@kernel.org>, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Max Hsu <max.hsu@sifive.com>, 
 Samuel Holland <samuel.holland@sifive.com>, 
 Deepak Gupta <debug@rivosinc.com>, Alexandre Ghiti <alexghiti@rivosinc.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3076; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=tbP+jC6o0WUbBs5wzvPexsjiCSh2sPVpbTXynXjrfGk=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBnXBt3nDotuBhQJRSQUC7kSPKHLLlxqASJuOrQK
 U5Px7fhMk6JAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZ1wbdwAKCRDSA/2dB3lA
 vcR4C/4irx2RT/e5bqfqAIm563+xO9z5R4UvXSir/eIK9aVaHYeMVqEdWbPauFsH5lGk+WLVpEh
 B9p8z3ebch6wZM/EHolPkw5wCN6bU7kouNEK4mTX9ciVvsgk2viGkFg2kuwQvxkDyPPTI0lG8py
 1O3tqm3kG9nv6YuBgJE/jFYHQK7AWqyGq+Z97fxy1+je3mdJ360SkwAJwLJruDet2/B39bd0wud
 Ye+9EUv44RY8nUGvq1E2teWhCcDGwysMSPwo1euaAG98AGzu82QpJMNE6CVjTcjryau0iu9eXBi
 XYoOpu/POI0s/hE8t+RQpofxtx7Zxn0jbtV98fsNKJGCkHm2jPIwTetFCcRnxQ6+qY1Rv0FSUr3
 rFMddvmyn+KHaBt0yccQpl8GOFWWUtn2G75N80wP5IUUW0H/6i/bCh45IGKSEVIMM/elBip6kNJ
 6sczUcrwCMH7g+b/5nuLrefqZXCg3p8Fk8/PBw0e9gXgz5aFBEX3c4jf/BR6ynSkuAHds=
X-Developer-Key: i=max.hsu@sifive.com; a=openpgp;
 fpr=EA5E671B3A14B629913D5F68D203FD9D077940BD

RISC-V privileged spec will be added with Svukte extension [1] 

Svukte introduce senvcfg.UKTE and hstatus.HUKTE bitfield.
which makes user-mode access to supervisor memory raise page faults
in constant time, mitigating attacks that attempt to discover the 
supervisor software's address-space layout.

In the Linux kernel, since the hstatus.HU bit is not enabled,
the following patches only enable the use of senvcfg.UKTE.

For Guest environments, because a Guest OS (not limited to Linux)
may hold mappings from GVA to GPA, the Guest OS should decide
whether to enable the protection provided by the Svukte extension.

Since the Guest OS may utilize the Svukte extension simply by setting
the senvcfg.UKTE without any trap to host. In the view of VMM, the
Svukte extension should be always presented. Therefore adding an
extra entry in kvm_riscv_vcpu_isa_disable_allowed().

If the Guest environment wants to change senvcfg.UKTE, KVM already
provides the senvcfg CSR swap support via 
kvm_riscv_vcpu_swap_in_(host|guest)_state.
Thus, there is no concern about the Guest OS affecting the Host OS. 

The following patches add 
- dt-binding of Svukte ISA string
- CSR bit definition, ISA detection, senvcfg.UKTE enablement in kernel
- KVM ISA support for Svukte extension

Changes in v4:
- rebase on riscv/for-next
- add kvm_riscv_vcpu_isa_disable_allowed() entry addressed by Anup
  and Andrew from v2/v3 patches.
  - update the cover letter for the detailed reason
- update the commit message on dt-binding for the Svukte ISA string
- Link to v3: https://lore.kernel.org/all/20241120-dev-maxh-svukte-v3-v3-0-1e533d41ae15@sifive.com/

Changes in v3: 
- rebase on riscv/for-next
- fixed typo in the dt-binding for the Svukte ISA string
- updated the commit message for KVM support for the Svukte extension
- Link to v2: https://lore.kernel.org/all/20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com/

Changes in v2: 
- rebase on riscv/for-next (riscv-for-linus-6.12-mw1)
- modify the description of dt-binding on Svukte ISA string
- Link to v1: https://lore.kernel.org/all/20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com/

Link: https://github.com/riscv/riscv-isa-manual/pull/1564 [1] 

Signed-off-by: Max Hsu <max.hsu@sifive.com>

---
Max Hsu (3):
      dt-bindings: riscv: Add Svukte entry
      riscv: Add Svukte extension support
      riscv: KVM: Add Svukte extension support for Guest/VM

 Documentation/devicetree/bindings/riscv/extensions.yaml | 9 +++++++++
 arch/riscv/include/asm/csr.h                            | 2 ++
 arch/riscv/include/asm/hwcap.h                          | 1 +
 arch/riscv/include/uapi/asm/kvm.h                       | 1 +
 arch/riscv/kernel/cpufeature.c                          | 5 +++++
 arch/riscv/kvm/vcpu_onereg.c                            | 2 ++
 6 files changed, 20 insertions(+)
---
base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
change-id: 20241213-dev-maxh-svukte-v4-34101ec945e9

Best regards,
-- 
Max Hsu <max.hsu@sifive.com>


