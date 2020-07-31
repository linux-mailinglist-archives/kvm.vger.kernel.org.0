Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E70233D52
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbgGaCmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731261AbgGaCmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:37 -0400
IronPort-SDR: pjL19V4JCgth7LarL5Y8IGMtw5VLH59TIkZlnngtpO/AwWYXRYeAnmQ+UurjrS8C2ESuyX+Bf0
 AmjxpPcGPuMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290115"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290115"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:37 -0700
IronPort-SDR: mhT77PxW+ZKZkGV8pbgU6XOHNKXpbwewaox2Mbm27kuzMOLLSd6dBi0W09NVqhYnrixA27w35N
 +8vfzDGSSeZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304805959"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:34 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 2/9] KVM:x86: Substitute kvm_update_cpuid_runtime() with kvm_apic_base_update_cpuid() in kvm_lapic_set_base()
Date:   Fri, 31 Jul 2020 10:42:20 +0800
Message-Id: <1596163347-18574-3-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d5fb2ea..1e3d03c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2231,7 +2231,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-		kvm_update_cpuid_runtime(vcpu);
+		kvm_apic_base_update_cpuid(vcpu, !!(value & MSR_IA32_APICBASE_ENABLE));
 
 	if (!apic)
 		return;
-- 
1.8.3.1

