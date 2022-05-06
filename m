Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558BF51D4FE
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 11:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390738AbiEFJwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 05:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242864AbiEFJwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 05:52:11 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E00323BE4;
        Fri,  6 May 2022 02:48:29 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d22so6889419plr.9;
        Fri, 06 May 2022 02:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=UlQ9fS0XFblBSDhDz8WGXl8//XRj+LMFbWdmJ5ZdaYA=;
        b=UIPpl2UeldmDHnpBs9VvwDTvnYeCCu8Ju5B7HQauUY6Zj2Sg8VuWYcw5DPx4Hlwjbd
         A3wykhqotE/ofFgSSUCZ/pvjckJ05spAr2ph/VSqfpuGDy/AGyF1IIal+z/IiOyiNjR+
         n8lX6TPlvpF3vmBHxOyanZZttb0VTLpgYS2V5BQKtZSh7ncx5iWzr2I7zRkmm/mwPIko
         yd4yiCkuJ2B9GKc0Xd2+8kwF/vS5aqSzOFgTqR98y/3n9lalK4yhfRH2ocf/IhjX25HQ
         +82x+dIf+gQTZ7Ro9Ak25ti3vd+G/7I2OpwwO1ToG0wk2unmFI/oxKh+jncLyKFxXmGx
         NMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UlQ9fS0XFblBSDhDz8WGXl8//XRj+LMFbWdmJ5ZdaYA=;
        b=eDOz8Wpxa+lpcb0nevnrao0DapPQnxQIHW1Jtm9Wf7w2mEs/sczj8ItHZg6/DoRvDl
         AMZQOCx8Ap7k/WBmdKHnW+fJEIx8Km+sxamZCjkil2EkBhdx+Eo2fwBuHSJgzNILWOel
         bbIzV8/nm6KgnOjUZVa6fpQUOCdNIQU2S1x1bugMznQkdb/rPUtZ4/ZLDMkp8r6mrIoP
         t8CkGxakriJK3XWPTK9ZROkAbQtXG/VQMBeAk9DxZO2VTMtvJDIpyq2GiOxm9vlVOZnV
         mJKXgDf5BeWuyLu8Vp4KnszlFAKKMVwvI4hTrlGVmPV9+s69xpa7VSrIU/dq6rXyHF9n
         6U3A==
X-Gm-Message-State: AOAM531Jnnt+CkVEgQiWJUVZFVoATOjkwD0bv3NpPynDZwF1orlV72da
        kyMa1ZXjD/Ib3oIn7GUjVFLFpfLv8BU=
X-Google-Smtp-Source: ABdhPJy/WIot2HAfxHlNdNRBXGMQmcEOB4QwkDJIVJrUejNXE2Cp7r47SJGyCxpai6eSYiUmGBrouA==
X-Received: by 2002:a17:902:a9ca:b0:15e:f017:91b5 with SMTP id b10-20020a170902a9ca00b0015ef01791b5mr962508plr.27.1651830508636;
        Fri, 06 May 2022 02:48:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.googlemail.com with ESMTPSA id w4-20020a17090aaf8400b001d5f22845bdsm1456284pjq.1.2022.05.06.02.48.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 02:48:28 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Narrow down the timer fastpath to tscdeadline timer
Date:   Fri,  6 May 2022 02:47:37 -0700
Message-Id: <1651830457-11284-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The original timer fastpath is developed for tscdeadline timer, however,
the apic timer periodic/oneshot mode which is emulated by vmx preemption
timer goes to preemption timer vmexit fastpath quietly, let's leave the 
complex recompute periodic timer's target expiration and restart apic 
timer to the slowpath vm-exit. Narrow down the timer fastpath to tscdeadline
timer mode.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   |  6 ++++++
 arch/x86/kvm/lapic.h   |  1 +
 arch/x86/kvm/vmx/vmx.c | 14 +++++++++++---
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 137c3a2f5180..3e6cb2bf56dc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2459,6 +2459,12 @@ static bool lapic_is_periodic(struct kvm_lapic *apic)
 	return apic_lvtt_period(apic);
 }
 
+bool lapic_is_tscdeadline(struct kvm_lapic *apic)
+{
+	return apic_lvtt_tscdeadline(apic);
+}
+EXPORT_SYMBOL_GPL(lapic_is_tscdeadline);
+
 int apic_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4e4f8a22754f..6e1b2f349237 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -241,6 +241,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu);
+bool lapic_is_tscdeadline(struct kvm_lapic *apic);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bb09fc9a7e55..2a8f4253df35 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5713,22 +5713,30 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
+static bool __handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!vmx->req_immediate_exit &&
 	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
 		kvm_lapic_expired_hv_timer(vcpu);
-		return EXIT_FASTPATH_REENTER_GUEST;
+		return true;
 	}
 
+	return false;
+}
+
+static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
+{
+	if (lapic_is_tscdeadline(vcpu->arch.apic) && __handle_preemption_timer(vcpu))
+		return EXIT_FASTPATH_REENTER_GUEST;
+
 	return EXIT_FASTPATH_NONE;
 }
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	handle_fastpath_preemption_timer(vcpu);
+	__handle_preemption_timer(vcpu);
 	return 1;
 }
 
-- 
2.25.1

