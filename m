Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B4F59F1BC
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiHXDET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiHXDDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:37 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF15E82773
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f5960500bso269537027b3.14
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=XRDKW4kmbUxxML99G2x2cqmnCCslDq3EFu56tuStBew=;
        b=htzEhsuHTWnaS7lJlrCkCUlr5hOyBQ97QWU5JhZikwn1LPYRVNR4Sr4rIuYWsFk5Lq
         AWE+gpiZLJmtNw3g6Ld9PAmP1p8WYH7SKBZOzbLfVaFG5K01oa6+xS3iMqOORi9Yvq/n
         Qkqyz+sqXRJur+vkg2m5zuszgHYxvXJaNnBFswh02QMtjvbuYscHdFoHQfVePLzariHj
         qBXVAOWKJYMwEBZ7BRWnaPhE7xCI9wVFH4pvF8xP4t5flHl30/qgbYmSQmPIPmOm4g5d
         NnPdEYgXEtHbtK1cRiAtPpxxlTPO9D7MEYeJ9PCbpcqJmst506sjjXagEyZu9AY49Qsq
         5Eow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=XRDKW4kmbUxxML99G2x2cqmnCCslDq3EFu56tuStBew=;
        b=eUjHjG/C0+RrpTbff2cMDvnR+OEjJLlNMH7jS6hPy7uzAcRn9sOp6YzI9oGG6LWdcX
         BqSwtQJ5cyxeekmzTroUPUTPKr9cWp1ssAzbBAkMC9EiuSxOyWgvaUIXlZsE45dpHRd2
         lfo3ysbRxoan1HGXwMY/gh7bJg6YmDlBT6U+HNAiQPPItF9m+isOyEQIQOEqbGPQ3gaU
         2zrVhhQG0rkpMrPKmxFGRH+H03wkEqfK8+2LUaQiPxZh1faIXlc/tlsdrvJD80I/m4yl
         0WoAyb5+BN9Hr9D+2FM99FQUgrRwKUXsDjSe4j53brZIct+4FyhVm11/G2+RwVmr06JR
         aAbA==
X-Gm-Message-State: ACgBeo0NyKy3WN2ywwGmPbnHGWxhc6Q0UWLwPC6WyY+yc3cl77W+t+Pr
        OPVeV5vZWbWeA14/Wjxhg9TIIlodiPA=
X-Google-Smtp-Source: AA6agR6A0OVJFVib5uvT/h15YkUnE5V9nE9fPXy4AJaBmmXnnGdFV4pBcFf+g7Y4xKD1M0yispqqioawl/Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1989:0:b0:696:180d:89cb with SMTP id
 131-20020a251989000000b00696180d89cbmr1524400ybz.157.1661310133153; Tue, 23
 Aug 2022 20:02:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:21 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 19/36] KVM: VMX: Get rid of eVMCS specific VMX controls sanitization
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

With the updated eVMCSv1 definition, there's no known 'problematic'
controls which are exposed in VMX control MSRs but are not present in
eVMCSv1: all known Hyper-V versions either don't expose the new fields
by not setting bits in the VMX feature controls or support the new
eVMCS revision.

Get rid of VMX control MSRs filtering for KVM on Hyper-V.

Note: VMX control MSRs filtering for Hyper-V on KVM
(nested_evmcs_filter_control_msr()) stays as even the updated eVMCSv1
definition doesn't have all the features implemented by KVM and some
fields are still missing. Moreover, nested_evmcs_filter_control_msr()
has to support the original eVMCSv1 version when VMM wishes so.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/evmcs.c | 13 -------------
 arch/x86/kvm/vmx/evmcs.h |  1 -
 arch/x86/kvm/vmx/vmx.c   |  5 -----
 3 files changed, 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 38ec41939cab..2365e81cfc6e 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -322,19 +322,6 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 };
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
-#if IS_ENABLED(CONFIG_HYPERV)
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
-{
-	vmcs_conf->cpu_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
-	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
-	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
-	vmcs_conf->cpu_based_3rd_exec_ctrl = 0;
-
-	vmcs_conf->vmexit_ctrl &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
-	vmcs_conf->vmentry_ctrl &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
-}
-#endif
-
 bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
 {
 	struct hv_vp_assist_page assist_page;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index a2e21bdd17bb..33cd4623bb0b 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -215,7 +215,6 @@ static inline void evmcs_load(u64 phys_addr)
 	vp_ap->enlighten_vmentry = 1;
 }
 
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static inline void evmcs_write32(unsigned long field, u32 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 73f9074efc61..6b702c0085ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2762,11 +2762,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (enlightened_vmcs)
-		evmcs_sanitize_exec_ctrls(vmcs_conf);
-#endif
-
 	return 0;
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

