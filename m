Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0615A6543
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiH3Nle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiH3Nkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:40:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C36B15C780
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppxBvNBPIPgVe6xpKz5mkcug3vVW5FWLaNZHpD9dNCo=;
        b=e+y1B2YqGHDNn/1T033t11Ahr5x0mAGHVIVq5cW+rPiu7mX9z9wMmp/mtW52nRWNZEijfu
        rKuE0GOg5nLjarSDCdQ2+YooGvbnTdvJmK6QQ3ij5vsvdJs0f8d/gjbg0AJTOrmJWgfYSU
        za8GSZrEZDsd9BLhT+VRa2vwuFJH6OI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-zY9Dk9rHMvWObm9oPkwpVg-1; Tue, 30 Aug 2022 09:38:45 -0400
X-MC-Unique: zY9Dk9rHMvWObm9oPkwpVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2F75185A7B2;
        Tue, 30 Aug 2022 13:38:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25EDA2166B26;
        Tue, 30 Aug 2022 13:38:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 25/33] KVM: VMX: Add missing VMEXIT controls to vmcs_config
Date:   Tue, 30 Aug 2022 15:37:29 +0200
Message-Id: <20220830133737.1539624-26-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, add the VMEXIT controls which KVM doesn't
use but supports for nVMX to KVM_OPT_VMX_VM_EXIT_CONTROLS and
filter them out in vmx_vmexit_ctrl().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 arch/x86/kvm/vmx/vmx.h | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2e0deac5570f..779377380399 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4279,6 +4279,13 @@ static u32 vmx_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
 
+	/*
+	 * Not used by KVM and never set in vmcs01 or vmcs02, but emulated for
+	 * nested virtualization and thus allowed to be set in vmcs12.
+	 */
+	vmexit_ctrl &= ~(VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER |
+			 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER);
+
 	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e927d35bece5..200a17ca9406 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -508,7 +508,10 @@ static inline u8 vmx_get_rvi(void)
 #endif
 #define KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS				\
 	      (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |			\
+	       VM_EXIT_SAVE_IA32_PAT |					\
 	       VM_EXIT_LOAD_IA32_PAT |					\
+	       VM_EXIT_SAVE_IA32_EFER |					\
+	       VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |			\
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-- 
2.37.2

