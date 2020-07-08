Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465B6217FE0
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgGHGvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:51:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:5308 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729934AbgGHGvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:51:19 -0400
IronPort-SDR: wt6ZRwzNKTUGf88oihDzJXxXbJKsUf4fvBM/L8N5YKSdQAhguqM0QXqRmuoL64kaMlYu91AcUi
 EEjxGdGiNVqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145852085"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="145852085"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:51:17 -0700
IronPort-SDR: FsywX1EknOoqBV1N6wkPt0TGvRrfm3UsLGL8+G95FUbAIQMWIFGF3UofaSoukHo5YeYZZVnFkT
 tB/ltM+KECAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="457399218"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 23:51:15 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 6/8] KVM: X86: Move kvm_x86_ops.update_vcpu_model() into kvm_update_vcpu_model()
Date:   Wed,  8 Jul 2020 14:50:52 +0800
Message-Id: <20200708065054.19713-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200708065054.19713-1-xiaoyao.li@intel.com>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_x86_ops.update_vcpu_model() is used to update vmx/svm vcpu settings
based on updated CPUID settings. So it's supposed to be called after
CPUIDs are fully updated, i.e., kvm_update_cpuid().

Currently, kvm_update_cpuid() only updates CPUID bits of OSXSAVE, APIC,
OSPKE, MWAIT, KVM_FEATURE_PV_UNHALT and ebx of (leaf 0xD, subleaf 0x0),
ebx of (leaf 0xD, subleaf 0x1). None of them is consumed by vmx/svm's
update_vcpu_model().

So there is no dependency between kvm_x86_ops.update_vcpu_model() and
kvm_update_cpuid(). Move kvm_x86_ops.update_vcpu_model() into
kvm_update_vcpu_model() make it more reasonable.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d2f93823f9fd..89ffd9dccfc6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -121,6 +121,8 @@ void kvm_update_vcpu_model(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
 
+	kvm_x86_ops.update_vcpu_model(vcpu);
+
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
@@ -224,7 +226,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 
 	cpuid_fix_nx_cap(vcpu);
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops.update_vcpu_model(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 
@@ -254,7 +255,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	}
 
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops.update_vcpu_model(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 out:
-- 
2.18.4

