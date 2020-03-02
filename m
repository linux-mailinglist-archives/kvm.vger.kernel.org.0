Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F27F1768E3
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgCCAAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:00:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:25520 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbgCBX51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384643"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 07/66] KVM: x86: Check for CPUID 0xD.N support before validating array size
Date:   Mon,  2 Mar 2020 15:56:10 -0800
Message-Id: <20200302235709.27467-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that sub-leaf 1 is handled separately, verify the next sub-leaf is
needed before rejecting KVM_GET_SUPPORTED_CPUID due to an insufficiently
sized userspace array.

Note, although this is technically a bug, it's not visible to userspace
as KVM_GET_SUPPORTED_CPUID is guaranteed to fail on KVM_CPUID_SIGNATURE,
which is hardcoded to be added after leaf 0xD.  The real motivation for
the change is to tightly couple the nent/maxnent and do_host_cpuid()
sequences in preparation for future cleanup.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fc8540596386..fd9b29aa7abc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -670,13 +670,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry[1].edx = 0;
 
 		for (idx = 2, i = 2; idx < 64; ++idx) {
-			u64 mask = ((u64)1 << idx);
+			if (!(supported & BIT_ULL(idx)))
+				continue;
 
 			if (*nent >= maxnent)
 				goto out;
 
 			do_host_cpuid(&entry[i], function, idx);
-			if (entry[i].eax == 0 || !(supported & mask))
+			if (entry[i].eax == 0)
 				continue;
 			if (WARN_ON_ONCE(entry[i].ecx & 1))
 				continue;
-- 
2.24.1

