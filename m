Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAF165246E
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiLTQMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLTQMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:12:48 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EF510C8
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:47 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-43ea89bc5d8so120969467b3.4
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IBrgP2w19ZFMF3aW10IyLQJ8VRXdX90TEsumVmFJcoM=;
        b=Cm4ASHhCXG4dFpghACp5MwgNaHhUnSG3Nq2PnYI4DizdzCUXdLFEfHXs4ZWHuYMynH
         5cDlkw2h1+E7oP/5pWg88DzEXXF0+8Y0N6oM0Q7c6LtexOjfR4jbQjlyGS0BiI40QTNp
         YVgEPI9Npk5/7+UxQYHvZJtNDd+Lfyu+fVSoSwMgGDYZRvgk4fEt/GnE9CxzB5QR+lc4
         A1/+3Zu1CjaeObXd+6UkFL34ARWvSxHdBOp7BVHoD1SoyutjkXhRrb8CMRNeulaV8ZA9
         HUEGHAuxe2AopIm3mYvSEbOQNBacBC/ZNyaTHGyS3VhwbKOVSavS+2cprdm57z/ZZtui
         3UQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBrgP2w19ZFMF3aW10IyLQJ8VRXdX90TEsumVmFJcoM=;
        b=lQkFkF61t6cPk025VPMCdfVh5pB/BR6bIFOwP7rvXRes/RKLFhE1H22FwtrIE80NlH
         dvX+OXVkSTh/CVdaqC/WC3nRYDI4uk7F4U7a4InjI2Snx/HbN9r1AIdBO8WAHxY0k4An
         I1GzuJBXyl6Wi9hanEC05w348DSartT+Z1ztbocSnkFDW6tUua29UVHlaCKqZMZAZW8a
         53ZcC6i8eS8QMORnWRv6Q6elw1EcI0YpLJPIcwr1wGcxXITsxuCk7aCbCZd7QxNwLSbM
         jbrCLuPr3ohriVSNDfCjVJZX24FcuPwRXMPfuLNpf3/11nKY0U6WWVXvYYZMv3xwLLyG
         n54Q==
X-Gm-Message-State: ANoB5pnSDyr8vgunfoucsQm9dK08evw2hP5EHbTuywMDqOj2PlsV8m9D
        6wsMfzqveQl7Lt4XS8oifsCLHgWDKMLgu7ZuB3XISDmcFn+x2FGBwZP5nKYWdhDNft4N1pZBp19
        n/WYDbgPPiL6+shqm4olI4aKcviaBTLlsL5DrY4ttyZkt33jA4rlU83dsJbHVewk4bK9i
X-Google-Smtp-Source: AA0mqf5yys3dWJUDxHVeb8/hiVPtQq14UMCOnOT+H+CfVbaecrxXAxm6AwH9kD2jiNpcXUPdnqDTluj5igQfvtmx
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:8743:0:b0:6f0:c9e7:68bf with SMTP
 id e3-20020a258743000000b006f0c9e768bfmr71025769ybn.78.1671552766748; Tue, 20
 Dec 2022 08:12:46 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:12:30 +0000
In-Reply-To: <20221220161236.555143-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220161236.555143-2-aaronlewis@google.com>
Subject: [PATCH v8 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

When checking if a pmu event the guest is attempting to program should
be filtered, only consider the event select + unit mask in that
decision. Use an architecture specific mask to mask out all other bits,
including bits 35:32 on Intel.  Those bits are not part of the event
select and should not be considered in that decision.

Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c           | 3 ++-
 arch/x86/kvm/pmu.h           | 2 ++
 arch/x86/kvm/svm/pmu.c       | 1 +
 arch/x86/kvm/vmx/pmu_intel.c | 1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 684393c22105..760a09ff65cd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -277,7 +277,8 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 		goto out;
 
 	if (pmc_is_gp(pmc)) {
-		key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
+		key = pmc->eventsel & (kvm_pmu_ops.EVENTSEL_EVENT |
+				       ARCH_PERFMON_EVENTSEL_UMASK);
 		if (bsearch(&key, filter->events, filter->nevents,
 			    sizeof(__u64), cmp_u64))
 			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 85ff3c0588ba..5b070c563a97 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -40,6 +40,8 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+
+	const u64 EVENTSEL_EVENT;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 0e313fbae055..d3ae261d56a6 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -229,4 +229,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
+	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e5cec07ca8d9..edf23115f2ef 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -810,4 +810,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 };
-- 
2.39.0.314.g84b9a713c41-goog

