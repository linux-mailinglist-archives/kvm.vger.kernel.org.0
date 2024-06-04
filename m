Return-Path: <kvm+bounces-18766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BE18FB286
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22BE01C215E1
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD95F1465A8;
	Tue,  4 Jun 2024 12:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ZZ9gtc+H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED16145FF1
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 12:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505174; cv=none; b=F1eXcEt/1BecBBzDNuJ/nBeTdIxya38U5pk1N9bP3vOnnpHnEAJT8cjlk26sf8cVmXj3ZYXlo0zTGaIuJU/2q+7UB2WarHmtyji8etMhfwvnNmz7ecQrFJnGQ4QWrYGgBiQWqZynakY5xn+BNj4uyXec4FERNFFxZkvatKnZaMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505174; c=relaxed/simple;
	bh=rXkB9HSCpKxWLSjih7qqbvvJKhAnmk8tL5d1yBuTZvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V79jHEARZ5c/iv0U0z+bPvfw5nnV50cdv5FLHV5oNOtoftPAZ3n32bPV6ikeN/wLAA85J9wQmXB3qf0IrjDio1vC/LrDOBRHpfYJYAxeL3gIEw2k0Tzu4+KMkmEsJg+XbHTqu3hipYaJroBjDiLQcQ9Noxxoz+CN9TjUdGAscRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ZZ9gtc+H; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f6181fc973so1999575ad.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 05:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717505170; x=1718109970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RlFfGyvlYpwu5mumxxHK+PtmO5s3+buvtb+SvPxc6V0=;
        b=ZZ9gtc+HzFnFoM18eou/rOcC3NuD4FVSM/dEi8JicBScNDcQrq+bw+4b0PlcchXbcJ
         Es+wj3Zsf0jnCklYbhskBaJIqBBW9kwgkV/qoUgxySJ5t+seyFhQEFscN3u3CZqERisw
         XtTsa04EFvTWu/faxFMeiQsK4r63Q4WMVTCZQpZVFI2fascUv0bW0qlvlFb6A7WDeXR4
         k1zQw8XY9TI4O0ki2x8QW4vq/HdIG7a7DODs8tqOFulQ3YfWoM5qiGBmnhx910yQed71
         Ml8l6ilx05hOOGkLF3BgcYu7MmJB6DvC22dxAKFEuCm/3Gn2aYDo1DwPlY9EGgtsvY5T
         iMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505170; x=1718109970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RlFfGyvlYpwu5mumxxHK+PtmO5s3+buvtb+SvPxc6V0=;
        b=hULS83AXrdwA6GZbwMMYcQoJS4h9LGe8tqTUe9MNNsCNGLWD17qYg3U+nmtKd0waE9
         /mz4l1ogB9XkHCKo90Q0sDR1kPpr/FuVjWqpVmJYEYvHPiM8drTlGe3RKF7xEbKo12Gz
         GBFZcPi9O4DGlg0nqvtUrRe7QTGWDWx228aWuWRJ9RTCPj0lxPH2oiNWYyod9C2wLYI+
         j6+uBf+SSbqoQOIbJc08fGyOZwWTKbjTBNOeSSl1X/Ctmq1dN2NUV7T6f59QqlN2m4GX
         gHRxPIWpbRfiHsX9RMwqUYUowV80GTNXKz7S6rqdzcGsi42mKUPq+0p9ZRSa1BwMczXF
         LAqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM/Pgo37fXxI9Hrl5LLcoXAwyMtKZuAAvKghljA0tC35GjBM7ZikuMMBrdzv5eeHRJVDrC3fGRR7j18bQQuJUkwjdP
X-Gm-Message-State: AOJu0YzXrXUJ5L1eSF36JFauVhZrapBg9+/WZ9RAkQslFEXdZ1H/dJxk
	uDK4ulI7bi5vlaUTffL1AjfPyVv5xySuaIfkLNlROZ9AFJ1voa17+33ab+l77bI=
X-Google-Smtp-Source: AGHT+IHYa0Aw6/ZCoGM1K6W/t5DQ4yQlSVhFECl9FxLx/IWFviwLhyvqWExcUz4B81YUgol+CdCuQw==
X-Received: by 2002:a17:902:ea0e:b0:1f2:fbc8:643c with SMTP id d9443c01a7336-1f6370f2847mr137326235ad.3.1717505170463;
        Tue, 04 Jun 2024 05:46:10 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:327b:5ba3:8154:37ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323ebc69sm83042885ad.211.2024.06.04.05.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 05:46:09 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v6 00/16] Add support for a few Zc* extensions, Zcmop and Zimop
