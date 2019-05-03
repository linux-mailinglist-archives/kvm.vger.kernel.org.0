Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D2812B48
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 12:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfECKJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 06:09:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:59997 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfECKJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 06:09:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 03:09:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,425,1549958400"; 
   d="scan'208";a="139552011"
Received: from khuang2-desk.gar.corp.intel.com ([10.254.24.58])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2019 03:09:12 -0700
From:   Kai Huang <kai.huang@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, junaids@google.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        guangrong.xiao@gmail.com, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, kai.huang@intel.com
Subject: [PATCH 0/2] Fix reserved bits calculation errors caused by MKTME
Date:   Fri,  3 May 2019 22:08:51 +1200
Message-Id: <cover.1556877940.git.kai.huang@linux.intel.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fix reserved bits related calculation errors caused by MKTME. MKTME
repurposes high bits of physical address bits as 'keyID' thus they are not
reserved bits, and to honor such HW behavior those reduced bits are taken away
from boot_cpu_data.x86_phys_bits when MKTME is detected (exactly how many bits
are taken away is configured by BIOS). Currently KVM asssumes bits from
boot_cpu_data.x86_phys_bits to 51 are reserved bits, which is not true anymore
with MKTME, and needs fix.

This series was splitted from the old patch I sent out around 2 weeks ago:

kvm: x86: Fix several SPTE mask calculation errors caused by MKTME

Changes to old patch:

  - splitted one patch into two patches. First patch is to move
    kvm_set_mmio_spte_mask() as prerequisite. It doesn't impact functionality.
    Patch 2 does the real fix.

  - renamed shadow_first_rsvd_bits to shadow_phys_bits suggested by Sean.

  - refined comments and commit msg to be more concise.

Btw sorry that I will be out next week and won't be able to reply email.

Kai Huang (2):
  kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
  kvm: x86: Fix reserved bits related calculation errors caused by MKTME

 arch/x86/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c | 31 ---------------------------
 2 files changed, 57 insertions(+), 35 deletions(-)

-- 
2.13.6

