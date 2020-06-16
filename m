Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2401FA9F6
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 09:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgFPHdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 03:33:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:46469 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgFPHdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 03:33:15 -0400
IronPort-SDR: 9kO8yEa9bIv+qkGyLCqMoy7mM6gWrOGfpzfNyEfyNy6xK8twKZpIhThI53k9WskcXxbs9F+kTa
 ONK/mXCd6BZg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 00:33:14 -0700
IronPort-SDR: hFfb1kQV9mwaaKEDADpV9dTlNpLO4oG7L2F/uMb2dPpJGRWjNvR24A0jI3DhxCOr0cWiJN6ER6
 1Tkv++9zrW8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,518,1583222400"; 
   d="scan'208";a="476339274"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jun 2020 00:33:10 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: X86: Fix MSR range of APIC registers in X2APIC mode
Date:   Tue, 16 Jun 2020 15:33:07 +0800
Message-Id: <20200616073307.16440-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only MSR address range 0x800 through 0x8ff is architecturally reserved
and dedicated for accessing APIC registers in x2APIC mode.

Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..29d9b078ce69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2856,7 +2856,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
-	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_TSCDEADLINE:
 		kvm_set_lapic_tscdeadline_msr(vcpu, data);
@@ -3196,7 +3196,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_APICBASE:
 		msr_info->data = kvm_get_apic_base(vcpu);
 		break;
-	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
 	case MSR_IA32_TSCDEADLINE:
 		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
-- 
2.18.2

