Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC88C204316
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 23:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgFVV6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 17:58:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:15498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVV6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 17:58:35 -0400
IronPort-SDR: KRvkcQRT4rBNCr/B1TE60VYKH5cLZXHpRpq1ncq91NPWlGvODwT812H1YPbfF3TZ/+8krUAwxS
 8sveclPsje3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142148017"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142148017"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 14:58:34 -0700
IronPort-SDR: LSYAsMODyMOxQuUrr1xHH7LlZh+uKR68WRuRiXJlBaJjIzaCCo/v0DqzSskgDc6DO3RqBjo+d0
 XbSi2dPDo16w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="300987312"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jun 2020 14:58:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: x86: nVMX: Nested PML bug fix and cleanup
Date:   Mon, 22 Jun 2020 14:58:28 -0700
Message-Id: <20200622215832.22090-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix for a theoretical bug in nested PML emulation, and additional clean up
of the related code.

Tested by doing a few rounds of intra-VM migration (same L1) of an L2
guest with PML confirmed enabled in L1.

This has a trivial conflict with patch 3 of the MMU files series[*], both
remove function prototypes from mmu.h.

[*] https://lkml.kernel.org/r/20200622202034.15093-4-sean.j.christopherson@intel.com

Sean Christopherson (4):
  KVM: nVMX: Plumb L2 GPA through to PML emulation
  KVM: x86/mmu: Drop kvm_arch_write_log_dirty() wrapper
  KVM: nVMX: WARN if PML emulation helper is invoked outside of nested
    guest
  KVM: x86/mmu: Make .write_log_dirty a nested operation

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.h              |  1 -
 arch/x86/kvm/mmu/mmu.c          | 15 -------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++---
 arch/x86/kvm/vmx/nested.c       | 38 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 37 --------------------------------
 6 files changed, 43 insertions(+), 57 deletions(-)

-- 
2.26.0

