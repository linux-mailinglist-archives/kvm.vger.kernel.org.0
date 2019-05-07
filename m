Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A35A16B15
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfEGTSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:55700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfEGTSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 12:18:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2019 12:18:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 10/13] KVM: nVMX: Preset *DT exiting in vmcs02 when emulating UMIP
Date:   Tue,  7 May 2019 12:18:02 -0700
Message-Id: <20190507191805.9932-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM dynamically toggles SECONDARY_EXEC_DESC to intercept (a subset of)
instructions that are subject to User-Mode Instruction Prevention, i.e.
VMCS.SECONDARY_EXEC_DESC == CR4.UMIP when emulating UMIP.  Preset the
VMCS control when preparing vmcs02 to avoid unnecessarily VMWRITEs,
e.g. KVM will clear VMCS.SECONDARY_EXEC_DESC in prepare_vmcs02_early()
and then set it in vmx_set_cr4().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e4d363661ae7..4b5be38cfc86 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2057,6 +2057,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		/* VMCS shadowing for L2 is emulated for now */
 		exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
 
+		/* Preset *DT exiting when emulating UMIP (vmx_set_cr4()). */
+		if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated() &&
+		    (vmcs12->guest_cr4 & X86_CR4_UMIP))
+			exec_control |= SECONDARY_EXEC_DESC;
+
 		if (exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
 			vmcs_write16(GUEST_INTR_STATUS,
 				vmcs12->guest_intr_status);
-- 
2.21.0

