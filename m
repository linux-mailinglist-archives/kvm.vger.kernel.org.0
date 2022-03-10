Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B4C4D53A8
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 22:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiCJVkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 16:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbiCJVkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 16:40:11 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FFABECC3;
        Thu, 10 Mar 2022 13:39:07 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nSQUh-0006Ir-2l; Thu, 10 Mar 2022 22:38:47 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] nSVM: L1 -> L2 event injection fixes and a self-test
Date:   Thu, 10 Mar 2022 22:38:36 +0100
Message-Id: <cover.1646944472.git.maciej.szmigiero@oracle.com>
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

There are some issues with respect to nSVM L1 -> L2 event injection.

First, the next_rip field of a VMCB is *not* an output-only field for a VMRUN.
This field value (instead of the saved guest RIP) in used by the CPU for
the return address pushed on stack when injecting a software interrupt or
INT3 or INTO exception (this was confirmed by AMD).

On a VMRUN that does event injection it has similar function as VMX's
VM_ENTRY_INSTRUCTION_LEN field, although, in contrast to VMX, it holds an
absolute RIP value, not a relative increment.

However, KVM seems to treat this field as a unidirectional hint from the CPU
to the hypervisor - there seems to be no specific effort to maintain this
field consistency for such VMRUN.

This is mostly visible with running a nested guest, with L1 trying to inject
an event into its L2.
In this case, we need to make sure the next_rip field gets synced from
vmcb12 to vmcb02.

Another issue is that pending L1 -> L2 events are forgotten if there is an
intervening L0 VMEXIT during their delivery.
We need to make sure they are remembered (including their desired next_rip
field value) until they are either re-injected into L2 successfully or
returned back to L1 in the EXITINTINFO field upon a nested VMEXIT.

A new KVM self-test that checks for the nSVM issues described above is
included in this patch series.

These issues are SVM-specific - all the use cases described above already
work correctly with VMX.

This patch set was tested with both Linux and Windows nested guests.

  KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
  KVM: SVM: Downgrade BUG_ON() to WARN_ON() in svm_inject_irq()
  KVM: nSVM: Don't forget about L1-injected events
  KVM: nSVM: Restore next_rip when doing L1 -> L2 event re-injection
  KVM: selftests: nSVM: Add svm_nested_soft_inject_test

 arch/x86/kvm/svm/nested.c                     |  69 +++++++-
 arch/x86/kvm/svm/svm.c                        |  60 ++++++-
 arch/x86/kvm/svm/svm.h                        |  48 ++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 .../kvm/x86_64/svm_nested_soft_inject_test.c  | 147 ++++++++++++++++++
 7 files changed, 324 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c

