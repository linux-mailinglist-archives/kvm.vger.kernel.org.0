Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C8465F8CA
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbjAFBN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbjAFBNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:35 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6B272D0C
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:35 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090a9f8800b002260d01b221so2088608pjp.8
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kDxvCyND+GW2720NKX+RgCL5mWGsrG1FRlKlZQabxpo=;
        b=ReJLu44Xuh4L0IBAiISnjpPDDmPZ4zwt1bptT0oPD7m/aH0WSmyL3GOnkvXTm/nwxL
         QJ2LJh6tqzSOReRZuSNjKCRtIHdOrYNhOhnIRueYmyjdWqB3GFnXlunLvUvGnn4jS3+3
         8ORcT4qtwKM/HGxgM9Mq6zhIXA7OV0ahXuuSC7z8ZOb4BFRxm1bbk667UvcrQgj798yj
         dTlMJlvImnDEKZrTB62yq9A6UHtYeivWKHoGzHpHX5Y2L+qxA3RgMEGSKLV/3jHtIAMq
         TFis3gn/knWcYiPuIwBJ+dNPLg/fgfC6RRqacslGH7qUqPsb+NXbhNr4R2x8JJ7H1SfC
         1XFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kDxvCyND+GW2720NKX+RgCL5mWGsrG1FRlKlZQabxpo=;
        b=SwM5ryLiPiVKeUI1Q4xvGHlyiU7R6b2x2Yz2RXSNha/92XpCovc+PB4fvjp2aZ4mRR
         qb2zv7CRV5DEOF8iYau9g8COSLgc03ZkAYABJNtfoHViljprTN/fba6W372ZNAASLk3f
         LszUrQ9hTjTDqXEE7oRUw3N8MY6hbYzwML3pasPSgJ/5CsqJHdEUUx3UFvaKGIAagqrR
         YzLaPAcXmb+/uG2ZCcYQtqk27x0jbgSVui2dKGKgNU2N6BKrAjC9nfWlihpVLwejhk1K
         v1mcMSino5vbJy2p2njm/pqYroyBiqiK5K5nz6o97i7PS4+F6rMUvfW/PLGKak2uHbj5
         0nuA==
X-Gm-Message-State: AFqh2kpmLzw77cKQJr7kVca9tidumID9hiaYKX260wVTiossL6g1P7p9
        QOmsJrLklftTQTJmbKkUlx9Jkr38r10=
X-Google-Smtp-Source: AMrXdXsI6obmtHI5V7B7wmBHR7mIfmRtZG2EiLT/QjCy0gfiqMsIPsfndMILkmOZcFdKLlasZmLbvJLVT5E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6748:0:b0:483:cd24:1cb7 with SMTP id
 c8-20020a656748000000b00483cd241cb7mr2838151pgu.190.1672967614819; Thu, 05
 Jan 2023 17:13:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:45 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-13-seanjc@google.com>
Subject: [PATCH v5 12/33] KVM: SVM: Compute dest based on sender's x2APIC
 status for AVIC kick
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the destination from ICRH using the sender's x2APIC status, not
each (potential) target's x2APIC status.

Fixes: c514d3a348ac ("KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID")
Cc: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 10b0e996e2e3..f2db0021c45f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -429,6 +429,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 				   u32 icrl, u32 icrh, u32 index)
 {
+	u32 dest = apic_x2apic_mode(source) ? icrh : GET_XAPIC_DEST_FIELD(icrh);
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
@@ -444,13 +445,6 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		u32 dest;
-
-		if (apic_x2apic_mode(vcpu->arch.apic))
-			dest = icrh;
-		else
-			dest = GET_XAPIC_DEST_FIELD(icrh);
-
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
 					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
-- 
2.39.0.314.g84b9a713c41-goog

