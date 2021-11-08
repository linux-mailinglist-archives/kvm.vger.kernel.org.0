Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0DD447FA9
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhKHMrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbhKHMrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:40 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF720C06120C;
        Mon,  8 Nov 2021 04:44:55 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p18so15648208plf.13;
        Mon, 08 Nov 2021 04:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lkQZLAs32xKdFX6mNMiLM8Wp8LK6aRx8X001XWtnJyg=;
        b=eStkVXn/kJAz1DHFPIMEuGV6xz1pzvO3JWZssAK3N0Qh/VIY19Nlq5NyDcBEqIHSqF
         O8Q4lD72bhObDYaGsUkEyOHAX0RO0VVG0v9u+VsoccwwLOUsGm0TN1UdRNrnJ+l/8gfn
         s72JU4qdJrYp9pfVUrlNM/0YRlyZj/k/MnwJ8Tb7c03BroGmt6K0Gzk3uu9A+hDT+UU6
         CYeuFztetegREKpskig8nRfFLQW4T8TklrK2cqJajFUtNqKC+LIeR/sacq84HY8JBUVO
         fPYyggf2LheT7X4R7ASg/pbN89EaTDRFKDF+O29QQNK28+gsf98wtIK3pbzFFK//IW68
         s5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lkQZLAs32xKdFX6mNMiLM8Wp8LK6aRx8X001XWtnJyg=;
        b=yDGnMmLNp2wQkd/QBGXLWfbzEeDvTVjLNDkyoqjGqRUWQTMEWKjPn67+81apRZelck
         Y4xro3z9zA8oCVq/QpOkRvR2ZF8UcHxohLvDp6PUHE7cSAo/0g/eFAZ1PX25ex0ia+hT
         noCyv+ixTPAwoCjrQNAa+b1tIpDoVZadGT4d3ImAivALl7Q2UqAwI5M5FFfC+eaD9gb5
         thXlzE0IHG1Aza8Cr1L6InuOPlxlR1muBxJ41tkqr3YX3xhcA0dZeUYbBvkPQYesiFEr
         2JvkIQeOwR4miNwC2GK6ajVB6DVSs4IG9PUMxnu+W9Qhy5YKq4XKAQHvZ8YpyEFr3N68
         ZODA==
X-Gm-Message-State: AOAM530iCAsh6bgxi0vqKKWOCMQRcfi0M/REe08sA+1DUOWWflYxIsiX
        KLOGKRF+HyjRkuol4NERwgd21x1moAk=
X-Google-Smtp-Source: ABdhPJxBRa3SKK37ZOZ3ZoioODMghksE5bZSuADmFvGtc0nk/cTT5rh8TDDqEZalvbAjtUOoNxmnpw==
X-Received: by 2002:a17:90a:49:: with SMTP id 9mr51975839pjb.80.1636375495279;
        Mon, 08 Nov 2021 04:44:55 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id y4sm16701285pfi.178.2021.11.08.04.44.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:54 -0800 (PST)
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
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 08/15] KVM: SVM: Remove useless check in svm_load_mmu_pgd()
Date:   Mon,  8 Nov 2021 20:44:00 +0800
Message-Id: <20211108124407.12187-9-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

VCPU_EXREG_CR3 is never cleared from vcpu->arch.regs_avail in SVM so
the if-branch is always false and useless, just remove it.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/svm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e3607fa025d3..b7da66935e72 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4000,8 +4000,6 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 
 		hv_track_root_tdp(vcpu, root_hpa);
 
-		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
-			return;
 		cr3 = vcpu->arch.cr3;
 	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
 		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
-- 
2.19.1.6.gb485710b

