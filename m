Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB59C5B59D9
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 14:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiILMCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 08:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiILMBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 08:01:31 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA4C3E74F;
        Mon, 12 Sep 2022 05:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1662984077; x=1694520077;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s0ZNz9XPea2aGhVpa6wsn3yqXfZ2O4WeFl/sXwOzjAI=;
  b=FFHEBb3qSNEzR1t9aFeEbJjrqvV5vCuKySBVau7uGTybLk6A/RIgBFqJ
   nt6M+icaVUOtVOlhYupvfwlUFmoSvfq3uE2XLeEfgf7mf2bEv1fSz7d1e
   2TPy7E09sZspjTEHU+XA/3Ioib2XY84FM7KExUGepbKBPU+CM6dsKGFFT
   M=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 12:00:58 +0000
Received: from EX13D07EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id BF93845393;
        Mon, 12 Sep 2022 12:00:52 +0000 (UTC)
Received: from dev-dsk-faresx-1b-818bcd8f.eu-west-1.amazon.com (10.43.162.32)
 by EX13D07EUA003.ant.amazon.com (10.43.165.176) with Microsoft SMTP Server
 (TLS) id 15.0.1497.38; Mon, 12 Sep 2022 12:00:47 +0000
From:   Fares Mehanna <faresx@amazon.de>
CC:     <faresx@amazon.de>, Benjamin Serebrin <serebrin@amazon.com>,
        Filippo Sironi <sironi@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Babu Moger <babu.moger@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: SVM: don't apply host security mitigations to the guest
Date:   Mon, 12 Sep 2022 11:58:09 +0000
Message-ID: <20220912115809.76550-1-faresx@amazon.de>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
X-Originating-IP: [10.43.162.32]
X-ClientProxiedBy: EX13D05UWC001.ant.amazon.com (10.43.162.82) To
 EX13D07EUA003.ant.amazon.com (10.43.165.176)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support of virtual SPEC_CTRL caused a new behavior in KVM which made host
security mitigations applying by default to the guests.

We noticed a regression after applying the patch, primarily because of the
enablement of SSBD on AMD Milan.

This patch keeps the new behavior of applying host security mitigations to
the guests, but adds an option to disable it so the guests are free to pick
their own security mitigations.

Fixes: d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")
Signed-off-by: Fares Mehanna <faresx@amazon.de>
Reviewed-by: Benjamin Serebrin <serebrin@amazon.com>
Reviewed-by: Filippo Sironi <sironi@amazon.de>
---
 arch/x86/kvm/svm/svm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..c6ea24685301 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -225,6 +225,10 @@ module_param(avic, bool, 0444);
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
+/* enable/disable applying host security mitigations on the guest */
+static bool host_mitigations_on_guest = true;
+module_param(host_mitigations_on_guest, bool, 0444);
+
 
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
@@ -4000,6 +4004,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+	else if (!host_mitigations_on_guest)
+		/*
+		 * Clear the host MSR before vm-enter to avoid applying host
+		 * security mitigations to the guest.
+		 */
+		x86_spec_ctrl_set_guest(0, 0);
 
 	svm_vcpu_enter_exit(vcpu);
 
@@ -4025,7 +4035,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (!sev_es_guest(vcpu->kvm))
 		reload_tss(vcpu);
 
-	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) || !host_mitigations_on_guest)
 		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	if (!sev_es_guest(vcpu->kvm)) {
-- 
2.37.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



