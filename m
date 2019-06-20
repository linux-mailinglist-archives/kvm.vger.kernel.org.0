Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C5D4CC88
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 13:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfFTLCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 07:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfFTLCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 07:02:44 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9AFB2300DA2B;
        Thu, 20 Jun 2019 11:02:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AB7E5D9E5;
        Thu, 20 Jun 2019 11:02:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 0/5] x86/KVM/svm: get rid of hardcoded instructions lengths
Date:   Thu, 20 Jun 2019 13:02:35 +0200
Message-Id: <20190620110240.25799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 20 Jun 2019 11:02:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim rightfully complains that hardcoding instuctions lengths is not always
correct: additional (redundant) prefixes can be used. Luckily, the ugliness
is mostly harmless: modern AMD CPUs support NRIP_SAVE feature but I'd like
to clean things up and sacrifice speed in favor of correctness.

Early RFC. Unfortunately, I got distracted by some other problems so
sending it out half-baked.

TODO:
- Get rid of hardcoded '+ 3' in vmrun_interception().
- Test.

P.S. If you'd like to test the series you'll have to have a CPU without
NRIP_SAVE feature or forcefully disable it, something like:

index 8d4e50428b68..93c7eaad7915 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -922,6 +922,9 @@ static void init_amd(struct cpuinfo_x86 *c)
        /* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
        if (!cpu_has(c, X86_FEATURE_XENPV))
                set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+       /* No nrips */
+       clear_cpu_cap(c, X86_FEATURE_NRIPS);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5beca1030c9a..5b2ea34bc9f2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -773,11 +773,11 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
 
-       if (svm->vmcb->control.next_rip != 0) {
+/*     if (svm->vmcb->control.next_rip != 0) {
                WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
                svm->next_rip = svm->vmcb->control.next_rip;
        }
-
+*/
        if (!svm->next_rip) {
                if (kvm_emulate_instruction(vcpu, EMULTYPE_SKIP) !=
                                EMULATE_DONE)

Vitaly Kuznetsov (5):
  x86: KVM: svm: don't pretend to advance RIP in case
    wrmsr_interception() results in #GP
  x86: KVM: svm: avoid flooding logs when skip_emulated_instruction()
    fails
  x86: KVM: svm: clear interrupt shadow on all paths in
    skip_emulated_instruction()
  x86: KVM: add xsetbv to the emulator
  x86: KVM: svm: remove hardcoded instruction length from intercepts

 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/kvm/emulate.c             |  9 ++++++++-
 arch/x86/kvm/svm.c                 | 19 ++++++-------------
 3 files changed, 15 insertions(+), 14 deletions(-)

-- 
2.20.1

