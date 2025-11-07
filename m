Return-Path: <kvm+bounces-62266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 85417C3E641
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 04:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ED9E94E3660
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 03:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71445248881;
	Fri,  7 Nov 2025 03:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjQO7QNP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194B65FDA7
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 03:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762487305; cv=none; b=sXmsv9f/9ChOY3ImykPltlCjJ1834R+YgfjoZfhthhVkU9sC1aHGD/i5H60ZzUbLTuRQxL/CglgyijTZfvHyYvqeDpyg1aGSdY/mQ9DXT08Ag3S+/fGc+hE5vQl5bXj4cjflj7IBqDah0zS7xqdF6Gr/2T5OFpGy4AX9vf/QRVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762487305; c=relaxed/simple;
	bh=kQyAVI4y8yipNmAogQTmIHyYXsOFyh7Qtld2V6eqX6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQkcEHOJ7vSEPlROjVe9YGF4pvwZ+563jsoFMCuAZXsqSZxfLr1CvNgzbbD60xtSbZ36ND4RM37hk35/y0mKQjcirpqSWyrlqrCFR76XOhSbeKu79Hqkr2vk4Q9C7l+uCQTW+pHelZ9P2BDqW1UdTJt4fa1GSdbqy+HZ+aM9+dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjQO7QNP; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3418ac74bffso255373a91.1
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 19:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762487303; x=1763092103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlM1DNs/nEhfiMi8hhEV6pv9uodDW5WOGwEIwULU83w=;
        b=IjQO7QNPf+dClcJrWD3jzZfxp/qwiXrSt5HhVDFFO7I7zNhFlURepc3CfPPekPz1VF
         aM84z/lo52Mn+GnVaWMZ0MOpBgfjr5nuSNAwZmFjqCk7433FtpyhV4IUuw2kx+QDuqXB
         qcvpFKX8rhr1YW3S1yMMbciArSwf+TnETBDEUcZ7+uVE0ErbGk1nCv9ZulCd57S8SBZy
         0KNx0/1UUjHGK2qNS8KkrbJKCjDNtIuhseukGOOUo+F1hGj+Iqtey8lOUCko0c2H3MWP
         saK7ci+56Of7HAUvRrhD0hZX6qaaZmkQ00wjFGDO1xeYtju50QKBge7CeG+5ueZKXUWe
         hK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762487303; x=1763092103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jlM1DNs/nEhfiMi8hhEV6pv9uodDW5WOGwEIwULU83w=;
        b=BSgaZZNefKlZElVieyABzOE6yjgFbCWQIjqZcQsRYim81GFX6jby7l6V6PsO6ycMIp
         luHSN5VI40kQ5fWQHox5/i6YHMAD9JObm/3/ZxgIVmmA51f7/7tE5H02pPOLFDu7bFNJ
         5J3TyoHv4GM3QPtNmWY2j0NjQUCIAPXPolKzfsOU3LwK1FBy6F/tYw2mG6e9Tb+L8Ojq
         ofs8dS3CX6UJPgdq5N83iX97kY+UdZqmHOXpRISg7yK/wWvXgSGnieGMjvZWe0i18l7P
         r1obfereIDFNLSICxT+nveM0pFR4c2wBG/VEqYxVxJ/JXq67niqmu+zf7auUGhCf35zz
         fRzw==
X-Forwarded-Encrypted: i=1; AJvYcCVdg6f8uG+GUYs2iUJXaRsitWQuCNxO1lu9xX+SfO9Q+1lz1K6YacnUrNsibbUAYgd7e6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhtN9KkzK8lg0kCXf1HyyZcJEwLwIKUms+4BLSmFaCtPVE8iPJ
	988qZXN50g1ka3lwxJaXK+uShV6Ixo+kX0xN4UPXFLXnu0ET6o5Hrbmx8LGuVnYkrQQ=
X-Gm-Gg: ASbGnctOHD500bW2T5uVfkcpIb5dNvUo9B9ajDOA5eS7KWbgnHjAeeOw43qSAP+Ozci
	aKxJDebrmPsMkBQEG5+jDjXZl3FHsZwZxlIcA5MyQw3DzaJ6yKcv8q0UEOddt5iU3tgfY9QsB8U
	Gfa6ursJxnxcD1X1xb1UOgOK3EtPjvSBZT5FiKF4GOVI7SNogK4stkgxotEQQyu2oB0KQeRPSXF
	w+ka+anmsOuvduJ05IcsboZEVKDVlF9/Ea/q+53cme7Xddy22hj+iyKLFygc70iROO5h1UitN5h
	7j1L6ZZQXlJqBIrxO3nKxqlZ7zSzcyNLY6DMYe7r/VcqKhlC3j7rmOp6gCqaF3AqsamjfXavIyC
	NMz7eeBg//mzZSa1vgWTjNG20HsN7IlEIJxWpMnLYayYGMNtMOQfxg8TEZnUOqbhy4TZhCcFOdE
	7vumX5rObeOFuQ6NIdUPL/mIIgxhOV
