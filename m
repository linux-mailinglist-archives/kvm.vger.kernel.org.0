Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5054E2BA52F
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 09:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgKTIys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 03:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgKTIyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 03:54:47 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6899FC0613CF;
        Fri, 20 Nov 2020 00:54:47 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id g7so7232244pfc.2;
        Fri, 20 Nov 2020 00:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/GGZ6aBy0fAJHljiYm9GCn8PhX9nN8QvN23eDsxWuk=;
        b=T1qI09CMPKnjLyDYy5sS1ZvKis/W3pvPci8guN7/8hK87Tzs/WoHCgxsuwGdXrhURS
         aBnSfNwCs6wmBWQBBi0kfPVEJvfImuz3ZjK5Utw2DDXHlmSBC6q5Y3UpgagZZgy1eqi/
         yIWa84v8guKk08Wsq/+Jl18AtYuCPNUO2yuGoUUb0pLWBG8GljbWiJ9q8r1h38MDlrgz
         q/J4F0A6W3Jx/knO+EnmHsdJ3a2uTaVVq6HtYxnyDfe9hUnvv/vsUpF156stnorc5scJ
         4bfFw1p8aGUAL66NGMj51G5A4mHc/Q/wLG2sYKIe75SDBplUBVCnw3mvBcYoOCDn2EVg
         +mUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/GGZ6aBy0fAJHljiYm9GCn8PhX9nN8QvN23eDsxWuk=;
        b=Wa6/WrnfvaG29/mmeTVj4AvvO/yOaaEH9aWRIdTGKO2BUwzHslFrKJDzvQMimXkWQh
         6o8RrNnqPAj6Huy47jQ1RdJj2ZT1QocIT//iXlearNyXQawkKQUAqyIZSXcxQ28mOYoO
         p4fHybmU9UtOBtT2poLJlcAcI3Zfe46/ZLSHdm4aiBT1VENWWjlolGa5OXs35HESdw4F
         C6+gyGE54Mfbmb4CigIUDVvA1DC7bDR7v7KrLyRKIymAHkdq4GuNO7ELnLfbUDU8ToWQ
         dXkcJ2BBtAf2C4PYvWDkoXFhmwOkbk1xoT/c16oy4bOI1Bd9PWMrkJOPqmYo6/Alre25
         rsNQ==
X-Gm-Message-State: AOAM532tqvQ6OUPrgWFnnCGfit/Q8eZ1BARr0x4xgfQ4BOQRON39s7lm
        +x0Uhqki/JUfjqICZMKVUSmjQ2JB6+g=
X-Google-Smtp-Source: ABdhPJywHQyJ4kLhi69aEm0AdkK7Bpe/GnTHUS4lbV9KMn5cRw1YJ4PoVKVXo/A811o9pUjYqKjN4g==
X-Received: by 2002:a17:90b:208:: with SMTP id fy8mr9132287pjb.204.1605862486817;
        Fri, 20 Nov 2020 00:54:46 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id s189sm2734936pfb.60.2020.11.20.00.54.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2020 00:54:46 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@qumranet.com>, linux-doc@vger.kernel.org
Subject: [PATCH] kvm/x86/mmu: use the correct inherited permissions to get shadow page
Date:   Fri, 20 Nov 2020 17:55:17 +0800
Message-Id: <20201120095517.19211-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Commit 41074d07c78b ("KVM: MMU: Fix inherited permissions for emulated
guest pte updates") said role.access is common access permissions for
all ptes in this shadow page, which is the inherited permissions from
the parent ptes.

But the commit did not enforce this definition when kvm_mmu_get_page()
is called in FNAME(fetch). Rather, it uses a random (last level pte's
combined) access permissions. And the permissions won't be checked again
in next FNAME(fetch) since the spte is present. It might fail to meet
guest's expectation when guest sets up spaghetti pagetables.

Fixes: 41074d07c78b ("KVM: MMU: Fix inherited permissions for emulated guest pte updates")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 Documentation/virt/kvm/mmu.rst |  4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h | 14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 1c030dbac7c4..b31586504a9a 100644
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
index 50e268eb8e1a..00a0bfaed6e8 100644
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
@@ -635,7 +638,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, level, req_level, ret;
 	gfn_t base_gfn = gw->gfn;
 
@@ -667,6 +670,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}
-- 
2.19.1.6.gb485710b

