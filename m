Return-Path: <kvm+bounces-15073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 248088A9A08
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4870E1C202E7
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE12E15E1FE;
	Thu, 18 Apr 2024 12:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="m2Tx15Tv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EED13442C
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713444237; cv=none; b=owi0ZeriGBh/GsCoN1U7gtz+VCcEiS9TOjhABql7LZVLgDVc1e9eXJbuIWe4mWS6uo4rbV6D/t0KSPAY5lfOycgMU1LpMRC+5sIoiBP4BVtsAJYpRQT4Hh2uOLV8kE37jFv/U3Wy31ggeblI5ZBMuJN5UxDxn6Ll2ifOAKMKb0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713444237; c=relaxed/simple;
	bh=BSPP+JhpgqmbSOjXMNtVSOk6UyemTIHuAPZ8lvb1GHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Pl8otcxzHCnpuiK42jWrLDFdA1oqoP3r7gfQc+W8NTr5XycJl6aVzYfT8/D4jvViRGkUEAdG+kU2l/mG4ejT2vQalFezBLru0vpVIIPSFTl63G+iAJYBACzdzphkR1gtk+01+hXNAwbxHJjzYOMaO+ixocVKgiK6l+kk75uehhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=m2Tx15Tv; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-346a5dea2f4so182894f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 05:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713444234; x=1714049034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=32JRcAZ8LHhKBfsqOJDGu3ZSnqgwx85ZTFPgD6hMyrs=;
        b=m2Tx15TvdFRjHOdqyJyX67kMDKVBuysCC/o7Fc9xL4ucSvqrtNxR4vZRDWYRbobUGn
         bLdFWiuGaWdEo41pwwa2YLmKM+RdWZ3DXUQxl0kTRJpZrf5R+UeEKp1SCisFyZjSyHgJ
         qgrdEIO02UcnfX5osQXMANFnB0X1WEyATveHyhPHLMXnwoMCE6PhHNY71HivWRzEjxrN
         E3lwqTgFApDl2uHX3k9u6Zxb/mf34ndDFdxZXIMfFAPvk5dh79sByNmPYnVpEmgF+4t7
         NkJB5+jU3wUJojc/JesjaejkSlKV6V4HD+tFPJtt6RDgyyZxjLBScj0AT75/KIr0RJjj
         icKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713444234; x=1714049034;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32JRcAZ8LHhKBfsqOJDGu3ZSnqgwx85ZTFPgD6hMyrs=;
        b=pXNrAYRdr30V/Gq70A4rHEaQRIlHO4YuA9EfCbSGbCh8ZElUfVI99vNhQ66om75jDn
         WDjNy3dkmJrFDnV7QOc2HAckUYMQ4wzEE5c4waf7C+i/8ncUUEoadXF1Hd6nd6mMGibe
         0TG2zNJgAk9ehNj+7DhczxCc67hPbAp2agtEHJoN4ytZ3rKNXDDjAeYO+XlQG8u5oVTP
         3NoMX7kBEvxMRqu+kWuWjGmKT1lkxfgydd5lkWJLGHos0OMAjaCBAR3SfQVjOy+Q7il/
         0GJe3qYHyprV46VFugJP58lUy6AAB+R/WTrs3USxDT3/QiuV2cFUg5fDIq84lQzZpDRk
         7xbA==
X-Forwarded-Encrypted: i=1; AJvYcCUYOA7HFv66eEcQW/VxO1FQEs7GyCmL2oM7bbJulX92xYYV65eB42K5/UyrRavEQvIivAeemut3B1YYUfz+iZxVcqDs
X-Gm-Message-State: AOJu0Yx7OTamO32kP19qxEV6OA850Teof2+ldeHzLzovVDwRSHs0wdQ/
	yXZqmdXWoZ2G9zTKIObLYUDVPF6xQZydOOhw9IaKHR6vTcqGJA5mXg+jSjoZU6w=
