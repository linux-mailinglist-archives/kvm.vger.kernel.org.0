Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8AC1EDC24
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 06:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgFDERJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 00:17:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:16104 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDERI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 00:17:08 -0400
IronPort-SDR: UtNw6hvOlDZdYbt12xOlrfJfSWOBksFqXNVKHxUawtL/IyEtVn0biCoTJ0Y8i+PmWiGyteyjie
 MiQnqlMDMecg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 21:17:08 -0700
IronPort-SDR: pT9a6wKXzrM+ieidBq3xAmrP+FCuj7BAtH3eZh6VKon148ga1t7N9JD1jIjMENjgD2ReP1SSvH
 euQ9AdxBkgNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,471,1583222400"; 
   d="scan'208";a="416782285"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2020 21:17:06 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2] KVM: x86: Assign correct value to array.maxnent
Date:   Thu,  4 Jun 2020 12:16:36 +0800
Message-Id: <20200604041636.1187-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
Reply-To: <20200604024304.14643-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delay the assignment of array.maxnent to use correct value for the case
cpuid->nent > KVM_MAX_CPUID_ENTRIES.

Fixes: e53c95e8d41e ("KVM: x86: Encapsulate CPUID entries and metadata in struct")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v2:
   - remove "const" of maxnent to fix build error.
---
 arch/x86/kvm/cpuid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 253b8e875ccd..3d88ddf781d0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -426,7 +426,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
-	const int maxnent;
+	int maxnent;
 	int nent;
 };
 
@@ -870,7 +870,6 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 
 	struct kvm_cpuid_array array = {
 		.nent = 0,
-		.maxnent = cpuid->nent,
 	};
 	int r, i;
 
@@ -887,6 +886,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	if (!array.entries)
 		return -ENOMEM;
 
+	array.maxnent = cpuid->nent;
+
 	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
 		r = get_cpuid_func(&array, funcs[i], type);
 		if (r)
-- 
2.18.2

