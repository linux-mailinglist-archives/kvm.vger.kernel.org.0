Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D997858BE81
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 02:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiHHAgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiHHAgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 20:36:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0248063EB
        for <kvm@vger.kernel.org>; Sun,  7 Aug 2022 17:36:14 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b9-20020a170902d50900b0016f0342a417so5323448plg.21
        for <kvm@vger.kernel.org>; Sun, 07 Aug 2022 17:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=np/zKDyUVwS1W7aYDEH7LbBLlTsAcwXA4VI1/IKlP2I=;
        b=FiUQRaBiLsY9KBwqRfBuiGVnyDu61TCCITxCv0dgSH3rP9NopCi+2wiG0KH3QgXIjL
         vTWeCSIrOotf0pGOgTg/d+Z6FTb5wHqCMqGl3Acur2NHX9QJaSpDb6Bf16HZj985cNax
         OiYGHZo+PEE9K+iORNib2snUIlpSGMm2d9Rw68fvBY3AwcxXA5SbJoc1h70O2Wwq7Kme
         Gg90Q3I8eegCZa3Ssf5LjfkwxvUn+PuKA90T65rIcNApcB9eTIEaCVhVKlJLytT70whW
         P2uPbynkuIo6aAjClE6f7nQwiPicsjTEJdRMhySrvbOBniNwv+zc5qQZpcBn10tFTdIs
         5DaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=np/zKDyUVwS1W7aYDEH7LbBLlTsAcwXA4VI1/IKlP2I=;
        b=IOm3zECpN7Y8th+XYoiSRVeW0mzJ2WO9neE7+UA8bi+xGmXzLV+AshBlsXKE3Cm+HR
         B69OeX7YvAIaSWh2qkf+s7KAjJ/BlUDpd1BmIYAvW/Wmo0+OGZztl2+gSMuDy9blPvmI
         QJvp/Td32xgOUzrCBNb5KOJeBTPp7s0EvmFxeskSWa4ZM8tYE7/7xq6sU4mFSQYeqWzF
         mUU3aGNfOE5XCvLFMLEFEZ88ypmVk4k20nbIWqCOfnnFUbSLlTPKsXkWS+r0aSGLiYcp
         Ea1lRPFbr4aGaabEb6Wa74LXcD8WlYdTLYGiV7nS7tlqQECXjHcCi/zhCA0v6o5DdL6W
         I/DQ==
X-Gm-Message-State: ACgBeo0Dp4w8icX25Ah4DnhnOkUuHoT1490uiehBE1LAMq76UDGuQCLY
        70132SHAm9XSYE9G02itzvQ5tsnU/56V
X-Google-Smtp-Source: AA6agR4pvER6blwvdq6OmwHugcEqd/AycIb8NeErTtQnYC9hrjM1qbO+O8FI6VrlcogkC7dvkdqBl172wxDY
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr1201360pje.0.1659918973913; Sun, 07 Aug
 2022 17:36:13 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  8 Aug 2022 00:36:06 +0000
In-Reply-To: <20220808003606.424212-1-mizhang@google.com>
Message-Id: <20220808003606.424212-4-mizhang@google.com>
Mime-Version: 1.0
References: <20220808003606.424212-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 3/3] KVM: x86: Print guest pgd in kvm_nested_vmenter()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print guest pgd in kvm_nested_vmenter() to enrich the information for
tracing. When tdp is enabled, print the value of tdp page table (EPT/NPT);
when tdp is disabled, print the value of non-nested CR3.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/nested.c |  2 ++
 arch/x86/kvm/trace.h      | 13 +++++++++----
 arch/x86/kvm/vmx/nested.c |  2 ++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0a148a352c3a..0b91a82a3755 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -730,6 +730,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 			       vmcb12->control.int_ctl,
 			       vmcb12->control.event_inj,
 			       vmcb12->control.nested_ctl,
+			       vmcb12->control.nested_cr3,
+			       vmcb12->save.cr3,
 			       KVM_ISA_SVM);
 
 	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 3ef29c7e4f69..821b3d254bb9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -580,9 +580,10 @@ TRACE_EVENT(kvm_pv_eoi,
  */
 TRACE_EVENT(kvm_nested_vmenter,
 	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
-		     __u32 event_inj, bool tdp_enabled, __u32 isa),
+		     __u32 event_inj, bool tdp_enabled, __u64 guest_tdp,
+		     __u64 guest_cr3, __u32 isa),
 	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, tdp_enabled,
-		    isa),
+		    guest_tdp, guest_cr3, isa),
 
 	TP_STRUCT__entry(
 		__field(	__u64,		rip		)
@@ -591,6 +592,7 @@ TRACE_EVENT(kvm_nested_vmenter,
 		__field(	__u32,		int_ctl		)
 		__field(	__u32,		event_inj	)
 		__field(	bool,		tdp_enabled	)
+		__field(	__u64,		guest_pgd	)
 		__field(	__u32,		isa		)
 	),
 
@@ -601,11 +603,13 @@ TRACE_EVENT(kvm_nested_vmenter,
 		__entry->int_ctl	= int_ctl;
 		__entry->event_inj	= event_inj;
 		__entry->tdp_enabled	= tdp_enabled;
+		__entry->guest_pgd	= tdp_enabled ? guest_tdp : guest_cr3;
 		__entry->isa		= isa;
 	),
 
 	TP_printk("rip: 0x%016llx %s: 0x%016llx nested_rip: 0x%016llx "
-		  "int_ctl: 0x%08x event_inj: 0x%08x nested_%s: %s",
+		  "int_ctl: 0x%08x event_inj: 0x%08x nested_%s: %s, "
+		  "guest_pgd: 0x%016llx",
 		__entry->rip,
 		__entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
 		__entry->vmcb,
@@ -613,7 +617,8 @@ TRACE_EVENT(kvm_nested_vmenter,
 		__entry->int_ctl,
 		__entry->event_inj,
 		__entry->isa == KVM_ISA_VMX ? "ept" : "npt",
-		__entry->tdp_enabled ? "on" : "off")
+		__entry->tdp_enabled ? "on" : "off",
+		__entry->guest_pgd)
 );
 
 TRACE_EVENT(kvm_nested_intercepts,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a65477295ec0..4237b415e0f7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3373,6 +3373,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 				 vmcs12->guest_intr_status,
 				 vmcs12->vm_entry_intr_info_field,
 				 vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_ENABLE_EPT,
+				 vmcs12->ept_pointer,
+				 vmcs12->guest_cr3,
 				 KVM_ISA_VMX);
 
 	kvm_service_local_tlb_flush_requests(vcpu);
-- 
2.37.1.559.g78731f0fdb-goog

