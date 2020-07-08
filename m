Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF296217FD5
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgGHGvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:51:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:5284 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgGHGvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:51:03 -0400
IronPort-SDR: +oW0ifRZDuYkgnZTFyCKpBQDNq0yX4oRqTYkBSDW8hTRrrdlRcpgczzXlTNSUTqOn/2pLiofv8
 QaLQyDhrCOrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145852063"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="145852063"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:51:02 -0700
IronPort-SDR: IE1br+pQ/SIt4czU36ckXrrO+vx5wZx8UFMLiqChEc5ziO38xV/44+R6gcLOMYUb3asV4cR4hA
 RUBvWsrFouSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="457399090"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 23:50:59 -0700
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
Subject: [PATCH v3 1/8] KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID* fails
Date:   Wed,  8 Jul 2020 14:50:47 +0800
Message-Id: <20200708065054.19713-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200708065054.19713-1-xiaoyao.li@intel.com>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementation keeps userspace input of CPUID configuration and
cpuid->nent even if kvm_update_cpuid() fails. Reset vcpu->arch.cpuid_nent
to 0 for the case of failure as a simple fix.

Besides, update the doc to explicitly state that if IOCTL SET_CPUID*
fail KVM gives no gurantee that previous valid CPUID configuration is
kept.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/api.rst | 4 ++++
 arch/x86/kvm/cpuid.c           | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1cfe79b932d6..3ca809a1a44f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -669,6 +669,10 @@ MSRs that have been set successfully.
 Defines the vcpu responses to the cpuid instruction.  Applications
 should use the KVM_SET_CPUID2 ioctl if available.
 
+Note, when this IOCTL fails, KVM gives no guarantees that previous valid CPUID
+configuration (if there is) is not corrupted. Userspace can get a copy of valid
+CPUID configuration through KVM_GET_CPUID2 in case.
+
 ::
 
   struct kvm_cpuid_entry {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9747aa..1d13bad42bf9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -207,6 +207,8 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (r)
+		vcpu->arch.cpuid_nent = 0;
 
 	kvfree(cpuid_entries);
 out:
@@ -230,6 +232,8 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (r)
+		vcpu->arch.cpuid_nent = 0;
 out:
 	return r;
 }
-- 
2.18.4

