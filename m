Return-Path: <kvm+bounces-54095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8526FB1C1E7
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 10:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DE731866C7
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 08:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78253221278;
	Wed,  6 Aug 2025 08:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DMXZ6AU2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE43190498;
	Wed,  6 Aug 2025 08:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754467984; cv=none; b=HBvVzmvrhw0s/s4bPbMeycb8TLR1ExnkcJWSECWgzByauGinpfWdtoLzFWYzkgNtEetxF5D9JTiJhvzogrVwmhpHn08Bgu10O/qhKepuiWieeBGHY8O3O60NgTU1/pIevvKXeIotauGGe/u6LCo3Ho/05b2g6cB1yhTiM6pcI7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754467984; c=relaxed/simple;
	bh=NPwQzODxZDZ63KgTqpvrv+q9WLYhOkGA2VBcH1Jt9Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qJzQLgUuF6lux5O9IGJ9QLBqt7+keENYifeHI/O1diA0BAn+N+rh75ewHO9eWnmTY+Klstd/I+UUZWw4Xc4nW3Cy56UgMpoZCQvxWVdh0KOFZaJUNhHk5hxvxZF9fZpgM8Jgfmtsm3khj/B8Z8qbGptGhiS8T+sKbn8dnbSPwgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DMXZ6AU2; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76bc5e68d96so5419434b3a.3;
        Wed, 06 Aug 2025 01:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754467982; x=1755072782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6CybQKPsrdQOzf4AE3k80/Out/jwh9Y2vwWG1ev31ck=;
        b=DMXZ6AU2iZp4nRwwAuAMzZ7VL/NRQdwSxTtjSfODAqJzFN9pxvo7nnLI/Lpkkg2m9k
         Q7sdDQf5V29se7X7auaoSIYNB2Bexy5e5RzQSvm6MnowzgjldbWzpQ1tImsRp5Em/Isn
         WEzR4ofApwZgwNwP673Yr2U200Ebezv6ocSfDWSQOplQQ5GDYdoc9wE1d0JFRnG3SPQx
         Or50KAtP1yqAutgH4OMkS4dakwJkrJxLCpYluo/uEuqPD2W+QVNQBAwkNFkMTWKbGEA+
         BFST98Z07lJtWoX5GEsxOQnMPSHnmBpkVvCeP1n+yfFLdRAyA3UA9ToBCcxtlF6LrOX5
         pPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754467982; x=1755072782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6CybQKPsrdQOzf4AE3k80/Out/jwh9Y2vwWG1ev31ck=;
        b=UULuXurn7ki/4vECCOWHz2c1c5azbop2ow7F5KS9dhN/SCPd5LU4Qz1oXckT/hclZq
         oJP7Sf5ZFbC+MCK2a67qcVOg20TTd9NmAX66mf1szgkaJDeAVrTu7Wzh2mcVcjAZsjyW
         uRsJh2fqzs19suAqbhMm1MY1dCTNIKRA15Z4SwgIB7CkYMxrxihl1YWfpVTXq0yctvc+
         r24Fqi2stNLN9WfT5A5FBrnR5iAEM8I8m/RDKaNCMaXk3zbSnOLL3VfnQfsqhilKplNo
         lRlsr3eY4eILDSQQg6e3kb8b8o0o/N8uF4ZnKsuMYukSAaoaNaYMeXdi7EVK21Z35cyY
         /kSw==
X-Forwarded-Encrypted: i=1; AJvYcCU/h+Ix1DYSJnuu2AqyTwc+80V3unXeiFIW0H8Cm0xbvn2sv1Qc1N/oqTSE8K0nNZeIgBA=@vger.kernel.org, AJvYcCUD2aVDmYmy9jP2DDib5beY+pbw+/CT25ayoqYHvXWPhIbmU8YWw6L8wD61ugyIEJH1lqBvJcPyXSeaSjoG@vger.kernel.org
X-Gm-Message-State: AOJu0Yzns2FISs98EEVkAMz7vXE7nOp2VImyEEmmlJG3gSWjv/7z+U0i
	ULl2PooSE0DC7Gi6/jgXP20gCmyqGgxauZkS5BPV8JfOoREQJsEmXAaf
