Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870FD1B512B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 02:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDWAL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 20:11:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:6055 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgDWAL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 20:11:28 -0400
IronPort-SDR: gy3VN51eNd25JeobTjYQZ769UXTcwbCyT40YQfq1i6JSL6bvUHxyzPmuiBxCbtr4mLDl8zUkWU
 TzaPwYdFE6Bw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 17:11:28 -0700
IronPort-SDR: aQf708tzHhWl8yKzEOn23sd8LSUIxgWzWyapz5K++6BLe7JwWgMWyWraZtXBo1PN8ML/OOkKLE
 7wTom2pwMHuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="334793040"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2020 17:11:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Store vmcs.EXIT_QUALIFICATION as an unsigned long, not u32
Date:   Wed, 22 Apr 2020 17:11:27 -0700
Message-Id: <20200423001127.13490-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an unsigned long for 'exit_qual' in nested_vmx_reflect_vmexit(), the
EXIT_QUALIFICATION field is naturally sized, not a 32-bit field.

The bug is most easily observed by doing VMXON (or any VMX instruction)
in L2 with a negative displacement, in which case dropping the upper
bits on nested VM-Exit results in L1 calculating the wrong virtual
address for the memory operand, e.g. "vmxon -0x8(%rbp)" yields:

  Unhandled cpu exception 14 #PF at ip 0000000000400553
  rbp=0000000000537000 cr2=0000000100536ff8

Fixes: fbdd50250396d ("KVM: nVMX: Move VM-Fail check out of nested_vmx_exit_reflected()")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Sadly (for me), I can't blame a mishandled merge on this one.  Even more
embarassing is that this is actually the second instance where I botched
the size for exit_qual, you'd think I'd have double-checked everything
after the first one...

 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f228339cd0a0..3f32f81f5c59 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5814,7 +5814,8 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 exit_reason = vmx->exit_reason;
-	u32 exit_intr_info, exit_qual;
+	unsigned long exit_qual;
+	u32 exit_intr_info;
 
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-- 
2.26.0

