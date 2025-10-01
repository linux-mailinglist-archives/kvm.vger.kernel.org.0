Return-Path: <kvm+bounces-59272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3796CBAFBCB
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A523C4A71B0
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BFF2BF01D;
	Wed,  1 Oct 2025 08:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMwwT9kQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F7D27F16A
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759308723; cv=none; b=oX0Wfmy4G8OEvUMg/92wfkR6WsBvBg7tkk1yYPTpz4MfxgTkL95/KKqkaVr+sGMlGTQOx0wtk9IngQEHEfOSkCOB+UvlH6gd8G3WBF35suyTYw0Lrlo3iL240PR1J72Ieu0CHQeHGuJ3XadJnboOUDzGTX3RPA2ZVjXy6HIWmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759308723; c=relaxed/simple;
	bh=J/dzWtKuI6KBjBEpLOQM0goLapAMplM4s0j7SX3F+KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vBpUUMQaRTUwiomSbc3EYmwrsQReqbgLylM1jwOqUtho244u+u3dZJK3bcGWjTwO3RIcvo/DgDE3dmdkwlpF6TOeZG6GoOsitDAvxu8blUciA6loeb8KH3znERJ0LRvumpoQ9EJYp+DRduvIpQQ47jhnMcbX2cJ6swGlPHmlr1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMwwT9kQ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-269639879c3so66988415ad.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759308720; x=1759913520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qp4XEa7ToS5FljKv+e4kbXkPaJ8IiCtEps0yhLGiUvo=;
        b=SMwwT9kQAT+026Dlsnx8iiaALwf7jm8DFODZwPw+8OKaVgo5O5I7k6P6ARfdyHhKJM
         +9S6bWFignCoMU5KsyyBxZJzOFJY1b3Sqi/kriUkeHU4OpNFb8Vo9o4rwSxLvijJsSJN
         1o0OPLA4H4xtBZsjgLgGXxlkSxZBcnoupT7Q3YsLYV+Dt73/OKDtrXBzBkEfJmFCqRHK
         pa04WzI2M021yQRgaMbYXkXpwftgtE+blSl7VKCfVqQXHadbC+zmmuhDmiguBfaMk/KV
         ok8ReOPg7HXAOB120/FJG5rFKtwUmysYo2WnBnrCoBsIlTDpvS6Daastd7kiYN1ARfAK
         p/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759308720; x=1759913520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qp4XEa7ToS5FljKv+e4kbXkPaJ8IiCtEps0yhLGiUvo=;
        b=L8EKjwVjTepsDENVL1riV4z14FUxLvO8XJ8MRWTvSYP/rSdsrG/teK4NRGaMCN0G4Z
         SOUIOGpO0E0QRXApreEkwEM81P/7XxJNBm31ae9g6V+aRMIBz2KVTE19ZyEpE/K7+jIT
         Z3luswaT1H2DfGI34b9u/hEwgROV8Qi4xrTF52KWHScxFx4PM7PvyFQ/qlMmuVBZnYqU
         HAjIO2bxRlL63qNRCCbUP3uWdjZrVYH0K8UexMZgXKo7nQmOgJhzV/vT+n064Q9djyxP
         U6Vc9XH3u4nBWOndZ81lHhCmMVoigVmFZv88UtX8j0JVAPkp6X5YcgIUlaF02480rsns
         dMTg==
X-Forwarded-Encrypted: i=1; AJvYcCUP20gOV6MbR+HPwaJA/xnxSWWdDd31Fd5PXVggJj/WF4VCFjNHCI99ZXAgtlhi58kU2IA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMsZQWJtn/pBXFPlNTOdx2azPSDolOMGuSeCE20NsnBBlF7Gei
	rEsSYN/URmR6dhXMrvQnYdFZ/rm5tt5prOa5IikMtCw+8HoAOEYwtsLCi2+luQdk6o0=
