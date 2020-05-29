Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504EE1E78DD
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgE2I4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:56:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:44061 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgE2I4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:56:02 -0400
IronPort-SDR: WxJkzpnS8bDXDm2lCuncZDYLSDPiJSH4+wTSwS3YpO8TxWo2NRUIxtpYXj59gef5j7AuO1T5N3
 p/cywoL6zQoA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:56:01 -0700
IronPort-SDR: 5shGSAVwEKjtV1RbYK//3o9TjwmJcuv2BDBt8G48VHECR28DliVPPnUFdWSLcu1LeFsagqTn9V
 FEnfmoZyQ6iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="311188383"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2020 01:55:59 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 6/6] KVM: X86: Move kvm_apic_set_version() to kvm_update_state_based_on_cpuid()
Date:   Fri, 29 May 2020 16:55:45 +0800
Message-Id: <20200529085545.29242-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200529085545.29242-1-xiaoyao.li@intel.com>
References: <20200529085545.29242-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Obviously, kvm_apic_set_version() fits well in
kvm_update_state_based_on_cpuid().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5d4da8970940..eb60098aca29 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -127,6 +127,8 @@ void kvm_update_state_based_on_cpuid(struct kvm_vcpu *vcpu)
 			apic->lapic_timer.timer_mode_mask = 3 << 17;
 		else
 			apic->lapic_timer.timer_mode_mask = 1 << 17;
+
+		kvm_apic_set_version(vcpu);
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
@@ -228,7 +230,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	}
 
 	cpuid_fix_nx_cap(vcpu);
-	kvm_apic_set_version(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_state_based_on_cpuid(vcpu);
 
@@ -257,7 +258,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
-	kvm_apic_set_version(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_state_based_on_cpuid(vcpu);
 out:
-- 
2.18.2

