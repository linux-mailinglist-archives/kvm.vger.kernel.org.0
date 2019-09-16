Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE17B35D9
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 09:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbfIPHmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 03:42:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40283 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfIPHmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 03:42:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so22462117pfb.7;
        Mon, 16 Sep 2019 00:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iElSScH0z0U2B9GLYDqzyiyFEddhdSl2+XmoY+CYnvk=;
        b=TdKgVm1KSuoUuweHXf8nrFV8eIYyOvfvBAR8TLSN5mcZF5YfmIOuzIWlWf+QDdiZT1
         Ale/7tQIDRV+uk8ED/zr3/6d/4w19egG0pabScUjISNOlnBQ4FfeF3D600tfcaE2q/0l
         w7CZMnm8p0iweES607fM/k/pSviFZKC1MpTkj6fF1VA2ppgJRsnQ8bZs6s0IrSMiBkuR
         ALU2cFMahLZEPcaRhglEOAQrE2Y0AeUvBdmMsnfaH65r6PT0M7yylkEw4isUnDW0cPyr
         L8F5e4YyNYDgUX7qnsRFY3UBOg55Mknax+rVLM8BMM/i8QxaUlx+Zt/siwIwmefmIdEb
         84VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iElSScH0z0U2B9GLYDqzyiyFEddhdSl2+XmoY+CYnvk=;
        b=A4tDtL+Zd8k+IukmuLYdvvCW9Z7P4tV5L2yMnoRs9Ww80nG420henJDtDUBONN25al
         z2pKGIb1ini6fJal2dTBSCKqH5fASQoJur0MuAviux/fSqIGyY9p8b4iE9pL4i9nyrED
         BZIlwupfyqxKXZ6QTpGuez57jT4BZ41JmoqhKPYe6WzqaOQLeyAiv7I/ef/td/cA8rc9
         PJ7MyJetaZShRH/2Ino4WEvMw3e1oGoTwf+nmj7K1Kf62TYdZpsMG1mWkbZqf+t9/Rrp
         QwYRuh1XiiGpEovtBnM8y11AEmcIlxXlsjBDJC5jsvJTZJv1H3GBpuM08GNgTpfM5xl6
         3I/w==
X-Gm-Message-State: APjAAAXSdNHE6taCRxnGMjCQedGOt3OIXhgoxZG0m0a+GlVqC1eniPI0
        1Qs2z+PTKlczZgcJ0veAtiurMhws
X-Google-Smtp-Source: APXvYqz6UXb+1m2RY5wgCOKMbqJoz8UuUxUz1PwKGU2byU6AGn21tsVQ4b9kP+cucwWs52QAxFK4wg==
X-Received: by 2002:a63:ef4d:: with SMTP id c13mr17809326pgk.200.1568619757028;
        Mon, 16 Sep 2019 00:42:37 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id s19sm36531063pfe.86.2019.09.16.00.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Sep 2019 00:42:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3] KVM: hyperv: Fix Direct Synthetic timers assert an interrupt w/o lapic_in_kernel
Date:   Mon, 16 Sep 2019 15:42:32 +0800
Message-Id: <1568619752-3885-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

	kasan: GPF could be caused by NULL-ptr deref or user memory access
	general protection fault: 0000 [#1] PREEMPT SMP KASAN
	RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
	Call Trace:
	kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
	stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
	stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
	kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
	vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
	vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
	kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
	kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765

The testcase programs HV_X64_MSR_STIMERn_CONFIG/HV_X64_MSR_STIMERn_COUNT,
in addition, there is no lapic in the kernel, the counters value are small
enough in order that kvm_hv_process_stimers() inject this already-expired
timer interrupt into the guest through lapic in the kernel which triggers
the NULL deferencing. This patch fixes it by don't advertise direct mode 
synthetic timers and discarding the inject when lapic is not in kernel.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=1752fe0a600000

Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * add the link of syzkaller source
v1 -> v2:
 * don't advertise direct mode synthetic timers when lapic is not in kernel

 arch/x86/kvm/hyperv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c10a8b1..069e655 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -645,7 +645,9 @@ static int stimer_notify_direct(struct kvm_vcpu_hv_stimer *stimer)
 		.vector = stimer->config.apic_vector
 	};
 
-	return !kvm_apic_set_irq(vcpu, &irq, NULL);
+	if (lapic_in_kernel(vcpu))
+		return !kvm_apic_set_irq(vcpu, &irq, NULL);
+	return 0;
 }
 
 static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
@@ -1849,7 +1851,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
-			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+
+			/*
+			 * Direct Synthetic timers only make sense with in-kernel
+			 * LAPIC
+			 */
+			if (lapic_in_kernel(vcpu))
+				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 
 			break;
 
-- 
2.7.4

