Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EC66D4184
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjDCKGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbjDCKGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:06:21 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63EFC5;
        Mon,  3 Apr 2023 03:06:18 -0700 (PDT)
X-QQ-mid: bizesmtp91t1680516325tq5obnn3
Received: from localhost.localdomain ( [1.202.39.170])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 03 Apr 2023 18:05:08 +0800 (CST)
X-QQ-SSF: 0140000000200060C000B00A0000000
X-QQ-FEAT: QityeSR92A3eE7pP0HGLRVBbG3YVAk4j1Ut2Z0cJG0qAx4nCcn1mNzmFhWDpz
        L28PwdE+7DRTU1aC/KJrEAO6XIYXyP9myId3gpjgimyiBPC08qN3RBOlWxjBroTgyuU22/V
        uvhu0Hu9cxoKQIDlyvllQCmII6ZaVH7z6h9Iou6jagcQL7j5V37K/uadLpUuR0CTyCDgnGM
        h2du7odWmpGyZtfm0j0/n/pEdxwWhPObZHJDlcgwf1WVp10MTO6I5pS0tkhha3GbAbelUC+
        ZWiOPygBM/YIq7rXOFL0Vy7EKzdvctTh2h7tsFYBJD3vyf0/20yQOuGCTTv8cucktxJWBYY
        Q/EPsiCQC3f1InH6Mc08TIKocuwxzDCHQbyUmfkVC2dX4s5vmiST1MXQqvVTrEQ6F4EUwC4
        MA7Gegptwpw=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 2117086051544787867
From:   Wenyao Hai <haiwenyao@uniontech.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wenyao Hai <haiwenyao@uniontech.com>
Subject: [PATCH V2] KVM: VMX: Reduce unnecessary call and simplify code
Date:   Mon,  3 Apr 2023 18:05:05 +0800
Message-Id: <20230403100505.322199-1-haiwenyao@uniontech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230331071929.102070-1-haiwenyao@uniontech.com>
References: <20230331071929.102070-1-haiwenyao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr2
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vcpu->arch.pat = data instead of kvm_set_msr_common() to
simplify code, avoid superfluous judgements.

Signed-off-by: Wenyao Hai <haiwenyao@uniontech.com>
---
 V1 -> V2: Modified commit message

 arch/x86/kvm/vmx/vmx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2d6e1b6c788..abeeea21c8ef 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2320,12 +2320,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
 			get_vmcs12(vcpu)->guest_ia32_pat = data;
 
-		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
+		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
 			vmcs_write64(GUEST_IA32_PAT, data);
-			vcpu->arch.pat = data;
-			break;
-		}
-		ret = kvm_set_msr_common(vcpu, msr_info);
+
+		vcpu->arch.pat = data;
 		break;
 	case MSR_IA32_MCG_EXT_CTL:
 		if ((!msr_info->host_initiated &&
-- 
2.25.1

