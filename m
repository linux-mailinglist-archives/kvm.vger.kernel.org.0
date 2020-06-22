Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEFC2043F8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731552AbgFVWo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:44:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:27426 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731186AbgFVWm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:57 -0400
IronPort-SDR: rrQdXBB1pzl7O0uBTA+CRVWxWpdN6M8nfQ0ZieKxjwMzK9pyi8AileE6z79hAs8BmYob0euarC
 PoUcUJg/XS3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303574"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303574"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:54 -0700
IronPort-SDR: FAzpuBBf11NBdp3BnF5sXwz5dNqTfJt2k/bHeEQM4oziqWdZgdT6N8zu6h9Cn0p5afhdaaPytx
 pL1960fCdI1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634927"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] KVM: VMX: Check guest support for RDTSCP before processing MSR_TSC_AUX
Date:   Mon, 22 Jun 2020 15:42:43 -0700
Message-Id: <20200622224249.29562-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check for RDTSCP support prior to checking if MSR_TSC_AUX is in the uret
MSRs array so that the array lookup and manipulation are back-to-back.
This paves the way toward adding a helper to wrap the lookup and
manipulation.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a0f4049d956f..954b9aa950f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1751,9 +1751,11 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	index = __vmx_find_uret_msr(vmx, MSR_EFER);
 	if (index >= 0 && update_transition_efer(vmx, index))
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
-	index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
-	if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
-		move_msr_up(vmx, index, nr_active_uret_msrs++);
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)) {
+		index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
+		if (index >= 0)
+			move_msr_up(vmx, index, nr_active_uret_msrs++);
+	}
 	index = __vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 	if (index >= 0)
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
-- 
2.26.0

