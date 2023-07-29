Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE72767A1F
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbjG2Atn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbjG2AtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:49:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D449049FA
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb98659f3cso18237305ad.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591663; x=1691196463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N+/CFCalnN5xPq+FJCMcppiU8/rhXPIN/0hig0msSo8=;
        b=BH/vnXUYOHXy6b1NYhugXlcJVFxpFBACy6MHTmpwAHEsFt0Tb+2O/PuTM8uyBWxsoQ
         cd5pWacOlW0dxtb4jtK1Afkp/SxeOcFxaSP0qJc57vUNjKs4X/qRNdaMreb7VlI+ErVC
         2rfrkdgt3VGWiDXrrjTxqMkVSfQLkMfdiVA16UsPo8d8xVWwu50tMwFGe4TMQquS5u7N
         HpNWkop5hN6b/L/CZilAtEUTmFhsYBWaPAkPDoTCqqjp3T6p6gv/vdQamw0Skme2wCHf
         yDn9ZEPPIsvPqarpWNphc+E34E3RjRHHRHoZgzlk4quBE7XtiCjjBXGnN4b047a43NX6
         CAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591663; x=1691196463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+/CFCalnN5xPq+FJCMcppiU8/rhXPIN/0hig0msSo8=;
        b=ZBmFRkj8InVk6ZR5Kce0X4CaediMDd3uasEeRdMG5A2asKEeM5x2NwJ8MNfqkBs1d+
         MnQMYErKe9OHPBdckak0Fpew+4Bg8A38CvkK/LNZE02Ki7qJsqgtYaW4XwcQM35oQ6tj
         H3+CniO8bpENQjWaB926x8D9FwF1NEcVEzkSwMxwJXIbgqvd/IT2oqUWEm4E8mQi+yFc
         O2qWFfmP20HcZRm4gXd4qdvBX2myqWNEC5c8u4Hf2tm2xhkFf91xvTqZHAE4VaH5VquG
         /WZ941VCt3aoqoEOQis11MXzfIIvP+PhhqBSItOFlJNnPIgl1YHz/Sy1lh9H43z3jyUh
         2WNg==
X-Gm-Message-State: ABy/qLZM8au7K28xOvdJZJ3YeA1mx96lfjtBXWxyZGtk1T9myzBmU8vG
        qwq8yKQxHhgICeFhWSrkfkf42e4jlbs=
X-Google-Smtp-Source: APBJJlHTx0tMhdVdj9DHQL2qIu5IwtD1zQZTL75hc9Ut9ZxNuNOuReykzid0E2yHjV5ekXl0GYuOIbK8/6k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e748:b0:1b5:61d3:dae5 with SMTP id
 p8-20020a170902e74800b001b561d3dae5mr14320plf.1.1690591663061; Fri, 28 Jul
 2023 17:47:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:20 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-11-seanjc@google.com>
Subject: [PATCH v3 10/12] KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for
 KVM_MMU_WARN_ON() stub
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use BUILD_BUG_ON_INVALID() instead of an empty do-while loop to stub out
KVM_MMU_WARN_ON() when CONFIG_KVM_PROVE_MMU=n, that way _some_ build
issues with the usage of KVM_MMU_WARN_ON() will be dected even if the
kernel is using the stubs, e.g. basic syntax errors will be detected.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 40e74db6a7d5..f1ef670058e5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -9,7 +9,7 @@
 #ifdef CONFIG_KVM_PROVE_MMU
 #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
 #else
-#define KVM_MMU_WARN_ON(x) do { } while (0)
+#define KVM_MMU_WARN_ON(x) BUILD_BUG_ON_INVALID(x)
 #endif
 
 /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
-- 
2.41.0.487.g6d72f3e995-goog

