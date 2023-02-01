Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7124E6866EF
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjBANa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjBANai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:30:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D102A410BF
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675258154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n5g5BRaVE7Y5sLa48yF1mcVGIt0PT9vmJ+7t6OX7GDw=;
        b=evrQxQLjY75uEDbxtMNI/F8NI+1nrTJtLJ9YJ4j+zq5u6ilHHDO32lJ23S4/6l3LwoKIZa
        MC8JzIfZ6ka1gufwqRqfpKf2iruxJ8xTzm55c3xbRahUoq/bGdvaVoCTRyAAjFFm7E0K/Y
        gvfc7WwjYAbUdjLB6nHser7IWdbItTo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-82CvK5LLMseqK97uy1yOKA-1; Wed, 01 Feb 2023 08:29:11 -0500
X-MC-Unique: 82CvK5LLMseqK97uy1yOKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9289802C17;
        Wed,  1 Feb 2023 13:29:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C33140C2064;
        Wed,  1 Feb 2023 13:29:09 +0000 (UTC)
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
Subject: [PATCH 2/3] kvm: svm: Add IA32_FLUSH_CMD guest support
Date:   Wed,  1 Feb 2023 08:29:04 -0500
Message-Id: <20230201132905.549148-3-eesposit@redhat.com>
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

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 44 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d13cf53e7390..8a4fa8edf6ee 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2866,6 +2866,28 @@ static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
+static int svm_set_msr_ia32_cmd(struct kvm_vcpu *vcpu, struct msr_data *msr,
+				bool guest_has_feat, u64 cmd,
+				int x86_feature_bit)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!msr->host_initiated && !guest_has_feat)
+		return 1;
+
+	if (!(msr->data & ~cmd))
+		return 1;
+	if (!boot_cpu_has(x86_feature_bit))
+		return 1;
+	if (!msr->data)
+		return 0;
+
+	wrmsrl(msr->index, cmd);
+	set_msr_interception(vcpu, svm->msrpm, msr->index, 0, 1);
+
+	return 0;
+}
+
 static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2940,19 +2962,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
-		if (!msr->host_initiated &&
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
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
+		r = svm_set_msr_ia32_cmd(vcpu, msr,
+					 guest_has_pred_cmd_msr(vcpu),
+					 PRED_CMD_IBPB, X86_FEATURE_IBPB);
+		break;
+	case MSR_IA32_FLUSH_CMD:
+		bool guest_flush_l1d = guest_cpuid_has(vcpu,
+						       X86_FEATURE_FLUSH_L1D);
+		r = svm_set_msr_ia32_cmd(vcpu, msr, guest_flush_l1d,
+					 L1D_FLUSH, X86_FEATURE_FLUSH_L1D);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
-- 
2.39.1

