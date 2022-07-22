Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF70B57E9F5
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbiGVWoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbiGVWoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:44:17 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65274109C
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:16 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o21-20020a17090a9f9500b001f0574225faso4889008pjp.6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9G8uQUSZj7v4UHpXueicxg4z7HLUkR6M06BpV0pfE2A=;
        b=BtnvUGhXo8FNJq4+dboCuzzQEcIKDkhpSyiqC+p0WVx8OKcRagSaCHp/9pjiPqY6AP
         pf1HYAVxTgofQOGxjB+But51yclF6DiPs5ZXNb7/jNHy7xWldiLIDn1WMsOo5uwTHYC4
         DMk3wQckzpTtTEXC/sYuRcDmrpfX9IxbkQfovjSHSPkszIuS9/NnRNs6fyI1J/WEsmST
         i1n+sYALhVoOAM7IMsRyMWghXhfxM5YcHeNSZlePd+j7la3ou+X8gO5UVUXYg67Z5rJv
         kiWkF/jeKkHAWAKLcN04tv7ilK4g1A+f6e0tYlW8qaK/r28/p6ASChOVTTm5lM1ft+ul
         WGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9G8uQUSZj7v4UHpXueicxg4z7HLUkR6M06BpV0pfE2A=;
        b=Nlqy+8jVRJL8kDNKAyMJSK9ifg9ocKpXhRKZuXqbHCoPzx0UUjuloZV5xRYdQikx9D
         q5AlPHKpaCC0O5kOE7JcuGPygnRqnuJOAQ0YvC1bhpeFFXoneddDLpILukP8DJE7kgxZ
         DhWKZhF0mZwaN/HlFEBrqSts8mxpr2DP9Le4pI6JYCl261rwszP+tkqC4IMAy4e9KC/X
         RtGqqk4qPzsSItPSHykp9gBddQ/ZNOPhcXakqrpNDR6r+KotB4vrdwK4qveoKnIReQEX
         Lz1XT+n6Z/ArUc2+Y4HvS5Lbr8yM35d+UEjNACzP8JG/vJPqXTSBmU1var8McRI60NZ4
         1xmA==
X-Gm-Message-State: AJIora9BKXit969oM3JqEt5oErVozvewnW0uUfvIvTPPuMLDG+cQKrAE
        Rf6tfXH4kAgOl55Gn+X7UkEETFo6MxQ=
X-Google-Smtp-Source: AGRyM1t9GNt4LECENs25Ww0TbI0BikLZMmC5OL2xSEWkDJpJyBU/9b5VWWYWdt3pFiWl/1WiNvrBWE+bApg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab12:b0:16c:8d8a:c865 with SMTP id
 ik18-20020a170902ab1200b0016c8d8ac865mr1616901plb.145.1658529855990; Fri, 22
 Jul 2022 15:44:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jul 2022 22:44:06 +0000
In-Reply-To: <20220722224409.1336532-1-seanjc@google.com>
Message-Id: <20220722224409.1336532-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220722224409.1336532-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 2/5] KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved
 if there's no vPMU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Mark all MSR_CORE_PERF_GLOBAL_CTRL and MSR_CORE_PERF_GLOBAL_OVF_CTRL bits
as reserved if there is no guest vPMU.  The nVMX VM-Entry consistency
checks do not check for a valid vPMU prior to consuming the masks via
kvm_valid_perf_global_ctrl(), i.e. may incorrectly allow a non-zero mask
to be loaded via VM-Enter or VM-Exit (well, attempted to be loaded, the
actual MSR load will be rejected by intel_is_valid_msr()).

Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4bc098fbec31..6e355c5d2f40 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -527,6 +527,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
+	pmu->global_ctrl_mask = ~0ull;
+	pmu->global_ovf_ctrl_mask = ~0ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
-- 
2.37.1.359.gd136c6c3e2-goog

