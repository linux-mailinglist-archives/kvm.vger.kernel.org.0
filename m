Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892B34AE2D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfFRWvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:51:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:48876 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730982AbfFRWvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009392"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:12 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 16/17] x86/split_lock: Reorganize few header files in order to call WARN_ON_ONCE() in atomic bit ops
Date:   Tue, 18 Jun 2019 15:41:18 -0700
Message-Id: <1560897679-228028-17-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>

Calling WARN_ON_ONCE() from atomic bit ops xxx_bit() throws a build error
as shown below.

  HOSTLD  scripts/mod/modpost
  CC      kernel/bounds.s
  CALL    scripts/atomic/check-atomics.sh
In file included from ./include/linux/bitops.h:19:0,
                 from ./include/linux/kernel.h:12,
                 from ./include/asm-generic/bug.h:18,
                 from ./arch/x86/include/asm/bug.h:83,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/page-flags.h:10,
                 from kernel/bounds.c:10:
./arch/x86/include/asm/bitops.h: In function 'set_bit':
./arch/x86/include/asm/bitops.h:164:2: error: implicit declaration of
function 'WARN_ON_ONCE' [-Werror=implicit-function-declaration]
  WARN_ON_ONCE(!ALIGNED_TO_UNSIGNED_LONG((unsigned long)addr));
  ^
  UPD     include/generated/timeconst.h
cc1: some warnings being treated as errors
scripts/Makefile.build:112: recipe for target 'kernel/bounds.s' failed
make[1]: *** [kernel/bounds.s] Error 1
make[1]: *** Waiting for unfinished jobs....
Makefile:1095: recipe for target 'prepare0' failed
make: *** [prepare0] Error 2
make: *** Waiting for unfinished jobs....
  INSTALL usr/include/asm/ (62 files)

The compiler complains that "WARN_ON_ONCE()" is undefined and the common
approach to fix this is to include the right header file in
<linux/bitops.h>. But, including any of <linux/bug.h> or
<asm-generic/bug.h> or <asm/bug.h> in <linux/bitops.h> doesn't help because
these files are already included by <linux/page-flags.h> (please refer to
the include chain above) and they won't be double included because of
<linux/bitops.h> with this include chain.

So, we need a different approach to solve this issue. Taking a look at
<linux/kernel.h> revealed that it doesn't use any macros, functions or
data_types introduced by <linux/bitops.h>. Hence, don't include
<linux/bitops.h> in <linux/kernel.h>. This fixes the issue because now
there are no references to "WARN_ON_ONCE()" by <linux/kernel.h>. Not
including <linux/bitops.h> in <linux/kernel.h> does help in progressing the
build further but now it breaks at a different point. Applying the same
above technique reveals that <linux/kernel.h> doesn't need <linux/log2.h>
and <asm/div64.h>. Hence, don't include them either.

Since, <linux/kernel.h> now doesn't include <linux/bitops.h>,
<linux/log2.h> and <asm/div64.h>, the build now breaks at yet another point
because there are some files in the repository that include
<linux/kernel.h> but refer to macros, functions or data_types introduced by
either of <linux/bitops.h>, <linux/log2.h> or <asm/div64.h>. Hence, fix
them up appropriately by including the right header file.

Note: This patch has been tested with "make allyesconfig" for x86_64 and
has been going through 0-day Continuous Integration (CI) system (thanks for
reporting build issues with IA64, Microblaze, MIPS, m68k, xtensa and
powerpc). But, please be aware that as <linux/kernel.h> has been modified
it could lead to build failures for some unknown configs on architectures
other than x86_64. The fix should really be simple, i.e. include the right
header file (please refer to this patch for fix examples).

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Build-tested-by: kbuild test robot <lkp@intel.com>
---

Questions to the community:
---------------------------
1. Although this patch has been an outcome to support adding WARN_ON_ONCE() to
xxx_bit() ops functions, it solves an underlying issue i.e. including
unnecessary header files in linux/kernel.h. So, if we consider the problem to be
this, can we view this patch as a stand-alone (i.e. decouple it entirely from
split lock)?

