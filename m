Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AF01A4980
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 19:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgDJRrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 13:47:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:60983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgDJRrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 13:47:06 -0400
IronPort-SDR: U1WklG+yOS6NE+jMI7UvZ5MHCiD4wcFsOQSSj3OX7lHw3fBIBviNV9W5CR44k09eOfHNbWZWbl
 NeS2TXrA1Mow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 10:47:06 -0700
IronPort-SDR: jFSvR6kxcUcRaXKCntyWUbd41j54+6KAo3c4Sif0MehZ4fYwrJ6RvZeiOuiJcXYCxs5zCbLLet
 78CM6ujhyVwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,367,1580803200"; 
   d="scan'208";a="297857979"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2020 10:47:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v3 1/2] KVM: VMX: Optimize handling of VM-Entry failures in vmx_vcpu_run()
Date:   Fri, 10 Apr 2020 10:47:02 -0700
Message-Id: <20200410174703.1138-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410174703.1138-1-sean.j.christopherson@intel.com>
References: <f51251cc-885e-2f7a-b18d-faa76db15b87@redhat.com>
 <20200410174703.1138-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark the VM-Fail, VM-Exit on VM-Enter, and #MC on VM-Enter paths as
'unlikely' so as to improve code generation so that it favors successful
VM-Enter.  The performance of successful VM-Enter is for more important,
irrespective of whether or not success is actually likely.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1d2bb57f4ac4..a8402bed29e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6736,11 +6736,16 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->nested.nested_run_pending = 0;
 	vmx->idt_vectoring_info = 0;
 
-	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
-	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+	if (unlikely(vmx->fail)) {
+		vmx->exit_reason = 0xdead;
+		return;
+	}
+
+	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
+	if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
-	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
+	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return;
 
 	vmx->loaded_vmcs->launched = 1;
-- 
2.26.0

