Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF064205177
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732533AbgFWL6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:58:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:58474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732364AbgFWL6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:58:24 -0400
IronPort-SDR: bnkQ12CZuUHAwuve9KzbHcNOCrE0T56NUMctU2PkB5y7Rn4HM6xU6O5sllJZATmIgvALOO3xq7
 NhdrHmW6HaFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="228710034"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="228710034"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 04:58:23 -0700
IronPort-SDR: qptkiFY9mzn1oJIiSEjbe6MsnPiPaMjdFMI/J/dgVDyy8cDOsUAdDbzlZbKr8yFOdewfLcubsE
 y68dUnbyL6zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="285745184"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2020 04:58:20 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 1/7] KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID fails
Date:   Tue, 23 Jun 2020 19:58:10 +0800
Message-Id: <20200623115816.24132-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200623115816.24132-1-xiaoyao.li@intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
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
2.18.2

