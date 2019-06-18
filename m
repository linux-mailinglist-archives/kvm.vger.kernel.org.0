Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECFC4AE26
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbfFRWvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:51:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:48880 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730979AbfFRWvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009395"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:13 -0700
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
Subject: [PATCH v9 17/17] x86/split_lock: Warn on unaligned address in atomic bit operations
Date:   Tue, 18 Jun 2019 15:41:19 -0700
Message-Id: <1560897679-228028-18-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An atomic bit operation operates one bit in a single unsigned long location
in a bitmap. In 64-bit mode, the location is at:
base address of the bitmap + (bit offset in the bitmap / 64) * 8

If the base address is unaligned to unsigned long, each unsigned long
location operated by the atomic operation will be unaligned to unsigned
long and a split lock issue will happen if the unsigned long location
crosses two cache lines.

So checking alignment of the base address can proactively audit potential
split lock issues in the atomic bit operation. A real split lock issue
may or may not happen depending on the bit offset.

Once analyzing the warning information, kernel developer can fix the
potential split lock issue by aligning the base address to unsigned long
instead of waiting for a real split lock issue happens.

After applying this patch on 5.2-rc1, vmlinux size is increased by 0.2%
and bzImage size is increased by 0.3% with allyesconfig.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---

FYI. After applying this patch, I haven't noticed any warning generated
from this patch with booting and limited run time tests on a few platforms.

 arch/x86/include/asm/bitops.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 8e790ec219a5..44d7a353d6fd 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -14,6 +14,7 @@
 #endif
 
 #include <linux/compiler.h>
+#include <linux/bug.h>
 #include <asm/alternative.h>
 #include <asm/rmwcc.h>
 #include <asm/barrier.h>
@@ -67,6 +68,8 @@
 static __always_inline void
 set_bit(long nr, volatile unsigned long *addr)
 {
+	WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
 			: CONST_MASK_ADDR(nr, addr)
@@ -105,6 +108,8 @@ static __always_inline void __set_bit(long nr, volatile unsigned long *addr)
 static __always_inline void
 clear_bit(long nr, volatile unsigned long *addr)
 {
+	WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
 			: CONST_MASK_ADDR(nr, addr)
@@ -137,6 +142,9 @@ static __always_inline void __clear_bit(long nr, volatile unsigned long *addr)
 static __always_inline bool clear_bit_unlock_is_negative_byte(long nr, volatile unsigned long *addr)
 {
 	bool negative;
+
+	WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
 	asm volatile(LOCK_PREFIX "andb %2,%1"
 		CC_SET(s)
 		: CC_OUT(s) (negative), WBYTE_ADDR(addr)
@@ -186,6 +194,8 @@ static __always_inline void __change_bit(long nr, volatile unsigned long *addr)
  */
 static __always_inline void change_bit(long nr, volatile unsigned long *addr)
 {
+	WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "xorb %1,%0"
 			: CONST_MASK_ADDR(nr, addr)
@@ -206,6 +216,8 @@ static __always_inline void change_bit(long nr, volatile unsigned long *addr)
  */
 static __always_inline bool test_and_set_bit(long nr, volatile unsigned long *addr)
 {
+	WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
 	return GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, c, "Ir", nr);
 }
 
@@ -252,6 +264,8 @@ static __always_inline bool __test_and_set_bit(long nr, volatile unsigned long *
  */
 static __always_inline bool test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
+	WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
 	return GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(btr), *addr, c, "Ir", nr);
 }
 
@@ -305,6 +319,8 @@ static __always_inline bool __test_and_change_bit(long nr, volatile unsigned lon
  */
 static __always_inline bool test_and_change_bit(long nr, volatile unsigned long *addr)
 {
+	WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
 	return GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(btc), *addr, c, "Ir", nr);
 }
 
-- 
2.19.1