X-Gm-Gg: ASbGnctqHBz/mtU0Ql4JLgz5J8zmHtIHQ9xkKtTEMpelGDweEMvXK5Jw1EwhtSHhKP8
	1qOFHr/E5nqOTtUFY2RqRQsx4PBb1UKn+PUw0MXQUdev8uBv0jk4ht02t/4dG+BYHeUNlbEH5Yz
	tIFSy6a5amhHg7WciinCbGlzdcnS8MH9MFNeugPyyx9f5dDDg+TCdgsExw0Km7FUk6lbsD7MpXl
	FwXhBXdUCABOsZZiYGyKPf/UcOMo+ZDbeLfoPbTMQEKE9eb20X81Mm6O4BaNB4B2x3YmKSdtESF
	rmsPVZoq+SSQrquJ6hs9UKgwfMWzrA53Sfxn/sCzWozin0QeKSrqjaDcYUxsd5XEtEI0j44Y5Kv
	+3/46SI5k0BqGwZnD/c5/OdOc9DN2u3CCbjh+mJ1dCa4NJPX0YoeYuoW+
X-Google-Smtp-Source: AGHT+IFemTQ4BuOshxxMlQHiljIVMVOoEcww4fej94enuuEn+iwO2CZKMypsoQX4obu4xDWMztnu7A==
X-Received: by 2002:a05:6a20:12c7:b0:23d:dcb9:d511 with SMTP id adf61e73a8af0-240313ec491mr3166546637.19.1754467982348;
        Wed, 06 Aug 2025 01:13:02 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.165])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76c0a952525sm6231346b3a.79.2025.08.06.01.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 01:13:01 -0700 (PDT)
From: Yuguo Li <cs.hugolee@gmail.com>
X-Google-Original-From: Yuguo Li <hugoolli@tencent.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuguo Li <hugoolli@tencent.com>
Subject: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
Date: Wed,  6 Aug 2025 16:10:51 +0800
Message-ID: <20250806081051.3533470-1-hugoolli@tencent.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using split irqchip mode, IOAPIC is handled by QEMU while the LAPIC is emulated by KVM.
When guest disables LINT0, KVM doesn't exit to QEMU for synchronization, leaving IOAPIC unaware of this change.
This may cause vCPU to be kicked when external devices(e.g. PIT)keep sending interrupts.
This patch ensure that KVM exits to QEMU for synchronization when the guest disables LINT0.

Signed-off-by: Yuguo Li <hugoolli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/lapic.c            | 4 ++++
 arch/x86/kvm/x86.c              | 5 +++++
 include/uapi/linux/kvm.h        | 1 +
 4 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..f69ce111bbe0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -129,6 +129,7 @@
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
 	KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
+#define KVM_REQ_LAPIC_UPDATE              KVM_ARCH_REQ(35)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8172c2042dd6..65ffa89bf8a6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2329,6 +2329,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			val |= APIC_LVT_MASKED;
 		val &= apic_lvt_mask[index];
 		kvm_lapic_set_reg(apic, reg, val);
+		if (irqchip_split(apic->vcpu->kvm) && (val & APIC_LVT_MASKED)) {
+			kvm_make_request(KVM_REQ_LAPIC_UPDATE, apic->vcpu);
+			kvm_vcpu_kick(apic->vcpu);
+		}
 		break;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..0d6d29488ee9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10779,6 +10779,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+		if (kvm_check_request(KVM_REQ_LAPIC_UPDATE, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_APIC_SYNC;
+			r = 0;
+			goto out;
+		}
 
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0f0d49d2544..3425076d5c7b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_APIC_SYNC        41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
-- 
2.43.5


