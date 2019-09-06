Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132FEAB028
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 03:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404182AbfIFBa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 21:30:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34445 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403979AbfIFBa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 21:30:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id r12so3191236pfh.1;
        Thu, 05 Sep 2019 18:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lzU0KnwlLwZRT/00/44UaOi16RS92F7Mftz12Dneqw0=;
        b=BFmak78KIEynzF4dsEtKE2pyq+InTsB0IwkxiZIhXyCANQaY+y2RNUcjNY+eQP0297
         /3bxyIm1pAnXXCbWwE3pCwQRcnvtI3Jmki9dxQ0VJa43AFWsgjsMuvdUSPpGRY3ulEW3
         DiR14PUuuB4xDypIGY3uwsdDa1BaQNohXBqlcK1Evci2KZ+M7e4DdhmeLho9Qo36fHQu
         qf52Vsjaw5jOXPCKwVPc7a9Y0rglI3z9Agc/2+zHYlhnfh6/nDBNQ8GVn5pp9QdwA1kS
         m7AosbQmRSdZjhmb/vrTF1zwu898BZn74VD1veuFFLUc5sAGhavFEtrFxBEs3UnvSVeN
         28jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lzU0KnwlLwZRT/00/44UaOi16RS92F7Mftz12Dneqw0=;
        b=su8StgWMqC/QPPxj+xvWYabG+CHx9tzAgDVOY49wNMM2NFZU/siZPYQLNhc0NqhfIY
         KrNeebwkkmSY41K4uNvMYA1mp+YB2pXblk7rJZ1uKbt0QWsBfrF0FPT54Tr+PkiejYZr
         ZQKzDk0d8TwQWxX2+mzB6l6Mh4KPo7ZsSpdZJa/fnAj5/Q8Obk4e11u2d0Z7a8eSEBUH
         IO0YlYV1vKIsVR2K0IXSdusG1ka+J6YLVCXhwEIBDV3kMizv+I3iJ/f7SPtQE1ohqVak
         JcnL2+WM85O5mCscj8etE6RJgyzO5jgpQXcAQn1EfLQ1RrlPYAmqjcVX2feUhLiYmsJi
         SraQ==
X-Gm-Message-State: APjAAAUthm0foSjuszinybBxNXnYRU9Z2S/yrsp4z1MsWc8yhGxk9/9s
        lq5VT8qhcQyjmD0E885u1qOR8Hjk
X-Google-Smtp-Source: APXvYqyPzRoAay3eF3jG73d8xyiw9BP2olD/7SS7dUF38q/pUW5/uylf1N/SvNnzddQ3nZ3DoHyg2A==
X-Received: by 2002:a65:5a8c:: with SMTP id c12mr5706037pgt.73.1567733426195;
        Thu, 05 Sep 2019 18:30:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g11sm3332294pgu.11.2019.09.05.18.30.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Sep 2019 18:30:25 -0700 (PDT)
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
Subject: [PATCH v2 5/5] KVM: hyperv: Fix Direct Synthetic timers assert an interrupt w/o lapic_in_kernel
Date:   Fri,  6 Sep 2019 09:30:04 +0800
Message-Id: <1567733404-7759-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
References: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
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

Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
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

