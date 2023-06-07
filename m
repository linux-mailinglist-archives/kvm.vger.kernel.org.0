Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13404725132
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240241AbjFGAnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239981AbjFGAnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:43:21 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EE519A0
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:43:19 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-568ae92e492so112176217b3.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686098599; x=1688690599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iWpx+RfSpqGCjC/645vo3rjaj4FpsSPwYJ169RAHthE=;
        b=pxetOLQocTqwrPnV3EV/w5idyhiG8XYmDrXsHQd2U14s8p5u2EVCgIgk+8I7dqiP93
         aOmgTbqkfnkFBItWeLUE9Ow9WgnuTiUuSudnCyfK99s4mHpzPT41YEILu+uZ1ZLpste+
         obA95rKvnjRhTB4EeAZMn5VWUGX/TQqhqGdwDSRbo4frz/xTu3GGfK1BVHyimWV/rUcT
         xhNPGlhvhL3IyT1I8eNtErpOoK1MozEEPby6B2okd253BCEY0Bsr/DBfGQLUwAGZ9ppT
         oB6J2x+3FOG/A80GYb6uAFqSmGu8sl8qGMxvFPDvQPdkNZFgFyBNgkuBGTxMZoSSDelM
         NEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686098599; x=1688690599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iWpx+RfSpqGCjC/645vo3rjaj4FpsSPwYJ169RAHthE=;
        b=WRG8FaC6uSNalPGF00Rgo1qQf7PIG40X9hbbOz3Jni5Bd77iMiCjMezWuqTRezTXEv
         MqKCGxGkvgON564pZpPHjTqefaEk9Yuk969T101ju9TWX/efC5d8234y7JHtNy8MLzXn
         WGobLLPjsoSu4ZmKAgLGYckaHZu0zcRdJcPh+K+6C7jEgExQC576LNULbVsXc/fECSlJ
         Lw38Oqj3/w26YdSvQ/SJL35BZ6n+7vbDGcBWE6dZusF+YrXopwg5YufMK8wbx0LkjVKT
         ay0Acjd+H/21+zsV6FERhcqxEMp49WFPPr1L/fZ4LvhnyZGJiIqPoXr3EcxvEEKAI6Ug
         KHNg==
X-Gm-Message-State: AC+VfDw2NaUApPsGQM2NdRdRgGkGojMx1/Ayew1dYIENaCEZcN64R+Xn
        LXwU8M14s79/S4TXnggoyWkhnyCwgsY=
X-Google-Smtp-Source: ACHHUZ6WDGc6dSyAYqCWbMICZuWNSAvkeozfOxaiyprE0dooA/9MBteFyjCTI2p5nz/KcLZhnd8fMUGpMOE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a7c3:0:b0:568:ee83:d87d with SMTP id
 e186-20020a81a7c3000000b00568ee83d87dmr1857439ywh.5.1686098599082; Tue, 06
 Jun 2023 17:43:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 17:43:10 -0700
In-Reply-To: <20230607004311.1420507-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607004311.1420507-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607004311.1420507-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available "cache"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
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

Now that KVM snapshots the host's MSR_IA32_ARCH_CAPABILITIES, drop the
similar snapshot/cache of whether or not KVM is allowed to manipulate
ARCH_CAPABILITIES.FB_CLEAR_CTRL.  The motivation for the cache was
presumably to avoid the RDMSR, e.g. boot_cpu_has_bug() is quite cheap, and
modifying the vCPU's MSR_IA32_ARCH_CAPABILITIES is an infrequent option
and a relatively slow path.

Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42d1148f933c..17003660138a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -237,9 +237,6 @@ static const struct {
 #define L1D_CACHE_ORDER 4
 static void *vmx_l1d_flush_pages;
 
-/* Control for disabling CPU Fill buffer clear */
-static bool __read_mostly vmx_fb_clear_ctrl_available;
-
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
 	struct page *page;
@@ -366,14 +363,6 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 	return sprintf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
 }
 
-static void vmx_setup_fb_clear_ctrl(void)
-{
-	if ((host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
-	    !boot_cpu_has_bug(X86_BUG_MDS) &&
-	    !boot_cpu_has_bug(X86_BUG_TAA))
-		vmx_fb_clear_ctrl_available = true;
-}
-
 static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
 {
 	u64 msr;
@@ -399,7 +388,9 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
 {
-	vmx->disable_fb_clear = vmx_fb_clear_ctrl_available;
+	vmx->disable_fb_clear = (host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
+				!boot_cpu_has_bug(X86_BUG_MDS) &&
+				!boot_cpu_has_bug(X86_BUG_TAA);
 
 	/*
 	 * If guest will not execute VERW, there is no need to set FB_CLEAR_DIS
@@ -8580,8 +8571,6 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_l1d_flush;
 
-	vmx_setup_fb_clear_ctrl();
-
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 
-- 
2.41.0.162.gfafddb0af9-goog

