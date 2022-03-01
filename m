Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1644C8D0A
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 14:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbiCAN4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 08:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbiCAN43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 08:56:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0A989F6F2
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 05:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646142946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OiMjjIHHeTM/gQ1C4O+yjUIrBcfp/Osrq5pxcQPrA3c=;
        b=AAcQ2G2G/iZrs/YZapnCuxjenxp55uA/TV+ZIZB6d93da9B3GirELjAfy6G9bdR4U2pQPv
        lq3t5mGX5zEuUgaWlbh3Nj2o4IJ7faxeAriUQb+eVcyIwaWpt8gHvbp6cKzUrGtpINK/uB
        8f1RoGmLMrm+WEsifiHN81S9YKwiLgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-njn-BBIVOmy3rjb8sccEhA-1; Tue, 01 Mar 2022 08:55:44 -0500
X-MC-Unique: njn-BBIVOmy3rjb8sccEhA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F5BA180473E;
        Tue,  1 Mar 2022 13:55:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E1811057FD2;
        Tue,  1 Mar 2022 13:55:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/4] KVM: x86: mark synthetic SMM vmexit as SVM_EXIT_SW
Date:   Tue,  1 Mar 2022 15:55:23 +0200
Message-Id: <20220301135526.136554-2-mlevitsk@redhat.com>
In-Reply-To: <20220301135526.136554-1-mlevitsk@redhat.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a dummy unused vmexit reason to mark the 'VM exit' that is happening
when kvm exits to handle SMM, which is not a real VM exit.

This makes it a bit easier to read the KVM trace, and avoids
other potential problems.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa8410..c08fd7f4f3414 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4218,7 +4218,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
-	ret = nested_svm_vmexit(svm);
+	ret = nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
 	if (ret)
 		return ret;
 
-- 
2.26.3

