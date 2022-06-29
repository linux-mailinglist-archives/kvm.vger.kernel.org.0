Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06BF560422
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiF2PIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbiF2PHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:07:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DCA3313BD
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PR2sWSUR3Ut5vTLscX402dr/jKcDAyqLOx4gYNTqSps=;
        b=AywOoNOg/o0J6+gfOAnTSmUj6eDDR3XUvFr9qbA4naTBKBm8JxWkeV27vW05REZZXf0BpY
        HdODJ1zvW1HiIJrPJzKkFsfP0HCQzeqzPkqNTC+7zb/XdQqgfK3ZNkK73hURWlLCfgusrx
        PqroGIXlxXm4KeNfGcX8CxIVUvTwQXU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-PZtENbaGPay47lVpoE9KAg-1; Wed, 29 Jun 2022 11:07:15 -0400
X-MC-Unique: PZtENbaGPay47lVpoE9KAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36848185A79C;
        Wed, 29 Jun 2022 15:07:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3591C40EC002;
        Wed, 29 Jun 2022 15:07:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 20/28] KVM: VMX: Add missing VMENTRY controls to vmcs_config
Date:   Wed, 29 Jun 2022 17:06:17 +0200
Message-Id: <20220629150625.238286-21-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, add the VMENTRY controls which KVM doesn't
use but supports for nVMX to KVM_OPT_VMX_VM_ENTRY_CONTROLS and
filter them out in vmx_vmentry_ctrl().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 arch/x86/kvm/vmx/vmx.h | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e5ab77ed37e4..b774b6391e0e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4179,6 +4179,9 @@ static u32 vmx_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
 
+	/* Not used by KVM but supported for nesting. */
+	vmentry_ctrl &= ~(VM_ENTRY_SMM | VM_ENTRY_DEACT_DUAL_MONITOR);
+
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d4503a38735b..7ada8410a037 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -479,7 +479,9 @@ static inline u8 vmx_get_rvi(void)
 		__KVM_REQ_VMX_VM_ENTRY_CONTROLS
 #endif
 #define KVM_OPT_VMX_VM_ENTRY_CONTROLS				\
-	(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |			\
+	(VM_ENTRY_SMM |						\
+	VM_ENTRY_DEACT_DUAL_MONITOR |				\
+	VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |			\
 	VM_ENTRY_LOAD_IA32_PAT |				\
 	VM_ENTRY_LOAD_IA32_EFER |				\
 	VM_ENTRY_LOAD_BNDCFGS |					\
-- 
2.35.3

