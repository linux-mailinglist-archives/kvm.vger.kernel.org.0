Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35ACE51687D
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355515AbiEAWLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiEAWLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:11:22 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76AC1C93F;
        Sun,  1 May 2022 15:07:54 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjB-0008MV-VJ; Mon, 02 May 2022 00:07:42 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/12] KVM: SVM: Fix soft int/ex re-injection
Date:   Mon,  2 May 2022 00:07:24 +0200
Message-Id: <cover.1651440202.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

This series is an updated version of Sean's SVM soft interrupt/exception
re-injection fixes patch set, which in turn extended and generalized my
nSVM L1 -> L2 event injection fixes series.

Detailed list of changes in this version:
* "Downgraded" the commit affecting !nrips CPUs to just drop nested SVM
support for such parts instead of SVM support in general,

* Removed the BUG_ON() from svm_inject_irq() completely, instead of
replacing it with WARN() - Maxim has pointed out it can still be triggered
by userspace via KVM_SET_VCPU_EVENTS,

* Updated the new KVM self-test to switch to an alternate IDT before attempting
a second L1 -> L2 injection to cause intervening NPF again,

* Added a fix for L1/L2 NMI state confusion during L1 -> L2 NMI re-injection,

* Updated the new KVM self-test to also check for the NMI injection
scenario being fixed (that was found causing issues with a real guest),

* Changed "kvm_inj_virq" trace event "reinjected" field type to bool,

* Integrated the fix from patch 5 for nested_vmcb02_prepare_control() call
argument in svm_set_nested_state() to patch 1,

* Collected Maxim's "Reviewed-by:" for tracepoint patches.

Previous versions:
Sean's v2:
https://lore.kernel.org/kvm/20220423021411.784383-1-seanjc@google.com

Sean's v1:
https://lore.kernel.org/kvm/20220402010903.727604-1-seanjc@google.com

My original series:
https://lore.kernel.org/kvm/cover.1646944472.git.maciej.szmigiero@oracle.com

Maciej S. Szmigiero (4):
  KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
  KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0
  KVM: nSVM: Transparently handle L1 -> L2 NMI re-injection
  KVM: selftests: nSVM: Add svm_nested_soft_inject_test

Sean Christopherson (8):
  KVM: SVM: Unwind "speculative" RIP advancement if INTn injection
    "fails"
  KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is
    supported
  KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction
  KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"
  KVM: x86: Trace re-injected exceptions
  KVM: x86: Print error code in exception injection tracepoint iff valid
  KVM: x86: Differentiate Soft vs. Hard IRQs vs. reinjected in
    tracepoint
  KVM: nSVM: Drop support for CPUs without NRIPS (NextRIP Save) support

 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/svm/nested.c                     |  55 ++++-
 arch/x86/kvm/svm/svm.c                        | 179 +++++++++++----
 arch/x86/kvm/svm/svm.h                        |   8 +-
 arch/x86/kvm/trace.h                          |  31 ++-
 arch/x86/kvm/vmx/vmx.c                        |   4 +-
 arch/x86/kvm/x86.c                            |  20 +-
 tools/testing/selftests/kvm/.gitignore        |   3 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  17 ++
 .../selftests/kvm/include/x86_64/svm_util.h   |  12 +
 .../kvm/x86_64/svm_nested_soft_inject_test.c  | 217 ++++++++++++++++++
 12 files changed, 478 insertions(+), 71 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c

