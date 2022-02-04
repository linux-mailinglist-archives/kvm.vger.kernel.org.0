Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD04AA282
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245671AbiBDVmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244860AbiBDVmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:43 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F6FC061760
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:24 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id g21-20020a056a0023d500b004cc3a6556c5so3542050pfc.22
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NkV3Msgch3zFwH89OWlAlvxffB+RDhruYURC7hCf3XE=;
        b=Y/9PcR2wxtQOu8vrJPWbtGwHBJoxjOl0ybS/BDNdEgRXAAcUadz2lhRl4+mrbYu8Cq
         iYrTIUq55RsxkmwX6vHqW+RujwtmEWljWDjPtgnxdlrjxVTnZYmKMEZrOhpctN4jdpS4
         cMZ2IMBM1pHffQGgQh69ajLJZlrT2z1SRXag0OtSxHDXDH8W4eo0rQewi71Hso+oFlRf
         r20xgP7PRdiaDAeuCFWBDxmW/wwGm3seZ6eDfP6RYYG9x9jD4CpBRkfzdP8fcy5ThH5F
         odZCpjmtKlWAT+srUIYofAFvBWtvFlmin1xtRhDJZdwVZ1PWHVswKGjZcZhtcxtrHdKv
         4B7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NkV3Msgch3zFwH89OWlAlvxffB+RDhruYURC7hCf3XE=;
        b=eyY3s026Ky61k4CXY6NPFdHvZ3s4EAt/PGZxq7XQwouGFwL6q3IAMvBMw9B9LgOqAp
         RnKwrNvdQGokrpnNRpn1jabCeep4cgMPf7UYPQRsXmiTvSD8hFyBYQ/NzEzTKKeO68WC
         YcFUTGIleZ2OEgmzLg81C5R0tAKVLhcSLoX2/Tp6qSRQ7EK8eX3thDDU31ml97NHI26l
         dQSarP2rehvnusGDj+6n3++pYPgoGHrNHJMqvNn9FHvSDWuzz/qxHdccAlgYkiHWXi5J
         RY3fvbyHTnOK4lWvVzqXJhJfGx3YcGS5M0Wr6uOfGAJjXR6FtsmkNzQCiPz1KOSn5Q9u
         nTFg==
X-Gm-Message-State: AOAM530HxE0rJXjP7/Az56L+yqFVIdKZqUkSD2w2p1cSSCt4TH8RbkDl
        /mlVXsKb/bvyegQSLAHssgE+wLEAmiQ=
X-Google-Smtp-Source: ABdhPJyX6AXK89iDEI3/dyJx0hocA3ZoDVNZsc/XHIavHl7kK1gj+7CoUbQMAG404RCwBFkjlfEyjx/ZgVA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:7a42:: with SMTP id v63mr4994448pfc.61.1644010944420;
 Fri, 04 Feb 2022 13:42:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:42:04 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 10/11] KVM: x86: Make kvm_lapic_set_reg() a "private" xAPIC helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hide the lapic's "raw" write helper inside lapic.c to force non-APIC code
to go through proper helpers when modification the vAPIC state.  Keep the
read helper visible to outsiders for now, refactoring KVM to hide it too
is possible, it will just take more work to do so.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 10 ++++++++++
 arch/x86/kvm/lapic.h | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dd185367a62c..d60eb6251bed 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -68,6 +68,16 @@ static bool lapic_timer_advance_dynamic __read_mostly;
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 
+static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
+{
+	*((u32 *) (regs + reg_off)) = val;
+}
+
+static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
+{
+	__kvm_lapic_set_reg(apic->regs, reg_off, val);
+}
+
 static __always_inline u64 __kvm_lapic_get_reg64(char *regs, int reg)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index e39e7ec5c2b4..4e4f8a22754f 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -161,16 +161,6 @@ static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 	return __kvm_lapic_get_reg(apic->regs, reg_off);
 }
 
-static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
-{
-	*((u32 *) (regs + reg_off)) = val;
-}
-
-static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
-{
-	__kvm_lapic_set_reg(apic->regs, reg_off, val);
-}
-
 DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 
 static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
-- 
2.35.0.263.gb82422642f-goog

