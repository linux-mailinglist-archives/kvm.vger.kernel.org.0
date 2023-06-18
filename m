Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BBA734481
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 02:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbjFRAJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 20:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjFRAJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 20:09:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0F0170F
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-25efb82179dso41942a91.1
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687046961; x=1689638961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kxL2IQh8QsyzT6M8Esvdn0S5tsYGjEEcYbokMBIJOOA=;
        b=gMXMhYIhG2lW0SrPMUMr/jEaUXXnHOTAKNZtToKxzpFzIj9Y9m+1qXmo4dWsPoPvLr
         plVHnLbDVoL5nKbQ24qCLpgop2Mkxkv7z5E7x36gOXD9Dv/3IpNI29XczZ5e3dxJ9BP5
         Cs3tNz3R/gYemrR4La3CUU0Zn/VzUphnGNOjltb587gpzFz4xxs5CatONKNqj/b+sqYP
         wCO65H1ExzPgkkFj1vYdx6rCHjXIFdEOiqH5Bjg9KaAtsBFNSIVBwGspnXohbEd1i1Jp
         wmu+yRapRmaZ33Czkeh7p9/dDzsqGZ1fhQBD2GtD2OUTNCuohWlQWzkhxhJft5S+PZFv
         /L5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687046961; x=1689638961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kxL2IQh8QsyzT6M8Esvdn0S5tsYGjEEcYbokMBIJOOA=;
        b=knIH2DnQ28445LsTyCs04dQm8p+Ljtb3xz8EW/FGoLuAxrSAf0sIepTccAFOn3bTtS
         EOTo4Aj/UHkOpDdnk0ILpwOTr1k9EnT3MrrMtBy2bxCdQqPwYKhgFN/CfMCjXFjkSuAN
         QVQlfpoUSi9TVqX2tDnOyKHwDwv6tBTXVbRQVGSR038QodTl3Xw7UGG4sW+x3Le/SlQP
         Vf4R1jcXEb9HJ3n83+62sAVSqXhfr6vprfrKDROyuTCrOQfRiRk11u2SagW1MW8vrxgq
         aQyglYQaDos7+gqFdFINNeyeenYl8v1PE1P7wFE/SigQFMfBViVTLSyfS0YB3W9wuAMv
         9D4w==
X-Gm-Message-State: AC+VfDyzqG0Iq2i4ejstdLD26URGxBamHa+QHdrs+IET2ilsHYWxUcT8
        TbbjNp0XjBRshTz93BvNhbFVWDI1Ue3T
X-Google-Smtp-Source: ACHHUZ667rmHgnnVMFyiOS98UlXH2hDjVOn68VnJ+dNKWA2D/uGC0vcKPrekHRymKGd05CoJKmuP1cPxyqdg
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:1a15:b0:654:8eb9:4607 with SMTP id
 g21-20020a056a001a1500b006548eb94607mr1818385pfv.4.1687046960661; Sat, 17 Jun
 2023 17:09:20 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 18 Jun 2023 00:08:55 +0000
In-Reply-To: <20230618000856.1714902-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230618000856.1714902-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230618000856.1714902-6-mizhang@google.com>
Subject: [PATCH 5/6] KVM: Documentation: Add the missing mmu_valid_gen into kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add mmu_valid_gen into kvm_mmu_page description. mmu_valid_gen is used in
shadow MMU for fast zapping. Update the doc to reflect that.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 3dce2426ad6d..0dbdb7fb8cc6 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -208,6 +208,10 @@ Shadow pages contain the following information:
     The page is not backed by a guest page table, but its first entry
     points to one.  This is set if NPT uses 5-level page tables (host
     CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=1).
+  mmu_valid_gen:
+    Used by comparing against kvm->arch.mmu_valid_gen to check whether the
+    shadow page is obsolete thus a convenient variable for fast zapping.
+    Note that TDP MMU does not use mmu_valid_gen.
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
-- 
2.41.0.162.gfafddb0af9-goog

