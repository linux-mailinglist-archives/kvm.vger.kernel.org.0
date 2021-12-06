Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A3946A62E
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348974AbhLFT7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 14:59:11 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:49914 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349008AbhLFT7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:59:09 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK50-0000n1-SA; Mon, 06 Dec 2021 20:55:18 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/29] KVM: MIPS: Drop pr_debug from memslot commit to avoid using "mem"
Date:   Mon,  6 Dec 2021 20:54:13 +0100
Message-Id: <446929a668f6e1346751571b71db41e94e976cdf.1638817639.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Remove an old (circa 2012) kvm_debug from kvm_arch_commit_memory_region()
to print basic information when committing a memslot change.  The primary
motivation for removing the kvm_debug is to avoid using @mem, the user
memory region, so that said param can be removed.

Alternatively, the debug message could be converted to use @new, but that
would require synthesizing select state to play nice with the DELETED
case, which will pass NULL for @new in the future.  And there's no
argument to be had for dumping generic information in an arch callback,
i.e. if there's a good reason for the debug message, then it belongs in
common KVM code where all architectures can benefit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/mips/kvm/mips.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b2ce10784eb0..bda717301db8 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -230,10 +230,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 {
 	int needs_flush;
 
-	kvm_debug("%s: kvm: %p slot: %d, GPA: %llx, size: %llx, QVA: %llx\n",
-		  __func__, kvm, mem->slot, mem->guest_phys_addr,
-		  mem->memory_size, mem->userspace_addr);
-
 	/*
 	 * If dirty page logging is enabled, write protect all pages in the slot
 	 * ready for dirty logging.
