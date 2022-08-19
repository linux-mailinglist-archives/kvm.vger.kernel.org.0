Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20C859A590
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350626AbiHSSXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 14:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349855AbiHSSXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 14:23:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D33EBCC11
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:23:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 130-20020a630088000000b004276c4c600fso2490510pga.9
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=q6KGI9Syk3DETLlMjkc4p6X3oD6H1Sce59yzAdrHv9I=;
        b=dYp8LmBpls9sKCojA7hC8ie4GaU/vb9ZQR5d5rfmpp8r5dvZVRu2Y3IdsP0Xet8c6s
         Elf52OrkccDJlui4irWLDP6KPCzV8rzKzAEP/Gi/4Jdu2eOf7xH0vxDqRPXgNbeXfYx8
         w+eUDBv1HC9X/6zMDOMdrWXhLX49Xs31oYUmQybGH3wZlHoxy7dI4WFHzZdDBwGJacDK
         mlosSMEqQuylU/LLOlNCaDpPCYsR6Y4Z4Q6hoNWaxWa8sFtBIpQ4rLmt4HpXKXhfT0PA
         sSveP90DLxiUTNRhKq2R0s8A4SJrSbDF5pk7sF89a77b07gzbv1ekR7sCMJU9Yd48/tN
         3GPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=q6KGI9Syk3DETLlMjkc4p6X3oD6H1Sce59yzAdrHv9I=;
        b=EhdK8mHcdjNAcer4yBl7H3Au8Fh0i5pPdNwhCRrNyM2ANPN/SuswSRbLmzweecX6cv
         uGDsAV4eX7JIdU6JfIWoaaMWwhGZxl2mqbrY+PjRt5dFD8zwdCnWjcGAFqfVRIogjZH+
         INlqYKMHPUKCFTBWN647aqJbSMTTXdkhmsWI2yfyV0UbIenQWz6DA7Wu2WnLTyXumF4m
         ecZPz1VcNIWmr8Yl4F5IQ5LxsANVhdpPKAwcUnBIfgKZu/vljB/gzL78JVY4mhFSqJnv
         HF098t5MrWIlDJY+H9xUoYC9K/GpmbieKDFDcQNQH2qINfGBR84hI/1+sy0/eaTt+fZQ
         Dvvw==
X-Gm-Message-State: ACgBeo0VRc/+RExbu8WiVeLwicOoc95/bn/ortLdai0U7zofQoqK1dGa
        47WYtdudYT3EtHRV2Ox44IFtmjcG8rQf
X-Google-Smtp-Source: AA6agR5BnOtXR7mbS2J4iyctv5Xrw2jkTvIDPsI52C3aKVCk8ttOa2n1F9D2pvLo9CAnflh0Gv0AuIvqMW5y
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:f92:b0:535:e39c:a6b4 with SMTP id
 ct18-20020a056a000f9200b00535e39ca6b4mr7429055pfb.46.1660933387036; Fri, 19
 Aug 2022 11:23:07 -0700 (PDT)
Date:   Fri, 19 Aug 2022 11:22:58 -0700
Message-Id: <20220819182258.588335-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] KVM: x86: Fix mce_banks memory leak on mci_ctl2_banks
 allocation failure
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

If mci_ctl2_banks allocation fails, kvm goes to fail_free_pio_data and
forgets about freeing mce_banks memory causing memory leak.

Individually check memory allocation status and free memory in the correct
order.

Fixes: 281b52780b57 ("KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.")
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..4b2c7a4f175f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11560,15 +11560,19 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.mce_banks)
+		goto fail_free_pio_data;
+
 	vcpu->arch.mci_ctl2_banks = kcalloc(KVM_MAX_MCE_BANKS, sizeof(u64),
 					    GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks || !vcpu->arch.mci_ctl2_banks)
-		goto fail_free_pio_data;
+	if (!vcpu->arch.mci_ctl2_banks)
+		goto fail_free_mce_banks;
+
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
 	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
 				GFP_KERNEL_ACCOUNT))
-		goto fail_free_mce_banks;
+		goto fail_free_mci_ctl2_banks;
 
 	if (!alloc_emulate_ctxt(vcpu))
 		goto free_wbinvd_dirty_mask;
@@ -11614,9 +11618,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 free_wbinvd_dirty_mask:
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
+fail_free_mci_ctl2_banks:
+	kfree(vcpu->arch.mci_ctl2_banks);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
-	kfree(vcpu->arch.mci_ctl2_banks);
 fail_free_pio_data:
 	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
-- 
2.37.1.595.g718a3a8f04-goog

