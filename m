Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425E3169C3B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 03:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgBXCND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 21:13:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:24747 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXCND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 21:13:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 18:13:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,478,1574150400"; 
   d="scan'208";a="255437173"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga002.jf.intel.com with ESMTP; 23 Feb 2020 18:13:00 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 0/2] KVM: VMX: Use basic exit reason for cheking and indexing
Date:   Mon, 24 Feb 2020 10:07:49 +0800
Message-Id: <20200224020751.1469-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current KVM directly uses the whole 32-bit EXIT REASON when
1) checking: if (vmx->exit_reason == EXIT_REASON_*)
2) indexing: kvm_vmx_exit_handlers[exit_reason]

However, only the low 16-bit of EXIT REASON serves as basic Exit Reason.
Fix it by using the 16-bit basic exit reason.

BTW, I'm not sure if it's necessary to split nested case into a seperate
patch.

Xiaoyao Li (2):
  kvm: vmx: Use basic exit reason to check if it's the specific VM EXIT
  kvm: nvmx: Use basic(exit_reason) when checking specific EXIT_REASON

 arch/x86/kvm/vmx/nested.c |  6 +++---
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 44 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 4 files changed, 29 insertions(+), 25 deletions(-)

-- 
2.23.0

