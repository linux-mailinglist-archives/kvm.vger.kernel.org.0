Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAF94CF369
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiCGIRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbiCGIRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:17:48 -0500
Received: from mx425.baidu.com (mx417.baidu.com [124.64.200.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4CAE62103
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 00:16:54 -0800 (PST)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx425.baidu.com (Postfix) with ESMTP id A4B7A1258055B;
        Mon,  7 Mar 2022 16:16:51 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 902FBD9932;
        Mon,  7 Mar 2022 16:16:51 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, x86@kernel.org, kvm@vger.kernel.org,
        lirongqing@baidu.com
Subject: [PATCH][resend] KVM: x86: check steal time address when enable steal time
Date:   Mon,  7 Mar 2022 16:16:51 +0800
Message-Id: <1646641011-55068-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

check steal time address when enable steal time, do not update
arch.st.msr_val if the address is invalid,  and return in #GP

this can avoid unnecessary write/read invalid memory when guest
is running

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb402966..3ed0949 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3616,6 +3616,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & KVM_STEAL_RESERVED_MASK)
 			return 1;
 
+		if (!kvm_vcpu_gfn_to_memslot(vcpu, data >> PAGE_SHIFT))
+			return 1;
+
 		vcpu->arch.st.msr_val = data;
 
 		if (!(data & KVM_MSR_ENABLED))
-- 
2.9.4

