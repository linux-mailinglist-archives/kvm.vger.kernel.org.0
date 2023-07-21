Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC675D7BF
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjGUXA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjGUXAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:00:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEFF3AA7
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b9de3e7fb1so14273165ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689980419; x=1690585219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Hf66Tg9z6eVGNOq7lITDvOc5Z8kagkKjdF0cIF19+es=;
        b=gWGRlaTkn5NiQLzTFkJJKM2s4Vv0wJGMneYaEHOeICGvTQoBJES+ZxeOaxEYUZZ8H/
         aLgB8W2eVwNHUj+L5gE16Bl9H4JCMo1jGVfETz9hdyOEhIOdqK4qUaEnHiyFgT3I5xvw
         5T05h3Lp3sUtvhTNneKrxTx1I6X497FTCSBHT4zPNmNGobPrsW5GniH4Q83Wpsg84klB
         BoNg3UF4Ix1V+9TO5Vo7EA8b8WvxG0sO4gwmvOZvacxW6B3glGXlVviCggBB5PUN470T
         AxanZ4SsftqURjvz+fPuPucWNINaeTK/YOLjg38HJr+MNi6DcmrliLE9v0nUEQxlvldR
         Td2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689980419; x=1690585219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hf66Tg9z6eVGNOq7lITDvOc5Z8kagkKjdF0cIF19+es=;
        b=P9ZdiuyAJ3jdMBy/uluyA9EvO70RyD1BPHyO8ZrNUb1cejnJLn26CIHplwt7hyr/WG
         Cja5M/mFZxK/+WSyPT5qx+mTO94nhd5lP+VggbYrmz/XnzfUo3D6qGNSlLjEa8UVphBs
         Tn/RF8PmAenj98pDOaUfa5x+I8mJcICIbyC3Q3/f0gC9emAnwIWyMywoTQqUhMebRlEs
         /1bAeLHsM+sWwUEcXbNzdzZfI8dDXmbM8hGDHeEOi5ullIYpL5I+F8r0nAj2vffaxkYR
         0uDqPzz2EmWD2mmcKIcvlwt+qiXbx+iutiWZxd+c3PXfh7bSkm8WyWLJn/PGwz8KEi0q
         RJ/g==
X-Gm-Message-State: ABy/qLY6j7jr2pLsGhg5fBeWDbBcKl7r/92668eNpdo0KcPAsHJdlvHV
        t/dsjWUYbV3ZKWSKxga/IgIcN6qRgdo=
X-Google-Smtp-Source: APBJJlEsYv3UXRqM2FbL42Qk0+DlYkMF8rC36zy+MJ2FBqa3Hu01PoGnin5LXIu6/ke1lnlgUHk4C5SvjFo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dad2:b0:1b8:5541:9d4d with SMTP id
 q18-20020a170902dad200b001b855419d4dmr13969plx.6.1689980419181; Fri, 21 Jul
 2023 16:00:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 16:00:02 -0700
In-Reply-To: <20230721230006.2337941-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721230006.2337941-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721230006.2337941-6-seanjc@google.com>
Subject: [PATCH v2 5/9] KVM: x86/mmu: Bug the VM if a vCPU ends up in long
 mode without PAE enabled
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
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Promote the ASSERT(), which is quite dead code in KVM, into a KVM_BUG_ON()
for KVM's sanity check that CR4.PAE=1 if the vCPU is in long mode when
performing a walk of guest page tables.  The sanity is quite cheap since
neither EFER nor CR4.PAE requires a VMREAD, especially relative to the
cost of walking the guest page tables.

More importantly, the sanity check would have prevented the true badness
fixed by commit 112e66017bff ("KVM: nVMX: add missing consistency checks
for CR0 and CR4").  The missed consistency check resulted in some versions
of KVM corrupting the on-stack guest_walker structure due to KVM thinking
there are 4/5 levels of page tables, but wiring up the MMU hooks to point
at the paging32 implementation, which only allocates space for two levels
of page tables in "struct guest_walker32".

Queue a page fault for injection if the assertion fails, as both callers,
FNAME(gva_to_gpa) and FNAME(walk_addr_generic), assume that walker.fault
contains sane info on a walk failure.  E.g. not populating the fault info
could result in KVM consuming and/or exposing uninitialized stack data
before the vCPU is kicked out to userspace, which doesn't happen until
KVM checks for KVM_REQ_VM_DEAD on the next enter.

Move the check below the initialization of "pte_access" so that the
aforementioned to-be-injected page fault doesn't consume uninitialized
stack data.  The information _shouldn't_ reach the guest or userspace,
but there's zero downside to being paranoid in this case.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a3fc7c1a7f8d..f8d358226ac6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -338,7 +338,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 #endif
 	walker->max_level = walker->level;
-	ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
 
 	/*
 	 * FIXME: on Intel processors, loads of the PDPTE registers for PAE paging
@@ -348,6 +347,17 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	nested_access = (have_ad ? PFERR_WRITE_MASK : 0) | PFERR_USER_MASK;
 
 	pte_access = ~0;
+
+	/*
+	 * Queue a page fault for injection if this assertion fails, as callers
+	 * assume that walker.fault contains sane info on a walk failure.  I.e.
+	 * avoid making the situation worse by inducing even worse badness
+	 * between when the assertion fails and when KVM kicks the vCPU out to
+	 * userspace (because the VM is bugged).
+	 */
+	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm))
+		goto error;
+
 	++walker->level;
 
 	do {
-- 
2.41.0.487.g6d72f3e995-goog

