Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7031C1E78D7
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgE2Izx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:55:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:46106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2Izw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:55:52 -0400
IronPort-SDR: W7Mz2F3EPjCvhPMieqF4F/Ga1RYxZYPIsR1z2aHRfLAgOgQY3hQsVQ/bJqMQxzUR1+crw01zdM
 Pdiy/55UPABA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:55:51 -0700
IronPort-SDR: a5Oa3r1SQaZiHjHd/srIDIJJaUZFDdCsTEo1FV7EnMltPhAsKVIvH4ZKC8F2saST03ky2nc9+u
 e+Y6zDNcuM7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="311188298"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2020 01:55:49 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 1/6] KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID fails
Date:   Fri, 29 May 2020 16:55:40 +0800
Message-Id: <20200529085545.29242-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200529085545.29242-1-xiaoyao.li@intel.com>
References: <20200529085545.29242-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It needs to invalidate CPUID configruations if usersapce provides
illegal input.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cd708b0b460a..2f1a9650b7f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -210,6 +210,8 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (r)
+		vcpu->arch.cpuid_nent = 0;
 
 out:
 	vfree(cpuid_entries);
@@ -233,6 +235,8 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (r)
+		vcpu->arch.cpuid_nent = 0;
 out:
 	return r;
 }
-- 
2.18.2

