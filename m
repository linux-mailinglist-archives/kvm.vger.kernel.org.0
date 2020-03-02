Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559FF176468
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 20:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgCBT5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 14:57:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:30422 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgCBT5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 14:57:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="438404989"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2020 11:57:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 5/6] KVM: x86: Rename "found" variable in kvm_cpuid() to "exact_entry_exists"
Date:   Mon,  2 Mar 2020 11:57:35 -0800
Message-Id: <20200302195736.24777-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302195736.24777-1-sean.j.christopherson@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "found" in kvm_cpuid() to "exact_entry_exists" to better convey
that the intent of the tracepoint's "found/not found" output is to trace
whether the output values are for the actual requested leaf or for some
other (likely unrelated) leaf that was found while processing entries to
emulate funky CPU behavior, e.g. the max basic leaf on Intel CPUs when
the requested CPUID leaf is out of range.

Suggested-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 869526930cf7..b0a4f3c17932 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1002,10 +1002,10 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 {
 	const u32 function = *eax, index = *ecx;
 	struct kvm_cpuid_entry2 *entry;
-	bool found;
+	bool exact_entry_exists;
 
 	entry = kvm_find_cpuid_entry(vcpu, function, index);
-	found = entry;
+	exact_entry_exists = !!entry;
 	/*
 	 * Intel CPUID semantics treats any query for an out-of-range
 	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
@@ -1047,7 +1047,7 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
+	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, exact_entry_exists);
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
 
-- 
2.24.1