2. This patch causes a lot of header thrash and has already broken build for
various architectures (all the outstanding issues are addressed), do you think
it makes sense to have this header thrash?

3. If this patch makes sense, does it also make sense to get this into Andrew
Morton's tree first so that it's well tested before it's considered for Linus's
tree?

Note:
-----
This patch (on other architectures except x86) has been tested only for
build issues and wasn't tested for boot issues (i.e. I haven't booted this
kernel on other architectures because I don't have access to them and I
*assumed* there shouldn't be any boot problems because of the nature of the
patch)

 arch/microblaze/kernel/cpu/pvr.c                     | 1 +
 arch/mips/ralink/mt7620.c                            | 1 +
 arch/powerpc/include/asm/cmpxchg.h                   | 1 +
 arch/xtensa/include/asm/traps.h                      | 1 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c | 2 ++
 drivers/net/ethernet/freescale/fman/fman_muram.c     | 1 +
 drivers/soc/renesas/rcar-sysc.h                      | 2 +-
 drivers/staging/fwserial/dma_fifo.c                  | 1 +
 include/linux/assoc_array_priv.h                     | 1 +
 include/linux/ata.h                                  | 1 +
 include/linux/gpio/consumer.h                        | 1 +
 include/linux/iommu-helper.h                         | 1 +
 include/linux/kernel.h                               | 4 ----
 include/linux/sched.h                                | 1 +
 kernel/bpf/tnum.c                                    | 1 +
 lib/clz_ctz.c                                        | 1 +
 lib/errseq.c                                         | 1 +
 lib/flex_proportions.c                               | 1 +
 lib/hexdump.c                                        | 1 +
 lib/lz4/lz4defs.h                                    | 1 +
 lib/math/div64.c                                     | 1 +
 lib/math/gcd.c                                       | 1 +
 lib/math/reciprocal_div.c                            | 1 +
 lib/siphash.c                                        | 1 +
 net/netfilter/nf_conntrack_h323_asn1.c               | 1 +
 25 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/kernel/cpu/pvr.c b/arch/microblaze/kernel/cpu/pvr.c
index 8d0dc6db48cf..f139052a39bd 100644
--- a/arch/microblaze/kernel/cpu/pvr.c
+++ b/arch/microblaze/kernel/cpu/pvr.c
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <asm/exceptions.h>
 #include <asm/pvr.h>
+#include <linux/irqflags.h>
 
 /*
  * Until we get an assembler that knows about the pvr registers,
diff --git a/arch/mips/ralink/mt7620.c b/arch/mips/ralink/mt7620.c
index c1ce6f43642b..89079885e4bc 100644
--- a/arch/mips/ralink/mt7620.c
+++ b/arch/mips/ralink/mt7620.c
@@ -18,6 +18,7 @@
 #include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/mt7620.h>
 #include <asm/mach-ralink/pinmux.h>
+#include <asm/div64.h>
 
 #include "common.h"
 
diff --git a/arch/powerpc/include/asm/cmpxchg.h b/arch/powerpc/include/asm/cmpxchg.h
index 27183871eb3b..8727e2b9378b 100644
--- a/arch/powerpc/include/asm/cmpxchg.h
+++ b/arch/powerpc/include/asm/cmpxchg.h
@@ -7,6 +7,7 @@
 #include <asm/synch.h>
 #include <linux/bug.h>
 #include <asm/asm-405.h>
+#include <linux/bits.h>
 
 #ifdef __BIG_ENDIAN
 #define BITOFF_CAL(size, off)	((sizeof(u32) - size - off) * BITS_PER_BYTE)
diff --git a/arch/xtensa/include/asm/traps.h b/arch/xtensa/include/asm/traps.h
index f720a57d0a5b..8ae962f5352b 100644
--- a/arch/xtensa/include/asm/traps.h
+++ b/arch/xtensa/include/asm/traps.h
@@ -11,6 +11,7 @@
 #define _XTENSA_TRAPS_H
 
 #include <asm/ptrace.h>
+#include <asm/regs.h>
 
 /*
  * Per-CPU exception handling data structure.
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
index d6f5af6609c1..898e211365fb 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
@@ -7,6 +7,8 @@
  * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
  */
 
