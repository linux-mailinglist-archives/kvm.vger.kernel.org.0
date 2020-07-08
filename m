Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22A9217FE3
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgGHGvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:51:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:5308 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729761AbgGHGvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:51:23 -0400
IronPort-SDR: Rfpe598RxQYJQrEBqvXsluiE0Y683+HTUx/sJ+xfqWLkejcEEmYvN3jz8lNQFvxVxk0kbxv8PP
 h/lD9JUUWQfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145852103"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="145852103"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:51:23 -0700
IronPort-SDR: ejOlX4vhPngvmlx0pwSR2E34lt4h0hLaGRuBaWfv7WLcMTiUHpYA/sxVEifb1Eo9nUbOU8YU4W
 q+GprLcw7yzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="457399263"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 23:51:20 -0700
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
Subject: [PATCH v3 8/8] KVM: X86: Move kvm_apic_set_version() to kvm_update_vcpu_model()
Date:   Wed,  8 Jul 2020 14:50:54 +0800
Message-Id: <20200708065054.19713-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200708065054.19713-1-xiaoyao.li@intel.com>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no dependencies between kvm_apic_set_version() and
kvm_update_cpuid() because kvm_apic_set_version() queries X2APIC CPUID bit,
which is not touched/changed by kvm_update_cpuid().

Obviously, kvm_apic_set_version() belongs to the category of updating
vcpu model.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89ffd9dccfc6..c183a11dbcff 100644
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
@@ -225,7 +227,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	}
 
 	cpuid_fix_nx_cap(vcpu);
-	kvm_apic_set_version(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 
@@ -254,7 +255,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
-	kvm_apic_set_version(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 out:
-- 
2.18.4

