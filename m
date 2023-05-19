Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDDF709727
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 14:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjESMRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 08:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjESMRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 08:17:38 -0400
X-Greylist: delayed 1799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 May 2023 05:17:36 PDT
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D908199;
        Fri, 19 May 2023 05:17:36 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1pzyFc-0005jV-AN; Fri, 19 May 2023 13:26:24 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not V_NMI_BLOCKING_MASK
Date:   Fri, 19 May 2023 13:26:18 +0200
Message-Id: <be4ca192eb0c1e69a210db3009ca984e6a54ae69.1684495380.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

While testing Hyper-V enabled Windows Server 2019 guests on Zen4 hardware
I noticed that with vCPU count large enough (> 16) they sometimes froze at
boot.
With vCPU count of 64 they never booted successfully - suggesting some kind
of a race condition.

Since adding "vnmi=0" module parameter made these guests boot successfully
it was clear that the problem is most likely (v)NMI-related.

Running kvm-unit-tests quickly showed failing NMI-related tests cases, like
"multiple nmi" and "pending nmi" from apic-split, x2apic and xapic tests
and the NMI parts of eventinj test.

The issue was that once one NMI was being serviced no other NMI was allowed
to be set pending (NMI limit = 0), which was traced to
svm_is_vnmi_pending() wrongly testing for the "NMI blocked" flag rather
than for the "NMI pending" flag.

Fix this by testing for the right flag in svm_is_vnmi_pending().
Once this is done, the NMI-related kvm-unit-tests pass successfully and
the Windows guest no longer freezes at boot.

Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---

It's a bit sad that no-one apparently tested the vNMI patchset with
kvm-unit-tests on an actual vNMI-enabled hardware...

 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca32389f3c36..54089f990c8f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3510,7 +3510,7 @@ static bool svm_is_vnmi_pending(struct kvm_vcpu *vcpu)
 	if (!is_vnmi_enabled(svm))
 		return false;
 
-	return !!(svm->vmcb->control.int_ctl & V_NMI_BLOCKING_MASK);
+	return !!(svm->vmcb->control.int_ctl & V_NMI_PENDING_MASK);
 }
 
 static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
