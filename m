Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2E64F6F24
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiDGAZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiDGAZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:25:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408D21403E4
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:23:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id x3-20020a17090a6c0300b001cab7230b41so2505957pjj.9
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZbUSsGMzV8H0NtJ0T4RW76JlUTBQJ2VR2Gh74XZNDes=;
        b=r9m7XeURpO+lPEryjCJnCAUlYOnYN9vudzJsuUK3i1MIVsIIo7aQ/atNtp7ojtzDVO
         VdA2+tKPfuA6IHudvGKlKRxwHCN/k7wtfrgyMLzFo4m0HGSsBb9aGQRLuGFDhuhkDEQE
         ZIfhvB0799LsFLVE4FDwY7dHEy4HLA+g99nfabikM75kprPZb/6b/ct4tl9JDmkNL1Kc
         Uhg3rihsc1cncV1S2eO96LGftXcXesoRnWp5Z/6GC8/qy+dd0IC68xQ/LfHJoDx4nvlP
         O/uGrUBo4wfOxmKnl9yRvHFvokPxkrRpIg71ycUsYqK8zthF6HD6BgsoWgpdOC+U7+S/
         6qOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZbUSsGMzV8H0NtJ0T4RW76JlUTBQJ2VR2Gh74XZNDes=;
        b=XSDOo7O8GjieyeGY3H82zdENEoomfyLmZCB3FooBwXtTWeMmJmvqodIVEfVHsTFHds
         DXF4GUIL6qiJFhRGwIrFMCwQaos/3sR4anH1iLuGwJu8mL3NYgb8ekjE9b6TaUGx7ZTG
         YVz85dMHl/ISbFUvUvD/LANvSRVrQccWJskDTYQz05N5HeaTMp5KKcHtwcrd53HYloQi
         l1WkgEp3fwOymI4v2qqjfoFqJtmua/+FvGSIYBe0T+bHJHfkUzWshyoCY64wbBIQenHG
         7PLxrL8fBQAHofcIwH69YeuQe0E8ZDuML2KfV2Z5D79KPJ3E/CAbh+9Kdq2FphzffyWh
         838w==
X-Gm-Message-State: AOAM533etIZSX8pXHx3VtRe3X8sDLDmlcA5I7Wv8mI+V31BvrMKxLVue
        eAi/kcX2UrfYwcd0LcraXVcOXp7H6vw=
X-Google-Smtp-Source: ABdhPJxiLGPzvE6WAPK+V8aUxaldQBesrWzqA9qWB9kSrQPvuWMth062nPMk9y1MCo4qWh16tJ3u/67eDnQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8ec3:b0:155:ff17:fb7 with SMTP id
 x3-20020a1709028ec300b00155ff170fb7mr11125640plo.135.1649291001671; Wed, 06
 Apr 2022 17:23:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  7 Apr 2022 00:23:14 +0000
In-Reply-To: <20220407002315.78092-1-seanjc@google.com>
Message-Id: <20220407002315.78092-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220407002315.78092-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 2/3] KVM: nVMX: Leave most VM-Exit info fields unmodified on
 failed VM-Entry
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't modify vmcs12 exit fields except EXIT_REASON and EXIT_QUALIFICATION
when performing a nested VM-Exit due to failed VM-Entry.  Per the SDM,
only the two aformentioned fields are filled and "All other VM-exit
information fields are unmodified".

Fixes: 4704d0befb07 ("KVM: nVMX: Exiting from L2 to L1")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ec4cbf583921..9a4938955bad 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4198,12 +4198,12 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (to_vmx(vcpu)->exit_reason.enclave_mode)
 		vmcs12->vm_exit_reason |= VMX_EXIT_REASONS_SGX_ENCLAVE_MODE;
 	vmcs12->exit_qualification = exit_qualification;
-	vmcs12->vm_exit_intr_info = exit_intr_info;
-
-	vmcs12->idt_vectoring_info_field = 0;
-	vmcs12->vm_exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-	vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 
+	/*
+	 * On VM-Exit due to a failed VM-Entry, the VMCS isn't marked launched
+	 * and only EXIT_REASON and EXIT_QUALIFICATION are updated, all other
+	 * exit info fields are unmodified.
+	 */
 	if (!(vmcs12->vm_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY)) {
 		vmcs12->launch_state = 1;
 
@@ -4215,8 +4215,13 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		 * Transfer the event that L0 or L1 may wanted to inject into
 		 * L2 to IDT_VECTORING_INFO_FIELD.
 		 */
+		vmcs12->idt_vectoring_info_field = 0;
 		vmcs12_save_pending_event(vcpu, vmcs12);
 
+		vmcs12->vm_exit_intr_info = exit_intr_info;
+		vmcs12->vm_exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+
 		/*
 		 * According to spec, there's no need to store the guest's
 		 * MSRs if the exit is due to a VM-entry failure that occurs
-- 
2.35.1.1094.g7c7d902a7c-goog

