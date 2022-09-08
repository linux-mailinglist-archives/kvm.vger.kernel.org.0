Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDEC5B2A68
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiIHXeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiIHXeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:34:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BCF10D70E
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 16:31:46 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j6-20020a170902da8600b00176a4279ba4so122195plx.18
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 16:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=xeFgTKLEFiHOB/M2DDI+MkAiIXTDAhcWUCQwueHFFYo=;
        b=fHJCkeC4xm2CCMxwGvZeMN4WIrs+Rz2fN6+vaYnp/UJ6pc1sAQQxxB/ouafFLTNMa6
         MXdzZ23sWrlw3ZuFX7HcAqF3t16sutl3QssHRs5L2LQpy12bj7jTCU437CctdcJ3fn0r
         /9k3/R5oCr9E0VQhnkD6WWrq206x+JtlVfHib8u9W3zuE98hMB0fiA+CKg5KGeGrz3Oi
         V6fogMfEyvwtVfm4gEIOl008Vswek6Elst5RLuWsn4LenjRCUp0PSkqOwEWyt/PBHnVH
         eHK98WSnISjOpeBHV+iHAK/vvyiKnLd5UF/UmByhMVoi/BBcD0hg8srk1A9Waqbz2yXx
         +DUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=xeFgTKLEFiHOB/M2DDI+MkAiIXTDAhcWUCQwueHFFYo=;
        b=zSmSxd7hzJyUxMVCkxEhFlQxWt3riFtYSRpUz3pvZQIZ/1rsHc+iwyIR07UgZ7PKGD
         aF61DdAUtFMLjqV3hG1CiMZBphpO4O6lMi/dEn4H1OR2I9WJFgb3J9wd0wPAAkPwtgdY
         AAbV9KHSIJK/4uKqDMdLCg988qamAW41jcOhPedmni0Br+3XI6X9HJNTUkNdrlnT5L3M
         JmUVEvyOnewEvqN2kDHam/QjCQeL14Kw95wNWobgTs6yTDNGj8968UMvq2L06NSZzbJn
         82PNpqoM0Fvn6DoRWW5YnA/DnmNYilNwi5PMhucniJUXEvRGRlKVEfkCbqjEnGle2vHN
         1W2w==
X-Gm-Message-State: ACgBeo0jhCejgHtxutuZoF4ElJytI0NX6a6Y53V/IjGI615EmPq2hrBz
        e0D8NE3gwVH3BiGpO7bz3nVbGrO/n7A=
X-Google-Smtp-Source: AA6agR5+KvZYz7gdURCU07mIkYGoV0EpUavYTtuEpBeF40snucz+v+X1NUyfoJ3tC7ZKV8JLUy5EoDi1KEU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e7c2:b0:1f5:85ab:938c with SMTP id
 kb2-20020a17090ae7c200b001f585ab938cmr6706565pjb.133.1662679905144; Thu, 08
 Sep 2022 16:31:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  8 Sep 2022 23:31:32 +0000
In-Reply-To: <20220908233134.3523339-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220908233134.3523339-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908233134.3523339-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: selftests: Remove unnecessary register shuffling in fix_hypercall_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Use input constraints to load RAX and RBX when testing that KVM correctly
does/doesn't patch the "wrong" hypercall.  There's no need to manually
load RAX and RBX, and no reason to clobber them either (KVM is not
supposed to modify anything other than RAX).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index 2512df357ab3..dde97be3e719 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -30,14 +30,11 @@ static uint64_t svm_do_sched_yield(uint8_t apic_id)
 {
 	uint64_t ret;
 
-	asm volatile("mov %1, %%rax\n\t"
-		     "mov %2, %%rbx\n\t"
-		     "svm_hypercall_insn:\n\t"
+	asm volatile("svm_hypercall_insn:\n\t"
 		     "vmmcall\n\t"
-		     "mov %%rax, %0\n\t"
-		     : "=r"(ret)
-		     : "r"((uint64_t)KVM_HC_SCHED_YIELD), "r"((uint64_t)apic_id)
-		     : "rax", "rbx", "memory");
+		     : "=a"(ret)
+		     : "a"((uint64_t)KVM_HC_SCHED_YIELD), "b"((uint64_t)apic_id)
+		     : "memory");
 
 	return ret;
 }
@@ -47,14 +44,11 @@ static uint64_t vmx_do_sched_yield(uint8_t apic_id)
 {
 	uint64_t ret;
 
-	asm volatile("mov %1, %%rax\n\t"
-		     "mov %2, %%rbx\n\t"
-		     "vmx_hypercall_insn:\n\t"
+	asm volatile("vmx_hypercall_insn:\n\t"
 		     "vmcall\n\t"
-		     "mov %%rax, %0\n\t"
-		     : "=r"(ret)
-		     : "r"((uint64_t)KVM_HC_SCHED_YIELD), "r"((uint64_t)apic_id)
-		     : "rax", "rbx", "memory");
+		     : "=a"(ret)
+		     : "a"((uint64_t)KVM_HC_SCHED_YIELD), "b"((uint64_t)apic_id)
+		     : "memory");
 
 	return ret;
 }
-- 
2.37.2.789.g6183377224-goog

