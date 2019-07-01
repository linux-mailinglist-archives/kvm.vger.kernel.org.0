Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317151C2A2
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 07:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfENFzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 01:55:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43467 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfENFzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 01:55:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id c6so8494725pfa.10;
        Mon, 13 May 2019 22:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CMDRp8XpQweyoE6w7mWaIS4V4U3Zt6PA6daqDS60vy4=;
        b=AGETcZb5B5+JSFCrLzQCchKAqOSdHTu08ihur04wjJAh4hRZzLT5eq0cLyddtkUxpy
         9EAUk0dM3Jh09plKuOu01QSRFeSHDwN3hbK/O01GgzEeO/4agp1pcwQBmYkoUTXNrK4S
         wt40Lc832cHqClBbr5NtBUsffKq8l/dvP7Yhcibu4GuO78iIy0BGaTxcM8tlriyAJKWY
         4cUtkluCq3TE4EA20rAMgEqrIDKaiugh/VrCoj/ToAukkNJ5RdYQmCiul6xi/KaQoBfE
         +m9UVL+ZjktcaXrKq3w1kWnxRr+iVTyzx+3LC73cDhZ3dS+w4gjviHZfwq3pZdBNL78D
         TYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CMDRp8XpQweyoE6w7mWaIS4V4U3Zt6PA6daqDS60vy4=;
        b=rCsH5uu8/TSUHIv4v97ozlyMtXMCqOxcGrC6tQGhEXWDt4aCcR2cxtagVCcIJSezbl
         6kPD+UwH5qmFYrfdqtgUH46vmQbDBXg4SR5Vl+D6AWH14bUFodHdQoPAXJ8k2CmSjnVe
         9m9TJtNFfVy0TnZMvoh9+cb6XOpgWvkGHo96Mrh57AtUXHF5eBtUuIVgN2CYVPdqXyiB
         sGYGq6ymSYdKVkHdhoPyplDw//gp2WyZz2vfnM1QK6PMQOUiAELIf81Ekey64oNdL0X1
         h6bNdj9pXnQ9HGKegAdTNv5UATzAr41f9wG3Y0CYldxnkfGHG5/kvwAKYKKbiYIiIH91
         Ly8Q==
X-Gm-Message-State: APjAAAU4lyIpFpNshLhKYXe+31UDKkf/5JCFHekCFjIl242nBYZT9hnP
        76PHxwTe0dcXn6NgEn+Ba5D4w+sy
X-Google-Smtp-Source: APXvYqwJB4aneVhpH1fMcWBasJHmUPuELrl/sHgYpGsFJ084xgc/kGYBvgpy0nL8CvfCAVIAX32xjQ==
X-Received: by 2002:a63:309:: with SMTP id 9mr36437674pgd.49.1557813315521;
        Mon, 13 May 2019 22:55:15 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f87sm22808814pff.56.2019.05.13.22.55.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 May 2019 22:55:15 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2] KVM: X86: Emulate MSR_IA32_MISC_ENABLE MWAIT bit
Date:   Tue, 14 May 2019 13:55:09 +0800
Message-Id: <1557813309-8524-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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
v1 -> v2:
 * to configure MSR_IA32_MISC_ENABLE_MWAIT bit in userspace
 * implements toggling of the CPUID bit based on guest writes to the MSR

 arch/x86/kvm/cpuid.c | 8 ++++++++
 arch/x86/kvm/x86.c   | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fd39516..0f82393 100644
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
index 3bbf3ab..4ed45ab 100644
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

