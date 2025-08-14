Return-Path: <kvm+bounces-54676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B96B26BCC
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 18:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7174DAA7A01
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 15:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4DB423B60A;
	Thu, 14 Aug 2025 15:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OPd0CK8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6237260B
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755186961; cv=none; b=TfFNfre9G2Ajxltycow8LfvKozHqgQmPxKkVEPGYWiu2CrgWt8DnrZICCRJqMYarJOJxMp84u4+DuhUSzQ7TNhB8E5xb8Tqp2I0SfXFXClBrMBwB6/hU39+FVaiT4NCpWhg8kZwGuO0n9e9n4jgYAhhsIsdPLhsZZVel07K9seA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755186961; c=relaxed/simple;
	bh=70C+wR2OGyGwLPTOfQiAUvSVN2h1Wr8pPgkJs2xIVQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PkaLH5p4pzpmQlbuZv7uP2Y5+3FsNqL0KwmqBIUtIdaZpPe8znObR3tDknl5lpsdndKuD/f07GvG3sydvIRarOgrurecs8m6+PVBZpWCMlGmKnJqFB4UdJ1CHvdfhOiIrCQ5n/gj+lKe6biLGZ4f7Y/jgdATdjnhLBikXrJvaJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OPd0CK8Q; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4716fa7706so782201a12.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755186960; x=1755791760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fbS0SnSfDCYNteBkAugCZAVezW6wYeQqbL6j1Y/9w2o=;
        b=OPd0CK8QfxBK+Iz6vzDibyRg7ZuChu7DR7rK//4Nv/RQ7qolecyzOubtoE0nRYJc+6
         0anEDeZUj1/te+RkxC7ZxzVPkywOZomjdMdVPfNRgnRyBKmve1A1/GlVbIgwfwWRu01e
         yUySYWUibjQyQJzjCbDjRm4tNXOinbAJEbrpyimTBWOBOddOSfrpvha/oGbLkQ3aBaMw
         zeG9BbhoCztB06JfUJ9XDQo6CSI1SNFaFDzS2SfEUb0QZYOeY6jdUP0DzHdsyID/J5WW
         QkhwxZ661DDUTWdQ4mUzhu02f/vfG5p1hdV5XYvemC2Dl6jhAyy+aU0bbnjXRZYjJl4p
         TltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755186960; x=1755791760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbS0SnSfDCYNteBkAugCZAVezW6wYeQqbL6j1Y/9w2o=;
        b=B7CizJGYKxke+tUDAaQsm43qUbuMz/3IxiglhGEbUe/XpMRaU6rck9IiFJkfhpZdLj
         4yb9wVMH0s2xIxYFcdglspszbWsOto1Zh08cyC6aiv9O5y3w84iAkOPtIiE6kerI8OV5
         1LfbtRCVyicFxmGuVm+BeghgiYjihf6q3hyXK3ile2qOq0xQn5VLDq0k2uaAaApLwhpN
         1KxnrkcaXlAYnUSE9bxLt9NZR5tASTk7breDg1WhfIhfGXsMXfVghWZGIUfSNDeW0K7G
         socZIwXurCk0XrnADrLeZgeXMWIZHhrT1cETecLHuHjUXeUSSx6+deya4mmx2RFBmJq4
         DOxg==
X-Forwarded-Encrypted: i=1; AJvYcCXzmhBUTEq5XAPdEnn678Qbuf5j9lKJLoC/GN16uVx0nVbqIMyKTdj3l4tQgb67wpttOjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIsuY2Eyk1fJOC1jOAC+N8egIwCBPYLULEuefgD/g3dInexCr7
	DxadzfD8JagGO8/+atAIfgH+oRZQWmONVl4+V7m33YUF/oICpmJVh2JaEFgkXZ4QpXM=
X-Gm-Gg: ASbGncs0rL1+tdiOSdabrIKxghYZRpFBxjoqFhSm67bn1NiyWSSC1WsJF229yywV5h+
	+19nmJNi0O4pH57oCeTeoLt2jiEhp6UxsmT+GMypw8P1Y5b6yZa8nVA1DOfRtJjgaCEY8nnecME
	Zk9JAriFUDaWkpJouqcWGoDtlu5xUnAsE5OiwSAR/ihm/7z4gSpt/rMfAMtfik0lqm8lkEr/TUA
	MDXEpHQBYdfGHkhL8HVnxgDG+S3O1smfdC5KWmFBVn4PCH7jM+IQtQUzpUf5suCLZ4bY7mq+Ctq
	/JqdeyA46NZKdYdUmbNG3wu8cvJXmfINfPEqRXPcjHQM4kJ8rLI6JwakYaL8w2YtKA/hXXepjnj
	khKOVYgtOul2GAJy6CFcn2/pPevTSxBpCy9JqGIB7RqWOPeS5PJ6Llil1O9VP6A==
X-Google-Smtp-Source: AGHT+IHiJ/C+iotNnCA3DhU4+fNK2fePBsmUyymIcxaNYom/9E0Z1/NWwsgFdX4eBUWW/qEOqDpszg==
X-Received: by 2002:a17:903:1a30:b0:242:fc4f:9fe3 with SMTP id d9443c01a7336-244586a18c8mr55450135ad.37.1755186959600;
        Thu, 14 Aug 2025 08:55:59 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233108e1d9sm2225500a91.29.2025.08.14.08.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 08:55:59 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/6] ONE_REG interface for SBI FWFT extension
Date: Thu, 14 Aug 2025 21:25:42 +0530
Message-ID: <20250814155548.457172-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds ONE_REG interface for SBI FWFT extension implemented
by KVM RISC-V. This was missed out in accepted SBI FWFT patches for
KVM RISC-V.

These patches can also be found in the riscv_kvm_fwft_one_reg_v1 branch
at: https://github.com/avpatel/linux.git

Anup Patel (6):
  RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
  RISC-V: KVM: Introduce feature specific reset for SBI FWFT
  RISC-V: KVM: Introduce optional ONE_REG callbacks for SBI extensions
  RISC-V: KVM: Move copy_sbi_ext_reg_indices() to SBI implementation
  RISC-V: KVM: Implement ONE_REG interface for SBI FWFT state
  KVM: riscv: selftests: Add SBI FWFT to get-reg-list test

 arch/riscv/include/asm/kvm_vcpu_sbi.h         |  23 +-
 arch/riscv/include/uapi/asm/kvm.h             |  14 ++
 arch/riscv/kvm/vcpu.c                         |   3 +-
 arch/riscv/kvm/vcpu_onereg.c                  |  60 +-----
 arch/riscv/kvm/vcpu_sbi.c                     | 172 ++++++++++++---
 arch/riscv/kvm/vcpu_sbi_fwft.c                | 199 ++++++++++++++++--
 arch/riscv/kvm/vcpu_sbi_sta.c                 |  64 ++++--
 .../selftests/kvm/riscv/get-reg-list.c        |  28 +++
 8 files changed, 436 insertions(+), 127 deletions(-)

-- 
2.43.0


