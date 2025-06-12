Return-Path: <kvm+bounces-49296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B06C7AD75CD
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B78683B1DA4
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2B02C3256;
	Thu, 12 Jun 2025 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utpS9S62"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BBB2BEC28;
	Thu, 12 Jun 2025 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741473; cv=none; b=j+EsXeJCnQY8Zut7gk8t0bj9BXdolr2dSzRWINnlahucJ9WptJZsFaNPwvlb9rekQ8IgrguHwfzOsMZ605pF65I/Yi6SxMGdfHVyRhKY5dO41A+DW/XiUZTp7XosmgYZ24tBgg6Eje8eruHHdhXxwdjeIpsjx6u+Hyvl/gzJ+zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741473; c=relaxed/simple;
	bh=aMXdc8zVOp/1YkCFDVtL0XoKwSDR/Bai53NssJz8Zao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1pUbYOgBoobmzW29hXxMuBVpuDAILk0SdSRACwtFP/IUw4DCK36s5vBA7XGtH0/ea+n+QNPVLVdePEKVNGe3LF37nddltEbwjoFu7DfPQJmRlkf2nXf6Pb2OMpLOFXwYBXuX2HYsAfgL1ethrB6B64VFgpxtFmwLhcDheryyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utpS9S62; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C44C4CEEA;
	Thu, 12 Jun 2025 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741472;
	bh=aMXdc8zVOp/1YkCFDVtL0XoKwSDR/Bai53NssJz8Zao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utpS9S629m+AvtQNcN+U4t3FZZ9ByluaaehuxthiWMwwxVhsU+i1o5SaHTnT8WNXn
	 86kneYXgK8pnU0C7y8WOi457A18x3g349GGOlBaWcea0uHkpuhxKIAW6skXeTyFESv
	 lVMmcA8+O5JmxX1ST5UfMy/VM/q481FClrDF2b3KbtmOU9Xz7n1uH5jpg3hVoXRwZS
	 +0AySDgu/vxHYA95vNGKSCeOPGxbOpGgP76+F7jUamW8m31MjUIXGSForI6q+d8Il/
	 2XdlxbJduo82MMugD3TStmPp3rto9oasLpvFPuwn97mDLWb/HjVS5SD0Lkk5WH+np6
	 HhhX1KXnYth4Q==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgZ-00000005EwQ-3M8O;
	Thu, 12 Jun 2025 17:17:47 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Ani Sinha" <anisinha@redhat.com>,
	"Dongjiu Geng" <gengdongjiu1@gmail.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>,
	"Peter Maydell" <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Shannon Zhao" <shannon.zhaosl@gmail.com>,
	"Yanan Wang" <wangyanan55@huawei.com>,
	"Zhao Liu" <zhao1.liu@intel.com>,
	Cleber Rosa <crosa@redhat.com>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 (RESEND) 20/20] scripts/ghes_inject: add a script to generate GHES error inject
Date: Thu, 12 Jun 2025 17:17:44 +0200
Message-ID: <3a13c03e5a3e32e52f4c857607c233145da6c44d.1749741085.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749741085.git.mchehab+huawei@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Using the QMP GHESv2 API requires preparing a raw data array
containing a CPER record.

Add a helper script with subcommands to prepare such data.

Currently, only ARM Processor error CPER record is supported, by
using:
	$ ghes_inject.py arm

which produces those warnings on Linux:

[  705.032426] [Firmware Warn]: GHES: Unhandled processor error type 0x02: cache error
[  774.866308] {4}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[  774.866583] {4}[Hardware Error]: event severity: recoverable
[  774.866738] {4}[Hardware Error]:  Error 0, type: recoverable
[  774.866889] {4}[Hardware Error]:   section_type: ARM processor error
[  774.867048] {4}[Hardware Error]:   MIDR: 0x00000000000f0510
[  774.867189] {4}[Hardware Error]:   running state: 0x0
[  774.867321] {4}[Hardware Error]:   Power State Coordination Interface state: 0
[  774.867511] {4}[Hardware Error]:   Error info structure 0:
[  774.867679] {4}[Hardware Error]:   num errors: 2
[  774.867801] {4}[Hardware Error]:    error_type: 0x02: cache error
[  774.867962] {4}[Hardware Error]:    error_info: 0x000000000091000f
[  774.868124] {4}[Hardware Error]:     transaction type: Data Access
[  774.868280] {4}[Hardware Error]:     cache error, operation type: Data write
[  774.868465] {4}[Hardware Error]:     cache level: 2
[  774.868592] {4}[Hardware Error]:     processor context not corrupted
[  774.868774] [Firmware Warn]: GHES: Unhandled processor error type 0x02: cache error

Such script allows customizing the error data, allowing to change
all fields at the record. Please use:

	$ ghes_inject.py arm -h

For more details about its usage.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 MAINTAINERS                    |   3 +
 scripts/arm_processor_error.py | 476 ++++++++++++++++++++++
 scripts/ghes_inject.py         |  51 +++
 scripts/qmp_helper.py          | 703 +++++++++++++++++++++++++++++++++
 4 files changed, 1233 insertions(+)
 create mode 100644 scripts/arm_processor_error.py
 create mode 100755 scripts/ghes_inject.py
 create mode 100755 scripts/qmp_helper.py

diff --git a/MAINTAINERS b/MAINTAINERS
index 30acbe89f5cc..6a9ec7d11d8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2142,6 +2142,9 @@ S: Maintained
 F: hw/arm/ghes_cper.c
 F: hw/acpi/ghes_cper_stub.c
 F: qapi/acpi-hest.json
+F: scripts/ghes_inject.py
+F: scripts/arm_processor_error.py
+F: scripts/qmp_helper.py
 
 ppc4xx
 L: qemu-ppc@nongnu.org
