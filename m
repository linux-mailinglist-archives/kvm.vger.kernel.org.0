Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1E73947C7
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 22:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhE1UId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 16:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhE1UIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 16:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EEA66139A;
        Fri, 28 May 2021 20:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622232417;
        bh=ZV1SeuPvDYe6GKbtbIb0+ApRzqPbNzxh5Kl5WTNpluU=;
        h=Date:From:To:Cc:Subject:From;
        b=VxmEw93MsPS0xdknwmzQPvfz7ky8qPJs1+sggEaujPxUwBziQv2KXTkgkXPD82CzJ
         wf7bV/oBZTUbSVgE/Rw/LPYnCI+MfjHnlvkZcU0G0wwdFCbm/MFxVJwtsC4x7ha9F6
         79QrI62QXrLA4bScfp69WW8Yo3ep8j/yAQ2xhoLNx+k9LVKt/V/KpT8Ei+wYlBmqKg
         mp5lTAzYSR0fjTh46oFAlFf/haw/2LYBh0EIIdUbSitfnJbzfOug3JKq2hY9Bl2UYO
         1sgWNBVpVsbNqENJzoU0MJyfb1wfcbmb0RRHlvuUFNcoQk//qacC4zdY774Gf3GZEA
         zx8yt6XPD9Fgg==
Date:   Fri, 28 May 2021 15:07:56 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] KVM: x86: Fix fall-through warnings for Clang
Message-ID: <20210528200756.GA39320@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
of warnings by explicitly adding break statements instead of just letting
the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
JFYI: We had thousands of these sorts of warnings and now we are down
      to just 25 in linux-next. These are some of those last remaining
      warnings.

 arch/x86/kvm/cpuid.c   | 1 +
 arch/x86/kvm/vmx/vmx.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9a48f138832d..b4da665bb892 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -655,6 +655,7 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
 			entry->ecx = F(RDPID);
 		++array->nent;
+		break;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..e7d98c3d398e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6248,6 +6248,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	switch (kvm_get_apic_mode(vcpu)) {
 	case LAPIC_MODE_INVALID:
 		WARN_ONCE(true, "Invalid local APIC state");
+		break;
 	case LAPIC_MODE_DISABLED:
 		break;
 	case LAPIC_MODE_XAPIC:
-- 
2.27.0

