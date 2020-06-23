Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2505320517F
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgFWL6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:58:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:58510 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732593AbgFWL6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:58:38 -0400
IronPort-SDR: 0qK9wSJkTcb0f/V66sdW4ec1DOKIBUIO18TZX7/jGOBB5t44MTzRI9TFN0iUkRM6mxAGer/i6v
 5DS/qTJImwVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="228710147"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="228710147"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 04:58:38 -0700
IronPort-SDR: 0HTZHbEmA/vtz9h8VCgPRhMyjRNWVRoymmJLdvfL30htg9WgKMH/6lfSNLB1wpdJyZCL6Bmzbc
 kGeTz78LPuqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="285746261"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2020 04:58:35 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 7/7] KVM: X86: Move kvm_apic_set_version() to kvm_update_vcpu_model()
Date:   Tue, 23 Jun 2020 19:58:16 +0800
Message-Id: <20200623115816.24132-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200623115816.24132-1-xiaoyao.li@intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Obviously, kvm_apic_set_version() fits well in kvm_update_vcpu_model().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5decc2dd5448..3428f4d84b42 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -129,6 +129,8 @@ void kvm_update_vcpu_model(struct kvm_vcpu *vcpu)
 			apic->lapic_timer.timer_mode_mask = 3 << 17;
 		else
 			apic->lapic_timer.timer_mode_mask = 1 << 17;
+
+		kvm_apic_set_version(vcpu);
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
@@ -226,7 +228,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	}
 
 	cpuid_fix_nx_cap(vcpu);
-	kvm_apic_set_version(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 
@@ -255,7 +256,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
-	kvm_apic_set_version(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 out:
-- 
2.18.2

