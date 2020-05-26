Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094E31AB039
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 20:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416525AbgDORzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:55:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:26430 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437449AbgDORz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:26 -0400
IronPort-SDR: SD3kBL3/MNWGAxxXyJ8CSTsfictFCgpK4W8UjKtnaC9F4ZKATkMBp+L717QKbjfk7zvC9JK+wF
 L/H/BOn/7XRA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:22 -0700
IronPort-SDR: 9AQT2fPHHcmbXSk8vc4uuwqSR7T8sOOIjmbcjQpiEI14xL/xSQtIw7BdQ8c7nA1Iq1cyje/nPa
 K7/h1ke/QmMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567335"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2020 10:55:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 00/10]  KVM: VMX: Unionize vcpu_vmx.exit_reason
Date:   Wed, 15 Apr 2020 10:55:09 -0700
Message-Id: <20200415175519.14230-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the exit_reason field in struct vcpu_vmx from a vanilla u32 to a
union, (ab)using the union to provide access to the basic exit reason and
flags.

There is a fairly substantial delta relative to v1, as I ran with Vitaly's
suggestion to split nested_vmx_exit_reflected() into VM-Fail, "L0 wants"
and "L1 wants", and move the tracepoint into nested_vmx_reflect_vmexit().
IMO, this yields cleaner and more understandable code overall, and helps
eliminate caching the basic exit reason (see below) by avoiding large
functions that repeatedly query the basic exit reason.  The refactoring
isn't strictly related to making exit_reason a union, but the code would
conflict horribly and the end code nicely demonstrates the value of using
a union for the exit reason.

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

v2:
  - Don't snapshot the basic exit reason, i.e. either use vmx->exit_reason
    directly or snapshot the whole thing.  The resulting code is similar
    to Xiaoyao's original patch, e.g. vmx_handle_exit() now uses
    "exit_reason.basic" instead of "exit_reason" to reference the basic
    exit reason.
  - Split nested_vmx_exit_reflected() into VM-Fail, "L0 wants" and "L1
    wants", and move the tracepoint into nested_vmx_reflect_vmexit().
    [Vitaly]
  - Use a "union vmx_exit_reason exit_reason" to handle a consistency
    check VM-Exit on VM-Enter in nested_vmx_enter_non_root_mode() to avoid
    some implicit casting shenanigans. [Vitaly]
  - Collect tags. [Vitaly]

v1: https://lkml.kernel.org/r/20200312184521.24579-1-sean.j.christopherson@intel.com


Sean Christopherson (10):
  KVM: nVMX: Move reflection check into nested_vmx_reflect_vmexit()
  KVM: nVMX: Uninline nested_vmx_reflect_vmexit(), i.e. move it to
    nested.c
  KVM: nVMX: Move VM-Fail check out of nested_vmx_exit_reflected()
  KVM: nVMX: Move nested VM-Exit tracepoint into
    nested_vmx_reflect_vmexit()
  KVM: nVMX: Split VM-Exit reflection logic into L0 vs. L1 wants
  KVM: nVMX: Drop a superfluous WARN on reflecting EXTERNAL_INTERRUPT
  KVM: nVMX: Pull exit_reason from vcpu_vmx in
    nested_vmx_reflect_vmexit()
  KVM: nVMX: Cast exit_reason to u16 to check for nested
    EXTERNAL_INTERRUPT
  KVM: nVMX: Rename exit_reason to vm_exit_reason for nested VM-Exit
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/kvm/vmx/nested.c | 237 +++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/nested.h |  32 +----
 arch/x86/kvm/vmx/vmx.c    |  66 ++++++-----
 arch/x86/kvm/vmx/vmx.h    |  25 +++-
 4 files changed, 219 insertions(+), 141 deletions(-)

-- 
2.26.0

