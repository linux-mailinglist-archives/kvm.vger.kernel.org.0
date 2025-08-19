Return-Path: <kvm+bounces-54999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF38AB2C859
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D239E1C23A22
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124082848BA;
	Tue, 19 Aug 2025 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="ruUSWohB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39612877CF
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616845; cv=none; b=XF7SAcm9nq6QgxqB1T2Y0YlYwcPcrK4c+H3Jx8L35BAf1k0pyztq8FAGXY4CFIFEy3W8LZ8XmJriTrupTxNw5nRx7P2ZcN2s30VaebxDMMIkfHJrdfCq53MNqVCAfbePnRU2+LEfzPiTCE7R9Iy6vWfazmY8br8f6yjJq3wj/lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616845; c=relaxed/simple;
	bh=eUrR4NP72EKznEUzfrQ6RmdmdpoU6ltR0MbO4Ojo8Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG9M+cLSANDnTBugEwwuJgpzsd4PD9tmYFLicmb9ES0ryAEl0VxGtSq3+Xce1Kd3sRAb+BM3Hsg0/3lG0JuT5EMBkCxs+nllxwDiLpz/58NRmVJ5IqcOk5vqYznREEd2nakItojN2VMmkfCbL7L9ADDIcb8J4oJJ0MUa2Kz57yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=ruUSWohB; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so3057483b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 08:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1755616843; x=1756221643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lSDpgMZajVKYY0uCSDb90s/Pt+KK5ftnBEiQn/IXqA=;
        b=ruUSWohBwJyBmTuk07GSs/ZfoQzBcQKPYXC6uxe7QBdDDx1AGvtYLFzR9CD+Df7frS
         H8TRuvEWThWuqjJ+WagRIC7pdf4qqASgV/43dpsHNe+FCEcTlvtRalCmJXo7rF9aiLs0
         nakBLSEGBVe/ZGv1EHPNhPpTCWQ1+9D+CChpktKN2Vdy/ReMU8aHG2YwXHTNpl+3+Kgf
         s2VeJ+Zriwumk1C42Vc2Y5/UDZQLRd2iHQG6vWc+xDO1Krk/VZ1iTYtoTaY0Qp5gt2GA
         3aifJ7xl0gt0afHyRQ1Ahf5aivpjTW8LbvnZp7lesKs3Y9vW/t+TDWke12YeCowcAMit
         /shQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755616843; x=1756221643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lSDpgMZajVKYY0uCSDb90s/Pt+KK5ftnBEiQn/IXqA=;
        b=VJ6oZOZJAInDrR8ucqyEwhv3I9hvxlZbb6EQ9B/iyPc6HN739vwhtCS56zFUUy3pGW
         nEj+fGUbk5tSB57qdOWVrLu/Eg/O/MkSiP0K/K3Log6r7WpOnF3ynWTE8nIOnI/bTy9J
         3pZbf1NOdP6LuuSRibSdo//Tn21sHBDNdKAdIBho88PbUOUOqA0vfvyz/vwm/KGWE861
         sUFlcWoKAmIsFMeQx2fGPcQVvaDQPrqDeDYEuTa5D2+L6l59LfTPo3PO4XKEl/aHBk8o
         lcaP5Ssh484hMNwKPdBr/+jEdIb+4/hc+QuBF7YrEzeIEFR6c2/zCuJwRLsjAOJZ3Eu1
         8ZZA==
X-Gm-Message-State: AOJu0Yw5epMZ5h8e2t7Qb7d4fcjOwMjxHgJk7E7UfMVAEcy+wkVBLtSu
	Ye1ntZosvl5rBwpDuoKxrmdD/MvRxkvDoneSNDddR8mhdDqlWHPaTHShjwT55nss99g=
