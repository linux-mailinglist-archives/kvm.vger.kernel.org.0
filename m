Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C477849455B
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358059AbiATBHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358063AbiATBHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:34 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBA0C06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:33 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 67-20020a630746000000b003443fe43bbaso2672480pgh.12
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TxuUNLoyietdT61eIE0lbg64yLaLTh0tHHqgbXWBlNo=;
        b=b827jumsuFaQW5H+v6dhCHq7b3TR1naHApZBaKCp7PAs7IpS3I/CcRPHsL9rQIzmqt
         fSWR5GNGb0IeP2vIWEHrwv3wcAD2g1do2+OZRMulelc9eNpcnRSmmGV76Zsayf1p45Sj
         tYimU7SSyemoo4SMI51paePVRyaod80QTPkCULIR6ekgo2OR5EPfAKP+bxDG/40ikcQ/
         nihI9NoKpvf1vAyTGVAmDvIPmMN8BqGj3Q7wFVZOEoH6DsHrnB0VxaOPKBFEiSiWGYGR
         n8ZZwnFcW/+nxIfTwldLYVd3m9rLPY2vBJx0W9Jvi5VbX+u0tlRmC3RJBHZbvvyC7xlv
         6F8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TxuUNLoyietdT61eIE0lbg64yLaLTh0tHHqgbXWBlNo=;
        b=SKhR+LPVCuvB/iLEoglVW+FGW2gQQyrkq9vVNxTBmWtmHwm8zosP4sbwMbAWZt2LbU
         NvPqjR+1e1vFMkoi9ofTM8cNhN537E9A1KLDAxL8dhr0k4kufLXFKw8NElO3ztjixRTq
         6tthm03ohIINGZO+b4P5NnI6+VVUinf6/mNDZ6M0E2wxy1joa4UL0mrRBmGx//+rZOqX
         GNNmtydIK51eRQCSSDaOFWfKtIBywxkeZNtEi5FRBRHb3THB8fGbDyJCYz2ll4fbFwpY
         zunjpSW2MJ3LyxHhWZHLZdsjRATF6tfQPq1dKbApNRoUoOwAB0C75hfn1AtspJqRTGa4
         tc9g==
X-Gm-Message-State: AOAM5308HgBtCTXCxEfDk9Mxik7H7UtCbnPk+RlGCn3NYLZxJAL+8i0a
        1ePRAwBIilH0zoVHxW2dRnAEdw/ZpKA=
X-Google-Smtp-Source: ABdhPJy/MSJ5chrh5w+N9f9+8l6wVRl+020P8ytnIUW0IshMvWAK+MeRPrUrNbIFJ78QjFxa4TB88Hy/vGM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:1ad6:0:b0:4c1:8aa6:f622 with SMTP id
 a205-20020a621ad6000000b004c18aa6f622mr33698912pfa.41.1642640853249; Wed, 19
 Jan 2022 17:07:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:16 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 6/9] KVM: SVM: WARN if KVM attempts emulation on #UD or #GP
 for SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if KVM attempts to emulate in response to #UD or #GP for SEV guests,
i.e. if KVM intercepts #UD or #GP, as emulation on any fault except #NPF
is impossible since KVM cannot read guest private memory to get the code
stream, and the CPU's DecodeAssists feature only provides the instruction
bytes on #NPF.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 994224ae2731..ed2ca875b84b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4267,6 +4267,9 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	if (!sev_guest(vcpu->kvm))
 		return true;
 
+	/* #UD and #GP should never be intercepted for SEV guests. */
+	WARN_ON_ONCE(emul_type & (EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP));
+
 	/*
 	 * Emulation is impossible for SEV-ES guests as KVM doesn't have access
 	 * to guest register state.
-- 
2.34.1.703.g22d0c6ccf7-goog

