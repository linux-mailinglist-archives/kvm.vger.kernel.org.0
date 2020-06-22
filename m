Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886262043FA
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbgFVWpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:45:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:27426 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731148AbgFVWmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:55 -0400
IronPort-SDR: xW5vWn627KCA1Z+btIlISv/mAMOUB/SompzMbhLVuzAtP8a+i7Wv83VE7/CpxzgPgMK5gUbpRR
 NgM2YnU001Yw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303562"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303562"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:51 -0700
IronPort-SDR: dbQNUkpwSHjIswhH8lQ0KEewh9wNZtJKkbw6ixYaeEOhJkIdzJMIOBeGqqAyyr3c5jbTIYnFT0
 sN9a8ZXW76zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634905"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] KVM: VMX: Prepend "MAX_" to MSR array size defines
Date:   Mon, 22 Jun 2020 15:42:36 -0700
Message-Id: <20200622224249.29562-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add "MAX" to the LOADSTORE and so called SHARED MSR defines to make it
more clear that the define controls the array size, as opposed to the
actual number of valid entries that are in the array.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  6 +++---
 arch/x86/kvm/vmx/vmx.h    | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index adb11b504d5c..df33878ff612 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1035,7 +1035,7 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 	in_vmcs12_store_list = nested_msr_store_list_has_msr(vcpu, msr_index);
 
 	if (in_vmcs12_store_list && !in_autostore_list) {
-		if (autostore->nr == NR_LOADSTORE_MSRS) {
+		if (autostore->nr == MAX_NR_LOADSTORE_MSRS) {
 			/*
 			 * Emulated VMEntry does not fail here.  Instead a less
 			 * accurate value will be returned by
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ea79a02d905c..19e6f697affb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -931,8 +931,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	if (!entry_only)
 		j = vmx_find_msr_index(&m->host, msr);
 
-	if ((i < 0 && m->guest.nr == NR_LOADSTORE_MSRS) ||
-		(j < 0 &&  m->host.nr == NR_LOADSTORE_MSRS)) {
+	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
+	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
 		printk_once(KERN_WARNING "Not enough msr switch entries. "
 				"Can't add msr %x\n", msr);
 		return;
@@ -6891,7 +6891,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vpid;
 	}
 
-	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS);
+	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != MAX_NR_SHARED_MSRS);
 
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
 		u32 index = vmx_msr_index[i];
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8a83b5edc820..4c053d204bea 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -21,16 +21,16 @@ extern const u32 vmx_msr_index[];
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
 #ifdef CONFIG_X86_64
-#define NR_SHARED_MSRS	7
+#define MAX_NR_SHARED_MSRS	7
 #else
-#define NR_SHARED_MSRS	4
+#define MAX_NR_SHARED_MSRS	4
 #endif
 
-#define NR_LOADSTORE_MSRS 8
+#define MAX_NR_LOADSTORE_MSRS	8
 
 struct vmx_msrs {
 	unsigned int		nr;
-	struct vmx_msr_entry	val[NR_LOADSTORE_MSRS];
+	struct vmx_msr_entry	val[MAX_NR_LOADSTORE_MSRS];
 };
 
 struct shared_msr_entry {
@@ -217,7 +217,7 @@ struct vcpu_vmx {
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
-	struct shared_msr_entry guest_msrs[NR_SHARED_MSRS];
+	struct shared_msr_entry guest_msrs[MAX_NR_SHARED_MSRS];
 	int                   nmsrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
-- 
2.26.0

