Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1402C560404
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiF2PIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiF2PH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:07:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C027C31913
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qg4VAqoRxLU9S6SiCst12xv/W6F6a5KULdlIKyb1Uj0=;
        b=CWM53Ktycm3Ha/sgF0+ikUX0zAE/AV5hJtGM8T52MsSzhZRurs1MdPkN9LzbgR29rwxYJj
        pofIC6kXEvYLxR97NxE6aHNISr5o7Idk04G+4puupcw36DT9FP9RSCR21nRu+Xf6L1qSkS
        qxhugEetoSRdx3wHaxMDdROjlwFaCTQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-gkiJ03skMrKmby9IoTycjg-1; Wed, 29 Jun 2022 11:07:13 -0400
X-MC-Unique: gkiJ03skMrKmby9IoTycjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDD8B1019C8E;
        Wed, 29 Jun 2022 15:07:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B5BD40EC002;
        Wed, 29 Jun 2022 15:07:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/28] KVM: VMX: Add missing VMEXIT controls to vmcs_config
Date:   Wed, 29 Jun 2022 17:06:16 +0200
Message-Id: <20220629150625.238286-20-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/vmx/vmx.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b1bc85d8744d..e5ab77ed37e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4197,6 +4197,10 @@ static u32 vmx_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
 
+	/* Not used by KVM but supported for nesting. */
+	vmexit_ctrl &= ~(VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER |
+			 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER);
+
 	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2a5dbb8330a9..d4503a38735b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -499,8 +499,11 @@ static inline u8 vmx_get_rvi(void)
 #endif
 #define KVM_OPT_VMX_VM_EXIT_CONTROLS				\
 	      (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |		\
+	      VM_EXIT_SAVE_IA32_PAT |				\
 	      VM_EXIT_LOAD_IA32_PAT |				\
+	      VM_EXIT_SAVE_IA32_EFER |				\
 	      VM_EXIT_LOAD_IA32_EFER |				\
+	      VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |		\
 	      VM_EXIT_CLEAR_BNDCFGS |				\
 	      VM_EXIT_PT_CONCEAL_PIP |				\
 	      VM_EXIT_CLEAR_IA32_RTIT_CTL)
-- 
2.35.3

