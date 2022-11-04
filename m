Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE60619A81
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 15:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiKDOsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 10:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiKDOs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 10:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40093057B
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 07:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667573241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x3rQzKrQXAi/9BH92e4CJYU8l9iFtv05ST7kt/Kr7v4=;
        b=A15oYv2BICXYmYV2Tbee+Pn+3jEl5YNfi5Igm8WPxNbZTNnVNauXTdcfG1wf8BfSLJZK2t
        P6nZPopNx67jHoFXtoZ0iUjpi/vrWveXAHuhsHC1H6psUL58Xc/TJ0vcMTm3sTKwXeStu1
        a3dVtNfZcARyUY6dj07m9ovcclIVnq0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-dV285eEVMAO5IZRfMODYEA-1; Fri, 04 Nov 2022 10:47:18 -0400
X-MC-Unique: dV285eEVMAO5IZRfMODYEA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 249772823817;
        Fri,  4 Nov 2022 14:47:18 +0000 (UTC)
Received: from ovpn-192-136.brq.redhat.com (ovpn-192-136.brq.redhat.com [10.40.192.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 682B0C2DF65;
        Fri,  4 Nov 2022 14:47:16 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: nVMX: Prepare to sanitize tertiary execution controls with eVMCS
Date:   Fri,  4 Nov 2022 15:47:07 +0100
Message-Id: <20221104144708.435865-4-vkuznets@redhat.com>
In-Reply-To: <20221104144708.435865-1-vkuznets@redhat.com>
References: <20221104144708.435865-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to restoring vmcs_conf sanitization for KVM-on-Hyper-V,
(and for completeness) add tertiary VM-execution controls to
'evmcs_supported_ctrls'.

No functional change intended as KVM doesn't yet expose
MSR_IA32_VMX_PROCBASED_CTLS3 to its guests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 4 ++++
 arch/x86/kvm/vmx/evmcs.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 0f031d27741a..47f6d1cbd428 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -370,6 +370,7 @@ enum evmcs_ctrl_type {
 	EVMCS_ENTRY_CTRLS,
 	EVMCS_EXEC_CTRL,
 	EVMCS_2NDEXEC,
+	EVMCS_3RDEXEC,
 	EVMCS_PINCTRL,
 	EVMCS_VMFUNC,
 	NR_EVMCS_CTRLS,
@@ -388,6 +389,9 @@ static const u32 evmcs_supported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
 	[EVMCS_2NDEXEC] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_2NDEXEC & ~SECONDARY_EXEC_TSC_SCALING,
 	},
+	[EVMCS_3RDEXEC] = {
+		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_3RDEXEC,
+	},
 	[EVMCS_PINCTRL] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_PINCTRL,
 	},
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 4c351f334446..205b5b467617 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -96,6 +96,8 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
 	 SECONDARY_EXEC_ENCLS_EXITING)
 
+#define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
+
 #define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
 	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
 	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
-- 
2.38.1

