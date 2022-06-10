Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DBD546B88
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350139AbiFJRLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346765AbiFJRLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:11:44 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC881CB701
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:43 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u10-20020a17090a1d4a00b001e862680928so8407091pju.9
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cVld20u0Ri71OEZrD0TbN7fRdrbZ7cH+/WFQAOuFvmc=;
        b=p8UavliYStH0snAphW652SgLdJHIPvObr5VOqDG9U/i847vGONsoQwKeYh6bg2gT7o
         7lKdtqtAqMokQdjSn+LlT9p2hBV8AMqzmlrpejm3YIizGKuBUXT3021KAAqXL46KB5o1
         nozPLeKXRyATwbNa6RQvwQcvxuE7EwT24uyIr6pHaArHFUyecQhlfYA/Mr87JJone9ac
         IbuYNpR8fNa9XRSWfVjdRouBEdxrDqj/dxUBq6mBSh9jIVuO06tilnSGVMgonqP6pJgC
         COxR+fCBEMufXg/NBfvXflrMC25CTl3pSF1c7t7/QL8cuB1pZNJmf+OO0tMK75uRGw0u
         y0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cVld20u0Ri71OEZrD0TbN7fRdrbZ7cH+/WFQAOuFvmc=;
        b=qNOLfGa98Wzzqyr7keKFcz7C/taUwuSPETg62HDDJPrNVTXf6ikJEUO8F+W7jTl6Tp
         H1c/OhewLKMOTk/IVPS3JNY/LUb9gSwGH7I579kKmY+UrkdQ2tXR230IqaMTiA5WO63o
         ImeVE0cYG6knS8jRsi2QeERfeEp8vhSg/+3CwAkxAMxCnisorQc2K9HAckiQlfKszc+c
         nFQmUq35fktSUcoAnjcF98lWPLCmYqQL376jTdJR5J3qUAux0OKMt3jdatxtYSK0NTxY
         cSDNiE90I3HiezOgNtOWQobH8yfBKCXBSoHG+ozg5uGVj18YLHCDmZ3RPZvLU/JxkN3p
         /qSw==
X-Gm-Message-State: AOAM530T5icHtcT32ivIFp2lDYN1faRd6SD8ovYLePJImLYZWa3cUlqK
        YGpFrqfQ2jdBh+DS/LGFLudpRtZt
X-Google-Smtp-Source: ABdhPJyvFWept3iQaH/ImQhZlD0+zVRm5PuEufL0koNbIH9N51P6iDRMxP+bxGK6elTRFs1nPDosdUf9
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a62:1dc7:0:b0:51b:a56e:35c3 with SMTP id
 d190-20020a621dc7000000b0051ba56e35c3mr52197479pfd.45.1654881102505; Fri, 10
 Jun 2022 10:11:42 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:27 -0700
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Message-Id: <20220610171134.772566-2-juew@google.com>
Mime-Version: 1.0
References: <20220610171134.772566-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 1/8] KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
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

Refactor APIC_VERSION so that the maximum number of LVT entries is
inserted at runtime rather than compile time. This will be used in a
subsequent commit to expose the LVT CMCI Register to VMs that support
Corrected Machine Check error counting/signaling
(IA32_MCG_CAP.MCG_CMCI_P=1).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..a5caa77e279f 100644
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
@@ -401,7 +401,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION;
+	u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);
 
 	if (!lapic_in_kernel(vcpu))
 		return;
-- 
2.36.1.255.ge46751e96f-goog

