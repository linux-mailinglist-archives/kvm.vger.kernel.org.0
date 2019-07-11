Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF4965B1C
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 17:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfGKP6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 11:58:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:21774 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbfGKP6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 11:58:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 08:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="365312094"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jul 2019 08:58:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH v3 0/2] KVM: nVMX: add tracepoints for nested VM-Enter failures
Date:   Thu, 11 Jul 2019 08:58:28 -0700
Message-Id: <20190711155830.15178-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Debugging VM-Enter failures has been the bane of my existence for years.
Seeing KVM's VMCS dump format pop up on a console triggers a Pavlovian
response of swear words and sighs.  As KVM's coverage of VM-Enter checks
improve, so too do the odds of being able to triage/debug a KVM (or any
other hypervisor) bug by running the bad KVM build as an L1 guest.

Improve support for using KVM to debug a buggy VMM by adding tracepoints
to capture the basic gist of a VM-Enter failure so that extracting said
information from KVM doesn't require attaching a debugger or modifying
L0 KVM to manually log failures.

The captured information is by no means complete or perfect, e.g. I'd
love to capture *exactly* why a consistency check failed, but logging
that level of detail would require invasive code changes and might even
act as a deterrent to adding more checks in KVM.

v3: Fix a minor snafu in the v2 rebase, and re-rebase to kvm/next
    (a45ff5994c9c, "Merge tag 'kvm-arm-for-5.3'...")

v2: Rebase to kvm/queue.

Sean Christopherson (2):
  KVM: nVMX: add tracepoint for failed nested VM-Enter
  KVM: nVMX: trace nested VM-Enter failures detected by H/W

 arch/x86/include/asm/vmx.h |  14 ++
 arch/x86/kvm/trace.h       |  22 +++
 arch/x86/kvm/vmx/nested.c  | 269 ++++++++++++++++++++-----------------
 arch/x86/kvm/x86.c         |   1 +
 4 files changed, 179 insertions(+), 127 deletions(-)

-- 
2.22.0

