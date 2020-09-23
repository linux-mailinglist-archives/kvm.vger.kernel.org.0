Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9059F27637E
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIWWE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:04:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:60138 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIWWE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:04:27 -0400
IronPort-SDR: hZJCBN3wvXXHfsSb94AwEm1htFsxaq8VIsV4Juj+AuI+bVL/bPK+cYo00o/H0jRBigRAFDXhm2
 d68LcKNxh0tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158381351"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158381351"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:04:26 -0700
IronPort-SDR: SbBoppeSUtxVda/CYgowXFdVBdZnT58iPc+A9OzyJMZASltR2sLt4NyW4SnQpM3FYwtnYDkMxm
 +lwKs46mjqjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335647632"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2020 15:04:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 0/4] KVM: x86/mmu: Page fault handling cleanups
Date:   Wed, 23 Sep 2020 15:04:21 -0700
Message-Id: <20200923220425.18402-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanups for page fault handling that were encountered during early TDX
enabling, but are worthwhile on their own.  Specifically, patch 4 fixes an
issue where KVM doesn't detect a spurious page fault (due to the fault
being fixed by a different pCPU+vCPU) and does the full gamut of writing
the SPTE, updating stats, and prefetching SPTEs.

Sean Christopherson (4):
  KVM: x86/mmu: Return -EIO if page fault returns RET_PF_INVALID
  KVM: x86/mmu: Invert RET_PF_* check when falling through to emulation
  KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed
  KVM: x86/mmu: Bail early from final #PF handling on spurious faults

 arch/x86/kvm/mmu/mmu.c         | 70 +++++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmutrace.h    | 13 +++----
 arch/x86/kvm/mmu/paging_tmpl.h |  3 ++
 3 files changed, 52 insertions(+), 34 deletions(-)

-- 
2.28.0

