Return-Path: <kvm+bounces-60834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E25BFBFCC45
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ACC75E7630
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FEA34CFC6;
	Wed, 22 Oct 2025 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="crd0p7DR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72AB348462
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145311; cv=none; b=pvesEIYQzdisy6P3R2Phq4Jx57FOOG+zbjYp6jMInYU/bwQjISBMkjRDykS6RN+DIPnU9ssalFqk6D2a8w0Ap4X24Fy2+4KJsmIMT/v+Mijq5zMJc6WM13CNKk9x/JFD48NY8J+zMJ9uSOGllNG0rev3p0tdyLltiALsJXArwcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145311; c=relaxed/simple;
	bh=E3MjY4wrFQgs0Ey0M7VbCGgbgx+qYCvJq22nI6SsagA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNbpYGBwYJZEA9nHF2KWDkXdsju/FpYSXNRuNNoMga6qzKWZk2vFKcEpF93pCfXz4fKKp31tqMM/6goQyWgcMVehcdxrAl69gwBok34cq305TWIyCXxqxWVvdNN6Y0UZZVGb9tjzemVJEnqpVzo9bq3XdyupBMEMLvgZn24+lbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=crd0p7DR; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7811a02316bso4894790b3a.3
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 08:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761145307; x=1761750107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAEfyzLs6ZfNZyLJabqtuJouEJtYNe8jJBcru5DQddE=;
        b=crd0p7DRC1Tng3tEWub76YtCUDAkij09uw+6KcBEEkvGAyt95fZX4T4MwDnqId/2BA
         R0qu1+8lPLRhhJykLhmzG37BTYPsd1GWfuxyyEhNqgLoTF2utlUYf2te7P+Yb5Hj0DB6
         XihhBFt8p4MDpA2hZpiksc8FVGfagOk5hVAL6w5MTAss3GvynTqBdWgYvW80TVyPzka2
         2YZhxVhaEG4rlBdwaMhRlYYAJVtvMDh4/HFEdA4vG8taJ7gGQ+rDYktVCLeEeny+m8cz
         pe8YZ/CQRxGnv8RGikPgUS3WH5JSGyRMVv6wD2VQPMMIMv6ahmOdCCsrxZfbKNMo3kf5
         gmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761145307; x=1761750107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAEfyzLs6ZfNZyLJabqtuJouEJtYNe8jJBcru5DQddE=;
        b=a80iQ4obeUfdcLcIRVJKFIjjfzlw8FazTiwS8oNZj7nNS/vezc0gSBT17xb7AFLrOJ
         jv0e1ZwpLEiMApxL+WoNeGogN0JLauE/0rc3RhyHN3k+0v3AppF02VxXCyODxyQck6KA
         tBLZOtfClCStAI0ZArnhdbcZIsxKBrSF0znr3jyjUPdaSGJTqM7tCM88+tIVSESGGgP4
         xGS9wZRW+Nre31iyYzkvHPVMKkSuVr22+TJa5gr06OIaEydgETj+dWuFbtsDmz/L4s9a
         27AtW9q0Kset+GRoVrvcdq6e7sAmRZrhi5gHIySlbcBWER6ZqVHf6NqZVRU9WQkzzvH/
         4Ycg==
X-Forwarded-Encrypted: i=1; AJvYcCUgmLgXqMNWuYkpcfrBFLl5OvjGxCP3z5E0eSx+5rjQQFT+gec96c3xoj+xDY5CFcX8K/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3uM/sxFSuvvhrWgPMH3KdduzDpXE5l5szjzQTK81LFV5uK6W8
	Js3Bpv5ksznP3lHM24oKu8c6usrStPPexNRiADppoQZenbb3qNv8LaRS
X-Gm-Gg: ASbGncuSBNyolTy0eZLiinLBEXZAw+x/J3d/jGKvF43h7g1adaXawZB4DiPANHyBrz5
	eNGyRDt5DlDiEz0DnQZNCr64L6zXeRCM2J1/1VkPlwGpt8F039I7K3jTRnt07z1w797TkFI7zCN
	cRAPP5DXLWf+xTPy7rfKqZ7ShN2OB1vHWrmcSaebdqZIVmBlDeOLNfzwQMyDTv4RaN1OatUaK3h
	z14SopzPeh/LsEwJh3xD/VMBn6BFoyKlabMgaeVytRbQ4QPU5S5aZ7fIzORyaMTOP4QnCa/N98X
	PjxYRx+AKCH37anlqCUl13JUjqQNqmbJCTCxouTZQN1JYpEtVKksIPAyK8jFfBHYqs5D7v2LON0
	l2aSBJPY/MyL8bzPmroAAsD4nVpKCVW91TSHzX9IZgYdeyDsQQ1a5tvtQm/bbKqvssmbNpGTFy3
	EybVn0TI0B5yjFbIA8O9vIp4hM//B78Ia6xZVCc00bGHC6Fovn8Oyy2ekSGQ==
