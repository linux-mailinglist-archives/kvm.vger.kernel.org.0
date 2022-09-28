Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11675EEA2C
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiI1XhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiI1XhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:37:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B023EFF72
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:36:59 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j11-20020a056a00234b00b005415b511595so8158923pfj.12
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=1HjnVybSCmk8PN3Kx7J1WICZYKcCSPZ9vUMHNLgvNs0=;
        b=IusJICLcxEmdez2ty2Vz8B77a5JP1QBAG0cdW/ocVron3SMKgcwJgtG928TMMmumMe
         jXbX3CojoE1ImjmaPw/GIui5hJPueMiC5uSUfsucbk50zJvddSpaE9pDWnzHcPIJOiO/
         83zZjEE+4Aqrzz2xpavzNJDV2tNQX1AOHnC7FKCGFEJzJEC8UUpOSXAgCvNDEBWqkEzl
         GHBtOz/fgSW6UYpDPU16t/Rb9aPN5s/8vITkg1otK4GGW8pmB+qG3y9u+RSyluMEjXHY
         3YRB7h7YoLGmjdscr8v2LgJOTNThjYczBQoNvapq86atBPNdj+sqHLNoFUWN6G6MF5jK
         EQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=1HjnVybSCmk8PN3Kx7J1WICZYKcCSPZ9vUMHNLgvNs0=;
        b=4BVlD66W5xWQX09czOAbyAkZlXF6DdsgFFUCtDCA98AYeKsJY/SicpdQNs5v+j0g6R
         ofz2DI+tUUrdKjSucja3P9GH3Acfh8Nmz63mr+YyrrYAMP7rwSNjsAIVLzPQrkt8rX7K
         CQ+kYjXvWcvuvDgb5zrXg0jb2gzsNAuJ4eVsN1Z/A0aQ6E89YN2US7Cv3e3UBSyoD+lH
         hF7qHHDfxMDvmopc0tdf/V5gUAOxj1LKGDNHNv1Gk30vsoxIpD7bMTm6UpPp6h2hRghH
         HpQHef/axBkG2vVZpM1+mnhs7GN7xreO3QqDDzmOMAswh14+RsaiVH3T/sn/JQjB/J1g
         8+rg==
X-Gm-Message-State: ACrzQf1qnmdwr16HU/aBd2NhI8L5I0j12pd5aRV+g3d6z12m9n6cwR7/
        2zhiz4fiPMlf47Hn0AWnnXAW4qOM8zQ=
X-Google-Smtp-Source: AMsMyM7c7CTUEAxcZIKJ3TaSJNeOpA/iJXEXySd+W0B9c+KaHrVi1iKNFO6imibHN2j7A4a4Txc/dgLEciw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:88c7:0:b0:542:3229:8d0f with SMTP id
 k7-20020aa788c7000000b0054232298d0fmr220106pff.74.1664408219026; Wed, 28 Sep
 2022 16:36:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 28 Sep 2022 23:36:48 +0000
In-Reply-To: <20220928233652.783504-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220928233652.783504-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928233652.783504-4-seanjc@google.com>
Subject: [PATCH v2 3/7] KVM: selftests: Remove unnecessary register shuffling
 in fix_hypercall_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>
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

Use input constraints to load RAX and RBX when testing that KVM correctly
does/doesn't patch the "wrong" hypercall.  There's no need to manually
load RAX and RBX, and no reason to clobber them either (KVM is not
supposed to modify anything other than RAX).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index e0004bd26536..6864eb0d5d14 100644
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
2.37.3.998.g577e59143f-goog

