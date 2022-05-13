Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1FB526920
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383271AbiEMSU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383008AbiEMSUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:20:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91B26D4D4
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:20:53 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x4-20020a1709028ec400b0015e84d42eaaso4730110plo.7
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xtyTGS4pN9ybEAH4kKSCBU2r0ngCJaIdQ+Oc4Z8dQHU=;
        b=URsFm5z4392YEJna5KHOtwJfvZyqav3vSK0UiujdEj+gecwcgQhtJfhZ6V/GDMnmf4
         Tu/1MhwBce319EgixWKOtEOia+wb5UERkDmYVBA1YLU28NlD3I5eBriQouQ3gXSjaq2p
         m83lV927reeHkSAIEIU73g8Og/Y1uavCP03veuGVm+5uYhdHaCnXZaAaXotwExdbuHRf
         6HMazZh7znilQxQYWfz5dnkot+Thi8+8+VXFvXovr0tPQtaT9LN5Q3WQTPrKURjTXXZg
         sZIEPbCKtbHY1VBOct4gffyzL9UCS7knxdgNau1ySHi9aY6G4O1R1kST7/r7Uc3B7csZ
         eVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xtyTGS4pN9ybEAH4kKSCBU2r0ngCJaIdQ+Oc4Z8dQHU=;
        b=6ovPg3KiKRuX1QcFlEORYoiZ+dI5jFDQoDv+G4XiwZsg9ZijLXG6PMai2LGr/67slR
         RFqabFmpvr4r+W4LNM5tK64DwShpJv26KP0viseg2bKiui19bk0ncv3WoLlUtguZgwJx
         P3ADMs8s1U9nCMGwSVey2arJbThIV9lUU3THpaiO2at3qmW/a6jGj8Ao/XlWKLuxFoGr
         WgD+vAbgqwTR8mi34ONq/bSUhP7CZr8t52Cy4mEPb+yxmAhjj0SEPj3/B0Zjq9tQnm4s
         hb7o5Nv64M4pE6NAsV26KXOYrFwCvobJCLMuMacAfEyZPkLetxyXYMUenq3aQbClKhBS
         xHGg==
X-Gm-Message-State: AOAM533fB41+CEogw+1bOT3Sw0YPA59ePMMOzAV5OjeIRKiW6gO3zrsi
        3FlRKZNFFeP7CvviJYwicXDK9sJr
X-Google-Smtp-Source: ABdhPJzlboT+MvR0HefPwdvKBIvabRSA+zz48AC3+X7z/akE5ogt9BQuutEzXVpq3tNchssXO352u3md
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP id
 d3-20020a17090a8d8300b001dd258c7c55mr249804pjo.1.1652466052590; Fri, 13 May
 2022 11:20:52 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:32 -0700
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
Message-Id: <20220513182038.2564643-2-juew@google.com>
Mime-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 1/7] KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
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

This series adds the Corrected Machine Check Interrupt (CMCI) and
Uncorrectable Error No Action required (UCNA) emulation to KVM. The
former is implemented as a LVT CMCI vector. The emulation of UCNA share
the MCE emulation infrastructure.

This is the first of 3 patches that clean up KVM APIC LVT logic.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9322e6340a74..73b94e312f97 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -54,7 +54,7 @@
 #define PRIo64 "o"
 
 /* 14 is the version for Xeon and Pentium 8.4.8*/
-#define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
+#define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 /* followed define is not in apicdef.h */
 #define MAX_APIC_VECTOR			256
@@ -367,7 +367,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION;
+	u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);
 
 	if (!lapic_in_kernel(vcpu))
 		return;
-- 
2.36.0.550.gb090851708-goog