X-Gm-Gg: ASbGnctK/VzdrOVgKlfrxLB72hfkiNv5VN0siH0et7bN1YiX9lWeRyG+O7KogLBQYw6
	zlLrtrsBwFct4Ne7dQYfeefBwleVzUl0ObxZgdwvE/jdALdoQ5N3gWMq0j751X9qEtL0e+Zx1pJ
	eO3Ij4vIVNBrGJV244RFzweju/2oCTFiVZwGJWZqNxbP1aVqxADfVn5G0WQG5d2QMEW7AVVrbMe
	Cb2TYoGHpe3x01uMrX0ZsdnoYKG/2j7JK7VdISNSiqUEx6kjIPWrtcRLIHqG8H98GOdZphxfkcp
	fon/rvs0F3TADCbP9prdoprPy9AWHB/5GHjFi/hNNaco+y6htebP82wuSBpotU/xis4LtVwmvYb
	LpcC3JU7sI6CUofvHhNe+C7B0n/pDfxYI2RMnZw==
X-Google-Smtp-Source: AGHT+IET1fYCsA43ScR7Gl7o0QqueeZxCmd7tup9t4LlIjJFy4GsUQxo56fJU5lQZ9Qa7DgyluOoXg==
X-Received: by 2002:a05:6a00:2d29:b0:76c:3751:dfbe with SMTP id d2e1a72fcca58-76e8114636cmr4179133b3a.24.1755616842845;
        Tue, 19 Aug 2025 08:20:42 -0700 (PDT)
Received: from localhost.localdomain ([193.246.161.124])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d546ce3sm2771227b3a.103.2025.08.19.08.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 08:20:42 -0700 (PDT)
From: Lei Chen <lei.chen@smartx.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] Revert "x86: kvm: rate-limit global clock updates"
Date: Tue, 19 Aug 2025 23:20:26 +0800
Message-ID: <20250819152027.1687487-3-lei.chen@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250819152027.1687487-1-lei.chen@smartx.com>
References: <20250819152027.1687487-1-lei.chen@smartx.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 7e44e4495a398eb553ce561f29f9148f40a3448f.

Commit 7e44e4495a39 ("x86: kvm: rate-limit global clock updates")
intends to use a kvmclock_update_work to sync ntp corretion
across all vcpus kvmclock, which is based on commit 0061d53daf26f
("KVM: x86: limit difference between kvmclock updates")

Since kvmclock has been switched to mono raw, this commit can be
reverted.

Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 29 ++++-------------------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e41e4fe91f5e..0a1165f40ff1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1435,7 +1435,6 @@ struct kvm_arch {
 	bool use_master_clock;
 	u64 master_kernel_ns;
 	u64 master_cycle_now;
-	struct delayed_work kvmclock_update_work;
 
 #ifdef CONFIG_KVM_HYPERV
 	struct kvm_hv hyperv;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 399045a384d4..d526e9e285f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3404,22 +3404,14 @@ uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
  * the others.
  *
  * So in those cases, request a kvmclock update for all vcpus.
- * We need to rate-limit these requests though, as they can
- * considerably slow guests that have a large number of vcpus.
- * The time for a remote vcpu to update its kvmclock is bound
- * by the delay we use to rate-limit the updates.
+ * The worst case for a remote vcpu to update its kvmclock
+ * is then bounded by maximum nohz sleep latency.
  */
-
-#define KVMCLOCK_UPDATE_DELAY msecs_to_jiffies(100)
-
-static void kvmclock_update_fn(struct work_struct *work)
+static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 {
 	unsigned long i;
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
-					   kvmclock_update_work);
-	struct kvm *kvm = container_of(ka, struct kvm, arch);
 	struct kvm_vcpu *vcpu;
+	struct kvm *kvm = v->kvm;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -3427,15 +3419,6 @@ static void kvmclock_update_fn(struct work_struct *work)
 	}
 }
 
-static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
-{
-	struct kvm *kvm = v->kvm;
-
-	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
-					KVMCLOCK_UPDATE_DELAY);
-}
-
 /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
 static bool is_mci_control_msr(u32 msr)
 {
@@ -12698,8 +12681,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.hv_root_tdp = INVALID_PAGE;
 #endif
 
-	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
-
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
@@ -12806,8 +12787,6 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 	 * is unsafe, i.e. will lead to use-after-free.  The PIT also needs to
 	 * be stopped before IRQ routing is freed.
 	 */
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
-
 #ifdef CONFIG_KVM_IOAPIC
 	kvm_free_pit(kvm);
 #endif
-- 
2.44.0


