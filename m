Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21CFFEF3
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 19:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfD3RgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 13:36:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:32357 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfD3RgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 13:36:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 10:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="166341319"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga002.fm.intel.com with ESMTP; 30 Apr 2019 10:36:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: Drop "caching" of always-available GPRs
Date:   Tue, 30 Apr 2019 10:36:16 -0700
Message-Id: <20190430173619.15774-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM's GPR caching logic is unconditionally emitted for all GPR accesses
(that go through the accessors), even when the register being accessed
is fixed and always available.  This bloats KVM due to the instructions
needed to test and set the available/dirty bitmaps, and to conditionally
invoke the .cache_reg() callback.  The latter is especially painful when
compiling with retpolines.

Eliminate the unnecessary overhead by:

 - Adding dedicated accessors for every GPR
 - Omitting the caching logic for GPRs that are always available
 - Preventing use of the unoptimized versions for fixed accesses

The last patch is an opportunistic clean up of VMX, which has gradually
acquired a bad habit of sprinkling in direct access to GPRs.

Sean Christopherson (3):
  KVM: x86: Omit caching logic for always-available GPRs
  KVM: x86: Prevent use of kvm_register_{read,write}() with known GPRs
  KVM: VMX: Use accessors for GPRs outside of dedicated caching logic

 arch/x86/kvm/cpuid.c          | 12 ++---
 arch/x86/kvm/hyperv.c         | 24 ++++-----
 arch/x86/kvm/kvm_cache_regs.h | 73 +++++++++++++++++++++++----
 arch/x86/kvm/svm.c            | 34 ++++++-------
 arch/x86/kvm/vmx/nested.c     | 18 +++----
 arch/x86/kvm/vmx/vmx.c        | 14 +++---
 arch/x86/kvm/x86.c            | 93 +++++++++++++++++------------------
 7 files changed, 159 insertions(+), 109 deletions(-)

-- 
2.21.0

