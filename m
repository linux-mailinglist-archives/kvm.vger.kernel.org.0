Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E01556BC65
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbiGHOnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238489AbiGHOnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:43:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A84E85A441
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFFz7hVDwUTXhc27r1AirBf0pqMQlMbodobdMfg7Q6o=;
        b=MoMBXoo88eR5bM4sInBdrSkTsiuuOL5inFBvZTviPQOHMXWf50N2uU7wdaXSwZP5Izz25L
        F+lq5SgNgxmzPr/UgChFrxN05e+b51LF3l+uNYTjR03cBoJZET4570n28kWScu+7x1xV/9
        WL2Mw2ZTStuJzNuVuDWb8dzFVC9NVqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-NVMQ42EkN_WPk_wjN7mehQ-1; Fri, 08 Jul 2022 10:43:07 -0400
X-MC-Unique: NVMQ42EkN_WPk_wjN7mehQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 556D418A01BE;
        Fri,  8 Jul 2022 14:43:06 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1522B492C3B;
        Fri,  8 Jul 2022 14:43:03 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 16/25] KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of setup_vmcs_config()
Date:   Fri,  8 Jul 2022 16:42:14 +0200
Message-Id: <20220708144223.610080-17-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering
to vmx_exec_control().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 93ca9ff8e641..d7170990f469 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2479,11 +2479,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control) < 0)
 		return -EIO;
-#ifdef CONFIG_X86_64
-	if (_cpu_based_exec_control & CPU_BASED_TPR_SHADOW)
-		_cpu_based_exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
-					   ~CPU_BASED_CR8_STORE_EXITING;
-#endif
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		if (adjust_vmx_controls(KVM_REQ_VMX_SECONDARY_VM_EXEC_CONTROL,
 					KVM_OPT_VMX_SECONDARY_VM_EXEC_CONTROL,
@@ -4248,13 +4243,17 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
 		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
 
-	if (!cpu_need_tpr_shadow(&vmx->vcpu)) {
+	if (!cpu_need_tpr_shadow(&vmx->vcpu))
 		exec_control &= ~CPU_BASED_TPR_SHADOW;
+
 #ifdef CONFIG_X86_64
+	if (exec_control & CPU_BASED_TPR_SHADOW)
+		exec_control &= ~(CPU_BASED_CR8_LOAD_EXITING |
+				  CPU_BASED_CR8_STORE_EXITING);
+	else
 		exec_control |= CPU_BASED_CR8_STORE_EXITING |
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
-	}
 	if (!enable_ept)
 		exec_control |= CPU_BASED_CR3_STORE_EXITING |
 				CPU_BASED_CR3_LOAD_EXITING  |
-- 
2.35.3

