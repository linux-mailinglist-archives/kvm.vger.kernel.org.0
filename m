Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB156BC73
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbiGHOne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238502AbiGHOnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E71F5C952
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9vk4b7jcglhc/ayKiKZzgv5keBBUhAPy8HLuXqtQs0g=;
        b=YR4fyBYhKimOAOXhwJZbhAOFit/0QeZu4x2iHN8ndkjw3TsaOT217MesqdKWm8X0dMSqeE
        xPjGG7WiuMuZb2kRERVJvoMoBBEm8gFKJ220lGyosIu8YhuEX9ELi+u8Yo0Z9ft4L69pGf
        shUWdb1Cyv9GKGEoo/EL79khNfNNvc8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-JTkRGt_7MG6rFo0S4h8ERA-1; Fri, 08 Jul 2022 10:43:09 -0400
X-MC-Unique: JTkRGt_7MG6rFo0S4h8ERA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8C02101A592;
        Fri,  8 Jul 2022 14:43:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B521F492C3B;
        Fri,  8 Jul 2022 14:43:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 17/25] KVM: VMX: Add missing VMEXIT controls to vmcs_config
Date:   Fri,  8 Jul 2022 16:42:15 +0200
Message-Id: <20220708144223.610080-18-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/vmx/vmx.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7170990f469..2fb89bdcbbd8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4196,6 +4196,10 @@ static u32 vmx_vmexit_ctrl(void)
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
index 89eaab3495a6..e9c392398f1b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -498,8 +498,11 @@ static inline u8 vmx_get_rvi(void)
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

