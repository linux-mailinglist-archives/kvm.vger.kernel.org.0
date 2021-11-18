Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC2F4559C9
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343919AbhKRLPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343605AbhKRLNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:13:50 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9AC06122E;
        Thu, 18 Nov 2021 03:09:04 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g28so5033405pgg.3;
        Thu, 18 Nov 2021 03:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JOQN1FyHOOaGiRO0iQypErrhkvSTjnVtAXlZRhg9yE=;
        b=SWzLZH0gSfsxgOlxNe8D3XhBWumtB+31hB7IrnhHBoGf31cVnezIztbZRRvnuM2Mx6
         9gMsvE9VIrqHg6l0zlVzdmLYMkx54vw/+ShFLTqMtMei3bA8VVCpRMfYI5biDZkZuhFX
         RXUSAWYWvi25bh3lNMW3I8Cp9GZYB4eMyofmNtjmuBp3mZOO7c8w/bLmCYScpvaRXBL5
         miIfTBWeAH1h9pL8Y34onHqDWkhDPOIbPqPhzAlS682NdfqQ+RtrF60DvpfgPoSIPqLr
         q8apt5rp7S6xCyBFoNuiO4MFKvfUzc7L/aP56IOjvXYurQEMMQFat01Gs47R+lQYfO6N
         /h6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JOQN1FyHOOaGiRO0iQypErrhkvSTjnVtAXlZRhg9yE=;
        b=OWX8DZ+9uILLnyZdloQElQ0QGmHC7WWV3DP670jSq1l+PLrhrE1QPOn3Xal1JT4Kwk
         kilLlZrheJ0JPJryCjhJdYp6h1pN1gBdAfyXtxtKUWA6kY2VaDn0C4ULgir5yOEvhMUV
         6MS2+DQp9Fw6TnHSVLWVw/LDQGLnX1a6mNjLkXlJQ2o2Qhds7WglAExC2+hHKn0PtLJN
         YiDDRS5PlnQL1fX6xdd9NExFRrIH5B+3Uj8MJ+a2oSCBqXgOvGsw57YQzyZZyaqegef1
         ro/BDEhMLSRCVhRag6IqBjkCsUq8O3JD5kKnlf0NxuN3xDBqawz19OTz7Ia2DCl9+Cy5
         l1Yw==
X-Gm-Message-State: AOAM531TmM2nLOekE7DKfExQ9L0hal91wCUHwAwbe+yrF2Nl/NtoPj5s
        Bq019K6hKOOnjeNPZlX9thwnuzGTK2I=
X-Google-Smtp-Source: ABdhPJxEb0WzDlkM5eEdXOiWxh/TeUkASyZXnS6r6rOBGdjFZlx+XsxWWD3ZJUR2+3NHZRrwkFtiuQ==
X-Received: by 2002:a05:6a00:234f:b0:3eb:3ffd:6da2 with SMTP id j15-20020a056a00234f00b003eb3ffd6da2mr55062168pfj.15.1637233744308;
        Thu, 18 Nov 2021 03:09:04 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id i184sm2845904pfe.15.2021.11.18.03.09.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:09:04 -0800 (PST)
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
Subject: [PATCH 10/15] KVM: X86: Skip allocating pae_root for vcpu->arch.guest_mmu when !tdp_enabled
Date:   Thu, 18 Nov 2021 19:08:09 +0800
Message-Id: <20211118110814.2568-11-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

It is never used.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f0035517450..e1fe8af874ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5501,6 +5501,10 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
+	/* vcpu->arch.guest_mmu isn't used when !tdp_enabled. */
+	if (!tdp_enabled && mmu == &vcpu->arch.guest_mmu)
+		return 0;
+
 	/*
 	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
 	 * while the PDP table is a per-vCPU construct that's allocated at MMU
-- 
2.19.1.6.gb485710b

