Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A144559C0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343727AbhKRLOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343758AbhKRLMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:12:31 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B572C06120F;
        Thu, 18 Nov 2021 03:08:41 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so7867162pjb.5;
        Thu, 18 Nov 2021 03:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uQxQaa/j7EXWUJQyVa/licy6Kslt0KYeAuLANLkvvZs=;
        b=qlqlPe3BBwmkZD4k2waU8sSoD4bavgjN3pfvFIXodZeBucwmrMUiOcGACzE9/KXlAl
         uF8Ga+SZH8QNIFnaiv2KQ+3HnC1mVKL3fTZYsWkSHv3pLNI1dr5T9jw79lANQ0lmeSpy
         TpxYrAJ0qr9EeAxxpXpiQlUumHXjnlfRfymZT4HbTOGg1ajKlucukKS6JlEAopiBToN8
         Pw3bfvBTas+auE7sVXlGXFdvIxbPQQddZbUOtvhdbTfwHn/mWKdKCTwotMzGVT26hTOA
         TsqcoROCUFip7R1b+qGLB+Ykf/kb4jvd96bBgWe496YmoZ+/7S6NwPPacaCjS2wZfvp4
         LvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQxQaa/j7EXWUJQyVa/licy6Kslt0KYeAuLANLkvvZs=;
        b=oGQM2HYd8Djsijm31Tb2FUpLUkN6pK0C/H1Ymska7IiHwU1qufxGJtzrRG/j7neKOd
         jbcrZBrALdBC772hUgypSTg2Lgz7R99FD8BeMpjPsbn2RJR0y3eoSA1TbsHYIjPYISVf
         c6SoCnO3WokeGaotNeMRWxxUMvMnp2mC8tLsj8wBHgG3AdJ7ZhZuk3qJxYWZaBbebeQt
         ohh370S4V/URSCKIBK2FfCnfWt08QFZqe/HNaetX2fOlq8tSrB61vBMcRUxijNEJzsGI
         LggmuJiQCvAouiZk7X0xmk8H+93rhCyLOyKQ118PhmebfuQJWkFG9vYx21c0wZL4CQ6R
         A2Tw==
X-Gm-Message-State: AOAM532jo7O90DKQ3uj3E+MnNccj33iaF5Ui//QCFFN6UgFLvRSsBNMJ
        13xFLH0QPvkHW14xOCcTkl4+QV3Wf8I=
X-Google-Smtp-Source: ABdhPJw6LQqlIxO7mSSJ6CrYFrjmOOBAQoWPfisRqGP2qNC+vfevJFbpCPOsUXgkxyFFgoZt7DNqvg==
X-Received: by 2002:a17:90b:4f4c:: with SMTP id pj12mr9395993pjb.217.1637233721057;
        Thu, 18 Nov 2021 03:08:41 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id y18sm2166790pgh.18.2021.11.18.03.08.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:40 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 06/15] KVM: VMX: Use kvm_set_msr_common() for MSR_IA32_TSC_ADJUST in the default way
Date:   Thu, 18 Nov 2021 19:08:05 +0800
Message-Id: <20211118110814.2568-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

MSR_IA32_TSC_ADJUST can be left to the default way which also uese
kvm_set_msr_common().

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cd081219b668..a0efc1e74311 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2104,9 +2104,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
-	case MSR_IA32_TSC_ADJUST:
-		ret = kvm_set_msr_common(vcpu, msr_info);
-		break;
 	case MSR_IA32_MCG_EXT_CTL:
 		if ((!msr_info->host_initiated &&
 		     !(to_vmx(vcpu)->msr_ia32_feature_control &
-- 
2.19.1.6.gb485710b

