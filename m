Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF371587FE6
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiHBQKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbiHBQKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:10:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F123849B47
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OS5v0XmCD8G3mjBxVV/Vj1QGtDMgomvnVCUIWMBzJ04=;
        b=BV/G+N4dWe+EkaHpJj7GBnpA0fH8wlENxso+Azb0ASY4/BVjCx38ibpmNOnxRTBRMG0E5H
        YVvcjoCiEj+p1klFGdp8Cqn0lzo7dl9yFk3hAhAskcsvXOBHakXqIjRvSQsv4+YtQhn3ho
        JTI8VtRJUcOCqVj8mriAZTHPhGBZvBQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-nqhJbL2SMZyRH984UE7U2Q-1; Tue, 02 Aug 2022 12:08:51 -0400
X-MC-Unique: nqhJbL2SMZyRH984UE7U2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAD521C03364;
        Tue,  2 Aug 2022 16:08:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76B032166B26;
        Tue,  2 Aug 2022 16:08:48 +0000 (UTC)
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
Subject: [PATCH v5 18/26] KVM: VMX: Add missing VMEXIT controls to vmcs_config
Date:   Tue,  2 Aug 2022 18:07:48 +0200
Message-Id: <20220802160756.339464-19-vkuznets@redhat.com>
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
nested VMX MSR setup, add the VMEXIT controls which KVM doesn't
use but supports for nVMX to KVM_OPT_VMX_VM_EXIT_CONTROLS and
filter them out in vmx_vmexit_ctrl().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 arch/x86/kvm/vmx/vmx.h | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 94d7060aebe1..a7097c7ed547 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4281,6 +4281,13 @@ static u32 vmx_vmexit_ctrl(void)
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
index 8dd942aeaa4a..e3b908e7365f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -516,7 +516,10 @@ static inline u8 vmx_get_rvi(void)
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
2.35.3

