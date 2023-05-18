Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77810708663
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 19:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjERRHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjERRG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 13:06:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CACB9F
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:06:57 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-51b67183546so1330634a12.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684429616; x=1687021616;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ha8ZfG9WtE0dPySJ/+ise1++4XlMqEuz3CNRHMvVR+0=;
        b=qzfeyf3TraFs/hFscOCnvXugA2E4VTI4Q3PHtq6vDUuGOQTnPx0hInkmMb/PjG8OJy
         VYXZVZ2B22J/881K+e94rxIdxhhTyhktiCwSCM1sFJ4dsorZa2Jlmdh8gYktLew/WF2s
         PuEoOPbZucxfKL2YafxmKGa/X1AhHnJwdjdBDZuV7HXFnsORktauKpaA2t8e52hVYA4+
         gINZm4lxoMVTva2NXkus25VId9dRJLkLDhg+hZ5L66aQ2WZOPr5ydekR0H40s3Ilx1jS
         9o35oqjQbu1R9jDkBUhlhMjMS7l3zszK+JyY9zz+T45hWhOHvD64X7SIywIqib/WPnGp
         jNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684429616; x=1687021616;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ha8ZfG9WtE0dPySJ/+ise1++4XlMqEuz3CNRHMvVR+0=;
        b=PYOzbDDN37AtSMCKHufyNcEoOhcTrB2XSClmqh+cQUYYFcMWJH0t42rBT3lxDOJr/+
         pION8eYbsumN+ZEqVb6aojKICnD0SuRL3I5PnAPBIFrvfKoTeR7ybriz0FJiHUl0HxkI
         sS59jTfFgrub1t5AtnNf31bqJcO37zd9oDy/Wrdc8v+VbC9MeKAMiXJ772SSYKPGr7jX
         HW+K3MW6yppBkwsTiNMaNyCXkL/FThvY2ShlCfU67yQc+mRnO+PDFDRido8WQ296Ljvf
         27lBCEO5CvZ3mZKFrmAWcU5vaKJgjukwBFpdvnL9lOT84/eSgSXlC+cAxYxoDJfUdyx3
         8xpQ==
X-Gm-Message-State: AC+VfDzPRLlx9EhIJPwC7lLT4ddJnwUYX9tRDHRShE+ySl9zWk2IABKa
        Xe0idvoSoVD1XgUS+bRJhfML76oo7F+3
X-Google-Smtp-Source: ACHHUZ6Nhs9hYjvqI0OzmsHnESW8H7QtDtj6cOsbr3W+Idrd7doJnSDv0w619W1QPkBe0REMD4M+wzeAK7+z
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:465e:0:b0:52c:4227:aa61 with SMTP id
 v30-20020a63465e000000b0052c4227aa61mr479850pgk.6.1684429616582; Thu, 18 May
 2023 10:06:56 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Thu, 18 May 2023 17:06:53 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230518170653.704562-1-mizhang@google.com>
Subject: [PATCH] KVM: SVM: Remove TSS reloading code after VMEXIT
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Remove TSS reloading code after VMEXIT since upstream KVM after [1] has
already been using VMLOAD to load host segment state (including TSS).
Therefore, reload_tss() becomes redundant. Because of that, also remove the
relevant data field tss_desc in svm_cpu_data as well as its data structure
definition.

[1] commit e79b91bb3c91 ("KVM: SVM: use vmsave/vmload for saving/restoring additionalhost state")

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
-- 
2.40.1.698.g37aff9b760-goog

