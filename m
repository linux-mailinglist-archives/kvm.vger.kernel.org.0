Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CBB75D7A1
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 00:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjGUWnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 18:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjGUWno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 18:43:44 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053CC3A87
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:43:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-66881827473so1500835b3a.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689979423; x=1690584223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QLdjoAuH6ny9qcAXLDVVZFI8shq7PUiJbkoQWuRMVVg=;
        b=r7DayOcA+ltTh6qjlaW24skIpW7xZ/eeZRZhOUL6eNDr49X0gtEPZCrp9ecJuvEyXa
         iyUjReMGUqms9AQmBsMakzpo5wZxxM68a5j76iaYZttCeKC4bgdGFfLa/BnQr3+jt8S+
         +wXPqZcgfTEEk3m9HhS0BLqP24tj0/TPPTZGgXkBIKGL56mERUjJVbULQtda6tVhY5wQ
         eqhWSNgI0nNgQGqXEIaQ8wWdHVrZ1LWyxmvpoDZcT8PSdbhwYfJDwFHV3UfEtrr/WgNh
         /BQ+a0EeMxOH3Ukt17t90axDe3hzA33+A6yMeH5hU5EXAVwuIAeIrC8vgkArp/6Z5hks
         ynzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689979423; x=1690584223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLdjoAuH6ny9qcAXLDVVZFI8shq7PUiJbkoQWuRMVVg=;
        b=QoMCnzuNPLtN2zSqh3m1aAoLXW9UYkSmeSyBpM04JgNOwfRGjfAnG8WUkji2ykok8r
         MwYHrWcgi/VasjXMLqXDhO0uosWyYsTl1ila+pbItteiiPaMQGUVwR1edsob1Dk6/fM2
         o0C1seOg+atct7ZG3WUoFQYov+O9MAsgRCnb6u2Q8prZRaYDuOi3L8B85vSEw88Gr1t1
         oYcktYW5EMa4gIA6n13FrEVFNSxXkZ0XaWqX3TlhoDg4l1rcNcmwtjPrxFLbebLLZd+Y
         5E3Af6AjDuxsxAo224oquCzzvbJaBTTHRncR+Bs1j3t7w6rT0BRnubhmBsiJPqwdiUCv
         eAuw==
X-Gm-Message-State: ABy/qLZK/1qNgoRZdMqR4ISMceqpzHRmDRrgX0k7U7O9ERiqtgoMFaKY
        yxlaWOnRJKCFVVnZQGd2CW8V3jV956M=
X-Google-Smtp-Source: APBJJlGl6ZlPeg7FzuC/9y7JTBhGtcOsUDfONYfHz3CdAvqvd3nJVGgrwd6x8dJgPSW4q+12UlFCrNglprA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f691:b0:1b8:a555:385d with SMTP id
 l17-20020a170902f69100b001b8a555385dmr13248plg.9.1689979423484; Fri, 21 Jul
 2023 15:43:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 15:43:37 -0700
In-Reply-To: <20230721224337.2335137-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721224337.2335137-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721224337.2335137-3-seanjc@google.com>
Subject: [PATCH 2/2] Revert "KVM: SVM: Skip WRMSR fastpath on VM-Exit if next
 RIP isn't valid"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that handle_fastpath_set_msr_irqoff() acquires kvm->srcu, i.e. allows
dereferencing memslots during WRMSR emulation, drop the requirement that
"next RIP" is valid.  In hindsight, acquiring kvm->srcu would have been a
better fix than avoiding the pastpath, but at the time it was thought that
accessing SRCU-protected data in the fastpath was a one-off edge case.

This reverts commit 5c30e8101e8d5d020b1d7119117889756a6ed713.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d381ad424554..cea08e5fa69b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3986,14 +3986,8 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
-
-	/*
-	 * Note, the next RIP must be provided as SRCU isn't held, i.e. KVM
-	 * can't read guest memory (dereference memslots) to decode the WRMSR.
-	 */
-	if (control->exit_code == SVM_EXIT_MSR && control->exit_info_1 &&
-	    nrips && control->next_rip)
+	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
+	    to_svm(vcpu)->vmcb->control.exit_info_1)
 		return handle_fastpath_set_msr_irqoff(vcpu);
 
 	return EXIT_FASTPATH_NONE;
-- 
2.41.0.487.g6d72f3e995-goog

