Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680A71BB310
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgD1AyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:54:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:42479 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgD1AyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 20:54:23 -0400
IronPort-SDR: gsMD55yMjEWbZ8fYZbBny4aLLBGzT+ECLwt+Q4tuuWvovupcIPNPYHUr98ZLlq6lBxgS+66gs5
 PdYXVFRWiZEQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:54:23 -0700
IronPort-SDR: JQc3L9gG3VS4FzygtcdMVJkwfH3re0P7lqJ0dd+sbvkg+lU+h6U12rlxgp/ISB1DbRQuLCenlT
 w1W8bT4J7AFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="260920803"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 27 Apr 2020 17:54:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Barret Rhoden <brho@google.com>
Subject: [PATCH 0/3] KVM: x86/mmu: Use kernel's PG_LEVEL_* enums
Date:   Mon, 27 Apr 2020 17:54:19 -0700
Message-Id: <20200428005422.4235-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop KVM's PT_{PAGE_TABLE,DIRECTORY,PDPE}_LEVEL KVM enums in favor of the
kernel's PG_LEVEL_{4K,2M,1G} enums, which have far more user friendly
names.

The KVM names were presumably intended to abstract away the page size.  In
practice, the abstraction is only useful for a single line of code, a PSE
paging related large page check.  For everything else, the abstract names
do nothing but obfuscate the code.

Boot tested a PSE kernel under 32-bit KVM and 64-bit KVM, with and without
EPT enabled.  Patches 2 and 3 generate no binary difference relative to
patch 1 when compared via "objdump -d".

Sean Christopherson (3):
  KVM: x86/mmu: Tweak PSE hugepage handling to avoid 2M vs 4M conundrum
  KVM: x86/mmu: Move max hugepage level to a separate #define
  KVM: x86/mmu: Drop KVM's hugepage enums in favor of the kernel's enums

 arch/x86/include/asm/kvm_host.h |  13 +---
 arch/x86/kvm/mmu/mmu.c          | 118 +++++++++++++++-----------------
 arch/x86/kvm/mmu/page_track.c   |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  18 ++---
 arch/x86/kvm/mmu_audit.c        |   6 +-
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/x86.c              |   4 +-
 8 files changed, 79 insertions(+), 92 deletions(-)

-- 
2.26.0

