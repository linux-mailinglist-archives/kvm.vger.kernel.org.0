Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7CC70E3B1
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 19:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbjEWQ4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 12:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjEWQ4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 12:56:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D437CC2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 09:56:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-564fb1018bcso57520257b3.0
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 09:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684861001; x=1687453001;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wrBhXdURti5dDN8ayuXGB0ofh5Nn3n6ogjtgMB2nW2Q=;
        b=Ipet8D8+ByimH4J0Yup7AfjiRNANkpz/sRtQDxkHat/bahvEYoS8gmEG+5SvYC/1P5
         a3Gt1GqyMyas8m2DUR8jNdOeVjEozG7mJ8b0FpV3xK4vdY2FW1zll8VQ9WTZpnx8KK96
         V8o7yNyKqoUq0JvtTqDMPlC2lQ9KE7MkOAjJOnrOLDCQBJeu382hvUwjbEl0omhYc70B
         0jOPclBKZDuIPzxBbVa6p5N34U0+/g81y/fBMppddz2NEvmAoAcdVx0Z3Kh+3t1AeGg2
         2SVWh4JSYEaSmlvIWLVfmxpMxRMey2K0vULQYfWcdfCOlfDucPH0EzILs16hEgQojH/B
         tX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684861001; x=1687453001;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wrBhXdURti5dDN8ayuXGB0ofh5Nn3n6ogjtgMB2nW2Q=;
        b=H1UOEnfT7gZn0CAH1hlEnGt+Wf1DLb+tsdAn6+jrlUYErd9zGhZfukslMRJkpFdozR
         oXVhumAK8Xvs9uHn1uo6ys5nxUmlGUXekfPxZ+BDx1rZFfmatQzxdfTA0+bt0rzTNzY/
         NDrlQboJAV8gR5Jx+YHGUZrEXqM/B8VVLOBsoC+AoHY20ifyMo0Wjq9NbPrfaB8Iz9xQ
         9QFyfDw0nhgXBt3vmwvyB6EDVENqwRd8g0pxrfBBOvCOuCtfykwRye5gdetmc60O4oAw
         BwwC1dnH5pbgeGugnIOoivfaTS8UjIOUr6gYd1rBUp3/fcsk9YjS1LfB+P27h3jvn5gg
         9wmw==
X-Gm-Message-State: AC+VfDzDOAHwE+P0Ba21K4WjZO6/41twzUuCXFROoELzaPK8yRjaYv6w
        9KXyjS2rDluUY2lKGpO5WGEO4kIMSb3Q
X-Google-Smtp-Source: ACHHUZ7zZMPI75T9CkUUAEFQYaJqKd4MnmRq2fA2kMT2h5naBwye5UXY+Z4MCIilxMLOtegZ6zbRAscuAMzd
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a81:440b:0:b0:565:2bb:6860 with SMTP id
 r11-20020a81440b000000b0056502bb6860mr4621180ywa.4.1684861001145; Tue, 23 May
 2023 09:56:41 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 23 May 2023 16:56:35 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523165635.4002711-1-mizhang@google.com>
Subject: [PATCH v2] KVM: SVM: Remove TSS reloading code after VMEXIT
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Michael Roth <Michael.Roth@amd.com>
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

Remove TSS reloading code after VMEXIT since upstream KVM after [1] has
already been using VMLOAD to load host segment state (including TSS).
Therefore, reload_tss() becomes redundant and could have been removed in
[1]. So fix it by removing remove reload_tss() and the relevant data field
tss_desc in svm_cpu_data as well as its data structure definition.

[1] Check the Fixes tag.

Fixes: e79b91bb3c91 ("KVM: SVM: use vmsave/vmload for saving/restoring additional host state")
Reported-by: Venkatesh Srinivas <venkateshs@google.com>
Suggested-by: Jim Mattson <jmattson@google.com>
Tested-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/svm.c | 24 ------------------------
 arch/x86/kvm/svm/svm.h |  1 -
 2 files changed, 25 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb308c9994f9..cfbe00360908 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -240,15 +240,6 @@ static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static unsigned long iopm_base;
 
-struct kvm_ldttss_desc {
-	u16 limit0;
-	u16 base0;
-	unsigned base1:8, type:5, dpl:2, p:1;
-	unsigned limit1:4, zero0:3, g:1, base2:8;
-	u32 base3;
-	u32 zero1;
-} __attribute__((packed));
-
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
 /*
@@ -584,7 +575,6 @@ static int svm_hardware_enable(void)
 
 	struct svm_cpu_data *sd;
 	uint64_t efer;
-	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
 
 	rdmsrl(MSR_EFER, efer);
@@ -597,9 +587,6 @@ static int svm_hardware_enable(void)
 	sd->next_asid = sd->max_asid + 1;
 	sd->min_asid = max_sev_asid + 1;
 
-	gdt = get_current_gdt_rw();
-	sd->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
-
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
 	wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
@@ -3453,14 +3440,6 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return svm_invoke_exit_handler(vcpu, exit_code);
 }
 
-static void reload_tss(struct kvm_vcpu *vcpu)
-{
-	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
-
-	sd->tss_desc->type = 9; /* available 32/64-bit TSS */
-	load_TR_desc();
-}
-
 static void pre_svm_run(struct kvm_vcpu *vcpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
@@ -4064,9 +4043,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
 
-	if (!sev_es_guest(vcpu->kvm))
-		reload_tss(vcpu);
-
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f44751dd8d5d..18af7e712a5a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -303,7 +303,6 @@ struct svm_cpu_data {
 	u32 max_asid;
 	u32 next_asid;
 	u32 min_asid;
-	struct kvm_ldttss_desc *tss_desc;
 
 	struct page *save_area;
 	unsigned long save_area_pa;

base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
-- 
2.40.1.698.g37aff9b760-goog

