Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3455DB98F3
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393830AbfITVZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:25:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393804AbfITVZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:25:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 075EF3082A6C;
        Fri, 20 Sep 2019 21:25:16 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC83C5F7D5;
        Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
Date:   Fri, 20 Sep 2019 17:25:07 -0400
Message-Id: <20190920212509.2578-16-aarcange@redhat.com>
In-Reply-To: <20190920212509.2578-1-aarcange@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 20 Sep 2019 21:25:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's enough to check the exit value and issue a direct call to avoid
the retpoline for all the common vmexit reasons.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a6e597025011..9aa73e216df2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5866,9 +5866,29 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (exit_reason < kvm_vmx_max_exit_handlers
-	    && kvm_vmx_exit_handlers[exit_reason])
+	    && kvm_vmx_exit_handlers[exit_reason]) {
+#ifdef CONFIG_RETPOLINE
+		if (exit_reason == EXIT_REASON_MSR_WRITE)
+			return handle_wrmsr(vcpu);
+		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+			return handle_preemption_timer(vcpu);
+		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
+			return handle_interrupt_window(vcpu);
+		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+			return handle_external_interrupt(vcpu);
+		else if (exit_reason == EXIT_REASON_HLT)
+			return handle_halt(vcpu);
+		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
+			return handle_pause(vcpu);
+		else if (exit_reason == EXIT_REASON_MSR_READ)
+			return handle_rdmsr(vcpu);
+		else if (exit_reason == EXIT_REASON_CPUID)
+			return handle_cpuid(vcpu);
+		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+			return handle_ept_misconfig(vcpu);
+#endif
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
-	else {
+	} else {
 		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 				exit_reason);
 		dump_vmcs();
