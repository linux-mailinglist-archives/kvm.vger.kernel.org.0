Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8C645E3B3
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 01:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351600AbhKZAgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 19:36:41 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:55270 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238820AbhKZAek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 19:34:40 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mqP96-0007Gx-JD; Fri, 26 Nov 2021 01:31:20 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Avoid overflowing nr_mmu_pages in kvm_arch_commit_memory_region()
Date:   Fri, 26 Nov 2021 01:31:07 +0100
Message-Id: <44edcde46d12c2f5376a1cd1429650acb506ebaf.1637884349.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1637884349.git.maciej.szmigiero@oracle.com>
References: <cover.1637884349.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

With kvm->nr_memslot_pages capped at ULONG_MAX we can't safely multiply it
by KVM_PERMILLE_MMU_PAGES (20) since this operation can possibly overflow
an unsigned long variable.

Rewrite this "* 20 / 1000" operation as "/ 50" instead to avoid such
overflow.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.c              | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1fcb345bc107..8cd1d254c948 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -135,7 +135,7 @@
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
 #define KVM_PAGES_PER_HPAGE(x)	(KVM_HPAGE_SIZE(x) / PAGE_SIZE)
 
-#define KVM_PERMILLE_MMU_PAGES 20
+#define KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO 50
 #define KVM_MIN_ALLOC_MMU_PAGES 64UL
 #define KVM_MMU_HASH_SHIFT 12
 #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04e8dabc187d..69330b395f12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11753,8 +11753,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
 		unsigned long nr_mmu_pages;
 
-		nr_mmu_pages = kvm->nr_memslot_pages * KVM_PERMILLE_MMU_PAGES;
-		nr_mmu_pages /= 1000;
+		nr_mmu_pages = kvm->nr_memslot_pages / KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO;
 		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
 	}
