Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F393856BC4D
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbiGHOnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238436AbiGHOnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2248A5722F
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BtCT34eOafblUectYrCZGmbtv5nzY7e9yLFKX/y6w7o=;
        b=GBLNPO1R9ggdUVimK//WHX4BtF43kNN3oRV0Xc4TycdSkjI7SC1AQFtFUZhmPAkxNftSod
        CWw6UDJPxG4v/FrEnjRQApc7+1He9sw4Iv4t1+kE1oFR8GcdH147qj2Efkv3rA8zO7IQ3N
        y9GCanKk9VWuT5ysiCWlhfzOjOxVhpU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-WH9hAlinP6WJJ-0nK_lB-A-1; Fri, 08 Jul 2022 10:42:57 -0400
X-MC-Unique: WH9hAlinP6WJJ-0nK_lB-A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91BB318A01BB;
        Fri,  8 Jul 2022 14:42:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36CCC492C3B;
        Fri,  8 Jul 2022 14:42:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/25] KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
Date:   Fri,  8 Jul 2022 16:42:10 +0200
Message-Id: <20220708144223.610080-13-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VM_ENTRY_IA32E_MODE control is toggled dynamically by vmx_set_efer()
and setup_vmcs_config() doesn't check its existence. On the contrary,
nested_vmx_setup_ctls_msrs() doesn set it on x86_64. Add the missing
check and filter the bit out in vmx_vmentry_ctrl().

No (real) functional change intended as all existing CPUs supporting
long mode and VMX are supposed to have it.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dd905ad72637..1aaec4d19e1b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2610,6 +2610,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
 	min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
+#ifdef CONFIG_X86_64
+	min |= VM_ENTRY_IA32E_MODE;
+#endif
 	opt = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
 	      VM_ENTRY_LOAD_IA32_PAT |
 	      VM_ENTRY_LOAD_IA32_EFER |
@@ -4242,9 +4245,14 @@ static u32 vmx_vmentry_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
-	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-	return vmentry_ctrl &
-		~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_EFER);
+	/*
+	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
+	 */
+	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
+			  VM_ENTRY_LOAD_IA32_EFER |
+			  VM_ENTRY_IA32E_MODE);
+
+	return vmentry_ctrl;
 }
 
 static u32 vmx_vmexit_ctrl(void)
-- 
2.35.3

