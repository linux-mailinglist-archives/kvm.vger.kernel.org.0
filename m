Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C0122032C
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgGOEGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:16671 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgGOEGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:02 -0400
IronPort-SDR: MC6ZGUcmmoKsjmPMFKbNjeqSbb6NGalw6cS4L5lBvcv33d5p1K3kB5znCN8V5D7JUfZ0ekqhqI
 0i3LeQJRYQ1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167481"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167481"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:02 -0700
IronPort-SDR: v+XInTWoTKRYbE1UC1W2TSxWvGPUzRRM45ChY1gc2F5PTzO9jo7+fYkBfgQaKBFf63no4wBB6O
 O17oBdIpn/yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587009"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 21:06:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 2/7] KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails
Date:   Tue, 14 Jul 2020 21:05:52 -0700
Message-Id: <20200715040557.5889-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715040557.5889-1-sean.j.christopherson@intel.com>
References: <20200715040557.5889-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reload vmcs01 when bailing from nested_vmx_enter_non_root_mode() as KVM
expects vmcs01 to be loaded when is_guest_mode() is false.

Fixes: 671ddc700fd08 ("KVM: nVMX: Don't leak L1 MMIO regions to L2")
Cc: stable@vger.kernel.org
Cc: Dan Cross <dcross@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3b23901b90809..8cbf7bd3a7aa3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3345,8 +3345,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		if (unlikely(!nested_get_vmcs12_pages(vcpu)))
+		if (unlikely(!nested_get_vmcs12_pages(vcpu))) {
+			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
+		}
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-- 
2.26.0

