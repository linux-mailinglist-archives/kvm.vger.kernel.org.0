Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE04DCED9
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 20:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbiCQTaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 15:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbiCQTaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 15:30:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF12CA0C0
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 12:28:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t9-20020a5b03c9000000b0063363e52dd1so5212984ybp.2
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 12:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SY7x7s2PK1m0DaFeGw30caQr16xmi7SnJs2uqFu6Tyw=;
        b=L7FBCoN5t/2Ea1nlPMdTrQvGRFpECrEEIRXWJF33LoJdKXnl2+kwr+7ohPt0ZUpwC8
         vRjXdUni20pzcoCNsBojtPthikRHC4/je7IaHWt2BJc1Gty87x4/sNqHkLIeAaxpwDQu
         MbwAkJgy4/1pRCBtXQFRRSsKtg1a3ca1CLulOJCo00ek4CvUX8f33jgbxH6O8mxUmKUp
         686oeD9rdNqCEZADsu+tBJyf3wzz5jDgKG9fppCSHSBvnp8VnSIkuRRkzRwmWDH8FbXx
         nd9e3HJxyzKEPpxvznOrPODEYiOWBF5nxP5J2Vu0pDX6dKveTc3YHTPzYnERq7Ueq9+k
         Dztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SY7x7s2PK1m0DaFeGw30caQr16xmi7SnJs2uqFu6Tyw=;
        b=X5zEDbrF3/VE3NK73djrYh7wVCV5Qlu1XyBObAoaMcxwSiZKUOddAwT+ATs5rHd79j
         u1oEA6qdgxmh4ZzN9vIMnCa3LWCzMebx0CiKML304aqaduR0mud9w9OupWQA4Yb4wElA
         wBdKjqLP2aS/CzylKWITp6UWhzSpldB4vhVuayJGJKKNmQA0GntAVRqmgYhabxgAG76f
         adb9T5c4FR+5urJRA9FYrCgQlFjpoosyWVOUPxE9/e2D8Any4FJzrX8lGlN0ZBMYErOf
         T2vfcImmzsM7eKkM3q6N239G5ISjqitaM1lbSRUv3oW9CpZZiIM1PE0ZbWmkNCZDQZan
         NWEg==
X-Gm-Message-State: AOAM530nHLIm8A5x7MzWJ6Zgue/jBWqd3xRBs5s6gby337PMlkQeyZFc
        RTtcMftI+ZYotQfOKj2uI5M+6w4/Se2b/ER/9XsS4Xz6F7gr253sj7UuXQC2jMaM3xj8urnuHZK
        XVANec3FtwIMROAAT4bUK15wopApjwh0Hz2FjS2V8iV7p6/HQ9VY6Rawljw==
X-Google-Smtp-Source: ABdhPJwQs2MfYczzqOmdMxs4JsW0INyDklGddhvyOHaKSZISFHdeCt34FspbVcM3NOfEhDy57J2nJ/tDF4U=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0d:f603:0:b0:2d1:57e5:234 with SMTP id
 g3-20020a0df603000000b002d157e50234mr7664680ywf.469.1647545338416; Thu, 17
 Mar 2022 12:28:58 -0700 (PDT)
Date:   Thu, 17 Mar 2022 19:28:53 +0000
Message-Id: <20220317192853.60205-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [RESEND PATCH kvmtool] x86/cpuid: Stop masking the CPU vendor
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
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

commit bc0b99a ("kvm tools: Filter out CPU vendor string") replaced the
processor's native vendor string with a synthetic one to hack around
some interesting guest MSR accesses that were not handled in KVM. In
particular, the MC4_CTL_MASK MSR was accessed for AMD VMs, which isn't
supported by KVM. This MSR relates to masking MCEs originating from the
northbridge on real hardware, but is of zero use in virtualization.

Speaking more broadly, KVM does in fact do the right thing for such an
MSR (#GP), and it is annoying but benign that KVM does a printk for the
MSR. Masking the CPU vendor string is far from ideal, and gets in the
way of testing vendor-specific CPU features. Stop the shenanigans and
expose the vendor ID as returned by KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/cpuid.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index aa213d5..f4347a8 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -10,7 +10,6 @@
 
 static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 {
-	unsigned int signature[3];
 	unsigned int i;
 
 	/*
@@ -20,13 +19,6 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 		struct kvm_cpuid_entry2 *entry = &kvm_cpuid->entries[i];
 
 		switch (entry->function) {
-		case 0:
-			/* Vendor name */
-			memcpy(signature, "LKVMLKVMLKVM", 12);
-			entry->ebx = signature[0];
-			entry->ecx = signature[1];
-			entry->edx = signature[2];
-			break;
 		case 1:
 			entry->ebx &= ~(0xff << 24);
 			entry->ebx |= cpu_id << 24;
-- 
2.35.1.894.gb6a874cedc-goog

