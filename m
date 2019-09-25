Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E02BE798
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 23:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfIYVhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 17:37:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38554 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbfIYVhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 17:37:37 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iDEyX-0002Dx-FF; Wed, 25 Sep 2019 23:37:29 +0200
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
Subject: [PATCH 2/2] KVM: x86: Expose CLZERO and XSAVEERPTR to the guest
Date:   Wed, 25 Sep 2019 23:37:21 +0200
Message-Id: <20190925213721.21245-3-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925213721.21245-1-bigeasy@linutronix.de>
References: <20190925213721.21245-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I was surprised to see that the guest reported `fxsave_leak' while the
host did not. After digging deeper I noticed that the bits are simply
masked out during enumeration.
The XSAVEERPTR feature is actually a bug fix on AMD which means the
kernel can disable a workaround.
While here, I've seen that CLZERO is also masked out. This opcode is
unprivilged so exposing it to the guest should not make any difference.

Pass CLZERO and XSAVEERPTR to the guest if available on the host.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948e..0ae9194d0f4d2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -473,6 +473,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entr=
y2 *entry, u32 function,
=20
 	/* cpuid 0x80000008.ebx */
 	const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
+		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
=20
--=20
2.23.0

