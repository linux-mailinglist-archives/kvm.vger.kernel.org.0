Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41815101DA2
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 09:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfKSIeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 03:34:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:61383 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfKSIeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 03:34:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 00:34:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,322,1569308400"; 
   d="scan'208";a="204332642"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga008.fm.intel.com with ESMTP; 19 Nov 2019 00:34:03 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: add CR4_LA57 bit to nested CR4_FIXED1
Date:   Tue, 19 Nov 2019 16:33:59 +0800
Message-Id: <20191119083359.15319-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L1 guest uses 5-level paging, it fails vm-entry to L2 due to
invalid host-state. It needs to add CR4_LA57 bit to nested CR4_FIXED1
MSR.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 621142e55e28..89253d60e23a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6962,6 +6962,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_SMAP,       ebx, bit(X86_FEATURE_SMAP));
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, bit(X86_FEATURE_PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, bit(X86_FEATURE_UMIP));
+	cr4_fixed1_update(X86_CR4_LA57,       ecx, bit(X86_FEATURE_LA57));
 
 #undef cr4_fixed1_update
 }
-- 
2.17.1

