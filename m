Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E4465F8BE
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbjAFBN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbjAFBNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:23 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927C071FF5
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:22 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090a9f8800b002260d01b221so2088346pjp.8
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CYYJmfZ9mNFDGGWa3J2yKpONItWzTZPphAVz+Kbcn3U=;
        b=KX8XYL9rvgWNlKIscy8mzK0MqUP7L1Eptt11dNZ8Y2gjLSZ2roViegLOvfCmQkXRpm
         tml1DSPvp1xePvkNESZNRVZ+J0GMlShsFDneY4BlLYyDCUG7XQ5iL1F274CUEEJ1tgKa
         V8Bmg8gNqLoK/+hlNaN6q/SnxniCnTNq0p+Jzh4HM0ZtHbTvl0U7KvUjA+LpZaAMvbN9
         KL/0k8zHeUTiHCcLolVAs7suPaPLUxTiylIKf+h45lufC9nHXuCUKBe9dKVFeUb2gCMK
         /5yjguwvs7UF6e3mk61i5V/mB5cMIaUnGPfbiZ0dtfjJbOjkt38R2pXpIRo8BAsY9uSA
         Pe5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYYJmfZ9mNFDGGWa3J2yKpONItWzTZPphAVz+Kbcn3U=;
        b=uwgLLhMv8Js5sOyDmQThguBW/wyiI22POlkvaJpeKcyCp6vrNsk16iVlzIhM9YDIXf
         DYRrag9QD8zSI5aDQ39HcTk7L7mmS8YrekkI4Jpt0WPIRmgo4bCt3xZZwzDKXULtBA7z
         fWZU4caO2YYwDu4i5cgEFCteYiSRqfVT2yqVeGOkJ5AQs44iNjbc51a15/i8/tOBvqL4
         mE/pqC8mdlci1juSZyoaIDYpqugbA8FvV+/nTRfIPqOYOwBfPOewD8fygdDK9TxMARlZ
         4nSRUkS4HMO30kifymwZY3Ud5vJs1bI1YRey9RJH9y7uenD1vTMlL+rbNy6Zl0QBF4WW
         H1uQ==
X-Gm-Message-State: AFqh2kriB5761L7ZfsmBOsgnNwOaXyn7GiofMXOPv11X81+bDySftkCd
        el4dQ9tAXztJdwizB0FhWnXWmYXsI3s=
X-Google-Smtp-Source: AMrXdXvZ54jo+YAhl8/uutr0jDuCzf8Ba0wnCowq+Ef3JUXXTxNdYHfjXThpH2Aq33jmQUew7tLvxV7jLNI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b207:b0:189:5ba2:4907 with SMTP id
 t7-20020a170902b20700b001895ba24907mr3964708plr.113.1672967602066; Thu, 05
 Jan 2023 17:13:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:37 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-5-seanjc@google.com>
Subject: [PATCH v5 04/33] KVM: SVM: Process ICR on AVIC IPI delivery failure
 due to invalid target
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulate ICR writes on AVIC IPI failures due to invalid targets using the
same logic as failures due to invalid types.  AVIC acceleration fails if
_any_ of the targets are invalid, and crucially VM-Exits before sending
IPIs to targets that _are_ valid.  In logical mode, the destination is a
bitmap, i.e. a single IPI can target multiple logical IDs.  Doing nothing
causes KVM to drop IPIs if at least one target is valid and at least one
target is invalid.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Cc: stable@vger.kernel.org
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 712330b80891..3b2c88b168ba 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -502,14 +502,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
 
 	switch (id) {
+	case AVIC_IPI_FAILURE_INVALID_TARGET:
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
 		 * Emulate IPIs that are not handled by AVIC hardware, which
-		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
-		 * a trap, e.g. ICR holds the correct value and RIP has been
-		 * advanced, KVM is responsible only for emulating the IPI.
-		 * Sadly, hardware may sometimes leave the BUSY flag set, in
-		 * which case KVM needs to emulate the ICR write as well in
+		 * only virtualizes Fixed, Edge-Triggered INTRs, and falls over
+		 * if _any_ targets are invalid, e.g. if the logical mode mask
+		 * is a superset of running vCPUs.
+		 *
+		 * The exit is a trap, e.g. ICR holds the correct value and RIP
+		 * has been advanced, KVM is responsible only for emulating the
+		 * IPI.  Sadly, hardware may sometimes leave the BUSY flag set,
+		 * in which case KVM needs to emulate the ICR write as well in
 		 * order to clear the BUSY flag.
 		 */
 		if (icrl & APIC_ICR_BUSY)
@@ -525,8 +529,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 */
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
 		break;
-	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;
-- 
2.39.0.314.g84b9a713c41-goog

