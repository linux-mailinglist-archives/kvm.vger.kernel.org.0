Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0665D1E65D6
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 17:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404313AbgE1PTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 11:19:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:64188 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404219AbgE1PTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 11:19:41 -0400
IronPort-SDR: kcd1/j7jzA7xbET44HnV5V8IPvDCH4kKnjisUW8iIzo7EUym2zw9RVHze1bmsOhs0/kPH8dxfn
 AwGj0u1NQyjw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 08:19:32 -0700
IronPort-SDR: PKpILhmpgWJ4LqD1TSyYiIUyogBt/I1Qqls+IXEYCQOudAO2v82YIWdazRGEUPJ3YlVKw1jWBs
 bknPGleRqmQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,445,1583222400"; 
   d="scan'208";a="292030776"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by fmsmga004.fm.intel.com with ESMTP; 28 May 2020 08:19:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: X86: Call kvm_x86_ops.cpuid_update() after CPUIDs fully updated
Date:   Thu, 28 May 2020 23:19:27 +0800
Message-Id: <20200528151927.14346-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_x86_ops.cpuid_update() is used to update vmx/svm settings based on
updated CPUID settings. So it's supposed to be called after CPUIDs are
fully updated, not in the middle stage.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cd708b0b460a..753739bc1bf0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -208,8 +208,11 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	cpuid_fix_nx_cap(vcpu);
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (r)
+		goto out;
+
+	kvm_x86_ops.cpuid_update(vcpu);
 
 out:
 	vfree(cpuid_entries);
@@ -231,8 +234,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (r)
+		goto out;
+
+	kvm_x86_ops.cpuid_update(vcpu);
 out:
 	return r;
 }
-- 
2.18.2

