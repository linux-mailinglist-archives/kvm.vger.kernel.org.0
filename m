Return-Path: <kvm+bounces-60682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0A1BF7744
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CC5D543CB7
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086CB3451A6;
	Tue, 21 Oct 2025 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7KW6QGD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EBA3446CD
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761061273; cv=none; b=NgzO50biktkbqu+oV+Opv1/uzIzUGWnIsehF+WovYYF1kuHy5Rbmhw01itXaspjZOXa6Ci66GbqEB+bAp8XZmVWX8kBA3TvImwNekAFjqxTLgAZsYeWzN1s8QNU4DD9UpuBWmc09OjHx5V7Lo2RZN0HOX2KgVrJ8CTZWfVrANyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761061273; c=relaxed/simple;
	bh=e0gkwlBemXCSBwwddgJoHX+/v6dnIudPTn869cFxe7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQHhVSf65oRlo0/t0TotcK8ig81q4U8KaZ9XbLvemYgv+ATg0hC2xhscuSwa2bsRjREzsSQFnUf88y1Br2d1uajfAY9FukQKLoTcqq7cpGjenQkkwgZaAknjbgyMcWjQ0wQvwrPH5kB7IBXIu6k6UQp7M8jiIV2p5tFZHRuhrMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7KW6QGD; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33bb090aa78so5019319a91.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761061270; x=1761666070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3ce92NCooPokgRFEi3LP0UGh1WqBX737txf2jDC0QE=;
        b=F7KW6QGD2rNIBoiKy3AohX91Rl9F5DS5DXoFllLsxImXwu+KmelW+tIRHTX71HK4il
         +BXY37bhAeokXUEeoMEtvvau1+LqJ8dmzJrEW7eao1/DOPp5UupOOzaWG02GNyn3mCaS
         sDEsnGfhfOyv2TIARRzbfzlCfHm5q2MFAUhWwdPe0b2cSHvvAWvOGmEc1kfePeDzP4eR
         Kf/3x62P6M/zBopS8qMhm/Y1crYmNM0YeuE9eIlcb36TuHwjS5aZjND5NBPU1R/KDzQb
         Vt/iJzjX2C25p/VFDYBe/8ciEKALcXPgMwuPm8bmwJfaidpwtT6D/zoN0/3XCnrWwJi+
         jkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061270; x=1761666070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n3ce92NCooPokgRFEi3LP0UGh1WqBX737txf2jDC0QE=;
        b=scpFpmOfJzw7hZsXooygZmP5pY04NRfK5XYDl2/Im3zFB9bZ2Cu6/aiBZN6lQ0GBKx
         J6cq/9SNjQn0WxXDxLZ0/UjEozgDM1DZmocgszgwRCN6aJHAyni3yA2sqU2u5xt/ACJc
         A0GxShxhkiRubt+RQ5WF7aLKx4UEN/J+ZMbf5TgD+VWXDSRzgoboS1hxpfc0XkIwRV7O
         o4MD6aOE2GB0Yhk1CemtJo7wfyisNlDAp5fqk4CKheNfu8xifY3b8wB/O283VUNyLu3+
         575zP6wqe8fsoMkczAiPzQbPp++EPG5BeQUjxRtGuNcVNDMYgtqjdO7hDW6LSH7mNeGS
         42aA==
X-Forwarded-Encrypted: i=1; AJvYcCUt9iASFIVq91pq+bOPtteS6KwpxM0rQFgqzR/TwS/A6/WFsDIKrT2RQZRnTK/leP/NEZw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw2jRgYqL6wzLldRQKrOh81XTYr/JpbVXDQpmSV5e413wYL227
	GdRrc8yrUEfRIdW08VZ0NSEPEKUxADxJFZZYga1YPHMppp4OIJec40Ir
X-Gm-Gg: ASbGncsW/K7BIDknLGs9A0ZtuDK+2l6UOfwaBJgeKAiz7chZcEYKjMDH+tbykYrsxhM
	NUlkuu5gd9j9T9f+Ri3EYsN/mocBLAJKZGq1KdlJwGax2Gf4RYjAMRqygzavVARo7jiGNc+j7tL
	en63BteXDxHFM7jolxHjiObdvEtUz/f37fqSRat9Mg8UNqf0hwq+cegFG9FATPqnrofbVDCkQw5
	fXLcVaIgwygvIgqFffi7A4dnfTBxMIWReb3zmriWu2w1sDdSeH54PO5zXmVhD94pkseKtlWY0va
	VjgiIvRHwv9D2IIDTUHfOnTfDRoHj+FWWo7BV2Yqg84amnqgo4f7mWcOR0jcDY0KGADeIYI5FiI
	2+STNzTnH5V/0x2XhrkeW0vTHpOBlKKA6gff2UNrminW/gfRiY4Vxr2r5wZP59AotmUit2lK2Ff
	zeFJ39IgdZgDoTwjXw/w==
X-Google-Smtp-Source: AGHT+IHGEBDmN+8ALME98r4cPlj9TIB9R9dfE9HuJOuR6+rubeOOAvJAJYzjSy4NHtHny2nEcMuC/w==
X-Received: by 2002:a17:90b:270a:b0:32e:8c14:5d09 with SMTP id 98e67ed59e1d1-33bcf86287fmr21759932a91.7.1761061269630;
        Tue, 21 Oct 2025 08:41:09 -0700 (PDT)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5de09fa4sm11293742a91.7.2025.10.21.08.41.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 08:41:09 -0700 (PDT)
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
Cc: fuqiang wang <fuqiang.wng@gmail.com>
Subject: [PATCH v2 2/2] fix hardlockup when waking VM after long suspend
Date: Tue, 21 Oct 2025 23:40:52 +0800
Message-ID: <20251021154052.17132-3-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251021154052.17132-1-fuqiang.wng@gmail.com>
References: <20251021154052.17132-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a virtual machine uses the hv timer during suspend, the kvm timer does
not advance. After a long period, if the VM is woken up, there will be a
large gap between target_expiration and now. Since each timer expiration
only advances target_expiration by one period, the timer expiration
function will be repeatedly executed.

Without the previous patch merged, the advanced target_expiration is less
than now, which causes tscdeadline to be set to a negative value. This
results in HV timer setup failure and a fallback to the SW timer. After
switching to the SW timer, apic_timer_fn is repeatedly executed within a
single clock interrupt handler, leading to a hardlockup:

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

After the previous patch is merged, the HV timer can no longer fall back to
the SW timer. Additionally, while target_expiration is catching up to the
current time, the VMX-preemption timer is set to 0 before each VM entry.
According to Intel SDM 27.7.4 “VMX-Preemption Timer”: if the VMX-preemption
timer has already expired at VM entry, a VM exit will occur before any
instruction is executed. As a result, the guest cannot execute any
instructions during this period, and therefore has no opportunity to reach
vcpu_block() to switch to the SW timer. Thus, a hardlockup will not occur.

However, it is still necessary to eliminate unnecessary multiple catch-ups.
Therefore, if the advanced target_expiration is still less than now, we
catch up to now in the current handling.

Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fa07a303767c..ba30de871929 100644
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
-- 
2.47.0


