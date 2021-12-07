Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1DA46B7F9
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhLGJyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhLGJyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:54:08 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8DCC061574;
        Tue,  7 Dec 2021 01:50:38 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u80so12951513pfc.9;
        Tue, 07 Dec 2021 01:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RMTiX2aZeNd4qpFKqUKy722u5I1mgSXu8S4DQtQTgOo=;
        b=SpKHuQ5JhTFTRwkxoCmoXjuPwIu8SNY5ax0AWHPAO08SJSQIJKpUfjzKdqHd9WAyY2
         yFghIozeSR2CA0O9t1cWSUwBeebOshvDJpxKsIAVpWawuPcmKAIy38M4u/TW0Lzdf8Hv
         HQLjQKMvHFDfyZ3BYLICrdImH6mb+uxTmhnFz4Kve9zd9zvdRSFQXfKtavts/ecjLYwv
         g2MJlDp+2Cilk6hErqOMJtPP3/j1w6vlWUY3myQBFcy8eoP51MkxZBmysfR14dyH+10H
         oUftCf2rcGbaG0H9aMfWxt2u8YiJ6STOaNG4s8dk3sqFWQNsGbzFDM6uMJnbCqhrE8A+
         CReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RMTiX2aZeNd4qpFKqUKy722u5I1mgSXu8S4DQtQTgOo=;
        b=WlVxisg9VgYQBRuUtPcq6NARphoaBmPd+k/d+pDaDVrsj1aG3CY2NeEyKpsBtAmdI4
         IrabGUv/9ZI5aC6SwjbNSUm/r/9lmzQLKd/Ke3PsR4YlVDNNlpn7FYUnatoFi2meZr0A
         EPEdTDW/q4PVCubLPIzLm0MNXv8Pik3d+eBnzs2Y0P/mtoO04dhcQWBjOCrQSnoGRDt8
         bJCxTH27SidSU8jZ6PjYGF6NFVcb9Cfv33KOcb8Tutc96AgEGav82dbnQcBcupQMCVNv
         L0n6A4VUUnzrVE6DbWTLwJaW6nWl2tNOemRlLMVfmeEPeSFmXHT/65N1q55TwZaSIpNy
         UX+Q==
X-Gm-Message-State: AOAM532vs7TdVPBx5lDo/NdIUBrjvdjWAc96/IuS9bKN9/RlIT4fS+SI
        MX0NywcTiyzygeAJzJ7FZMVA0tu68uk=
X-Google-Smtp-Source: ABdhPJxYXM+EmfUCT+R6D/b9cAtW2djDPWTxFx8shPjZ85kAR74EkhWYmkn2NgKciC921nYIsH8irA==
X-Received: by 2002:a05:6a00:1822:b0:49f:c55b:6235 with SMTP id y34-20020a056a00182200b0049fc55b6235mr41519873pfa.66.1638870637812;
        Tue, 07 Dec 2021 01:50:37 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id w20sm16533462pfu.146.2021.12.07.01.50.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 01:50:37 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/4] KVM: X86: Rename variable smap to not_smap in permission_fault()
Date:   Tue,  7 Dec 2021 17:50:37 +0800
Message-Id: <20211207095039.53166-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211207095039.53166-1-jiangshanlai@gmail.com>
References: <20211207095039.53166-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Comments above the variable says the bit is set when SMAP is overridden
or the same meaning in update_permission_bitmask(): it is not subjected
to SMAP restriction.

Renaming it to reflect the negative implication and make the code better
readability.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 018108b0113a..b70b36734bc0 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -268,9 +268,9 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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

