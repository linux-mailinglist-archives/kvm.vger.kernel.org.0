Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A0A95727
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 08:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfHTGOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 02:14:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45652 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbfHTGOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 02:14:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so2575954pgp.12;
        Mon, 19 Aug 2019 23:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mhB3UhKa2apbmILstVtC2PuBpKp+KIhCo43t5hvhotg=;
        b=qCrE+7Gv+siL4APdA5TNSgsXbN8MDTadgi8WtA9BzoUSsgHRYilJOs8fJvNB9Ei0KT
         WitL6q4cCiwUx3de5plYEsnKBcS5MW6CHclZIaJNdrcZF+BrGB5j4gatGs+7ZNW4c3Cp
         yDT4+SJMw/ZcYoitRjlz3Q8HnrVP6UUrMKVb0CRWGW21ee+MXjrv4MVwp/gMrIt55BZW
         PFnxMVEIIYa+0vvtSmhJl49Tzvs8ITIGHwW4IE8KL6etlIQzQHnT8kH0l+EW4tLIAFOm
         IVyWcnQhRbYenh2Jox0+d45itZDeb8uiFOiUwpU/Y14rgIYXPfRt7N7LPo34cjJp/n1D
         WazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mhB3UhKa2apbmILstVtC2PuBpKp+KIhCo43t5hvhotg=;
        b=GoMn920+ZPsDoe+A6gi7ynvdYW969Qy/sOAwiTfPja9hUNTR+NACqEvMdeKMrq04eA
         FTgiKoKp5phPExFog1dQVMrCz9f1btuOv1Vct2WSjU9/gKRzYP/SVrO2DbqZsgOD9zOV
         5FljvpAgBavzfN84mVdZe5jK1WmjOQx+e4dL+In5Ronl4EsUKcVn6iYGw8FYAwJdopbW
         uOWsGl3WCnQ06b86A9OEJXF+KTFOc9Qg7JEcxEkUJ3ji/iAeZil1WkHUL5RKKxU63xwk
         LcdONblNa7Gp0f/i0YjpXONJDjIoEPcH8p64IjeKwp422fic+niQR3YSXplJ/HtBaOIn
         BUow==
X-Gm-Message-State: APjAAAVL18dkCSSA3HRJ7M4SyoVHRolJJQzwJsEQ96+0oB+JO3gMYXOH
        W58eAnLqe2C/WyhcDAcrNJIyBba1
X-Google-Smtp-Source: APXvYqwnE1DCcQVDEpP87tHqgAuQNly7+QuZ9z1c9GXF4bR0TCPwj2dU6DdIERh2C5MBaeGgjrl+dQ==
X-Received: by 2002:aa7:93cc:: with SMTP id y12mr24691671pff.246.1566281641237;
        Mon, 19 Aug 2019 23:14:01 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id y13sm10276581pfb.48.2019.08.19.23.13.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 23:14:00 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Define usage types for rmap array in guest memslot
Date:   Tue, 20 Aug 2019 16:13:49 +1000
Message-Id: <20190820061349.28995-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The rmap array in the guest memslot is an array of size number of guest
pages, allocated at memslot creation time. Each rmap entry in this array
is used to store information about the guest page to which it
corresponds. For example for a hpt guest it is used to store a lock bit,
rc bits, a present bit and the index of a hpt entry in the guest hpt
which maps this page. For a radix guest which is running nested guests
it is used to store a pointer to a linked list of nested rmap entries
which store the nested guest physical address which maps this guest
address and for which there is a pte in the shadow page table.

As there are currently two uses for the rmap array, and the potential
for this to expand to more in the future, define a type field (being the
top 8 bits of the rmap entry) to be used to define the type of the rmap
entry which is currently present and define two values for this field
for the two current uses of the rmap array.

Since the nested case uses the rmap entry to store a pointer, define
this type as having the two high bits set as is expected for a pointer.
Define the hpt entry type as having bit 56 set (bit 7 IBM bit ordering).

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h | 22 ++++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_rm_mmu.c |  2 +-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index e6e5f59aaa97..6fb5fb4779e0 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -232,11 +232,25 @@ struct revmap_entry {
 };
 
 /*
- * We use the top bit of each memslot->arch.rmap entry as a lock bit,
- * and bit 32 as a present flag.  The bottom 32 bits are the
- * index in the guest HPT of a HPTE that points to the page.
+ * The rmap array of size number of guest pages is allocated for each memslot.
+ * This array is used to store usage specific information about the guest page.
+ * Below are the encodings of the various possible usage types.
  */
-#define KVMPPC_RMAP_LOCK_BIT	63
+/* Free bits which can be used to define a new usage */
+#define KVMPPC_RMAP_TYPE_MASK	0xff00000000000000
+#define KVMPPC_RMAP_NESTED	0xc000000000000000	/* Nested rmap array */
+#define KVMPPC_RMAP_HPT		0x0100000000000000	/* HPT guest */
+
+/*
+ * rmap usage definition for a hash page table (hpt) guest:
+ * 0x0000080000000000	Lock bit
+ * 0x0000018000000000	RC bits
+ * 0x0000000100000000	Present bit
+ * 0x00000000ffffffff	HPT index bits
+ * The bottom 32 bits are the index in the guest HPT of a HPTE that points to
+ * the page.
+ */
+#define KVMPPC_RMAP_LOCK_BIT	43
 #define KVMPPC_RMAP_RC_SHIFT	32
 #define KVMPPC_RMAP_REFERENCED	(HPTE_R_R << KVMPPC_RMAP_RC_SHIFT)
 #define KVMPPC_RMAP_PRESENT	0x100000000ul
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 63e0ce91e29d..7186c65c61c9 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -99,7 +99,7 @@ void kvmppc_add_revmap_chain(struct kvm *kvm, struct revmap_entry *rev,
 	} else {
 		rev->forw = rev->back = pte_index;
 		*rmap = (*rmap & ~KVMPPC_RMAP_INDEX) |
-			pte_index | KVMPPC_RMAP_PRESENT;
+			pte_index | KVMPPC_RMAP_PRESENT | KVMPPC_RMAP_HPT;
 	}
 	unlock_rmap(rmap);
 }
-- 
2.13.6

