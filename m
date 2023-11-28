Return-Path: <kvm+bounces-2631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 875647FBD7B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E256CB21C1C
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B455C086;
	Tue, 28 Nov 2023 14:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DeB5o+Vu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96581BCC
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:37 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cf8c462766so39963665ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183397; x=1701788197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qApon/WYFGnryV9MyIIHISCC8QpWn0HWfbXOQ5ylTxU=;
        b=DeB5o+VuY8oVOCXsuE3e74Xqt4haTkwAcZkYSsQpB1qz4h278TxGNdZICCz3MZngcN
         BjXqs50tw+FKNxjU9T+Xon0A+gSj6a64otRpa75wdq5ohkzk1V+qGht33vongS5tmv+y
         IqaEFd5+7KSZINazspjqWwwVsNHpZYibM5oQrJ1RdENByDRwTTsOO6Mx20FFd8tFf3j/
         DDoP1ymMJzx6/JF1/UfuyjG92ZUfgRy071s7kKOW12jp47nCqYzTdfBdKkyrTfMwhlH7
         cJtnyZy2Y8apAjUnK4EzuQ43VgiuS5pqzU23A269scNusyseBHN9yCLcf3kbgXLl81FC
         ZpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183397; x=1701788197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qApon/WYFGnryV9MyIIHISCC8QpWn0HWfbXOQ5ylTxU=;
        b=NKpE5bZtCB10kY9dF66JOrb8aQHouq9K9UbWhf7gy4QmUmZcQMI8V3gcQxAY8S25kz
         +HGHdpErDi9TxSO3thjDBHx2GXcAsjZv29s5Mrz8ug5OeJYAFRL0XuUjWRXda51em7g0
         mGorMmAsSJCWg7sqHzrx/5tjFYrJjeDK+SBsg2KfcLF2ZFWRxJZCYfR56hzGobehXevh
         NxT1zGcTsO/3IT1a8acwgbqxjUrml4+1qum5PuD9rtc+8xGJsYOa6ec3vSaOFe1hJVJ9
         U6vfX8jaOq/yazX/zgOBl1B7D95ayUtjxlGUNaxWz5MEfz+up8eoZXMUokIeK/FQM96G
         QGtg==
X-Gm-Message-State: AOJu0YzjR6TWAvxCaJwgHihU3rqXzwfcW05oCInua2Tn3RIc1hi54WXs
	UzMuiqI3mwgOnwt+atU64CiE5w==
X-Google-Smtp-Source: AGHT+IFeX/wWXXnRpNou05oVLFzgPUXOys5/zlIGODZT76xLUuo+UO9+hGXi1iq+++RQaHPlbdu/9A==
X-Received: by 2002:a17:902:d301:b0:1cf:f3c7:e078 with SMTP id b1-20020a170902d30100b001cff3c7e078mr2876633plc.64.1701183397109;
        Tue, 28 Nov 2023 06:56:37 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:56:36 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 00/10] SBI debug console and few ISA extensions
Date: Tue, 28 Nov 2023 20:26:18 +0530
Message-Id: <20231128145628.413414-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for:
1) ISA extensions: Zba, Zbs, Zicntr, Zihpm, Zicsr, Zifencei, Zicond,
   and Smstateen
2) SBI debug console (DBCN) extension

These patches can also be found in the riscv_zbx_zicntr_smstateen_condops_v1
branch at: https://github.com/avpatel/kvmtool.git

Anup Patel (10):
  Sync-up header with Linux-6.7-rc3 for KVM RISC-V
  riscv: Improve warning in generate_cpu_nodes()
  riscv: Make CPU_ISA_MAX_LEN depend upon isa_info_arr array size
  riscv: Add Zba and Zbs extension support
  riscv: Add Zicntr and Zihpm extension support
  riscv: Add Zicsr and Zifencei extension support
  riscv: Add Smstateen extension support
  riscv: Add Zicond extension support
  riscv: Set mmu-type DT property based on satp_mode ONE_REG interface
  riscv: Handle SBI DBCN calls from Guest/VM

 arm/aarch64/include/asm/kvm.h       | 32 ++++++++++++++++
 include/linux/kvm.h                 | 11 ++++++
 include/linux/virtio_config.h       |  5 +++
 include/linux/virtio_pci.h          | 11 ++++++
 riscv/fdt.c                         | 57 ++++++++++++++++++++++++-----
 riscv/include/asm/kvm.h             | 12 ++++++
 riscv/include/kvm/kvm-config-arch.h | 29 ++++++++++++++-
 riscv/include/kvm/sbi.h             | 14 ++++++-
 riscv/kvm-cpu.c                     | 57 +++++++++++++++++++++++++++++
 9 files changed, 216 insertions(+), 12 deletions(-)

-- 
2.34.1


