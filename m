Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE0A14FA0D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgBAS55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:57:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:37509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgBASw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075431"
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
Subject: [PATCH 01/61] KVM: x86: Return -E2BIG when KVM_GET_SUPPORTED_CPUID hits max entries
Date:   Sat,  1 Feb 2020 10:51:18 -0800
Message-Id: <20200201185218.24473-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a long-standing bug that causes KVM to return 0 instead of -E2BIG
when userspace's array is insufficiently sized.

Note, while the Fixes: tag is accurate with respect to the immediate
bug, it's likely that similar bugs in KVM_GET_SUPPORTED_CPUID existed
prior to the refactoring, e.g. Qemu contains a workaround for the broken
KVM_GET_SUPPORTED_CPUID behavior that predates the buggy commit by over
two years.  The Qemu workaround is also likely the main reason the bug
has gone unreported for so long.

Qemu hack:
  commit 76ae317f7c16aec6b469604b1764094870a75470
  Author: Mark McLoughlin <markmc@redhat.com>
  Date:   Tue May 19 18:55:21 2009 +0100

    kvm: work around supported cpuid ioctl() brokenness

    KVM_GET_SUPPORTED_CPUID has been known to fail to return -E2BIG
    when it runs out of entries. Detect this by always trying again
    with a bigger table if the ioctl() fills the table.

Fixes: 831bf664e9c1f ("KVM: Refactor and simplify kvm_dev_ioctl_get_supported_cpuid")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..47ce04762c20 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -908,9 +908,14 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 			goto out_free;
 
 		limit = cpuid_entries[nent - 1].eax;
-		for (func = ent->func + 1; func <= limit && nent < cpuid->nent && r == 0; ++func)
+		for (func = ent->func + 1; func <= limit && r == 0; ++func) {
+			if (nent >= cpuid->nent) {
+				r = -E2BIG;
+				goto out_free;
+			}
 			r = do_cpuid_func(&cpuid_entries[nent], func,
 				          &nent, cpuid->nent, type);
+		}
 
 		if (r)
 			goto out_free;
-- 
2.24.1