X-Google-Smtp-Source: AGHT+IEUe0G/nUsevGa54SNa5im91FTU/jSkO0XpC6wLwexvqmtd6apDfIPbGxtS3ZUe1/mXkDlnQg==
X-Received: by 2002:a17:90b:4a52:b0:340:a5b2:c305 with SMTP id 98e67ed59e1d1-3434c4e3b66mr1758512a91.2.1762487303249;
        Thu, 06 Nov 2025 19:48:23 -0800 (PST)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c356300sm989552a91.18.2025.11.06.19.48.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Nov 2025 19:48:22 -0800 (PST)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: fuqiang wang <fuqiang.wng@gmail.com>,
	yu chen <33988979@163.com>,
	dongxu zhang <xu910121@sina.com>
Subject: [PATCH v5 1/1] KVM: x86: Fix VM hard lockup after prolonged suspend with periodic HV timer
Date: Fri,  7 Nov 2025 11:48:00 +0800
Message-ID: <20251107034802.39763-2-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251107034802.39763-1-fuqiang.wng@gmail.com>
References: <20251107034802.39763-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a VM is suspended while using the periodic HV timer, the KVM timer
also ceases to advance. After the VM resumes from a prolonged suspend,
there will be a huge gap between target_expiration and the current time.
Because target_expiration is incremented by only one period on each KVM
timer expiration, this leads to a series of KVM timer expirations occurring
rapidly after the VM resumes.

More critically, when the VM first triggers a periodic HV timer expiration
after resuming, executing advance_periodic_target_expiration() advance
target_expiration by one period, but it will still be earlier than the
current time (now).  As a result, delta may be calculated as a negative
value. Subsequently, nsec_to_cycles() convert this delta into an absolute
value larger than guest_l1_tsc, resulting in a negative tscdeadline. Since
the hv timer supports a maximum bit width of cpu_preemption_timer_multi +
32, this causes the hv timer setup to fail and switch to the sw timer.

After switching to the software timer, periodic timer expiration callbacks
may be executed consecutively within a single clock interrupt handler, with
interrupts disabled until target_expiration is advanced to now. If this
situation persists for an extended period, it could result in a hard
lockup.

Here is a stack trace from a Windows VM that encountered a hard lockup
after resuming from a long suspend.

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

Moreover, if the suspend duration of the virtual machine is not long enough
to trigger a hard lockup in this scenario, due to the commit 98c25ead5eda
("KVM: VMX: Move preemption timer <=> hrtimer dance to common x86"), if the
guest is using the sw timer before blocking, it will continue to use the sw
timer after being woken up, and will not switch back to the hv timer until
the relevant APIC timer register is reprogrammed.  Since the periodic timer
does not require frequent APIC timer register programming, the guest may
continue to use the software timer for an extended period.

This patch makes the following modification: When handling KVM periodic
timer expiration, if we find that the advanced target_expiration is still
less than now, we set target_expiration directly to now (just like how
update_target_expiration handles the remaining).

Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/x86/kvm/lapic.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..bc082271c81c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2131,18 +2131,34 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 	ktime_t delta;
 
 	/*
-	 * Synchronize both deadlines to the same time source or
-	 * differences in the periods (caused by differences in the
-	 * underlying clocks or numerical approximation errors) will
-	 * cause the two to drift apart over time as the errors
-	 * accumulate.
+	 * Use kernel time as the time source for both deadlines so that they
+	 * stay synchronized.  Computing each deadline independently will cause
+	 * the two deadlines to drift apart over time as differences in the
+	 * periods accumulate, e.g. due to differences in the underlying clocks
+	 * or numerical approximation errors.
 	 */
 	apic->lapic_timer.target_expiration =
 		ktime_add_ns(apic->lapic_timer.target_expiration,
 				apic->lapic_timer.period);
+
+	/*
+	 * When the vm is suspend, the hv timer also stops advancing. After it
+	 * is resumed, this may result in a large delta. If the
+	 * target_expiration only advances by one period each time, it will
+	 * cause KVM to frequently handle timer expirations.
+	 */
+	if (apic->lapic_timer.period > 0 &&
+	    ktime_before(apic->lapic_timer.target_expiration, now))
+		apic->lapic_timer.target_expiration = now;
+
 	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
-	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
-		nsec_to_cycles(apic->vcpu, delta);
+	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl);
+	/*
+	 * Note: delta must not be negative. Otherwise, blindly adding a
+	 * negative delta could cause the deadline to become excessively large
+	 * due to the tscdeadline being an unsigned value.
+	 */
+	apic->lapic_timer.tscdeadline += nsec_to_cycles(apic->vcpu, delta);
 }
 
 static void start_sw_period(struct kvm_lapic *apic)
@@ -2972,7 +2988,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 
 	if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;
-- 
2.47.0


