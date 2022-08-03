Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D5588FD2
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbiHCPxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiHCPvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:51:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 825BA4D151
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwY8q9NKTMuKDlfD+95rBy75sDQtNoFH7OKEETfKcv8=;
        b=PgVidNm+pLiIDrdbAWyDD392Z9euDwgpKR42fp5AjKuZuN9v1FlDMn9yHiLfv8C8+3+kex
        pG3CGOZAwfUB5iHi2dsb0n63EOEpENc4C3ABUUawsqPNTLmv7fp725xbSyRO9AHeyxd0jI
        gpbMHHl4u56BLf9uMbvtTv2pHoOVnwU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-Tev-prOKPAWzMgdrsCQ_cA-1; Wed, 03 Aug 2022 11:51:07 -0400
X-MC-Unique: Tev-prOKPAWzMgdrsCQ_cA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DE901019C9A;
        Wed,  3 Aug 2022 15:51:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA4F81121314;
        Wed,  3 Aug 2022 15:51:02 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 12/13] KVM: x86: SVM: don't save SVM state to SMRAM when VM is not long mode capable
Date:   Wed,  3 Aug 2022 18:50:10 +0300
Message-Id: <20220803155011.43721-13-mlevitsk@redhat.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the guest CPUID doesn't have support for long mode, 32 bit SMRAM
layout is used and it has no support for preserving EFER and/or SVM
state.

Note that this isn't relevant to running 32 bit guests on VM which is
long mode capable - such VM can still run 32 bit guests in compatibility
mode.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ca5e06878e19a..64cfd26bc5e7a6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4442,6 +4442,15 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	if (!is_guest_mode(vcpu))
 		return 0;
 
+	/*
+	 * 32 bit SMRAM format doesn't preserve EFER and SVM state.
+	 * SVM should not be enabled by the userspace without marking
+	 * the CPU as at least long mode capable.
+	 */
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+		return 1;
+
 	smram->smram64.svm_guest_flag = 1;
 	smram->smram64.svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;
 
-- 
2.26.3

