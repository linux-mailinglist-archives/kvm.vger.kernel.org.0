Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5571039A403
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 17:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhFCPMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 11:12:37 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:43903 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhFCPMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 11:12:37 -0400
Received: by mail-pl1-f171.google.com with SMTP id v12so3023172plo.10;
        Thu, 03 Jun 2021 08:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ytX/7qNN3WwyQK0LAIrxn42NeJriMqbyp9OIcjvkW4=;
        b=Ie42/OY9JQj6C5gqGcEO3N8IUZ47sNLu7b/37YWU9nTBfZhNYKiNX0sdbz/pA5Au/c
         tMWGf7LWBDNe8Y6ur2rbxKiUTricsCq6ysD+SmBE7iPjvqD7RpXs0C1GT5hjQ6MmqAPf
         gHx7a9buVV6mbwqO8tvuwZ4W6VT4C2h1+R/Z1xEwHfTCKxzIKmhsPCyAatIvxyYbL3ib
         qV+dWMYQ5OtXkUjaEhMAnnLKIaQ5cyvN8FOR+P20vUsNgL7tnjTH9Ymx/nGDpAf0GXTy
         6IISXn6xpiIpUJKPUDtmNh2wb8cOEJae/DyUO7iAisa51SbnUxomokFL3J+62FvCo2lK
         J7xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ytX/7qNN3WwyQK0LAIrxn42NeJriMqbyp9OIcjvkW4=;
        b=E49bv5ml9ekMlvD2gXLA8usK2rWVxI0l+QpNKSTj2kmG7/ic1+WKXBWd17AJ+3oxbu
         GMgmlarjKknEgDTQ4029PUDPGOEW3MpwD2x5o79yJ0vTXGVc5CDWtBxN35ncnpngJ0gN
         IjDgyJlq8D27dJKdzJg1TPoDiXWThapGlFmQhrG5RnWk3XVOAwhRP9hVuI57SNnv7Nf0
         kjbXmruPFYT/4rf4eW+Y8Zc1KEb6k6OBbOhXqlYnaWt1M9vvlhzCUZLUjaIsg0wGUrgu
         8ao7COCP9LMaWb9DIyXAYTM8RwlCzrvCg9ATXIqVPh8M5qWLOsror7p1AKm5c4KJdaq/
         CSmA==
X-Gm-Message-State: AOAM531+ekqQ4BxOoc/+R3p59tU3fDn3FpqLGK9aYxjh4hGkDgrZrRt1
        isjtw0BjREFuKiW4lLPvEOKIoPmAFSA=
X-Google-Smtp-Source: ABdhPJyDjceDUJjIgTwEDxoIaUx371wwpPCNRO3iIruRpb5xntwB7viN3eDmhb5Hp4L5NdOmds5JJg==
X-Received: by 2002:a17:902:27:b029:10b:dd63:2d3a with SMTP id 36-20020a1709020027b029010bdd632d3amr130819pla.77.1622732992058;
        Thu, 03 Jun 2021 08:09:52 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id x3sm3177706pgx.8.2021.06.03.08.09.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jun 2021 08:09:51 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH V2] KVM: X86: MMU: Use the correct inherited permissions to get shadow page
Date:   Thu,  3 Jun 2021 13:24:55 +0800
Message-Id: <20210603052455.21023-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20201120095517.19211-1-jiangshanlai@gmail.com>
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Commit 41074d07c78b ("KVM: MMU: Fix inherited permissions for emulated
guest pte updates") said role.access is common access permissions for
all ptes in this shadow page, which is the inherited permissions from
the parent ptes, and should not from any children pte.

But the commit did not enforce this definition when kvm_mmu_get_page()
is called in FNAME(fetch). Rather, it uses a whole combined access of
the first accessing vitual address except the ternimating pte. And the
permissions won't be checked again in next FNAME(fetch) since the spte
is present. It might fail to meet guest's expectation when guest uses
shared pagetables.

For example, here is a shared pagetable:
   pgd[]   pud[]        pmd[]            virtual address pointers
                     /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
        /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
   pgd-|           (shared pmd[] as above)
        \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
                     \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
  pud1 and pud2 point to the same pmd table, so:
  ptr1 and ptr3 points to the same page.
  ptr2 and ptr4 points to the same page.

(pud1 and pud2 here are pud entries, not pud pagtable pointer
 pmd1 and pmd2 here are pmd entries, not pmd pagtable pointer)

  The guess read-accesses to ptr1 first. So the hypervisor gets the
shadow page table with role.access=u-- for ptr1's pud1 and ptr1's pmd1.
(Note: current pt->access is the combined access of pgd, pud1 and
pmd1, so it is "u--".  But the current code uses this pt->access to
get pagetable for pud1 which violate the definition in the comment
which should be the combined access of pgd, pud1, a.k.a "uw-".)

  And then the guest write-accesses to ptr2, and the hypervisor
set up shadow page for ptr2.
(Note: current pt->access=uw-, but pud1 points to a shadow pmd
table with role.access=u--.  Since pud1 is present, the hypervisor
silencely accepts it without recheck the access in FNAME(fetch))

  After that, the guess read-accesses to ptr3, the hypervisor
reused the same shadow pmd page table for pud2 as ptr1.
(Note: because current pt->access=u--, which is the access of pgd, pud2
and pmd1)

  At last, the guest writes to ptr4 without vmexit nor pagefault.
Which should cause pagefault as the guest expects.

Any kind of shared pagetable might have the similar problem when in
virtual machine without TDP enabled if the permissions are different
from different ancestors.

In order to fix the problem, we change pt->access to be an array, and
any access in it will not combind accesses from child ptes.

The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangshanlai@gmail.com/ 
Remember to test it with TDP disabled.

The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
Fix inherited permissions for emulated guest pte updates"), and it
is hard to find which is the culprit.  So there is no fixes tag here.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from V1:
	Update changelog only

 Documentation/virt/kvm/mmu.rst |  4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h | 14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 5bfe28b0728e..20d85daed395 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -171,8 +171,8 @@ Shadow pages contain the following information:
     shadow pages) so role.quadrant takes values in the range 0..3.  Each
     quadrant maps 1GB virtual address space.
   role.access:
-    Inherited guest access permissions in the form uwx.  Note execute
-    permission is positive, not negative.
+    Inherited guest access permissions from the parent ptes in the form uwx.
+    Note execute permission is positive, not negative.
   role.invalid:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it is
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 70b7e44e3035..823a5919f9fa 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -90,8 +90,8 @@ struct guest_walker {
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
 	bool pte_writable[PT_MAX_FULL_LEVELS];
-	unsigned pt_access;
-	unsigned pte_access;
+	unsigned int pt_access[PT_MAX_FULL_LEVELS];
+	unsigned int pte_access;
 	gfn_t gfn;
 	struct x86_exception fault;
 };
@@ -418,13 +418,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		}
 
 		walker->ptes[walker->level - 1] = pte;
+
+		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
 	} while (!is_last_gpte(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
 
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
 	walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
 	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
@@ -463,7 +465,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -643,7 +646,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, level, req_level, ret;
 	gfn_t base_gfn = gw->gfn;
 
@@ -675,6 +678,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}
-- 
2.19.1.6.gb485710b

