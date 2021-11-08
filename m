Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25AD447E82
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbhKHLNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhKHLNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:30 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95317C061570;
        Mon,  8 Nov 2021 03:10:46 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gt5so7851657pjb.1;
        Mon, 08 Nov 2021 03:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JP82EkUCeu5i/GWrbIV5dc8BYPvDb6Y+uomOO0EQbb0=;
        b=HjH9sVaUp0IjHSPOCOuflJQufc25qreVDuxILYP9HLslD4lRp1uoNzc4HbaeEa9bwF
         wFbwV2nHXGuWP9PGsW1JwqXxOI21trYrizvGt5t6awtFMLkdIgIIk9u+3pEprwtzRLDr
         C1UnCFNW+25YdjtEbZWRSTvTrAiwmwC1cdGJAPBCBENJEaoM7D4S3g84O9/zjdModpHw
         yI93Tpa8R2n+gUDBx/G30AoOU8Qp10DkHqzIZNHBtdJ/4gBQNFeIOfIDv49iLNOBAL5H
         xmi1d3nZwEm9hmpDj4YO7+cJVs35KCRd75ERFcU77MwBSyTc+QiEIO2UveP+i8SVPKa3
         6cMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JP82EkUCeu5i/GWrbIV5dc8BYPvDb6Y+uomOO0EQbb0=;
        b=nIfoV85srYJtzElj9kNziPHblRcfbKRXAAWAQ59p/yzpmSgDtcdybxMg5cUN01COnO
         eUOfFHE2Ds1CC82pmilhEif3Vh6GHyCIJwwb/RdFHM2upyLyMA148sFDAn760mAytcBM
         NPEc9y6Uyo/i26IBRQM6c8KsWxuEOOx7mSgMmUHAn/tQsAi1z6+yEaiS3X/yCKVGrhXW
         BLaAtYMRjWN6ZpT8DTAizVQ/QUnyIl6AtV5B1tbafbODudPIv8DZDiKlZcxPhD6B0TJ6
         X2pVV6l8rH7+jmxO45Wm7DuhrKAkre7JIdXNRCFbE5E4OEXOSUw6E7gGJ7kh9ykTS63M
         qeZQ==
X-Gm-Message-State: AOAM5332pGPNAuiuqQapWz3pvpD+5todNYQZP8HMbpl9Cqwtw6P1+gM7
        n4RJHb7bgyux+xTI9oU/3M3hYsxnpt4=
X-Google-Smtp-Source: ABdhPJzDOQSs0KSp2Hs0PVPaONtr815k3Mky5ZUgQZW8KpY6Gy4W1C4A1zeg6Jgx3RlTi0WQnItfbg==
X-Received: by 2002:a17:902:d491:b0:142:892d:a89 with SMTP id c17-20020a170902d49100b00142892d0a89mr1329047plg.20.1636369846200;
        Mon, 08 Nov 2021 03:10:46 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.10.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:10:45 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: x86: Export kvm_pmu_is_valid_msr() for nVMX
Date:   Mon,  8 Nov 2021 19:10:26 +0800
Message-Id: <20211108111032.24457-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108111032.24457-1-likexu@tencent.com>
References: <20211108111032.24457-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Let's export kvm_pmu_is_valid_msr() for nVMX,  instead of
exporting all kvm_pmu_ops for this one case. The reduced access
scope will help to optimize the kvm_x86_ops.pmu_ops stuff later.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c        | 1 +
 arch/x86/kvm/vmx/nested.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..aa6ac9c7aff2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -398,6 +398,7 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
 		kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, msr);
 }
+EXPORT_SYMBOL_GPL(kvm_pmu_is_valid_msr);
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b4ee5e9f9e20..6c6bc8b2072a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4796,7 +4796,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 		return;
 
 	vmx = to_vmx(vcpu);
-	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+	if (kvm_pmu_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
 		vmx->nested.msrs.entry_ctls_high |=
 				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 		vmx->nested.msrs.exit_ctls_high |=
-- 
2.33.0

