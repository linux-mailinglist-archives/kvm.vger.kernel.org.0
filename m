Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BB0283FEC
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 21:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgJETz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 15:55:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:42027 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbgJETzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 15:55:54 -0400
IronPort-SDR: oOb/qjoUubOY4mdg4Jm46SdoBitMgepHPkMNo3nb8wXlqDA/JtsIdCeqT+teDGqHnUuhVh9AOd
 UfGxuB607UFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="181660130"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="181660130"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 12:55:38 -0700
IronPort-SDR: Qn6dcXyLS9GLxdy9yfod/VbkNOasp1nJSKcc4UGx8m5yfFHOpyna3foH/aVvptK8KO5ec9W/oh
 YLRX3kjIi0AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="353550141"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2020 12:55:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 0/2] KVM: VMX: x2APIC + APICV MSR fix and cleanup
Date:   Mon,  5 Oct 2020 12:55:30 -0700
Message-Id: <20201005195532.8674-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 is an unofficial patch from Peter to fix x2APIC MSR interception
on non-APICV systems.  As Peter suggested, it really should be squashed
with commit 3eb900173c71 ("KVM: x86: VMX: Prevent MSR passthrough when MSR
access is denied").  Without the fix, KVM is completely busted on
non-APICV systems.

Patch 2 is a cleanup of sorts to revert back to the pre-filtering approach
of initializing the x2APIC MSR bitmaps for APICV.

Note, I haven't tested on an APICV system.  My APICV system appears to
have crashed over the weekend and I haven't yet journeyed back to the
lab to kick it.

Peter Xu (1):
  KVM: VMX: Fix x2APIC MSR intercept handling on !APICV platforms

Sean Christopherson (1):
  KVM: VMX: Ignore userspace MSR filters for x2APIC when APICV is
    enabled

 arch/x86/kvm/vmx/vmx.c | 45 ++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 15 deletions(-)

-- 
2.28.0

