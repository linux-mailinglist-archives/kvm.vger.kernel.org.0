Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB3B65866A
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 20:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiL1TZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 14:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiL1TZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 14:25:05 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48CE186A3
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 11:24:56 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m16-20020a170902db1000b0018fa0de6aa6so12581757plx.18
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 11:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sIyfuO6L8HnU8CmCldKrIpDi7aTZJyxJfn1wljTzIeI=;
        b=HbphtqtIjGcu1bCKK6wFWu4E/GlYZGDlsYger0IgbCeUkoHRrvjgvwYnY/vOQNJS3v
         FyjI7bdMglfCpRTTsNvK49p8IyLNoVRBVdcnldRVB+HUTo08LKiSrhC5Q/0Uc+QQdp+X
         IHJ89MTp65CrwucYaVMtjMiROhNdBnnGYlBREUmDHiQkTkehUA4DlpRUBvud1+SVqpMC
         6jKDiAXw31yGNOiO07z1YlMzIXbFVC8qVLvnQMkUpOleAVc5L3CryHcplcqTmY4Pt+Gf
         tXjGKaI88IH6T+SOZw737PpHr745DcyWzXyYFxhUqfzzIygXPYuztcWMdNooU6ZBsvBQ
         U5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sIyfuO6L8HnU8CmCldKrIpDi7aTZJyxJfn1wljTzIeI=;
        b=rKxCpf2iHyMPw9Vo5gHSQgpT0383SADizV4ZNNr4K6jl1c2CL49fDdxQlmxoyYqvUK
         A5QnVZvJ6I3RY2jAXe+aaBsZe3QvIDvLRJTJiVXRGFjRjQY9sInVMmzLvZml3s0aIVj5
         QLESg85hoFKOutIRziHuWu92n00gnvXnBQX9f8MlmGwTm3r0Oclnmi1eAPJKaGE2S3gT
         0r9cXemzr2FCYgoSbf5sKkRwPoIgBV5DDyLqkVCWKMdb4Y5nsC81jwsTkEyn/PSdQcKW
         N91dNMvvZfJWWjdJqAbBnrSc6OVd0sGB1eOHe/Wbwtejb/dpZTrt2aCG83noIFE59tXf
         ZRHw==
X-Gm-Message-State: AFqh2kpaUNJ0+OMjXo5MuGqDsFvZxpdEzOdXZs5ZAhKsShibDNJPiaLu
        KkbpsBeVGg9y4eqnPFc1UhI3X8nvGTutZyBi
X-Google-Smtp-Source: AMrXdXvOH+6kWmrNXWr4DzT0DiqLcTz70aEBBsdc901akacOkyNgSBf4mYJaruRIUQ+DNlIh+bmPNeoAoGZ2Pser
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:90a:7c48:b0:225:ff38:5494 with SMTP
 id e8-20020a17090a7c4800b00225ff385494mr796035pjl.151.1672255496443; Wed, 28
 Dec 2022 11:24:56 -0800 (PST)
Date:   Wed, 28 Dec 2022 19:24:38 +0000
In-Reply-To: <20221228192438.2835203-1-vannapurve@google.com>
Mime-Version: 1.0
References: <20221228192438.2835203-1-vannapurve@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221228192438.2835203-5-vannapurve@google.com>
Subject: [V4 PATCH 4/4] KVM: selftests: x86: Invoke kvm hypercall as per host cpu
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, bgardon@google.com,
        seanjc@google.com, oupton@google.com, peterx@redhat.com,
        vkuznets@redhat.com, dmatlack@google.com,
        Vishal Annapurve <vannapurve@google.com>
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

Invoke vmcall/vmmcall instructions from kvm_hypercall as per host CPU
type. CVMs and current kvm_hyerpcall callers need to execute hypercall
as per the cpu type to avoid KVM having to emulate the instruction
anyways.

CVMs need to avoid KVM emulation as the guest code is not updatable
from KVM. Guest code region can be marked un-mondifiable from KVM
without CVMs as well, so in general it's safer to avoid KVM emulation
for vmcall/vmmcall instructions.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 18f0608743d1..cc0b9c17fa91 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1154,9 +1154,15 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 {
 	uint64_t r;
 
-	asm volatile("vmcall"
+	asm volatile("test %[use_vmmcall], %[use_vmmcall]\n\t"
+		     "jnz 1f\n\t"
+		     "vmcall\n\t"
+		     "jmp 2f\n\t"
+		     "1: vmmcall\n\t"
+		     "2:"
 		     : "=a"(r)
-		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3),
+		       [use_vmmcall] "r" (is_host_cpu_amd()));
 	return r;
 }
 
-- 
2.39.0.314.g84b9a713c41-goog

