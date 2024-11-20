Return-Path: <kvm+bounces-32157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B03D49D3D4E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71810281B51
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFF91C7281;
	Wed, 20 Nov 2024 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="K8RygJNl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CBD1AC447
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732111787; cv=none; b=oRmYwczSbyCW8vkS/IK7tUjZ7eFTbptp4NxDvXD8M/57x9YvA8xj/9MpMYAZdjafe+hF4/z7tGmIlD2mEQ4KBGkpvuabGI2pG0FNfpq+Zct/Zne/5FF3V+QDxcGIQY+PxNaIWMOl1ZobEnetcb1iuZ+ocNiT+EIKblQROLYLWP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732111787; c=relaxed/simple;
	bh=ju5iaCTTGnlC8cKNSV/WW1suH3P3ww9XIffkT2cxxRo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UKAZJ+pQctAs1d1Pm4kY+m/xnYbB2V9pxs9x+mCan5H+y2+PiVhM6RY5JRdn4pQIV29xl+NjKEHMOcEo+5HD8sWn527HPs8TdOkJ9blSDvb7FI+krxT2MLOF4gl2Mz4IRwC7d2LtR0S/7lz2yfH5x+CIXayCqDDMqZcMy1+ctUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=K8RygJNl; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-20c805a0753so21440985ad.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 06:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1732111785; x=1732716585; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cxrAHqhmG1JlcR3HvdHEoqSUwYkPTE5MTo5NUdeAECY=;
        b=K8RygJNlhsqvtRxMj60MGZUwW32Wb52IUFpZ9lHxfUG/GWm7jSqrPv2Z4fqx3xH3IU
         ZJmTaSHVQa3Xs9d6EM7AwbRxvjiByv9dZu+XtZlAef7pdMp+9YdAAqWGSX8DSBlU4ro6
         TuLOWU8aIUkrUqPhAdrYA2L73qRMVo5e8NhHBpgmIevV1KxIh8XgDJSM5ysh18tjU9Pp
         lS/CmKixArN63B0SwbOCG/IIpN7diA6nj8zuuLk6li94UwjA92vr0rTARCnNMipT3CUV
         bAkIcVAqOMi+x1WgeF29rqr2XqbRwAV5Mj21Oo7nfNKS4LrPycN9X4Cdrvv9r64cs7/V
         ljiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732111785; x=1732716585;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cxrAHqhmG1JlcR3HvdHEoqSUwYkPTE5MTo5NUdeAECY=;
        b=Y8DYNCbI7fnwMC00WtZPb16b20NcrM6jdwvJebk6nLXEaikmGgHlsKdQs4N5p1Qcgn
         3PdSjHl9hPDHy3Io2DqglbkXZ09qW+HZ0L/MV46LcuRbhDghyJ9ifQ6sFboO74MLWSgb
         vH5s1SobOaytz3hZUxFJCBRQYm4RuKTi+jmAcWx1Fyyd9jQjwZ+4w6QhGJhaycE9gDiE
         A4YRGrLDLsFra0vsHB0fnZ/5zd7QhFzmkHl9HYFxVC+AgUKAvIPMbBFyV3c4PIuT03w6
         Vj6K6RLWkr11Vkb8rODI3PdvENif6HQM4dUuq90uodG8uv/Ebla/DbR8Krj+hrDIxMkc
         AD0A==
X-Forwarded-Encrypted: i=1; AJvYcCV6yNQBvymVw/00lqTaWXC8dDVJRuBT/kcD+t1oZhxRqgFU2XSoRPQQ/0rZVGj58TlcYXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YynqWYCFvHOUiP59uW4SepM35Ts8S+yACqfcwLen4w3lfkDdkbw
	ChVk8MrY9BZJvWBVK0rhtHC2w67GtK+r2N6iup8Qz1wKQWAyZRMgnR04AIbZ82c=
X-Gm-Gg: ASbGnculv9RT+EXtC89xb+mfsQjuRFFh8Ex4v/mpDqJOSH3FupruxovuleQ+TwuwbHm
	b7uCMukVl9ITWAf/hgqBGmYuktjpWeWupTqEy68p4Oz2qcaUXMzfiJNJvTWTH7qLQWR/ZWxZnbh
	TvMiU5SL3ZplEEKFQR4gsoZp04KpOtKv5JI7Zare0qv8l6Yjv3q0eTP/C45vbAoXdhDNzp65DWL
	AGWIt2EDFAn9SgTFkEo9pzAorHkaDNilX4Ssha3BgdO1+ArUOO4ycxs/t30ZsyDl7iWZXhLnUEW
	BZf5Qw==
