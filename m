Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F7A372EA8
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhEDRSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhEDRSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372AFC061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:17:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o186-20020a2528c30000b02904f824478356so2062193ybo.4
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Mu+gEWNFD64rfAygjoRzLbXHjILdR4aSiYoIxX4BVaU=;
        b=vc6WfaDNhGXnxvzcIjsY5cNjkGyx7dmFjddNsCJRbyGdRPrl3THfl2KHLG8BUXv01Z
         NS/TtAghiP1EJwfN0gWaU4pT2Wyzko5S4/KXldiq7EKJKzM1g3b7qyn+DqsHSWtAmfss
         09AW1NzRufPSnjBL5eVsky5IxIr6t8562okUKZI1ldnSsZjp0WbGwzTO9iiJR01LmkQU
         dg9HlBwkuIB9I4JwcOWvTOnx1pDLH1/gRTMml5QGa8ZxxPvRKtFUB7ETic0tP8HKinKa
         Tgdat3v7IKJ7gr95sLIXPPIatl3gAVBLSALMyuUfBYgGRRxZpyv4K5hbLcp0+cuztjid
         V25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Mu+gEWNFD64rfAygjoRzLbXHjILdR4aSiYoIxX4BVaU=;
        b=bttYvU+5OIkr5ZYJEFBvuiTluh7k952CZPMxwMoWm/qBnYNVp6mDRTBOw8FqX2fHLK
         LRAN54cMg3Ihwa5BRTrs9n67ZUx5+Ku6FtzEfFYHVDfn/FtE6pIXXf3So/rvsbpuj8dr
         Ej0seRkfvOwQj145foUaClcVhhBsJxY15hBU4cgLSrEhVIQ/Z+GuEm+exb5BVmy0BRng
         nMsUmCNuueESuKS4iggW1fcq3Op1WU2J35lLCZ0DNQ6UqXWQGv9/BfgGMLqAjKYKYrok
         4A9BRRLauIUC8UV/8WqJVwRiHyq/XF8DXCeDkNhD6sZIbRE0/36qKTcGiPXZw1dHekOV
         hINQ==
X-Gm-Message-State: AOAM531ZCB5ect6jO1jKc9yuCfuK4BTjUE5AJYj2CX80KfDnRuRemvpr
        3uTN952Ld0gc1KDGhyPShIQ/9ryreqM=
X-Google-Smtp-Source: ABdhPJwlIQBBBVZtWF2iJlUZEqIfnqJVgYceDZL5CJzNPL1GoAgGUfkgW/iYbkTyzo7VpPPUFM1H019rjwk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:e6d4:: with SMTP id d203mr4165572ybh.226.1620148674458;
 Tue, 04 May 2021 10:17:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:24 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 05/15] KVM: VMX: Disable preemption when probing user return MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable preemption when probing a user return MSR via RDSMR/WRMSR.  If
the MSR holds a different value per logical CPU, the WRMSR could corrupt
the host's value if KVM is preempted between the RDMSR and WRMSR, and
then rescheduled on a different CPU.

Opportunistically land the helper in common x86, SVM will use the helper
in a future commit.

Fixes: 4be534102624 ("KVM: VMX: Initialize vmx->guest_msrs[] right after allocation")
Cc: stable@vger.kernel.org
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          |  5 +----
 arch/x86/kvm/x86.c              | 16 ++++++++++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e5fc80a35c8..a02c9bf3f7f1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1778,6 +1778,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long icr, int op_64_bit);
 
 void kvm_define_user_return_msr(unsigned index, u32 msr);
+int kvm_probe_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99591e523b47..990ee339a05f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6914,12 +6914,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
 		u32 index = vmx_uret_msrs_list[i];
-		u32 data_low, data_high;
 		int j = vmx->nr_uret_msrs;
 
-		if (rdmsr_safe(index, &data_low, &data_high) < 0)
-			continue;
-		if (wrmsr_safe(index, data_low, data_high) < 0)
+		if (kvm_probe_user_return_msr(index))
 			continue;
 
 		vmx->guest_uret_msrs[j].slot = i;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf52ba5f2bb..e304447be42d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -339,6 +339,22 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	}
 }
 
+int kvm_probe_user_return_msr(u32 msr)
+{
+	u64 val;
+	int ret;
+
+	preempt_disable();
+	ret = rdmsrl_safe(msr, &val);
+	if (ret)
+		goto out;
+	ret = wrmsrl_safe(msr, val);
+out:
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_probe_user_return_msr);
+
 void kvm_define_user_return_msr(unsigned slot, u32 msr)
 {
 	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);
-- 
2.31.1.527.g47e6f16901-goog

