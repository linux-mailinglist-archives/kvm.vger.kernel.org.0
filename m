Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9964460ADBC
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 16:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiJXOcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237068AbiJXOcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 10:32:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7861C509E
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 06:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666616589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kJsLl4LmziKHBgnDcaNe3l0TTFQxVoF0LS9oUPYIa6g=;
        b=aSNROS5ZRzSYuyn1dsvlFkIEVotHi1FyS/Kf7J69rK5B1HjZteNByN2h1N/b1jD8mrMbc/
        LA8sGQBXeXqDFOIarim/+XrLMPA0C1ntT56AtBjEteX2VWfd3FZa78QivBJIsSYDbcCmSU
        mG9x7RDTdmPkHUrFfJWm2lu9IWWudLE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-dKeT6KaQMvKsjQq2qmeFTQ-1; Mon, 24 Oct 2022 08:48:49 -0400
X-MC-Unique: dKeT6KaQMvKsjQq2qmeFTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C18B3804064;
        Mon, 24 Oct 2022 12:48:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02DCE1415114;
        Mon, 24 Oct 2022 12:48:47 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH] KVM: vmx/nested: avoid blindly setting SECONDARY_EXEC_ENCLS_EXITING when sgx is enabled
Date:   Mon, 24 Oct 2022 08:48:45 -0400
Message-Id: <20221024124845.1927035-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently vmx enables SECONDARY_EXEC_ENCLS_EXITING even when sgx
is not set in the host MSR.
This was probably introduced when sgx was not yet fully supported, and
we wanted to trap guests trying to use the feature.

When booting a guest, KVM checks that the cpuid bit is actually set
in vmx.c, and if not, it does not enable the feature.

However, in nesting this control bit is blindly copied, and will be
propagated to VMCS12 and VMCS02. Therefore, when L1 tries to boot
the guest, the host will try to execute VMLOAD with VMCS02 containing
a feature that the hardware does not support, making it fail with
hardware error 0x7.

According with section A.3.3 of Intel System Programming Guide,
we should *always* check the value in the actual
MSR_IA32_VMX_PROCBASED_CTLS2 before enabling this bit.

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2127128

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8f67a9c4a287..f651084010cc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6678,6 +6678,25 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
 	return (u64)max_idx << VMCS_FIELD_INDEX_SHIFT;
 }
 
+/*
+ * According with section A.3.3 of Intel System Programming Guide,
+ * we *can* set the guest MSR control X (in our case
+ * SECONDARY_EXEC_ENCLS_EXITING) *iff* bit 32+X of
+ * MSR_IA32_VMX_PROCBASED_CTLS2 is set to 1.
+ * Otherwise it must remain zero.
+ */
+static void nested_vmx_setup_encls_exiting(struct nested_vmx_msrs *msrs)
+{
+	u32 vmx_msr_procb_low, vmx_msr_procb_high;
+
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2, vmx_msr_procb_low, vmx_msr_procb_high);
+
+	WARN_ON(vmx_msr_procb_low & SECONDARY_EXEC_ENCLS_EXITING);
+
+	if (enable_sgx && (vmx_msr_procb_high & SECONDARY_EXEC_ENCLS_EXITING))
+		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
+}
+
 /*
  * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
  * returned for the various VMX controls MSRs when nested VMX is enabled.
@@ -6874,8 +6893,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		msrs->secondary_ctls_high |=
 			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
 
-	if (enable_sgx)
-		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
+	nested_vmx_setup_encls_exiting(msrs);
 
 	/* miscellaneous data */
 	msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
-- 
2.31.1

