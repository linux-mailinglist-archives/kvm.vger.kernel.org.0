Return-Path: <kvm+bounces-59603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A274ABC2D74
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D07834F85B5
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDF026F28D;
	Tue,  7 Oct 2025 22:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hfXdHTBv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEBA26A1B5
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875291; cv=none; b=gdkYu/bPaM/v0fsdyQdjTTrvePaISVza72ALes+xZRztazOeVHmqXqo0Iqw+q45JHAY7xJtW4B8Jo7FUU1EYWoBCoRZmhelpAkO5RCkVXj+DfFzsZGrHibnOpT+s4NlwaOuIeXGr2tX+LKc0hqXDLwKvgfOnWeyuvEEhqFQQ0FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875291; c=relaxed/simple;
	bh=DQgULNgEfY1Jt0H2/OfuNvBsjc9CKm5CpMZ3jXWuIWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hXnasWvE/kAzYbMJKlOUS/e2w6y7rtALwPJIkl0qSmA1UAgOD/FRAFBzlVJ22UEGtm9x3I/q1PKcQr3jRInEVsau/BohD8Wfq3x5y8AR+ImjT/9zsC1LeG6r3qqa+JX48rtayMNKxdTHMRhbncAluoi5c5dHOG3pyTrxVybAtRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hfXdHTBv; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-781171fe1c5so6340105b3a.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875290; x=1760480090; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRjLOkLi9BSY1X/Dn5kuYV5Nji5pDR3uoMZxLkUFt2o=;
        b=hfXdHTBv15rANbphNVIFd1wb+x+WpzC/F+r+BCt9D9MdWv1N3c1n7RO/njPl1bq64P
         w0l+cWXfUg1RCpwt1EEzrfU1OHPuXjZFztPnSytFuAjWEQTfC648fwPrWWa/sWIWgrN0
         FcY0GLBqV6nx+pKlyZA0lmMAjuCUwJhjv2FOPWaIhnuaIMV+SOx9pFQ2IjIUdC2K2nvn
         rVW7yUPZPOVJx74TZ9C0RoR+1CTLK6d1b4pgTKopTBm0C+kteDsURXDvExAHEG91bbzk
         dA1YHeB1FT83zZJdrd7b26Jv1N/nNcURkAXOFhJ2tYbPKiVCxBkPITKG/ksNmRgnxIwn
         7CRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875290; x=1760480090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZRjLOkLi9BSY1X/Dn5kuYV5Nji5pDR3uoMZxLkUFt2o=;
        b=aK/vtsK5aCYXEnT5I7uV6BAYvmkAFhvYgT1l0V97Kps9DY1k3t8Gf/DjxpwG4w8vie
         tyQ286EYD/P77Tse1OjjXXF1RnOcZBw0JqMTyvwidzy+OaJkOiBKHCtMkH1g9NEkeJhD
         Qv1JJC7sfhE4n2QyYM3TlcnlfSkBCHCfbgf1EfyUm8PwmpNBwxjKwTi7hOXAnBQAXY1o
         X3++WCzdJx+UR01Tl6pljqdDJBOB7N7WhFP6UKUoThQpUcBsy2cXId3wbwmmDVcYbseT
         xV1yBU674YTV/EC4P3acE/sqqWtUdbyCHjXSeT81y80zhFjmv9BG4WPdn0YB63fC498s
         +HWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXazALVop5NiiqVGZB9dcxsnHHoeSAA3jvrBdjpFq3Po5HHKIkiXd1avkCmanmXcbZoPhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoYeSQi3RYnGFJKfPN4GLEmu9lht/om0H4nbjZko+v7rPuPHHq
	7mkHLtn69y2fddwLkuGB1UXfMHtgO5tt/SP1xqSxKjlNwsu5sfrdfHzwzlaK46bBrXRtaICuDfl
	WpBIX/g==
X-Google-Smtp-Source: AGHT+IEms4qpmxT3+KnDpQ4qOyqPi3vhEOg4w0WfOhks0tfRQIlFpS+IHju/WYm3RYsFn35p+Bdpiaz8XEQ=
X-Received: from pfbig5.prod.google.com ([2002:a05:6a00:8b85:b0:77f:33ea:96e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cce:b0:77e:5c9f:f85a
 with SMTP id d2e1a72fcca58-79385ce1122mr1342534b3a.14.1759875289698; Tue, 07
 Oct 2025 15:14:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:15 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-8-seanjc@google.com>
Subject: [PATCH v12 07/12] KVM: selftests: Report stacktraces SIGBUS, SIGSEGV,
 SIGILL, and SIGFPE by default
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Register handlers for signals for all selftests that are likely happen due
to test (or kernel) bugs, and explicitly fail tests on unexpected signals
so that users get a stack trace, i.e. don't have to go spelunking to do
basic triage.

Register the handlers as early as possible, to catch as many unexpected
signals as possible, and also so that the common code doesn't clobber a
handler that's installed by test (or arch) code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8b60b767224b..0c3a6a40d1a9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2290,11 +2290,35 @@ __weak void kvm_selftest_arch_init(void)
 {
 }
 
+static void report_unexpected_signal(int signum)
+{
+#define KVM_CASE_SIGNUM(sig)					\
+	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
+
+	switch (signum) {
+	KVM_CASE_SIGNUM(SIGBUS);
+	KVM_CASE_SIGNUM(SIGSEGV);
+	KVM_CASE_SIGNUM(SIGILL);
+	KVM_CASE_SIGNUM(SIGFPE);
+	default:
+		TEST_FAIL("Unexpected signal %d\n", signum);
+	}
+}
+
 void __attribute((constructor)) kvm_selftest_init(void)
 {
+	struct sigaction sig_sa = {
+		.sa_handler = report_unexpected_signal,
+	};
+
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	sigaction(SIGBUS, &sig_sa, NULL);
+	sigaction(SIGSEGV, &sig_sa, NULL);
+	sigaction(SIGILL, &sig_sa, NULL);
+	sigaction(SIGFPE, &sig_sa, NULL);
+
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
-- 
2.51.0.710.ga91ca5db03-goog