Date: Tue,  4 Jun 2024 14:45:32 +0200
Message-ID: <20240604124550.3214710-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for (yet again) more RVA23U64 missing extensions. Add
support for Zimop, Zcmop, Zca, Zcf, Zcd and Zcb extensions ISA string
parsing, hwprobe and kvm support. Zce, Zcmt and Zcmp extensions have
been left out since they target microcontrollers/embedded CPUs and are
not needed by RVA23U64.

Since Zc* extensions states that C implies Zca, Zcf (if F and RV32), Zcd
(if D), this series modifies the way ISA string is parsed and now does
it in two phases. First one parses the string and the second one
validates it for the final ISA description.

Link: https://lore.kernel.org/linux-riscv/20240404103254.1752834-1-cleger@rivosinc.com/ [1]
Link: https://lore.kernel.org/all/20240409143839.558784-1-cleger@rivosinc.com/ [2]

---

v6:
 - Rebased on riscv/for-next
 - Remove ternary operator to use 'if()' instead in extension checks
 - v5: https://lore.kernel.org/all/20240517145302.971019-1-cleger@rivosinc.com/

v5:
 - Merged in Zimop to avoid any uneeded series dependencies
 - Rework dependency resolution loop to loop on source isa first rather
   than on all extension.
 - Disabled extensions in source isa once set in resolved isa
 - Rename riscv_resolve_isa() parameters
 - v4: https://lore.kernel.org/all/20240429150553.625165-1-cleger@rivosinc.com/

v4:
 - Modify validate() callbacks to return 0, -EPROBEDEFER or another
   error.
 - v3: https://lore.kernel.org/all/20240423124326.2532796-1-cleger@rivosinc.com/

v3:
 - Fix typo "exists" -> "exist"
 - Remove C implies Zca, Zcd, Zcf, dt-bindings rules
 - Rework ISA string resolver to handle dependencies
 - v2: https://lore.kernel.org/all/20240418124300.1387978-1-cleger@rivosinc.com/

v2:
 - Add Zc* dependencies validation in dt-bindings
 - v1: https://lore.kernel.org/lkml/20240410091106.749233-1-cleger@rivosinc.com/

Clément Léger (16):
  dt-bindings: riscv: add Zimop ISA extension description
  riscv: add ISA extension parsing for Zimop
  riscv: hwprobe: export Zimop ISA extension
  RISC-V: KVM: Allow Zimop extension for Guest/VM
  KVM: riscv: selftests: Add Zimop extension to get-reg-list test
  dt-bindings: riscv: add Zca, Zcf, Zcd and Zcb ISA extension
    description
  riscv: add ISA extensions validation callback
  riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
  riscv: hwprobe: export Zca, Zcf, Zcd and Zcb ISA extensions
  RISC-V: KVM: Allow Zca, Zcf, Zcd and Zcb extensions for Guest/VM
  KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test
  dt-bindings: riscv: add Zcmop ISA extension description
  riscv: add ISA extension parsing for Zcmop
  riscv: hwprobe: export Zcmop ISA extension
  RISC-V: KVM: Allow Zcmop extension for Guest/VM
  KVM: riscv: selftests: Add Zcmop extension to get-reg-list test

 Documentation/arch/riscv/hwprobe.rst          |  28 ++
 .../devicetree/bindings/riscv/extensions.yaml |  95 ++++++
 arch/riscv/include/asm/cpufeature.h           |   1 +
 arch/riscv/include/asm/hwcap.h                |   7 +-
 arch/riscv/include/uapi/asm/hwprobe.h         |   6 +
 arch/riscv/include/uapi/asm/kvm.h             |   6 +
 arch/riscv/kernel/cpufeature.c                | 278 ++++++++++++------
 arch/riscv/kernel/sys_hwprobe.c               |   6 +
 arch/riscv/kvm/vcpu_onereg.c                  |  12 +
 .../selftests/kvm/riscv/get-reg-list.c        |  24 ++
 10 files changed, 375 insertions(+), 88 deletions(-)

-- 
2.45.1


