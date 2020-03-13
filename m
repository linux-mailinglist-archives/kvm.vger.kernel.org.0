Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB721838F0
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCLSqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:46:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:23434 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgCLSpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041225"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2020 11:45:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 00/10] KVM: VMX: Unionize vcpu_vmx.exit_reason
Date:   Thu, 12 Mar 2020 11:45:11 -0700
Message-Id: <20200312184521.24579-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the exit_reason field in struct vcpu_vmx from a vanilla u32 to a
union, (ab)using the union to provide access to the basic exit reason and
flags.

There are three motivating factors for making exit_reason a union:

  - Help avoid bugs where a basic exit reason is compared against the full
    exit reason, e.g. there have been two bugs where MCE_DURING_VMENTRY
    was incorrectly compared against the full exit reason.

  - Clarify the intent of related flows, e.g. exit_reason is used for both
    "basic exit reason" and "full exit reason", and it's not always clear
    which of the two is intended without a fair bit of digging.

  - Prepare for future Intel features, e.g. SGX, that add new exit flags
    that are less restricted than FAILED_VMENTRY, i.e. can be set on what
    is otherwise a standard VM-Exit.

Sean Christopherson (10):
  KVM: nVMX: Move reflection check into nested_vmx_reflect_vmexit()
  KVM: nVMX: Drop a superfluous WARN on reflecting EXTERNAL_INTERRUPT
  KVM: nVMX: Pull exit_reason from vcpu_vmx in
    nested_vmx_exit_reflected()
  KVM: VMX: Convert local exit_reason to u16 in
    nested_vmx_exit_reflected()
  KVM: VMX: Convert local exit_reason to u16 in vmx_handle_exit()
  KVM: nVMX: Convert local exit_reason to u16 in
    ...enter_non_root_mode()
  KVM: nVMX: Cast exit_reason to u16 to check for nested
    EXTERNAL_INTERRUPT
  KVM: nVMX: Rename exit_reason to vm_exit_reason for nested VM-Exit
  KVM: VMX: Cache vmx->exit_reason in local u16 in
    vmx_handle_exit_irqoff()
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/kvm/vmx/nested.c | 49 +++++++++++++++++++++++----------------
 arch/x86/kvm/vmx/nested.h | 28 ++++++++++++----------
 arch/x86/kvm/vmx/vmx.c    | 39 +++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++++++++-
 4 files changed, 90 insertions(+), 51 deletions(-)

-- 
2.24.1

