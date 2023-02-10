Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDE269157D
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjBJAcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjBJAcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:32:18 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FB26E883
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:03 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 72-20020a17090a0fce00b00233ac50238cso119785pjz.4
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lmrHsEd1kvbCEq2I68uT6iSRNvZfXrvkq6sDzsXiSd8=;
        b=eFeXbUZsLbfNmRG2IC3K5Td95hJyMIBDyhLJbX7KOnO7j9qBQs4ffh7MH+DTeFYR66
         GPxjZuzdYJs926CDgjuSJrEU4CZlAnm5YBPHzTt61cE605mDF0frD062wM7KlwwBlT5R
         oD2TMUDVjJy1Xs9xM0JOmDVSNaPLJj7wphE07o3YIeYrupB8gBOrRAKCEFErIyMXJBux
         s6tysAlHtj05f2QLU5bIke6dc1SeNxA5u+vZ6zppv5bzec2Cgae0Sk4Ttc3eMgkNWGMy
         UZt09U2thAEQDY52kwh0mv/0Ie1OwtkxyTfqTMmArhrrn68GXeX0glrtW8tPE1/Yc8fp
         bYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmrHsEd1kvbCEq2I68uT6iSRNvZfXrvkq6sDzsXiSd8=;
        b=qA8Zy3EyLtz0TQ+FHcgvgKoHvJ4wYzTpgeP03VjSpIn5OUKY/SXunCqoYDyz1YwJhr
         Q0xb2Adev/kUnACVj3cMZ8CXY0xK0/Wue7FQ9L93s5B7/A/HA3ac7jRosdjBD3ZC272h
         jAnIS8l9aqTzAyKyQtQDBc55AhoZvstklwkPerwWLuXh67dlsDTJbd5rhLJrdfcnrAci
         xmBP9gnL/uNu8A6dX4khsxqfeyhrwztsbR5p2P2QrNXb/8DDVv2egXYMJO2gw8AN4gPr
         u85XwN9Pvf7anhhLTnWu+sTbyDbresaucoJ47ifDhhoKYhrKWivxPNyEMXRV9jgii7cU
         kWhA==
X-Gm-Message-State: AO0yUKWo1sF9NItGBWUSTf2IiLrwJNk8AA8MR/A246sWa4LB+l12gv/j
        Gz1M4TsGpbg0oc5kiUZD2rSP7SNCbl4=
X-Google-Smtp-Source: AK7set+Eno6Q3VlOQChz82W6hjM+oLLJTWmqQOm0SDfFMxGRHgWSwmotAxFKANOUxU33bUR/beHmHd/TSyI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b346:0:b0:4df:c991:3a74 with SMTP id
 x6-20020a63b346000000b004dfc9913a74mr2450713pgt.94.1675989122972; Thu, 09 Feb
 2023 16:32:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:34 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-8-seanjc@google.com>
Subject: [PATCH v2 07/21] KVM: x86/pmu: Zero out LBR capabilities during PMU refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zero out the LBR capabilities during PMU refresh to avoid exposing LBRs
to the guest against userspace's wishes. If userspace modifies the
guest's CPUID model or invokes KVM_CAP_PMU_CAPABILITY to disable vPMU
after an initial KVM_SET_CPUID2, but before the first KVM_RUN, KVM will
retain the previous LBR info due to bailing before refreshing the LBR
descriptor.

Note, this is a very theoretical bug, there is no known use case where a
VMM would deliberately enable the vPMU via KVM_SET_CPUID2, and then later
disable the vPMU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..d889bb2a1de5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -531,6 +531,16 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
 
+	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
+
+	/*
+	 * Setting passthrough of LBR MSRs is done only in the VM-Entry loop,
+	 * and PMU refresh is disallowed after the vCPU has run, i.e. this code
+	 * should never be reached while KVM is passing through MSRs.
+	 */
+	if (KVM_BUG_ON(lbr_desc->msr_passthrough, vcpu->kvm))
+		return;
+
 	entry = kvm_find_cpuid_entry(vcpu, 0xa);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
 		return;
-- 
2.39.1.581.gbfd45094c4-goog

