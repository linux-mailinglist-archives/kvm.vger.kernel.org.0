Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D46F6FFD8F
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbjEKX7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbjEKX70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:59:26 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE34F7698
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:24 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-643a1fed384so4803156b3a.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683849564; x=1686441564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MEk4ljfjUrhYUrSteJqpKxRY6vJbyA6fFCK+rB7er/I=;
        b=ZTKfWcodlx+iAl7zxea0FMeNu6SZzfQ391F9NdQdcDalTF810JiIW+11fnDFvCxftW
         YOTk1GcXRemaIFDnJKfDJ/9ZIhmJ1DrnF7eQkl4olnIjpXECV+zr50SHuMQjl8aUvgZf
         V2fsmPRUBzHwTR28iFSim2t7wgW2DeJxeoZka9mF7A6lBburlYrEB+VUaTAW13EZVAUY
         I3HBUF6UkvWU1AI/DxsLzCDqlR8HVMF7IeVpF+zjpJdMHrOJQT9gAIhHybKb761iF4U5
         mvM430WKhXJFE/Yk9hCXHdfFvsdG422kHWf3cMn8wRH80p2g8sdw43iZxtoogclofmgg
         lQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683849564; x=1686441564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MEk4ljfjUrhYUrSteJqpKxRY6vJbyA6fFCK+rB7er/I=;
        b=hlsURKa442SL4sc/rBFydA/O86/9KG68LwvoQzTWpf9eVi8M/jDMZwz1fHRftcbhDK
         E6HjdYP42cu8ZfryHhn62qfATcm96krRDHnTGawBq+PzPiz4KE1SBb4MFU52yCVKt5Tm
         UO+39PGlY/8xUShr36tRukRvO7oXG73OV4wimaebUcGNzPZqzDeMDlbSgA8DKMeoG8QT
         +r41D0qOXDFRnnZ+uTw94PfmXWazgiWpN8XiTI17+yN/yB1Lwwx+7+T+h09DnpHe/r5c
         3Z+QaI0Inden6cm56ZSnsGKaAR6S/sYtBOEEX2qBo4V3MHPGssU8BPcRO40EyRqmOcWx
         IZPg==
X-Gm-Message-State: AC+VfDw9qTB61GvTXWPch+RlDe9UowJDoUhXEwyeRF/Q2+DX3Sc+46Sj
        OZqBoAtY6G3aewL5XrN1wsgL3amNMAE=
X-Google-Smtp-Source: ACHHUZ5l3rRuanjYbp1RV2ouAwFxf1cJNWLF+jyC0+yqQArFREl4t0+hRDySD9cYAS6UIzzTM7dmmv4jZPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2cf:b0:643:4b03:4930 with SMTP id
 b15-20020a056a0002cf00b006434b034930mr5941851pft.0.1683849564339; Thu, 11 May
 2023 16:59:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:59:11 -0700
In-Reply-To: <20230511235917.639770-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511235917.639770-4-seanjc@google.com>
Subject: [PATCH 3/9] KVM: x86/mmu: Delete the "dbg" module param
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
index f6918c0bb82d..2b65a62fb953 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -112,11 +112,6 @@ static int max_huge_page_level __read_mostly;
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
2.40.1.606.ga4b1b128d6-goog

