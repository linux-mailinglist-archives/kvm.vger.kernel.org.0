Return-Path: <kvm+bounces-45470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A5BAA9E42
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 23:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 882AA3A8B2C
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B20275103;
	Mon,  5 May 2025 21:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TwAzgL1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5C270EA1
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 21:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746481180; cv=none; b=TjvD0euKnURleeVlFVpzW2nnDkrV+LtdnOiBx4HCHXzSfbv2vOjZC6aXNZJaUt5wWbQYsvm1mxFTXnwAyMfaa+aURjvu2hzeUWKZfANLYNkfUB2QlWV+Bfc3lpc/Su1BHZm60YHStn50pN0Pfa3KHyIhK0kT4JSFdqJlcCeoteE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746481180; c=relaxed/simple;
	bh=JdUrIVH+IGCLd13BCkYc9KzQyFYTnCzlSPf84de/Rhk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=okR8WdSqfMMcSVnBeD0nabf/wAZBblrLiKMkZd8ehX4NfUTP+2BZg64P4IRt5LKtMPmrfJDJm8xx8r92mBqIf0CldZOd8Z/95LKgOpdOROOYwZbM3qLUi6GwqcHcXwiKFhFHlLeE6AgPgFr37xQ+HTzcOP3Sna0r1WEqYwMG+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=TwAzgL1t; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-736b0c68092so4345398b3a.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 14:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746481176; x=1747085976; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W99fxoPhbzUqm7Gk7SdB4XI9Zg/UKYP4CZESDkaON8c=;
        b=TwAzgL1tc/a1VbIHXARJY69NyqrollMt+3Qtz1mKXgvbZ052I20xKNh7qM0eV56mvM
         b/D3jpKWgHs84ndPT57/U5+JA8X6+lc6K71K+HAEUlJQJowmdwkciAoBUhsRS0FfCox1
         FaPz/lYbkgpQP6LsilDciOr7Pgnemb5xxcWFAiNj8jp3im0t8iqpLymwJ0peHroFXLTF
         wb7T2Ir9/xE+wiK/qDG8UCJXlCtPjQx7DCU0G3KntSEWo6pkHOG57C//6TvpOq5fLP7w
         9GTGJrMi387hp45fzSywChRD8Ug6StAOV6oYZnzOPRmoT/h+yqDpOb2ubEtB5Zh0CzRw
         S5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746481176; x=1747085976;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W99fxoPhbzUqm7Gk7SdB4XI9Zg/UKYP4CZESDkaON8c=;
        b=Kzp/JcvX1LfFwtnIEUvQ+Zib6pEa1ewOZd+2vVzZtQ/bROGhu5nQ0i/RUHP30u4iU2
         wmpyd7qbgmVJ1dO1DpkA1Y0EkIm+51w2znwk0d/K5g4RA0JzRbbd6MalH0YD/YyX2+pI
         TLb/qqTrYDfVAIVTjOBi8cqYdJ1aFlyB8JbwucAQOjqxb+nHelbOo30+oE/hArlbi/kt
         0k194gZrynrwmCY28/FcsZoXiHmWYUoaPBFb0Q9IMKlVb1GfI/SfbRkjS9LYjyXgkO+p
         QJRZQW/+Og49lTo41PP2JvLXQ3ricHB2XaaBbwbH/3n/0XS1lSNRGXK6MlvT75RzAHeP
         q5tg==
X-Gm-Message-State: AOJu0YzNsDuBtwdMVJq3bQUGZboED6uVETxCrpCcc+/gHU37ZN3P3wVo
	8Wu/T6Jv5le/L1m66AYr5AbUAQS7fJwM8sHjCRTmJEB1hrfsqjxBBGFgebS8/2A=
X-Gm-Gg: ASbGnctirf/XfGHGNsSDdgJydPCEwa3YmZ2HTtYnGlvdO9o1aZhOKesMk90jOw+akfN
	BBAdmNNtZAwLDPww7L6gtfScUpdZ5MpzFPU4FWqfdi6mImWXAn4D1KxTecSy+22mNt2GPLgga6F
	VuMohYVwF/Y9+3sl5EZ56yAqaMsNhV/CGzN584oqct0TYrMpYyCKBLkJWCAU9OxewwDBYp+4bP9
	1jVD8bR/5mEZMZTlQjmV4Wp1IvX51q7NtAYmilvg/7gGuowuGxDQ9Uv//2PglV2xfAQwW/2pgbb
	K0bFRAfci/DAk4cotApM6aELYs0irebfaL5hgp/IvZQF+yykci3OMCCSxMgsT/7X
X-Google-Smtp-Source: AGHT+IHJOxFm989TcbBZBaCDwcCJ9ebhtRuxodDiEdghNVUEU6LdMQk0DXZ57fAxwh3qFk8n0Wb3MQ==
X-Received: by 2002:aa7:9a8c:0:b0:736:57cb:f2aa with SMTP id d2e1a72fcca58-74058a56837mr21134021b3a.13.1746481176348;
        Mon, 05 May 2025 14:39:36 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058df12d8sm7388599b3a.78.2025.05.05.14.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 14:39:36 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH 0/5] Enable hstateen bits lazily for the KVM RISC-V Guests
Date: Mon, 05 May 2025 14:39:25 -0700
Message-Id: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA0wGWgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDE2MD3eyy3PicxKrK+NS8xKSc1PjiksSS1NQ8XWPjZIvERMtEYwNzQyW
 g7oKi1LTMCrDJ0bG1tQD9GuCEaQAAAA==
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
 arch/riscv/kvm/vcpu_insn.c             | 52 +++++++++++++++++++++++
 6 files changed, 154 insertions(+), 11 deletions(-)
---
base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
change-id: 20250430-kvm_lazy_enable_stateen-33c8aa9a3071
--
Regards,
Atish patra


