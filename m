Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE24121976F
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgGIEek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:34:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:10037 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgGIEej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:34:39 -0400
IronPort-SDR: A20b4/WtqSKN2hy5ZCx13x0EUOvJxEPGsDbc6pzeShZfpg1Sl2OfPmi2aGBNDh3qxGzjR9qjv4
 cjt1K7mWrMRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147011566"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="147011566"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:34:38 -0700
IronPort-SDR: xvsdNLLTLA/X7bVeDBZ7YMXtOiLsDrrXq9KNewLzf/fxmxgN0P05ij8Pbvz81t9EyqXBVrE+Vr
 mYEEzQglIyJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="297942883"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 21:34:36 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 3/5] KVM: x86: Rename kvm_update_cpuid() to kvm_vcpu_after_set_cpuid()
Date:   Thu,  9 Jul 2020 12:34:24 +0800
Message-Id: <20200709043426.92712-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200709043426.92712-1-xiaoyao.li@intel.com>
References: <20200709043426.92712-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now there is no updating CPUID bits behavior in kvm_update_cpuid(),
rename it to kvm_vcpu_after_set_cpuid().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0ed3b343c44e..b602c0c9078e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -116,7 +116,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void kvm_update_cpuid(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
@@ -230,7 +230,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	cpuid_fix_nx_cap(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
-	kvm_update_cpuid(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
 
 	kvfree(cpuid_entries);
 out:
@@ -259,7 +259,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 
 	kvm_x86_ops.cpuid_update(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
-	kvm_update_cpuid(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
 out:
 	return r;
 }
-- 
2.18.4

