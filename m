Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CFB129FA
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 10:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfECIkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 04:40:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:5280 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfECIkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 04:40:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 01:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,425,1549958400"; 
   d="scan'208";a="296632863"
Received: from khuang2-desk.gar.corp.intel.com ([10.254.24.58])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2019 01:40:43 -0700
From:   Kai Huang <kai.huang@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, junaids@google.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, kai.huang@intel.com,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [PATCH] kvm: x86: Fix L1TF mitigation for shadow MMU
Date:   Fri,  3 May 2019 20:40:25 +1200
Message-Id: <20190503084025.24549-1-kai.huang@linux.intel.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently KVM sets 5 most significant bits of physical address bits
reported by CPUID (boot_cpu_data.x86_phys_bits) for nonpresent or
reserved bits SPTE to mitigate L1TF attack from guest when using shadow
MMU. However for some particular Intel CPUs the physical address bits
of internal cache is greater than physical address bits reported by
CPUID.

Use the kernel's existing boot_cpu_data.x86_cache_bits to determine the
five most significant bits. Doing so improves KVM's L1TF mitigation in
the unlikely scenario that system RAM overlaps the high order bits of
the "real" physical address space as reported by CPUID. This aligns with
the kernel's warnings regarding L1TF mitigation, e.g. in the above
scenario the kernel won't warn the user about lack of L1TF mitigation
if x86_cache_bits is greater than x86_phys_bits.

Also initialize shadow_nonpresent_or_rsvd_mask explicitly to make it
consistent with other 'shadow_{xxx}_mask', and opportunistically add a
WARN once if KVM's L1TF mitigation cannot be applied on a system that
is marked as being susceptible to L1TF.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
---

This patch was splitted from old patch I sent out around 2 weeks ago:

kvm: x86: Fix several SPTE mask calculation errors caused by MKTME

After reviewing with Sean Christopherson it's better to split this out,
since the logic in this patch is independent. And maybe this patch should
also be into stable.

---
 arch/x86/kvm/mmu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b0899f175db9..1b2380e0060f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -511,16 +511,24 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	 * If the CPU has 46 or less physical address bits, then set an
 	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
 	 * assumed that the CPU is not vulnerable to L1TF.
+	 *
+	 * Some Intel CPUs address the L1 cache using more PA bits than are
+	 * reported by CPUID. Use the PA width of the L1 cache when possible
+	 * to achieve more effective mitigation, e.g. if system RAM overlaps
+	 * the most significant bits of legal physical address space.
 	 */
-	low_phys_bits = boot_cpu_data.x86_phys_bits;
-	if (boot_cpu_data.x86_phys_bits <
+	shadow_nonpresent_or_rsvd_mask = 0;
+	low_phys_bits = boot_cpu_data.x86_cache_bits;
+	if (boot_cpu_data.x86_cache_bits <
 	    52 - shadow_nonpresent_or_rsvd_mask_len) {
 		shadow_nonpresent_or_rsvd_mask =
-			rsvd_bits(boot_cpu_data.x86_phys_bits -
+			rsvd_bits(boot_cpu_data.x86_cache_bits -
 				  shadow_nonpresent_or_rsvd_mask_len,
-				  boot_cpu_data.x86_phys_bits - 1);
+				  boot_cpu_data.x86_cache_bits - 1);
 		low_phys_bits -= shadow_nonpresent_or_rsvd_mask_len;
-	}
+	} else
+		WARN_ON_ONCE(boot_cpu_has_bug(X86_BUG_L1TF));
+
 	shadow_nonpresent_or_rsvd_lower_gfn_mask =
 		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
 }
-- 
2.13.6