X-Google-Smtp-Source: AGHT+IGrUnu0OE0MYMOGdRgAiyJXuUcaG4uPEeJasZ3TUiI7e1KAHvPHOFWaSXc9Do7+EcDyuK5f7Q==
X-Received: by 2002:a17:902:e5cf:b0:290:a32b:9095 with SMTP id d9443c01a7336-290cb7567fdmr293829075ad.54.1761145306436;
        Wed, 22 Oct 2025 08:01:46 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:8685:174d:2a07:e639])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e3125a3afsm1973624a91.6.2025.10.22.08.01.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 08:01:45 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: fuqiang wang <fuqiang.wng@gmail.com>,
	yu chen <33988979@163.com>,
	dongxu zhang <xu910121@sina.com>
Subject: [PATCH v3 2/2] fix hardlockup when waking VM after long suspend
Date: Wed, 22 Oct 2025 23:00:55 +0800
Message-ID: <20251022150055.2531-3-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251022150055.2531-1-fuqiang.wng@gmail.com>
References: <20251022150055.2531-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a virtual machine uses the HV timer during suspend, the KVM timer does
not advance. Upon waking after a long period, there may be a significant
gap between target_expiration and the current time. Since each timer
expiration only advances target_expiration by one period, the expiration
handler can be invoked repeatedly to catch up.

Prior to the previous patch, if the advanced target_expiration remained
less than the current time, tscdeadline could be set to a negative value.
This would cause HV timer setup to fail and fallback to the SW timer. After
switching to SW timer, apic_timer_fn could be repeatedly executed within a
single clock interrupt handler, resulting in a hardlockup:

  NMI watchdog: Watchdog detected hard LOCKUP on cpu 45
  ...
  RIP: 0010:advance_periodic_target_expiration+0x4d/0x80 [kvm]
  ...
  RSP: 0018:ff4f88f5d98d8ef0 EFLAGS: 00000046
  RAX: fff0103f91be678e RBX: fff0103f91be678e RCX: 00843a7d9e127bcc
  RDX: 0000000000000002 RSI: 0052ca4003697505 RDI: ff440d5bfbdbd500
  RBP: ff440d5956f99200 R08: ff2ff2a42deb6a84 R09: 000000000002a6c0
  R10: 0122d794016332b3 R11: 0000000000000000 R12: ff440db1af39cfc0
  R13: ff440db1af39cfc0 R14: ffffffffc0d4a560 R15: ff440db1af39d0f8
  FS:  00007f04a6ffd700(0000) GS:ff440db1af380000(0000) knlGS:000000e38a3b8000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000d5651feff8 CR3: 000000684e038002 CR4: 0000000000773ee0
  PKRU: 55555554
  Call Trace:
   <IRQ>
   apic_timer_fn+0x31/0x50 [kvm]
   __hrtimer_run_queues+0x100/0x280
   hrtimer_interrupt+0x100/0x210
   ? ttwu_do_wakeup+0x19/0x160
   smp_apic_timer_interrupt+0x6a/0x130
   apic_timer_interrupt+0xf/0x20
   </IRQ>

With the previous patch applied, HV timer no longer falls back to SW timer.
Additionally, while target_expiration is catching up to the current time,
the VMX-preemption timer is set to 0 before each VM entry. According to
Intel SDM 27.7.4 ("VMX-Preemption Timer"), if the timer has already expired
at VM entry, a VM exit occurs before any guest instruction executes. As a
result, the guest cannot run instructions during this period and cannot
reach vcpu_block() to switch to the SW timer, preventing hardlockup.

However, unnecessary repeated catch-ups should still be avoided. Therefore,
if the advanced target_expiration is still less than the current time, we
immediately catch up to the current time in the handler.

Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/x86/kvm/lapic.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fa07a303767c..307e2d6c3450 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2140,17 +2140,25 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 	apic->lapic_timer.target_expiration =
 		ktime_add_ns(apic->lapic_timer.target_expiration,
 				apic->lapic_timer.period);
-	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
 
 	/*
-	 * Don't adjust the tscdeadline if the next period has already expired,
-	 * e.g. due to software overhead resulting in delays larger than the
-	 * period.  Blindly adding a negative delta could cause the deadline to
-	 * become excessively large due to the deadline being an unsigned value.
+	 * When the vm is suspend, the hv timer also stops advancing. After it
+	 * is resumed, this may result in a large delta. If the
+	 * target_expiration only advances by one period each time, it will
+	 * cause KVM to frequently handle timer expirations.
 	 */
+	if (apic->lapic_timer.period > 0 &&
+	    ktime_before(apic->lapic_timer.target_expiration, now))
+		apic->lapic_timer.target_expiration = now;
+
+	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
 	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl);
-	if (delta > 0)
-		apic->lapic_timer.tscdeadline += nsec_to_cycles(apic->vcpu, delta);
+	/*
+	 * Note: delta must not be negative. Otherwise, blindly adding a
+	 * negative delta could cause the deadline to become excessively large
+	 * due to the deadline being an unsigned value.
+	 */
+	apic->lapic_timer.tscdeadline += nsec_to_cycles(apic->vcpu, delta);
 }
 
 static void start_sw_period(struct kvm_lapic *apic)
@@ -2980,7 +2988,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 
 	if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;
-- 
2.47.0


