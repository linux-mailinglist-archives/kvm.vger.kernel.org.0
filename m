Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32306193A9E
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgCZIQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 04:16:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:27555 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbgCZIQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:16:07 -0400
IronPort-SDR: c8+IotzP46zru/jIdpNKZRftejIUGoHKnDH6a0bllLW3uJ8dd2dEa/Y0BNptH+aKn4ufb/QeC0
 GZp4EGGHHnUQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:16:06 -0700
IronPort-SDR: 0ypeViXOAy7AWiW53RxQz6EIqHZXcNNgha9coXGdKSPPPtOdoXe6re9DjWL063ZBuLwTrVgV37
 Ij58ojRj9bhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393898876"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 01:16:04 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 4/9] KVM: VMX: Check CET dependencies on CR settings
Date:   Thu, 26 Mar 2020 16:18:41 +0800
Message-Id: <20200326081847.5870-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200326081847.5870-1-weijiang.yang@intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CR4.CET is master control bit for CET function.
There're mutual constrains between CR0.WP and CR4.CET, so need
to check the dependent bit while changing the control registers.

Note:
1)The processor does not allow CR4.CET to be set if CR0.WP = 0,
  similarly, it does not allow CR0.WP to be cleared while
  CR4.CET = 1. In either case, KVM would inject #GP to guest.

2)SHSTK and IBT features share one control MSR:
  MSR_IA32_{U,S}_CET, which means it's difficult to hide
  one feature from another in the case of SHSTK != IBT,
  after discussed in community, it's agreed to allow guest
  control two features independently as it won't introduce
  security hole.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/x86.c     | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bd7cd175fd81..87f101750746 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3089,6 +3089,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && (!is_cet_supported(vcpu) ||
+	    !(kvm_read_cr0(vcpu) & X86_CR0_WP)))
+		return 1;
+
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 830afe5038d1..90acdbbb8a5a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -804,6 +804,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-- 
2.17.2

