Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C226914F98B
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgBASwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:11279 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgBASw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075480"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/61] KVM: x86: Drop redundant array size check
Date:   Sat,  1 Feb 2020 10:51:34 -0800
Message-Id: <20200201185218.24473-18-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop a "nent >= maxnent" check in kvm_get_cpuid() that's fully redundant
now that kvm_get_cpuid() isn't indexing the array to pass an entry to
do_cpuid_func().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f9cfc69199f0..6516fec361c1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -844,9 +844,6 @@ static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
 
 	limit = array->entries[array->nent - 1].eax;
 	for (func = func + 1; func <= limit; ++func) {
-		if (array->nent >= array->maxnent)
-			return -E2BIG;
-
 		r = do_cpuid_func(array, func, type);
 		if (r)
 			break;
-- 
2.24.1

