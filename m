Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84AD157D21
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 15:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgBJONb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 09:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgBJONb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 09:13:31 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBA020714;
        Mon, 10 Feb 2020 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581344010;
        bh=r+j5gAVgCtkQ8J7jlJ6T58nEBoHtHCZIY6CJGtVKFOc=;
        h=From:To:Cc:Subject:Date:From;
        b=PMfXM5QBXw6bvZAbWFaGKhv8hs7NJpPsgDZ1YHM1oxapmtngi4XHN3LBoim4jqmTg
         WKQKQZv9ha5K41MEhM1pbx3E9yeqJkL8EAzNHZLokEDqLJ/MXlao5xi56CjgN7Qa4l
         NZcb80T8GtagXnHUm8flgDsd+lXssVdSKRl0ZxtU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j19oW-0048kH-CM; Mon, 10 Feb 2020 14:13:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Anders Berg <anders.berg@lsi.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
Date:   Mon, 10 Feb 2020 14:13:19 +0000
Message-Id: <20200210141324.21090-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, pbonzini@redhat.com, Christoffer.Dall@arm.com, will@kernel.org, qperret@google.com, linux@arm.linux.org.uk, vladimir.murzin@arm.com, anders.berg@lsi.com, arnd@arndb.de
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm was merged just over 7 years ago, and has lived a very quiet
life so far. It mostly works if you're prepared to deal with its
limitations, it has been a good prototype for the arm64 version,
but it suffers a few problems:

