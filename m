Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D05E4029
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388067AbfJXXJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:09:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:23485 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387481AbfJXXHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:07:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="202445847"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 16:07:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 06/15] KVM: Explicitly free allocated-but-unused dirty bitmap
Date:   Thu, 24 Oct 2019 16:07:35 -0700
Message-Id: <20191024230744.14543-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191024230744.14543-1-sean.j.christopherson@intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly free an allocated-but-unused dirty bitmap instead of relying
on kvm_free_memslot() if an error occurs in __kvm_set_memory_region().
There is no longer a need to abuse kvm_free_memslot() to free arch
specific resources as arch specific code is now called only after the
common flow is guaranteed to succeed.  Arch code can still fail, but
it's responsible for its own cleanup in that case.

Eliminating the error path's abuse of kvm_free_memslot() paves the way
for simplifying kvm_free_memslot(), i.e. dropping its @dont param.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9d6af9044304..a43902d9036d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1030,7 +1030,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
 	if (!slots)
-		goto out_free;
+		goto out_bitmap;
 	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
 
 	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
@@ -1078,8 +1078,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
 		slots = install_new_memslots(kvm, as_id, slots);
 	kvfree(slots);
-out_free:
-	kvm_free_memslot(kvm, &new, &old);
+out_bitmap:
+	if (new.dirty_bitmap && !old.dirty_bitmap)
+		kvm_destroy_dirty_bitmap(&new);
 out:
 	return r;
 }
-- 
2.22.0

