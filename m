Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86783EBCFC
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhHMUCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:02:09 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50356 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbhHMUCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:02:08 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcwN-00042n-U7; Fri, 13 Aug 2021 21:34:03 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
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
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/13] KVM: Move WARN on invalid memslot index to update_memslots()
Date:   Fri, 13 Aug 2021 21:33:19 +0200
Message-Id: <8db0f1d1901768b5de1417caa425e62d1118e5e8.1628871413.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Since kvm_memslot_move_forward() can theoretically return a negative
memslot index even when kvm_memslot_move_backward() returned a positive one
(and so did not WARN) let's just move the warning to the common code.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 03ef42d2e421..7000efff1425 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1293,8 +1293,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 	struct kvm_memory_slot *mslots = slots->memslots;
 	int i;
 
-	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
-	    WARN_ON_ONCE(!slots->used_slots))
+	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
 		return -1;
 
 	/*
@@ -1398,6 +1397,9 @@ static void update_memslots(struct kvm_memslots *slots,
 			i = kvm_memslot_move_backward(slots, memslot);
 		i = kvm_memslot_move_forward(slots, memslot, i);
 
+		if (WARN_ON_ONCE(i < 0))
+			return;
+
 		/*
 		 * Copy the memslot to its new position in memslots and update
 		 * its index accordingly.
