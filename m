Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715634EFDA1
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353600AbiDBBLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353598AbiDBBLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:11:03 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9348FE73
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:12 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id l2-20020a17090ad10200b001ca56de815aso135865pju.0
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7avyx91O5ONbDknYrTN91hag2V92Uiaf3yyc7ikJ6Oo=;
        b=lgN0JGg0wAU/S9xkkCMagwMhbjg+igv1CYSqU9NWY3LszidXgY9Q8mwSKtd0cN+kfP
         bbwg4h40YSIeXaYQyKZlaaD3Y1gdb9B4VINZmKU3T6ZvbTxe2t7Y8gDAD3ZnBDEZjCgj
         qG5lPOTOTYQ1rudMZVmQSZvIaffENRyCo7qIPIpLuPnyBlyk90j809EPFrK71YU/BFOk
         ALHT+cBCZJ5n9EQbfIka2+Pbe7xzXWWI3IycDUwkPM7/55Nw/Si1q3/WuWRZc1ERadnY
         33HJeNGUtuLj+u2b9Ia8DrX1kuO/igrZ3L9FgTg8YxiQpeuN2rWqhtMvGg2tcENOx7F4
         bVlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7avyx91O5ONbDknYrTN91hag2V92Uiaf3yyc7ikJ6Oo=;
        b=ZEACem/wlEoRNYx4npNrnAWxy9AJ+gb0vyxA+q8t+4w/TYHK+osY8eQWdQ0w6hGlDM
         NJXIH1klvHDAJDTTkvGj/+mkOyDIPi3hhXxUG59PD5lwvUIH4MIdWMeI8/s6d3SCADvL
         tjUBWc2ZfedhxNVGdoK6LPFPq10gix60+miMrozrJnh/AtAn+Y574wGm0erbFaCzYKYN
         wdGpFESCe8yv/Rdy5WEu0lMaXqNaWlFjk36LaDcXsXq/HQQJ5AwJ0aPylGsefCvGwBP2
         7stzoWp5WPEk2odHd1qGgYGoe/bNTEZyQZe1u8pJASqYey8cmxsbkt/ILEc20OQaQYoj
         LhlA==
X-Gm-Message-State: AOAM53230Tqq2lIzuthGBbqYVkfS6wUfIZyD9gaSt6a4WthixWgGXkJo
        CYQccC/6lqClhG8qdyMMyg6PYyaXbgY=
X-Google-Smtp-Source: ABdhPJzvMNImKhhmy2dldTQRHr/5DfEDlkVSAfluMJDr/3Vdc7HuHvWtI4mJ23ei5/ubz4qjXLU7GsXO62Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8256:0:b0:4e0:78ad:eb81 with SMTP id
 e22-20020aa78256000000b004e078adeb81mr13590929pfn.30.1648861752031; Fri, 01
 Apr 2022 18:09:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:08:59 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 4/8] KVM: SVM: Stuff next_rip on emualted INT3 injection if
 NRIPS is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
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

If NRIPS is supported in hardware but disabled in KVM, set next_rip to
the next RIP when advancing RIP as part of emulating INT3 injection.
There is no flag to tell the CPU that KVM isn't using next_rip, and so
leaving next_rip is left as is will result in the CPU pushing garbage
onto the stack when vectoring the injected event.

Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 30cef3b10838..6ea8f16e39ac 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -391,6 +391,10 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 */
 		(void)svm_skip_emulated_instruction(vcpu);
 		rip = kvm_rip_read(vcpu);
+
+		if (boot_cpu_has(X86_FEATURE_NRIPS))
+			svm->vmcb->control.next_rip = rip;
+
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
 	}
-- 
2.35.1.1094.g7c7d902a7c-goog

