Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F5CDF8D6
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfJUX4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:56:48 -0400
Received: from mga07.intel.com ([134.134.136.100]:63371 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbfJUX4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:56:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 16:56:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="222630834"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 21 Oct 2019 16:56:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 02/16] x86/mce: WARN once if IA32_FEATURE_CONTROL MSR is left unlocked
Date:   Mon, 21 Oct 2019 16:56:42 -0700
Message-Id: <20191021235642.418-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191021234632.32363-1-sean.j.christopherson@intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if the IA32_FEATURE_CONTROL MSR is somehow left unlocked now that
CPU initialization unconditionally locks the MSR.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/mce/intel.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 88cd9598fa57..1008f14b803b 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -117,11 +117,10 @@ static bool lmce_supported(void)
 	 * generate a #GP fault.
 	 */
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, tmp);
-	if ((tmp & (FEATURE_CONTROL_LOCKED | FEATURE_CONTROL_LMCE)) ==
-		   (FEATURE_CONTROL_LOCKED | FEATURE_CONTROL_LMCE))
-		return true;
+	if (WARN_ON_ONCE(!(tmp & FEATURE_CONTROL_LOCKED)))
+		return false;
 
-	return false;
+	return tmp & FEATURE_CONTROL_LMCE;
 }
 
 bool mce_intel_cmci_poll(void)
-- 
2.22.0

