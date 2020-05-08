Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472DD1CBB76
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 01:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgEHXx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 19:53:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:30638 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgEHXxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 19:53:50 -0400
IronPort-SDR: IEeBMj4vdS9VcmKkg9xYxX6UmFzYvTW7NIjGbpAHwoqmsnUggqkaPwn58obtmhtcW7d5c5ePov
 BtXD0tt0yZAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 16:53:50 -0700
IronPort-SDR: aQ41pnR4xb366pYf5CryNKk9avHhKQW2vQAVW7dWKzbhWpZqgfanku4uGTWuuh70Ei7wMv7XL1
 Jymu09dX+aWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="264546904"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2020 16:53:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: VMX: Invoke kvm_exit tracepoint on VM-Exit due to failed VM-Enter
Date:   Fri,  8 May 2020 16:53:47 -0700
Message-Id: <20200508235348.19427-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200508235348.19427-1-sean.j.christopherson@intel.com>
References: <20200508235348.19427-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore the pre-fastpath behavior of tracing all VM-Exits, including
those due to failed VM-Enter.

Fixes: 032e5dcbcb443 ("KVM: VMX: Introduce generic fastpath handler")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bc5e5cf1d4cc8..a6d108bfc7132 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6801,6 +6801,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
+	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
+
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return EXIT_FASTPATH_NONE;
 
@@ -6810,8 +6812,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
-	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
-
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
 
-- 
2.26.0

