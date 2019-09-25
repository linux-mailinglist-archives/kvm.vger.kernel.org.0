Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CB6BE79B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 23:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfIYVhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 17:37:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38549 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbfIYVhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 17:37:34 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iDEyX-0002Dx-3W; Wed, 25 Sep 2019 23:37:29 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] KVM: x86: svm: Pass XSAVES to guest if available on host
Date:   Wed, 25 Sep 2019 23:37:20 +0200
Message-Id: <20190925213721.21245-2-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925213721.21245-1-bigeasy@linutronix.de>
References: <20190925213721.21245-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In commit
   55412b2eda2b7 ("kvm: x86: Add kvm_x86_ops hook that enables XSAVES for g=
uest")

XSAVES was enabled on VMX with a few additional tweaks and was always
disabled on SVM. Before ZEN XSAVES was not available so it made no
difference. With Zen it is possible to expose it to the guest if it is
available on the host.
I didn't find anything close to VMX's "VM-Execution Controls" and
exposing this flag based on the CPUID flags cause no harm so far.

Expose the XSAVES flag to the guest if the host supports it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e0368076a1ef9..3878eb766fa39 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5992,7 +5992,7 @@ static bool svm_mpx_supported(void)
=20
 static bool svm_xsaves_supported(void)
 {
-	return false;
+	return boot_cpu_has(X86_FEATURE_XSAVES);
 }
=20
 static bool svm_umip_emulated(void)
--=20
2.23.0

