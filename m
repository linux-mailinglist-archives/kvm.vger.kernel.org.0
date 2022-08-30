Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5E5A6547
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiH3Nll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiH3NlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E8DFCA38
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FOt93qaFZyGHM3bS6yprWKlmEjd91A7jA18n75/j8XE=;
        b=enHSqp1yOxqG4W5c7vSKJARmv1u3w1y78LgoNcjh6zwaPYCeybM+TuVDPdqCwDDyjgg667
        N6GiP9z7JE5nBtXsodB38DZ8fl8wRptNJRJTkV5Bb2UV2NE5ic5vIIb3lwxUe9s52yQBWG
        s4ujco/KO/UO9pj+SyiKinNShZ5bhCs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-30NGISCaODKzD-nSbb4x1Q-1; Tue, 30 Aug 2022 09:38:47 -0400
X-MC-Unique: 30NGISCaODKzD-nSbb4x1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37247811768;
        Tue, 30 Aug 2022 13:38:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A11D2166B26;
        Tue, 30 Aug 2022 13:38:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 26/33] KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
Date:   Tue, 30 Aug 2022 15:37:30 +0200
Message-Id: <20220830133737.1539624-27-vkuznets@redhat.com>
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

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, add the CPU based VM execution controls which KVM
doesn't use but supports for nVMX to KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL
and filter them out in vmx_exec_control().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.h | 6 +++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 779377380399..be69fc3a57a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4326,6 +4326,15 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
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
index 200a17ca9406..a3da84f4ea45 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -549,9 +549,13 @@ static inline u8 vmx_get_rvi(void)
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
2.37.2

