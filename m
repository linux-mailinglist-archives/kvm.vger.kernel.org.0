Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B766B56F9
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjCKArL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjCKAqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:46:55 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3820613E0B2
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:35 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id b8-20020aa78708000000b005eaa50faa35so3693368pfo.20
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fG/gctdmsHG4KFmH0rDrimK5SXVIN8L7Kh/kR2GvG5A=;
        b=BCXSRihXjCF5gcpGEqZASI3X2u2m382eLGuNLXdp9s9FXaM2NnxlLaov/07yvpjiZI
         d5dc57wxslbohOAxK7jf/NKVwHIt6oyCqizaYjDuIEe518RQDeiCwgkRz6SEh1xibxxX
         ySlMYp/aC6gazQyrjwOT5yeD6v4xmZdy3az3oJlb3y4CK8bpbPOhydZ7ceuCu9o9Huz+
         WtTW8lcLsuNoak4HCLCQKkZsigrLQu+oQDdqSWBVFk+7C+frapYtH+PegbRXJIXk+q4c
         D7YI+dZaAvhESpu2jak5vyM8eTXpPHNXsdv1vtNYC6FHKPnU6WPGLLsvDasDULfj7KX9
         wtlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fG/gctdmsHG4KFmH0rDrimK5SXVIN8L7Kh/kR2GvG5A=;
        b=dcMJU5ULurmwIZxtvw5S9hOKesPTHsY+AhjCk0mN5ntlaIN9AABFgPwkqAP/hvg/HH
         k7BBVozYzabCMMdNWJYGl6aPmlSHkerIympsO/XAybeF3JbzCw23X53PZN+bTDGnnERs
         OFkCzf8AFb/b7AqV+6Q2OaaoDPpu4RXGRRGfq5tO1jfrwOpSiIL609qBohGPg1GBk0ye
         yfKDNThBs3/2i/VDruegtGxllPh+q603Qxp1wVuGKMxJsKhu8mOW0ibLVnn9WTsdjPnk
         7i65i/5DdXbcHvIMIFV48Jjqjn5pv6aLEkIZNSz1Vx8giU2PCAAZZXO3UD2fq5KAYMOz
         9NHA==
X-Gm-Message-State: AO0yUKXzve2C29TuTO//8ta2ddRpGL4cBIqzbbcxdsrXdAZZ6SvxLOva
        1hJ0N79Sx56u+LvXndy4vUgMPVaFX0c=
X-Google-Smtp-Source: AK7set/8k4ZuMdVVQdkcEV/wb/yLxhP6jK2ME2RuLadTBBF5FTif/SapvdPl8BOgE6/fCrXKesQjcqO3wpo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:8247:0:b0:5a8:bdd2:f99c with SMTP id
 w68-20020a628247000000b005a8bdd2f99cmr11215844pfd.1.1678495595379; Fri, 10
 Mar 2023 16:46:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:04 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-8-seanjc@google.com>
Subject: [PATCH v3 07/21] KVM: x86/pmu: WARN and bug the VM if PMU is
 refreshed after vCPU has run
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Now that KVM disallows changing feature MSRs, i.e. PERF_CAPABILITIES,
after running a vCPU, WARN and bug the VM if the PMU is refreshed after
the vCPU has run.

Note, KVM has disallowed CPUID updates after running a vCPU since commit
feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN"), i.e.
PERF_CAPABILITIES was the only remaining way to trigger a PMU refresh
after KVM_RUN.

Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c |  3 +++
 arch/x86/kvm/x86.c | 10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 612e6c70ce2e..7e974c4e61b0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -589,6 +589,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
+		return;
+
 	static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 219492cd887e..93a7302e4fc3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3625,9 +3625,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~kvm_caps.supported_perf_cap)
 			return 1;
 
+		/*
+		 * Note, this is not just a performance optimization!  KVM
+		 * disallows changing feature MSRs after the vCPU has run; PMU
+		 * refresh will bug the VM if called after the vCPU has run.
+		 */
+		if (vcpu->arch.perf_capabilities == data)
+			break;
+
 		vcpu->arch.perf_capabilities = data;
 		kvm_pmu_refresh(vcpu);
-		return 0;
+		break;
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
-- 
2.40.0.rc1.284.g88254d51c5-goog

