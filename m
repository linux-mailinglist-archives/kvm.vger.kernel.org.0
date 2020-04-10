Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF83B1A4C94
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDJXRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:20811 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgDJXRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:10 -0400
IronPort-SDR: z+5CrFAHYBue1LjQlCLbgJYfqWOj3/r2umJ3dI1axca0Jp/DBrr9NO2CKEE2h4UnoS8CpOT3Up
 L+tv90tJ+O3g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:09 -0700
IronPort-SDR: FzvuNvvKZpOwvgY8K4862XFoE/gFd82xETllZcB01RLxQodqpBf1+Pv7IFARofVwbABdJEa1xq
 ozdin/MY6IqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542216"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 01/10] KVM: selftests: Take vcpu pointer instead of id in vm_vcpu_rm()
Date:   Fri, 10 Apr 2020 16:16:58 -0700
Message-Id: <20200410231707.7128-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
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
2.26.0

