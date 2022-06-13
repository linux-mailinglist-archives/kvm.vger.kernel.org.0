Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1651354A258
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 00:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241482AbiFMW6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 18:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiFMW5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 18:57:36 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D3910E5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d125-20020a636883000000b003db5e24db27so4018423pgc.13
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dqOTd+rrEbe0Ho1KL+nrXG1TMVjZBcGq3Scgu3Hlczc=;
        b=G2vOugzu0HbRynHAIdfDvh7H6N8NAGp6OeQXZpZEPcoDoGxCjUfJtyrMb3Sup/4kFm
         UNEVjfAQsq1t27BPYIgf8RCWCi+Kl0Guq5Kaqyvj5Mp3Z5yiTWq1cFX3kk0m0Yo5MGZM
         OLllczkwvkBu2yDMqgQWndoHXH8PHXWQEKtSreWMXQc4uBTLX2YAOnUxIKr+f03kcCQw
         uFOQ6XzWTYeVn2eIKI8Gor8qkHvlybXEyCdJlgV5yjSekW3oBiCWRRwvh81U/BlPNR8R
         RrrZh7vfuqRkfsThIb8YazidnNzNDqp6XwpoE/MARqV0PlZdygplQfsvxUQZ7BVh7aRn
         VluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dqOTd+rrEbe0Ho1KL+nrXG1TMVjZBcGq3Scgu3Hlczc=;
        b=oYfPGfL6zd7qztO/VNFl2pS0GPoWFcgywGHxVUIs+jPwQ2Uak4POXkZgk7GPwDlGga
         GiEdDb4qODNTBcte0oWWQTR/tC1FIJMJexWmHl2DjInc6euNbGgImLRLxDejDIAatZ80
         HCaVppeg26ZND/a/+3KdQploCtHCza95lxqSG12H0hKNdx8Jg9467w/JVfixNLoHcWZ/
         P7pCCb54R+qs0K7vgqA/smvH9Xy8QeT4CFWPh5UFV1wtWmhmYKB9LphK9Yh8BXlnAqrc
         rWnHq/HMxterLBd4jjQwFNQIO/cbKHvckiWAkeFSLrcWOfNXb43Q83NBd+g73iJ3NAOW
         BvOA==
X-Gm-Message-State: AJIora+LXhI3qkT/xyUHMn84ILL5azD0wMXZImO3jcStozBrXYVbXUJ2
        c30BUuYUVAWmxt+6yUyigRW2w5UkEMs=
X-Google-Smtp-Source: AGRyM1s2pBEr39PeNzqKK5HLiCeXP22OWsE3v+YL7CLPBqUac5YpEvSaxDH40rsOJG+z5l0HV6tHa3Sk/h4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b909:b0:167:8c44:9bc1 with SMTP id
 bf9-20020a170902b90900b001678c449bc1mr1584462plb.47.1655161047715; Mon, 13
 Jun 2022 15:57:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 22:57:16 +0000
In-Reply-To: <20220613225723.2734132-1-seanjc@google.com>
Message-Id: <20220613225723.2734132-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 1/8] KVM: x86/mmu: Drop unused CMPXCHG macro from paging_tmpl.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Drop the CMPXCHG macro from paging_tmpl.h, it's no longer used now that
KVM uses a common uaccess helper to do 8-byte CMPXCHG.

Fixes: f122dfe44768 ("KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits")
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

