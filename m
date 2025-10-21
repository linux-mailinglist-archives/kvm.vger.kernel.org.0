Return-Path: <kvm+bounces-60681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ABB5BF7708
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 309C6189556A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B1D3446B5;
	Tue, 21 Oct 2025 15:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BQQJY19X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A74343D90
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761061269; cv=none; b=sSeyWyX4i4S54o7f2wlaF+CJR7oz+8N2wmDFZQxXfudCQsal1HbP43NJcglvTs2AXJGMXPgsT9BgAeVrwf1+6tKKu1DiPIukZH0kuR4Xp1U0kc7M9Wy1vGeTPA3ZbrJ5UXi1eY3UDhXU+XhWbXZF7PpJDKnSpb5A+Jj+/KstJAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761061269; c=relaxed/simple;
	bh=HqZK9FK31xUcTHOGeovXnR3k6rsNamjMy9oCewtnq2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6W05nIQGTO/jHONophSzXVlXwckbEQEa13e2KyTOMgVw/m2HSE6Uskpr7Oe8h5WZXJHVW7VMopnHHYJ2U+5N9rQNNfrX3c5+4+L4/rlfbeh+IKWRWq57cNvdCtTce+qMcWR/1uBrsfcYh1j3OzeD0W3e2iYcEIKulO0f0zuLho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BQQJY19X; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33082c95fd0so5763719a91.1
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761061266; x=1761666066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gElp4KIF8VYeQaILzzzMZvdUU8mJFRmHLG+SIVbwPDw=;
        b=BQQJY19Xd49pJTjVXxDiHNAiShy5haO4w3L1zg30F2BD05Q62K28H2/4oac0L1cxpu
         UkAHkrSvak5qe/sc46PUQVY5M3PhPzYgL3H0u1B0L0idxKkMWmAE8wjt8Ytah5VdsZQ9
         gxU+EGHWblOIIJ6okE13u8YkKan6nIAEi2pGaAfrmm4TOZbZuvNsT7ZLw8o+iZn+g06I
         fFPLT4tpbLzwCHZXKGoMMgvDgptDV8Yph2ZxJjNj2ahze2BBCT+IkncibI544OxAKrkP
         eyuZnuVLzK5YjkIu3lPdAsVBCTq9Mp99pFEFakTdSUpHpTfUvh5YDwUDmf3h1w1y1Zd4
         T6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061266; x=1761666066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gElp4KIF8VYeQaILzzzMZvdUU8mJFRmHLG+SIVbwPDw=;
        b=lf0exbLlTTGPwyE9LpafxswAWQj9CavUIZCvEWOMhV26CdoK7ECnWyaJWhtxQ0c50S
         u3nVCOYJLmG2RNEVOyrYB1sU9D4wl6HMpIhuqYerQJofsgyUp9rRJN6B/iYBWPwio/vI
         MPKliXUZXamZR75b6gt9/wcQTiKB9UiNat5UHCwMEScfZEEn5BmzL2nx7v/boKsdlwq1
         0HseXFsUWh3Iwc87payKlLS4ykmgIy/RWriQ/07cDkbHIUhPKq7sIiNS3jCTFnTOUrch
         ZGziDobdDAuz04SN/B2i7a6l9doLO0e3Eh658Gd5kbXcorjlzjivB9JM1fSbCNdjmkYp
         gmMw==
X-Forwarded-Encrypted: i=1; AJvYcCW29UNPDS4XECOQMyeJS9rGSV06E0MBdNkFb1jJtYhDRUIP7poR8098o0/mRa9bGAoYl+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoohTbaNRO8qpOhAE5B4/JqJUN2hqsWxV/dr8f3UpZzE0tPWIh
	bcGBqorfbgEfuaYMETmDzLilYDPbHBwmZcPfUrq4L15FfD9C/Qnj+MHR
X-Gm-Gg: ASbGncu6Tc2yGKq0xbH5q2ETmuwDP+TCl+ZviS5g69vdBMWyDTE3yqc7qbFGbPClUaN
	b8y3hkzFgXE18LJcaYi1ZGkEYdMT+xOTQnOxYw1bmydpR7xxEjQEKd9v9H7ZwtC+rjvFuFLz6XO
	oZHlp+z1pqPoahyacsNckxpzfqTcHAJUaRH+GtVMLPRhz79bFRGfU9oxP7VwWZAmhkh0HetPYai
	SbU/SXiBZLO7CwZRaA1wHPyQfGpEI5Sgx1cCl/rN4vg51wKElED+/qd/cqdssluONp9vp0IRv9E
	3mjv2WOH/9F8YpQuf9iI40TkHQV2SqFBeujWXXIhCMAtxzbZGQvU3ufC3Xo7m58TZ8qh4UP6z4/
	v3LSK254BgqoDTkkH7U3QMHF1OYXF3N5F5hMhopCd8mtUfbmVQAPEPBLuHEaa/It/uTncadScpF
	eSCwWZfKHYJGTglUkorA==
X-Google-Smtp-Source: AGHT+IF2BEwN9SHTQpZOBouBqDDDTDgWqYFnhtzjPK7YuK56SeaSmY5uLQ3V84GXfTxkxL1xmym6Yw==
X-Received: by 2002:a17:90a:c2c3:b0:32e:4924:6902 with SMTP id 98e67ed59e1d1-33bcf85a829mr20457454a91.3.1761061265570;
        Tue, 21 Oct 2025 08:41:05 -0700 (PDT)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5de09fa4sm11293742a91.7.2025.10.21.08.41.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 08:41:05 -0700 (PDT)
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
Subject: [PATCH v2 1/2] avoid hv timer fallback to sw timer if delay exceeds period
Date: Tue, 21 Oct 2025 23:40:51 +0800
Message-ID: <20251021154052.17132-2-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251021154052.17132-1-fuqiang.wng@gmail.com>
References: <20251021154052.17132-1-fuqiang.wng@gmail.com>
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


