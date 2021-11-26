Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5DA45E3B5
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 01:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352047AbhKZAgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 19:36:47 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:55292 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239062AbhKZAep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 19:34:45 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mqP9B-0007H6-VT; Fri, 26 Nov 2021 01:31:26 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: Use atomic_long_cmpxchg() instead of an open-coded variant
Date:   Fri, 26 Nov 2021 01:31:08 +0100
Message-Id: <7bdc7ee3dcc09a109cfaf9fb8662fb49ca0bec2c.1637884349.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1637884349.git.maciej.szmigiero@oracle.com>
References: <cover.1637884349.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Open-coding a cmpxchg()-like operation is significantly less readable than
a direct call.

Also, the open-coded version compiles to multiple instructions with
a branch on x86, instead of just a single instruction.

Since technically the open-coded variant didn't guarantee actual atomicity
add a comment there, too, that this property isn't strictly required in
this case.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d4399db06d49..367c1cba26d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1378,8 +1378,12 @@ static void kvm_replace_memslot(struct kvm *kvm,
 		hash_del(&old->id_node[idx]);
 		interval_tree_remove(&old->hva_node[idx], &slots->hva_tree);
 
-		if ((long)old == atomic_long_read(&slots->last_used_slot))
-			atomic_long_set(&slots->last_used_slot, (long)new);
+		/*
+		 * The atomicity isn't strictly required here since we are
+		 * operating on an inactive memslots set anyway.
+		 */
+		atomic_long_cmpxchg(&slots->last_used_slot,
+				    (unsigned long)old, (unsigned long)new);
 
 		if (!new) {
 			kvm_erase_gfn_node(slots, old);