X-Gm-Gg: ASbGncue3iT5+ygTiR7nROB7c+FVOjQvd/UPmGxEMMMWDjLSSlTmIFj3XargP1+2Xl0
	72eex4PgiH5C9u5HKLgRewySGOkjv1YgsFralVdyinPEoTIVC/E299J23QXAvKjvTD+cWpkj8PQ
	feONKLMkBhyneHNVCst86saH1NRAnjI6cLa7uQErbJ6ckwY+C4U9jlnEoZ1/wc3888B38JsOo1f
	6db3wi/ULUZDJ4CKhUzpt+xly0mtl8OExnomlUDOYJ+N1mIEHD+WPJmywvfYm5v9VxD6VtQVfYi
	7xDvO10PsUud3IarbRDCPYfBjmPsuPYW1UUA9wCijWW0eE3oLMT83/RR+XpXbO032k/2m0hxDP+
	uvowbwWSeQjVhSnM7qATmT3lAPyEV5N4wwUXcuop91DPpVf1gUA2yAi1WdVo/
X-Google-Smtp-Source: AGHT+IEHdZm9mfkBKVeO9ICnDi0prrIOk7t9NdFH7Nb8A1i6qAUcHyz3K7tduBTbrUHYsSRsis4o3w==
X-Received: by 2002:a17:903:189:b0:24e:3cf2:2453 with SMTP id d9443c01a7336-28e7f326956mr31904445ad.61.1759308720391;
        Wed, 01 Oct 2025 01:52:00 -0700 (PDT)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed68821c8sm178451175ad.74.2025.10.01.01.51.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:51:59 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: fuqiang wang <fuqiang.wng@gmail.com>,
	yu chen <chen.yu@easystack.com>,
	dongxu zhang <dongxu.zhang@easystack.com>
Subject: [PATCH] avoid hv timer fallback to sw timer if delay exceeds period
Date: Wed,  1 Oct 2025 16:50:39 +0800
Message-ID: <20251001085039.91635-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the guest uses the APIC periodic timer, if the delay exceeds the
period, the delta will be negative. nsec_to_cycles() may then convert this
delta into an absolute value larger than guest_l1_tsc, resulting in a
negative tscdeadline. Since the hv timer supports a maximum bit width of
cpu_preemption_timer_multi + 32, this causes the hv timer setup to fail and
switch to the sw timer.

Moreover, due to the commit 98c25ead5eda ("KVM: VMX: Move preemption timer
<=> hrtimer dance to common x86"), if the guest is using the sw timer
before blocking, it will continue to use the sw timer after being woken up,
and will not switch back to the hv timer until the relevant APIC timer
register is reprogrammed.  Since the periodic timer does not require
frequent APIC timer register programming, the guest may continue to use the
software timer for an extended period.

The reproduction steps and patch verification results at link [1].

[1]: https://github.com/cai-fuqiang/kernel_test/tree/master/period_timer_test

Fixes: 98c25ead5eda ("KVM: VMX: Move preemption timer <=> hrtimer dance to common x86")
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/x86/kvm/lapic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5fc437341e03..afd349f4d933 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2036,6 +2036,9 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 	u64 tscl = rdtsc();
 	ktime_t delta;
 
+	u64 delta_cycles_u;
+	u64 delta_cycles_s;
+
 	/*
 	 * Synchronize both deadlines to the same time source or
 	 * differences in the periods (caused by differences in the
@@ -2047,8 +2050,11 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 		ktime_add_ns(apic->lapic_timer.target_expiration,
 				apic->lapic_timer.period);
 	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
+	delta_cycles_u = nsec_to_cycles(apic->vcpu, abs(delta));
+	delta_cycles_s = delta > 0 ? delta_cycles_u : -delta_cycles_u;
+
 	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
-		nsec_to_cycles(apic->vcpu, delta);
+		delta_cycles_s;
 }
 
 static void start_sw_period(struct kvm_lapic *apic)
-- 
2.47.0


