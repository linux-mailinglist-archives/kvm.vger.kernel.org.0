Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693E387FA4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437267AbfHIQUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:18 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53334 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407434AbfHIQUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DE002305D3E1;
        Fri,  9 Aug 2019 19:01:03 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C1A4A305B7A0;
        Fri,  9 Aug 2019 19:01:01 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v6 28/92] kvm: x86: consult the page tracking from kvm_mmu_get_page() and __direct_map()
Date:   Fri,  9 Aug 2019 18:59:43 +0300
Message-Id: <20190809160047.8319-29-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

KVM doesn't normally need to keep track that closely to page access bits,
however for the introspection subsystem this is essential.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://marc.info/?l=kvm&m=149804987417131&w=2
CC: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/mmu.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9eaf6cc776a9..810e3e5bd575 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2491,6 +2491,20 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sp);
 }
 
+static unsigned int kvm_mmu_page_track_acc(struct kvm_vcpu *vcpu, gfn_t gfn,
+					   unsigned int acc)
+{
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREREAD))
+		acc &= ~ACC_USER_MASK;
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREWRITE) ||
+	    kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+		acc &= ~ACC_WRITE_MASK;
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_PREEXEC))
+		acc &= ~ACC_EXEC_MASK;
+
+	return acc;
+}
+
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
@@ -2511,7 +2525,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.direct = direct;
 	if (role.direct)
 		role.cr4_pae = 0;
-	role.access = access;
+	role.access = kvm_mmu_page_track_acc(vcpu, gfn, access);
 	if (!vcpu->arch.mmu->direct_map
 	    && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
@@ -3234,7 +3248,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, int write, int map_writable,
 
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == level) {
-			emulate = mmu_set_spte(vcpu, iterator.sptep, ACC_ALL,
+			unsigned int acc = kvm_mmu_page_track_acc(vcpu, gfn,
+								  ACC_ALL);
+
+			emulate = mmu_set_spte(vcpu, iterator.sptep, acc,
 					       write, level, gfn, pfn, prefault,
 					       map_writable);
 			direct_pte_prefetch(vcpu, iterator.sptep);
