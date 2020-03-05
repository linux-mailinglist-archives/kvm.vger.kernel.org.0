Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C66179D5E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 02:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgCEBel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 20:34:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:31855 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgCEBek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 20:34:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 17:34:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,516,1574150400"; 
   d="scan'208";a="234301743"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2020 17:34:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
Subject: [PATCH v2 1/7] KVM: x86: Trace the original requested CPUID function in kvm_cpuid()
Date:   Wed,  4 Mar 2020 17:34:31 -0800
Message-Id: <20200305013437.8578-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305013437.8578-1-sean.j.christopherson@intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Trace the requested CPUID function instead of the effective function,
e.g. if the requested function is out-of-range and KVM is emulating an
Intel CPU, as the intent of the tracepoint is to show if the output came
from the actual leaf as opposed to the max basic leaf via redirection.

Similarly, leave "found" as is, i.e. report that an entry was found if
and only if the requested entry was found.

Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
[Sean: Drop "found" semantic change, reword changelong accordingly ]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..b4beb3707d1b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1000,7 +1000,7 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit)
 {
-	u32 function = *eax, index = *ecx;
+	u32 orig_function = *eax, function = *eax, index = *ecx;
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_cpuid_entry2 *max;
 	bool found;
@@ -1049,7 +1049,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
+	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, found);
 	return found;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
-- 
2.24.1

