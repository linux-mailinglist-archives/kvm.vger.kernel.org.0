Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2201878A3
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCQExT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:34106 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbgCQExT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:19 -0400
IronPort-SDR: KreRwomM7VJGpCBfE/borSampHbVfiQcTCtQOonbkZwtstv+/9zeSqFeukFnKKw9Rfz2sOY03C
 1MMA9C7vKf3g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:17 -0700
IronPort-SDR: jQD7X+ULGfM6v79c19ndhGBd76QGW88CrUMnM5XdULPlsG7KpwoMM58s4AkfCY3rU6xh8BFo0n
 Pja434OCZO9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252789"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v2 17/32] KVM: SVM: Wire up ->tlb_flush_guest() directly to svm_flush_tlb()
Date:   Mon, 16 Mar 2020 21:52:23 -0700
Message-Id: <20200317045238.30434-18-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use svm_flush_tlb() directly for kvm_x86_ops->tlb_flush_guest() now that
the @invalidate_gpa param to ->tlb_flush() is gone, i.e. the wrapper for
->tlb_flush_guest() is no longer necessary.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 62fa45dcb6a4..dfa3b53f8437 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5643,11 +5643,6 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 	invlpga(gva, svm->vmcb->control.asid);
 }
 
-static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
-{
-	svm_flush_tlb(vcpu);
-}
-
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 }
@@ -7405,7 +7400,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.tlb_flush = svm_flush_tlb,
 	.tlb_flush_gva = svm_flush_tlb_gva,
-	.tlb_flush_guest = svm_flush_tlb_guest,
+	.tlb_flush_guest = svm_flush_tlb,
 
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
-- 
2.24.1

