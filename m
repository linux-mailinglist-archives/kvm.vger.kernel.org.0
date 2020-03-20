Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C4818DA52
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCTV2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:42047 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgCTV2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:53 -0400
IronPort-SDR: VitMlAAuMcDYzmYQEjZm1JKrtc5BvLME768MrpKrGCgVpO7esX6HETt8yyF16W0QQ1qg7wR/Xd
 gfPPWW2FQA0A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:52 -0700
IronPort-SDR: ghAuvcOx6OeLT+TT0hWokk53Kj6URsyVcJrzWRXNop1mQNLjcTFDB0vI3muLMVp8pehK1+G0uy
 DSVu5+SzqRSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224465"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:52 -0700
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
Subject: [PATCH v3 17/37] KVM: SVM: Wire up ->tlb_flush_guest() directly to svm_flush_tlb()
Date:   Fri, 20 Mar 2020 14:28:13 -0700
Message-Id: <20200320212833.3507-18-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
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

