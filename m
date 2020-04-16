Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C181ABE00
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505105AbgDPKeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 06:34:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:46605 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505097AbgDPKeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 06:34:02 -0400
IronPort-SDR: tKTQGJ1hQI7xoal+PAS6ZiNdOXg5na9yp4sV3S/Vit4KwF2E3RMt/RB2+7NrsdaGCF3THanvF/
 KdtHa8tuQqnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:33:29 -0700
IronPort-SDR: JvzddcKGvjliYl2cvOvoOesY9Om7KNGV4b/0is+8tvoi2stVDHbVm1Dz10URsWVpRAGtuhOGmr
 EJcN4MFuyU3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="277947904"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 16 Apr 2020 03:33:27 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 2/3] kvm: x86: Use KVM_DEBUGREG_NEED_RELOAD instead of KVM_DEBUGREG_BP_ENABLED
Date:   Thu, 16 Apr 2020 18:15:08 +0800
Message-Id: <20200416101509.73526-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200416101509.73526-1-xiaoyao.li@intel.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once any #BP enabled in DR7, it will set KVM_DEBUGREG_BP_ENABLED, which
leads to reload DRn before every VM entry even if none of DRn changed.

Drop KVM_DEBUGREG_BP_ENABLED flag and set KVM_DEBUGREG_NEED_RELOAD flag
for the cases that DRn need to be reloaded instead, to avoid unnecessary
DRn reload.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +--
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f465c76e6e5a..87e2d020351e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -509,9 +509,8 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
+	KVM_DEBUGREG_NEED_RELOAD = 1,
 	KVM_DEBUGREG_WONT_EXIT = 2,
-	KVM_DEBUGREG_NEED_RELOAD = 4,
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cce926658d10..71264df64001 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1086,9 +1086,8 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
 	else
 		dr7 = vcpu->arch.dr7;
 	kvm_x86_ops.set_dr7(vcpu, dr7);
-	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
 	if (dr7 & DR7_BP_EN_MASK)
-		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
+		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
 }
 
 static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
@@ -1128,6 +1127,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 		break;
 	}
 
+	vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
 	return 0;
 }
 
-- 
2.20.1

