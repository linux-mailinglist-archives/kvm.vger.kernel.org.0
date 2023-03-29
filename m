Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27FB6CD46D
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 10:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjC2IVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 04:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjC2IVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 04:21:31 -0400
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EB749C1;
        Wed, 29 Mar 2023 01:20:28 -0700 (PDT)
X-QQ-mid: bizesmtp76t1680077956tsbj2yfo
Received: from localhost.localdomain ( [1.202.39.170])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Mar 2023 16:19:04 +0800 (CST)
X-QQ-SSF: 01400000000000C0H000000A0000000
X-QQ-FEAT: I8hG9CuxGDKnF0zrM7FlPwImURR4VFgXj2Ah99m1dTebzaBSKMvDh3gWmjmwt
        YHGZDYcXolBTAwjmPaGVVFtZE5ycy/uHyO37aTmsa7kltZVKznjYptQFBAsNzq1NDq44CQu
        a1ZIQC0JSKAYYyTU1Ttw/czBir82blaFk2WTeFrbFIukP38V8hGVoQAj6nJ+XzALFT21sis
        unZyqHcelYzm7YraOpFPTkASYJrVknIrlRjrnmcU7LtsdOljd9rmtYgMA2WP9IWaEm9h2Vb
        Yakz2D/SpuX9rvXiEZulLNkuqjmUWvvmlbdljWo/877hHdjdE9wHRV3/Dn+fzd0ouS2V806
        4DXyDn4LsphxnuviAb7RGEoWtCEcrrmAoMkt154Rq9TAvPe+s6WM/mX854z0s8hAWNwH+xa
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9811005486938683475
From:   Ke Guo <guoke@uniontech.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, guoke@uniontech.com
Subject: [PATCH] KVM: SVM: use kvm_pat_valid instead of kvm_mtrr_valid
Date:   Wed, 29 Mar 2023 16:18:59 +0800
Message-Id: <20230329081859.2571698-1-guoke@uniontech.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using kvm_pat_valid instead of kvm_mtrr_valid here is more appropriate. It
does the same thing as calling kvm_mtrr_valid here without two useless
check. MSR_IA32_CR_PAT is only related to PAT register but not the other
MTRR related registers.

Signed-off-by: Ke Guo <guoke@uniontech.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 252e7f37e4e2..834bf9e6c158 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2906,7 +2906,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		break;
 	case MSR_IA32_CR_PAT:
-		if (!kvm_mtrr_valid(vcpu, MSR_IA32_CR_PAT, data))
+		if (!kvm_pat_valid(data))
 			return 1;
 		vcpu->arch.pat = data;
 		svm->vmcb01.ptr->save.g_pat = data;
-- 
2.25.1

