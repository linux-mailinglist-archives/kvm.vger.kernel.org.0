Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDB016762
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfEGQGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:42085 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEGQGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 09:06:42 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2019 09:06:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 00/15] KVM: nVMX: Optimize nested VM-Entry
Date:   Tue,  7 May 2019 09:06:25 -0700
Message-Id: <20190507160640.4812-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The majority of patches in this series are loosely related optimizations
to pick off low(ish) hanging fruit in nested VM-Entry, e.g. there are
many VMREADs and VMWRITEs that can be optimized away without too much
effort.

The major change (in terms of performance) is to not "put" the vCPU
state when switching between vmcs01 and vmcs02, which can reudce the
latency of a nested VM-Entry by upwards of 1000 cycles.

A few bug fixes are prepended as they touch code that happens to be
modified by the various optimizations.

Sean Christopherson (15):
  KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped
  KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value
  KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
  KVM: nVMX: Write ENCLS-exiting bitmap once per vmcs02
  KVM: nVMX: Don't rewrite GUEST_PML_INDEX during nested VM-Entry
  KVM: nVMX: Don't "put" vCPU or host state when switching VMCS
  KVM: nVMX: Don't reread VMCS-agnostic state when switching VMCS
  KVM: nVMX: Don't speculatively write virtual-APIC page address
  KVM: nVMX: Don't speculatively write APIC-access page address
  KVM: nVMX: Update vmcs12 for MSR_IA32_CR_PAT when it's written
  KVM: nVMX: Update vmcs12 for SYSENTER MSRs when they're written
  KVM: nVMX: Update vmcs12 for MSR_IA32_DEBUGCTLMSR when it's written
  KVM: nVMX: Update vmcs02 GUEST_IA32_DEBUGCTL only when vmcs12 is dirty
  KVM: nVMX: Don't update GUEST_BNDCFGS if it's clean in HV eVMCS
  KVM: nVMX: Copy PDPTRs to/from vmcs12 only when necessary

 arch/x86/kvm/vmx/nested.c | 142 +++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.c    |  93 +++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.h    |   5 +-
 3 files changed, 136 insertions(+), 104 deletions(-)

-- 
2.21.0

