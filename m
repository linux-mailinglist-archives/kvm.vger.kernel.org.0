Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68556FFD95
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbjEKX7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbjEKX7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:59:37 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8DD7AAE
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1aad9af33c1so94046425ad.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683849570; x=1686441570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YnFuIzqD1/t6APimZk0lC1MpBWigrgfjZSdse0VQg8E=;
        b=m6BIqiWHUNnwH9ZX1auPqN8qbYxGdaQTvKaKyZWwmYcUSvHMgc/cPcnsQG+xCbXjby
         uFO0RSxKkpl/MG8aAsVdgDpTocb2yEDzuEuAGyfFv5RrIuvsdjXXDZDcIbtQ8Y5Am32i
         gFk1v/oXsMP6Lc33MQcOJA9n7VbewZB9LcXu8IVxeBFYNpcpjKkSlfwzqiWMz0Iu7ZGR
         lhCSVmtX2z75ZiWwfBYjGLCRQAzx9inv2mbnDLQpsX90sfcHCU3oIVCk3ev+ej7nD45U
         Y1p7GQ91pd/Nf5ZBLMnXakp4S9DaWdR3sTMIrK3NpOO/yXJ0tuH1xgs3nV57joSjCFPp
         ABDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683849570; x=1686441570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YnFuIzqD1/t6APimZk0lC1MpBWigrgfjZSdse0VQg8E=;
        b=GVZqfDv37P2FwRENh1dhYUnCxL+8B5dGKqGNkWbgJXpF0ki4CdU59OCGkaS/wSypfj
         fI8fKuWYZS6cmrxaj45rkEjTFBjBOKsgv8JYIHAuvNwaUMhErSwy4J8odqaERq79h2q7
         ZbAJ8Vc9/nVyS37+NQW62ZVw1A7bTIZNYHMXpDHrvO+X7m60sm52agRyiCC99DzdD/iW
         TQnY+xnpo2jZMldMjSUenkQDDAg5LxbSgsNZ0ON4M3OovrbUkXxGpEWXmeTw5XEWYseu
         6CY3q9BsoWc67zaJrERGq5SDsJClPap3i/5izyJxuPUvrkUh2DWs0RnEhnO7bFYlVsr4
         lS3g==
X-Gm-Message-State: AC+VfDxQCavBhWpgt3wSQH28h3uLEsR/cREG1ttETYg/DuznSvrYdYA9
        2Yi5zZUrpGPqf3cIeuyMNsjxUXaZEz4=
X-Google-Smtp-Source: ACHHUZ50yKczHohEWCnK11pRBzxZJwgMfOTrGLy4SGJC1v/SnV4xq6fJZWHW3hsVT9XcVqeBdvbSquzBL3Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c946:b0:1a6:a899:fe78 with SMTP id
 i6-20020a170902c94600b001a6a899fe78mr8905287pla.2.1683849569880; Thu, 11 May
 2023 16:59:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:59:14 -0700
In-Reply-To: <20230511235917.639770-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511235917.639770-7-seanjc@google.com>
Subject: [PATCH 6/9] KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode
 without PAE enabled
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

Queue a page fault for injection if the assertion fails, as the sole
caller, FNAME(gva_to_gpa), assumes that walker.fault contains sane info
on a walk failure, i.e. avoid making the situation worse between the time
the assertion fails and when KVM kicks the vCPU out to userspace (because
the VM is bugged).

Move the check below the initialization of "pte_access" so that the
aforementioned to-be-injected page fault doesn't consume uninitialized
stack data.  The information _shouldn't_ reach the guest or userspace,
but there's zero downside to being paranoid in this case.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a3fc7c1a7f8d..f297e9311dcd 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -338,7 +338,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 #endif
 	walker->max_level = walker->level;
-	ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
 
 	/*
 	 * FIXME: on Intel processors, loads of the PDPTE registers for PAE paging
@@ -348,6 +347,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	nested_access = (have_ad ? PFERR_WRITE_MASK : 0) | PFERR_USER_MASK;
 
 	pte_access = ~0;
+
+	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm))
+		goto error;
+
 	++walker->level;
 
 	do {
-- 
2.40.1.606.ga4b1b128d6-goog

