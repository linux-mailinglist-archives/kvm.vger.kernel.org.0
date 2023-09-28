Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51647B23FA
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjI1Re6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Re4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:34:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C48D195
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 10:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695922450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oOqP2ppbORxupNPRbUHGH6nf4SvE0P2uUesTtFRc8Ik=;
        b=FZT/E3pOWqsQ1PGe7FiamhZKRvhJrb9CjbCv50Vqu6n7bRTMnWOmiZIpeksb95fm0nrMa6
        27TJr4vY5TNHxtq/buyx4OcXVwXlJABdvrTpLy/YJi0eMCJBTKEsGnav5kiAHN+0Q7Pxcs
        4g/1cK2eMvnf+z1jTOzTAtUIxnOT/Mw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-Df1GUGMiNMW4qntqZxmpqQ-1; Thu, 28 Sep 2023 13:34:04 -0400
X-MC-Unique: Df1GUGMiNMW4qntqZxmpqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EBE92810D42;
        Thu, 28 Sep 2023 17:34:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 723E314171B6;
        Thu, 28 Sep 2023 17:33:59 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     iommu@lists.linux.dev, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] x86: KVM: SVM: always update the x2avic msr interception
Date:   Thu, 28 Sep 2023 20:33:51 +0300
Message-Id: <20230928173354.217464-2-mlevitsk@redhat.com>
In-Reply-To: <20230928173354.217464-1-mlevitsk@redhat.com>
References: <20230928173354.217464-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following problem exists since x2avic was enabled in the KVM:

svm_set_x2apic_msr_interception is called to enable the interception of
the x2apic msrs.

In particular it is called at the moment the guest resets its apic.

Assuming that the guest's apic was in x2apic mode, the reset will bring
it back to the xapic mode.

The svm_set_x2apic_msr_interception however has an erroneous check for
'!apic_x2apic_mode()' which prevents it from doing anything in this case.

As a result of this, all x2apic msrs are left unintercepted, and that
exposes the bare metal x2apic (if enabled) to the guest.
Oops.

Remove the erroneous '!apic_x2apic_mode()' check to fix that.

This fixes CVE-2023-5090

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9507df93f410a63..acdd0b89e4715a3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -913,8 +913,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (intercept == svm->x2avic_msrs_intercepted)
 		return;
 
-	if (!x2avic_enabled ||
-	    !apic_x2apic_mode(svm->vcpu.arch.apic))
+	if (!x2avic_enabled)
 		return;
 
 	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
-- 
2.26.3

