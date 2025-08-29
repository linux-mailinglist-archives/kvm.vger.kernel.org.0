Return-Path: <kvm+bounces-56315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59582B3BE27
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2806F462BA7
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B3A322C9B;
	Fri, 29 Aug 2025 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="d+I8lA3C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54598322750
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478476; cv=none; b=QVVjpZJUFr4gVEZhsZ5t30OFndpFAUse9Mje7GAtuej7RsFEdUHbz26qWTeYcFUxGme8v24TWzn2o47Jx6xeHRWjV54THRrHYUHJq0nFJDNJds3G03tR0PPCUU4MNZIJ54wJGWNdDSx0ijaVgSrfRZIZuBZOQKxSQdwBUKQuyTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478476; c=relaxed/simple;
	bh=P9xlKEicZbq+4RuRvDD2ITpXhX/jhYOsR8b1c9w53oc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c3wjBvSsk5X9l8TqY99LjWU2h8/K3RnEnIwQL+sNNtjZfSN3nm9GWGKYuR9I7uoXQM9XphfuipHVGFk1Jmv/9OMBfVw6kta4NYw1iahKwBjnamnPZUUdMChOTtHVrXcsf2bhasc4My2W/Jl8u4wnW8SkAwhyWtMDEZgBfxxIjto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=d+I8lA3C; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-770530175b2so1738178b3a.3
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478475; x=1757083275; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJrFx3WCqf6VFVoWT85m6XL4XoNDn8hAld/4UFHpYgs=;
        b=d+I8lA3CN/HohPgLZ1ZwlR9u5iHLx25tnBWd+8YlZUWC4C37jn+1wguJCSNKtKz6gs
         x+5LmIqY/BeyZE4f7QX5cgVeeZUc+As2XAcJZH7t8hCWWTjE/xzTg0doqWUaXfJA9/cW
         gUWFecr78UPoFOFY4Z1thJTjMwigMdS0JXmv0JhgV9EBU3hM84OaefLSQ8xBqxP0lYTr
         rgi6cdbX5+Yu06WA3EEVxL+KAVFr9r0ko2oYrsQ9HfZIDMrOM9XzLOLUrxD4lTzSLEaP
         sRA98uFp2//ciKTdqo3vI7KvwAVB+laQOAsAgpGEKbVOLBp9NFXJ1ct275kaEifEX1Jq
         ia2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478475; x=1757083275;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJrFx3WCqf6VFVoWT85m6XL4XoNDn8hAld/4UFHpYgs=;
        b=lxmX8GIJRBYDkVI/GRkq5u/nIYGBbkiZ5pwt7kPMDTuxxe3iRoKwtkr+PG3Cw1YPL5
         oXPunAGHgkbQP8g0qQfxqU8+Z6B8prG043GELbr5q9coJyJgvHELzqB68m9Sqb+4tnfb
         LqK8ywJCR5VvvCOTnKuBiraSu2uV+/gF6Uq7TI7TNGgkA7fxoAl8mW93vPb4ZyZt3KQx
         QAVSOJt5URcrw9g8B5uyYVzSsmvsr2R/H6Ys1cghTV/yGzzFVUUZi/U9gw3z9rplsFCd
         Pziu5N/MWKOnetTRdSZqQx4UXKozj11RnnrWLH67rPFMEJabnK5ICOEu18Bd6VAiPt+t
         hgMA==
X-Forwarded-Encrypted: i=1; AJvYcCWe5BMcbt085PluSLAuab1Afy5pgkoMFuGFLdc5vtjV42hypN5RxlpfcJmn/qOjzNCkMaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJQvidhZiNROv7d0T9l39PYkJVqTQUjduOiuijldCVBeiMNvHl
	wEROta2+hnArQCoFOIZ22mztn4yrevWAM3V68s4xCABi3XgqejRRLQigg/fY2sxQnLg=
X-Gm-Gg: ASbGncvMHoyAhb7BEF+oMlja1uPCXW2Bi4A8tq0lrvIRrzMI3bvH6XRB1qRaXl9r031
	BnvJUz+ZgpOEbWLRA6M3ZetkbErzxDiJCrRc+gVyjJwGMoTJy8wQk8xQkogNObYLwX+2dnU8s89
	jYwykzDWVcSISDB0k06yOVq1iJK0/2JulN5TsyVinrrVXZ3CMsNxLqQ8dJ0efo6PeZ18vCru2iZ
	JLE6/6zyIOU2KauIhKFi+yezqOdYl2DYobtMmqv4SvELuFE7KBPlsafugGjKX4tjTRzLaxjzbtm
	ZwqQqjWfoJg6AWREZImOWZA5hoKnojZ9uy/V//Rixrt76SmQPd+RG7xUfrjCCfSvM7U+Ca0jdAx
	ouQPcPL1dDdDnYtMkBhy76KMUZP2haulEYSZ7RVFGPwd2AQ==
X-Google-Smtp-Source: AGHT+IE+tippTw8I5Rjqj8J4MuD+XFXMLrYSoKCBTNLNIx4D19MX2vzDRgyVPUrBIKEMjW6IJPF1lQ==
X-Received: by 2002:a05:6a20:c127:b0:243:b8c8:a247 with SMTP id adf61e73a8af0-243b8c8a5b5mr5669681637.2.1756478474637;
        Fri, 29 Aug 2025 07:41:14 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:14 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:07 -0700
Subject: [PATCH v5 6/9] KVM: Add a helper function to check if a gpa is in
 writable memselot
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-6-9dca26139a33@rivosinc.com>
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
In-Reply-To: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>, 
 Sean Christopherson <seanjc@google.com>
X-Mailer: b4 0.15-dev-50721

The arch specific code may need to know if a particular gpa is valid and
writable for the shared memory between the host and the guest. Currently,
there are few places where it is used in RISC-V implementation. Given the
nature of the function it may be used for other architectures.
Hence, a common helper function is added.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 include/linux/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..eec5cbbcb4b3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1892,6 +1892,14 @@ static inline bool kvm_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa)
 	return !kvm_is_error_hva(hva);
 }
 
+static inline bool kvm_is_gpa_in_writable_memslot(struct kvm *kvm, gpa_t gpa)
+{
+	bool writable;
+	unsigned long hva = gfn_to_hva_prot(kvm, gpa_to_gfn(gpa), &writable);
+
+	return !kvm_is_error_hva(hva) && writable;
+}
+
 static inline void kvm_gpc_mark_dirty_in_slot(struct gfn_to_pfn_cache *gpc)
 {
 	lockdep_assert_held(&gpc->lock);

-- 
2.43.0


