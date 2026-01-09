Return-Path: <kvm+bounces-67535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5611FD07C64
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E77A306A0CA
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC461318ECF;
	Fri,  9 Jan 2026 08:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="10WDMoYi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EB4314B9A
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946952; cv=none; b=AmMTQGFfc327W78rh0DMnEGxC+gKez5LXIPTrE89er7OS4AYTvws5kVpJpz80C86wMXroN8XDDPsGZJ5wgMrt8aRe8XdVf1c3Vn2SUE4Qmsp4KD8OHOvOFjsDiELrcw4xT97xs4bqSmHbYPnRXrlYz1FgRnZuoGLVHZ99lTbjZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946952; c=relaxed/simple;
	bh=a+P8IDuXmE3XGEoH5ksrNZ5ogpqK5TTuuqzWjToyeZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dFULPnSTpc5GYFCrPMTbIsP4DPXXqmkJjqa6T0ZVchqFjXvB/bmysPJ8Y/Cyzkk774NgExXOaIRUs+En4cTd38HraC7cC7WTB+l/aZLDwAMQHQCnCAgfdudfGOSy5+FLXd1XG9j9bbvku+G/bfan0J6H0vxyMlbjDH7CkdtNuW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=10WDMoYi; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43009df5ab3so2532049f8f.1
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 00:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946940; x=1768551740; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sYmtUt8Xl9FkSFC/XVvZCPE49zR2Dt2nIyVImhULnc8=;
        b=10WDMoYisvr2q/vJWVQn5SwGea6HDHqguODUKe2MZr4WqLnR69bKO2w/z4NTDbf8aq
         4daW6PqcEOPXHML1QHpfpsMiziOcdnlhczh4aqm8SUxQ5Vl5HFT9KHBXTuedZDNKVykI
         hZlo7mkVsvO/4KbFjDXdwa6nF/DSd1sKqs0EoyoYaq+X43GnJ689qMryst63N4SZ/ybr
         YtmtMSJTKdUSVBmX3yMaQznPiJZkzjEYq899rubBHetZD973ICDiTFmqL9lHpVTV3Q+l
         LgnHpYBHauEEBYoXU9ZIk3CWNr12UCrDC1NyCfvaFGXx0mBUX7gBHb8oVPOGmiEZAepo
         YHAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946940; x=1768551740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sYmtUt8Xl9FkSFC/XVvZCPE49zR2Dt2nIyVImhULnc8=;
        b=ChX5ihDmEwn67E8kyipFvUDScmIKpB0cLtA22mqAVHhy0/4JrpBIpHjhtLI1076nth
         xTvAG3TNj2cSkOHa9XlX/cYCGKCA++V+R6TqJ61brzPCOmESazEPlyYlZOkjhFFNOX0x
         hjda3AXGZyr1phroc7nEDU+ghUwMKjLH91oVBA8LkQMXltubpGfQLnY6A5Bshg53ZCZ7
         VAcW1NCPjPbDjGP6UhBoa9GPE+fJYx/L2+8KK+hb+kJt56qxUQIU+UGlmI2+rtw6kuHH
         nFAHec/g/r94WJ0RruHfrAtAEYlPhTvNlv4R7ymdIixPhWDnZug+ZODbk/6OXy6IWt+f
         sMBw==
X-Gm-Message-State: AOJu0YxXr8hbMUraRZe2bPnBRgS2XORyFjeye8unbCLL4knWn3wdBPfR
	NMFfzp7r15NJUp9FsUdSjmI35BZtKhvG0u91Y2Tmc0L2NvWUQJbHc2BQXp3WeFnd4OVWw0M6YPh
	fdyLmTo53DmCfhFbZ5BYqnkFVflOmLorIboglknwbss4dYTC/qSPzSyw98hrDVnUAsNYfO3gQ9i
	ryxZHIE78lxERNGh5oI4ztJkGDOT8=
X-Google-Smtp-Source: AGHT+IETB7LrDsnfiW2BPzlfWyDm7NKj1+DX1BU5/AFEdV7tYtJ3d8mxv/c+jnVIsPQwWb0Tl7EWECUx/w==
X-Received: from wrbgx16.prod.google.com ([2002:a05:6000:4710:b0:42f:b666:90bb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26c4:b0:430:96bd:411b
 with SMTP id ffacd0b85a97d-432c3775a8cmr10939156f8f.58.1767946940503; Fri, 09
 Jan 2026 00:22:20 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:14 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-2-tabba@google.com>
Subject: [PATCH v4 1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
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
Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
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
2.52.0.457.g6b5491de43-goog


