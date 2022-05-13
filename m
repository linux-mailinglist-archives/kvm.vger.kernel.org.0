Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9925E526923
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383280AbiEMSVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383298AbiEMSVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:21:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0016C377CB
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:06 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o7-20020a17090a0a0700b001d93c491131so6553690pjo.6
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XfAmxK+3Wufo+lA94S7B1fRFZl2NuslHkNmptVglJwY=;
        b=ZMmNOimu0QMae1KUZcdfFCA/34+mXbiZvlFh3hLG1+U6yZ8BzUBjH8l3iuTONqd/s5
         OO2UJWWkWrPWUEPNFA/EjVVQ9wZ55YzRaCK+yei2PSOwvtsQZD5BV5BT8QdzwKK7feIa
         TiQsc061iKA5erSwscoUV4CaI61Sk1j+AVkXl8/X3XK1u10g7gr2A0DlkgH9OQJck64s
         L/JtFSbPkPWYYJ8og9TYZDv9vubowimm+KDP+Ow+Da54rOcwbSl6SpSxLBqUolsKOtEV
         maxDEuq9/gJqa2oZ8ZfpcreCysZGpYTWz5kmz1P1HK1QKhA/x9L/7zGJaaWf8PBdtAb2
         ImLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XfAmxK+3Wufo+lA94S7B1fRFZl2NuslHkNmptVglJwY=;
        b=k6JnRe1LNb698t0Hdkgrd3f1iOtTCR+JO9qdSk3LY47MhjuqfdS1l3erxmm91Yp3LP
         Wgd1lMVIu+0Up5BcfV8pglwrfEHYml2S4nXcfhV8F+aCrfaKTHN7WjlNyyV8bi9t0a/D
         fNG864U5suJeg7AjoWsA56eUZnktoVLmxKGj3l/0QZD6aSLjQmawptiwrQb+3rPVDb0X
         Is1T2Tm28q2/BbnOHIynOAysMDLRTxUFODyHHaps8p2xl1cIwTP8hscenyzInLxwM46x
         RuWwVxdxF0bzsqY1RPzd/pWtvXLtROjX8oW0e/Uj7NDEV/l5AEpNeuoWXUUi1jvm6vWH
         ltDg==
X-Gm-Message-State: AOAM532JH4njuS46XKTnIap58AFWAEN6LxrUDXr6amk3E4aMSZd3r8fW
        wWPXdg3w08Xp0mVbnRpTxQicpauZ
X-Google-Smtp-Source: ABdhPJymE2hJDYpLTHUzWM5Wgi+FfgbY46/CMVPjG3HhVqfnzaaCaJ6CPiDbp8nuebqwHwt41Cm8cN3N
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:a17:903:230e:b0:15e:ce57:d66f with SMTP id
 d14-20020a170903230e00b0015ece57d66fmr5934570plh.35.1652466066461; Fri, 13
 May 2022 11:21:06 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:36 -0700
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
Message-Id: <20220513182038.2564643-6-juew@google.com>
Mime-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 5/7] KVM: x86: Use kcalloc to allocate the mce_banks array.
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

Update the array allocations to use the array allocation API: kcalloc.
This sets up pattern for future array allocations, e.g., mci_ctl2_banks.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb4029660bd9..2eaa6161b227 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11126,7 +11126,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
 
-	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks)
 		goto fail_free_pio_data;
-- 
2.36.0.550.gb090851708-goog

