Return-Path: <kvm+bounces-65990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 70592CBF16B
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4554B300288B
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83C2341661;
	Mon, 15 Dec 2025 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vpsWTE5q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A62B341074
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817521; cv=none; b=d5iKaBcPDTwCtGCEBnIbvcEet4tUKA3Eq7qGQAoO9L1ZEl1uXiYY4dvBu4shhBuUf0wJNMqtOJFb/WrKlMmXZqaC6KMzJh/L3zTraHqpaYpt1Va2gc7SMYqkqo1Tkq8rySivS3bwt0FkZGJRTiqP5Nnb+QFKZGn0l7LopA0NClM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817521; c=relaxed/simple;
	bh=H+BYPeuC46/cZwkzUGpKRp4PEKTMr0g8kH+Bp2Om/eI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sdva1Ow/7zY0YdYDxVL47LPNhL8oDHvCYgeDGamWLQEjV8p+1mieK3w3NzdfdFNcgt0zp3LTbXapSQjHKsdn8ZMvKEA1VHTnDty7f5ug8jCtr9gcdct/3KwyVVG5TrW4UHmcJGVmuubzdqgWPkDjaybuq+t6NdlFvCGGmfg/tRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vpsWTE5q; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64969d8d4f2so5351543a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817517; x=1766422317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=vpsWTE5qIGXjoKwxTKEuoBKCjSuzjeoBw1e43f7xkutPvnFhrltDJCTM+7L6VToad/
         SJIppHe4VTZALh8jZjIu5UBQ5N6ki0LCrvIKIe58M1Vy39fKv7qr0XHGBKiOAAWyYCr7
         V1XKIagV/S4WQFPhQ4LIn6K+ZchhzVQi/9+DpX0JzwP5eqIHD3989q4l4owASCWTmoXj
         CTIYAmPdYb2iC3ISlKKchYXrjRijZgG8q6i+nbmoyv2DOaX2u72mFBQ9CMcYChX6it5w
         m7uYiabUchpmuKp7DNXqZ8Oip9Pakqe09Wh848VW0GmHV3Grgo2vwWKphkiGUpEksf3H
         YETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817517; x=1766422317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=kvrPWzuBqIRUb5Y510L8EruqA57kbq8d8IrOukjFz40zkws8oPB6YvoOizIrfCSDJu
         gGgn9KCp3iZd9PHTWR40V+Xb7cRHAiK1c433DRziFIzKaj/cWNWCdSU3y1jVeH5pK7Yl
         GnZsI/M5JbB+5jasE+Z45qNnSxhlk1YspCniLxJ/vCbCqErwyqKG8ZHJPV7LteXcWvO9
         eYs37C7ktZljFdGUp4hkUqu98WLGvmLAFa2PqLmrLI4hBf45azw+FiirbYluAxN+U2yJ
         4V403Z33IIcGh7EUNEKmavsYcc5NNfZaCnq0Iu1kifDRNSZ6z2sntzroZa/4IFesU4W6
         H8cQ==
X-Gm-Message-State: AOJu0YwGIiaHMag56OK9jatAtSuvhMVGQ+lzrO8w21WIfT65Dn3Sor3i
	1Ofz9m7gD0XQ+hLV53JZeAYWh+bV3IUr4nRDZoD9ZlbavU+FWP9WiPPHF4rZJMm93iWm5VBAs2F
	72KWuqKvE2ga6JplXzSMpwoF42qr+5TUJeERduyGiGs1Nr8NUOxnDDYXaksJrkKbHNtp3TNN0M5
	Pt6sMayrRuOPFEkM83kqJOxY5vmME=
X-Google-Smtp-Source: AGHT+IFrHxiEYHDjT58c4YVmrMD5eO1DrDlCmV6f5ukjJAbXvW2Vssi5+5Lw36DE9YHOiX+0KsCF3RMJMA==
X-Received: from edbdk5.prod.google.com ([2002:a05:6402:1d85:b0:649:1567:4ee3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:d08:b0:641:8a92:9334
 with SMTP id 4fb4d7f45d1cf-6499b1301b7mr10482727a12.6.1765817517246; Mon, 15
 Dec 2025 08:51:57 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:51 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-2-tabba@google.com>
Subject: [PATCH v2 1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
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


