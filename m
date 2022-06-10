Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A9546B89
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350147AbiFJRLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348867AbiFJRLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:11:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7C51F702C
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so23373100ybp.9
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t8ZIKMaZWd/kgq7//BTCVhDTNO2lmebl8XJJDz2uLBo=;
        b=JfLtdmdTiM0ARSn83d6s3o7mox9am5+5hj6HTfEjBn1hkwfdV76G8jKr/rsPI64tqi
         ZZQnL+Y+DIYC790yyLEF2r7gO8u8aTDdyvZRZacq3W/iqunPnzgMrTJx5xr/36KW87cP
         v285BScEE7fGBMypIUTKeZANngzZ9PYZf4ykyoWZZ6+MvOuOhPFDd+tMCnl7GCZ5Pt5a
         4Uk1v8Iv6SS6aTFfEhH4G5tz8rg5OpgcqNKn7KW7akYBvCS+7gF/0y8G4gbVzorafbs6
         5XNqpJ06ZV7wrQ5TeBb8cxOLHbonsgLZlTTo4Cqp5r7T1NMo+XIaySsiU+HjAGYB3kxj
         buVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t8ZIKMaZWd/kgq7//BTCVhDTNO2lmebl8XJJDz2uLBo=;
        b=tyJorsrC9MlMeRxOQHOX2lNDjMvoI7g9sSuusTyblVeYWSP3WS5I2An9eIXA0H31ZP
         4L5nZo3QR4JZ/ocB+ZDq2vMjwHzgPUa6x1zAOtm5pWZoR8xCrFOi7A5ngw6VF/GMmwzP
         /A+vs9AyrSwihEpkr6t+xWhCqZup3W+kzu611i3S0Ygqlq/S8EIgIwts6BcP7QB3m5Uc
         7Ovbjl4UphbRAOs9G2pMDWMiq2anE/8fNojWpC6SXZH/VxJ5ibX1HFbewKDqDMDI9c6C
         jt4TuIIfrAhiQVzDI+v2Mw5AuXEl6SWm/KziEXEwGR1KZzK3hHNN4r4Ztz3rgH2wt8aW
         mFAA==
X-Gm-Message-State: AOAM532Q3hXRHFGcucSR68K/pcYmwmNW5KyUSHqmQ2S/svyWLpV6e6+9
        n5Plk+0/j+AI4EC5mxAe2+m5uh2R
X-Google-Smtp-Source: ABdhPJw49VXYUi4Oh2250oRITyod15FGbC0thZ6tdLuhsm8dOx7eUa+ctxlzvR6wct5P3f9iaJIPjlkg
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a0d:e648:0:b0:30c:62ba:ae0c with SMTP id
 p69-20020a0de648000000b0030c62baae0cmr50240603ywe.56.1654881107681; Fri, 10
 Jun 2022 10:11:47 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:29 -0700
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Message-Id: <20220610171134.772566-4-juew@google.com>
Mime-Version: 1.0
References: <20220610171134.772566-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 3/8] KVM: x86: Add APIC_LVTx() macro.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
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

An APIC_LVTx macro is introduced to calcualte the APIC_LVTx register
offset based on the index in the lapic_lvt_entry enum. Later patches
will extend the APIC_LVTx macro to support the APIC_LVTCMCI register
in order to implement Corrected Machine Check Interrupt signaling.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 7 +++----
 arch/x86/kvm/lapic.h | 2 ++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73f5cd248a63..db12d2ef1aef 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2086,9 +2086,8 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			u32 lvt_val;
 
 			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
-				lvt_val = kvm_lapic_get_reg(apic,
-						       APIC_LVTT + 0x10 * i);
-				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
+				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
+				kvm_lapic_set_reg(apic, APIC_LVTx(i),
 					     lvt_val | APIC_LVT_MASKED);
 			}
 			apic_update_lvtt(apic);
@@ -2385,7 +2384,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_apic_set_version(apic->vcpu);
 
 	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
-		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
+		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
 	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_LINT0_REENABLED))
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4990793c2034..2d197ed0b8ce 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -39,6 +39,8 @@ enum lapic_lvt_entry {
 	KVM_APIC_MAX_NR_LVT_ENTRIES,
 };
 
+#define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
+
 struct kvm_timer {
 	struct hrtimer timer;
 	s64 period; 				/* unit: ns */
-- 
2.36.1.255.ge46751e96f-goog

