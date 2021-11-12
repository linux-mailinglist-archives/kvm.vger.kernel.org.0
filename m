Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8368C44EA7F
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhKLPlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:41:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:34471 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235304AbhKLPkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:40:52 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093167"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093167"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:37:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182071"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:37:46 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     xiaoyao.li@intel.com, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 03/11] KVM: x86: Clean up kvm_vcpu_ioctl_x86_setup_mce()
Date:   Fri, 12 Nov 2021 23:37:25 +0800
Message-Id: <20211112153733.2767561-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to use goto.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23617582712d..b02088343d80 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4505,15 +4505,13 @@ static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 					u64 mcg_cap)
 {
-	int r;
 	unsigned bank_num = mcg_cap & 0xff, bank;
 
-	r = -EINVAL;
 	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
-		goto out;
+		return -EINVAL;
 	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
-		goto out;
-	r = 0;
+		return -EINVAL;
+
 	vcpu->arch.mcg_cap = mcg_cap;
 	/* Init IA32_MCG_CTL to all 1s */
 	if (mcg_cap & MCG_CTL_P)
@@ -4523,8 +4521,8 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 
 	static_call(kvm_x86_setup_mce)(vcpu);
-out:
-	return r;
+
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
-- 
2.27.0

