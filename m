Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C720918E457
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 21:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgCUU0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 16:26:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:8930 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728075AbgCUU0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 16:26:09 -0400
IronPort-SDR: jsyyZ4an+U30rfUzxZStxjeevoSiLGqN6SsHwHTRjhGPWGkei9oj/wmJycxTdj82cla06FnITR
 LzfnZlg71aXw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 13:26:08 -0700
IronPort-SDR: C6h7LJAXXbxHDomfxCRqgNzOi+Nt8KHcxW9uzsthbxs6Sm3EbqrVlN5B394T+e9EmphuUAlUSt
 vJ4yoS4uDL/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="280773550"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 21 Mar 2020 13:26:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/9] KVM: x86: Set kvm_x86_ops only after ->hardware_setup() completes
Date:   Sat, 21 Mar 2020 13:25:59 -0700
Message-Id: <20200321202603.19355-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200321202603.19355-1-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set kvm_x86_ops with the vendor's ops only after ->hardware_setup()
completes to "prevent" using kvm_x86_ops before they are ready, i.e. to
generate a null pointer fault instead of silently consuming unconfigured
state.

An alternative implementation would be to have ->hardware_setup()
return the vendor's ops, but that would require non-trivial refactoring,
and would arguably result in less readable code, e.g. ->hardware_setup()
would need to use ERR_PTR() in multiple locations, and each vendor's
declaration of the runtime ops would be less obvious.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20f989d1bba8..eb1976214ada 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7354,8 +7354,6 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
-	kvm_x86_ops = ops->runtime_ops;
-
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0,
 			PT_PRESENT_MASK, 0, sme_me_mask);
@@ -9635,6 +9633,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (r != 0)
 		return r;
 
+	kvm_x86_ops = ops->runtime_ops;
+
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
-- 
2.24.1

