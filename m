Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591141F1FA7
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 21:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgFHTTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 15:19:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:41852 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgFHTS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 15:18:59 -0400
IronPort-SDR: TX0auy171xg/88bbdvUy0RNU/eN06UqdDle9Lx8xatxU3JYUVM9CEqS8nogwL0wpdeNqXVMwn7
 xCntn4YniymQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 12:18:59 -0700
IronPort-SDR: WIvzDvt6qXPnDtoGlEHqhyfaeHGmYNE6iID2/o8ODo6ZAgHRcxd0ILtw4JJz9RY545QtW3RS/V
 PzvkvaUlqvhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="446851097"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 08 Jun 2020 12:18:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Oliver Upton <oupton@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH v2] KVM: nVMX: Consult only the "basic" exit reason when routing nested exit
Date:   Mon,  8 Jun 2020 12:18:57 -0700
Message-Id: <20200608191857.30319-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consult only the basic exit reason, i.e. bits 15:0 of vmcs.EXIT_REASON,
when determining whether a nested VM-Exit should be reflected into L1 or
handled by KVM in L0.

For better or worse, the switch statements nested_vmx_l0_wants_exit()
and nested_vmx_l1_wants_exit() default to reflecting the VM-Exit into L1
for any nested VM-Exit without dedicated logic.  Because the case
statements only contain the basic exit reason, any VM-Exit with modifier
bits set will be reflected to L1, even if KVM intended to handle it in
L0.

Practically speaking, this only affects EXIT_REASON_MCE_DURING_VMENTRY,
i.e. a #MC that occurs on nested VM-Enter would be incorrectly routed to
L1, as "failed VM-Entry" is the only modifier that KVM can currently
encounter.  The SMM modifiers will never be generated as KVM doesn't
support/employ a SMI Transfer Monitor.  Ditto for "exit from enclave",
as KVM doesn't yet support virtualizing SGX, i.e. it's impossible to
enter an enclave in a KVM guest (L1 or L2).

Note, the original version of this fix[*] is functionally equivalent and
far more suited to backporting as the affected code was refactored since
the original patch was posted.

[*] https://lkml.kernel.org/r/20200227174430.26371-1-sean.j.christopherson@intel.com

Fixes: 644d711aa0e1 ("KVM: nVMX: Deciding if L0 or L1 should handle an L2 exit")
Cc: Jim Mattson <jmattson@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: stable@vger.kernel.org
Cc: Oliver Upton <oupton@google.com>
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Another wounded soldier. 

Oliver, Krish, and Miaohe all provided reviews for v1, but I didn't feel
comfortable adding the tags to v2 because this is far from a straight
rebase.

v2: Rebased to kvm/queue, commit fb7333dfd812 ("KVM: SVM: fix calls ...").

 arch/x86/kvm/vmx/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bcb50724be38..adb11b504d5c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5672,7 +5672,7 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 {
 	u32 intr_info;
 
-	switch (exit_reason) {
+	switch ((u16)exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		intr_info = vmx_get_intr_info(vcpu);
 		if (is_nmi(intr_info))
@@ -5733,7 +5733,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	u32 intr_info;
 
-	switch (exit_reason) {
+	switch ((u16)exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		intr_info = vmx_get_intr_info(vcpu);
 		if (is_nmi(intr_info))
-- 
2.26.0

