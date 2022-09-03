Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6745ABBAD
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiICAYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiICAXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEDE10F0B4
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nl16-20020a17090b385000b001fff2445007so2128370pjb.7
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=IBvO4qkKDFwYqm7S6fXdHOVkKag46t3/GGPLwUice6c=;
        b=nIs4eo4iqErAuI6XAFNgX6K77AZBYZYcdGu5RBfi6rLgj8zJaVKBGiFUF4jy+f2znL
         k+qC3Efd6cGYqYiNAJBp29RDUUSv2MhLCeTShr4/p8PfeNBoFjjm1pmgLwA7N9MnAr3z
         qjFin8J5UL85YT7wnMqEQ+7lLJUPh2RbQka0MzvYphGjsD/IksqIhauUYX33X0QJRmi0
         IGsDmQ7WWt9MjzqOY+Kej5U6HJ1a3rr93F0KVIHfiaR0OGq94W+RVMqdNdJtOTMqRc/M
         UQpkYD+AfhWjSEyTBzdmd1UHeb0n2VLqGhCI0ia5FE6PIyWOr/KtgRP61b6mOmSw4yYk
         hdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=IBvO4qkKDFwYqm7S6fXdHOVkKag46t3/GGPLwUice6c=;
        b=kjMI8WBXZd8L0X8gwJUMhgL2l81xAtJNJWAYvjkrkdgNmd40bONXVB/eTI4SnXMnpK
         /wqAP2zRFWKz/HWbTARNARh0Z140sFdcncEV/6wXpKPmfKu9RMRYwez+Btm9rW3X5IYi
         1xgBFb6obgUrvutYwZwPKiIfLeUTgvV67es8LJx7OI9MmeoZtnraS7ya9Brc+KWjzmhU
         9K94eQk7vqdiNlTUEI1I3ZtYURttbxLv06OxPKaq9QGZMp9nOPIaRIz5uRxu1ZhQnCdE
         +KudB3LxZLmnF8Q/VVb62RaPmDQJBaEzXoL0PmFk8psXa+0SUalL1j+APFpjgd88C9rv
         cvBQ==
X-Gm-Message-State: ACgBeo32FfmdEYHdtVHtHWXKImpBx/Mk7SfJw5cPDa2aAzuyYWYvF7Ih
        6qGzY6atyJfM6AoSy1OdsymzLN1UeoY=
X-Google-Smtp-Source: AA6agR5KdEl4pFQ/8xGmdvMSfiM+U4GcrEKxOndZDwfISDdUasj0qKYxoDZRKwWyveAWxdAekfFTP/avhg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22c7:b0:175:3682:9cf5 with SMTP id
 y7-20020a17090322c700b0017536829cf5mr17164030plg.150.1662164611463; Fri, 02
 Sep 2022 17:23:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:50 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-20-seanjc@google.com>
Subject: [PATCH v2 19/23] KVM: SVM: Update svm->ldr_reg cache even if LDR is "bad"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update SVM's cache of the LDR even if the new value is "bad".  Leaving
stale information in the cache can result in KVM missing updates and/or
invalidating the wrong entry, e.g. if avic_invalidate_logical_id_entry()
is triggered after a different vCPU has "claimed" the old LDR.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 456f24378961..894d0afd761b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -566,23 +566,24 @@ static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 	return &logical_apic_id_table[index];
 }
 
-static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
+static void avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
 {
 	bool flat;
 	u32 *entry, new_entry;
 
+	if (!ldr)
+		return;
+
 	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
 	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
 	if (!entry)
-		return -EINVAL;
+		return;
 
 	new_entry = READ_ONCE(*entry);
 	new_entry &= ~AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
 	new_entry |= (g_physical_id & AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK);
 	new_entry |= AVIC_LOGICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(*entry, new_entry);
-
-	return 0;
 }
 
 static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
@@ -602,7 +603,6 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 
 static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 {
-	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
@@ -616,11 +616,8 @@ static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	avic_invalidate_logical_id_entry(vcpu);
 
-	if (ldr)
-		ret = avic_ldr_write(vcpu, id, ldr);
-
-	if (!ret)
-		svm->ldr_reg = ldr;
+	svm->ldr_reg = ldr;
+	avic_ldr_write(vcpu, id, ldr);
 }
 
 static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
-- 
2.37.2.789.g6183377224-goog

