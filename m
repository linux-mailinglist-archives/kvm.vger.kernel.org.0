Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1726A69EF5D
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBVHdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjBVHdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:33:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820C9189;
        Tue, 21 Feb 2023 23:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=7frTxIZFv6V8GcZJSwPPjJonPyC8OEzNtnJ8xaSDdjY=; b=E5kGRER7UUdajQ4OvY+g7lA3ND
        8TnbP4LsKimWd3IMfWKY/sm1xzuswDZQegXTQn0NEy3yyet7AdazYIS3DSlqQZTToOFjxCrNbin6j
        pRfb1qfpQjZSy+lSE5HI7rqs8apf+nSbtf8SuUIOfdV5Zd/qkhICGt7rTjEDxRwXXPpPfLV/FKzUc
        245rSeVmBnyetiNTKtLbq3uhW3nvS4NEPn4H3fRyGHZUxN0JzQCF9haOXTsalgvYhmEu+1VOeCY2y
        J+QygSSzO0oZNaRNSXgG6cQSaOJEDmbpNOL2rt+susiVLqDzfuO6mz+/3oFk+xHu7+U0nVtp/XKk3
        haC1cs1g==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUjcq-00B5lK-Jg; Wed, 22 Feb 2023 07:33:16 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: SVM: hyper-v: placate modpost section mismatch error
Date:   Tue, 21 Feb 2023 23:33:15 -0800
Message-Id: <20230222073315.9081-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

modpost reports section mismatch errors/warnings:
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)

Marking svm_hv_hardware_setup() as __init fixes the warnings.

I don't know why this should be needed -- it seems like a compiler
problem to me since the calling function is marked as __init.

This "(unknown) (section: .init.data)" all refer to svm_x86_ops.

Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vineeth Pillai <viremana@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/svm/svm_onhyperv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -30,7 +30,7 @@ static inline void svm_hv_init_vmcb(stru
 		hve->hv_enlightenments_control.msr_bitmap = 1;
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