X-Google-Smtp-Source: AGHT+IFziCRGNRnIuKdQWAYceCQlX3IZZXZCOpe0+zYvs0VTpiLEE6booy5ASHtPCGw5+ceQDaJ+5w==
X-Received: by 2002:a05:600c:1c91:b0:418:9a5b:d51 with SMTP id k17-20020a05600c1c9100b004189a5b0d51mr2042383wms.0.1713444233704;
        Thu, 18 Apr 2024 05:43:53 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id bi18-20020a05600c3d9200b00418d5b16fa2sm3373412wmb.30.2024.04.18.05.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 05:43:53 -0700 (PDT)
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
Subject: [PATCH v2 00/12] Add support for a few Zc* extensions as well as Zcmop
Date: Thu, 18 Apr 2024 14:42:23 +0200
Message-ID: <20240418124300.1387978-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for (yet again) more RVA23U64 missing extensions. Add
support for Zcmop, Zca, Zcf, Zcd and Zcb extensions isa string parsing,
hwprobe and kvm support. Zce, Zcmt and Zcmp extensions have been left
out since they target microcontrollers/embedded CPUs and are not needed
by RVA23U64

This series is based on the Zimop one [1].

Link: https://lore.kernel.org/linux-riscv/20240404103254.1752834-1-cleger@rivosinc.com/ [1]

---
v2:
 - Add Zc* dependencies validation in dt-bindings
 - v1: https://lore.kernel.org/lkml/20240410091106.749233-1-cleger@rivosinc.com/

Clément Léger (12):
  dt-bindings: riscv: add Zca, Zcf, Zcd and Zcb ISA extension
    description
  riscv: dts: enable Zc* extensions when needed
  dt-bindings: riscv: add Zc* extension rules implied by C extension
  riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
  riscv: hwprobe: export Zca, Zcf, Zcd and Zcb ISA extensions
  RISC-V: KVM: Allow Zca, Zcf, Zcd and Zcb extensions for Guest/VM
  KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test
  dt-bindings: riscv: add Zcmop ISA extension description
  riscv: add ISA extension parsing for Zcmop
  riscv: hwprobe: export Zcmop ISA extension
  RISC-V: KVM: Allow Zcmop extension for Guest/VM
  KVM: riscv: selftests: Add Zcmop extension to get-reg-list test

 Documentation/arch/riscv/hwprobe.rst          |  24 ++
 .../devicetree/bindings/riscv/cpus.yaml       |   8 +-
 .../devicetree/bindings/riscv/extensions.yaml | 124 +++++++++
 arch/riscv/boot/dts/allwinner/sun20i-d1s.dtsi |   4 +-
 arch/riscv/boot/dts/microchip/mpfs.dtsi       |  20 +-
 arch/riscv/boot/dts/renesas/r9a07g043f.dtsi   |   4 +-
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi    |  20 +-
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi    |  20 +-
 arch/riscv/boot/dts/sophgo/cv18xx.dtsi        |   4 +-
 arch/riscv/boot/dts/sophgo/sg2042-cpus.dtsi   | 256 +++++++++---------
 arch/riscv/boot/dts/starfive/jh7100.dtsi      |   8 +-
 arch/riscv/boot/dts/starfive/jh7110.dtsi      |  20 +-
 arch/riscv/boot/dts/thead/th1520.dtsi         |  16 +-
 arch/riscv/include/asm/hwcap.h                |   5 +
 arch/riscv/include/uapi/asm/hwprobe.h         |   5 +
 arch/riscv/include/uapi/asm/kvm.h             |   5 +
 arch/riscv/kernel/cpufeature.c                |   5 +
 arch/riscv/kernel/sys_hwprobe.c               |   5 +
 arch/riscv/kvm/vcpu_onereg.c                  |  10 +
 .../selftests/kvm/riscv/get-reg-list.c        |  20 ++
 20 files changed, 394 insertions(+), 189 deletions(-)

-- 
2.43.0


