Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728E7277992
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 21:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgIXTnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 15:43:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:31793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgIXTmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 15:42:55 -0400
IronPort-SDR: 41lHK3Z6RdKtA7GfkcZXKlHZsYJfBaZrLXjkBA2EkcYASvH7+5IQB3PDYcpV2fqBagH9v3IYXT
 2ZAODmOp/CSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149076385"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="149076385"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:42:52 -0700
IronPort-SDR: A/+uMWafT6EWXWKKO5iDn/P9CPytRGZ7xZ1tjaw9eMO7vtWPt+EPEhFrvFbnu3o/MFdSUzhmV3
 HVjswC92wVGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="347953041"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2020 12:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5]  KVM: VMX: Clean up RTIT MAXPHYADDR usage
Date:   Thu, 24 Sep 2020 12:42:45 -0700
Message-Id: <20200924194250.19137-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop using cpuid_query_maxphyaddr() for a random RTIT MSR check, unexport
said function to discourage future use, and do additional related cleanup.

Paolo, feel free to reorder/squash these as you see fit.  Five patches
feels more than a bit gratuitous, but every time I tried to squash things
I ended up with changelogs that ran on and on...

v2:
  - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
    feature on AMD").

Sean Christopherson (5):
  KVM: VMX: Use precomputed MAXPHYADDR for RTIT base MSR check
  KVM: x86: Unexport cpuid_query_maxphyaddr()
  KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK with helper function
  KVM: x86: Move illegal GPA helper out of the MMU code
  KVM: VMX: Use "illegal GPA" helper for PT/RTIT output base check

 arch/x86/kvm/cpuid.c   |  1 -
 arch/x86/kvm/cpuid.h   |  5 +++++
 arch/x86/kvm/mmu.h     |  5 -----
 arch/x86/kvm/mmu/mmu.c |  2 +-
 arch/x86/kvm/vmx/vmx.c | 13 ++++++++-----
 5 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.28.0

