Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D0B54BE50
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbiFNXdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiFNXdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:33:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFB84CD56
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 92-20020a17090a09e500b001d917022847so4228334pjo.1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=F1mEM+Sk9NhfTo4twLztO1JRBfAv8ACvHFu9EdejiLQ=;
        b=VCGcEXx6TRJZH//+muwGLcl6V0jHbZuGFGc8YXZJ4kBFZP4jqYV6ZgfGDkNne2UzJK
         H1oNBWP5SHUxaD639jUs+Art971dPO2rn6nVQ+ODbYbTVvr+cuItW16sUj4mno2uNgge
         3OTQPpWcC4sTW2GpGb1WFdwD0FYHe+rWzviyvseevbydMKqgEKzkX9PcJ9H3867eDuRN
         wzjHY4wzhUmN2FPNsg8w44UL6uWY5t5R6nOnh5o3vnYOzkEJnbBuhz//WC1FvbTwrVoQ
         2nrMBYIL/QOxcNKUP5MANf4BwctetfiWipAPKw36djGRx5SmbiTkpbq8LPQm4e2kVur7
         J0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=F1mEM+Sk9NhfTo4twLztO1JRBfAv8ACvHFu9EdejiLQ=;
        b=hMCworTih/sJ8p1J3USapkjzbwaWfPOBQigZ5w2SVqRUaqWy1Cgvgv4MBSFVJ3nXPt
         VZtJKqWl2bUSpWfjK8nVmHBAQ6FHxIdRXBTM/kMz7io7zqCkCV6O0DyPgigYbsvI/WKV
         Cawv4EZZjKhLR+gBnezBR3cXUSGVOh0lTaOCATluhm875CTRZmYHRvoRKfHRyWHg2XrT
         QrQjI6HuhsZnnK2KSh35SeFv4ofqSDENPfzB74ULkj6fTFjEd+MpwGCu4UVu42K7oCdb
         MBCs09YsKeK9Mg1Bv8jINal7h8L5yk4HcOk7yJb29MlEN2eHcogwKjyi7YM43y6fwiYZ
         kq2g==
X-Gm-Message-State: AOAM531M4wxBgJvxoAudBpAJFUaenUbZdlcDrukMg7mLhZBkammjIRwz
        tIdFJeyyhTxidAaIUx+jdQZt+i2gDs8=
X-Google-Smtp-Source: ABdhPJwaYznr7aIlMCIFr+HBjFPK2thAUaXhCVe8WPr/90jqP0ecaVZ6zGrXdaKmd62aPfo843OWpII8UDE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1387:b0:51c:2712:7859 with SMTP id
 t7-20020a056a00138700b0051c27127859mr6973184pfg.38.1655249616263; Tue, 14 Jun
 2022 16:33:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:21 +0000
In-Reply-To: <20220614233328.3896033-1-seanjc@google.com>
Message-Id: <20220614233328.3896033-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220614233328.3896033-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 1/8] KVM: x86/mmu: Drop unused CMPXCHG macro from paging_tmpl.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Drop the CMPXCHG macro from paging_tmpl.h, it's no longer used now that
KVM uses a common uaccess helper to do 8-byte CMPXCHG.

Fixes: f122dfe44768 ("KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits")
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
[sean: drop only CMPXCHG, update changelog accordingly]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fe35d8fd3276..f595c4b8657f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -34,7 +34,6 @@
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
 	#ifdef CONFIG_X86_64
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
-	#define CMPXCHG "cmpxchgq"
 	#else
 	#define PT_MAX_FULL_LEVELS 2
 	#endif
@@ -51,7 +50,6 @@
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
-	#define CMPXCHG "cmpxchgl"
 #elif PTTYPE == PTTYPE_EPT
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
@@ -64,9 +62,6 @@
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.ad_disabled)
-	#ifdef CONFIG_X86_64
-	#define CMPXCHG "cmpxchgq"
-	#endif
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
 	#error Invalid PTTYPE value
@@ -1100,7 +1095,6 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 #undef PT_MAX_FULL_LEVELS
 #undef gpte_to_gfn
 #undef gpte_to_gfn_lvl
-#undef CMPXCHG
 #undef PT_GUEST_ACCESSED_MASK
 #undef PT_GUEST_DIRTY_MASK
 #undef PT_GUEST_DIRTY_SHIFT
-- 
2.36.1.476.g0c4daa206d-goog

