Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEEF6DDD79
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2019 11:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfJTJ0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 05:26:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:39083 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfJTJ0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 05:26:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Oct 2019 02:26:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,319,1566889200"; 
   d="scan'208";a="348494029"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by orsmga004.jf.intel.com with ESMTP; 20 Oct 2019 02:26:04 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: VMX: Write VPID to vmcs when creating vcpu
Date:   Sun, 20 Oct 2019 17:10:58 +0800
Message-Id: <20191020091101.125516-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191020091101.125516-1-xiaoyao.li@intel.com>
References: <20191020091101.125516-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the code that writes vmx->vpid to vmcs from vmx_vcpu_reset() to
vmx_vcpu_setup(), because vmx->vpid is allocated when creating vcpu and
never changed. So we don't need to update the vmcs.vpid when resetting
vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e660e28e9ae0..279f855d892b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4252,6 +4252,9 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	set_cr4_guest_host_mask(vmx);
 
+	if (vmx->vpid != 0)
+		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
+
 	if (vmx_xsaves_supported())
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
@@ -4354,9 +4357,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
-	if (vmx->vpid != 0)
-		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
-
 	cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
 	vmx->vcpu.arch.cr0 = cr0;
 	vmx_set_cr0(vcpu, cr0); /* enter rmode */
-- 
2.19.1

