Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2FE5A6533
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiH3NlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiH3Nk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:40:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1A2155D6C
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0touUuJf73/3In9MOrJwHRR1ckxO9xzuDjSUYiJEWo=;
        b=DLd9fOsOoQN6vRjXfRrIMtkjfzDQEt5zrAEN3O7SlTyWfx4OBUXxAH+hLHfkcbC4guRl7g
        hmfOrTGC57EDp1tKc1iE5hZ8zi1X6HSpXDHss0WP6m6oG/zHN+yztMbxf1v/VQeGMkHTdR
        mg9WxXj6w5eYFlm3iGW/d7a3HpKzMZM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-GUEhvWRIPH-vw4Y_nDN4qQ-1; Tue, 30 Aug 2022 09:38:32 -0400
X-MC-Unique: GUEhvWRIPH-vw4Y_nDN4qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCC113C0D850;
        Tue, 30 Aug 2022 13:38:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA88D2166B26;
        Tue, 30 Aug 2022 13:38:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 20/33] KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in setup_vmcs_config()
Date:   Tue, 30 Aug 2022 15:37:24 +0200
Message-Id: <20220830133737.1539624-21-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPU_BASED_{INTR,NMI}_WINDOW_EXITING controls are toggled dynamically by
vmx_enable_{irq,nmi}_window, handle_interrupt_window(), handle_nmi_window()
but setup_vmcs_config() doesn't check their existence. Add the check and
filter the controls out in vmx_exec_control().

Note: KVM explicitly supports CPUs without VIRTUAL_NMIS and all these CPUs
are supposedly lacking NMI_WINDOW_EXITING too. Adjust cpu_has_virtual_nmis()
accordingly.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5e5dfef69c7..faee1db8b0e0 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -82,7 +82,8 @@ static inline bool cpu_has_vmx_basic_inout(void)
 
 static inline bool cpu_has_virtual_nmis(void)
 {
-	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
+	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
+	       vmcs_config.cpu_based_exec_ctrl & CPU_BASED_NMI_WINDOW_EXITING;
 }
 
 static inline bool cpu_has_vmx_preemption_timer(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cb662943b83a..cfe1a1157302 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2564,10 +2564,12 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      CPU_BASED_MWAIT_EXITING |
 	      CPU_BASED_MONITOR_EXITING |
 	      CPU_BASED_INVLPG_EXITING |
-	      CPU_BASED_RDPMC_EXITING;
+	      CPU_BASED_RDPMC_EXITING |
+	      CPU_BASED_INTR_WINDOW_EXITING;
 
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
+	      CPU_BASED_NMI_WINDOW_EXITING |
 	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
 	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
@@ -4378,6 +4380,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
 
+	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
+	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
+			  CPU_BASED_NMI_WINDOW_EXITING);
+
 	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
 		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
 
-- 
2.37.2

