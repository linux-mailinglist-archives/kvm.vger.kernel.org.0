Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3598F197939
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgC3KTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:49 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43730 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728746AbgC3KTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:49 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2020 06:19:47 EDT
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E2AD530747C6;
        Mon, 30 Mar 2020 13:12:49 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id BCEF0305B7A1;
        Mon, 30 Mar 2020 13:12:49 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 09/81] KVM: x86: avoid injecting #PF when emulate the VMCALL instruction
Date:   Mon, 30 Mar 2020 13:11:56 +0300
Message-Id: <20200330101308.21702-10-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

It can happened to end up emulating the VMCALL instruction as a result
of the handling of an EPT write fault. In this situation,
the emulator will try to unconditionally patch the correct hypercall
opcode bytes using emulator_write_emulated(). However, this last call
uses the fault GPA (if available) or walks the guest page tables at RIP,
otherwise. The trouble begins when using VM introspection,
when we forbid the use of the fault GPA and fallback to the guest pt walk:
in Windows (8.1 and newer) the page that we try to write into
is marked read-execute and as such emulator_write_emulated() fails
and we inject a write #PF, leading to a guest crash.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f23e015fc86..bfd8e3515c0d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7580,11 +7580,15 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	char instruction[3];
 	unsigned long rip = kvm_rip_read(vcpu);
+	int err;
 
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
 
-	return emulator_write_emulated(ctxt, rip, instruction, 3,
+	err = emulator_write_emulated(ctxt, rip, instruction, 3,
 		&ctxt->exception);
+	if (err == X86EMUL_PROPAGATE_FAULT)
+		err = X86EMUL_CONTINUE;
+	return err;
 }
 
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
