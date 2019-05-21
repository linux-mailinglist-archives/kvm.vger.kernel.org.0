Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475F6247BF
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 08:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfEUGHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 02:07:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39078 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfEUGHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 02:07:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id z26so8478948pfg.6;
        Mon, 20 May 2019 23:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T2f0j+HcR+Hm2808+uYZ0INzAMJinwKKeoQwZ5KAAMI=;
        b=AfTgyoeXL7FvsFCYPAMw2WB6WEYULcybTi8Y4feHwmKhP32/yEDF7uQVjZCOD1BOyH
         MJkOKTFQTBy+9FR9fykBAuRzjhuYIMFY6LOJUotbnevwBeiCealuEvvzdv3t2799rSeh
         feljqw21jIYZLBfOMhKN3jDfh0PVDpcDsPpfqP5aVrv9DhEllO5x4ASFWNKqThoN0Trj
         Pazimk3nOviXHAB3wyl0VbQ4Dvwd0M1zmMDIGhszXhuKzZBxsh3LgR5NKRWv1Mn59Jvv
         PsuPJ+NDlziuakmxo10qlB5hxKS4p10i44atoayaiRyldpDnMGCuZU3fIIlhqQMllRV2
         s12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2f0j+HcR+Hm2808+uYZ0INzAMJinwKKeoQwZ5KAAMI=;
        b=H6n6IGbTdFraDRn3h0z+dcRso0p4U3dY16rK6MTppkkRZZ80a5TUAS09RzCtJA0ITz
         C3adAMALZp3Tq+s5qCwUiLzQBO+9gGYbbv++srOxgWGQ49F92k9iDE9cXpHfw+u0R9kf
         ZH2BfXnvF6xPTymtf7a3nYF3IdHbpdXoCTylz+qyJCujuLxSk6HkVyHJn9eiw8ycibno
         MX+f9socNtkqWQlh5/4vCzJN+dkCLqttbe1vNl46Y6BzTW9ls3J0WzYgDf1F8biIEfiC
         TnP5BM4nggxXvoMj9TURH32ltJhLDU7sJ5iYmRaH/PrZIeG3OH2vBuRmC3suimQi5sKs
         XB3g==
X-Gm-Message-State: APjAAAXz+Px93naRAUKj5iV4RAteatoy0mFyCdnpGzyzvFAy0oJ387Yw
        /k1rQX+arNP+IO1SXIf39CuCOLb1
X-Google-Smtp-Source: APXvYqwK/Tl2RHm3mvIPhxToSh/2lEv1avoEWuM3BPxoT0DKr2jUctRvx8kGLha9eTQMMOzFVdc1+g==
X-Received: by 2002:a63:495e:: with SMTP id y30mr37000742pgk.185.1558418825234;
        Mon, 20 May 2019 23:07:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id a15sm2351484pgv.4.2019.05.20.23.07.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 23:07:04 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 3/3] KVM: X86: Emulate MSR_IA32_MISC_ENABLE MWAIT bit
Date:   Tue, 21 May 2019 14:06:54 +0800
Message-Id: <1558418814-6822-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

MSR IA32_MISC_ENABLE bit 18, according to SDM:

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
 * hide behind KVM_CAP_DISABLE_QUIRKS

 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/cpuid.c            | 10 ++++++++++
 arch/x86/kvm/x86.c              | 10 ++++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7a0e64c..e3ae96b5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -382,6 +382,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
 #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
+#define KVM_X86_QUIRK_MISC_ENABLE_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9..f54d266 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -137,6 +137,16 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_MWAIT)) {
+		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+		if (best) {
+			if (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT)
+				best->ecx |= F(MWAIT);
+			else
+				best->ecx &= ~F(MWAIT);
+		}
+	}
+
 	/* Update physical-address width */
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	kvm_mmu_reset_context(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 765fe59..a4eb711 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2547,6 +2547,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_MISC_ENABLE:
+		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_MWAIT) &&
+			((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
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

