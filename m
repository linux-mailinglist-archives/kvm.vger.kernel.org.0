Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010BF5961B8
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 20:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbiHPR7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 13:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiHPR7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 13:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CF780EBF
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 10:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660672787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fQmFY9VOGIe04U+1vRwOqLKcIN/QD1M65STVBWwbZ+I=;
        b=KeR7OQwrQQymyGiILLwrYYYquBJd/KQJ/1Jxe/LfWCDjbesg9t4/eKCOuCqTUWw7DaNY5C
        WJd9z/zqnRs/Vuvd6l0dUPK1W16pCXBJxVjRUGdsfP2zthG0tjDo6CTWGOatG+r7Hlk+N3
        aRHJ2cGlP8++jEuZDi0EJBdUPMUdPlo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-SOu88lKSNTKt5L6wKoT75Q-1; Tue, 16 Aug 2022 13:59:44 -0400
X-MC-Unique: SOu88lKSNTKt5L6wKoT75Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAE26101AA69;
        Tue, 16 Aug 2022 17:59:43 +0000 (UTC)
Received: from dgilbert-t580.localhost (unknown [10.33.36.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B29F492C3B;
        Tue, 16 Aug 2022 17:59:42 +0000 (UTC)
From:   "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, leobras@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH] KVM: x86: Always enable legacy fp/sse
Date:   Tue, 16 Aug 2022 18:59:36 +0100
Message-Id: <20220816175936.23238-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

A live migration under qemu is currently failing when the source
host is ~Nehalem era (pre-xsave) and the destination is much newer,
(configured with a guest CPU type of Nehalem).
QEMU always calls kvm_put_xsave, even on this combination because
KVM_CAP_CHECK_EXTENSION_VM always returns true for KVM_CAP_XSAVE.

When QEMU calls kvm_put_xsave it's rejected by
   fpu_copy_uabi_to_guest_fpstate->
     copy_uabi_to_xstate->
       validate_user_xstate_header

when the validate checks the loaded xfeatures against
user_xfeatures, which it finds to be 0.

I think our initialisation of user_xfeatures is being
too strict here, and we should always allow the base FP/SSE.

Fixes: ad856280ddea ("x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0")
bz: https://bugzilla.redhat.com/show_bug.cgi?id=2079311

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index de6d44e07e34..3b2319cecfd1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -298,7 +298,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0;
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0 |
+		XFEATURE_MASK_FPSSE;
 
 	kvm_update_pv_runtime(vcpu);
 
-- 
2.37.2

