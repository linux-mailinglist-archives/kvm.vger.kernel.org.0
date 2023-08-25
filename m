Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2557886C8
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244592AbjHYMPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244578AbjHYMPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:15:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1830F1BC2;
        Fri, 25 Aug 2023 05:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965733; x=1724501733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kJrFgFL5kQmXj3VvYjREAA0cgzDxTV0iK4UB6/LbnKY=;
  b=B4RdHLqOji4Oc/SG6NfntSCYJkLRAJpkcGxZlO5MXoLaNNb5LM7KDEYY
   T+ua5KnkScEuspNGFmXkFmQWc2cX+2QnJSjy+laXkNInbbx/eyCQAgbsJ
   ZLNzjhytscF3f987CKIOeSasSvrINZsQhVNli3Ds5vrjRkzjJZaWo3ItB
   nYVW+4KeMA5Eq/b5o/q8V32Y0vphW3wGUnFb8x4MGeANtCPKB8nGsuxA6
   z383p7Drv0HyaaOpthdLH1CyHHpQGhtdWG8iHfjnq4MyNJ04XJyNgcpkW
   QxXJNU/XuCD2KYZM3xtAfVgJCgexGycQ8w2NB7QvfRjTRyOWYZRH5OwOU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639054"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639054"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881157956"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:03 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v13 01/22] x86/virt/tdx: Detect TDX during kernel boot
Date:   Sat, 26 Aug 2023 00:14:20 +1200
Message-ID: <7329a23e94e10e222fce6ef4685c429b9377cad6.1692962263.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  A CPU-attested software module
called 'the TDX module' runs inside a new isolated memory range as a
trusted hypervisor to manage and run protected VMs.

Pre-TDX Intel hardware has support for a memory encryption architecture
called MKTME.  The memory encryption hardware underpinning MKTME is also
used for Intel TDX.  TDX ends up "stealing" some of the physical address
space from the MKTME architecture for crypto-protection to VMs.  The
BIOS is responsible for partitioning the "KeyID" space between legacy
MKTME and TDX.  The KeyIDs reserved for TDX are called 'TDX private
KeyIDs' or 'TDX KeyIDs' for short.

During machine boot, TDX microcode verifies that the BIOS programmed TDX
private KeyIDs consistently and correctly programmed across all CPU
packages.  The MSRs are locked in this state after verification.  This
is why MSR_IA32_MKTME_KEYID_PARTITIONING gets used for TDX enumeration:
it indicates not just that the hardware supports TDX, but that all the
boot-time security checks passed.

The TDX module is expected to be loaded by the BIOS when it enables TDX,
but the kernel needs to properly initialize it before it can be used to
create and run any TDX guests.  The TDX module will be initialized by
the KVM subsystem when KVM wants to use TDX.

Add a new early_initcall(tdx_init) to detect the TDX by detecting TDX
private KeyIDs.  Also add a function to report whether TDX is enabled by
the BIOS.  Similar to AMD SME, kexec() will use it to determine whether
cache flush is needed.

The TDX module itself requires one TDX KeyID as the 'TDX global KeyID'
to protect its metadata.  Each TDX guest also needs a TDX KeyID for its
own protection.  Just use the first TDX KeyID as the global KeyID and
leave the rest for TDX guests.  If no TDX KeyID is left for TDX guests,
disable TDX as initializing the TDX module alone is useless.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---

v12 -> v13:
 - Rebase to TDCALL assembly series.

v11 -> v12:
 - Improve setting up guest's TDX keyID range (David)
   - ++tdx_keyid_start -> tdx_keyid_start + 1
   - --nr_tdx_keyids -> nr_tdx_keyids - 1 
 - 'return -ENODEV' instead of 'goto no_tdx' (Sathy)
 - pr_info() -> pr_err() (Isaku)
 - Added tags from Isaku/David

v10 -> v11 (David):
 - "host kernel" -> "the host kernel"
 - "protected VM" -> "confidential VM".
 - Moved setting tdx_global_keyid to the end of tdx_init().

v9 -> v10:
 - No change.

v8 -> v9:
 - Moved MSR macro from local tdx.h to <asm/msr-index.h> (Dave).
 - Moved reserving the TDX global KeyID from later patch to here.
 - Changed 'tdx_keyid_start' and 'nr_tdx_keyids' to
   'tdx_guest_keyid_start' and 'tdx_nr_guest_keyids' to represent KeyIDs
   can be used by guest. (Dave)
 - Slight changelog update according to above changes.

