Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3667F1ABFFF
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 13:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505206AbgDPLpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 07:45:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:46619 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504914AbgDPKdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 06:33:38 -0400
IronPort-SDR: CBFc0+RD/rxjCamx/CRPEvlO6bTrJVUX4OIwq8jHiIvt3Rvp6XRL3YygupM8qsk+0JJ4zR+pQB
 qT1GHhZyJ7JA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:33:27 -0700
IronPort-SDR: GM7QgTRxLZxNtY5oDGeuldEujPWqCiRNQBU2Z1aqO/DnlR2z2n87sj4SRohvLHQLhs+KMo2hax
 VASDiE9UKVsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="277947896"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 16 Apr 2020 03:33:26 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to KVM_DEBUGREG_NEED_RELOAD
Date:   Thu, 16 Apr 2020 18:15:07 +0800
Message-Id: <20200416101509.73526-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200416101509.73526-1-xiaoyao.li@intel.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make it more clear that the flag means DRn (except DR7) need to be
reloaded before vm entry.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.c              | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c7da23aed79a..f465c76e6e5a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -511,7 +511,7 @@ struct kvm_pmu_ops;
 enum {
 	KVM_DEBUGREG_BP_ENABLED = 1,
 	KVM_DEBUGREG_WONT_EXIT = 2,
-	KVM_DEBUGREG_RELOAD = 4,
+	KVM_DEBUGREG_NEED_RELOAD = 4,
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index de77bc9bd0d7..cce926658d10 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1067,7 +1067,7 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
 		for (i = 0; i < KVM_NR_DB_REGS; i++)
 			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
-		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_RELOAD;
+		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
 	}
 }
 
@@ -8407,7 +8407,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[2], 2);
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		set_debugreg(vcpu->arch.dr6, 6);
-		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
+		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_NEED_RELOAD;
 	}
 
 	kvm_x86_ops.run(vcpu);
@@ -8424,7 +8424,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr6(vcpu);
 		kvm_update_dr7(vcpu);
-		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
+		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_NEED_RELOAD;
 	}
 
 	/*
-- 
2.20.1

