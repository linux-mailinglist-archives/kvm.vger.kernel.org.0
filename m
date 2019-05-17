Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E6215B2
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 10:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfEQIt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 04:49:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33230 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfEQIt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 04:49:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id h17so3005949pgv.0;
        Fri, 17 May 2019 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BMZTqCRe7Yq2IM+sICYMlznnn3t4JBojU8sT9FmlO4o=;
        b=cW7xcpKhrqtkIzyTFrMiDQ5p+TtZrCS3gBiD2zsnKHX/876EjpglYdiYy2K5mBdSzw
         b1J3wBqorDacpSoiBdeGkqVb+vsjpcRbAeW0ctnvw+yrzavMsJ2R/2dF6vvvoNrYPYX8
         CO5uZWmCMd67CPIxJbIfTM+FcpP84IKzIMjpYW7eBcI/MTmETqqOZf7Er8SltTqWLepa
         RbfWJ4+MHMCH3MmujNL/PFp2BKsuG323gwwPja4JmB908c8fVEJT5eUHR96WaEZVzZOI
         hOnjRqjgs3lqBQiHPBUDQuRopPoYCnfeQD2OKioIgzBRgv82jd0Cl2qJS7br2WoX5Ktp
         Z9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BMZTqCRe7Yq2IM+sICYMlznnn3t4JBojU8sT9FmlO4o=;
        b=FUHYNYA44qyb8i2ryx8qAaDKZf5wZ0f9wr8MyjQZoSnimi2CZPhzJ10atY2+n6xiui
         X5kyKfPSdSOMt4db1u8fpRErsLbyi08OzLZPA+sJqFhOJzMaUiNifD4bG4DIntfdvYhW
         gWO9VIPUzhZAl1pMhaFIhIHQK/0n/Y5H9BepwBRW0y2nmmB5/izAAWNjOAV6mWLLI29O
         0VxL1Z4O6BUg7xsswJqtJTjhn10cE9krgvfZCXRtiYeYASOQk8TWVzIT6kTQHSqPdT5z
         ELsolKnnLLMAe2XRGj5yWS7KtTIOwd/+P9KyI5T8/2w6xkdlBoKN8puDWHCpKbPCTFWO
         vKog==
X-Gm-Message-State: APjAAAWFwJ62bLR57jb0DutRALS3dmzGFrV954weEFkGctm7JvJ3j5X9
        4HyUOUdduKgLo459UZIlhEUfRICG
X-Google-Smtp-Source: APXvYqw39p1zjnYKnmyqGgifghpRVUZmXaCSxgucKvVBhasmkJ0xJcGLVC/TXH1ct3+/qFkrArIAsg==
X-Received: by 2002:aa7:9a99:: with SMTP id w25mr20416545pfi.249.1558082998095;
        Fri, 17 May 2019 01:49:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 63sm10417127pfu.95.2019.05.17.01.49.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 17 May 2019 01:49:57 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RESEND 2/4] KVM: X86: Emulate MSR_IA32_MISC_ENABLE MWAIT bit
Date:   Fri, 17 May 2019 16:49:48 +0800
Message-Id: <1558082990-7822-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
References: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

MSR IA32_MSIC_ENABLE bit 18, according to SDM:

| When this bit is set to 0, the MONITOR feature flag is not set (CPUID.01H:ECX[bit 3] = 0).
| This indicates that MONITOR/MWAIT are not supported.
|
| Software attempts to execute MONITOR/MWAIT will cause #UD when this bit is 0.
|
| When this bit is set to 1 (default), MONITOR/MWAIT are supported (CPUID.01H:ECX[bit 3] = 1).

The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR bit,
CPUID.01H:ECX[bit 3] is a better guard than kvm_mwait_in_guest().
kvm_mwait_in_guest() affects the behavior of MONITOR/MWAIT, not its
guest visibility.

This patch implements toggling of the CPUID bit based on guest writes
to the MSR.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/cpuid.c | 8 ++++++++
 arch/x86/kvm/x86.c   | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fd39516..9244d63 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -137,6 +137,14 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
+	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	if (best) {
+		if (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT)
+			best->ecx |= F(MWAIT);
+		else
+			best->ecx &= ~F(MWAIT);
+	}
+
 	/* Update physical-address width */
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	kvm_mmu_reset_context(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d89cb9..f2e3847 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2506,6 +2506,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_MISC_ENABLE:
+		if ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT) {
+			if ((vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT) &&
+				!(data & MSR_IA32_MISC_ENABLE_MWAIT)) {
+				if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
+					return 1;
+			}
+			vcpu->arch.ia32_misc_enable_msr = data;
+			kvm_update_cpuid(vcpu);
+		}
 		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
 	case MSR_IA32_SMBASE:
-- 
2.7.4

