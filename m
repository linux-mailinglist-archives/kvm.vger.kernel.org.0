Return-Path: <kvm+bounces-60832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 497B1BFCBE5
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:02:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E163919A23A6
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4509034C153;
	Wed, 22 Oct 2025 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l5fwJX9L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DFB337100
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145298; cv=none; b=uWVquwXbvUyH3z/XUapu2Ajx0JHdB0h+WGja4W7Io3MdG560j2C0leX/lXbogTwr8ZAb4uvEUZfPSzr4/jHjWrMlOh+s7VbxiMy3x7+yvqWyHa862iT5+1r4cxbw0xLkmrpYllxwucqTN/JxhFzj2lolwkVlQzK2C34wtIxHD+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145298; c=relaxed/simple;
	bh=HqZK9FK31xUcTHOGeovXnR3k6rsNamjMy9oCewtnq2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGMYWxoLYHQ+jUYb3Tmz4/fAqnZjB3XnNwg9p1C+xndJkNVtnKsXyrK8fdYJO9cCs4KMKMdUhsZZcjT28LeW/zywvs1Xw4ItZc9qp1aQ0+ETjIF+WowGNgAA5h3cncQHJO+yrggF0eKUkJ8Y5W6UqrWhPcNJyZSMAlAENjiWOfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l5fwJX9L; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-33bc2178d6aso4900160a91.0
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 08:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761145296; x=1761750096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gElp4KIF8VYeQaILzzzMZvdUU8mJFRmHLG+SIVbwPDw=;
        b=l5fwJX9LEKBO0Kpc8cHohJRGcoLcQP7+clOZtvvn3mTZIAG7PrwnMTaN6bpEFzHR9k
         Zj3nuKFit7nA22lN9GkCDRKNG2cXO9TfKyFH9xpQ22tZIgQh0SGX2hLc0BeklNtDr3qN
         SDy9mUocgWUANiwGnA8Bs+Z9bM61siorwPonzjmc8zEXWH6GzcQd0HTFcMSRrX6UcguV
         b/mqpRRKnYl/lAdbwjgW/XBNT9q3mFwSazdekbiC67VN7/w74HfJ7W9l/HdeRzTSCMzA
         1pf1mEWFaxyiUZKuCMBsQ4T8JxiyKSnjxUEaGgJUBtiaHZYJR0eywMYb+3Pbkq82IEla
         G+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761145296; x=1761750096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gElp4KIF8VYeQaILzzzMZvdUU8mJFRmHLG+SIVbwPDw=;
        b=WoI/WJ5FIEXmA9HnvwhHQZL3cDNKIWLTpa/QBr5wvRVJDljHr2AkDuA5Aqe8R+SIBx
         ilyga+6F346K+VPCG57GsdQJyBnyRjz9q9zMt8t0Fta++OM5yzQvR1vTPRvajPPs7gHo
         5erOdLaL/cIdoPYUH1kz1XSo9bFcjSGqKQoR23/kzGmd8rZCFELW+hccBQoQFR9RGBUU
         OIlUnZPBsYnML+piiQ9ws0hBXn8B0eHJkLic8IUmErmEjrASoAL4Fd7yfANgmF8L2ALV
         rLQe1QyNRfZluHq8LDomFrDzlglFOqf6+mfwRTx1l2PyEAjS2R+O6jvQmlvieA0Ex6xn
         gOeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAI5Cgmrh0XIv9hjCVZi6A0+1I4vYa6iM3lHcALxOkgtKD+NIUzGTclcIJZFKpBbmDOVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaPisf7IN3QiGk7BSmFivGpAOt3wXBzYUYZelQCpxxuvYyD6Ek
	TdC+ZJuUrslZ5bpOJt2lFllO6PbpUH1Kt7nv+jGQ42iOgg9K0xd+x8Mi
X-Gm-Gg: ASbGncur8/SuOHjNjB3keOZlRvKVFw18SehVlaErjsRfJWinur8QT+PoC+FoSATLUSY
	GFbi3hYprKQSyUf3u5Gho2WLyae2tXPsgtIJrGM5fVQOU9mHoEjW1VriB/4kXz5coSJNjyQgxDf
	tYWCUzku919oAzbf8LSFR6QTM+pL98BsxdDoIWsMDBIsxAj/I1cCVOg3YUS3tScxn2YBX0S8Ejn
	ii30uh/i7RSFSYaSHiz7CBPf4yEiPJxmF+NqFOWR/pmXQJE+hyVjZ1qr7jrAPB7uKhOh6ypwCka
	vEBk9K1Dlk7XUVEBsgSX1AgLNI62vGDMqf7ZA/QqcUyQ3qal8x1cjxdYd/JAvCKBK00C6e2EAWa
	iZwrH8/8bOnSIN5/6Q/tBIompLIkPYug483OahjRKRRR0x5ZybYBlsORJv2jZj3WBxUMZ0JsgaV
	pjS6ueGLP+Y1NRiRHvk3A33Mll+sxKLLNj9XkiYwejfITeIBo=
X-Google-Smtp-Source: AGHT+IEI8NM6eerSg7O9PVoccAbCBDR+/0TZEfc94ERPhhBgd8KxbPs/KdgxDYfPXFvQatu8ZnH43g==
X-Received: by 2002:a17:90b:28c4:b0:336:b563:993a with SMTP id 98e67ed59e1d1-33bcf8e72f4mr30503562a91.23.1761145295825;
        Wed, 22 Oct 2025 08:01:35 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:8685:174d:2a07:e639])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e3125a3afsm1973624a91.6.2025.10.22.08.01.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 08:01:35 -0700 (PDT)
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
Subject: [PATCH v3 1/2] avoid hv timer fallback to sw timer if delay exceeds period
Date: Wed, 22 Oct 2025 23:00:54 +0800
Message-ID: <20251022150055.2531-2-fuqiang.wng@gmail.com>
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

When the guest uses the APIC periodic timer, if the next period has already
expired, e.g. due to the period being smaller than the delay in processing
the timer, the delta will be negative.  nsec_to_cycles() may then convert
this delta into an absolute value larger than guest_l1_tsc, resulting in a
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

Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..fa07a303767c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2131,18 +2131,26 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
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
 	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
-	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
-		nsec_to_cycles(apic->vcpu, delta);
+
+	/*
+	 * Don't adjust the tscdeadline if the next period has already expired,
+	 * e.g. due to software overhead resulting in delays larger than the
+	 * period.  Blindly adding a negative delta could cause the deadline to
+	 * become excessively large due to the deadline being an unsigned value.
+	 */
+	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl);
+	if (delta > 0)
+		apic->lapic_timer.tscdeadline += nsec_to_cycles(apic->vcpu, delta);
 }
 
 static void start_sw_period(struct kvm_lapic *apic)
-- 
2.47.0


