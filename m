Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470502B4F9F
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388211AbgKPS2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:20638 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388095AbgKPS2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:06 -0500
IronPort-SDR: cRGVddNAopi48G6pJKgAFoC3dBwnwlX445Yp6GyyEPelr2GOHncisD+6eSGzgQMZ1vOoQvvFTi
 wSSAyxMsATvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410035"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410035"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:04 -0800
IronPort-SDR: siudl/3OmboItfUXg82BNh2u5l2IKHgnkwlMqzSDHugZoEFjK/1vQ0YNW39ilQbT044gUIgIWa
 fHSD1U5mAY1Q==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528018"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:04 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 26/67] KVM: x86: Add kvm_x86_ops .cache_gprs() and .flush_gprs()
Date:   Mon, 16 Nov 2020 10:26:11 -0800
Message-Id: <e57e13793023cf2e605b93e8681b520eb492197b.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add hooks to cache and flush GPRs and invoke them from KVM_GET_REGS and
KVM_SET_REGS respecitively.  TDX will use the hooks to read/write GPRs
from TDX-SEAM on-demand (for debug TDs).

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/x86.c              | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7537ba0bada2..01c78eeefef4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1130,6 +1130,8 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
+	void (*cache_gprs)(struct kvm_vcpu *vcpu);
+	void (*flush_gprs)(struct kvm_vcpu *vcpu);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c57d1eb460..22e956f01ddc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9385,6 +9385,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (kvm_x86_ops.cache_gprs)
+		kvm_x86_ops.cache_gprs(vcpu);
+
 	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
 		/*
 		 * We are here if userspace calls get_regs() in the middle of
@@ -9459,6 +9462,9 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 	vcpu->arch.exception.pending = false;
 
+	if (kvm_x86_ops.flush_gprs)
+		kvm_x86_ops.flush_gprs(vcpu);
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
-- 
2.17.1

