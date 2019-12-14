Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E3111EF10
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 01:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLNAP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 19:15:26 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52540 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfLNAP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 19:15:26 -0500
Received: by mail-pf1-f202.google.com with SMTP id j7so2530065pfa.19
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 16:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=j3GWZOfDYJMyQxFqgM/P1MdaTU3tmLK8r2EVWlOwQg0=;
        b=a4YYoxiEQkOxlxpOaZQptugyg1b1VgiCniRH/OCNEjUZ1tWbiPuJCViJ407/9eD44D
         a9xBX3klgf/oj+GW6VONsYC6i6IHH0cBjJDcaKeS9PYi5pOgAk6gtTWUO4QYHUTCLXHc
         fMsC/gurdr8oAGhsn3pf1CcNlD3kcH+V2bG87zBEr3Kume0n4gaZWYWzZgBV6x/G92j8
         g4mOX5Z/d7jJfH4A0wVkYh/EgihPRNI/j3SccyiY7zvdKspd5jsJAS3pNM+tB+VOD3E2
         VQhjvXZ1MX5extxhMiPrU2k+Hdhk4dv8TjduB5bLe8b1nTK5H1Gn9hkOSIDkBUyBpOsR
         P7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=j3GWZOfDYJMyQxFqgM/P1MdaTU3tmLK8r2EVWlOwQg0=;
        b=K4a8Q+hqNTQPUMqor8+C7XJLbBg3zG6MX5i50UokHO0iYHT8o0G+vDI8cZKrYWYOMJ
         bTz3m1qTVmeDa4Kr5mIaJgM2RntJOksAmtHcWDrKeWoNT7++VHuGl5n2T333TxC0NBd6
         0ASfcH5TzPt56X/fzI5YKxGjc1nZXb7cCp3zNuUD5qOGL/BFONK4HYgNoxVRorfMdyIj
         qDAxH5LjfDgdqaSN5jsZXm1cEmCD7BRdci1qJqeldKlxxrWa7xeLRXl1iPqgdC15ZxOY
         pXhwxTzEr9UVHuzAmzqqpC9IuZ5WBhZorZZulexzTi1Zyh+R+lIbEeHR6yrgWrroE2+E
         3DHg==
X-Gm-Message-State: APjAAAWcmHPVbFzedSjkoPglrrgEBULL/BtiyTC3ksG3WIIsOZBQCLhi
        P/8OnmhBshC0/yBSrWjFXrMi5J/3bdNPtVlBH3NVjnUlOfT7ILpr4oT5CqcN86P2n/m93166aYD
        sjnIjjp1cI98EcsEVs1qWCd5Hsx1KRBjLG8jlvgzNpbovisYp+YfO/eBQm8aPoDE=
X-Google-Smtp-Source: APXvYqz0PMBepM8X4lTtxtrURgx5ZRr8C0AwB73mfLoQPee57ZWzlBOegixTy14QNyXYBcMX1CoH/iIgknYm6g==
X-Received: by 2002:a63:4708:: with SMTP id u8mr2500295pga.391.1576282524350;
 Fri, 13 Dec 2019 16:15:24 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:15:15 -0800
Message-Id: <20191214001516.137526-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH 1/2] kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Jacob Xu <jacobhxu@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The host reports support for the synthetic feature X86_FEATURE_SSBD
when any of the three following hardware features are set:
  CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31]
  CPUID.80000008H:EBX.AMD_SSBD[bit 24]
  CPUID.80000008H:EBX.VIRT_SSBD[bit 25]

Either of the first two hardware features implies the existence of the
IA32_SPEC_CTRL MSR, but CPUID.80000008H:EBX.VIRT_SSBD[bit 25] does
not. Therefore, CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] should only be
set in the guest if CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] or
CPUID.80000008H:EBX.AMD_SSBD[bit 24] is set on the host.

Fixes: 0c54914d0c52a ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cfafa320a8cf..d70a08dec9b6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -402,7 +402,8 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 			entry->edx |= F(SPEC_CTRL);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
 			entry->edx |= F(INTEL_STIBP);
-		if (boot_cpu_has(X86_FEATURE_SSBD))
+		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 			entry->edx |= F(SPEC_CTRL_SSBD);
 		/*
 		 * We emulate ARCH_CAPABILITIES in software even
-- 
2.24.1.735.g03f4e72817-goog