X-Google-Smtp-Source: AGHT+IGUKS5hjt2wBeHFpNbOFGt9aCFT4yqBOEuCP8j8uWcxGmZ/D/8LQlPLEi80dxUfa7W2k1rhVQ==
X-Received: by 2002:a17:902:e80f:b0:20c:cd23:449d with SMTP id d9443c01a7336-2126a456615mr36184435ad.46.1732111783883;
        Wed, 20 Nov 2024 06:09:43 -0800 (PST)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f474fcsm92502505ad.213.2024.11.20.06.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 06:09:43 -0800 (PST)
From: Max Hsu <max.hsu@sifive.com>
Subject: [PATCH RFC v3 0/3] riscv: add Svukte extension
Date: Wed, 20 Nov 2024 22:09:31 +0800
Message-Id: <20241120-dev-maxh-svukte-v3-v3-0-1e533d41ae15@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJztPWcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHUUlJIzE
 vPSU3UzU4B8JSMDIxNDQ0NT3ZTUMt3cxIoM3eKy0uySVN0yY93ENBOzFDNTg8RkgyQloMaCotS
 0zAqwodFKQW7OSrG1tQCbJCqIaQAAAA==
X-Change-ID: 20241115-dev-maxh-svukte-v3-af46d650ac0b
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Max Hsu <max.hsu@sifive.com>, Samuel Holland <samuel.holland@sifive.com>, 
 Deepak Gupta <debug@rivosinc.com>, Alexandre Ghiti <alexghiti@rivosinc.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2572; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=ju5iaCTTGnlC8cKNSV/WW1suH3P3ww9XIffkT2cxxRo=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBnPe2kHNOLtJ3Nh25+lGk83izF/rgv0VNEkT6pu
 REZcT4K5Y6JAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZz3tpAAKCRDSA/2dB3lA
 vZfUC/sHvSkPEeYcaLuBEqUc3AcV2qThswESzWxUw4n7HTrnZVEWEif4jcdPYpXLMtrBY5zGlVk
 FO4VpUrnYPxMYbz2NSMEqp5JeIOdWY8rBQqKYcV17s7v4XA3BfCXC9q/hXupXM2dEdLOYUGtpqq
 LWyPTw5fuqFEShidGJktJK740GSqg0Rh8ybvwadf6/aP0bIGEYMflZbMn2JDo9Mc3b925/WaPgH
 vgEPgPWoTC/c9MX6Pb+nPxvK6lE/98LSbKCLLSCJDJuo5Z5l+Li4RqRt/SvL8YeqvwOmlKVbtGk
 cHz0q4XRKXyCSAg68Z/n/2rX410Nw9L8j0FxDjrmINiu6yge0/J/TiS2t5YRIoxmPYye0Yiz9A9
 s2goi0wDboUE1uIlMD1AHbmBSqnfSJsCEmE2TnLsnlarYRY3a3WmBh6mNNqh4vpbUOTCI0tpz1F
 7zC6DVzOqR6FJ4zULNN7B0rlWhzSWStDMay5CJOKM2awK0czHIHoaHuStTJywSon057N8=
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
Therefore, the functions kvm_riscv_vcpu_isa_(enable|disable)_allowed
can use default case (which will return true) in the switch-case.

If the Guest environment wants to change senvcfg.UKTE, KVM already
provides the senvcfg CSR swap support via
kvm_riscv_vcpu_swap_in_(host|guest)_state.
Thus, there is no concern about the Guest OS affecting the Host OS.

The following patches add
- dt-binding of Svukte ISA string
- CSR bit definition, ISA detection, senvcfg.UKTE enablement in kernel
- KVM ISA support for Svukte extension

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
 arch/riscv/kvm/vcpu_onereg.c                            | 1 +
 6 files changed, 19 insertions(+)
---
base-commit: 0eb512779d642b21ced83778287a0f7a3ca8f2a1
change-id: 20241115-dev-maxh-svukte-v3-af46d650ac0b

Best regards,
-- 
Max Hsu <max.hsu@sifive.com>


