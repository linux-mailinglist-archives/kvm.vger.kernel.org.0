Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BBE6B648E
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCLJ7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCLJ7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A89418168
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615087; x=1710151087;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cLuLDh1dabXh/Il+oBqSnsZQbww/KxrxM9p9WRh2vPg=;
  b=H6AcJqgq1ycF7Lb4cScKFSD13D07dFW0UMIIWTTPfeB89HuS5Y7PMfK9
   9oBZFAUKQVbl7dD7UBStuu8FEOjACxehabLmBf6o+/YEoELPvekHW7jWr
   q0ne60U8KjcbyYn2mt3SfLJwB03WSptiZGY5j3gXeEHGd4rK4VYKQvePf
   zYiNS7x1DLBSm3KTi7uU1z8RKmOC8gIW6min7LYjEh/dSA/obBCSMqmYl
   kCRrtr2yR64X8GXgbuqLBlP7/AEXwjBkb+hm/ocX5FmiEnouGGNhwnC7f
   EThc3k5t5De74btCm2l9R4K2QAcwawl5gLtsNdi+f4ns1iPSasbEnDjwG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344680"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344680"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627290"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627290"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:50 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-6 00/13] EPT Emulation
Date:   Mon, 13 Mar 2023 02:03:32 +0800
Message-Id: <20230312180345.1778588-1-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is part-6 of this RFC patches. It introduces EPT
emulation for pKVM on Intel platform.

Add EPT emulation through shadowing vEPT in host VM.

Host VM launches its guest, and manage such guest's memory through a EPT
page table maintained in host KVM. Meanwhile this EPT page table is
untrusted to pKVM, so pKVM shall not directly use this EPT as guest's
active EPT. To ensure isolating of guest memory for protected VM, pKVM
hypervisor shadows such guest's EPT in host KVM, to build out active EPT
page table after necessary check (the check is based on page state
management which will be introduced later). It's actually an emulation
for guest EPT page table, the guest EPT page table in host KVM is called
"virtual EPT", while the active EPT page table in pKVM is called "shadow
EPT".

Shadow EPT in pKVM is initialized with empty mapping. Guest EPT violation
leads to the EPT shadowing. The EPT shadowing first walks virtual EPT in
host VM to find out the virtual mapping, then setup the same mapping in
shadow EPT - this will be updated in the future to be managed by page
state.

And for invept emulation, just simply free all the mapping of shadow EPT
now.

pKVM on ARM is using PV ops to directly manage stage-2 MMU page table in
the hypervisor, while pKVM on Intel platform choose above EPT emulation
solution - it increases the complexity by doing EPT shadowing but avoids
changes in the KVM MMU code.

Chuanxiao Dong (12):
  pkvm: x86: Pre-define the maximum number of supported VMs
  pkvm: x86: init: Reserve memory for shadow EPT
  pkvm: x86: Initialize the shadow EPT pool
  pkvm: x86: Introduce shadow EPT
  pkvm: x86: Introduce vEPT to record guest EPT information
  pkvm: x86: Add API to get the max phys address bits
  pkvm: x86: Initialize ept_zero_check
  pkvm: x86: Add support for pKVM to handle the nested EPT violation
  pkvm: x86: Introduce PKVM_ASSERT
  pkvm: x86: add pkvm_pgtable_unmap_safe for a safe unmap
  pkvm: x86: Add INVEPT instruction emulation
  pkvm: x86: Switch to use shadow EPT for nested guests

Jason Chen CJ (1):
  pkvm: x86: Introduce shadow EPT invalidation support

 arch/x86/include/asm/kvm_pkvm.h           |  34 ++++
 arch/x86/kvm/vmx/pkvm/hyp/bug.h           |  23 +++
 arch/x86/kvm/vmx/pkvm/hyp/ept.c           | 238 +++++++++++++++++++++-
 arch/x86/kvm/vmx/pkvm/hyp/ept.h           |  24 +++
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c |  13 ++
 arch/x86/kvm/vmx/pkvm/hyp/memory.c        |  27 +++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h        |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c           |   4 +-
 arch/x86/kvm/vmx/pkvm/hyp/mmu.h           |   3 +-
 arch/x86/kvm/vmx/pkvm/hyp/nested.c        | 191 +++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h        |   1 +
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c       |  67 ++++--
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h       |   4 +-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c          |  36 +++-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h      |  32 +++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c        |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h           |  31 +++
 arch/x86/kvm/vmx/pkvm/pkvm_constants.c    |   3 +-
 arch/x86/kvm/vmx/pkvm/pkvm_host.c         |   3 +
 19 files changed, 711 insertions(+), 29 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/bug.h

-- 
2.25.1

