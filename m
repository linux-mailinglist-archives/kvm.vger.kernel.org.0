Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695B759F1C5
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbiHXDEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiHXDD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDED182D28
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:27 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id bf3-20020a17090b0b0300b001fb29d80046so3062207pjb.0
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=L2Wq13gaRR8SGt+1qw3vbwOKzk13HyPK66QgnJX9gh0=;
        b=s1LAurFkTI/9HlbNHPGYxau6vQzk1WNsYZA3RVQoIB7LjxNgju1RNlsuXbnTfS0Mco
         YKTWjkvmVKOgsQHvbh/V0MLPR3Jnluq7CiTe/xqAfwoihTwgleMZVCE8QGO8K3qV/vhY
         6KOZ8R0iS9WVBhVispevzWKzXorKeTK6W8f0BGcF3j66FJP7c79xM7qUQ9+PZwYlm6Xr
         KnVu5HlLcRtOtJq4lM74YFopgYJHEgs9m9RVMDvEoc9wXukGgC4ubZ0fejRqLKhe6lMW
         Vwzzbh2QGTlyK1/YobKB8ExGXJuiWSWtQuyVeK5Cea5DP6x+MhUm/W/UqxybsJn2KTQb
         5h3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=L2Wq13gaRR8SGt+1qw3vbwOKzk13HyPK66QgnJX9gh0=;
        b=MuQTZg8sROm71EZyXOCdBv6nKSVw231qrHFrfptQeyuLc1ANoqokZmvQJUrpGvkv4M
         I8MWR9X4AlhuK2ySpck3ZmjIDBWHRlqN3BUaDt/nLHRFMiRwxcP3D6aAmVBHPdlZv6H9
         v/EMAguiPHh6cEIqR524w1zGLEykNWE8QElrwCwcdMZsjtcKsl12JXGFVgk3TnbwmLUQ
         sSKujHp4+8MgoaYDhywH5bAUFr2yCqEJ/Z3hjR9civp1zRqUIPDq/PmMWUkH8IqmDYTX
         jeJ7tvlDz8AY9sYo3HRLpqcSSkw/BDc2aBmu92eb3Cq/fg+4ox2SKgC9y2X562fJly+f
         LRRg==
X-Gm-Message-State: ACgBeo1Rkb4UqQkPnMdvfXS3+nkZYwGIibZVdHI92yi8fR6RGGM6uJcL
        ckF4aq07QN7ULKf4GrOeIon9hkbvfs4=
X-Google-Smtp-Source: AA6agR7XpMAdEYvIchfhBTJtA4GWWplYvOLR0LrAx5Kry96M2oJKZ/Y6fzsfXMD+jd/ICCBI5HbTngTW6fY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2d0:b0:172:b63b:3a1e with SMTP id
 s16-20020a17090302d000b00172b63b3a1emr26056562plk.76.1661310147420; Tue, 23
 Aug 2022 20:02:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:30 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-29-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 28/36] KVM: VMX: Add missing VMEXIT controls to vmcs_config
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

As a preparation to reusing the result of setup_vmcs_config() in
nested VMX MSR setup, add the VMEXIT controls which KVM doesn't
use but supports for nVMX to KVM_OPT_VMX_VM_EXIT_CONTROLS and
filter them out in vmx_vmexit_ctrl().

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 arch/x86/kvm/vmx/vmx.h | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 23e237ad3956..079cc4835248 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4275,6 +4275,13 @@ static u32 vmx_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
 
+	/*
+	 * Not used by KVM and never set in vmcs01 or vmcs02, but emulated for
+	 * nested virtualization and thus allowed to be set in vmcs12.
+	 */
+	vmexit_ctrl &= ~(VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER |
+			 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER);
+
 	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3cfacf04be09..ce99704a37b7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -510,7 +510,10 @@ static inline u8 vmx_get_rvi(void)
 #endif
 #define KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS				\
 	      (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |			\
+	       VM_EXIT_SAVE_IA32_PAT |					\
 	       VM_EXIT_LOAD_IA32_PAT |					\
+	       VM_EXIT_SAVE_IA32_EFER |					\
+	       VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |			\
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-- 
2.37.1.595.g718a3a8f04-goog

