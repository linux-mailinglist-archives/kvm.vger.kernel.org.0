Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F3F3B23C5
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhFWXIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFWXI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:08:27 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274E4C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:08 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id n6-20020a3759060000b02903ad3598ec02so4278413qkb.17
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=M3ydmh5FXw/WwmZgZ0UhGBQS2xGblp3Q4P5QtrxRfkI=;
        b=vnK9fPSgKQWR5ZxNGiTOxjt1N7jAjbLXhEtcfyhBhy4nNsP17p5KlXGZRi/Dp8/x5D
         xoiUNjkDX5N7UtD7i4eBWfngirwXYukuiWD0nwwDZqmvrpwFJrWvvk9iwKF+XudfWMZv
         c8ev7fqKW/Hh8elAUTIGw2vSsPMAEq85vasEB0OKNSeWcwF5LYnQl/JTFgTyva/Fhqv3
         ZYNkcuFedfXRVwt1GO6tW0a2NbPwsTs77yWMMrDtcEyVpczy6YOd/ngxJO0BS1rb8CLu
         RWwhbALIREUWdkbx4n9viMMkJ+JWT+jKgV/nDjjExtRRvIBp51E8DRMhxexgJzzo0Nj9
         ysFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=M3ydmh5FXw/WwmZgZ0UhGBQS2xGblp3Q4P5QtrxRfkI=;
        b=I3tP+dRDTuistIpfPX8EAit0i4e3c/PxF5mquALeY9yOWA8Aiw2/hVB4tSX2lM5mvq
         3QDR7t7CvrFdLh1TE9CdEW8u/rub6sF0PMpdKfJl+fC9t5w0W8LKvpFcTDOmLxt98eKg
         OZp8UBy3ImbfEQYN/w/L9Q3mM028Bvc+3Fr10Z7CMRo3yBQ1hJm7u7q689RWzmy2lIGQ
         RaC+RAyttgYEREk4ivVQemXuI8tCrDFqg5AkUbG/5r9DP2nczHpwGixg0BaXZ9Y80vtA
         wvUvZAoYNfV4En0KnySu6Z5kuzy5XgW5BabnK5V0cJVVZzeJcbv0c5YZWz6blBMP8hEm
         7sZA==
X-Gm-Message-State: AOAM530NgC+wB+4J+SL4EpiofnuQ0BXqYJWEBMs9rAeWWWBoTEMhFQv+
        QgH2vTCa9iOqHQi1g3ApBEbtUaRfpck=
X-Google-Smtp-Source: ABdhPJzu9sXF91Gb7/TRKPqNiTlFm2WN9pf0kU7l2qzE5IHlnU7bheDRkZQi1EvV/yMrscItkc57snYovTg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:a25:6f55:: with SMTP id k82mr692122ybc.490.1624489567284;
 Wed, 23 Jun 2021 16:06:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Jun 2021 16:05:49 -0700
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Message-Id: <20210623230552.4027702-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210623230552.4027702-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 4/7] KVM: x86/mmu: Do not apply HPA (memory encryption) mask
 to GPAs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore "dynamic" host adjustments to the physical address mask when
generating the masks for guest PTEs, i.e. the guest PA masks.  The host
physical address space and guest physical address space are two different
beasts, e.g. even though SEV's C-bit is the same bit location for both
host and guest, disabling SME in the host (which clears shadow_me_mask)
does not affect the guest PTE->GPA "translation".

For non-SEV guests, not dropping bits is the correct behavior.  Assuming
KVM and userspace correctly enumerate/configure guest MAXPHYADDR, bits
that are lost as collateral damage from memory encryption are treated as
reserved bits, i.e. KVM will never get to the point where it attempts to
generate a gfn using the affected bits.  And if userspace wants to create
a bogus vCPU, then userspace gets to deal with the fallout of hardware
doing odd things with bad GPAs.

For SEV guests, not dropping the C-bit is technically wrong, but it's a
moot point because KVM can't read SEV guest's page tables in any case
since they're always encrypted.  Not to mention that the current KVM code
is also broken since sme_me_mask does not have to be non-zero for SEV to
be supported by KVM.  The proper fix would be to teach all of KVM to
correctly handle guest private memory, but that's a task for the future.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 17 +++++++++++++++--
 arch/x86/kvm/mmu/spte.h        |  6 ------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 823a5919f9fa..9df7e4b315a1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -20,11 +20,24 @@
  * so the code in this file is compiled twice, once per pte size.
  */
 
+/* Shadow paging constants/helpers that don't need to be #undef'd. */
+#ifndef __KVM_X86_PAGING_TMPL_COMMON_H
+#define __KVM_X86_PAGING_TMPL_COMMON_H
+
+#define GUEST_PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#define PT64_LVL_ADDR_MASK(level) \
+	(GUEST_PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#define PT64_LVL_OFFSET_MASK(level) \
+	(GUEST_PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#endif /* __KVM_X86_PAGING_TMPL_COMMON_H */
+
 #if PTTYPE == 64
 	#define pt_element_t u64
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
-	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
+	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
@@ -57,7 +70,7 @@
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
-	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
+	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index bca0ba11cccf..6925dfc38981 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -38,12 +38,6 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 #else
 #define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #endif
-#define PT64_LVL_ADDR_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
-#define PT64_LVL_OFFSET_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
 
 #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
 			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
-- 
2.32.0.288.g62a8d224e6-goog

