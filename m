Return-Path: <kvm+bounces-63048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CB94BC5A05D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 861554EA50F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FB9322A29;
	Thu, 13 Nov 2025 20:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B0MPILvC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAEC324B1F
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 20:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763067086; cv=none; b=VDMBkyFJPH0dA6HECKs0tdvsMWUXaKsATA3NfGHvMbzZsxSyQTKyYQQgiMl4nF2nBJ8k3vbIsDvNueVB9f3/WcIfUAATWhh8QwOscdRJ7TsKEQGGL0iAHhFpzeChvb7L3OLSD0N7Bzgf8QIjJTAsQaiWSML7a3fpRXZtcNwu+aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763067086; c=relaxed/simple;
	bh=eAhyJbLqUXlwQlucntSBQU+UA5T0/Z2bvA4Pjea03G0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ivY/hzs25JHbgeWW3W41G9ej2gnt0NdnuEW1RVfNqHpCDWkkMsaNp3uv2r6nn55MLabHC2j7uDIiJDxhSi2Hte0IRPQS3Jomg6fBKNEutNuLqj2Hi4lS5qoCGaUz02edvK3FdY2dT4qJDNQ/zmq/IbFkmtPNN+1D4XGGSKF4qUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B0MPILvC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297dfae179bso29898115ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 12:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763067084; x=1763671884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C7fYJA4HWXsvtk3lehp2/p12kOlA15qEdCD6I2JDssg=;
        b=B0MPILvC44cJuscNyamdQu+kKF0fqGhkMkip9WS7b0do7Hm+0CRS87MfZgAYJqdzgB
         1ZqORR7WMPmtMrhCP+LsHR5RDtXEJBpU5iSkjhHy6o9TwnHsVzDazwCX5aYkZ8wGCMEl
         gnxkk/m5DPadMK3CsMrlgaMpqDrSAmxrybiey/qcbaYIAmIcpmGmw9xmq1aNozNIHvtW
         Vf2r6dBJRhXq/+0PvcYu1D51z4M8oNt2MQcQjQgssYuwa6u4xjo4UtXQqd9n8Fc1yJu2
         aE5+QN0UomNpOJiuGTDJm8i1dv0mHEVBAYUCIeRxAbaG17Xx6DEcNp+zbCe1FSggjtYJ
         bS+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763067084; x=1763671884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7fYJA4HWXsvtk3lehp2/p12kOlA15qEdCD6I2JDssg=;
        b=eBzH67W7oLLkE6TIeL3EkfiIvV+bCHQSicLD611qGq3htZroDiYK+jwFfec8O4k0W5
         krA7Z19KUlDMKwUbzg/wl/aKBszSLnb9lnSalM5LpFtfEtXZCC3M9exCWLjLsm9hylAZ
         hk5iaZo023K5DBrbIyn4mg808SLgwPQG+iwMRp0Tk/riYkHm7ZTibv81qyf6Q7/cEARD
         sjPWcwcSp1FuAmXAaDiaVfh3ge75btmTPbYAYrBwptx8MSYinj7jrF9L7U/DLpIPZJJs
         FWni+YVdQgdqMdmUf7wz3YvwU+jOzTGIiccZKi5eNWRU4ZZH10ldF/k12POzDxs27sTj
         ANig==
X-Gm-Message-State: AOJu0YxjixwQ02fFnxv1PbfC1wvw4PDsFgyO6VL1EoArnBIb15jbAA1H
	IKhARzIGlyTgKSZ17BRIgZHGReepUPmYSJEREAXDz05RVaHSzhiFbTpFomYLRWtIDCW/NTGi2Wf
	aAtdGqQ==
X-Google-Smtp-Source: AGHT+IFcKCPvjnTbeCT8KN8m2AR8BSXmhvS7vXQLw6Thu8ciwldiBuq98W7UYmI82opbMJksxR+2zZr76OU=
X-Received: from plau6.prod.google.com ([2002:a17:903:3046:b0:258:dc43:b015])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b0d:b0:295:4d50:aab8
 with SMTP id d9443c01a7336-2986a6c3747mr3264535ad.24.1763067084383; Thu, 13
 Nov 2025 12:51:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 12:51:14 -0800
In-Reply-To: <20251113205114.1647493-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113205114.1647493-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113205114.1647493-5-seanjc@google.com>
Subject: [PATCH v6 4/4] KVM: x86: Grab lapic_timer in a local variable to
 cleanup periodic code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fuqiang wang <fuqiang.wng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Stash apic->lapic_timer in a local "ktimer" variable in
advance_periodic_target_expiration() to eliminate a few unaligned wraps,
and to make the code easier to read overall.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8b6ec3304100..1597dd0b0cc6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2126,6 +2126,7 @@ static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
 
 static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 {
+	struct kvm_timer *ktimer = &apic->lapic_timer;
 	ktime_t now = ktime_get();
 	u64 tscl = rdtsc();
 	ktime_t delta;
@@ -2137,9 +2138,8 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 	 * over time as differences in the periods accumulate, e.g. due to
 	 * differences in the underlying clocks or numerical approximation errors.
 	 */
-	apic->lapic_timer.target_expiration =
-		ktime_add_ns(apic->lapic_timer.target_expiration,
-				apic->lapic_timer.period);
+	ktimer->target_expiration = ktime_add_ns(ktimer->target_expiration,
+						 ktimer->period);
 
 	/*
 	 * If the new expiration is in the past, e.g. because userspace stopped
@@ -2150,17 +2150,17 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 	 * past will do nothing more than waste host cycles, and can even lead
 	 * to a hard lockup in extreme cases.
 	 */
-	if (ktime_before(apic->lapic_timer.target_expiration, now))
-		apic->lapic_timer.target_expiration = now;
+	if (ktime_before(ktimer->target_expiration, now))
+		ktimer->target_expiration = now;
 
 	/*
 	 * Note, ensuring the expiration isn't in the past also prevents delta
 	 * from going negative, which could cause the TSC deadline to become
 	 * excessively large due to it an unsigned value.
 	 */
-	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
-	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
-		nsec_to_cycles(apic->vcpu, delta);
+	delta = ktime_sub(ktimer->target_expiration, now);
+	ktimer->tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
+			      nsec_to_cycles(apic->vcpu, delta);
 }
 
 static void start_sw_period(struct kvm_lapic *apic)
-- 
2.52.0.rc1.455.g30608eb744-goog


