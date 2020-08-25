Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4B4250DDE
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 02:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgHYAyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 20:54:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:44396 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbgHYAyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 20:54:02 -0400
IronPort-SDR: VvvM+0L8VGw3xHnsYiMuOB10wfJP2+OocV8pTYyzmQP3gbdrEjqMW4jY2wSd5E8b+LZiy2RTHD
 uowByHh5yNbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="220284916"
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="220284916"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 17:54:02 -0700
IronPort-SDR: LLvBxzWhq25bkfXbFZVAzsoS6K+kmlkkiBeJ32HBDUnIVB596K7Tkalkp+Brgga3IuQliKmDeW
 WVSd/+KMtAuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="281351941"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2020 17:53:57 -0700
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
Subject: [PATCH v4 2/2] x86/kvm: Expose TSX Suspend Load Tracking feature
Date:   Tue, 25 Aug 2020 08:47:58 +0800
Message-Id: <1598316478-23337-3-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598316478-23337-1-git-send-email-cathy.zhang@intel.com>
References: <1598316478-23337-1-git-send-email-cathy.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TSX suspend load tracking instruction is supported by
Intel processor, Sapphire Rapids. It aims to give a
way to choose which memory accesses do not need to be
tracked in the TSX read set. It's availability is indicated
as CPUID.(EAX=7,ECX=0):EDX[bit 16].

Expose TSX Suspend Load Address Tracking feature in KVM
CPUID, so KVM could pass this information to guests and
they can make use of this feature accordingly.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v3:
 * Remove SERIALIZE part and refactor commit message..

Changes since v2:
 * Merge two patches into a single one. (Luck, Tony)
 * Add overview introduction for features. (Sean Christopherson)
 * Refactor commit message to explain why expose feature bits. (Luck, Tony)
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec..7456f9a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -371,7 +371,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE)
+		F(SERIALIZE) | F(TSXLDTRK)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-- 
1.8.3.1

