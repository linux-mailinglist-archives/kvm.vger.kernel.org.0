Return-Path: <kvm+bounces-22200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC61693B735
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 21:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 194471C212AE
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02F7167D8C;
	Wed, 24 Jul 2024 19:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/u7lpM9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DBC65E20
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721848054; cv=none; b=FPpVIUHTgOqQjIx2DhSYjIOlWeNISsPZmdsL+NjN5+GFxWcK+nj+3wweKnuCVrfsMEVABpfA5AJI9I8bMZsN6Fa+Af5Ra1zm4j09BhPzsomhwMlwF42CFZmtH5Q84XWrApsSUzE1hA13vFbEXCxlO84APdxyykNjmxYkmmbvkc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721848054; c=relaxed/simple;
	bh=a9+eRSRdwNUgKDMWFtiJrCBfxO2HCcEPQhgyRCcDNgA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qaBefop1HQOZ930JfIZnIqAhxqHCYs1HVfBG+Su0N3M93jFzyZThPoe6mNFxnGqAJ6YB9Cr9O9SFI8fHIdnMb1JmO8MgqYzY3ozXXC6W0LsE7eYkUhyZquKYfliA4eLg72SBEPsDv1NVFuM785K5OrHfR4Zfp9FwMzcCPwfw8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L/u7lpM9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd6d695662so1128195ad.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 12:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721848052; x=1722452852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qGPm4ZpqbQrMUclrVJSmGUETlP/+tI4QlaqmL51EMbc=;
        b=L/u7lpM9VuL1qjYsGP6pWO5ykp7yvH0sIsLm3+a96MHhG71KES5i3y3RYbd9/Qu9gr
         YaSUPhYCP5o+VFQZAUAcjG8Ax7XKeI238RSbixMyhPQnpf8D7QXV80dEf0KyKubQQC54
         XGKCQ4HAxC1P1jNST6Iq+PVwHEy0FkpIkXnFoWr/h6/AIhwfGiLn6jEF3p9knYskR6uL
         DBrr8dCXqetEj+NoLSOrYv8Vd1fmtwZUmb57AQxAiRNEoi/Oq7fW9sI6QLLRAV2eoQta
         BtcD8U3rl8v1T80Be+NYZH2CK6C0++Es9+Wm6er7+YDRKxXWwarl1epkhm1gLZb18thI
         TmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721848052; x=1722452852;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qGPm4ZpqbQrMUclrVJSmGUETlP/+tI4QlaqmL51EMbc=;
        b=jkDmVmtoPIip9WP2Kq8gKVGPiTZzioS3SVga/R5oAvrdnKhRailjBqkK0KhJ1unDwI
         Y3nBCfFbCgp/kivLHW8a5tl5kBbSKqg95Dn5WKOOXgSg2SCrb0pdIJ3TjKLUmhpeNclL
         hs0/srGtQvrth5ak1JS5OabioahV3FPNIgfflP1YjhBxEk6f2XEmcb/OC5UE0bHF2Blr
         bVd0TJVZWxHK30hRgpela4dBLpo7yn6loMuD0v6teD4GP88bfKffQVYyzLkjXrgahkrD
         x00g0p7/qxfwKAkdF0RP0oKsYgQIg8dNG3O5wAA5CaPoRSdraGBp4kIzOpAoWC2iXP8t
         Fy6g==
X-Forwarded-Encrypted: i=1; AJvYcCW/mHgo5L24zP7cfyG8XSoMKkxe8oM17xUztif51z25zwrvMiV7dl6+jkSqRk0UrIHWBSHWc8TNCzOQQ+UGN9OGMD+B
X-Gm-Message-State: AOJu0Yz7o9gtHIaeYczVdWvpYrdymSYB39qjGufeNCi1T+72Y8kisiys
	ypC7vBHHM8Ifn9UYBdcvtmVcrgIOHAq8bmgDP8IXN1Gs7xFihA9MMdYmbkYh0yoZIvQfaDIJgqq
	aMZ6mhmlYbQ==
X-Google-Smtp-Source: AGHT+IHqyuLE4a1MUDXDNLR+wFBGq/TxQqbpxHibZOnxn0O4z9CuhV/hHi+CeUjmgcWk/5TCqT0YeMISahS71w==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:ecd0:b0:1fb:80b9:fb5e with SMTP
 id d9443c01a7336-1fed38da786mr375685ad.9.1721848051902; Wed, 24 Jul 2024
 12:07:31 -0700 (PDT)
Date: Wed, 24 Jul 2024 12:05:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240724190640.2449291-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Eliminate log spam from limited APIC timer periods
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

SAP's vSMP MemoryONE continuously requests a local APIC timer period
less than 500 us, resulting in the following kernel log spam:

  kvm: vcpu 15: requested 70240 ns lapic timer period limited to 500000 ns
  kvm: vcpu 19: requested 52848 ns lapic timer period limited to 500000 ns
  kvm: vcpu 15: requested 70256 ns lapic timer period limited to 500000 ns
  kvm: vcpu 9: requested 70256 ns lapic timer period limited to 500000 ns
  kvm: vcpu 9: requested 70208 ns lapic timer period limited to 500000 ns
  kvm: vcpu 9: requested 387520 ns lapic timer period limited to 500000 ns
  kvm: vcpu 9: requested 70160 ns lapic timer period limited to 500000 ns
  kvm: vcpu 66: requested 205744 ns lapic timer period limited to 500000 ns
  kvm: vcpu 9: requested 70224 ns lapic timer period limited to 500000 ns
  kvm: vcpu 9: requested 70256 ns lapic timer period limited to 500000 ns
  limit_periodic_timer_frequency: 7569 callbacks suppressed
  ...

To eliminate this spam, change the pr_info_ratelimited() in
limit_periodic_timer_frequency() to pr_info_once().

Reported-by: James Houghton <jthoughton@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f64a5cc0ce72..c576a53733e5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1743,7 +1743,7 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
 		s64 min_period = min_timer_period_us * 1000LL;
 
 		if (apic->lapic_timer.period < min_period) {
-			pr_info_ratelimited(
+			pr_info_once(
 			    "vcpu %i: requested %lld ns "
 			    "lapic timer period limited to %lld ns\n",
 			    apic->vcpu->vcpu_id,
-- 
2.45.2.1089.g2a221341d9-goog


