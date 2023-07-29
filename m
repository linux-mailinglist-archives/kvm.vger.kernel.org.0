Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB0B767A06
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbjG2AtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbjG2As4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:48:56 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552B849EE
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:23 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id 46e09a7af769-6bc6e6390fcso4675974a34.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591650; x=1691196450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8LvdkVE4wBNN35/JnHy3xytlSvey6H90m9oi4YFPLDo=;
        b=Xc76+6yvCGka7zXqrgagphiv30oVLLs/qSSA+I9HZuQQnkJiG+4uQMeqGskUEw7qOg
         mMN2Rixx7sMQK8fGN7SPXhO38QjA2hLMOnD+Plxz3CxOFo0UNqW8pUiMjlPs8n8FUbBA
         yl8xYlqquhCH6XqSTy8ocqobtZfbz2sgwc8u7sTPWcC8rPO0pgMrclkdtnUdEFceSWk+
         jH5xNuLI68LWJIUQBwwFkia9uG+ofyi0EGZb+/qHXpcEqsq1oPbFn3hESOVj40tH7USP
         5dbwgoPlGotJw1Vymep9GIa5oVDGAcI1rG1vXFwgeLSwHkxu6Du67wzoLc0CF0/6D1Oj
         1P3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591650; x=1691196450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8LvdkVE4wBNN35/JnHy3xytlSvey6H90m9oi4YFPLDo=;
        b=ebKf13yLMkdsz3/lJIN2Bk9mB3y1e/+PysRzyU2bNEjDADA3C9EIvk69Wk+11iK2q7
         2U7tI5l8N6JDjNdEzUzVUegMjA9qZPuI19q9LgpCFkZSCDahRwM8FDanvzW5b9rDtOHw
         DeQ3Vrm5Nr/7gcNAMhkAzTWMvG2zBe5IoRi26S9IpzObRw8pjQ559tTnsJjj3VxvVl6h
         XkkKLtlZt0VxfK1tBex/mqKN2NcnQRv6CVwEEs0F+uc1SR1qFjc3zmdNZ4DPTexGuwZo
         c1eojauvaifOCeUhmESzUDW0KKO3zZaRy/7dUVxYNLpjaeW7TUlaMZqRW4/pb+TcNQkh
         s++A==
X-Gm-Message-State: ABy/qLZirPAjUTqspnZ24CRsiVIAP6LNqT3kC6aR8dU8XktgW9E7pWmn
        8zUzdZ3nJoEVJR6uwKICcnqCmuESGs8=
X-Google-Smtp-Source: APBJJlEgEWe6CBtugf7jr5Pm8RXi3H/4jF3adEPPWz1+z90JK7zDxBgAu0zq+D5YTM9Rek+mDeqN8MvUUWU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6830:909:b0:6b7:528c:d8bf with SMTP id
 v9-20020a056830090900b006b7528cd8bfmr12891485ott.0.1690591650032; Fri, 28 Jul
 2023 17:47:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:13 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-4-seanjc@google.com>
Subject: [PATCH v3 03/12] KVM: x86/mmu: Delete the "dbg" module param
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

Delete KVM's "dbg" module param now that its usage in KVM is gone (it
used to guard pgprintk() and rmap_printk()).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 5 -----
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e36e07719bf..b16092d71d3f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -115,11 +115,6 @@ static int max_huge_page_level __read_mostly;
 static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
 
-#ifdef MMU_DEBUG
-bool dbg = 0;
-module_param(dbg, bool, 0644);
-#endif
-
 #define PTE_PREFETCH_NUM		8
 
 #include <trace/events/kvm.h>
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9c9dd9340c63..9ea80e4d463c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -9,8 +9,6 @@
 #undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
-extern bool dbg;
-
 #define MMU_WARN_ON(x) WARN_ON(x)
 #else
 #define MMU_WARN_ON(x) do { } while (0)
-- 
2.41.0.487.g6d72f3e995-goog

