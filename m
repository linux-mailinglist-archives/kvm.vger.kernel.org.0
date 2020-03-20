Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52A718D9CE
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgCTU4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:56:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:32133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbgCTUzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:55:48 -0400
IronPort-SDR: Wc3WN+IL7OXdYlYJOJqLWRLz+B0iccnMlhm3GVaySI99H7a9LvF579M309Lwv/u2MrIy69vyPQ
 uvpHg3cRw86A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 13:55:48 -0700
IronPort-SDR: mecXOMDxpsSnYWlW+kNP6pgB55m4qSt40p2DV2i7agnEreJw/r+sNhb4EwakwhirV08mPlHP0I
 18mI0TIKMxOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280543323"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2020 13:55:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 3/7] KVM: selftests: Take vcpu pointer instead of id in vm_vcpu_rm()
Date:   Fri, 20 Mar 2020 13:55:42 -0700
Message-Id: <20200320205546.2396-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320205546.2396-1-sean.j.christopherson@intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sole caller of vm_vcpu_rm() already has the vcpu pointer, take it
directly instead of doing an extra lookup.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8a3523d4434f..9a783c20dd26 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -393,7 +393,7 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   vcpuid - VCPU ID
+ *   vcpu - VCPU to remove
  *
  * Output Args: None
  *
@@ -401,9 +401,8 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
  *
  * Within the VM specified by vm, removes the VCPU given by vcpuid.
  */
-static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
+static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
 
 	ret = munmap(vcpu->state, sizeof(*vcpu->state));
@@ -427,7 +426,7 @@ void kvm_vm_release(struct kvm_vm *vmp)
 	int ret;
 
 	while (vmp->vcpu_head)
-		vm_vcpu_rm(vmp, vmp->vcpu_head->id);
+		vm_vcpu_rm(vmp, vmp->vcpu_head);
 
 	ret = close(vmp->fd);
 	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
-- 
2.24.1

