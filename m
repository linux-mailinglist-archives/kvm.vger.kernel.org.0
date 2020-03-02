Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6117E17691D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgCCADC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:03:02 -0500
Received: from mga17.intel.com ([192.55.52.151]:37735 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgCBX5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384625"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 01/66] KVM: x86: Return -E2BIG when KVM_GET_SUPPORTED_CPUID hits max entries
Date:   Mon,  2 Mar 2020 15:56:04 -0800
Message-Id: <20200302235709.27467-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a long-standing bug that causes KVM to return 0 instead of -E2BIG
when userspace's array is insufficiently sized.

This technically breaks backwards compatibility, e.g. a userspace with a
hardcoded cpuid->nent could theoretically be broken as it would see an
error instead of success if cpuid->nent is less than the number of
entries required to fully enumerate the host CPU.  But, the lowest known
cpuid->nent hardcoded by a VMM is 100 (lkvm and selftests), and the
largest realistic limit on Intel and AMD is well under a 100.  E.g.
Intel's Icelake server with all the bells and whistles tops out at ~60
entries (variable due to SGX sub-leafs), and AMD's CPUID documentation
allows for less than 50 (KVM hard caps CPUID 0xD at a single sub-leaf).

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
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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

