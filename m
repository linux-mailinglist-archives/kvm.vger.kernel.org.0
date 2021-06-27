Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8E83B55D3
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 01:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhF0Xku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Jun 2021 19:40:50 -0400
Received: from forward104o.mail.yandex.net ([37.140.190.179]:42260 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231491AbhF0Xkt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 27 Jun 2021 19:40:49 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id 4705694142D;
        Mon, 28 Jun 2021 02:38:22 +0300 (MSK)
Received: from vla1-a6a42891800d.qloud-c.yandex.net (vla1-a6a42891800d.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:17a3:0:640:a6a4:2891])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 4327461E0004;
        Mon, 28 Jun 2021 02:38:22 +0300 (MSK)
Received: from vla1-ef285479e348.qloud-c.yandex.net (vla1-ef285479e348.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:ef28:5479])
        by vla1-a6a42891800d.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 4gkTbGMJ9g-cLHCFDfb;
        Mon, 28 Jun 2021 02:38:22 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624837102;
        bh=naMYM9gDZFSx3h6YF9DR7bBtKwQdlzzSknuSYsaG3uU=;
        h=Date:Subject:To:From:Message-Id:Cc;
        b=HnG8SvQZsuK2042pPNhcv0z2O0cFFPAWmtpEWZpTP1U4xpwynU8Cth9ImMDg2ul+D
         DKoJxxyBZA/x90mGopWT8Q1b26PzSbIqusLfIp5nZj/04QRhv6PaErv5DHFuz0qzqF
         uKl0LVJNxbaA+98mkyGVRe3JNYd6IDrmQ4ZHvU9k=
Authentication-Results: vla1-a6a42891800d.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla1-ef285479e348.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id JZM9r4HqlP-cK3WIVix;
        Mon, 28 Jun 2021 02:38:20 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Stas Sergeev <stsp2@yandex.ru>
Cc:     Stas Sergeev <stsp2@yandex.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: X86: Fix exception untrigger on ret to user
Date:   Mon, 28 Jun 2021 02:38:19 +0300
Message-Id: <20210627233819.857906-1-stsp2@yandex.ru>
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
with VMCS). Also it adds WARN_ON_ONCE() to __set_regs() to make
sure vcpu->arch.exception.injected is never set here, because
if it is, the exception context is going to be corrupted the same
way it was before that patch.
Adding WARN_ON_ONCE() alone, without the fix, was verified to
actually trigger and detect a buggy scenario.

Signed-off-by: Stas Sergeev <stsp2@yandex.ru>

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Wanpeng Li <wanpengli@tencent.com>
CC: Jim Mattson <jmattson@google.com>
CC: Joerg Roedel <joro@8bytes.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: x86@kernel.org
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: kvm@vger.kernel.org
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0f4a46649d7..bc6ca8641824 100644
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
@@ -9822,6 +9826,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_rip_write(vcpu, regs->rip);
 	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
 
+	WARN_ON_ONCE(vcpu->arch.exception.injected);
 	vcpu->arch.exception.pending = false;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
-- 
2.32.0

