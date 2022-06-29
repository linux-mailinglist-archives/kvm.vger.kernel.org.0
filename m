Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A735603FE
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiF2PID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbiF2PHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:07:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1DAD35DF1
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvXIRIWZntg17YqTCl3WUgSfMZBdo9N4P6n2aWZa2Xk=;
        b=CI/aJRIeVq4IQPHmdJUrbFmW/X6NCOOCc3DrcC/HvowmgLiptAYNjzrBSOIdzHosOCkxrj
        FpSjGscm8zTCyf/ZO63ZlH88ZKo79BaHpPF3LMkoR3b5Unk/MzFIrgRd+QhYIX4hyc3c4/
        9AN3goFPbivs/9is7he7Aim5Me6vwig=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-WiQh1mllMMuvLwLr060dRg-1; Wed, 29 Jun 2022 11:07:19 -0400
X-MC-Unique: WiQh1mllMMuvLwLr060dRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A5D71019C8A;
        Wed, 29 Jun 2022 15:07:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CC9940EC002;
        Wed, 29 Jun 2022 15:07:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/28] KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
Date:   Wed, 29 Jun 2022 17:06:18 +0200
Message-Id: <20220629150625.238286-22-vkuznets@redhat.com>
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
nested VMX MSR setup, add the CPU based VM execution controls which KVM
doesn't use but supports for nVMX to KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL
and filter them out in vmx_exec_control().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++++
 arch/x86/kvm/vmx/vmx.h | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b774b6391e0e..e5e4383d0cff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4244,6 +4244,12 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
 
+	/* Not used by KVM but supported for nesting. */
+	exec_control &= ~(CPU_BASED_RDTSC_EXITING |
+			  CPU_BASED_USE_IO_BITMAPS |
+			  CPU_BASED_MONITOR_TRAP_FLAG |
+			  CPU_BASED_PAUSE_EXITING);
+
 	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
 	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
 			  CPU_BASED_NMI_WINDOW_EXITING);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7ada8410a037..01420ef5a9b0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -543,8 +543,12 @@ static inline u8 vmx_get_rvi(void)
 #endif
 
 #define KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL			\
-	(CPU_BASED_TPR_SHADOW |					\
+	(CPU_BASED_RDTSC_EXITING |				\
+	CPU_BASED_TPR_SHADOW |					\
+	CPU_BASED_USE_IO_BITMAPS |				\
+	CPU_BASED_MONITOR_TRAP_FLAG |				\
 	CPU_BASED_USE_MSR_BITMAPS |				\
+	CPU_BASED_PAUSE_EXITING |				\
 	CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |			\
 	CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 
-- 
2.35.3

