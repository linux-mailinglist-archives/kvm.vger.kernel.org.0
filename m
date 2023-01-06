Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7665F8EC
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjAFBQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjAFBQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:16:09 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FC33E87A
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:14:13 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id e11-20020a63d94b000000b0048988ed9a6cso220830pgj.1
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7iPI0dl/ko2Lo6A5R8RXBXgr3khsxs/MyGTJ8pdxMPM=;
        b=ZaSgs0lSr/JJODEuSDEI4kPBIyYKk9ZEyKSnyX14YyGd+KcacGTqLZcQzCGgZE1j/6
         NhleuIjiv89JqbxHeQJ2Fprh/hJA77EhZiE7Un9s7rlCZWL3wpLO7HF3MQmyLZf7y4Ey
         VcOQdJzEVe7LplFmBqKjTZykJBAlohsByvNNW9lasR6poy+KaKwQfCauHCUg8lk2GuCr
         STJy0HpuTrmVNyrlm//D66UZkS31Zf8sJ865YAvoNzjGqsLiiU9H/LbsQC4gJDvKi18C
         ZEIF2PUBAPFwzWPsCyqVAYSubqlxyCUI3MWPQbqMACZP+SDYU3Zh1jblTcAvddN2fd5p
         Qc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7iPI0dl/ko2Lo6A5R8RXBXgr3khsxs/MyGTJ8pdxMPM=;
        b=jYo5hB+nqGQkHr++zOs7a0f+ibm3E9CEYjhzSsBLx/wqrtntrnTVr6XT1giUxLMVbT
         I84VC3VUeM2OsQ39A72wVDin0Jih/rR9i+SMF0WPqjxRUgbrsACROS0yvlxro6X6Wa4R
         4+vdDaF/aFJd38singdDOYk12XUj+Y3NFsNxxJphx8EZryRQr0n90CaTc3A032wcDdzZ
         qlxnCOxlokQlo/bKIZzurtJ6J/IqKc47ZTRBORhy6U3wR8D3bkXwzcLLHe6vz2TlEKHh
         1k/R6hw8jaBHpOKl1HPnmJWCjLfpOJKLDsGmUmz0dUjSBrsA2H6xFJbkwQEv37rFHCkN
         F2Zw==
X-Gm-Message-State: AFqh2kqElTuixWB5kwkW3DqsFVnombQjhSz41CH42S++msyYhD/5G14p
        5OwOC0JtqL6WDsAXr5SUZg97BPRteGw=
X-Google-Smtp-Source: AMrXdXuV5ubZU24A/2Z/LOyqgUjmQaAt0DIadBOPeaJ7WZw6iqYZ9yittKRNJ+NxDunMF7rB5NynpgV5WyA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3604:b0:219:d1eb:b8a1 with SMTP id
 ml4-20020a17090b360400b00219d1ebb8a1mr4230658pjb.174.1672967636674; Thu, 05
 Jan 2023 17:13:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:58 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-26-seanjc@google.com>
Subject: [PATCH v5 25/33] KVM: SVM: Always update local APIC on writes to
 logical dest register
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

Update the vCPU's local (virtual) APIC on LDR writes even if the write
"fails".  The APIC needs to recalc the optimized logical map even if the
LDR is invalid or zero, e.g. if the guest clears its LDR, the optimized
map will be left as is and the vCPU will receive interrupts using its
old LDR.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1fd473a57159..144e383a4c5d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -573,7 +573,7 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
 
-static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
+static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -582,10 +582,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	/* AVIC does not support LDR update for x2APIC */
 	if (apic_x2apic_mode(vcpu->arch.apic))
-		return 0;
+		return;
 
 	if (ldr == svm->ldr_reg)
-		return 0;
+		return;
 
 	avic_invalidate_logical_id_entry(vcpu);
 
@@ -594,8 +594,6 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	if (!ret)
 		svm->ldr_reg = ldr;
-
-	return ret;
 }
 
 static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
@@ -617,8 +615,7 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 
 	switch (offset) {
 	case APIC_LDR:
-		if (avic_handle_ldr_update(vcpu))
-			return 0;
+		avic_handle_ldr_update(vcpu);
 		break;
 	case APIC_DFR:
 		avic_handle_dfr_update(vcpu);
-- 
2.39.0.314.g84b9a713c41-goog

