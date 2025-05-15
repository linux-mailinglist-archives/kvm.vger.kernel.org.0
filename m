Return-Path: <kvm+bounces-46692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 369DFAB89FD
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 16:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB92B3B86D8
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 14:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23171FF608;
	Thu, 15 May 2025 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nb8FvDGj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B35C204689
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747320777; cv=none; b=aKXg4i1IOI7zVusCgirDbpAElZVUiuMBX+wZK/zh9Ge796/nmXbiV7lFrwAhld2+a1k8bxMT6b9D1zLhcnO5yPL3jSwtYg6ohpbAO/SJJWpZr/1DTLRMxXC97riEcSwJdq2Zw1dRzLm8CEw0HOFsDnIqu0y/q5Y4ocfjT0jDTr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747320777; c=relaxed/simple;
	bh=xj+JA/L1cw6HkMAFASvz+qsdhcu4e/coBRFvJAESILg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ilQ7/Qw51ZuRNNQVy8TZIngZhn+vEl0QMDLnwDBJ2XZZbuVTWpq+Fv7eWK2fOHoSf2aNLErDOjVRrrmZ9mlTbu4DvCs66uKaLnwl0NKW5SUvQdsmb6vF52AQe9r1BseH7GCRy/CdHy5goiVcyoCCZqsl5s0wIfOTWyEGbRNbFyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nb8FvDGj; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cee550af2so871955e9.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 07:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747320774; x=1747925574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JBNMBVMfrCwOqVA/j6iAZ2xlfGUT5Oj6Dz/mC6Rjl5s=;
        b=nb8FvDGjyZ0KM9ff4KGMrpbMnydBvmWHRSQyvqMZXAQQOvlp+ZdhQB9ZW49/0fAOjK
         ApH6Lp20ZXHSXArzwRx9pOw09/WC+9dZ0tGkPYJ2ouWMFvvcMmQPHGyQW4IP1TUr4WfP
         spK8OekI1L1anmzweWVVo+DIOUGJmFWwtcVn0DjhSdwSmF3QELF6hXV8B56VQTppSS7i
         NlxESGVW60HlhGzd77rz8eFk9d825MViGpVUdyta4C+meMwJulnyvkZksSZnZ0yGx5by
         NMVcxYji4EtOj6qekPg8qUgESRvVbo3iDtz3X6P/tiYlKBSgs45W2OuflqU+KNqu5rY5
         Terg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747320774; x=1747925574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JBNMBVMfrCwOqVA/j6iAZ2xlfGUT5Oj6Dz/mC6Rjl5s=;
        b=nf2OsHecBY9bylU8nw4MB6Y+OpLZ+niz1CffP3BOmk5nOLgg2TN/7BiMz3OuxwRRnK
         5HfZqrYp8zWAgjReq+Un4oWsJEEWY1elIwMHFmllnD+lVNMN7PM0Xl43nvUNMBmZ3+rR
         IHzlwSZsSDLGA2EpvBgeIXZAoM63e500wLtN5kojKq5CVpidB6NSMHiomNG+CDJnmgqB
         +2M6SFvPY9d/kFCEZ4sKhRvp5TkrHEEN83qWnYY8pjKrTeyOhgG0Jr7+rHMh+o9UQjGX
         5JPFhxxz15ISv+MaYZ0gPyZtAKSEAnCpr53vb2l9OcovjhMvq1ubv2St51eiffgeIx7H
         6hUQ==
X-Gm-Message-State: AOJu0Ywl9e8jj93WRxn4Jmee/72kWcFEoFrRl3ePaCzRecT/XUmr5VoX
	L3kPrklf7ni8k/VC63gupOzRB5+/lcoVlqo1aYT5beoipBCY8oYeWQWQzIXzwCE=
X-Gm-Gg: ASbGnctbx3iMQsT/DHHt9joATOBdCWWM1L0/87qEJF/PABLteyB7rn0UHa15jGmEFMx
	Y4IgnahdoGExPZgeZzrBEO/pNGt19cr1rOH3EvG1lY5TkQK6J3KvM0LHlKoK7AIuFWax6QFCy6d
	NIFiJhe1DnvNNUC3f0AGoXyJ1uXuJoHp0GvJCYc42NfiSqs9Sv4bBAjZPx8wMwmbB1as+RzFzBk
	byzZJUWhEEzDF3No7qf/x5gfACecURVdlQyfrkvsMCqmLBfZQf0VT8PMQFx0ZB53yX+MtZ/QsZu
	loUMhomaRXekkSMWyYSmqcBlcLSIxKR2cujy1sXcjC3Sbms6q8XLJCDP
X-Google-Smtp-Source: AGHT+IEjWdfaSstCa6WtRNHMXeY5NKPx+dlpO0u8cbQ+/wmwqBYSpQzl4SUc23EpyvhrjvwJhEHmXw==
X-Received: by 2002:a05:600c:1384:b0:43d:2318:ed7f with SMTP id 5b1f17b1804b1-442f1ddcf8emr28595905e9.0.1747320773678;
        Thu, 15 May 2025 07:52:53 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:59f5:9ec:79d9:ffc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f3951a97sm75040025e9.23.2025.05.15.07.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 07:52:53 -0700 (PDT)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
To: kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 0/2] RISC-V: KVM: VCPU reset fixes
Date: Thu, 15 May 2025 16:37:24 +0200
Message-ID: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

the design still requires a discussion.

[v3 1/2] removes most of the additional changes that the KVM capability
was doing in v2.  [v3 2/2] is new and previews a general solution to the
lack of userspace control over KVM SBI.

A possible QEMU implementation for both capabilities can be seen in
https://github.com/radimkrcmar/qemu/tree/reset_fixes_v3
The next step would be to forward the HSM ecalls to QEMU.

v2: https://lore.kernel.org/kvm-riscv/20250508142842.1496099-2-rkrcmar@ventanamicro.com/
v1: https://lore.kernel.org/kvm-riscv/20250403112522.1566629-3-rkrcmar@ventanamicro.com/

Radim Krčmář (2):
  RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
  RISC-V: KVM: add KVM_CAP_RISCV_USERSPACE_SBI

 Documentation/virt/kvm/api.rst        | 22 ++++++++++++++++++++++
 arch/riscv/include/asm/kvm_host.h     |  6 ++++++
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
 arch/riscv/kvm/vcpu.c                 | 27 ++++++++++++++-------------
 arch/riscv/kvm/vcpu_sbi.c             | 27 +++++++++++++++++++++++++--
 arch/riscv/kvm/vm.c                   | 18 ++++++++++++++++++
 include/uapi/linux/kvm.h              |  2 ++
 7 files changed, 88 insertions(+), 15 deletions(-)

-- 
2.49.0


