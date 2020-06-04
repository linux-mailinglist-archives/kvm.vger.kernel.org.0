Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D361EDB4C
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 04:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFDCnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 22:43:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:46889 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgFDCnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 22:43:14 -0400
IronPort-SDR: hjdir4Z+gMysQacx1M3TC3DWxl5U9n+aAubNzoOCNDb6isU2OrIa+ZVsOu0PvVo/XtjwEW3LPk
 Q+DosVcEIOgA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 19:43:13 -0700
IronPort-SDR: DMUHMEnWDRklmY95LvDL49LiNPEhLY0j5aBlXnFuymzxcclPQ0W7K8iq9sRmao+y2ZCW0h8oBZ
 Prw2wBpmEtlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,470,1583222400"; 
   d="scan'208";a="304571640"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by fmsmga002.fm.intel.com with ESMTP; 03 Jun 2020 19:43:11 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: x86: Assign correct value to array.maxnent
Date:   Thu,  4 Jun 2020 10:43:04 +0800
Message-Id: <20200604024304.14643-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delay the assignment of array.maxnent to use correct value for the case
cpuid->nent > KVM_MAX_CPUID_ENTRIES.

Fixes: e53c95e8d41e ("KVM: x86: Encapsulate CPUID entries and metadata in struct")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 253b8e875ccd..befff01d100c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
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

