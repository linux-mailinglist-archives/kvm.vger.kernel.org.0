Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C625587FEE
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbiHBQK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237816AbiHBQK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:10:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5687D4BD1D
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQTZA0E2UHFRN2Pk5/0INOeIHRwwQRn09cRwRALYPyA=;
        b=V5DBtH/99Z9wDVUXUSpeXgwq65ALIZoiEiif+YuG5Ep4S2nes9pJ1x1e267YfmmRu+aYnF
        1YLk2SN0cfGAlsaXqqSAHiO4MlmcikTLUbUA3ekixIssuAiywESiqlHkQNbkW8D5ycmtIN
        A/Q8rx1/aVm8R0NSDdszKxRRWSddWd8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-4iFVI04xNKeF6TkybVaivQ-1; Tue, 02 Aug 2022 12:08:55 -0400
X-MC-Unique: 4iFVI04xNKeF6TkybVaivQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6300D3803918;
        Tue,  2 Aug 2022 16:08:53 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 098A02166B2B;
        Tue,  2 Aug 2022 16:08:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 19/26] KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
Date:   Tue,  2 Aug 2022 18:07:49 +0200
Message-Id: <20220802160756.339464-20-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, add the CPU based VM execution controls which KVM
doesn't use but supports for nVMX to KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL
and filter them out in vmx_exec_control().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.h | 6 +++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a7097c7ed547..589e5de7fdbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4328,6 +4328,15 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
 
+	/*
+	 * Not used by KVM, but fully supported for nesting, i.e. are allowed in
+	 * vmcs12 and propagated to vmcs02 when set in vmcs12.
+	 */
+	exec_control &= ~(CPU_BASED_RDTSC_EXITING |
+			  CPU_BASED_USE_IO_BITMAPS |
+			  CPU_BASED_MONITOR_TRAP_FLAG |
+			  CPU_BASED_PAUSE_EXITING);
+
 	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
 	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
 			  CPU_BASED_NMI_WINDOW_EXITING);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e3b908e7365f..bf7d80ab543c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -557,9 +557,13 @@ static inline u8 vmx_get_rvi(void)
 #endif
 
 #define KVM_OPTIONAL_VMX_CPU_BASED_VM_EXEC_CONTROL			\
-	(CPU_BASED_TPR_SHADOW |						\
+	(CPU_BASED_RDTSC_EXITING |					\
+	 CPU_BASED_TPR_SHADOW |						\
+	 CPU_BASED_USE_IO_BITMAPS |					\
+	 CPU_BASED_MONITOR_TRAP_FLAG |					\
 	 CPU_BASED_USE_MSR_BITMAPS |					\
 	 CPU_BASED_NMI_WINDOW_EXITING |					\
+	 CPU_BASED_PAUSE_EXITING |					\
 	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |			\
 	 CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 
-- 
2.35.3

