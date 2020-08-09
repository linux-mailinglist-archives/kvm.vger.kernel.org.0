Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDED23FD45
	for <lists+kvm@lfdr.de>; Sun,  9 Aug 2020 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgHIHxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 03:53:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:53373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgHIHxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Aug 2020 03:53:15 -0400
IronPort-SDR: nFrYW+JFyliFBF31xCyvDOKrxMcN9SF8jgNc91754eGKeKJ3IkTVovaO0qmgeLCgl4sHwaF/rD
 JtZ4t1gQJx2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9707"; a="217734915"
X-IronPort-AV: E=Sophos;i="5.75,452,1589266800"; 
   d="scan'208";a="217734915"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2020 00:53:15 -0700
IronPort-SDR: zznu8IwFv3YSw+TjCJfwDjFT/U5P7bV+gXN3DrF+V5qm+MwMB+29J2IkXNCJNuUKwKlpy2shYX
 86qFnjFeDcuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,452,1589266800"; 
   d="scan'208";a="277033484"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2020 00:53:10 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        tony.luck@intel.com, dave.hansen@intel.com,
        kyung.min.park@intel.com, ricardo.neri-calderon@linux.intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        jpoimboe@redhat.com, ak@linux.intel.com, ravi.v.shankar@intel.com,
        Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH v3 2/2] x86/kvm: Expose new features for supported cpuid
Date:   Sun,  9 Aug 2020 15:47:22 +0800
Message-Id: <1596959242-2372-3-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
References: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose the SERIALIZE and TSX Suspend Load Address Tracking
features in KVM CPUID, so when running on processors which
support them, KVM could pass this information to guests and
they can make use of these features accordingly.

SERIALIZE is a faster serializing instruction which does not modify
registers, arithmetic flags or memory, will not cause VM exit. It's
availability is indicated by CPUID.(EAX=7,ECX=0):ECX[bit 14].

TSX suspend load tracking instruction aims to give a way to choose
which memory accesses do not need to be tracked in the TSX read set.
It's availability is indicated as CPUID.(EAX=7,ECX=0):EDX[bit 16].

Those instructions are currently documented in the the latest "extensions"
manual (ISE). It will appear in the "main" manual (SDM) in the future.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v2:
 * Merge two patches into a single one. (Luck, Tony)
 * Add overview introduction for features. (Sean Christopherson)
 * Refactor commit message to explain why expose feature bits. (Luck, Tony)
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9..dcf48cc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -341,7 +341,8 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
+		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
+		F(SERIALIZE) | F(TSXLDTRK)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-- 
1.8.3.1

