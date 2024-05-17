Return-Path: <kvm+bounces-17617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FEB8C887C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 181B5287245
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF7B6BB4A;
	Fri, 17 May 2024 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="uDRAJlKr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69149612D3
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957600; cv=none; b=ZiMdLnLRtRNnep57OOpNgAsl6HGdE6g9WrO/wi+7K/UesmFqjekcp1ojBI5MrgrR00EVnLNChGzL22zw6LXRxuwzq1WOGAS0liWrrA6onJ/9wb39zGGIQbIRnitvAHn8Uf+mvyM4mGBzkri1IwnhKsddDBeRS5SN3Djxqt4uyD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957600; c=relaxed/simple;
	bh=11tFZYMuDAVi+4LdOZqevmF5dxJsVBfI1xfm/Sl6E5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BjVo+Qi7347qEDRNrh7MUm6y4YvAzcdF+ApiAnhfyi5yYeScsya8SgJPgwDCvI0+bOjDZS7EhajIJHUTsGWQz7KcyVzt5tY74TNwigGM1ex/F5POxhGbrL4ZWbKCWz1Xd2inqqV9l03KoQmCIMOOPMbZhYF4oR1qPjwEFNJ8dFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=uDRAJlKr; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-420197fba0eso337385e9.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 07:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715957596; x=1716562396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MBxnVnvMYgrOz5wGG3XSCFV37Hy6vOq+FURf3O2sV60=;
        b=uDRAJlKr5Mb2MqFY26e+MkN4P2KElvhjOixy3rEUUpYyeTh4FTW+rAD9FSpFIAbehY
         NMfO0vPKNC7vqimVLaJeLDMebzpokanOF25MSCoisdfqgkZUt6hMKdxiRJwBcgSVDN3P
         c2JLufSk3SU2w+ibAiJ1x1TJp32z2c/9VKnIr3dQ+06Fj+jTs/hesQ9Q4IAxs0Qfa5BQ
         H5pfLwh3PO3HHOthGIJimaKCJHEIymsgfvPftfpqfW4OT/lIxRqQIMQIIGiBrIZdhpC+
         vDjFMk9LYUXxVOtYTCRO2VKUwnCDkOPLdVmDhI1Go6si4MTj4/zC6kAE70MF82irGiVJ
         7D1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957596; x=1716562396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBxnVnvMYgrOz5wGG3XSCFV37Hy6vOq+FURf3O2sV60=;
        b=hoT3ICdqDYrWk9dFXeBudRdCgrwNHsHpU2lekcQlJahY2nizohx/L3NySzabXhdiuD
         a5750oXo1il8g48ErDovvacljGPgIh9RBvx2tBcc5eQVqsg7lu3JnZeSFubTU3858HXx
         +HepO1vQL3azKfqMROF9AfgiFzEqSks8BIqQ3MrYyMBwVBMuusV0F8oI2wH4MSU8Xjod
         nNRp/2v6+2ZMxMlBt81yRtE0iPNFkuhrcZQUz5zDMXICW+TdYlBFp7GR9O6WcxALXHiA
         cDrIiAcTP+7V/dSPXXKYJQ+MwAQJ13TbHEyrv9ZgycyrJEif04rKnyjGXR5CC76hHSD5
         BP9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCN7taLqfiBnyve1CHf/mhHP8UYQFe/LUNY8LXRNH2uBwnPS6EqSbCS+rwjkFZpy/SYahl45xhPlfe5GzyDXD0nax+
X-Gm-Message-State: AOJu0Yx6GeP3mPAoa2A/VUK2fCfmSHufH+U9SmI/6dWFQn4MKHeajAKO
	3iSgzdoxCteee0bnUYVxOMKiLVEoXGUNpz37bYw1G2v2PG6ZGcz3DkSe7PbbmX0=
X-Google-Smtp-Source: AGHT+IElTJZHwS4R62Imc5G809nVY5XtS1QeDbXqWpbZYtlvSrsfuUs8xxpZzJsOl058opK+T4g56g==
X-Received: by 2002:a05:600c:3b0a:b0:41a:3150:cc83 with SMTP id 5b1f17b1804b1-41feac59d8emr162018155e9.2.1715957595750;
        Fri, 17 May 2024 07:53:15 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:46f0:3724:aa77:c1f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41fccce9431sm301723695e9.28.2024.05.17.07.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:53:14 -0700 (PDT)
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
Subject: [PATCH v5 00/16] Add support for a few Zc* extensions, Zcmop and Zimop
Date: Fri, 17 May 2024 16:52:40 +0200
Message-ID: <20240517145302.971019-1-cleger@rivosinc.com>
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

v5:
 - Merged in Zimop to avoid any uneeded series dependencies
 - Rework dependency resolution loop to loop on source isa first rather
   than on all extensions.
 - Disabled extensions in source isa once set in resolved isa
 - Rename riscv_resolve_isa() parameters

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
 .../devicetree/bindings/riscv/extensions.yaml |  95 +++++++
 arch/riscv/include/asm/cpufeature.h           |  26 +-
 arch/riscv/include/asm/hwcap.h                |   6 +
 arch/riscv/include/uapi/asm/hwprobe.h         |   6 +
 arch/riscv/include/uapi/asm/kvm.h             |   6 +
 arch/riscv/kernel/cpufeature.c                | 244 ++++++++++++------
 arch/riscv/kernel/sys_hwprobe.c               |   6 +
 arch/riscv/kvm/vcpu_onereg.c                  |  12 +
 .../selftests/kvm/riscv/get-reg-list.c        |  24 ++
 10 files changed, 366 insertions(+), 87 deletions(-)

-- 
2.43.0


