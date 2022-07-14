Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF750574853
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbiGNJQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237922AbiGNJPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:15:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C861643339
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BM+LngK8cfEy1KSSzqDfJs30VpEJdPIfs/RB7qTBZm0=;
        b=Qp4c8qA/vvC6j9pfE35F+D862hQv8WYGD46kibmyIEhmpBFDcc5Lj43mRNmUNfjhQIYqFx
        ccZbiMiCnyGWmby/xEtdotY26pv0XoH2lVv/nMDrmR8bm9oigmYL5qUpVBlZuvKglCUVS/
        NIGSTO864uJzwDoZFzimLTe1FAYOhRU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-NYqedhN8O-ysUmVvsdmWew-1; Thu, 14 Jul 2022 05:14:16 -0400
X-MC-Unique: NYqedhN8O-ysUmVvsdmWew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E34C3C01DEF;
        Thu, 14 Jul 2022 09:14:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 640942166B26;
        Thu, 14 Jul 2022 09:14:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 18/25] KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
Date:   Thu, 14 Jul 2022 11:13:20 +0200
Message-Id: <20220714091327.1085353-19-vkuznets@redhat.com>
In-Reply-To: <20220714091327.1085353-1-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++++
 arch/x86/kvm/vmx/vmx.h | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2fb89bdcbbd8..9771c771c8f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4240,6 +4240,12 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
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
index e9c392398f1b..758f80c41beb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -539,9 +539,13 @@ static inline u8 vmx_get_rvi(void)
 #endif
 
 #define KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL			\
-	(CPU_BASED_TPR_SHADOW |					\
+	(CPU_BASED_RDTSC_EXITING |				\
+	CPU_BASED_TPR_SHADOW |					\
+	CPU_BASED_USE_IO_BITMAPS |				\
+	CPU_BASED_MONITOR_TRAP_FLAG |				\
 	CPU_BASED_USE_MSR_BITMAPS |				\
 	CPU_BASED_NMI_WINDOW_EXITING |				\
+	CPU_BASED_PAUSE_EXITING |				\
 	CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |			\
 	CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 
-- 
2.35.3

