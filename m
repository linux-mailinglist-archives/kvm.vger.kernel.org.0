Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED055257C0
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 00:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359155AbiELW1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 18:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359140AbiELW1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 18:27:22 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A81B68FB6
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:27:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u9-20020a17090282c900b0015ea48078b7so3348286plz.10
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=C1tmuGf3Kd7bX6AU3hgvhdPKig3pohM2CuCo9pbL7R4=;
        b=GQ3TiTInl8g97+ab53I7+wOlfYIibpi1MwqEhIfwQfpbg/6/HMjl/L86q4NTrWM0dM
         05ZvPnReez1qICDspanXCUPjFsjzwBu0BBUj3kX8ciEISZBr6TIMzKbGZKLEY7J5FK18
         sSJbmY2nlZXmhk9jpc02Uci9pJHtFV2qawWnjJJTDVt+W5U5vxt9rAOEjF/iSAFU0/qJ
         idb9XzQiNlN9Aj7g2scAGXMAESLrT3FQfUjRQl1Wo37TW81PWKygJJZU10A7FUzgGEaq
         2J80DftcI5y7GHShiS9p3WCjfcA3j7X1J0GsmYJwXSJIQF2f/PbM8BMcri0IC+st8DV6
         JFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=C1tmuGf3Kd7bX6AU3hgvhdPKig3pohM2CuCo9pbL7R4=;
        b=SMFGSfOU0Z7zxab4m5sxuQSBnMGtTkUM+lFSApnQkdkpmbVnm7Zshd8g5xegea2Gn4
         x14MmSwPyYl3pLwgirsneVyDZDWAPHYMfhDwnDpJEWlnelWHIVgF+rFlgKZtZN3sv2TU
         fN9HrBlNgZyxIaRF90hb5lHXXnfgvWZlhWklntmrqb29fsZg+4RjoUWsMioATIDxZY7C
         MlLGdllHRcQMoSmH9p8N7M07LaVmqbh97tvSWVIPcpyGega55+Cr0KeHMECOWj8l93cX
         rWTJ/17QLqyp1x30srwesCAP1urn7iitVyXwiixRq8hXlVhquB649PXyEU6mc5V6HvAv
         tctw==
X-Gm-Message-State: AOAM533EO3IJtw8o8LbPY95Q66LPO5+lSIsKwOsNRJw1+1XOYXn2Vqq4
        Oi1c019rRz5pejMGqel4o1SMnpW/CdA=
X-Google-Smtp-Source: ABdhPJxHlQ48LjPdMReroSi+205tvMnzQqeslUkAQ4n7oeIV1go/ikXM5Elxq2fyC/ZXARh+nVKIAts+k58=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:31c1:0:b0:50a:4909:2691 with SMTP id
 x184-20020a6231c1000000b0050a49092691mr1511291pfx.64.1652394440586; Thu, 12
 May 2022 15:27:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 May 2022 22:27:14 +0000
In-Reply-To: <20220512222716.4112548-1-seanjc@google.com>
Message-Id: <20220512222716.4112548-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220512222716.4112548-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 1/3] KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jue Wang <juew@google.com>
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

Return '1', not '-1', when handling an illegal WRMSR to a MCi_CTL or
MCi_STATUS MSR.  The behavior of "all zeros' or "all ones" for CTL MSRs
is architectural, as is the "only zeros" behavior for STATUS MSRs.  I.e.
the intent is to inject a #GP, not exit to userspace due to an unhandled
emulation case.  Returning '-1' gets interpreted as -EPERM up the stack
and effecitvely kills the guest.

Fixes: 890ca9aefa78 ("KVM: Add MCE support")
Fixes: 9ffd986c6e4e ("KVM: X86: #GP when guest attempts to write MCi_STATUS register w/o 0")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ee8c91fa762..bc6db58975dc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3233,13 +3233,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			 */
 			if ((offset & 0x3) == 0 &&
 			    data != 0 && (data | (1 << 10)) != ~(u64)0)
-				return -1;
+				return 1;
 
 			/* MCi_STATUS */
 			if (!msr_info->host_initiated &&
 			    (offset & 0x3) == 1 && data != 0) {
 				if (!can_set_mci_status(vcpu))
-					return -1;
+					return 1;
 			}
 
 			vcpu->arch.mce_banks[offset] = data;
-- 
2.36.0.550.gb090851708-goog

