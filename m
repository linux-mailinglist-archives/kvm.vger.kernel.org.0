Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8741768F2
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgCCABK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:17170 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727372AbgCBX51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384783"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 53/66] KVM: x86: Do kvm_cpuid_array capacity checks in terminal functions
Date:   Mon,  2 Mar 2020 15:56:56 -0800
Message-Id: <20200302235709.27467-54-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perform the capacity checks on the userspace provided kvm_cpuid_array
in the lower __do_cpuid_func() and __do_cpuid_func_emulated().
Pre-checking the array in do_cpuid_func() no longer adds value now that
__do_cpuid_func() has been trimmed down to size, i.e. doesn't invoke a
big pile of retpolined functions before doing anything useful.

Note, __do_cpuid_func() already checks the array capacity via
do_host_cpuid(), "moving" the check to __do_cpuid_func() simply means
removing a WARN_ON().

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index eebd7f613f67..f879fcbd6fb2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -478,8 +478,12 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 
 static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 {
-	struct kvm_cpuid_entry2 *entry = &array->entries[array->nent];
+	struct kvm_cpuid_entry2 *entry;
 
+	if (array->nent >= array->maxnent)
+		return -E2BIG;
+
+	entry = &array->entries[array->nent];
 	entry->function = func;
 	entry->index = 0;
 	entry->flags = 0;
@@ -516,7 +520,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	r = -E2BIG;
 
 	entry = do_host_cpuid(array, function, 0);
-	if (WARN_ON(!entry))
+	if (!entry)
 		goto out;
 
 	switch (function) {
@@ -787,9 +791,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
 			 unsigned int type)
 {
-	if (array->nent >= array->maxnent)
-		return -E2BIG;
-
 	if (type == KVM_GET_EMULATED_CPUID)
 		return __do_cpuid_func_emulated(array, func);
 
-- 
2.24.1

