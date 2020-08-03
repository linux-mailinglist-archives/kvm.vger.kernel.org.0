Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287D423AC0B
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgHCR7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 13:59:16 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:64728 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgHCR7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 13:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596477555; x=1628013555;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VOtqlyeTI7pj/+WHRY84iOltoY1CldDSHk2ut6rF0TA=;
  b=ULxvTcVi1llcpnaSO40ak6Zvkze1vb0XTLevuyK67GidwfQfT3tv1yhm
   kiwhUowBxWIcNSOXB3LqP0e2JSUjYj8T9yH1sbXVkX/0HSQhdFi8mflYu
   KmT4uVaf13AcVOQdb1H8AhLeIenNJvO6Iv/caIS8w0+r414gMZqh+Ax71
   KVU7ob+N1vmlj5Ow5ytynOOztmN5TM8RMnL7/UMOasoluYX1xQk8WPiYJ
   TkD9t81eheeU//vSPzdok8GoKYTit+demOpofOIYIVZKCAqbctAfsfGaN
   YK19yn3A6v/Pi5sa748liv02OW+kmbZ+Z1Yi0LpmONXOwG/8UyLeYbIXr
   w==;
IronPort-SDR: oPMxDLwMfQHHOCpDbh1TynPUcKhbP0zVZDhIpHc9ZQaUKp5Uvt0zicWTa+VALzh2K1UiaTorSZ
 iGyLjrkO2pAavsidp9T0GlaU1ocdt2diK3Qv//pX2IMdpsPrYRrjy0e8xZzphgvoqZ6IHEn8wY
 1ltRyH5WoQ6k+qj2wQvTGHPQBqM5jAYG6I2xkvMuymmmZmT7DeZTTsmH7PsQzrIdYKxuBUWJlt
 I9mk6XbEsPGR7fvqXZndzoxONk0hwpkgBqDy2kj0/L3x8tbZ/pus9bCbA8a5r7Cgf2xqw+keQZ
 zok=
X-IronPort-AV: E=Sophos;i="5.75,430,1589212800"; 
   d="scan'208";a="144033180"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 01:59:03 +0800
IronPort-SDR: rmitMzpTBLuDNA1XJ/LlNY19nniyj4M68ST5vAlB0K/1mVnb9ubEMpML9H6BNkENh4F+xPH/n3
 Aami7WoNuM/A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 10:47:06 -0700
IronPort-SDR: iZb2sq5TmobDGkm1+xth6Z7qWVDWypo/WO9cBwNRRp0XCuOe4j67qj5bOnpyao4FekVWUgDZom
 eh4CemSsEC9g==
WDCIronportException: Internal
Received: from cnf007830.ad.shared (HELO jedi-01.hgst.com) ([10.86.58.196])
  by uls-op-cesaip01.wdc.com with ESMTP; 03 Aug 2020 10:59:03 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>
Subject: [PATCH 0/6] Add SBI v0.2 support for KVM
Date:   Mon,  3 Aug 2020 10:58:40 -0700
Message-Id: <20200803175846.26272-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Supervisor Binary Interface(SBI) specification[1] now defines a
base extension that provides extendability to add future extensions
while maintaining backward compatibility with previous versions.
The new version is defined as 0.2 and older version is marked as 0.1.

This series adds following features to RISC-V Linux KVM.
1. Adds support for SBI v0.2 in KVM
2. SBI Hart state management extension (HSM) in KVM
3. Ordered booting of guest vcpus in guest Linux

This series depends on the base kvm support series[2].

Guest kernel needs to also support SBI v0.2 and HSM extension in Kernel
to boot multiple vcpus. Linux kernel supports both starting v5.7.
In absense of that, guest can only boot 1vcpu.

[1] https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc
[2] http://lists.infradead.org/pipermail/linux-riscv/2020-July/001028.html

Atish Patra (6):
RISC-V: Add a non-void return for sbi v02 functions
RISC-V: Mark the existing SBI v0.1 implementation as legacy
RISC-V: Reorganize SBI code by moving legacy SBI to its own file
RISC-V: Add SBI v0.2 base extension
RISC-V: Add v0.1 replacement SBI extensions defined in v02
RISC-V: Add SBI HSM extension in KVM

arch/riscv/include/asm/kvm_vcpu_sbi.h |  32 +++++
arch/riscv/include/asm/sbi.h          |  17 ++-
arch/riscv/kernel/sbi.c               |  32 ++---
arch/riscv/kvm/Makefile               |   4 +-
arch/riscv/kvm/vcpu.c                 |  19 +++
arch/riscv/kvm/vcpu_sbi.c             | 194 ++++++++++++--------------
arch/riscv/kvm/vcpu_sbi_base.c        |  73 ++++++++++
arch/riscv/kvm/vcpu_sbi_hsm.c         | 109 +++++++++++++++
arch/riscv/kvm/vcpu_sbi_legacy.c      | 129 +++++++++++++++++
arch/riscv/kvm/vcpu_sbi_replace.c     | 136 ++++++++++++++++++
10 files changed, 619 insertions(+), 126 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_legacy.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c

--
2.24.0

