Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18D6D7B5E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfJOQ1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:27:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbfJOQ1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:27:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 287453084051;
        Tue, 15 Oct 2019 16:27:20 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB09319C58;
        Tue, 15 Oct 2019 16:27:08 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel@lists.xenproject.org,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 00/32] hw/i386/pc: Split PIIX3 southbridge from i440FX northbridge
Date:   Tue, 15 Oct 2019 18:26:33 +0200
Message-Id: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 15 Oct 2019 16:27:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series is a rework of "piix4: cleanup and improvements" [1]
from Hervé, and my "remove i386/pc dependency: PIIX cleanup" [2].

Still trying to remove the strong X86/PC dependency 2 years later,
one step at a time.
Here we split the PIIX3 southbridge from i440FX northbridge.
The i440FX northbridge is only used by the PC machine, while the
PIIX southbridge is also used by the Malta MIPS machine.

This is also a step forward using KConfig with the Malta board.
Without this split, it was impossible to compile the Malta without
pulling various X86 pieces of code.

The overall design cleanup is not yet perfect, but enough to post
as a series.

Now that the PIIX3 code is extracted, the code duplication with the
PIIX4 chipset is obvious. Not worth improving for now because it
isn't broken.

Next step is probably:

1/ Extract i8259 from "pc.h" and sort all the places where we call
   pic_*() using global variables
2/ Refactor common PIIX code from hw/i386/pc_*.c to piix*.c

Please review,

Phil.

Series available here:
branch pc_split_i440fx_piix-v1 on https://gitlab.com/philmd/qemu.git

[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg500737.html
[2] https://www.mail-archive.com/qemu-devel@nongnu.org/msg504081.html

Hervé Poussineau (9):
  mc146818rtc: move structure to header file
  mc146818rtc: always register rtc to rtc list
  piix4: rename some variables in realize function
  piix4: add Reset Control Register
  piix4: add a i8259 interrupt controller as specified in datasheet
  piix4: rename PIIX4 object to piix4-isa
  piix4: convert reset function to QOM
  piix4: add a i8257 dma controller as specified in datasheet
  piix4: add a i8254 pit controller as specified in datasheet

Philippe Mathieu-Daudé (23):
  hw/i386: Remove obsolete LoadStateHandler::load_state_old handlers
  hw/i386/pc: Move kvm_i8259_init() declaration to sysemu/kvm.h
  mc146818rtc: Move RTC_ISA_IRQ definition
  mc146818rtc: Include "mc146818rtc_regs.h" directly in mc146818rtc.c
  MAINTAINERS: Keep PIIX4 South Bridge separate from PC Chipsets
  Revert "irq: introduce qemu_irq_proxy()"
  piix4: add a mc146818rtc controller as specified in datasheet
  hw/mips/mips_malta: Create IDE hard drive array dynamically
  hw/mips/mips_malta: Extract the PIIX4 creation code as piix4_create()
  hw/isa/piix4: Move piix4_create() to hw/isa/piix4.c
  hw/i386/pc: Extract pc_gsi_create()
  hw/i386/pc: Reduce gsi_handler scope
  hw/i386/pc: Move gsi_state creation code
  hw/i386/pc: Extract pc_i8259_create()
  hw/i386/pc: Remove kvm_i386.h include
  hw/pci-host/piix: Extract piix3_create()
  hw/pci-host/piix: Move RCR_IOPORT register definition
  hw/pci-host/piix: Define and use the PIIX IRQ Route Control Registers
  hw/pci-host/piix: Move i440FX declarations to hw/pci-host/i440fx.h
  hw/pci-host/piix: Fix code style issues
  hw/pci-host/piix: Extract PIIX3 functions to hw/isa/piix3.c
  hw/pci-host: Rename incorrectly named 'piix' as 'i440fx'
  hw/pci-host/i440fx: Remove the last PIIX3 traces

 MAINTAINERS                         |  14 +-
 hw/acpi/pcihp.c                     |   2 +-
 hw/acpi/piix4.c                     |  42 +--
 hw/core/irq.c                       |  14 -
 hw/i386/Kconfig                     |   3 +-
 hw/i386/acpi-build.c                |   3 +-
 hw/i386/pc.c                        |  36 ++-
 hw/i386/pc_piix.c                   |  33 +--
 hw/i386/pc_q35.c                    |  28 +-
 hw/i386/xen/xen-hvm.c               |   5 +-
 hw/intc/apic_common.c               |  49 ----
 hw/isa/Kconfig                      |   4 +
 hw/isa/Makefile.objs                |   1 +
 hw/isa/piix3.c                      | 399 ++++++++++++++++++++++++++
 hw/isa/piix4.c                      | 155 ++++++++--
 hw/mips/gt64xxx_pci.c               |   5 +-
 hw/mips/mips_malta.c                |  46 +--
 hw/pci-host/Kconfig                 |   3 +-
 hw/pci-host/Makefile.objs           |   2 +-
 hw/pci-host/{piix.c => i440fx.c}    | 424 +---------------------------
 hw/timer/i8254_common.c             |  40 ---
 hw/timer/mc146818rtc.c              |  39 +--
 include/hw/acpi/piix4.h             |   6 -
 include/hw/i386/pc.h                |  41 +--
 include/hw/irq.h                    |   5 -
 include/hw/isa/isa.h                |   2 +
 include/hw/pci-host/i440fx.h        |  36 +++
 include/hw/southbridge/piix.h       |  74 +++++
 include/hw/timer/mc146818rtc.h      |  36 ++-
 include/hw/timer/mc146818rtc_regs.h |   2 -
 include/sysemu/kvm.h                |   1 +
 stubs/pci-host-piix.c               |   3 +-
 tests/rtc-test.c                    |   1 +
 33 files changed, 781 insertions(+), 773 deletions(-)
 create mode 100644 hw/isa/piix3.c
 rename hw/pci-host/{piix.c => i440fx.c} (58%)
 delete mode 100644 include/hw/acpi/piix4.h
 create mode 100644 include/hw/pci-host/i440fx.h
 create mode 100644 include/hw/southbridge/piix.h

-- 
2.21.0

