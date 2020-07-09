Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11142219774
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgGIEeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:34:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:10037 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgGIEep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:34:45 -0400
IronPort-SDR: Kar0x3GxdvemPbHC+BsSY5uZ2+i8MBlanND68NzGqX3KntAiwMVrWSMCpnhCQebAwCLj8UtgAq
 +fOBGsZFY78Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147011573"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="147011573"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:34:45 -0700
IronPort-SDR: 6K6Ckv3NFdCv0xBy2jAlfopVnrGdwSvXWTAJkPAECeZ8beIr6VALpZ4rpJlttx8s7Tyo9WZA3t
 8v/V9l4fEJuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="297942914"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 21:34:42 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 5/5] KVM: x86: Move kvm_x86_ops.vcpu_after_set_cpuid() into kvm_vcpu_after_set_cpuid()
Date:   Thu,  9 Jul 2020 12:34:26 +0800
Message-Id: <20200709043426.92712-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200709043426.92712-1-xiaoyao.li@intel.com>
References: <20200709043426.92712-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_x86_ops.vcpu_after_set_cpuid() is used to update vmx/svm specific
vcpu settings based on updated CPUID settings. So it's supposed to be
called after CPUIDs are updated, i.e., kvm_update_cpuid_runtime().

Currently, kvm_update_cpuid_runtime() only updates CPUID bits of OSXSAVE,
APIC, OSPKE, MWAIT, KVM_FEATURE_PV_UNHALT and CPUID(0xD,0).ebx and
CPUID(0xD, 1).ebx. None of them is consumed by vmx/svm's
update_vcpu_after_set_cpuid(). So there is no dependency between them.

Move kvm_x86_ops.vcpu_after_set_cpuid() into kvm_vcpu_after_set_cpuid() is
obviously more reasonable.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 832a24c1334e..edbed4f522f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -121,6 +121,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
 
+	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
+
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
@@ -228,7 +230,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	}
 
 	cpuid_fix_nx_cap(vcpu);
-	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
@@ -257,7 +258,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
-	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 out:
-- 
2.18.4