v7 -> v8: (address Dave's comments)
 - Improved changelog:
    - "KVM user" -> "The TDX module will be initialized by KVM when ..."
    - Changed "tdx_int" part to "Just say what this patch is doing"
    - Fixed the last sentence of "kexec()" paragraph
  - detect_tdx() -> record_keyid_partitioning()
  - Improved how to calculate tdx_keyid_start.
  - tdx_keyid_num -> nr_tdx_keyids.
  - Improved dmesg printing.
  - Add comment to clear_tdx().

v6 -> v7:
 - No change.

v5 -> v6:
 - Removed SEAMRR detection to make code simpler.
 - Removed the 'default N' in the KVM_TDX_HOST Kconfig (Kirill).
 - Changed to use 'obj-y' in arch/x86/virt/vmx/tdx/Makefile (Kirill).


---
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/tdx.h       |  4 ++
 arch/x86/virt/vmx/tdx/Makefile   |  2 +-
 arch/x86/virt/vmx/tdx/tdx.c      | 90 ++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a00a53e15ab7..342fc6011b4d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -523,6 +523,9 @@
 #define MSR_RELOAD_PMC0			0x000014c1
 #define MSR_RELOAD_FIXED_CTR0		0x00001309
 
+/* KeyID partitioning between MKTME and TDX */
+#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
+
 /*
  * AMD64 MSRs. Not complete. See the architecture manual for a more
  * complete list.
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index adcbe3f1de30..a252328734c7 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -81,6 +81,10 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 u64 __seamcall(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
+
+bool platform_tdx_enabled(void);
+#else
+static inline bool platform_tdx_enabled(void) { return false; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
index 46ef8f73aebb..90da47eb85ee 100644
--- a/arch/x86/virt/vmx/tdx/Makefile
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-y += seamcall.o
+obj-y += seamcall.o tdx.o
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
new file mode 100644
index 000000000000..908590e85749
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2023 Intel Corporation.
+ *
+ * Intel Trusted Domain Extensions (TDX) support
+ */
+
+#define pr_fmt(fmt)	"tdx: " fmt
+
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/printk.h>
+#include <asm/msr-index.h>
+#include <asm/msr.h>
+#include <asm/tdx.h>
+
+static u32 tdx_global_keyid __ro_after_init;
+static u32 tdx_guest_keyid_start __ro_after_init;
+static u32 tdx_nr_guest_keyids __ro_after_init;
+
+static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
+					    u32 *nr_tdx_keyids)
+{
+	u32 _nr_mktme_keyids, _tdx_keyid_start, _nr_tdx_keyids;
+	int ret;
+
+	/*
+	 * IA32_MKTME_KEYID_PARTIONING:
+	 *   Bit [31:0]:	Number of MKTME KeyIDs.
+	 *   Bit [63:32]:	Number of TDX private KeyIDs.
+	 */
+	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &_nr_mktme_keyids,
+			&_nr_tdx_keyids);
+	if (ret)
+		return -ENODEV;
+
+	if (!_nr_tdx_keyids)
+		return -ENODEV;
+
+	/* TDX KeyIDs start after the last MKTME KeyID. */
+	_tdx_keyid_start = _nr_mktme_keyids + 1;
+
+	*tdx_keyid_start = _tdx_keyid_start;
+	*nr_tdx_keyids = _nr_tdx_keyids;
+
+	return 0;
+}
+
+static int __init tdx_init(void)
+{
+	u32 tdx_keyid_start, nr_tdx_keyids;
+	int err;
+
+	err = record_keyid_partitioning(&tdx_keyid_start, &nr_tdx_keyids);
+	if (err)
+		return err;
+
+	pr_info("BIOS enabled: private KeyID range [%u, %u)\n",
+			tdx_keyid_start, tdx_keyid_start + nr_tdx_keyids);
+
+	/*
+	 * The TDX module itself requires one 'global KeyID' to protect
+	 * its metadata.  If there's only one TDX KeyID, there won't be
+	 * any left for TDX guests thus there's no point to enable TDX
+	 * at all.
+	 */
+	if (nr_tdx_keyids < 2) {
+		pr_err("initialization failed: too few private KeyIDs available.\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Just use the first TDX KeyID as the 'global KeyID' and
+	 * leave the rest for TDX guests.
+	 */
+	tdx_global_keyid = tdx_keyid_start;
+	tdx_guest_keyid_start = tdx_keyid_start + 1;
+	tdx_nr_guest_keyids = nr_tdx_keyids - 1;
+
+	return 0;
+}
+early_initcall(tdx_init);
+
+/* Return whether the BIOS has enabled TDX */
+bool platform_tdx_enabled(void)
+{
+	return !!tdx_global_keyid;
+}
-- 
2.41.0

