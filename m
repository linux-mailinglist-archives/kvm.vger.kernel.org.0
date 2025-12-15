Return-Path: <kvm+bounces-65981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67710CBEC82
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1A6C93019857
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A92030C62B;
	Mon, 15 Dec 2025 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fP9uvMIw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7A030C63C
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814150; cv=none; b=boDqrPbOOcXjl6kBbnfivmo7qS4nJ54lr7b0RWwPrDK6RRX71D9xkyR4lmV9cN5LpulNA6dx0QO6mBCZBwaZP2eOw9WaUfs1WvZD8INiAwEYYXLmXqIeKb1v3RIUbcjSLNq58xC+JHzhYkh3uZV7JLGLCGz4Z1b5x6O8vNcYHDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814150; c=relaxed/simple;
	bh=H+BYPeuC46/cZwkzUGpKRp4PEKTMr0g8kH+Bp2Om/eI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cS+3Vq5efHVBcd85x1/eAVrmrpv8h1Hsv2wPWUMaRwfMKE5wCcNIaIzZFuWmrQXnjrKPsrE7mATf6+mi/X/UyHEJ8cXzzHZvW/lr7M2uXF59XslzZ4ivAEkQG38bLaE6OQETJ7DNccWzxYNKOSfgo5G26vygoKhCTRMmSWEsaf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fP9uvMIw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47921784b97so27334165e9.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 07:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814145; x=1766418945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=fP9uvMIwgAGLXIxy791PEx+OZoTGb3+T6OcW167jT+RERBgwerp6ahysIQ+711oia/
         vIM7PAsUl0aeLTPQKI63PJ8I839pt9xRgc4JnXbmDYm4o40KOBrMLV6bDpfVb2lr1ZSt
         gGzY9bCheka/FXRL17p94Ircpx3Tv+ZAGMprO0UyhSLrX/j0mjkLRqz1/nUUj3DeMFGt
         Ocst88n9P6MmGnt2RDpA+phmE6uf4TXmRo7dMKeK5wMx1QUXdz5y+zVn/Sbdu7GozsmZ
         eXJbbVIC7wqB31gCvd8Sy4bdygJQOKEzWHFHrPyEglOM3nqzKpTnsS21dqjGfktnls+/
         FhGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814145; x=1766418945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=aSW/wY0aH0ALx3MoroDutX58cFSdHlxmnsZNv+Fe9KoCu5q/MgUmJ+OKK9mRbHc0iL
         EAfoQQ21IsLEJDmpltzPalGCX2SAJIQcZYX5eAYZ2Y6uPf4YXMq1uR0hVU8yHp2dCSeU
         xvhFnJtYQwAUu6YaMjzovnU5tTAJwwhMvfYvMlr0q4jNtdKKNOES8s8pbKfvPSmGOt94
         jw3L+F7ucFhHVWiKUFoIkLZgQOPHc9HwaQCYHQ47/isUo5H6YMZcQ61m318kfAxiJ9Vl
         DCOj8UdeLKZA64XLPGXQkFtcphek/BFe63hDJN7z0g6JYucxlOz8yo5TXCWgDX/NfcHJ
         o4IQ==
X-Gm-Message-State: AOJu0YzaX0TSF2hfyaR2BvpO9p2DoWkiPtFFEbKhFanxPn0SmTZ9Tg7B
	k6XBoRZzDIFP09dkk0pp6zgRx4qCPDW+7xhGh2zOZ0WzCUjUqWV4gJzLGkvD//hICZPcJ5JapX4
	t1kSFjC7QhD38yS8By3hg0KkyXTlXvWRjhBkrYWwcQdBru92CeIwhldalhwWne76IVpjNMS+qra
	FDU5EnbmokTg4QIe3q8NCohnlUZTY=
X-Google-Smtp-Source: AGHT+IHbF5g/qKuRmpHM+GAghD49LsbXx/xK7SXqnMvdHcBGuemjYLFGlWxVDieA3a2+nNsKY+U8PqUPRA==
X-Received: from wmjv24.prod.google.com ([2002:a7b:cb58:0:b0:46e:1e57:dbd6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46cf:b0:477:a3d1:aafb
 with SMTP id 5b1f17b1804b1-47a8f90d757mr122905225e9.29.1765814145019; Mon, 15
 Dec 2025 07:55:45 -0800 (PST)
Date: Mon, 15 Dec 2025 15:55:38 +0000
In-Reply-To: <20251215155542.3195173-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215155542.3195173-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215155542.3195173-2-tabba@google.com>
Subject: [PATCH v1 1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: tabba@google.com
Content-Type: text/plain; charset="UTF-8"

KVM selftests map all guest code and data into the lower virtual address
range (0x0000...) managed by TTBR0_EL1. The upper range (0xFFFF...)
managed by TTBR1_EL1 is unused and uninitialized.

If a guest accesses the upper range, the MMU attempts a translation
table walk using uninitialized registers, leading to unpredictable
behavior.

Set `TCR_EL1.EPD1` to disable translation table walks for TTBR1_EL1,
ensuring that any access to the upper range generates an immediate
Translation Fault. Additionally, set `TCR_EL1.TBI1` (Top Byte Ignore) to
ensure that tagged pointers in the upper range also deterministically
trigger a Translation Fault via EPD1.

Define `TCR_EPD1_MASK`, `TCR_EPD1_SHIFT`, and `TCR_TBI1` in
`processor.h` to support this configuration. These are based on their
definitions in `arch/arm64/include/asm/pgtable-hwdef.h`.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h | 4 ++++
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index ff928716574d..ac97a1c436fc 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -90,6 +90,9 @@
 #define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
 #define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
 
+#define TCR_EPD1_SHIFT		23
+#define TCR_EPD1_MASK		(UL(1) << TCR_EPD1_SHIFT)
+
 #define TCR_IPS_SHIFT		32
 #define TCR_IPS_MASK		(UL(7) << TCR_IPS_SHIFT)
 #define TCR_IPS_52_BITS	(UL(6) << TCR_IPS_SHIFT)
@@ -97,6 +100,7 @@
 #define TCR_IPS_40_BITS	(UL(2) << TCR_IPS_SHIFT)
 #define TCR_IPS_36_BITS	(UL(1) << TCR_IPS_SHIFT)
 
+#define TCR_TBI1		(UL(1) << 38)
 #define TCR_HA			(UL(1) << 39)
 #define TCR_DS			(UL(1) << 59)
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index d46e4b13b92c..5b379da8cb90 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -384,6 +384,8 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 	tcr_el1 |= TCR_IRGN0_WBWA | TCR_ORGN0_WBWA | TCR_SH0_INNER;
 	tcr_el1 |= TCR_T0SZ(vm->va_bits);
+	tcr_el1 |= TCR_TBI1;
+	tcr_el1 |= TCR_EPD1_MASK;
 	if (use_lpa2_pte_format(vm))
 		tcr_el1 |= TCR_DS;
 
-- 
2.52.0.239.gd5f0c6e74e-goog


