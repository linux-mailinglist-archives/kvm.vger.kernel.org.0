Return-Path: <kvm+bounces-42767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9AA8A7C630
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 060B7189CCD2
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7FA221563;
	Fri,  4 Apr 2025 22:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aq1YiAFl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE0F21A455
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 22:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743804427; cv=none; b=PmkC2ktek9TNeqgbFeUcatZfSs2Kg84AXBCgrwjIRy+rwPTWuQxeVfoOfgcpcZY5xFs/CYePb/fcVMPUdEQd3qAwwtXes50X8cMWHQQcy0y54OiZg2iTvltSflhw+WDeMJaaxXa7o+OkdlnLCcy0s1OAKw6zzp1s2QP32sXetGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743804427; c=relaxed/simple;
	bh=E4YqHNQ4gPeYFwy7PnyB6caqFhd7nH8+voL1clFcF6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Trqt3gG8noP3qBoP7WH5NEtUDnO3NRB2EgU6MMinxMJ7dkOMgkS9p8sb0GnNskXjM66qakcdq8X0zfEOA9SH2/4DlPWd/nCf4sWLf+5RpkukBcK67BEEX2/zg1QMBUZkVA5NiLjaTNQxoxfuS9X+/lLVpppxwnTJH8B2DPa4o4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aq1YiAFl; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-85dad593342so250249839f.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 15:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743804425; x=1744409225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pc9BIslmRtbzEaqCHxhWv7mDukpJW925YKmou2T40Cs=;
        b=aq1YiAFlmibEtVeZZBDr8pdL2qcgat0oDjxJXpDnXihM9beKgVDPCA4Jxvt5mjzD1X
         wlDP7tcZML7RBUOmlvyV2Rz00tc5OH4/985re28sekle1vXGtpKkkJdLb6uPI6l6iHV3
         70nWp6K2gKJIVTn6fWsZw8SrsGUlE1XT0nFtgIlaER20F+phlfL+XRSUQYQ6fVTsi3yj
         zmLEy7emz1O7CYHugbWhWvqgNdp+58ZXR5IxgW0ZRcNWGeQ/9igflAwkwvGjIphhdBKI
         zy3qWWW0VOQ6xuVCEm8buQ1HPEEvs6W/DwL66a6UfByBJfhliBaR08XRa1Efj+hkaDmG
         KZIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743804425; x=1744409225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pc9BIslmRtbzEaqCHxhWv7mDukpJW925YKmou2T40Cs=;
        b=ITpHeQ78PiZR90RB80qlWJmQQrDthTXa6mFkAkDLp9lqGTm1LEEkHlKxcgHT21CMec
         FXrT8wyls/TlA8m7CJzzOdLHn247k7d94PuhPFMlQTWlHbJshC6sM1L0TEHGnYs5Ne1x
         sny3vQ0TQxbg+GlXLnZUVdzgyNynMgOKontqVC2N9X5LT6bRlEHfhyuqIPAbAzCuefga
         c7XpYWs6AdDCWoaorhuOOyetpXpH0LDlAEvy0doT19IRT4OCVVWSesMN0rzsuZy5Lj3t
         XavwVOLk2RNcbsk2KGpH27Jt647cnc2yGZqJorHIVKDa6vYd8K2MSOecA3eIaKazPHIn
         /1YA==
X-Forwarded-Encrypted: i=1; AJvYcCWYcSYCptlLsRuSldChk6yeBb4IzYvFEZEGlG3hpxjk8Vq2/WRx2AhFteEBWiqm10JvG7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwokZ0gG080NMW3YzV/VxLhlXHiX2Vgnz+/d0TEiR0p2d8vYiuD
	JUCI0/MWgBuyjXzxg3zwZmMnrZ/faunbqxMeLxLOks5H1YFNzP8S4JV6dMC/mp7TeOX1N5ppBHf
	OIx0O0w==
X-Google-Smtp-Source: AGHT+IHdes02xNhbHRa4hrCg2N+VywWvzx8Vq2+IoHciYVBDcUnJpNkQ4rg+6l0nOZiDn4tZhimhX6EbrE0g
X-Received: from iobbf5.prod.google.com ([2002:a05:6602:3685:b0:85e:9686:d0f0])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:6a46:b0:85b:46d7:1886
 with SMTP id ca18e2360f4ac-8611b49b398mr539039139f.7.1743804425293; Fri, 04
 Apr 2025 15:07:05 -0700 (PDT)
Date: Fri,  4 Apr 2025 22:06:59 +0000
In-Reply-To: <20250404220659.1312465-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404220659.1312465-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404220659.1312465-3-rananta@google.com>
Subject: [PATCH 2/2] KVM: selftests: arm64: Explicitly set the page attrs to Inner-Shareable
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"

Atomic instructions such as 'ldset' over (global) variables in the guest
is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
DEFINED fault (Unsupported Exclusive or Atomic access)). The observation
was particularly apparent on Neoverse-N3.

According to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte load/store),
it is implementation defined that a data abort with the mentioned FSC
is reported for the first stage of translation that provides an
inappropriate memory type. It's likely that the same rule also applies
to memory attribute mismatch. When the guest loads the memory location of
the variable that was already cached during the host userspace's copying
of the ELF into the memory, the core is likely running into a mismatch
of memory attrs that's checked in stage-1 itself, and thus causing the
abort in EL1.

Fix this by explicitly setting the memory attribute to Inner-Shareable
to avoid the mismatch, and by extension, the data abort.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 691670bbe226..b337a606aac4 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -75,6 +75,7 @@
 #define PMD_TYPE_TABLE		BIT(1)
 #define PTE_TYPE_PAGE		BIT(1)
 
+#define PTE_SHARED		(UL(3) << 8) /* SH[1:0], inner shareable */
 #define PTE_AF			BIT(10)
 
 #define PTE_ADDR_MASK(page_shift)	GENMASK(47, (page_shift))
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index da5802c8a59c..9d69904cb608 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -172,6 +172,9 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 
 	pg_attr = PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE_VALID;
+	if (!use_lpa2_pte_format(vm))
+		pg_attr |= PTE_SHARED;
+
 	*ptep = addr_pte(vm, paddr, pg_attr);
 }
 
-- 
2.49.0.504.g3bcea36a83-goog


