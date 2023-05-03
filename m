Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59716F5DEE
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 20:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjECS3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 14:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjECS3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 14:29:13 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757C57DBA
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 11:29:05 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-51c18f5ae60so2387126a12.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 11:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683138545; x=1685730545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+XG9Kzlllq+ti/90Z+KsBtO7J9NFYimJbVN3QRxLOvk=;
        b=X29uNydOzy9esvjDZDAzmyJGWiaC/8bpqbk2Hn15itn/w45LOQd8JmRA/zpwjar7/G
         zCfOqNS1PuER3kG90LJ6+faebHsfrBZgI3Gsk9OaOkOjzz+YCncaAaFKFeTjGucnaL82
         uV7amdMIE8zdLVIe+qP+XpQmBGhhs/EAOzrLAGU80Lo+kOudelqPKzbSbQ0oQyHVyBMa
         g50Ev7JfwzCubGHAIE+UmozkyzUX0bVgS5oags8b6FO52NSnPSqiB4IVtTSmtj6QDYHg
         smF9mSD6ucU4qYrBtDkwQqJSfLnkmTSjv+y/jwtO8cHVaC2OS6dmMMoRczVPyJn910iP
         gUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138545; x=1685730545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+XG9Kzlllq+ti/90Z+KsBtO7J9NFYimJbVN3QRxLOvk=;
        b=OXjkqCPhoEM4q8bDa4/4GGUI6SaaQuuEwM96A00nQobzzBGN3UEx2vqKYnHZRmMi3Y
         f0lSjNBklb6VvwtMqwJJFc1FivjopXc2uCRDTN51X/Dg/vdAJ3XZ+9CwzRn5d4AvzAgO
         np/CYE+kv6KxDKazr4V7pRdFnMshPg7/TOgqOe0xfoP9ljOUTBmtrkTxE7+1nsYZyZPP
         11++i58+7v0Eu1Nygnl8J+KJQk1jTIMDFWCRp587Lc9EBMorztuvnsJFowYgA5QhTlub
         h3w4tcCvWztYlIihQi9WkD1mINNaDhVKRjgV7AgJoaj4ZSCY5b0G7We+Y4f9Asu/fdc5
         0iUg==
X-Gm-Message-State: AC+VfDzD+0lki1Xs9gnKdMgCNGjZgmzqCJFQVn7kz2v05+rR1FQXLmOT
        eAIngiH6ABDD/QTXS2c+pDcob81jzqg=
X-Google-Smtp-Source: ACHHUZ4g8LojGEmZCmmMffo7tSPFux1H2U6OuRHLfTAyx56VmnpckmGnA7nYKNUzNHB30VgOIXF/ETeNQoc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8142:0:b0:520:53db:fbf with SMTP id
 t63-20020a638142000000b0052053db0fbfmr760255pgd.6.1683138545003; Wed, 03 May
 2023 11:29:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 11:28:51 -0700
In-Reply-To: <20230503182852.3431281-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503182852.3431281-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: x86: WARN if writes to PAT MSR are handled by common
 KVM code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

WARN and continue if a write to the PAT MSR reaches kvm_set_msr_common()
now that both VMX and SVM handle PAT writes entirely on their own.  Keep
the case statement with a WARN instead of dropping it entirely to document
why KVM's handling of reads and writes isn't symmetrical (reads are still
handled by kvm_get_msr_common().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b356c9d8a81..c36256d00250 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3701,6 +3701,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_CR_PAT:
+		/*
+		 * Writes to PAT should be handled by vendor code as both SVM
+		 * and VMX track the guest's PAT in the VMCB/VMCS.
+		 */
+		WARN_ON_ONCE(1);
+		fallthrough;
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
-- 
2.40.1.495.gc816e09b53d-goog

