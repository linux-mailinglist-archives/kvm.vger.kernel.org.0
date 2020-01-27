Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B8F149E07
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 01:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgA0AlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 19:41:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:63120 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0AlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 19:41:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 16:41:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,367,1574150400"; 
   d="scan'208";a="223116774"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2020 16:41:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: VM alloc bug fix and cleanup
Date:   Sun, 26 Jan 2020 16:41:10 -0800
Message-Id: <20200127004113.25615-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a (fairly) long standing NULL pointer dereference if VM allocation
fails, and do a bit of clean up on top.

I would have preferred to omit patch 01, i.e. fix the bug via patch 02,
but unfortunately (long term support) kernel 4.19 doesn't have the
accounting changes, which would make backporting the fix extra annoying
for no real benefit.

Sean Christopherson (3):
  KVM: x86: Gracefully handle __vmalloc() failure during VM allocation
  KVM: x86: Directly return __vmalloc() result in ->vm_alloc()
  KVM: x86: Consolidate VM allocation and free for VMX and SVM

 arch/x86/include/asm/kvm_host.h | 12 ++++--------
 arch/x86/kvm/svm.c              | 15 ++++-----------
 arch/x86/kvm/vmx/vmx.c          | 16 ++++------------
 arch/x86/kvm/x86.c              |  7 +++++++
 4 files changed, 19 insertions(+), 31 deletions(-)

-- 
2.24.1