- It is incomplete (no debug support, no PMU)
- It hasn't followed any of the architectural evolutions
- It has zero users (I don't count myself here)
- It is more and more getting in the way of new arm64 developments

So here it is: unless someone screams and shows that they rely on
KVM/arm to be maintained upsteam, I'll remove 32bit host support
form the tree. One of the reasons that makes me confident nobody is
using it is that I never receive *any* bug report. Yes, it is perfect.
But if you depend on KVM/arm being available in mainline, please shout.

To reiterate: 32bit guest support for arm64 stays, of course. Only
32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
arm64, and cleanup all the now unnecessary abstractions.

The patches have been generated with the -D option to avoid spamming
everyone with huge diffs, and there is a kvm-arm/goodbye branch in
my kernel.org repository.

Marc Zyngier (5):
  arm: Unplug KVM from the build system
  arm: Remove KVM from config files
  arm: Remove 32bit KVM host support
  arm: Remove HYP/Stage-2 page-table support
  arm: Remove GICv3 vgic compatibility macros

 Documentation/virt/kvm/arm/hyp-abi.txt |    5 +
 arch/arm/Kconfig                       |    2 -
 arch/arm/Makefile                      |    1 -
 arch/arm/configs/axm55xx_defconfig     |    2 -
 arch/arm/include/asm/arch_gicv3.h      |  114 --
 arch/arm/include/asm/kvm_arm.h         |  239 ----
 arch/arm/include/asm/kvm_asm.h         |   77 --
 arch/arm/include/asm/kvm_coproc.h      |   36 -
 arch/arm/include/asm/kvm_emulate.h     |  372 ------
 arch/arm/include/asm/kvm_host.h        |  459 --------
 arch/arm/include/asm/kvm_hyp.h         |  127 ---
 arch/arm/include/asm/kvm_mmu.h         |  435 -------
 arch/arm/include/asm/kvm_ras.h         |   14 -
 arch/arm/include/asm/pgtable-3level.h  |   20 -
 arch/arm/include/asm/pgtable.h         |    9 -
 arch/arm/include/asm/sections.h        |    6 +-
 arch/arm/include/asm/stage2_pgtable.h  |   75 --
 arch/arm/include/asm/virt.h            |   12 -
 arch/arm/include/uapi/asm/kvm.h        |  314 -----
 arch/arm/kernel/asm-offsets.c          |   11 -
 arch/arm/kernel/vmlinux-xip.lds.S      |    8 -
 arch/arm/kernel/vmlinux.lds.S          |    8 -
 arch/arm/kernel/vmlinux.lds.h          |   10 -
 arch/arm/kvm/Kconfig                   |   59 -
 arch/arm/kvm/Makefile                  |   43 -
 arch/arm/kvm/coproc.c                  | 1455 ------------------------
 arch/arm/kvm/coproc.h                  |  130 ---
 arch/arm/kvm/coproc_a15.c              |   39 -
 arch/arm/kvm/coproc_a7.c               |   42 -
 arch/arm/kvm/emulate.c                 |  166 ---
 arch/arm/kvm/guest.c                   |  387 -------
 arch/arm/kvm/handle_exit.c             |  175 ---
 arch/arm/kvm/hyp/Makefile              |   34 -
 arch/arm/kvm/hyp/banked-sr.c           |   70 --
 arch/arm/kvm/hyp/cp15-sr.c             |   72 --
 arch/arm/kvm/hyp/entry.S               |  121 --
 arch/arm/kvm/hyp/hyp-entry.S           |  295 -----
 arch/arm/kvm/hyp/s2-setup.c            |   22 -
 arch/arm/kvm/hyp/switch.c              |  242 ----
 arch/arm/kvm/hyp/tlb.c                 |   68 --
 arch/arm/kvm/hyp/vfp.S                 |   57 -
 arch/arm/kvm/init.S                    |  157 ---
 arch/arm/kvm/interrupts.S              |   36 -
 arch/arm/kvm/irq.h                     |   16 -
 arch/arm/kvm/reset.c                   |   86 --
 arch/arm/kvm/trace.h                   |   86 --
 arch/arm/kvm/vgic-v3-coproc.c          |   27 -
 arch/arm/mach-exynos/Kconfig           |    2 +-
 arch/arm/mm/mmu.c                      |   26 -
 49 files changed, 7 insertions(+), 6262 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_arm.h
 delete mode 100644 arch/arm/include/asm/kvm_asm.h
 delete mode 100644 arch/arm/include/asm/kvm_coproc.h
 delete mode 100644 arch/arm/include/asm/kvm_emulate.h
 delete mode 100644 arch/arm/include/asm/kvm_host.h
 delete mode 100644 arch/arm/include/asm/kvm_hyp.h
 delete mode 100644 arch/arm/include/asm/kvm_mmu.h
 delete mode 100644 arch/arm/include/asm/kvm_ras.h
 delete mode 100644 arch/arm/include/asm/stage2_pgtable.h
 delete mode 100644 arch/arm/include/uapi/asm/kvm.h
 delete mode 100644 arch/arm/kvm/Kconfig
 delete mode 100644 arch/arm/kvm/Makefile
 delete mode 100644 arch/arm/kvm/coproc.c
 delete mode 100644 arch/arm/kvm/coproc.h
 delete mode 100644 arch/arm/kvm/coproc_a15.c
 delete mode 100644 arch/arm/kvm/coproc_a7.c
 delete mode 100644 arch/arm/kvm/emulate.c
 delete mode 100644 arch/arm/kvm/guest.c
 delete mode 100644 arch/arm/kvm/handle_exit.c
 delete mode 100644 arch/arm/kvm/hyp/Makefile
 delete mode 100644 arch/arm/kvm/hyp/banked-sr.c
 delete mode 100644 arch/arm/kvm/hyp/cp15-sr.c
 delete mode 100644 arch/arm/kvm/hyp/entry.S
 delete mode 100644 arch/arm/kvm/hyp/hyp-entry.S
 delete mode 100644 arch/arm/kvm/hyp/s2-setup.c
 delete mode 100644 arch/arm/kvm/hyp/switch.c
 delete mode 100644 arch/arm/kvm/hyp/tlb.c
 delete mode 100644 arch/arm/kvm/hyp/vfp.S
 delete mode 100644 arch/arm/kvm/init.S
 delete mode 100644 arch/arm/kvm/interrupts.S
 delete mode 100644 arch/arm/kvm/irq.h
 delete mode 100644 arch/arm/kvm/reset.c
 delete mode 100644 arch/arm/kvm/trace.h
 delete mode 100644 arch/arm/kvm/vgic-v3-coproc.c

-- 
2.20.1

