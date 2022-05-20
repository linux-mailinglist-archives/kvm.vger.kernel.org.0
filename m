Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989B552F1C2
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352289AbiETRg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345654AbiETRgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:36:50 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC1287202
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x16-20020a63f710000000b003f6082673afso4095130pgh.15
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uuOd9ok94EP/uvmfz9OLiHMjZtd/xYxJGu2lVm3MtUM=;
        b=scril5l+ZemMu34/UcQk1QtKakyvUafIXzF5bQCcgC6Hv+43k/2YYsJCXpBxRHk7xZ
         uMdlnJ0Kc8ZTMXf07VVIiFTglqdvfZLO8htdo1LU2t2CgnaUUBpgkar7CJGgv3ksyfqp
         p4W81waHFvq44aDEwxqIrBKuRHErXy9xvuCDsFJPgZXMGObRFGleQQt2H6KBNHRxU+F2
         6GcYKXOZFnQ8YBtI21ORZ4j9hxQJUaRTtVSIwPiaY2Y9Rh2YrEgQshkMWj6Wv9XdSyeF
         7b8BBSlNkWyQK3Ke186n0MqYm+r7TUdFGlKqmSym5oG/7xkFBdpT7wURyKQGx4+GCXYR
         30+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uuOd9ok94EP/uvmfz9OLiHMjZtd/xYxJGu2lVm3MtUM=;
        b=nxJ5vjQGYYcpy3sKid3XYPfIPuocUwo0hSCn3qqoxJQ7p71hYfvBaEARqP1+g+YzQ2
         uCnqAM/0Yx5v0MyJkeGik75FpTUvnfDgmcURubSwJjxSKhXdjudVysu0LwGuKfTGWUnS
         ZgpPvdHh83S+6XkFyPT/cYYo9vfAt1uCAu0ArUqiYkvX0GWugnZpKg6IHKri03yRk5/g
         4rVABxpDPxb/W9nBNrGS6b0CvYGsXvDMldgv2eiNUZQnkOrTECxOFaP7c7oB4TbgBazg
         vDVC0Ue0N13ZeiT0IVMGXr2ckmUzXWW5N6PvvwRgf7+DS4PSBWr4v4OHEKxhC6YJPf+H
         2P6A==
X-Gm-Message-State: AOAM533dyCqA/lvTWN069WMltHccvvLmX7/XU1w7JbWoMH/FCGSOk3eq
        Z60TmfoZNwAYrM461PvbqSgOVeSL
X-Google-Smtp-Source: ABdhPJztmp5xMuFrdfq5fX+gVIV59x2RLBsFj0VhBQK/E5O/8EEOJMg65srELGmOyYd6Yckcck4g+dfj
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a05:6a00:2310:b0:4fa:7eb1:e855 with SMTP id
 h16-20020a056a00231000b004fa7eb1e855mr11365191pfh.14.1653068208392; Fri, 20
 May 2022 10:36:48 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:33 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-4-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 3/8] KVM: x86: Add APIC_LVTx() macro.
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

To implement Corrected Machine Check Interrupt (CMCI) as an additional
LVT vector, the code needs to be able to calculate the APIC_LVTx register
offset based on the register indices in the lapic_lvt_entry enum which
will be used in all places looping through supported APIC_LVTx
registers.

APIC_LVTx macro is introduced for this purpose.

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
2.36.1.124.g0e6072fb45-goog

