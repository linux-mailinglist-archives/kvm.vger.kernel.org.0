Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7A22189AD
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 16:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgGHOAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 10:00:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30567 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728932AbgGHOAk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 10:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594216838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qPr0eL60h+DsRpfuaobt35zdISOXizza2r3opqrQCz0=;
        b=KLwi9sL37dbgYv0VA6tG9WfUosYBtuqJRDgYD/HoP4MidTC/LKSJGMuUhIKLQSUyQ09hm/
        tnnEMxqy88AnLg/pMm9vKAeeAAevzlx745fS4WQfKlt5CVsUiA2JouSQ3JW0hbAWEPxUgM
        ldWkgSIz6yK+5Kz2ynIvz3yBjYghSbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-EiqG4VkKOCG6ODFfeWtUJg-1; Wed, 08 Jul 2020 10:00:37 -0400
X-MC-Unique: EiqG4VkKOCG6ODFfeWtUJg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DA8E8015F7;
        Wed,  8 Jul 2020 14:00:34 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AE6078493;
        Wed,  8 Jul 2020 14:00:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: take as_id into account when checking PGD
Date:   Wed,  8 Jul 2020 16:00:23 +0200
Message-Id: <20200708140023.1476020-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OVMF booted guest running on shadow pages crashes on TRIPLE FAULT after
enabling paging from SMM. The crash is triggered from mmu_check_root() and
is caused by kvm_is_visible_gfn() searching through memslots with as_id = 0
while vCPU may be in a different context (address space).

Introduce kvm_vcpu_is_visible_gfn() and use it from mmu_check_root().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4fd4b5de8996..309024210a35 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3668,7 +3668,7 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 {
 	int ret = 0;
 
-	if (!kvm_is_visible_gfn(vcpu->kvm, root_gfn)) {
+	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		ret = 1;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d564855243d8..f74d2a5afc26 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -774,6 +774,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
+bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a852af5c3214..b131c7da1d12 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1626,6 +1626,14 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
+bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm_memory_slot *memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+
+	return kvm_is_visible_memslot(memslot);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_visible_gfn);
+
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
-- 
2.25.4

