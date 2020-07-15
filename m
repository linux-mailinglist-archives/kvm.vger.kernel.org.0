Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A89220335
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgGOEGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:16670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOEGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:01 -0400
IronPort-SDR: keFLI2pZFftDHBMkkaHIc3kzVRpmz8P2NqsA0yi9/+K9R5lvaJ1qIrsZWX4vD6Zdt4CmF/oj4Y
 XNLcJuyamPkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167478"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167478"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:01 -0700
IronPort-SDR: oLkwvnypvmrjiOV2yo8kXfycM+VsPm00teLTHWLLxxVaKBlwcl9+ijgnqqc48T1EM0ZxqhjFZ6
 k/LDhNNQntRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587000"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 21:06:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 0/7] KVM: nVMX: Bug fixes and cleanup
Date:   Tue, 14 Jul 2020 21:05:50 -0700
Message-Id: <20200715040557.5889-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix for a brutal segment caching bug that manifested as random nested
VM-Enter failures when running with unrestricted guest disabled.  A few
more bug fixes and cleanups for stuff found by inspection when hunting
down the caching issue.

Sean Christopherson (7):
  KVM: nVMX: Reset the segment cache when stuffing guest segs
  KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails
  KVM: nVMX: Explicitly check for valid guest state for !unrestricted
    guest
  KVM: nVMX: Move free_nested() below vmx_switch_vmcs()
  KVM: nVMX: Ensure vmcs01 is the loaded VMCS when freeing nested state
  KVM: nVMX: Drop redundant VMCS switch and free_nested() call
  KVM: nVMX: WARN on attempt to switch the currently loaded VMCS

 arch/x86/kvm/vmx/nested.c | 103 ++++++++++++++++++++------------------
 arch/x86/kvm/vmx/vmx.c    |   8 +--
 arch/x86/kvm/vmx/vmx.h    |  10 ++++
 3 files changed, 66 insertions(+), 55 deletions(-)

-- 
2.26.0

