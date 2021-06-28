Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926C83B5E58
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 14:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhF1MtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 08:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhF1MtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 08:49:03 -0400
Received: from forward106o.mail.yandex.net (forward106o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DC0C061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 05:46:37 -0700 (PDT)
Received: from iva1-cf747c9a36c8.qloud-c.yandex.net (iva1-cf747c9a36c8.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:9282:0:640:cf74:7c9a])
        by forward106o.mail.yandex.net (Yandex) with ESMTP id 0210D506268B;
        Mon, 28 Jun 2021 15:46:35 +0300 (MSK)
Received: from iva3-dd2bb2ff2b5f.qloud-c.yandex.net (iva3-dd2bb2ff2b5f.qloud-c.yandex.net [2a02:6b8:c0c:7611:0:640:dd2b:b2ff])
        by iva1-cf747c9a36c8.qloud-c.yandex.net (mxback/Yandex) with ESMTP id fuEENI93Yv-kYHiSd0u;
        Mon, 28 Jun 2021 15:46:34 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624884394;
        bh=MXNIktVnLvg3iLfiytyT0Mz6xWZ11yPrq2AeNMBm0q0=;
        h=Subject:To:From:Message-Id:Cc:Date;
        b=HKV21HIbqGpLeTgc/mlTvJ2i8Kc3b3bc/RV2+H9nL3C7M4MT3acE2zHXa7Fc7N9sI
         CR2A2ebJxBtWSYagCr5SekOphDr1GliT5LXZRhoqjoHc8kIAHo+MbGUU8MyJI15ReB
         opE18Y4HtXH4vQx3GaisnPb6fiUuzhIlm6PPGn/A=
Authentication-Results: iva1-cf747c9a36c8.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva3-dd2bb2ff2b5f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id cMbTfmbVkf-kX24W3VO;
        Mon, 28 Jun 2021 15:46:33 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Stas Sergeev <stsp2@yandex.ru>
Cc:     Stas Sergeev <stsp2@yandex.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: X86: Fix exception untrigger on ret to user
Date:   Mon, 28 Jun 2021 15:46:28 +0300
Message-Id: <20210628124628.1001133-1-stsp2@yandex.ru>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When returning to user, the special care is taken about the
exception that was already injected to VMCS but not yet to guest.
cancel_injection removes such exception from VMCS. It is set as
pending, and if the user does KVM_SET_REGS, it gets completely canceled.

This didn't happen though, because the vcpu->arch.exception.injected
and vcpu->arch.exception.pending were forgotten to update in
cancel_injection. As the result, KVM_SET_REGS didn't cancel out
anything, and the exception was re-injected on the next KVM_RUN,
even though the guest registers (like EIP) were already modified.
This was leading to an exception coming from the "wrong place".

This patch makes sure the vcpu->arch.exception.injected and
vcpu->arch.exception.pending are in sync with the reality (and
with VMCS). Also it adds clearing of pending exception to
__set_sregs() the same way it is in __set_regs(). See patch
b4f14abd9 that added it to __set_regs().

How to trigger the buggy scenario (that is, without this patch):
- Make sure you have the old CPU where shadow page tables
are used. Core2 family should be fine for the task. In this
case, all PF exceptions produce the exit to monitor.
- You need the _TIF_SIGPENDING flag set at the right moment
to get kvm_vcpu_exit_request() to return true when the PF
exception was just injected. In that case the cancel_injection
path is executed.
- You need the "unlucky" user-space that executes KVM_SET_REGS
at the right moment. This leads to KVM_SET_REGS not clearing
the exception, but instead corrupting its context.

v2 changes:
- do not add WARN_ON_ONCE() to __set_regs(). As explained by
Vitaly Kuznetsov, it can be user-triggerable.
- clear pending exception also in __set_sregs().
- update description with the bug-triggering scenario.

Signed-off-by: Stas Sergeev <stsp2@yandex.ru>

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Jim Mattson <jmattson@google.com>
CC: Joerg Roedel <joro@8bytes.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Jan Kiszka <jan.kiszka@siemens.com>
CC: x86@kernel.org
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: kvm@vger.kernel.org
---
 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0f4a46649d7..d1026e9216e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9450,7 +9450,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 cancel_injection:
 	if (req_immediate_exit)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-	static_call(kvm_x86_cancel_injection)(vcpu);
+	if (vcpu->arch.exception.injected) {
+		static_call(kvm_x86_cancel_injection)(vcpu);
+		vcpu->arch.exception.injected = false;
+		vcpu->arch.exception.pending = true;
+	}
 	if (unlikely(vcpu->arch.apic_attention))
 		kvm_lapic_sync_from_vapic(vcpu);
 out:
@@ -10077,6 +10081,8 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		pr_debug("Set back pending irq %d\n", pending_vec);
 	}
 
+	vcpu->arch.exception.pending = false;
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	ret = 0;
-- 
2.32.0

