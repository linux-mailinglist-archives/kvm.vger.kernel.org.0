Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F4A568C10
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiGFPAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiGFPAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:00:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF11425C4B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:00:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b2-20020a170903228200b0016bf00c3360so3279931plh.19
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mPm5f49DTk2e9v+311LOTHt6aH9oWOqMIbxfLkcqgGU=;
        b=AxTREYH+Td3fUZIjWr1uJk7JWfd6KqVXxBjjpsR6G61T8iykvdGT4sl0q6qrmVUCoZ
         9B7gbUj2sjoTrBkiYHoycVSBuJmV5rVXPEGP6TBWBeWophXhjBTDaIKGYvskp3BzFMcM
         l6v79Ct7MunBI94LOUG0XH6TdblPINctt6kC764wVXnyn/EFwGsIqoUSVv18H8aCsKjJ
         WLw+doGystwwbMaSclZljRHTXOr9dx5AiyZurarX4fKRMEwF8AbXz/cD9Rz4uQiajWuS
         jErMsq41DKmaDAiWRZMf1geC5OtCsfVWoiV3m2buQVYZvKY2uer0I+hS32t4eM2HeWOn
         yNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mPm5f49DTk2e9v+311LOTHt6aH9oWOqMIbxfLkcqgGU=;
        b=DBfVPQASsd8kidKhZU6f57L1KDwbhyE84az2TlBAJ1+9i1Nn4ZUZR1tW1O9B++O31d
         di3nR50MHAmXVhvMAMSKHizHvE5f3M7mm/UPTCi/OhPdQtggTt/cehxlYrkOm1pqrI5K
         PtFbsdBSViZLHmqjBrRsK4RNiMTrEE6ksZKaDYOlCzkLAbPTnXJQBbVZty2euYlarE8W
         4O8somroBZvKA7ANbdcKSBjRUC5XNkeLWXmuyzBzgXvgoj6fvNhalfE+N5yKkSduWKDY
         HyW6CXsoERPxQgzX+5nqePoPlW84A5NKHxluDuEhXflmaYm0Rv5Li0UNcUn/U6hk/++9
         BGBQ==
X-Gm-Message-State: AJIora+x032AHyxeS3RVpHGIVddbiJwo91bU+rDn+aRxcMnGIhbJfzVr
        w3rCqLEse/5jeN2+MUXrOY50Zvx5
X-Google-Smtp-Source: AGRyM1vtI07JBLNQ+fVcgeFE9FRKIS9SfLhqmVW1I395Qt9I+fWufX+KypmYY3VZz85QVpZdR6gLQPLt
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:2e3c:7c6b:b9e8:661])
 (user=juew job=sendgmr) by 2002:a17:90b:181:b0:1ef:c348:6835 with SMTP id
 t1-20020a17090b018100b001efc3486835mr13075pjs.1.1657119605067; Wed, 06 Jul
 2022 08:00:05 -0700 (PDT)
Date:   Wed,  6 Jul 2022 07:59:57 -0700
In-Reply-To: <20220706145957.32156-1-juew@google.com>
Message-Id: <20220706145957.32156-2-juew@google.com>
Mime-Version: 1.0
References: <20220706145957.32156-1-juew@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2 2/2] KVM: x86: Fix access to vcpu->arch.apic when the
 irqchip is not in kernel
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Siddh Raman Pant <code@siddh.me>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
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

Fix an access to vcpu->arch.apic when KVM_X86_SETUP_MCE is called
without KVM_CREATE_IRQCHIP called or KVM_CAP_SPLIT_IRQCHIP is
enabled.

Reported-by: https://syzkaller.appspot.com/bug?id=10b9b238e087a6c9bef2cc48bee2375f58fabbfc

Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4322a1365f74..5913f90ec3f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4820,8 +4820,9 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		if (mcg_cap & MCG_CMCI_P)
 			vcpu->arch.mci_ctl2_banks[bank] = 0;
 	}
-	vcpu->arch.apic->nr_lvt_entries =
-		KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
+	if (lapic_in_kernel(vcpu))
+		vcpu->arch.apic->nr_lvt_entries =
+			KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
 
 	static_call(kvm_x86_setup_mce)(vcpu);
 out:
-- 
2.37.0.rc0.161.g10f37bed90-goog

