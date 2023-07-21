Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C90775D7C0
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjGUXAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjGUXA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:00:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3805B3C0B
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b896096287so21593265ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689980423; x=1690585223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N+/CFCalnN5xPq+FJCMcppiU8/rhXPIN/0hig0msSo8=;
        b=O+6lv7D05Q0OUUA9ynt/KcA/czw0nVCmbf+DG+BCK0K9Z7aCmw2tgEyYalVuedspq8
         piJatN1AxWJYSYEWXCgEWV6Lj9WRMaYOQpNFZf/D6YxBGvXXC9sxFeWVnYSsh9PgdALK
         TI08rE9tC6B2sbC+Jjczj0KDs710pw7/X1Q1ffZt9W4t0WnhvXUr1aVaNL8cXazRCmS1
         C0EhZctoNOm/7wdzAXrff4qAVIbwy2Z8bb+Wn7hr5Vao+gofADZJgTNphVeN4r5pIW46
         fLax9V/1g5GZUDnUccR06p1tDp+XdU1R4e6QA1byPUciyCipHt9n184iwnlMoLNkuP/D
         gFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689980423; x=1690585223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+/CFCalnN5xPq+FJCMcppiU8/rhXPIN/0hig0msSo8=;
        b=lFMuvfTYyZrZ8aW6nMCRgdfAVcCQ7I0FdySZGhfs3OoiSQMz90Kw2fHc3TBFBhlqo0
         DXw0pGH93C+MvGoKRVEciWnk7e0s396kdBIm/9Ls3vzNxWK1cmGo/gwQ6jqlFRnJyrxt
         /44AKZzBJtZLIAdCAN5YWHxNQvyNyYTM62ZWtmG3zZ1LBodlggj7+N2FeRPpQ41Tz7I1
         VlcVOemsWSNCzv7FsELSvmc3vaiygG/TPurj5Jvvx82SbrMFMcuTCU6J6KTGPVZiyNxP
         wYJNeNoX10UG7+XH66+RrSvbrgUJI+JAMWuaL5/RZWy2NRSKIISWeO4xUmkoACKPJfuD
         /28w==
X-Gm-Message-State: ABy/qLaCU5Gp1Iz2HL18D8fhgclpBoyMx5y0tK4+jT6Ks0z8m6YgVgM+
        p30Q92cCMbXprXTSG3gKumEA9huuN2Y=
X-Google-Smtp-Source: APBJJlEdgoY2p3pkiIdjBOcg3jw3MqxAMwsO+nZ04BO6YA4qb9EUQT+jbdKrNSLS86YvWP/CqI58RihYbdk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74a:b0:1b8:b7fc:9aa1 with SMTP id
 p10-20020a170902e74a00b001b8b7fc9aa1mr13677plf.1.1689980423625; Fri, 21 Jul
 2023 16:00:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 16:00:04 -0700
In-Reply-To: <20230721230006.2337941-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721230006.2337941-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721230006.2337941-8-seanjc@google.com>
Subject: [PATCH v2 7/9] KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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

