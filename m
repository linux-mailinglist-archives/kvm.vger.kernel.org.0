Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8085516B17
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfEGTSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:55700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfEGTSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 12:18:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2019 12:18:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 00/13]  KVM: VMX: Reduce VMWRITEs to VMCS controls
Date:   Tue,  7 May 2019 12:17:52 -0700
Message-Id: <20190507191805.9932-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The overarching theme of this series is to reduce the number of VMWRITEs
to VMCS controls.  VMWRITEs to the major VMCS controls, i.e. vm_entry,
vm_exit, pin, exec and sec_exec, are deceptively expensive.  CPUs with
VMCS caching (Westmere and later) also optimize away consistency checks
on VM-Entry, i.e. skip consistency checks if the relevant fields haven't
changed since the last successful VM-Entry (of the cached VMCS).
Because uops are a precious commodity, uCode's dirty VMCS field tracking
isn't as precise as software would prefer.  Notably, writing any of the
major VMCS fields effectively marks the entire VMCS dirty, i.e. causes
the next VM-Entry to perform all consistency checks, which consumes
several hundred cycles.

The majority of this series is technically vanilla VMX, but the end goal
of nearly every patch is to eliminate VMWRITEs to controls when running
nested guests, e.g. much of the series resolves around shadowing the
various controls so that they don't need to be rewritten to vmcs02 on
every nested VM-Entry.

The sole patch that is purely vanilla VMX is to avoid writing pin
controls when disabling/enabling the preemption timer.  This is the
last known known case where semi-frequent writes to control fields
can be avoided (in non-nested operation).  E.g. detecting IRQ windows
frequently toggles VIRTUAL_INTR_PENDING, but at this juncture that
behavior is effectively unavoidable.  Resolving the preemption timer
case takes a somewhat adventurous approach of leaving the timer running
even when it's not in use.

Sean Christopherson (13):
  KVM: nVMX: Use adjusted pin controls for vmcs02
  KVM: VMX: Add builder macros for shadowing controls
  KVM: VMX: Shadow VMCS pin controls
  KVM: VMX: Shadow VMCS primary execution controls
  KVM: VMX: Shadow VMCS secondary execution controls
  KVM: nVMX: Shadow VMCS controls on a per-VMCS basis
  KVM: nVMX: Don't reset VMCS controls shadow on VMCS switch
  KVM: VMX: Explicitly initialize controls shadow at VMCS allocation
  KVM: nVMX: Preserve last USE_MSR_BITMAPS when preparing vmcs02
  KVM: nVMX: Preset *DT exiting in vmcs02 when emulating UMIP
  KVM: VMX: Drop hv_timer_armed from 'struct loaded_vmcs'
  KVM: nVMX: Don't mark vmcs12 as dirty when L1 writes pin controls
  KVM: VMX: Leave preemption timer running when it's disabled

 arch/x86/kvm/vmx/nested.c |  54 ++++++-------
 arch/x86/kvm/vmx/vmcs.h   |  11 ++-
 arch/x86/kvm/vmx/vmx.c    | 156 +++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    |  92 +++++++---------------
 4 files changed, 145 insertions(+), 168 deletions(-)

-- 
2.21.0

