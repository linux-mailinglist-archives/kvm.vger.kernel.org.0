Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ADB5F5D78
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJFADp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJFADc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:03:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A754D86898
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:03:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i5-20020a170902c94500b0017c602e7f76so99233pla.22
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HjxVpgNXisyN9sBypn/hCSm/iZsV2/LVKlhCgT8b+e8=;
        b=ruN0AC6W5Ztqa0QvB1F8i1r7EWXxBLZ5OoV5I/k6Y4Ic+syMQaA/93QLmKYLpFi4YM
         A5IcyUYjjZOIlMTOhbgHarjZuWu3KLJPADE5VWXaY8jQclkz+aNPytfwX9GQqnfsi6Kj
         pSvIiq7iGC/g9neZ5cti6kDzITiSrDadAiEO2CGnm8Of/QQ+ZurndAsZJXF1SsoGcMrd
         fP39yW2WqsXq5bjVRB0sBKG5rLInvN6GiNveBfx8s334+K7+yhBDKNL5dXaBfrgZ/ki4
         MvI9NEJGxzhBUeIfHiZ24Z12/ghgrmB3wedHWEGGR6gKT/YF6is1Zs6p9XdQWaZeasoG
         CT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjxVpgNXisyN9sBypn/hCSm/iZsV2/LVKlhCgT8b+e8=;
        b=HVQG7CCArpolyu+iR9VYK94v+ldu22gDPYJOCfII9c8uHlSwnhvCrLDs+6Gh8Vda/R
         BgQAz5fWtmzQd7EoAGFTCkuWJtwRMvCKcHKHsIg3sxZYQspAoRQv4egQdpMEmMcB2h1m
         9XmoAQAlUyLNQ6LWaTkylEGhFru3b8iunNyNKb2Ls2okjGos0i0/KkkF1fXhbVE2pP6w
         nqmn8IcwcVE5orklACLWRLF2OxKLVZ0LkPqLnEKpV42xeT8lSo/rK+l1II7GrUAxSIq6
         3qaSa+7uGYVuN0GV4A7Nm8CEGQRMtGHKgoD0fx3mhDp91K94nEdJvHWOomcpVO4EC5dy
         qVYg==
X-Gm-Message-State: ACrzQf1urY4G0JjuhvIJf2uJm/8pk2l3FZJzyT3cp3qdms4+9pQWuFrF
        YJrdSI3ydt8PWVwSjm7hjujfNSR+wms=
X-Google-Smtp-Source: AMsMyM4N/Zl8uSic3XOrOHu86WdR+m/a+W1ikd/K0K7LrmvDvn4vJN9uYIRkwmvFZF0FGbswaXQnl8x2FlI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e545:b0:177:e335:9757 with SMTP id
 n5-20020a170902e54500b00177e3359757mr2036698plf.152.1665014604559; Wed, 05
 Oct 2022 17:03:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:03:10 +0000
In-Reply-To: <20221006000314.73240-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006000314.73240-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006000314.73240-5-seanjc@google.com>
Subject: [PATCH v5 4/8] KVM: VMX: Ignore guest CPUID for host userspace writes
 to DEBUGCTL
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore guest CPUID for host userspace writes to the DEBUGCTL MSR, KVM's
ABI is that setting CPUID vs. state can be done in any order, i.e. KVM
allows userspace to stuff MSRs prior to setting the guest's CPUID that
makes the new MSR "legal".

Keep the vmx_get_perf_capabilities() check for guest writes, even though
it's technically unnecessary since the vCPU's PERF_CAPABILITIES is
consulted when refreshing LBR support.  A future patch will clean up
vmx_get_perf_capabilities() to avoid the RDMSR on every call, at which
point the paranoia will incur no meaningful overhead.

Note, prior to vmx_get_perf_capabilities() checking that the host fully
supports LBRs via x86_perf_get_lbr(), KVM effectively relied on
intel_pmu_lbr_is_enabled() to guard against host userspace enabling LBRs
on platforms without full support.

Fixes: c646236344e9 ("KVM: vmx/pmu: Add PMU_CAP_LBR_FMT check when guest LBR is enabled")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 97fc873c37fa..e70ac91cd2fb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2021,16 +2021,16 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 	return (unsigned long)data;
 }
 
-static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
+static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 {
 	u64 debugctl = 0;
 
 	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
 		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
 	if ((vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT) &&
-	    intel_pmu_lbr_is_enabled(vcpu))
+	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
 	return debugctl;
@@ -2105,7 +2105,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_DEBUGCTLMSR: {
-		u64 invalid = data & ~vcpu_supported_debugctl(vcpu);
+		u64 invalid;
+
+		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
 		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
 			if (report_ignored_msrs)
 				vcpu_unimpl(vcpu, "%s: BTF|LBR in IA32_DEBUGCTLMSR 0x%llx, nop\n",
-- 
2.38.0.rc1.362.ged0d419d3c-goog

