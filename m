Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164D63EE9E1
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 11:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhHQJcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 05:32:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:49582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhHQJcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 05:32:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238111494"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238111494"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:31:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="449200677"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2021 02:31:28 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v1 0/5] KVM/x86/nVMX: Add field existence support in VMCS12
Date:   Tue, 17 Aug 2021 17:31:08 +0800
Message-Id: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SDM[1] has stated that many VMCS fields' existence depend on some other
VMX feature's status.
In nested case, VMCS12 shall respect this, i.e., L0's VMCS configuration
for L1 has limited the L1's VMX "physical" capability, some vmcs12.fields
shall appear not exist when L1 vmread/vmwrite.

This patch set
1) Add a bitmap in nested_vmx to reflect vmcs12 fields' existence
2) Implement those update functions according to dependencies stated in SDM
and update dynamically
3) Make VMCS12 read/write respect this
4) Make nested MSR_IA32_VMX_VMCS_ENUM read-only and respect this

[1] Notes in SDM Vol.3, Appedix B FIELD ENCODING IN VMCS
---
This patch set is a follow-up to Sean's suggestion in ba1f82456b
(Dynamically compute max VMCS index for vmcs12).

Robert Hoo (5):
  KVM: x86: nVMX: Add vmcs12 field existence bitmap in nested_vmx
  KVM: x86: nVMX: Update VMCS12 fields existence when nVMX MSRs are set
  KVM: x86: nVMX: VMCS12 field's read/write respects field existence
    bitmap
  KVM: x86: nVMX: Respect vmcs12 field existence when calc
    vmx_vmcs_enum_msr
  KVM: x86: nVMX: Ignore user space set value to MSR_IA32_VMX_VMCS_ENUM

 arch/x86/kvm/vmx/nested.c |  68 +++++--
 arch/x86/kvm/vmx/nested.h |   1 +
 arch/x86/kvm/vmx/vmcs12.c | 363 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs12.h |  69 ++++++--
 arch/x86/kvm/vmx/vmx.c    |  17 +-
 arch/x86/kvm/vmx/vmx.h    |   3 +
 6 files changed, 499 insertions(+), 22 deletions(-)


base-commit: 32bdc01988413031c6e743714c2b40bdd773e5db
-- 
2.27.0

