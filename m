Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19EA6866E0
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjBANaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjBANaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:30:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3FC410AB
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675258153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XCDj+BnS4gsfltBgpuq4/PEw1EkFceCEZmDi9yc7JXM=;
        b=fapuZLsV8UGGhGp8mYQzRdcaGjolAwkL4Zp57EWFNEdi/sxtDtyIDHhtxjUfKnRbo6cQ8G
        +ojYm6vp16BudwoNU4mHndxcqDwk1hZtXvn+Yn3KmhZXBuvAxjAx/BpS34yzJrBl6KgMl7
        Wv4WFRbpBSVZsxotYFnJfuU3vSqdgPY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-Pt1cGpLqNAeI-X_Ovxjr6g-1; Wed, 01 Feb 2023 08:29:10 -0500
X-MC-Unique: Pt1cGpLqNAeI-X_Ovxjr6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4292718A6460;
        Wed,  1 Feb 2023 13:29:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA10B40C2064;
        Wed,  1 Feb 2023 13:29:08 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
Date:   Wed,  1 Feb 2023 08:29:03 -0500
Message-Id: <20230201132905.549148-2-eesposit@redhat.com>
In-Reply-To: <20230201132905.549148-1-eesposit@redhat.com>
References: <20230201132905.549148-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose IA32_FLUSH_CMD to the guest if the guest CPUID enumerates
support for this MSR. As with IA32_PRED_CMD, permission for
unintercepted writes to this MSR will be granted to the guest after
the first non-zero write.

Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  3 ++
 arch/x86/kvm/vmx/vmx.c    | 70 +++++++++++++++++++++++++--------------
 2 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..075b5ade7c80 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -654,6 +654,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
+
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..9a78ea96a6d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2133,6 +2133,39 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+static int vmx_set_msr_ia32_cmd(struct kvm_vcpu *vcpu,
+				struct msr_data *msr_info,
+				bool guest_has_feat, u64 cmd,
+				int x86_feature_bit)
+{
+	if (!msr_info->host_initiated && !guest_has_feat)
+		return 1;
+
+	if (!(msr_info->data & ~cmd))
+		return 1;
+	if (!boot_cpu_has(x86_feature_bit))
+		return 1;
+	if (!msr_info->data)
+		return 0;
+
+	wrmsrl(msr_info->index, cmd);
+
+	/*
+	 * For non-nested:
+	 * When it's written (to non-zero) for the first time, pass
+	 * it through.
+	 *
+	 * For nested:
+	 * The handling of the MSR bitmap for L2 guests is done in
+	 * nested_vmx_prepare_msr_bitmap. We should not touch the
+	 * vmcs02.msr_bitmap here since it gets completely overwritten
+	 * in the merging.
+	 */
+	vmx_disable_intercept_for_msr(vcpu, msr_info->index, MSR_TYPE_W);
+
+	return 0;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2288,31 +2321,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_PRED_CMD:
-		if (!msr_info->host_initiated &&
-		    !guest_has_pred_cmd_msr(vcpu))
-			return 1;
-
-		if (data & ~PRED_CMD_IBPB)
-			return 1;
-		if (!boot_cpu_has(X86_FEATURE_IBPB))
-			return 1;
-		if (!data)
-			break;
-
-		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-
-		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging.
-		 */
-		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
+		ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
+					   guest_has_pred_cmd_msr(vcpu),
+					   PRED_CMD_IBPB,
+					   X86_FEATURE_IBPB);
+		break;
+	case MSR_IA32_FLUSH_CMD:
+		bool guest_flush_l1d = guest_cpuid_has(vcpu,
+						       X86_FEATURE_FLUSH_L1D);
+		ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
+					   guest_flush_l1d,
+					   L1D_FLUSH,
+					   X86_FEATURE_FLUSH_L1D);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
-- 
2.39.1

