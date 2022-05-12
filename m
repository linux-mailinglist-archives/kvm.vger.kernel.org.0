Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFFE524A14
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 12:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352552AbiELKOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 06:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352396AbiELKOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 06:14:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 279CD63BDA
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 03:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652350471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPUrfpTKF1ogdDfODf+4Ux6BqBNq8Ze3rzmWyPbynzA=;
        b=L/167DV4QTt+tZf38LW6Pzak11ptcZBQ5owDNQ/jZ6B8G2iq64hcmgnRBAFhRvicw0y4xN
        DJM7Di4zzrOE7OyfZKNwAcqaT/HJv3qatna2d+KQ/2asCZIYswT58lvyYA0spA7de/WWDQ
        v4aXgI5VoTOV6D+X6AqabtAXoBAwMFk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-rzFv9KAfPH2IcNiYLA30Ig-1; Thu, 12 May 2022 06:14:28 -0400
X-MC-Unique: rzFv9KAfPH2IcNiYLA30Ig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51E0D85A5BC;
        Thu, 12 May 2022 10:14:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D729115392CD;
        Thu, 12 May 2022 10:14:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: fix a typo in __try_cmpxchg_user that caused cmpxchg to be not atomic
Date:   Thu, 12 May 2022 13:14:20 +0300
Message-Id: <20220512101420.306759-1-mlevitsk@redhat.com>
In-Reply-To: <20220202004945.2540433-5-seanjc@google.com>
References: <20220202004945.2540433-5-seanjc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 1c2361f667f36 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Yes, this is the root cause of the TDP mmu leak I was doing debug of in the last week.
Non working cmpxchg on which TDP mmu relies makes it install two differnt shadow pages
under same spte.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ee8c91fa7625..79cabd3d97d22 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7329,7 +7329,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 		goto emul_write;
 
 	hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
-	if (kvm_is_error_hva(addr))
+	if (kvm_is_error_hva(hva))
 		goto emul_write;
 
 	hva += offset_in_page(gpa);
-- 
2.26.3

