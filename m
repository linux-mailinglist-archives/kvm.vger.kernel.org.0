Return-Path: <kvm+bounces-62053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D9063C35F07
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 14:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 912604FC82B
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 13:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449D732548D;
	Wed,  5 Nov 2025 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgeecC9A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27A8314A6D
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762350916; cv=none; b=ZH3Bgswagrp/hPlU5SPur3zhAZRS1luLS/h5SzbAvY7D1y/jqVLIeVts+aOliHhtosLTBJyOAqY4AwGxGoGBL2YjSq5LJhUlH8AAVmwpGEGRhJtkibeSIHrQnfXkUIkDcCjouev65ELJiz1Wd0ZGFhx0ZcIF43c0udYfbe6vFiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762350916; c=relaxed/simple;
	bh=EaFzjkrBGwr52D5y36CtwQDRYHAo0O4gChoB96JzAT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihtvW6OATw8Isbn+d9JWn6qJIEJb+1n/cltoOcX+qrIX4J06jZ2zcyD3hBbknIr2+7P0j5i5IvbMg27pyl1VWGv6eej1LZX1E/WKImfJnKmYw3pkBPNMX/fcTYxMvoyKIpQAmcmnu2RdAQsIVItToBu5QoVBoj1yUUOs0j4LHPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PgeecC9A; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7930132f59aso9252543b3a.0
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 05:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762350914; x=1762955714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NcRQ1cUZC6yZ7cVW9F+sABQZIcnrZ0hG1K1BLLGNeV8=;
        b=PgeecC9AKxZz164QDeKyXWZU8NJtbNWmMkznBItcNxIk8KNSQvfLOofKZb2wvrq4lU
         WdMvgYCyNKIaLxgr183eXDEhgTOApwslGth+EKR9djRFjeD1aQy6mdFM87sSW8Up7A1n
         SW2QSvLDb4BSn0Y7HY9VPBHk6USSsDT1QEYZKExz3SpTgtPu+7AqhHR/QvjXqMJkesS8
         48R5wRtch7xxpTiLJQ9I700SV0VDSuQS7CsTJulF7yzHZ7K+GtQyF0WXrDPHpuk0Qe78
         gcgbwijWC/r6Uuv3owUZsWy+Xo+ConD0Ldil/PNK07x3wr0EP4CR5HBLxjoj9gOvhZL9
         Z2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762350914; x=1762955714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NcRQ1cUZC6yZ7cVW9F+sABQZIcnrZ0hG1K1BLLGNeV8=;
        b=vQfn58fmE7pnU9lFwg9FVeMpd29t9jysr5VgiH6BgDvD4ywfGZE4Mf1WI6qbPWLR1U
         3yKsIOsoYPE5Qc5sF+amIoOpiYKchc3LVcJZRKcvE0jjSLyZweUdMCoJsO23Nv1hzVaZ
         rzIg8sjOYvtFwRvLVlMXHeJuse5B2AQYgFkz5cBes1Kt1BBgwCDq1cAk3NiNdeRrmqYv
         zsKHoyiFhFj/AAanGVYYcyo49mUwwLLLLS8FJ2+xqgcF6RlF3SXnpkznqvRs/gyAG53G
         JUlAhavJxvL3uOepPhQZbMQ2WTG9UXjefcFJ+mOV2kd+XXEHWRdSJSt6zXrU0mLBog1m
         88tw==
X-Forwarded-Encrypted: i=1; AJvYcCUj0yBRq8ee4Fq+PyljM2MPDGJWTju2Y7rwhW1ufo6bEhu5Mmoge1flsJKkIx4DsLP4Bqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWME8J0sizkxfJJMSPMluH9sO5VLQif4+VgSOzntwSnD4F7+th
	AA0M2tIOgusCmJW1/pFZvLJNFFqVfugLEvNak0ulHKmM4eQ7+CYLiXGH
X-Gm-Gg: ASbGncuOWb/VqzvT/EN2CT7sFUB/7+TxREnX7TeVM3uuiNH8o84z7JHySxUE2ereEMc
	VK+FF/VA6EBR2D5SMJy9spHKAkoFRSUUvPO0RODqwtK8rg0grUnuPzL5eku5qBKa259HsGPzJbn
	WG3Hyq2hwH7g5zrgpebbbOB1nn80cSUFlcTmFt4azRVc/qTG7wh9nuuG4MYbpvVsniY9slr307A
	se5gebN6oi1kySHVW0DX5eWN983ANCXR/Ll5vASuaIR7OrW5+whNiLuAFmSUiqVkK7J5necjUHO
	jH779T+7bghX+arAjd8mUxasL8sUs8s+zkzpd/nbvUuM4SkHWByY9DWuTTtY9bYOfsg9U6Mbtx7
	PXoSgKyBMTis5yN0Q698nhXN1eZvXPjbp+N5tgM/Uon6WO5xnLse4T7Q2um560/+YwgmldIhtdv
	Dp9EMa7Te6hwp//w==
X-Google-Smtp-Source: AGHT+IGDcC3wh7/KWdmbQoENYqy/Rgl1TR7VHbu3/5Ebq1/tftdbfqSA8Jm2moAw860HITRRNLcm+A==
X-Received: by 2002:a05:6a00:4b04:b0:7a2:7930:6854 with SMTP id d2e1a72fcca58-7ae1dcff00bmr4339146b3a.13.1762350914080;
        Wed, 05 Nov 2025 05:55:14 -0800 (PST)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd3246d33sm6467321b3a.13.2025.11.05.05.55.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Nov 2025 05:55:13 -0800 (PST)
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
	yu chen <yuchen33988979@163.com>,
	dongxu zhang <dongxuzhangxu910121@sina.com>
Subject: [PATCH v4 1/1] fix hardlockup when waking VM after long suspend
Date: Wed,  5 Nov 2025 21:53:38 +0800
Message-ID: <20251105135340.33335-2-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251105135340.33335-1-fuqiang.wng@gmail.com>
References: <20251105135340.33335-1-fuqiang.wng@gmail.com>
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

Additionally, if the advanced target_expiration remained less than the
current time, tscdeadline could be set to a negative value.  This would
cause HV timer setup to fail and fallback to the SW timer. After switching
to SW timer, apic_timer_fn could be repeatedly executed within a single
clock interrupt handler, resulting in a hardlockup:

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

We modify it as follows: if, after advancing, after advancing,
target_expiration is still less than the current time, we set
target_expiration directly to now. This also ensures that delta is
non-negative.

Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/x86/kvm/lapic.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..307e2d6c3450 100644
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
+	 * due to the deadline being an unsigned value.
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


