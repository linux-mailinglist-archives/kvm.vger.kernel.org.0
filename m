Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFEDBFB08
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 23:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfIZVnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 17:43:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:8270 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbfIZVnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 17:43:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 14:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="192958527"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 26 Sep 2019 14:43:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Subject: [PATCH 0/2] KVM: nVMX: Bug fix for consuming stale vmcs02.GUEST_CR3
Date:   Thu, 26 Sep 2019 14:43:00 -0700
Message-Id: <20190926214302.21990-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reto Buerki reported a failure in a nested VMM when running with HLT
interception disabled in L1.  When putting L2 into HLT, KVM never actually
enters L2 and instead cancels the nested run and pretends that VM-Enter to
L2 completed and then exited on HLT (which KVM intercepted).  Because KVM
never actually runs L2, KVM skips the pending MMU update for L2 and so
leaves a stale value in vmcs02.GUEST_CR3.  If the next wake event for L2
triggers a nested VM-Exit, KVM will refresh vmcs12->guest_cr3 from
vmcs02.GUEST_CR3 and consume the stale value.

Fix the issue by unconditionally writing vmcs02.GUEST_CR3 during nested
VM-Enter instead of deferring the update to vmx_set_cr3(), and skip the
update of GUEST_CR3 in vmx_set_cr3() when running L2.  I.e. make the
nested code fully responsible for vmcs02.GUEST_CR3.

I really wanted to go with a different fix of handling this as a one-off
case in the HLT flow (in nested_vmx_run()), and then following that up
with a cleanup of VMX's CR3 handling, e.g. to do proper dirty tracking
instead of having the nested code do manual VMREADs and VMWRITEs.  I even
went so far as to hide vcpu->arch.cr3 (put CR3 in vcpu->arch.regs), but
things went south when I started working through the dirty tracking logic.

Because EPT can be enabled *without* unrestricted guest, enabling EPT
doesn't always mean GUEST_CR3 really is the guest CR3 (unlike SVM's NPT).
And because the unrestricted guest handling of GUEST_CR3 is dependent on
whether the guest has paging enabled, VMX can't even do a clean handoff
based on unrestricted guest.  In a nutshell, dynamically handling the
transitions of GUEST_CR3 ownership in VMX is a nightmare, so fixing this
purely within the context of nested VMX turned out to be the cleanest fix.

Sean Christopherson (2):
  KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
  KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date

 arch/x86/kvm/vmx/nested.c |  8 ++++++++
 arch/x86/kvm/vmx/vmx.c    | 15 ++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

-- 
2.22.0