+#include <linux/bits.h>
+
 #include "cxd2880_common.h"
 
 int cxd2880_convert2s_complement(u32 value, u32 bitlen)
diff --git a/drivers/net/ethernet/freescale/fman/fman_muram.c b/drivers/net/ethernet/freescale/fman/fman_muram.c
index 5ec94d243da0..28edee4779aa 100644
--- a/drivers/net/ethernet/freescale/fman/fman_muram.c
+++ b/drivers/net/ethernet/freescale/fman/fman_muram.c
@@ -35,6 +35,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/genalloc.h>
+#include <linux/log2.h>
 
 struct muram_info {
 	struct gen_pool *pool;
diff --git a/drivers/soc/renesas/rcar-sysc.h b/drivers/soc/renesas/rcar-sysc.h
index 485520a5b295..7595b731a6a2 100644
--- a/drivers/soc/renesas/rcar-sysc.h
+++ b/drivers/soc/renesas/rcar-sysc.h
@@ -8,7 +8,7 @@
 #define __SOC_RENESAS_RCAR_SYSC_H__
 
 #include <linux/types.h>
-
+#include <linux/bitops.h>
 
 /*
  * Power Domain flags
diff --git a/drivers/staging/fwserial/dma_fifo.c b/drivers/staging/fwserial/dma_fifo.c
index 5dcbab6fd622..d06b72594658 100644
--- a/drivers/staging/fwserial/dma_fifo.c
+++ b/drivers/staging/fwserial/dma_fifo.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/bug.h>
+#include <linux/log2.h>
 
 #include "dma_fifo.h"
 
diff --git a/include/linux/assoc_array_priv.h b/include/linux/assoc_array_priv.h
index dca733ef6750..9b4b3e666b74 100644
--- a/include/linux/assoc_array_priv.h
+++ b/include/linux/assoc_array_priv.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_ASSOCIATIVE_ARRAY
 
 #include <linux/assoc_array.h>
+#include <linux/log2.h>
 
 #define ASSOC_ARRAY_FAN_OUT		16	/* Number of slots per node */
 #define ASSOC_ARRAY_FAN_MASK		(ASSOC_ARRAY_FAN_OUT - 1)
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 6e67aded28f8..506f8d4487c5 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -17,6 +17,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
+#include <linux/bitops.h>
 
 /* defines only for the constants which don't work well as enums */
 #define ATA_DMA_BOUNDARY	0xffffUL
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 9ddcf50a3c59..099048c0edb4 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -5,6 +5,7 @@
 #include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/bits.h>
 
 struct device;
 
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index 70d01edcbf8b..20b706abadc7 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -4,6 +4,7 @@
 
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 
 static inline unsigned long iommu_device_max_index(unsigned long size,
 						   unsigned long offset,
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 74b1ee9027f5..117093d268d3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -9,15 +9,11 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/bitops.h>
-#include <linux/log2.h>
 #include <linux/typecheck.h>
 #include <linux/printk.h>
 #include <linux/build_bug.h>
 #include <asm/byteorder.h>
-#include <asm/div64.h>
 #include <uapi/linux/kernel.h>
-#include <asm/div64.h>
 
 #define STACK_MAGIC	0xdeadbeef
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 11837410690f..8eec4404b4a2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -29,6 +29,7 @@
 #include <linux/mm_types_task.h>
 #include <linux/task_io_accounting.h>
 #include <linux/rseq.h>
+#include <linux/log2.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
 struct audit_context;
diff --git a/kernel/bpf/tnum.c b/kernel/bpf/tnum.c
index ca52b9642943..2f28ef5a2929 100644
--- a/kernel/bpf/tnum.c
+++ b/kernel/bpf/tnum.c
@@ -8,6 +8,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/tnum.h>
+#include <linux/bitops.h>
 
 #define TNUM(_v, _m)	(struct tnum){.value = _v, .mask = _m}
 /* A completely unknown value */
diff --git a/lib/clz_ctz.c b/lib/clz_ctz.c
index 2e11e48446ab..8e807c60a69a 100644
--- a/lib/clz_ctz.c
+++ b/lib/clz_ctz.c
@@ -15,6 +15,7 @@
 
 #include <linux/export.h>
 #include <linux/kernel.h>
+#include <linux/bitops.h>
 
 int __weak __ctzsi2(int val);
 int __weak __ctzsi2(int val)
diff --git a/lib/errseq.c b/lib/errseq.c
index 81f9e33aa7e7..93e9b94358dc 100644
--- a/lib/errseq.c
+++ b/lib/errseq.c
@@ -3,6 +3,7 @@
 #include <linux/bug.h>
 #include <linux/atomic.h>
 #include <linux/errseq.h>
+#include <linux/log2.h>
 
 /*
  * An errseq_t is a way of recording errors in one place, and allowing any
diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
index 7852bfff50b1..13be57ccd54c 100644
--- a/lib/flex_proportions.c
+++ b/lib/flex_proportions.c
@@ -34,6 +34,7 @@
  * which something happened with proportion of type j.
  */
 #include <linux/flex_proportions.h>
+#include <linux/log2.h>
 
 int fprop_global_init(struct fprop_global *p, gfp_t gfp)
 {
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 81b70ed37209..926c7597920c 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <asm/unaligned.h>
+#include <linux/log2.h>
 
 const char hex_asc[] = "0123456789abcdef";
 EXPORT_SYMBOL(hex_asc);
diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
index 1a7fa9d9170f..9de1a56a462b 100644
--- a/lib/lz4/lz4defs.h
+++ b/lib/lz4/lz4defs.h
@@ -37,6 +37,7 @@
 
 #include <asm/unaligned.h>
 #include <linux/string.h>	 /* memset, memcpy */
+#include <linux/bitops.h>
 
 #define FORCE_INLINE __always_inline
 
diff --git a/lib/math/div64.c b/lib/math/div64.c
index 368ca7fd0d82..6e7673033fe7 100644
--- a/lib/math/div64.c
+++ b/lib/math/div64.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
+#include <linux/bitops.h>
 
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
diff --git a/lib/math/gcd.c b/lib/math/gcd.c
index e3b042214d1b..6be5fd7d199d 100644
--- a/lib/math/gcd.c
+++ b/lib/math/gcd.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/gcd.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 
 /*
  * This implements the binary GCD algorithm. (Often attributed to Stein,
diff --git a/lib/math/reciprocal_div.c b/lib/math/reciprocal_div.c
index bf043258fa00..f438baa3dbc3 100644
--- a/lib/math/reciprocal_div.c
+++ b/lib/math/reciprocal_div.c
@@ -4,6 +4,7 @@
 #include <asm/div64.h>
 #include <linux/reciprocal_div.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 
 /*
  * For a description of the algorithm please have a look at
diff --git a/lib/siphash.c b/lib/siphash.c
index c47bb6ff2149..16677dce91de 100644
--- a/lib/siphash.c
+++ b/lib/siphash.c
@@ -12,6 +12,7 @@
 
 #include <linux/siphash.h>
 #include <asm/unaligned.h>
+#include <linux/bitops.h>
 
 #if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG == 64
 #include <linux/dcache.h>
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 4c2ef42e189c..5c9d2291f140 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -16,6 +16,7 @@
 #include <stdio.h>
 #endif
 #include <linux/netfilter/nf_conntrack_h323_asn1.h>
+#include <linux/bits.h>
 
 /* Trace Flag */
 #ifndef H323_TRACE
-- 
2.19.1

