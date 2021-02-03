Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7862030D8A2
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhBCL1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:27:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:28346 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234340AbhBCLZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:25:42 -0500
IronPort-SDR: 0P2EYlogF6HXIZvhy2U6NekJI0CkSvZCcBdWg8HtyeojwHJ50H5wUvwk/9TPrUlOLLeuQk76KN
 m0qVEl+t97zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981332"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981332"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:33 -0800
IronPort-SDR: fpZYHT+yKVj3AHodAVpBAA4qaXTeCnqOhSQK6h6t50TIHdvwtZasBmfAH+glutnpd5lZ/E3JJo
 JEeWNLfSUjGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311251"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:32 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 14/14] KVM: x86: Save/Restore GUEST_SSP to/from SMRAM
Date:   Wed,  3 Feb 2021 19:34:21 +0800
Message-Id: <20210203113421.5759-15-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save GUEST_SSP to SMRAM when guest exits to SMM due to SMI and restore it
when guest exits SMM to interrupted normal non-root mode.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/emulate.c | 11 +++++++++++
 arch/x86/kvm/x86.c     | 10 ++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 56cae1ff9e3f..6d4a3181d8bd 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2615,6 +2615,17 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 			return r;
 	}
 
+	if (kvm_cet_supported()) {
+		struct msr_data msr;
+
+		val = GET_SMSTATE(u64, smstate, 0x7ec8);
+		msr.index = MSR_KVM_GUEST_SSP;
+		msr.host_initiated = true;
+		msr.data = val;
+		/* Mimic host_initiated access to bypass ssp access check. */
+		kvm_x86_ops.set_msr(ctxt->vcpu, &msr);
+	}
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 22eb6b8626a8..f63b713cd71f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8592,6 +8592,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 
 	for (i = 0; i < 6; i++)
 		enter_smm_save_seg_64(vcpu, buf, i);
+
+	if (kvm_cet_supported()) {
+		struct msr_data msr;
+
+		msr.index = MSR_KVM_GUEST_SSP;
+		msr.host_initiated = true;
+		/* GUEST_SSP is stored in VMCS at vm-exit. */
+		kvm_x86_ops.get_msr(vcpu, &msr);
+		put_smstate(u64, buf, 0x7ec8, msr.data);
+	}
 }
 #endif
 
-- 
2.26.2

