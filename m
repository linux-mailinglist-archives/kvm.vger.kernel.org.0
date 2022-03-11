Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE66F4D5BF5
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 08:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347007AbiCKHEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 02:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346985AbiCKHEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 02:04:34 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91BD8BF52;
        Thu, 10 Mar 2022 23:03:28 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n2so6990293plf.4;
        Thu, 10 Mar 2022 23:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aBihaRQYwPecRxz8n1A5pbPTnQ+xsKLR/Mkgvq9vX8=;
        b=W1iJMAwdQaOrDdchIMgobBvD5ADT1Zg00vXo8Usi2e48m1vTtIjM7h2hvYFaz7BlfS
         /Z0bevouYl0xGIqXIBdppUhFTcb7QUHjZ4afKYMSPA19r1EdWUuTaZZEaQKJ3KK+gYGn
         wH/pHAxmpkLheMEqc8hiWvYpaaONs+bzxIFeTdgw52UXE+CszUsbTfKWh6JzugFAK8TY
         zUrDMocyc3HFUF/MvRf1u/TUIHnut0deqQUOpnalknjWnnpb314JEZWdK3aKkUQe+e2P
         IOXGZyx7yfEHaxidxXtHTED7xNUWf+HBUk0qNA5yOELHzGghyOsDBWoYvvZyDoOdRCER
         1OMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aBihaRQYwPecRxz8n1A5pbPTnQ+xsKLR/Mkgvq9vX8=;
        b=pnbw7yL+pNTc69ql9ZeaKlAwrCopfwsJrNVfJJHWnRXhtoGyS+izkAcX7BXnaPb1p+
         vtGCMGTm3ADL2LSguZH7kCUORJviYELYdVUIVpSDFkBbTxWT0cOV/j5deSOk6fR3Tl79
         eW29sRl/3091cb3KqXNA2ULaDYCJ/FOu2XKuhtv0mHxLu2JdBYN4YL2LIKhQ5eWvo8/Z
         RWRfEGyDq55E1TGektkY1/2dqGwJhM7jBpJwx9xGIfvNoGarD87YRXIS/XeIokH4W/J1
         kYTQCG6q3JeyeWY0gEWFfIOsCtXr2lFXP3dcmQd5HEBXDgWb9TkyUK4yTbxMGxGbN/tO
         SFcQ==
X-Gm-Message-State: AOAM531grd4vP6BppZQzu0tbxtJeCirVzVUwKdNsgehqG2gWkE7CJ/ak
        QOvfsuXpig7myV61V37Ifodm5Fe66rM=
X-Google-Smtp-Source: ABdhPJzNDyNEZdgWFPxL0Be75suzoWNROVTW1tpMvu4CxVEBWGArVhzqoNO1TUGbbSe8+idNEzaZXA==
X-Received: by 2002:a17:90a:bf16:b0:1bf:37e2:e71c with SMTP id c22-20020a17090abf1600b001bf37e2e71cmr20539384pjs.96.1646982208234;
        Thu, 10 Mar 2022 23:03:28 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id hg1-20020a17090b300100b001bf70e72794sm11639121pjb.40.2022.03.10.23.03.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Mar 2022 23:03:27 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 3/5] KVM: X86: Rename variable smap to not_smap in permission_fault()
Date:   Fri, 11 Mar 2022 15:03:43 +0800
Message-Id: <20220311070346.45023-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220311070346.45023-1-jiangshanlai@gmail.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Comments above the variable says the bit is set when SMAP is overridden
or the same meaning in update_permission_bitmask(): it is not subjected
to SMAP restriction.

Renaming it to reflect the negative implication and make the code better
readability.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 74efeaefa8f8..24d94f6d378d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -234,9 +234,9 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	 * but it will be one in index if SMAP checks are being overridden.
 	 * It is important to keep this branchless.
 	 */
-	unsigned long smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
+	unsigned long not_smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
 	int index = (pfec >> 1) +
-		    (smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
+		    (not_smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
 	bool fault = (mmu->permissions[index] >> pte_access) & 1;
 	u32 errcode = PFERR_PRESENT_MASK;
 
-- 
2.19.1.6.gb485710b