diff --git a/scripts/arm_processor_error.py b/scripts/arm_processor_error.py
new file mode 100644
index 000000000000..1dd42e42a877
--- /dev/null
+++ b/scripts/arm_processor_error.py
@@ -0,0 +1,476 @@
+#!/usr/bin/env python3
+#
+# pylint: disable=C0301,C0114,R0903,R0912,R0913,R0914,R0915,W0511
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2024-2025 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+
+# TODO: current implementation has dummy defaults.
+#
+# For a better implementation, a QMP addition/call is needed to
+# retrieve some data for ARM Processor Error injection:
+#
+#   - ARM registers: power_state, mpidr.
+
+"""
+Generates an ARM processor error CPER, compatible with
+UEFI 2.9A Errata.
+
+Injecting such errors can be done using:
+
+    $ ./scripts/ghes_inject.py arm
+    Error injected.
+
+Produces a simple CPER register, as detected on a Linux guest:
+
+[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
+[Hardware Error]: event severity: recoverable
+[Hardware Error]:  Error 0, type: recoverable
+[Hardware Error]:   section_type: ARM processor error
+[Hardware Error]:   MIDR: 0x0000000000000000
+[Hardware Error]:   running state: 0x0
+[Hardware Error]:   Power State Coordination Interface state: 0
+[Hardware Error]:   Error info structure 0:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x02: cache error
+[Hardware Error]:    error_info: 0x000000000091000f
+[Hardware Error]:     transaction type: Data Access
+[Hardware Error]:     cache error, operation type: Data write
+[Hardware Error]:     cache level: 2
+[Hardware Error]:     processor context not corrupted
+[Firmware Warn]: GHES: Unhandled processor error type 0x02: cache error
+
+The ARM Processor Error message can be customized via command line
+parameters. For instance:
+
+    $ ./scripts/ghes_inject.py arm --mpidr 0x444 --running --affinity 1 \
+        --error-info 12345678 --vendor 0x13,123,4,5,1 --ctx-array 0,1,2,3,4,5 \
+        -t cache tlb bus micro-arch tlb,micro-arch
+    Error injected.
+
+Injects this error, as detected on a Linux guest:
+
+[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
+[Hardware Error]: event severity: recoverable
+[Hardware Error]:  Error 0, type: recoverable
+[Hardware Error]:   section_type: ARM processor error
+[Hardware Error]:   MIDR: 0x0000000000000000
+[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000000000000
+[Hardware Error]:   error affinity level: 0
+[Hardware Error]:   running state: 0x1
+[Hardware Error]:   Power State Coordination Interface state: 0
+[Hardware Error]:   Error info structure 0:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x02: cache error
+[Hardware Error]:    error_info: 0x0000000000bc614e
+[Hardware Error]:     cache level: 2
+[Hardware Error]:     processor context not corrupted
+[Hardware Error]:   Error info structure 1:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x04: TLB error
+[Hardware Error]:    error_info: 0x000000000054007f
+[Hardware Error]:     transaction type: Instruction
+[Hardware Error]:     TLB error, operation type: Instruction fetch
+[Hardware Error]:     TLB level: 1
+[Hardware Error]:     processor context not corrupted
+[Hardware Error]:     the error has not been corrected
+[Hardware Error]:     PC is imprecise
+[Hardware Error]:   Error info structure 2:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x08: bus error
+[Hardware Error]:    error_info: 0x00000080d6460fff
+[Hardware Error]:     transaction type: Generic
+[Hardware Error]:     bus error, operation type: Generic read (type of instruction or data request cannot be determined)
+[Hardware Error]:     affinity level at which the bus error occurred: 1
+[Hardware Error]:     processor context corrupted
+[Hardware Error]:     the error has been corrected
+[Hardware Error]:     PC is imprecise
+[Hardware Error]:     Program execution can be restarted reliably at the PC associated with the error.
+[Hardware Error]:     participation type: Local processor observed
+[Hardware Error]:     request timed out
+[Hardware Error]:     address space: External Memory Access
+[Hardware Error]:     memory access attributes:0x20
+[Hardware Error]:     access mode: secure
+[Hardware Error]:   Error info structure 3:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x10: micro-architectural error
+[Hardware Error]:    error_info: 0x0000000078da03ff
+[Hardware Error]:   Error info structure 4:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x14: TLB error|micro-architectural error
+[Hardware Error]:   Context info structure 0:
+[Hardware Error]:    register context type: AArch64 EL1 context registers
+[Hardware Error]:    00000000: 00000000 00000000
+[Hardware Error]:   Vendor specific error info has 5 bytes:
+[Hardware Error]:    00000000: 13 7b 04 05 01                                   .{...
+[Firmware Warn]: GHES: Unhandled processor error type 0x02: cache error
+[Firmware Warn]: GHES: Unhandled processor error type 0x04: TLB error
+[Firmware Warn]: GHES: Unhandled processor error type 0x08: bus error
+[Firmware Warn]: GHES: Unhandled processor error type 0x10: micro-architectural error
+[Firmware Warn]: GHES: Unhandled processor error type 0x14: TLB error|micro-architectural error
+"""
+
+import argparse
+import re
+
+from qmp_helper import qmp, util, cper_guid
+
+
+class ArmProcessorEinj:
+    """
+    Implements ARM Processor Error injection via GHES
+    """
+
+    DESC = """
+    Generates an ARM processor error CPER, compatible with
+    UEFI 2.9A Errata.
+    """
+
+    ACPI_GHES_ARM_CPER_LENGTH = 40
+    ACPI_GHES_ARM_CPER_PEI_LENGTH = 32
+
+    # Context types
+    CONTEXT_AARCH32_EL1 = 1
+    CONTEXT_AARCH64_EL1 = 5
+    CONTEXT_MISC_REG = 8
+
+    def __init__(self, subparsers):
+        """Initialize the error injection class and add subparser"""
+
+        # Valid choice values
+        self.arm_valid_bits = {
+            "mpidr":    util.bit(0),
+            "affinity": util.bit(1),
+            "running":  util.bit(2),
+            "vendor":   util.bit(3),
+        }
+
+        self.pei_flags = {
+            "first":        util.bit(0),
+            "last":         util.bit(1),
+            "propagated":   util.bit(2),
+            "overflow":     util.bit(3),
+        }
+
+        self.pei_error_types = {
+            "cache":        util.bit(1),
+            "tlb":          util.bit(2),
+            "bus":          util.bit(3),
+            "micro-arch":   util.bit(4),
+        }
+
+        self.pei_valid_bits = {
+            "multiple-error":   util.bit(0),
+            "flags":            util.bit(1),
+            "error-info":       util.bit(2),
+            "virt-addr":        util.bit(3),
+            "phy-addr":         util.bit(4),
+        }
+
+        self.data = bytearray()
+
+        parser = subparsers.add_parser("arm", description=self.DESC)
+
+        arm_valid_bits = ",".join(self.arm_valid_bits.keys())
+        flags = ",".join(self.pei_flags.keys())
+        error_types = ",".join(self.pei_error_types.keys())
+        pei_valid_bits = ",".join(self.pei_valid_bits.keys())
+
+        # UEFI N.16 ARM Validation bits
+        g_arm = parser.add_argument_group("ARM processor")
+        g_arm.add_argument("--arm", "--arm-valid",
+                           help=f"ARM valid bits: {arm_valid_bits}")
+        g_arm.add_argument("-a", "--affinity",  "--level", "--affinity-level",
+                           type=lambda x: int(x, 0),
+                           help="Affinity level (when multiple levels apply)")
+        g_arm.add_argument("-l", "--mpidr", type=lambda x: int(x, 0),
+                           help="Multiprocessor Affinity Register")
+        g_arm.add_argument("-i", "--midr", type=lambda x: int(x, 0),
+                           help="Main ID Register")
+        g_arm.add_argument("-r", "--running",
+                           action=argparse.BooleanOptionalAction,
+                           default=None,
+                           help="Indicates if the processor is running or not")
+        g_arm.add_argument("--psci", "--psci-state",
+                           type=lambda x: int(x, 0),
+                           help="Power State Coordination Interface - PSCI state")
+
+        # TODO: Add vendor-specific support
+
+        # UEFI N.17 bitmaps (type and flags)
+        g_pei = parser.add_argument_group("ARM Processor Error Info (PEI)")
+        g_pei.add_argument("-t", "--type", nargs="+",
+                        help=f"one or more error types: {error_types}")
+        g_pei.add_argument("-f", "--flags", nargs="*",
+                        help=f"zero or more error flags: {flags}")
+        g_pei.add_argument("-V", "--pei-valid", "--error-valid", nargs="*",
+                        help=f"zero or more PEI valid bits: {pei_valid_bits}")
+
+        # UEFI N.17 Integer values
+        g_pei.add_argument("-m", "--multiple-error", nargs="+",
+                        help="Number of errors: 0: Single error, 1: Multiple errors, 2-65535: Error count if known")
+        g_pei.add_argument("-e", "--error-info", nargs="+",
+                        help="Error information (UEFI 2.10 tables N.18 to N.20)")
+        g_pei.add_argument("-p", "--physical-address",  nargs="+",
+                        help="Physical address")
+        g_pei.add_argument("-v", "--virtual-address",  nargs="+",
+                        help="Virtual address")
+
+        # UEFI N.21 Context
+        g_ctx = parser.add_argument_group("Processor Context")
+        g_ctx.add_argument("--ctx-type", "--context-type", nargs="*",
+                        help="Type of the context (0=ARM32 GPR, 5=ARM64 EL1, other values supported)")
+        g_ctx.add_argument("--ctx-size", "--context-size", nargs="*",
+                        help="Minimal size of the context")
+        g_ctx.add_argument("--ctx-array", "--context-array", nargs="*",
+                        help="Comma-separated arrays for each context")
+
+        # Vendor-specific data
+        g_vendor = parser.add_argument_group("Vendor-specific data")
+        g_vendor.add_argument("--vendor", "--vendor-specific", nargs="+",
+                        help="Vendor-specific byte arrays of data")
+
+        # Add arguments for Generic Error Data
+        qmp.argparse(parser)
+
+        parser.set_defaults(func=self.send_cper)
+
+    def send_cper(self, args):
+        """Parse subcommand arguments and send a CPER via QMP"""
+
+        qmp_cmd = qmp(args.host, args.port, args.debug)
+
+        # Handle Generic Error Data arguments if any
+        qmp_cmd.set_args(args)
+
+        is_cpu_type = re.compile(r"^([\w+]+\-)?arm\-cpu$")
+        cpus = qmp_cmd.search_qom("/machine/unattached/device",
+                                  "type", is_cpu_type)
+
+        cper = {}
+        pei = {}
+        ctx = {}
+        vendor = {}
+
+        arg = vars(args)
+
+        # Handle global parameters
+        if args.arm:
+            arm_valid_init = False
+            cper["valid"] = util.get_choice(name="valid",
+                                       value=args.arm,
+                                       choices=self.arm_valid_bits,
+                                       suffixes=["-error", "-err"])
+        else:
+            cper["valid"] = 0
+            arm_valid_init = True
+
+        if "running" in arg:
+            if args.running:
+                cper["running-state"] = util.bit(0)
+            else:
+                cper["running-state"] = 0
+        else:
+            cper["running-state"] = 0
+
+        if arm_valid_init:
+            if args.affinity:
+                cper["valid"] |= self.arm_valid_bits["affinity"]
+
+            if args.mpidr:
+                cper["valid"] |= self.arm_valid_bits["mpidr"]
+
+            if "running-state" in cper:
+                cper["valid"] |= self.arm_valid_bits["running"]
+
+            if args.psci:
+                cper["valid"] |= self.arm_valid_bits["running"]
+
+        # Handle PEI
+        if not args.type:
+            args.type = ["cache-error"]
+
+        util.get_mult_choices(
+            pei,
+            name="valid",
+            values=args.pei_valid,
+            choices=self.pei_valid_bits,
+            suffixes=["-valid", "--addr"],
+        )
+        util.get_mult_choices(
+            pei,
+            name="type",
+            values=args.type,
+            choices=self.pei_error_types,
+            suffixes=["-error", "-err"],
+        )
+        util.get_mult_choices(
+            pei,
+            name="flags",
+            values=args.flags,
+            choices=self.pei_flags,
+            suffixes=["-error", "-cap"],
+        )
+        util.get_mult_int(pei, "error-info", args.error_info)
+        util.get_mult_int(pei, "multiple-error", args.multiple_error)
+        util.get_mult_int(pei, "phy-addr", args.physical_address)
+        util.get_mult_int(pei, "virt-addr", args.virtual_address)
+
+        # Handle context
+        util.get_mult_int(ctx, "type", args.ctx_type, allow_zero=True)
+        util.get_mult_int(ctx, "minimal-size", args.ctx_size, allow_zero=True)
+        util.get_mult_array(ctx, "register", args.ctx_array, allow_zero=True)
+
+        util.get_mult_array(vendor, "bytes", args.vendor, max_val=255)
+
+        # Store PEI
+        pei_data = bytearray()
+        default_flags  = self.pei_flags["first"]
+        default_flags |= self.pei_flags["last"]
+
+        error_info_num = 0
+
+        for i, p in pei.items():        # pylint: disable=W0612
+            error_info_num += 1
+
+            # UEFI 2.10 doesn't define how to encode error information
+            # when multiple types are raised. So, provide a default only
+            # if a single type is there
+            if "error-info" not in p:
+                if p["type"] == util.bit(1):
+                    p["error-info"] = 0x0091000F
+                if p["type"] == util.bit(2):
+                    p["error-info"] = 0x0054007F
+                if p["type"] == util.bit(3):
+                    p["error-info"] = 0x80D6460FFF
+                if p["type"] == util.bit(4):
+                    p["error-info"] = 0x78DA03FF
+
+            if "valid" not in p:
+                p["valid"] = 0
+                if "multiple-error" in p:
+                    p["valid"] |= self.pei_valid_bits["multiple-error"]
+
+                if "flags" in p:
+                    p["valid"] |= self.pei_valid_bits["flags"]
+
+                if "error-info" in p:
+                    p["valid"] |= self.pei_valid_bits["error-info"]
+
+                if "phy-addr" in p:
+                    p["valid"] |= self.pei_valid_bits["phy-addr"]
+
+                if "virt-addr" in p:
+                    p["valid"] |= self.pei_valid_bits["virt-addr"]
+
+            # Version
+            util.data_add(pei_data, 0, 1)
+
+            util.data_add(pei_data,
+                         self.ACPI_GHES_ARM_CPER_PEI_LENGTH, 1)
+
+            util.data_add(pei_data, p["valid"], 2)
+            util.data_add(pei_data, p["type"], 1)
+            util.data_add(pei_data, p.get("multiple-error", 1), 2)
+            util.data_add(pei_data, p.get("flags", default_flags), 1)
+            util.data_add(pei_data, p.get("error-info", 0), 8)
+            util.data_add(pei_data, p.get("virt-addr", 0xDEADBEEF), 8)
+            util.data_add(pei_data, p.get("phy-addr", 0xABBA0BAD), 8)
+
+        # Store Context
+        ctx_data = bytearray()
+        context_info_num = 0
+
+        if ctx:
+            ret = qmp_cmd.send_cmd("query-target", may_open=True)
+
+            default_ctx = self.CONTEXT_MISC_REG
+
+            if "arch" in ret:
+                if ret["arch"] == "aarch64":
+                    default_ctx = self.CONTEXT_AARCH64_EL1
+                elif ret["arch"] == "arm":
+                    default_ctx = self.CONTEXT_AARCH32_EL1
+
+            for k in sorted(ctx.keys()):
+                context_info_num += 1
+
+                if "type" not in ctx[k]:
+                    ctx[k]["type"] = default_ctx
+
+                if "register" not in ctx[k]:
+                    ctx[k]["register"] = []
+
+                reg_size = len(ctx[k]["register"])
+                size = 0
+
+                if "minimal-size" in ctx:
+                    size = ctx[k]["minimal-size"]
+
+                size = max(size, reg_size)
+
+                size = (size + 1) % 0xFFFE
+
+                # Version
+                util.data_add(ctx_data, 0, 2)
+
+                util.data_add(ctx_data, ctx[k]["type"], 2)
+
+                util.data_add(ctx_data, 8 * size, 4)
+
+                for r in ctx[k]["register"]:
+                    util.data_add(ctx_data, r, 8)
+
+                for i in range(reg_size, size):   # pylint: disable=W0612
+                    util.data_add(ctx_data, 0, 8)
+
+        # Vendor-specific bytes are not grouped
+        vendor_data = bytearray()
+        if vendor:
+            for k in sorted(vendor.keys()):
+                for b in vendor[k]["bytes"]:
+                    util.data_add(vendor_data, b, 1)
+
+        # Encode ARM Processor Error
+        data = bytearray()
+
+        util.data_add(data, cper["valid"], 4)
+
+        util.data_add(data, error_info_num, 2)
+        util.data_add(data, context_info_num, 2)
+
+        # Calculate the length of the CPER data
+        cper_length = self.ACPI_GHES_ARM_CPER_LENGTH
+        cper_length += len(pei_data)
+        cper_length += len(vendor_data)
+        cper_length += len(ctx_data)
+        util.data_add(data, cper_length, 4)
+
+        util.data_add(data, arg.get("affinity-level", 0), 1)
+
+        # Reserved
+        util.data_add(data, 0, 3)
+
+        if "midr-el1" not in arg:
+            if cpus:
+                cmd_arg = {
+                    'path': cpus[0],
+                    'property': "midr"
+                }
+                ret = qmp_cmd.send_cmd("qom-get", cmd_arg, may_open=True)
+                if isinstance(ret, int):
+                    arg["midr-el1"] = ret
+
+        util.data_add(data, arg.get("mpidr-el1", 0), 8)
+        util.data_add(data, arg.get("midr-el1", 0), 8)
+        util.data_add(data, cper["running-state"], 4)
+        util.data_add(data, arg.get("psci-state", 0), 4)
+
+        # Add PEI
+        data.extend(pei_data)
+        data.extend(ctx_data)
+        data.extend(vendor_data)
+
+        self.data = data
+
+        qmp_cmd.send_cper(cper_guid.CPER_PROC_ARM, self.data)
diff --git a/scripts/ghes_inject.py b/scripts/ghes_inject.py
new file mode 100755
index 000000000000..9a235201418b
--- /dev/null
+++ b/scripts/ghes_inject.py
@@ -0,0 +1,51 @@
+#!/usr/bin/env python3
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2024-2025 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+
+"""
+Handle ACPI GHESv2 error injection logic QEMU QMP interface.
+"""
+
+import argparse
+import sys
+
+from arm_processor_error import ArmProcessorEinj
+
+EINJ_DESC = """
+Handle ACPI GHESv2 error injection logic QEMU QMP interface.
+
+It allows using UEFI BIOS EINJ features to generate GHES records.
+
+It helps testing CPER and GHES drivers at the guest OS and how
+userspace applications at the guest handle them.
+"""
+
+def main():
+    """Main program"""
+
+    # Main parser - handle generic args like QEMU QMP TCP socket options
+    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
+                                     usage="%(prog)s [options]",
+                                     description=EINJ_DESC)
+
+    g_options = parser.add_argument_group("QEMU QMP socket options")
+    g_options.add_argument("-H", "--host", default="localhost", type=str,
+                           help="host name")
+    g_options.add_argument("-P", "--port", default=4445, type=int,
+                           help="TCP port number")
+    g_options.add_argument('-d', '--debug', action='store_true')
+
+    subparsers = parser.add_subparsers()
+
+    ArmProcessorEinj(subparsers)
+
+    args = parser.parse_args()
+    if "func" in args:
+        args.func(args)
+    else:
+        sys.exit(f"Please specify a valid command for {sys.argv[0]}")
+
+if __name__ == "__main__":
+    main()
diff --git a/scripts/qmp_helper.py b/scripts/qmp_helper.py
new file mode 100755
index 000000000000..c1e7e0fd80ce
--- /dev/null
+++ b/scripts/qmp_helper.py
@@ -0,0 +1,703 @@
+#!/usr/bin/env python3
+#
+# pylint: disable=C0103,E0213,E1135,E1136,E1137,R0902,R0903,R0912,R0913,R0917
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2024-2025 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+
+"""
+Helper classes to be used by ghes_inject command classes.
+"""
+
+import json
+import sys
+
+from datetime import datetime
+from os import path as os_path
+
+try:
+    qemu_dir = os_path.abspath(os_path.dirname(os_path.dirname(__file__)))
+    sys.path.append(os_path.join(qemu_dir, 'python'))
+
+    from qemu.qmp.legacy import QEMUMonitorProtocol
+
+except ModuleNotFoundError as exc:
+    print(f"Module '{exc.name}' not found.")
+    print("Try export PYTHONPATH=top-qemu-dir/python or run from top-qemu-dir")
+    sys.exit(1)
+
+from base64 import b64encode
+
+class util:
+    """
+    Ancillary functions to deal with bitmaps, parse arguments,
+    generate GUID and encode data on a bytearray buffer.
+    """
+
+    #
+    # Helper routines to handle multiple choice arguments
+    #
+    def get_choice(name, value, choices, suffixes=None, bitmask=True):
+        """Produce a list from multiple choice argument"""
+
+        new_values = 0
+
+        if not value:
+            return new_values
+
+        for val in value.split(","):
+            val = val.lower()
+
+            if suffixes:
+                for suffix in suffixes:
+                    val = val.removesuffix(suffix)
+
+            if val not in choices.keys():
+                if suffixes:
+                    for suffix in suffixes:
+                        if val + suffix in choices.keys():
+                            val += suffix
+                            break
+
+            if val not in choices.keys():
+                sys.exit(f"Error on '{name}': choice '{val}' is invalid.")
+
+            val = choices[val]
+
+            if bitmask:
+                new_values |= val
+            else:
+                if new_values:
+                    sys.exit(f"Error on '{name}': only one value is accepted.")
+
+                new_values = val
+
+        return new_values
+
+    def get_array(name, values, max_val=None):
+        """Add numbered hashes from integer lists into an array"""
+
+        array = []
+
+        for value in values:
+            for val in value.split(","):
+                try:
+                    val = int(val, 0)
+                except ValueError:
+                    sys.exit(f"Error on '{name}': {val} is not an integer")
+
+                if val < 0:
+                    sys.exit(f"Error on '{name}': {val} is not unsigned")
+
+                if max_val and val > max_val:
+                    sys.exit(f"Error on '{name}': {val} is too little")
+
+                array.append(val)
+
+        return array
+
+    def get_mult_array(mult, name, values, allow_zero=False, max_val=None):
+        """Add numbered hashes from integer lists"""
+
+        if not allow_zero:
+            if not values:
+                return
+        else:
+            if values is None:
+                return
+
+            if not values:
+                i = 0
+                if i not in mult:
+                    mult[i] = {}
+
+                mult[i][name] = []
+                return
+
+        i = 0
+        for value in values:
+            for val in value.split(","):
+                try:
+                    val = int(val, 0)
+                except ValueError:
+                    sys.exit(f"Error on '{name}': {val} is not an integer")
+
+                if val < 0:
+                    sys.exit(f"Error on '{name}': {val} is not unsigned")
+
+                if max_val and val > max_val:
+                    sys.exit(f"Error on '{name}': {val} is too little")
+
+                if i not in mult:
+                    mult[i] = {}
+
+                if name not in mult[i]:
+                    mult[i][name] = []
+
+                mult[i][name].append(val)
+
+            i += 1
+
+
+    def get_mult_choices(mult, name, values, choices,
+                        suffixes=None, allow_zero=False):
+        """Add numbered hashes from multiple choice arguments"""
+
+        if not allow_zero:
+            if not values:
+                return
+        else:
+            if values is None:
+                return
+
+        i = 0
+        for val in values:
+            new_values = util.get_choice(name, val, choices, suffixes)
+
+            if i not in mult:
+                mult[i] = {}
+
+            mult[i][name] = new_values
+            i += 1
+
+
+    def get_mult_int(mult, name, values, allow_zero=False):
+        """Add numbered hashes from integer arguments"""
+        if not allow_zero:
+            if not values:
+                return
+        else:
+            if values is None:
+                return
+
+        i = 0
+        for val in values:
+            try:
+                val = int(val, 0)
+            except ValueError:
+                sys.exit(f"Error on '{name}': {val} is not an integer")
+
+            if val < 0:
+                sys.exit(f"Error on '{name}': {val} is not unsigned")
+
+            if i not in mult:
+                mult[i] = {}
+
+            mult[i][name] = val
+            i += 1
+
+
+    #
+    # Data encode helper functions
+    #
+    def bit(b):
+        """Simple macro to define a bit on a bitmask"""
+        return 1 << b
+
+
+    def data_add(data, value, num_bytes):
+        """Adds bytes from value inside a bitarray"""
+
+        data.extend(value.to_bytes(num_bytes, byteorder="little"))  # pylint: disable=E1101
+
+    def dump_bytearray(name, data):
+        """Does an hexdump of a byte array, grouping in bytes"""
+
+        print(f"{name} ({len(data)} bytes):")
+
+        for ln_start in range(0, len(data), 16):
+            ln_end = min(ln_start + 16, len(data))
+            print(f"      {ln_start:08x}  ", end="")
+            for i in range(ln_start, ln_end):
+                print(f"{data[i]:02x} ", end="")
+            for i in range(ln_end, ln_start + 16):
+                print("   ", end="")
+            print("  ", end="")
+            for i in range(ln_start, ln_end):
+                if data[i] >= 32 and data[i] < 127:
+                    print(chr(data[i]), end="")
+                else:
+                    print(".", end="")
+
+            print()
+        print()
+
+    def time(string):
+        """Handle BCD timestamps used on Generic Error Data Block"""
+
+        time = None
+
+        # Formats to be used when parsing time stamps
+        formats = [
+            "%Y-%m-%d %H:%M:%S",
+        ]
+
+        if string == "now":
+            time = datetime.now()
+
+        if time is None:
+            for fmt in formats:
+                try:
+                    time = datetime.strptime(string, fmt)
+                    break
+                except ValueError:
+                    pass
+
+            if time is None:
+                raise ValueError("Invalid time format")
+
+        return time
+
+class guid:
+    """
+    Simple class to handle GUID fields.
+    """
+
+    def __init__(self, time_low, time_mid, time_high, nodes):
+        """Initialize a GUID value"""
+
+        assert len(nodes) == 8
+
+        self.time_low = time_low
+        self.time_mid = time_mid
+        self.time_high = time_high
+        self.nodes = nodes
+
+    @classmethod
+    def UUID(cls, guid_str):
+        """Initialize a GUID using a string on its standard format"""
+
+        if len(guid_str) != 36:
+            print("Size not 36")
+            raise ValueError('Invalid GUID size')
+
+        # It is easier to parse without separators. So, drop them
+        guid_str = guid_str.replace('-', '')
+
+        if len(guid_str) != 32:
+            print("Size not 32", guid_str, len(guid_str))
+            raise ValueError('Invalid GUID hex size')
+
+        time_low = 0
+        time_mid = 0
+        time_high = 0
+        nodes = []
+
+        for i in reversed(range(16, 32, 2)):
+            h = guid_str[i:i + 2]
+            value = int(h, 16)
+            nodes.insert(0, value)
+
+        time_high = int(guid_str[12:16], 16)
+        time_mid = int(guid_str[8:12], 16)
+        time_low = int(guid_str[0:8], 16)
+
+        return cls(time_low, time_mid, time_high, nodes)
+
+    def __str__(self):
+        """Output a GUID value on its default string representation"""
+
+        clock = self.nodes[0] << 8 | self.nodes[1]
+
+        node = 0
+        for i in range(2, len(self.nodes)):
+            node = node << 8 | self.nodes[i]
+
+        s = f"{self.time_low:08x}-{self.time_mid:04x}-"
+        s += f"{self.time_high:04x}-{clock:04x}-{node:012x}"
+        return s
+
+    def to_bytes(self):
+        """Output a GUID value in bytes"""
+
+        data = bytearray()
+
+        util.data_add(data, self.time_low, 4)
+        util.data_add(data, self.time_mid, 2)
+        util.data_add(data, self.time_high, 2)
+        data.extend(bytearray(self.nodes))
+
+        return data
+
+class qmp:
+    """
+    Opens a connection and send/receive QMP commands.
+    """
+
+    def send_cmd(self, command, args=None, may_open=False, return_error=True):
+        """Send a command to QMP, optinally opening a connection"""
+
+        if may_open:
+            self._connect()
+        elif not self.connected:
+            return False
+
+        msg = { 'execute': command }
+        if args:
+            msg['arguments'] = args
+
+        try:
+            obj = self.qmp_monitor.cmd_obj(msg)
+        # Can we use some other exception class here?
+        except Exception as e:                         # pylint: disable=W0718
+            print(f"Command: {command}")
+            print(f"Failed to inject error: {e}.")
+            return None
+
+        if "return" in obj:
+            if isinstance(obj.get("return"), dict):
+                if obj["return"]:
+                    return obj["return"]
+                return "OK"
+
+            return obj["return"]
+
+        if isinstance(obj.get("error"), dict):
+            error = obj["error"]
+            if return_error:
+                print(f"Command: {msg}")
+                print(f'{error["class"]}: {error["desc"]}')
+        else:
+            print(json.dumps(obj))
+
+        return None
+
+    def _close(self):
+        """Shutdown and close the socket, if opened"""
+        if not self.connected:
+            return
+
+        self.qmp_monitor.close()
+        self.connected = False
+
+    def _connect(self):
+        """Connect to a QMP TCP/IP port, if not connected yet"""
+
+        if self.connected:
+            return True
+
+        try:
+            self.qmp_monitor.connect(negotiate=True)
+        except ConnectionError:
+            sys.exit(f"Can't connect to QMP host {self.host}:{self.port}")
+
+        self.connected = True
+
+        return True
+
+    BLOCK_STATUS_BITS = {
+        "uncorrectable":            util.bit(0),
+        "correctable":              util.bit(1),
+        "multi-uncorrectable":      util.bit(2),
+        "multi-correctable":        util.bit(3),
+    }
+
+    ERROR_SEVERITY = {
+        "recoverable":  0,
+        "fatal":        1,
+        "corrected":    2,
+        "none":         3,
+    }
+
+    VALIDATION_BITS = {
+        "fru-id":       util.bit(0),
+        "fru-text":     util.bit(1),
+        "timestamp":    util.bit(2),
+    }
+
+    GEDB_FLAGS_BITS = {
+        "recovered":    util.bit(0),
+        "prev-error":   util.bit(1),
+        "simulated":    util.bit(2),
+    }
+
+    GENERIC_DATA_SIZE = 72
+
+    def argparse(parser):
+        """Prepare a parser group to query generic error data"""
+
+        block_status_bits = ",".join(qmp.BLOCK_STATUS_BITS.keys())
+        error_severity_enum = ",".join(qmp.ERROR_SEVERITY.keys())
+        validation_bits = ",".join(qmp.VALIDATION_BITS.keys())
+        gedb_flags_bits = ",".join(qmp.GEDB_FLAGS_BITS.keys())
+
+        g_gen = parser.add_argument_group("Generic Error Data")  # pylint: disable=E1101
+        g_gen.add_argument("--block-status",
+                           help=f"block status bits: {block_status_bits}")
+        g_gen.add_argument("--raw-data", nargs="+",
+                        help="Raw data inside the Error Status Block")
+        g_gen.add_argument("--error-severity", "--severity",
+                           help=f"error severity: {error_severity_enum}")
+        g_gen.add_argument("--gen-err-valid-bits",
+                           "--generic-error-validation-bits",
+                           help=f"validation bits: {validation_bits}")
+        g_gen.add_argument("--fru-id", type=guid.UUID,
+                           help="GUID representing a physical device")
+        g_gen.add_argument("--fru-text",
+                           help="ASCII string identifying the FRU hardware")
+        g_gen.add_argument("--timestamp", type=util.time,
+                           help="Time when the error info was collected")
+        g_gen.add_argument("--precise", "--precise-timestamp",
+                           action='store_true',
+                           help="Marks the timestamp as precise if --timestamp is used")
+        g_gen.add_argument("--gedb-flags",
+                           help=f"General Error Data Block flags: {gedb_flags_bits}")
+
+    def set_args(self, args):
+        """Set the arguments optionally defined via self.argparse()"""
+
+        if args.block_status:
+            self.block_status = util.get_choice(name="block-status",
+                                                value=args.block_status,
+                                                choices=self.BLOCK_STATUS_BITS,
+                                                bitmask=False)
+        if args.raw_data:
+            self.raw_data = util.get_array("raw-data", args.raw_data,
+                                           max_val=255)
+            print(self.raw_data)
+
+        if args.error_severity:
+            self.error_severity = util.get_choice(name="error-severity",
+                                                  value=args.error_severity,
+                                                  choices=self.ERROR_SEVERITY,
+                                                  bitmask=False)
+
+        if args.fru_id:
+            self.fru_id = args.fru_id.to_bytes()
+            if not args.gen_err_valid_bits:
+                self.validation_bits |= self.VALIDATION_BITS["fru-id"]
+
+        if args.fru_text:
+            text = bytearray(args.fru_text.encode('ascii'))
+            if len(text) > 20:
+                sys.exit("FRU text is too big to fit")
+
+            self.fru_text = text
+            if not args.gen_err_valid_bits:
+                self.validation_bits |= self.VALIDATION_BITS["fru-text"]
+
+        if args.timestamp:
+            time = args.timestamp
+            century = int(time.year / 100)
+
+            bcd = bytearray()
+            util.data_add(bcd, (time.second // 10) << 4 | (time.second % 10), 1)
+            util.data_add(bcd, (time.minute // 10) << 4 | (time.minute % 10), 1)
+            util.data_add(bcd, (time.hour // 10) << 4 | (time.hour % 10), 1)
+
+            if args.precise:
+                util.data_add(bcd, 1, 1)
+            else:
+                util.data_add(bcd, 0, 1)
+
+            util.data_add(bcd, (time.day // 10) << 4 | (time.day % 10), 1)
+            util.data_add(bcd, (time.month // 10) << 4 | (time.month % 10), 1)
+            util.data_add(bcd,
+                          ((time.year % 100) // 10) << 4 | (time.year % 10), 1)
+            util.data_add(bcd, ((century % 100) // 10) << 4 | (century % 10), 1)
+
+            self.timestamp = bcd
+            if not args.gen_err_valid_bits:
+                self.validation_bits |= self.VALIDATION_BITS["timestamp"]
+
+        if args.gen_err_valid_bits:
+            self.validation_bits = util.get_choice(name="validation",
+                                                   value=args.gen_err_valid_bits,
+                                                   choices=self.VALIDATION_BITS)
+
+    def __init__(self, host, port, debug=False):
+        """Initialize variables used by the QMP send logic"""
+
+        self.connected = False
+        self.host = host
+        self.port = port
+        self.debug = debug
+
+        # ACPI 6.1: 18.3.2.7.1 Generic Error Data: Generic Error Status Block
+        self.block_status = self.BLOCK_STATUS_BITS["uncorrectable"]
+        self.raw_data = []
+        self.error_severity = self.ERROR_SEVERITY["recoverable"]
+
+        # ACPI 6.1: 18.3.2.7.1 Generic Error Data: Generic Error Data Entry
+        self.validation_bits = 0
+        self.flags = 0
+        self.fru_id = bytearray(16)
+        self.fru_text = bytearray(20)
+        self.timestamp = bytearray(8)
+
+        self.qmp_monitor = QEMUMonitorProtocol(address=(self.host, self.port))
+
+    #
+    # Socket QMP send command
+    #
+    def send_cper_raw(self, cper_data):
+        """Send a raw CPER data to QEMU though QMP TCP socket"""
+
+        data = b64encode(bytes(cper_data)).decode('ascii')
+
+        cmd_arg = {
+            'cper': data
+        }
+
+        self._connect()
+
+        if self.send_cmd("inject-ghes-v2-error", cmd_arg):
+            print("Error injected.")
+
+    def send_cper(self, notif_type, payload):
+        """Send commands to QEMU though QMP TCP socket"""
+
+        # Fill CPER record header
+
+        # NOTE: bits 4 to 13 of block status contain the number of
+        # data entries in the data section. This is currently unsupported.
+
+        cper_length = len(payload)
+        data_length = cper_length + len(self.raw_data) + self.GENERIC_DATA_SIZE
+
+        #  Generic Error Data Entry
+        gede = bytearray()
+
+        gede.extend(notif_type.to_bytes())
+        util.data_add(gede, self.error_severity, 4)
+        util.data_add(gede, 0x300, 2)
+        util.data_add(gede, self.validation_bits, 1)
+        util.data_add(gede, self.flags, 1)
+        util.data_add(gede, cper_length, 4)
+        gede.extend(self.fru_id)
+        gede.extend(self.fru_text)
+        gede.extend(self.timestamp)
+
+        # Generic Error Status Block
+        gebs = bytearray()
+
+        if self.raw_data:
+            raw_data_offset = len(gebs)
+        else:
+            raw_data_offset = 0
+
+        util.data_add(gebs, self.block_status, 4)
+        util.data_add(gebs, raw_data_offset, 4)
+        util.data_add(gebs, len(self.raw_data), 4)
+        util.data_add(gebs, data_length, 4)
+        util.data_add(gebs, self.error_severity, 4)
+
+        cper_data = bytearray()
+        cper_data.extend(gebs)
+        cper_data.extend(gede)
+        cper_data.extend(bytearray(self.raw_data))
+        cper_data.extend(bytearray(payload))
+
+        if self.debug:
+            print(f"GUID: {notif_type}")
+
+            util.dump_bytearray("Generic Error Status Block", gebs)
+            util.dump_bytearray("Generic Error Data Entry", gede)
+
+            if self.raw_data:
+                util.dump_bytearray("Raw data", bytearray(self.raw_data))
+
+            util.dump_bytearray("Payload", payload)
+
+        self.send_cper_raw(cper_data)
+
+
+    def search_qom(self, path, prop, regex):
+        """
+        Return a list of devices that match path array like:
+
+            /machine/unattached/device
+            /machine/peripheral-anon/device
+            ...
+        """
+
+        found = []
+
+        i = 0
+        while 1:
+            dev = f"{path}[{i}]"
+            args = {
+                'path': dev,
+                'property': prop
+            }
+            ret = self.send_cmd("qom-get", args, may_open=True,
+                                return_error=False)
+            if not ret:
+                break
+
+            if isinstance(ret, str):
+                if regex.search(ret):
+                    found.append(dev)
+
+            i += 1
+            if i > 10000:
+                print("Too many objects returned by qom-get!")
+                break
+
+        return found
+
+class cper_guid:
+    """
+    Contains CPER GUID, as per:
+    https://uefi.org/specs/UEFI/2.10/Apx_N_Common_Platform_Error_Record.html
+    """
+
+    CPER_PROC_GENERIC =  guid(0x9876CCAD, 0x47B4, 0x4bdb,
+                              [0xB6, 0x5E, 0x16, 0xF1,
+                               0x93, 0xC4, 0xF3, 0xDB])
+
+    CPER_PROC_X86 = guid(0xDC3EA0B0, 0xA144, 0x4797,
+                         [0xB9, 0x5B, 0x53, 0xFA,
+                          0x24, 0x2B, 0x6E, 0x1D])
+
+    CPER_PROC_ITANIUM = guid(0xe429faf1, 0x3cb7, 0x11d4,
+                             [0xbc, 0xa7, 0x00, 0x80,
+                              0xc7, 0x3c, 0x88, 0x81])
+
+    CPER_PROC_ARM = guid(0xE19E3D16, 0xBC11, 0x11E4,
+                         [0x9C, 0xAA, 0xC2, 0x05,
+                          0x1D, 0x5D, 0x46, 0xB0])
+
+    CPER_PLATFORM_MEM = guid(0xA5BC1114, 0x6F64, 0x4EDE,
+                             [0xB8, 0x63, 0x3E, 0x83,
+                              0xED, 0x7C, 0x83, 0xB1])
+
+    CPER_PLATFORM_MEM2 = guid(0x61EC04FC, 0x48E6, 0xD813,
+                              [0x25, 0xC9, 0x8D, 0xAA,
+                               0x44, 0x75, 0x0B, 0x12])
+
+    CPER_PCIE = guid(0xD995E954, 0xBBC1, 0x430F,
+                     [0xAD, 0x91, 0xB4, 0x4D,
+                      0xCB, 0x3C, 0x6F, 0x35])
+
+    CPER_PCI_BUS = guid(0xC5753963, 0x3B84, 0x4095,
+                        [0xBF, 0x78, 0xED, 0xDA,
+                         0xD3, 0xF9, 0xC9, 0xDD])
+
+    CPER_PCI_DEV = guid(0xEB5E4685, 0xCA66, 0x4769,
+                        [0xB6, 0xA2, 0x26, 0x06,
+                         0x8B, 0x00, 0x13, 0x26])
+
+    CPER_FW_ERROR = guid(0x81212A96, 0x09ED, 0x4996,
+                         [0x94, 0x71, 0x8D, 0x72,
+                          0x9C, 0x8E, 0x69, 0xED])
+
+    CPER_DMA_GENERIC = guid(0x5B51FEF7, 0xC79D, 0x4434,
+                            [0x8F, 0x1B, 0xAA, 0x62,
+                             0xDE, 0x3E, 0x2C, 0x64])
+
+    CPER_DMA_VT = guid(0x71761D37, 0x32B2, 0x45cd,
+                       [0xA7, 0xD0, 0xB0, 0xFE,
+                        0xDD, 0x93, 0xE8, 0xCF])
+
+    CPER_DMA_IOMMU = guid(0x036F84E1, 0x7F37, 0x428c,
+                         [0xA7, 0x9E, 0x57, 0x5F,
+                          0xDF, 0xAA, 0x84, 0xEC])
+
+    CPER_CCIX_PER = guid(0x91335EF6, 0xEBFB, 0x4478,
+                         [0xA6, 0xA6, 0x88, 0xB7,
+                          0x28, 0xCF, 0x75, 0xD7])
+
+    CPER_CXL_PROT_ERR = guid(0x80B9EFB4, 0x52B5, 0x4DE3,
+                             [0xA7, 0x77, 0x68, 0x78,
+                              0x4B, 0x77, 0x10, 0x48])
-- 
2.49.0


