Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A6852D501
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiESNsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiESNso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:48:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB6E57100
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6613BB824B0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1902C34100;
        Thu, 19 May 2022 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968098;
        bh=OyFqMF74W3M0ZJLxEHZqbx0RH1+q2b7I75jA3NgE6M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sz4Qvp4rwr5g8e+HWqFvIn6o9WgbBHyu5HzK01BvWg2WbaepceHeDw2Oz4wrGY8uO
         aM7RkaxjPEp0BlTRFMv2G7K2U6Y54m/l1hoIiKuOssQGg1p4i8o4JRpOE4JkhEUjtu
         y1viTLNwKan5or5hlpGg7/3bb5GdQ2sSqlFRtVt8Kw26H188iSXMKY6TNLO9J0IR0v
         09XbcaTj4KmKVntmkWy3hOmTiJBA1MJbGs/mTlm1mDdvISFqM46gbapaqFy9TNpQsw
         e3bHaqnQUCzRzxlAq/EASYphq1ah49F36RW2faizlxHl00uW96cYtRQcQ49lHdXwm4
         jsg7IDRuYuYAg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 89/89] Documentation: KVM: Add some documentation for Protected KVM on arm64
Date:   Thu, 19 May 2022 14:42:04 +0100
Message-Id: <20220519134204.5379-90-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some initial documentation for the Protected KVM (pKVM) feature on
arm64, describing the user ABI for creating protected VMs as well as
their limitations.

Signed-off-by: Will Deacon <will@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  4 +-
 Documentation/virt/kvm/arm/index.rst          |  1 +
 Documentation/virt/kvm/arm/pkvm.rst           | 96 +++++++++++++++++++
 3 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 63a764ec7fec..b8841a969f59 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2437,7 +2437,9 @@
 			      protected guests.
 
 			protected: nVHE-based mode with support for guests whose
-				   state is kept private from the host.
+				   state is kept private from the host. See
+				   Documentation/virt/kvm/arm/pkvm.rst for more
+				   information about this mode of operation.
 
 			Defaults to VHE/nVHE based on hardware support. Setting
 			mode to "protected" will disable kexec and hibernation
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index b4067da3fcb6..49c388df662a 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -9,6 +9,7 @@ ARM
 
    hyp-abi
    hypercalls
+   pkvm
    psci
    pvtime
    ptp_kvm
diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
new file mode 100644
index 000000000000..64f099a5ac2e
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -0,0 +1,96 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Protected virtual machines (pKVM)
+=================================
+
+Introduction
+------------
+
+Protected KVM (pKVM) is a KVM/arm64 extension which uses the two-stage
+translation capability of the Armv8 MMU to isolate guest memory from the host
+system. This allows for the creation of a confidential computing environment
+without relying on whizz-bang features in hardware, but still allowing room for
+complementary technologies such as memory encryption and hardware-backed
+attestation.
+
+The major implementation change brought about by pKVM is that the hypervisor
+code running at EL2 is now largely independent of (and isolated from) the rest
+of the host kernel running at EL1 and therefore additional hypercalls are
+introduced to manage manipulation of guest stage-2 page tables, creation of VM
+data structures and reclamation of memory on teardown. An immediate consequence
+of this change is that the host itself runs with an identity mapping enabled
+at stage-2, providing the hypervisor code with a mechanism to restrict host
+access to an arbitrary physical page.
+
+Enabling pKVM
+-------------
+
+The pKVM hypervisor is enabled by booting the host kernel at EL2 with
+"``kvm-arm.mode=protected``" on the command-line. Once enabled, VMs can be spawned
+in either protected or non-protected state, although the hypervisor is still
+responsible for managing most of the VM metadata in either case.
+
+Limitations
+-----------
+
+Enabling pKVM places some significant limitations on KVM guests, regardless of
+whether they are spawned in protected state. It is therefore recommended only
+to enable pKVM if protected VMs are required, with non-protected state acting
+primarily as a debug and development aid.
+
+If you're still keen, then here is an incomplete list of caveats that apply
+to all VMs running under pKVM:
+
+- Guest memory cannot be file-backed (with the exception of shmem/memfd) and is
+  pinned as it is mapped into the guest. This prevents the host from
+  swapping-out, migrating, merging or generally doing anything useful with the
+  guest pages. It also requires that the VMM has either ``CAP_IPC_LOCK`` or
+  sufficient ``RLIMIT_MEMLOCK`` to account for this pinned memory.
+
+- GICv2 is not supported and therefore GICv3 hardware is required in order
+  to expose a virtual GICv3 to the guest.
+
+- Read-only memslots are unsupported and therefore dirty logging cannot be
+  enabled.
+
+- Memslot configuration is fixed once a VM has started running, with subsequent
+  move or deletion requests being rejected with ``-EPERM``.
+
+- There are probably many others.
+
+Since the host is unable to tear down the hypervisor when pKVM is enabled,
+hibernation (``CONFIG_HIBERNATION``) and kexec (``CONFIG_KEXEC``) will fail
+with ``-EBUSY``.
+
+If you are not happy with these limitations, then please don't enable pKVM :)
+
+VM creation
+-----------
+
+When pKVM is enabled, protected VMs can be created by specifying the
+``KVM_VM_TYPE_ARM_PROTECTED`` flag in the machine type identifier parameter
+passed to ``KVM_CREATE_VM``.
+
+Protected VMs are instantiated according to a fixed vCPU configuration
+described by the ID register definitions in
+``arch/arm64/include/asm/kvm_pkvm.h``. Only a subset of the architectural
+features that may be available to the host are exposed to the guest and the
+capabilities advertised by ``KVM_CHECK_EXTENSION`` are limited accordingly,
+with the vCPU registers being initialised to their architecturally-defined
+values.
+
+Where not defined by the architecture, the registers of a protected vCPU
+are reset to zero with the exception of the PC and X0 which can be set
+either by the ``KVM_SET_ONE_REG`` interface or by a call to PSCI ``CPU_ON``.
+
+VM runtime
+----------
+
+By default, memory pages mapped into a protected guest are inaccessible to the
+host and any attempt by the host to access such a page will result in the
+injection of an abort at EL1 by the hypervisor. For accesses originating from
+EL0, the host will then terminate the current task with a ``SIGSEGV``.
+
+pKVM exposes additional hypercalls to protected guests, primarily for the
+purpose of establishing shared-memory regions with the host for communication
+and I/O. These hypercalls are documented in hypercalls.rst.
-- 
2.36.1.124.g0e6072fb45-goog

