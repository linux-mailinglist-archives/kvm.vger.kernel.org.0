Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0325F124F97
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 18:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLRRnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 12:43:01 -0500
Received: from mga05.intel.com ([192.55.52.43]:57072 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbfLRRnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 12:43:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 09:42:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="298450983"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 18 Dec 2019 09:42:56 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Weijiang Yang <weijiang.yang@intel.com>
Subject: [RFC PATCH] KVM: x86: Disallow KVM_SET_CPUID{2} if the vCPU is in guest mode
Date:   Wed, 18 Dec 2019 09:42:55 -0800
Message-Id: <20191218174255.30773-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reject KVM_SET_CPUID{2} with -EBUSY if the vCPU is in guest mode (L2) to
avoid complications and potentially undesirable KVM behavior.  Allowing
userspace to change a guest's capabilities while L2 is active would at
best result in unexpected behavior in the guest (L1 or L2), and at worst
induce bad KVM behavior by breaking fundamental assumptions regarding
transitions between L0, L1 and L2.

Cc: Jim Mattson <jmattson@google.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

This came up in the context of the CET series, where passing through MSRs
to L1 depends on the CPUID-based capabilities of the guest[*].  The CET
problem is solvable, but IMO unnecessarily complex.   And I'm more
concerned that userspace would be able to induce bad behavior in KVM by
changing core capabilites while L2 is active, e.g. VMX, LM, LA57, etc...

Tagged RFC as this is an ABI change, though I highly doubt it actually
affects a real world VMM.

[*] https://lkml.kernel.org/r/20191218160228.GB25201@linux.intel.com/

 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8bb2fb1705ff..974983140e42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4189,6 +4189,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid __user *cpuid_arg = argp;
 		struct kvm_cpuid cpuid;
 
+		r = -EBUSY;
+		if (is_guest_mode(vcpu))
+			goto out;
+
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
@@ -4199,6 +4203,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid2 __user *cpuid_arg = argp;
 		struct kvm_cpuid2 cpuid;
 
+		r = -EBUSY;
+		if (is_guest_mode(vcpu))
+			goto out;
+
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
-- 
2.24.1

