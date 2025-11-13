Return-Path: <kvm+bounces-63045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DA957C5A02D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E52F8351502
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0C63246E1;
	Thu, 13 Nov 2025 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vz1ZpVCY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB3F320CC3
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 20:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763067081; cv=none; b=UPeTEjMluPGO71+kLLa56+xY9F/JnEWnsT6knRYjTrizkyjFutBFyRVuwqn7zsWa8mdzPWC+RhVOLB4flgo7prRN20ejkTKwg6dyeG5whA2TbbuIfLzETjz5a+6Q4dWTn1bSD8Gf6uDbovILijrJurMX0J0/6emA1K+LJlKy50E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763067081; c=relaxed/simple;
	bh=Vf3uSzJxbcyxYL4gFf/C72FnMzhTr6uR25r04d1TBGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ktIluuWWe/sh8w+/4FSUImr7cNIp2KUgBmrSLjs88xwnc3qQsTosYuX+UjmYcef5WA607RCWaM9padZCQdvf7/WY32X1fntDjcqG2a8bvX4gGUUdI7lwDC7sk2nSwZBsu/H702M9SjW/x8vswbyku+cUG6nsl2TZIHyemPiVuD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vz1ZpVCY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b991765fb5so1325699b3a.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 12:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763067079; x=1763671879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2S2xbMUFn2UUxymTDK244231LhDPBAgc++LRYyMCXcc=;
        b=Vz1ZpVCYl0ehQREEva6QHDlVEj5Xg2fQWza5UDiQvcgVvhzOccsEthXq3sEVyN81kR
         lMwhoiyUKrfFWTE93cXVwEv6XCc/8jHrMKtknNlV7mybCof0RzoqLWuZcPNelBZxTLVc
         huxrhHEovC7uPzFtTp4IHXqKqcR307iD3aAi+Ci+egxFmQa4hI2SV/a2EdH+UCprYUz4
         o6rNDEeLnsmxFOHh0W0mdReC/bu4qbTP2Q6b/ZKN3htN3/Tgb4rZPFtpztBGcgx+TPb0
         Wb5VR3uLsFGScxRox92adUk5MlCOFGKjV8Nu7wBMfpueWghxwEuPQrFggX2CP3TJxoyL
         Az7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763067079; x=1763671879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2S2xbMUFn2UUxymTDK244231LhDPBAgc++LRYyMCXcc=;
        b=KHGnlS5vAwctyHpM3Z3wljfa/gKtSHFpAgGT/y2hHI5NV+k+0UfW1hbSnrmxZZQoJQ
         XcW1GjyKOgt2tHYS5SXP8uvMG6hV9/hw5Ha2mQQ17JN6oKydcYIJv3JqNS7nPPRBmV0Q
         nyEqlUm7ejfyn25LiPWFQZ3EkZCGmr5j4X8MF8rhVxQTe4n4JNQoOiIOPp4hCCGxaq4c
         cMyxz5TD5VAwyDT7m4v63dW6rAKafv5J3sBfZmjqlOzjNrsCUaLQxPog1vNKunvyI0LQ
         9PzHZtNAtCPYKXch2pJx5jIZcB0e1djtwpVIUo5q8zfKaEkhe6gR2YfNquZ94dHhogjh
         UPHQ==
X-Gm-Message-State: AOJu0YysyGdVukHoD/kbfFLxCmTXnpLseaTkyucpN1F4OQKj5CXeLPLE
	/UjfNAOdTsvZ/8OBQG6MkQxDl4PhpHhhDmM6g4NPVRWcjzH5Qm2Cc76IqXxSiUStdADBzF0Awqo
	wTDmHSg==
X-Google-Smtp-Source: AGHT+IGVAzpCiBUlqayaEcwV9yPwrMMcLoBK/HBvd8DKQ/dh06UxA07ygYJfrejiXAPWfmyV/Ib0nnpELwY=
X-Received: from pfbhh7.prod.google.com ([2002:a05:6a00:8687:b0:77f:5efe:2d71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a1:b0:34f:99ce:4c48
 with SMTP id adf61e73a8af0-35ba1d9acd7mr1276932637.42.1763067079096; Thu, 13
 Nov 2025 12:51:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 12:51:11 -0800
In-Reply-To: <20251113205114.1647493-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113205114.1647493-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113205114.1647493-2-seanjc@google.com>
Subject: [PATCH v6 1/4] KVM: x86: WARN if hrtimer callback for periodic APIC
 timer fires with period=0
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fuqiang wang <fuqiang.wng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

WARN and don't restart the hrtimer if KVM's callback runs with the guest's
APIC timer in periodic mode but with a period of '0', as not advancing the
hrtimer's deadline would put the CPU into an infinite loop of hrtimer
events.  Observing a period of '0' should be impossible, even when the
hrtimer is running on a different CPU than the vCPU, as KVM is supposed to
cancel the hrtimer before changing (or zeroing) the period, e.g. when
switching from periodic to one-shot.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..78b74ba17592 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2970,7 +2970,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
 		return HRTIMER_RESTART;
-- 
2.52.0.rc1.455.g30608eb744-goog


