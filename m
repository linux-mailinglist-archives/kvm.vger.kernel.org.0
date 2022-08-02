Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399E8587FD2
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbiHBQJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237647AbiHBQJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:09:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C16014A818
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6F0Tossq5i4EP1SvO3ENLDue2PkwUeS+70GUZDLmvm8=;
        b=LCuVRXrhkO9GBFoZt9fhUMC5TCHvKgKKiNnGMDT+kcwSCRxHTKsxEbslzUI+b7wRwncV2D
        AJpGXJImkDEZQtsIytiznkNTo6D31CVGilcSWWv7bwjpU19VXXA9yMBPrYIzA3LPIWsDD/
        stXEKasR0rH0t31YvGHMAgQ7IXBT0yY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-J5hwrYPfPFC2iZmbHwJ4-A-1; Tue, 02 Aug 2022 12:08:32 -0400
X-MC-Unique: J5hwrYPfPFC2iZmbHwJ4-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F400F811E76;
        Tue,  2 Aug 2022 16:08:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CA8E2166B26;
        Tue,  2 Aug 2022 16:08:29 +0000 (UTC)
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
Subject: [PATCH v5 11/26] KVM: VMX: Get rid of eVMCS specific VMX controls sanitization
Date:   Tue,  2 Aug 2022 18:07:41 +0200
Message-Id: <20220802160756.339464-12-vkuznets@redhat.com>
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

With the updated eVMCSv1 definition, there's no known 'problematic'
controls which are exposed in VMX control MSRs but are not present in
eVMCSv1: all known Hyper-V versions either don't expose the new fields
by not setting bits in the VMX feature controls or support the new
eVMCS revision.

Get rid of VMX control MSRs filtering for KVM on Hyper-V.

Note: VMX control MSRs filtering for Hyper-V on KVM
(nested_evmcs_filter_control_msr()) stays as even the updated eVMCSv1
definition doesn't have all the features implemented by KVM and some
fields are still missing. Moreover, nested_evmcs_filter_control_msr()
has to support the original eVMCSv1 version when VMM wishes so.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 13 -------------
 arch/x86/kvm/vmx/evmcs.h |  1 -
 arch/x86/kvm/vmx/vmx.c   |  5 -----
 3 files changed, 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index e8497f9854a1..4340ef636ac3 100644
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
index 4b809c79ae63..0feac101cce4 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -203,7 +203,6 @@ static inline void evmcs_load(u64 phys_addr)
 	vp_ap->enlighten_vmentry = 1;
 }
 
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static inline void evmcs_write32(unsigned long field, u32 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bd6f8552102a..7a18a1828dc0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2768,11 +2768,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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

