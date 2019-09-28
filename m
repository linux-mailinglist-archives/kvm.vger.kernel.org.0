Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 969CEC118C
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfI1RYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbfI1RX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03DF210CC1F4;
        Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D225C5D6B0;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 11/14] KVM: x86: optimize more exit handlers in vmx.c
Date:   Sat, 28 Sep 2019 13:23:20 -0400
Message-Id: <20190928172323.14663-12-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eliminate wasteful call/ret non RETPOLINE case and unnecessary fentry
dynamic tracing hooking points.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e995e37a8c8..de3ae2246205 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4589,7 +4589,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int handle_external_interrupt(struct kvm_vcpu *vcpu)
+static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.irq_exits;
 	return 1;
@@ -4860,21 +4860,6 @@ void kvm_x86_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmcs_writel(GUEST_DR7, val);
 }
 
-static int handle_cpuid(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_cpuid(vcpu);
-}
-
-static int handle_rdmsr(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_rdmsr(vcpu);
-}
-
-static int handle_wrmsr(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_wrmsr(vcpu);
-}
-
 static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
 {
 	kvm_apic_update_ppr(vcpu);
@@ -4891,11 +4876,6 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_halt(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_halt(vcpu);
-}
-
 static int handle_vmcall(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_hypercall(vcpu);
@@ -5487,11 +5467,11 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_IO_INSTRUCTION]          = handle_io,
 	[EXIT_REASON_CR_ACCESS]               = handle_cr,
 	[EXIT_REASON_DR_ACCESS]               = handle_dr,
-	[EXIT_REASON_CPUID]                   = handle_cpuid,
-	[EXIT_REASON_MSR_READ]                = handle_rdmsr,
-	[EXIT_REASON_MSR_WRITE]               = handle_wrmsr,
+	[EXIT_REASON_CPUID]                   = kvm_emulate_cpuid,
+	[EXIT_REASON_MSR_READ]                = kvm_emulate_rdmsr,
+	[EXIT_REASON_MSR_WRITE]               = kvm_emulate_wrmsr,
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
-	[EXIT_REASON_HLT]                     = handle_halt,
+	[EXIT_REASON_HLT]                     = kvm_emulate_halt,
 	[EXIT_REASON_INVD]		      = handle_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
 	[EXIT_REASON_RDPMC]                   = handle_rdpmc,
