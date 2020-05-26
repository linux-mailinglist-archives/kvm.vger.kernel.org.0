Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618BD1AB2BB
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 22:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371305AbgDOUfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:35:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:20837 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371264AbgDOUe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 16:34:58 -0400
IronPort-SDR: DP5nnSE+MmmAeKfpA0yX+bamlUS0wVBXYZ+QRIjdlsucDxXKT06zbkqlkb6oq9HLuBkug0dznu
 i9SBaY47Hn2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 13:34:57 -0700
IronPort-SDR: +eCiecRj5JwTD4XQ78Xz6RJ7HDntOl0+gxxtmn2Hag9EQuNFUnoGbbzTmLeZb+XnnCeFMoktER
 gVqknUIC4bkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="288657636"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2020 13:34:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: VMX: Add caching of EXIT_QUAL and INTR_INFO
Date:   Wed, 15 Apr 2020 13:34:49 -0700
Message-Id: <20200415203454.8296-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 4-5 are the focus of this series, adding caching of
vmcs.EXIT_QUALIFICATION and proper caching of vmcs.INTR_INFO (instead of
caching it with ad hoc rules about when it's available).  Patches 1-3
are prep work to clean up the register caching to ensure correctness when
switching between vmcs01 and vmcs02.

The idea for this came about when working on the "unionize exit_reason"
series.  The nested VM-Exit logic looks at both fields multiple times,
which is ok-ish when everything is crammed into one or two functions, but
incurs multiple VMREADs when split up.  I really didn't want to solve that
issue by piling on more cases where vmx->exit_intr_info would be valid, or
by duplicating that fragile pattern for exit_qualification.

Paolo, this will conflict with the "unionize exit_reason" series, though
the conflict resolution is all mechnical in nature.  Let me know if you
want me to respin one on top of the other, send a single series, etc...

Sean Christopherson (5):
  KVM: nVMX: Invoke ept_save_pdptrs() if and only if PAE paging is
    enabled
  KVM: nVMX: Reset register cache (available and dirty masks) on VMCS
    switch
  KVM: nVMX: Drop manual clearing of segment cache on nested VMCS switch
  KVM: VMX: Cache vmcs.EXIT_QUALIFICATION using arch avail_reg flags
  KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/vmx/nested.c       | 29 +++++++------
 arch/x86/kvm/vmx/nested.h       |  4 +-
 arch/x86/kvm/vmx/vmx.c          | 73 ++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h          | 35 +++++++++++++++-
 5 files changed, 86 insertions(+), 57 deletions(-)

-- 
2.26.0

