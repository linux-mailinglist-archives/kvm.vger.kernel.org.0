Return-Path: <kvm+bounces-59895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42184BD3143
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 14:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 083F43C40B8
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 12:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05C52E2DC4;
	Mon, 13 Oct 2025 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GS7Jg828"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F40B266B6F
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760359905; cv=none; b=YTdui3Tws9PjYN/X7NePhUA/5gPuRJgoHJHHT1f276jCmjNSMHjQJfVQbk7B9ID1WauZz6zUZGf/Jt2KLcc1pQF2YkGhyZ3IDpWS+NOklJjCd0nT+vARlnAWht05/f/Qgq+GGZwwqXn1eZpLTrFlfl29+2Htqch4wOSlJw5EHvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760359905; c=relaxed/simple;
	bh=J/dzWtKuI6KBjBEpLOQM0goLapAMplM4s0j7SX3F+KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TKKP35XAylKL6JwYFyNCPCsrecB9cexIzX/3o3JDfgOT0EjcPAtZ0PwlR1wfrmVnMrpdoxvBjJ+L7RP7wVp/EhfNfG1IleWTWuZk1gh7oHxZy4amQCo8l0vjVO7KRmj6EZD9gzxgkvg7Boa7RN7LS1jwZvk+ihMvlI0pyp1lGCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GS7Jg828; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-339d7c403b6so4059991a91.2
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 05:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760359904; x=1760964704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qp4XEa7ToS5FljKv+e4kbXkPaJ8IiCtEps0yhLGiUvo=;
        b=GS7Jg828Dy3pvC7EdxvX78txIDyDUBH+bLWj+ewTYxpPQt6m26mMSXAaCOXe6Sn4iK
         wD3x/nFsbfuJemey99taA+7QrUZEEIeHcLh2jwhQC75mZwR5zjI3VnAMdT7Mxg/Tfiz5
         7IRx73c1Ok1JyxM1MEAKDWeOT3lE4j1BgewnpQLPBMhbjSTWMnSHpAwyUKiNZKhoRrxH
         LVn5AQI1FMFglCBipRCYgC5Ru/l64A1N7l5v7aIRsnYgiZDtLzBxFbPx9S1BRinvADtK
         aLsxc4/z2QpcK+Sj2QCLPX1nO9iIXH4Viz0D88ZQPni/Up+YXluoEBbysLkRL62iTsgs
         8Tkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359904; x=1760964704;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qp4XEa7ToS5FljKv+e4kbXkPaJ8IiCtEps0yhLGiUvo=;
        b=r8nVuW/z7sXzou2gDTpWf3rLIT8kHsZlnBTZ8Bckea+jisGonpeTAfifoM0ZNiws/y
         ISgrS8aGKDF+Jspts4Udo/drX4VigjkObs0wr+HpR1Jd8PacONPCSLLjH3GaTNHXT4cx
         twy+88DZC/awfgiY7JBsR5TA1yMtcgCOOS98U6UxJzjbk+csqM1z3L5oWXgsH6UXbjW2
         zfOqsDSNVQyyg7MWRRFPWOnlPmlIVF4guF9aJmli/xVW6iyrIhn3LoyL/qjdFpGjpMqe
         0I5y8Nwht06kZxpQDDKrVX6dqVP7RMS1yRz564UvOV1TA9X+X/4KwwHDej9Stolr3XrC
         7Sfw==
X-Forwarded-Encrypted: i=1; AJvYcCUa7cuTD2OfSK508rPNjhC/NKK3HC+cOwc11ctbPmwxJRdiVO4hjTd4s7OMwCyBhHA9eFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRscB+FmlHt93D9lLhD9p1qf2l0TmfiUNTWFAEUGad7vzAFIZl
	XBlQ16TOYARR0b12g15+0+S0BHTt1sRDQwrCSJBPs9NIJeB7pDEhuh25
X-Gm-Gg: ASbGncuado2mK4NIW50fO+CSz8MZNFX2SFPkD7W6ElByJ8GTEslhego+WHbjgp6FD8X
	rAwLmYNA3czb+SkQ2kuIwGnong1CUieHb2fcw5Nu/fXMoGKUjljjHz6m2S5o1B1hwYxXGX6DoFQ
	gwTV2bdmE+dfpxWOsbrXZMdjh1TLQ6GPY+eZow4tTOAGd6w3Zq7hLkksrB6c8Che9q3821RcCZg
	93QKS2HhrNvVYGEIuZy/5f1+yjr/wXJ2f8dVNexCIm5FY7hhtka9eLDkMOsnIXQv//LHd4hrVWD
	0whWe+if1cvJ6tZWN9fRXq9sXR5M5aePJONXORS2qSJj3JWjnCwHk389AjSW28FBNzNfWQvAS+m
	otaCSgQ9aRymx2vjzZhkhbu3jfp4j3rnNg8XVAXDMibv7e6Z5bfxO6oUaWuTkGEP0Bw==
X-Google-Smtp-Source: AGHT+IHCsN9tB1NFXjLxHlC1i+3jugsgr76PwZZhuE+ita/pwHESbjDT12QASzBbG7b8q5FB7Uoukw==
X-Received: by 2002:a17:90b:17ca:b0:32b:a332:7a0a with SMTP id 98e67ed59e1d1-33b5114b648mr28154449a91.1.1760359903593;
        Mon, 13 Oct 2025 05:51:43 -0700 (PDT)
Received: from localhost.localdomain ([47.82.118.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b5288043fsm9567422a91.0.2025.10.13.05.51.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 05:51:42 -0700 (PDT)
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
	yu chen <chen.yu@easystack.com>,
	dongxu zhang <dongxu.zhang@easystack.com>
Subject: [PATCH RESEND] avoid hv timer fallback to sw timer if delay exceeds period
Date: Mon, 13 Oct 2025 20:51:17 +0800
Message-ID: <20251013125117.87739-1-fuqiang.wng@gmail.com>
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


