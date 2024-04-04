Return-Path: <kvm+bounces-13522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5B2898518
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D83801F24D9C
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 10:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3545823D1;
	Thu,  4 Apr 2024 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="m9/oW3Kj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C1B7868B
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 10:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712226868; cv=none; b=bz1LWmA4e56rSPkJaj8Qj3LH2DEFaVpbdeE4NNrLOv5wYT/WHCJ7UrGCp7uN07k+o7dl762/9ajxevpCjGr+nulwx04Ughs98X8iJishKqkmRhLn9vqO4fkMfVrIvqtXANkpHEPo8agNi4/wY4Q2LojS6Hq/YFO5nR7H6+x9px4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712226868; c=relaxed/simple;
	bh=2/q4jfOj6U1einCYXJdHvK78eAQ3vHaYbSRzBTdpsBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SMjW2XeraPYuAhIhKSrzu+8B9FDdMT8EjH6EBmc01ewbLihNApGmOFzM6+kCUMLbOIOT3HgnXEE+YTdb01/4S7SWBSLEBCNFphMPNwwVUqeRqe1Vwo4oJFwXLrwkuX0SIK9x9yWTy1kVEvmncnmP9Mic28W4xn7AA+4btJ2B9nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=m9/oW3Kj; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d82422d202so1477231fa.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 03:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712226863; x=1712831663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h0yWpEBMuRREaN4Rfpr4/p3Cbe2kX6z7SdkYvYffV00=;
        b=m9/oW3KjpOr27N9nfPPmNzaCEB8cK9KH3zQA+Xy7uidbef5hRIvmfyD1u9Y06YStT+
         BzPXWgetDznouQS8INkOz2wS91EWVtiApc5C1/l5PhRXvJhKI4+/+kX2gqDhpRIJrIi5
         HUeipZ+CFkuPtDzHlw5I4YWsYBMydVUwnJ7UKmE4RH4HjmQIw3TDdx0uXM5vnB8NA+fv
         nT1CCzOP+mdWKaAxpx6Wo5GWFhLq/TeKDcxbUXNkhuR/f5k8Iwa/RQKndW1+aKlQ6Uum
         DkdXKyrZ14urAGlK7qL+nAvTTf8kZEwT+BF5nAlk8WypzhpmTcwnHa4bBu477jftqZfc
         ZArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712226863; x=1712831663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0yWpEBMuRREaN4Rfpr4/p3Cbe2kX6z7SdkYvYffV00=;
        b=QOtKYXg+nBJbdthiHHjJ3C4zVjlorCQttcHSQrwbEcPjFXEE6lu6ueCzFLpEMmRDtD
         BwCCQALNGZqHqfnn4vA+z67vSpXVdGsHRO5zHpmNfg+KD8WbFNcpewengM4g9rn/Og4n
         x8BarwfbIVp+28Tg/B9SvW9O4c3lK8UhoOU5CN968jy5dNTdlXMFpGNz3CFQBqFVegGo
         G+jfAetf/w0mv62v3ar2Nz8X71tBDzIFM3IGw5Rkk2Yb0gFiM4v1E/7vN4XwFRd3s2PZ
         0PUf8CoxIa/yiRzoOUs6h/rl2fDT43CSir9MtOuS2YJMoFj6JlyJqCuZSSaZH1CfOXmM
         sdcg==
X-Forwarded-Encrypted: i=1; AJvYcCUo2rW4eAjiy/d8mCbqGpLUHRMbIwLvJqnBmVCDZ4jQ/R/kX+D65XDdbk/Jwu36fAtYfnrkIIgpyEa1Jmv5bAqU1c9E
X-Gm-Message-State: AOJu0YzSxm2YaDv9CZqrVKBXr4Nxwmn/7OBHXxoMgutsTnnJ3uq3P/Mp
	WReDgmi2DIIikEnzns7V4k7diHeAoa/1nRDbK5TJXf7yWJB3zwdeBR5wv1f3nuDye3IsjWtJElo
	P05k=
X-Google-Smtp-Source: AGHT+IGgwXcPXNss81WaNWWIVnkPiMwtrKqgSEy7SDtHw2OIS4sQFnmrJ6LWngbeMCuWYCY0SDTSXA==
X-Received: by 2002:a2e:99cf:0:b0:2d6:c59e:37bd with SMTP id l15-20020a2e99cf000000b002d6c59e37bdmr1469136ljj.3.1712226862690;
        Thu, 04 Apr 2024 03:34:22 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:555b:1d2e:132d:dd32])
        by smtp.gmail.com with ESMTPSA id ju8-20020a05600c56c800b00416253a0dbdsm2171340wmb.36.2024.04.04.03.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 03:34:22 -0700 (PDT)
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
Subject: [PATCH 0/5] Add parsing for Zimop ISA extension
Date: Thu,  4 Apr 2024 12:32:46 +0200
Message-ID: <20240404103254.1752834-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Zimop ISA extension was ratified recently. This series adds support
for parsing it from riscv,isa, hwprobe export and kvm support for
Guest/VM.

Clément Léger (5):
  dt-bindings: riscv: add Zimop ISA extension description
  riscv: add ISA extension parsing for Zimop
  riscv: hwprobe: export Zimop ISA extension
  RISC-V: KVM: Allow Zimop extension for Guest/VM
  KVM: riscv: selftests: Add Zimop extension to get-reg-list test

 Documentation/arch/riscv/hwprobe.rst                    | 4 ++++
 Documentation/devicetree/bindings/riscv/extensions.yaml | 5 +++++
 arch/riscv/include/asm/hwcap.h                          | 1 +
 arch/riscv/include/uapi/asm/hwprobe.h                   | 1 +
 arch/riscv/include/uapi/asm/kvm.h                       | 1 +
 arch/riscv/kernel/cpufeature.c                          | 1 +
 arch/riscv/kernel/sys_hwprobe.c                         | 1 +
 arch/riscv/kvm/vcpu_onereg.c                            | 2 ++
 tools/testing/selftests/kvm/riscv/get-reg-list.c        | 4 ++++
 9 files changed, 20 insertions(+)

-- 
2.43.0


