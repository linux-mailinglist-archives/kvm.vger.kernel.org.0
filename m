Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA7B6D187E
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 09:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjCaHWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 03:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCaHVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 03:21:44 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FD2B452;
        Fri, 31 Mar 2023 00:21:20 -0700 (PDT)
X-QQ-mid: bizesmtp74t1680247178tcdee271
Received: from localhost.localdomain ( [1.202.39.170])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 31 Mar 2023 15:19:31 +0800 (CST)
X-QQ-SSF: 0140000000200060B000B00A0000000
X-QQ-FEAT: D2GZf6M6C/jlCu3/AMN9d6oIe3zyaLioIiwPBB090rgmjvvB9Jy286/N5MFQe
        zbL7NB2hgZ51D4JDk446U0fIXM+dEg4ctDOgRo8CYp7Hap+ukhbvXZ5ZgWL0NBcqgJYTslN
        E7VgkwZqjct44CWnE9iyGtpIezkHAU9uUCztfVRbCnHzt4D8CU1M/FiazL8I6647zNa1gEB
        fF0H2Ns8fsHCfSL1LfsiZMUdjmTdcRrDMRQSg23+7zTVY7cZA1RgljuUwZvvDzZ7zbvBNxT
        i/AeNmLLOfXtrWEMZ1LGSDvlyvNgpNuU+Hmt/nKI96cx/9my9UoLQmyDbeYVf7bARvAMc6i
        22WdvbOAdvW8nz2daYxUSPrzAXKj9lFdJV5flg+6gaPYH06fsVdr0DzTnOg4g==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 10139367410288235300
From:   Wenyao Hai <haiwenyao@uniontech.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wenyao Hai <haiwenyao@uniontech.com>
Subject: [PATCH] KVM: VMX: Reduce redundant call and simplify code
Date:   Fri, 31 Mar 2023 15:19:29 +0800
Message-Id: <20230331071929.102070-1-haiwenyao@uniontech.com>
X-Mailer: git-send-email 2.25.1
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
simplify code, avoid redundant judgements.

Signed-off-by: Wenyao Hai <haiwenyao@uniontech.com>
---
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

