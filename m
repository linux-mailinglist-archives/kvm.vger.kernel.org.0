Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259B2176474
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 20:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCBT6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 14:58:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:30422 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBT5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 14:57:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:57:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="438404978"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2020 11:57:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 2/6] KVM: x86: Fix CPUID range check for Centaur and Hypervisor ranges
Date:   Mon,  2 Mar 2020 11:57:32 -0800
Message-Id: <20200302195736.24777-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302195736.24777-1-sean.j.christopherson@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the mask in cpuid_function_in_range() for finding the "class" of
the function to 0xfffffff00.  While there is no official definition of
what constitutes a class, e.g. arguably bits 31:16 should be the class
and bits 15:0 the functions within that class, the Hypervisor logic
effectively uses bits 31:8 as the class by virtue of checking for
different bases in increments of 0x100, e.g. KVM advertises its CPUID
functions starting at 0x40000100 when HyperV features are advertised at
the default base of 0x40000000.

Masking against 0x80000000 only handles basic and extended leafs, which
results in Centaur and Hypervisor range checks being performed against
the basic CPUID range, e.g. if CPUID.0x40000000.EAX=0x4000000A and there
is no entry for CPUID.0x40000006, then function 0x40000006 would be
incorrectly reported as out of bounds.

The bad range check doesn't cause function problems for any known VMM
because out-of-range semantics only come into play if the exact entry
isn't found, and VMMs either support a very limited Hypervisor range,
e.g. the official KVM range is 0x40000000-0x40000001 (effectively no
room for undefined leafs) or explicitly defines gaps to be zero, e.g.
Qemu explicitly creates zeroed entries up to the Cenatur and Hypervisor
limits (the latter comes into play when providing HyperV features).

The bad behavior can be visually confirmed by dumping CPUID output in
the guest when running Qemu with a stable TSC, as Qemu extends the limit
of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
without defining zeroed entries for 0x40000002 - 0x4000000f.

Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6be012937eba..c320126e0118 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -993,7 +993,7 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 {
 	struct kvm_cpuid_entry2 *max;
 
-	max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
+	max = kvm_find_cpuid_entry(vcpu, function & 0xffffff00u, 0);
 	return max && function <= max->eax;
 }
 
-- 
2.24.1

