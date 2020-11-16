Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09412B4F5D
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388409AbgKPS2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:48461 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388350AbgKPS2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:24 -0500
IronPort-SDR: 2NAb9x1av2R5apCQGoZ41S3XFhLPFWhuWWf7tI2dwyY0GpYVrAPK5Msceovz+3vPGsjun8y2K5
 F07dzokQUuTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819220"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819220"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:23 -0800
IronPort-SDR: SdA6ZcXzGnuhcWBYFW0bgewEnreUvA1yTxRfIvU5avyG+OQsqjJt1nGl0BWrPrhl2iKtHRoEwc
 e9+HnkO5+Vqg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528406"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:23 -0800
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
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 65/67] KVM: x86: Mark the VM (TD) as bugged if non-coherent DMA is detected
Date:   Mon, 16 Nov 2020 10:26:50 -0800
Message-Id: <fa0cba75850470e3e46bf370aa921aa5d43fc64a.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX is not supported on platforms with non-coherent IOMMUs, freak out if
one is encountered, and because SEPT doesn't allow the memtype control
that's needed to support non-coherent DMA.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5566e7f25ce6..05dbdfdd7a8b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11144,6 +11144,7 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
+	KVM_BUG_ON(kvm->arch.vm_type == KVM_X86_TDX_VM, kvm);
 	atomic_inc(&kvm->arch.noncoherent_dma_count);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
-- 
2.17.1

