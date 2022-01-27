Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B6249DECC
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 11:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbiA0KLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 05:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiA0KLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 05:11:22 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03769C06173B;
        Thu, 27 Jan 2022 02:11:21 -0800 (PST)
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 71DD01B0;
        Thu, 27 Jan 2022 11:11:18 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v3 00/10] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Date:   Thu, 27 Jan 2022 11:10:34 +0100
Message-Id: <20220127101044.13803-1-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here are changes to enable kexec/kdump in SEV-ES guests. The biggest
problem for supporting kexec/kdump under SEV-ES is to find a way to
hand the non-boot CPUs (APs) from one kernel to another.

Without SEV-ES the first kernel parks the CPUs in a HLT loop until
they get reset by the kexec'ed kernel via an INIT-SIPI-SIPI sequence.
For virtual machines the CPU reset is emulated by the hypervisor,
which sets the vCPU registers back to reset state.

This does not work under SEV-ES, because the hypervisor has no access
to the vCPU registers and can't make modifications to them. So an
SEV-ES guest needs to reset the vCPU itself and park it using the
AP-reset-hold protocol. Upon wakeup the guest needs to jump to
real-mode and to the reset-vector configured in the AP-Jump-Table.

The code to do this is the main part of this patch-set. It works by
placing code on the AP Jump-Table page itself to park the vCPU and for
jumping to the reset vector upon wakeup. The code on the AP Jump Table
runs in 16-bit protected mode with segment base set to the beginning
of the page. The AP Jump-Table is usually not within the first 1MB of
memory, so the code can't run in real-mode.

The AP Jump-Table is the best place to put the parking code, because
the memory is owned, but read-only by the firmware and writeable by
the OS. Only the first 4 bytes are used for the reset-vector, leaving
the rest of the page for code/data/stack to park a vCPU. The code
can't be in kernel memory because by the time the vCPU wakes up the
memory will be owned by the new kernel, which might have overwritten it
already.

The other patches add initial GHCB Version 2 protocol support, because
kexec/kdump need the MSR-based (without a GHCB) AP-reset-hold VMGEXIT,
which is a GHCB protocol version 2 feature.

The kexec'ed kernel is also entered via the decompressor and needs
MMIO support there, so this patch-set also adds MMIO #VC support to
the decompressor and support for handling CLFLUSH instructions.

Finally there is also code to disable kexec/kdump support at runtime
when the environment does not support it (e.g. no GHCB protocol
version 2 support or AP Jump Table over 4GB).

The diffstat looks big, but most of it is moving code for MMIO #VC
support around to make it available to the decompressor.

The previous version of this patch-set can be found here:

	https://lore.kernel.org/lkml/20210913155603.28383-1-joro@8bytes.org/

Please review.

Thanks,

	Joerg

Changes v2->v3:

	- Rebased to v5.17-rc1
	- Applied most review comments by Boris
	- Use the name 'AP jump table' consistently
	- Make kexec-disabling for unsupported guests x86-specific
	- Cleanup and consolidate patches to detect GHCB v2 protocol
	  support

Joerg Roedel (10):
  x86/kexec/64: Disable kexec when SEV-ES is active
  x86/sev: Save and print negotiated GHCB protocol version
  x86/sev: Set GHCB data structure version
  x86/sev: Cache AP Jump Table Address
  x86/sev: Setup code to park APs in the AP Jump Table
  x86/sev: Park APs on AP Jump Table with GHCB protocol version 2
  x86/sev: Use AP Jump Table blob to stop CPU
  x86/sev: Add MMIO handling support to boot/compressed/ code
  x86/sev: Handle CLFLUSH MMIO events
  x86/kexec/64: Support kexec under SEV-ES with AP Jump Table Blob

 arch/x86/boot/compressed/sev.c          |  45 +-
 arch/x86/include/asm/insn-eval.h        |   1 +
 arch/x86/include/asm/realmode.h         |   5 +
 arch/x86/include/asm/sev-ap-jumptable.h |  29 +
 arch/x86/include/asm/sev.h              |  11 +-
 arch/x86/kernel/machine_kexec_64.c      |  12 +
 arch/x86/kernel/process.c               |   8 +
 arch/x86/kernel/sev-shared.c            | 233 +++++-
 arch/x86/kernel/sev.c                   | 404 +++++------
 arch/x86/lib/insn-eval-shared.c         | 913 ++++++++++++++++++++++++
 arch/x86/lib/insn-eval.c                | 909 +----------------------
 arch/x86/realmode/Makefile              |   9 +-
 arch/x86/realmode/rm/Makefile           |  11 +-
 arch/x86/realmode/rm/header.S           |   3 +
 arch/x86/realmode/rm/sev.S              |  85 +++
 arch/x86/realmode/rmpiggy.S             |   6 +
 arch/x86/realmode/sev/Makefile          |  33 +
 arch/x86/realmode/sev/ap_jump_table.S   | 131 ++++
 arch/x86/realmode/sev/ap_jump_table.lds |  24 +
 19 files changed, 1730 insertions(+), 1142 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-ap-jumptable.h
 create mode 100644 arch/x86/lib/insn-eval-shared.c
 create mode 100644 arch/x86/realmode/rm/sev.S
 create mode 100644 arch/x86/realmode/sev/Makefile
 create mode 100644 arch/x86/realmode/sev/ap_jump_table.S
 create mode 100644 arch/x86/realmode/sev/ap_jump_table.lds


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.34.1

