Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE4B560429
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiF2PHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiF2PHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:07:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8003A2BB0F
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOEwaG+9Jss6xm4ldxG7O7j+VQaKwTc8UnmVebaVyaw=;
        b=fBGk6TgqNn/cz9seUxjM6J2uxrb0jUelAZIr/W7fsWIWP7LIlnlb6mZN9XE2h9bUev/Lzk
        UnkshgSUtEvD5NcyfipJXZvBvVLpxqF51KeV0BaIos5CkwHoNyjZUxbhUpXz0SiHTWK50S
        PbLLF+8AGkRdGTzkP3SLuUEWyXQyjH0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-pAY2Nv2WOomOcJtzXLEgEg-1; Wed, 29 Jun 2022 11:07:02 -0400
X-MC-Unique: pAY2Nv2WOomOcJtzXLEgEg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A1233810D5A;
        Wed, 29 Jun 2022 15:06:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B5A740EC002;
        Wed, 29 Jun 2022 15:06:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/28] KVM: VMX: Get rid of eVMCS specific VMX controls sanitization
Date:   Wed, 29 Jun 2022 17:06:10 +0200
Message-Id: <20220629150625.238286-14-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the updated eVMCSv1 definition, there's no known 'problematic'
controls which are exposed in VMX control MSRs but are not present in
eVMCSv1. Get rid of the filtering.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 13 -------------
 arch/x86/kvm/vmx/evmcs.h |  1 -
 arch/x86/kvm/vmx/vmx.c   |  5 -----
 3 files changed, 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 697590cf5b10..ed29bc9bc485 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -320,19 +320,6 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 };
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
-#if IS_ENABLED(CONFIG_HYPERV)
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
-{
-	vmcs_conf->cpu_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
-	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
-	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
-	vmcs_conf->cpu_based_3rd_exec_ctrl = 0;
-
-	vmcs_conf->vmexit_ctrl &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
-	vmcs_conf->vmentry_ctrl &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
-}
-#endif
-
 bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
 {
 	struct hv_vp_assist_page assist_page;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index c9090ac39740..36a311bb80a9 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -218,7 +218,6 @@ static inline void evmcs_load(u64 phys_addr)
 	vp_ap->enlighten_vmentry = 1;
 }
 
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static inline void evmcs_write32(unsigned long field, u32 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99cd017cd3fe..83feb70d44a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2689,11 +2689,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (enlightened_vmcs)
-		evmcs_sanitize_exec_ctrls(vmcs_conf);
-#endif
-
 	return 0;
 }
 
-- 
2.35.3

