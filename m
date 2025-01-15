Return-Path: <kvm+bounces-35591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8899CA12AEF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C50CA163E96
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6F91DA313;
	Wed, 15 Jan 2025 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nkWp8jfH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5581D90BC
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965866; cv=none; b=hpN+/RF7HB5z//AVIQ0a/xIVvzjKRw1ZfOAnPEbWBW+yf9wq7ADpXMnPfRaAySNTkBtm1OlI+SzILGLefbUymYYtSVOYfNmtBeMn8irgPaG3sfDcapeQwQdqxj+UPhzMvxcOwBRR8cSTR11kDQUfGiWZi3C5B9K8lH7MIOBDmYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965866; c=relaxed/simple;
	bh=2VZE7ahRiWFyeef1RfOaScKQMn6RmpORm+fo0poup2k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LxMCYDlDwvlsAppIoFgYVxM2aPiTs44n0fILYKyKfU+ftIGp35lpsx9i2vy5qtPMgijBvZ6GiwGKYiDG1v8WWYW+ETKP6NRwo+m95RB05f+dZv1ddLR/oMNOEZ+mV5sA9inl/MP0MGvtC2/QhJhU3SUJhln8AQ16dQi1Y7FKbpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=nkWp8jfH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21619108a6bso126527325ad.3
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965864; x=1737570664; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGsO74qlfZsPi9kGTe6Mf3rItgKav5O5SJKk6N7d7+Y=;
        b=nkWp8jfHWt38tCi3A89AHaGElaPgfNyRMPfRv4RhE9DWQIIIeR1W4OmpSHrz4EbW6y
         Bqh7GxEOYJ8l7iKj9oVom+0EqYn6XaJ8/+gQfXiEaXuQ4uM7FHu1CP9RTolrfYDjj5AY
         VSDKg9JSdqeB6stLmPAMMvft+eHpBIObRSzVJC2PLMPYABIOQ06R5Zv9iKD/pt2C3jLW
         1zUgcs7HG1j78dLCh/adaE1LF9ZJ1tsXKNCOwL5U9XaECPxxlPyTnpS6Vs3LLCFEECgx
         wJxEsGZNnILHRGsLPP3nO6X1m6+i8ZVxFj75POG0gDH4cfxNt0tc69Q4bxV2QdqpGZgW
         5X0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965864; x=1737570664;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGsO74qlfZsPi9kGTe6Mf3rItgKav5O5SJKk6N7d7+Y=;
        b=Ve9Yw7BX+f1JeZdRab5wlPIazwgt2ojshI43RU52beiWSB3VsAS7qmCio7O06ilU3v
         GwuvUWT0Qy6lOB/4TMcsyGVS6ijBVeJt5u2weeBRx/IBlZ20K5ETYem1W8d4Www6oM2h
         BR7P5T7DXMfmc0pW4xvcD6vK36BoN6/RUsGW3pSkUYVxlAXm14YBJFYRWJIZhLpHEkbm
         RSgTsr/0BWa9D61En2ED3gkoM6Nt5zdLch+lb/HhXThrkTR/WbMKxnxZCILk6bpqrPnm
         u8KvO8Pe//eVskYEUnOLMrfcP9E4+2UylaiL+8Ug7aYaidS/Tex/j/xyuiuZeVj9nHrJ
         GqQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPKLBT6Rt0HnpXDRteH4xDduX4Uke+1rFMaw+AHsQbMAnsC2Vig+WeQAEINfdgnO0cWB4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0oVMGEtLCPvFM+Vk8Pau3sROYJXpS/e8oEekR5lGrcw+MaPf5
	9gS1Le8e7D4V2+Z041RKUiK8ioavhgbNRLFhvb4TQHPVquxjqUlNYbHBdYPg25I=
X-Gm-Gg: ASbGnctTli12xYg3TAKvMia/8n+PwVUAmMG38HLholLRxW+7rd1eBl7EQpbve1XgPvf
	XwLTLI3U9Y56m8rRIpq7/OLQ4Ds9ypSYJhHPNi0xcrmOwOTKAcf+2XFo3cbEDkzE7Hbg8f+0MxX
	+WZ1pxnOYKzBEp9Yo5mwdohRZ8954l2GKEijpACK6VIYWzgSHvf5hciisb9PiuCOXsk5RJH65ou
	BmdJFWoWE4llO3p1bw4idIOYV3W4TG1rZ05RGmCppoKCUfS5jCQR6e9TbOiX8q/vMZbjA==
X-Google-Smtp-Source: AGHT+IEVuy0zAtOEk7axH9BqkY46Q1CUJK/CsgMJYOIS0qmHtHOLlyWCGQnQHM7bf0KJ01YfA5xjlQ==
X-Received: by 2002:a17:902:cccb:b0:216:6769:9eca with SMTP id d9443c01a7336-21a83fd35bdmr452990815ad.37.1736965862343;
        Wed, 15 Jan 2025 10:31:02 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:31:02 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:46 -0800
Subject: [PATCH v2 6/9] KVM: Add a helper function to validate vcpu gpa
 range
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-6-84815b70383b@rivosinc.com>
References: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
In-Reply-To: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

The arch specific code may need to validate a gpa range if it is a shared
memory between the host and the guest. Currently, there are few places
where it is used in RISC-V implementation. Given the nature of the function
it may be used for other architectures. Hence, a common helper function
is added.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3..d999f80c7148 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1363,6 +1363,8 @@ static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
+int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
+				bool write_access);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
 			     int len);
 int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa, void *data,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..b81522add27e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3283,6 +3283,27 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest);
 
+int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
+				bool write_access)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int seg;
+	int offset = offset_in_page(gpa);
+	bool writable = false;
+	unsigned long hva;
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		hva = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, &writable);
+		if (kvm_is_error_hva(hva) || (writable ^ write_access))
+			return -EPERM;
+		offset = 0;
+		len -= seg;
+		++gfn;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_validate_gpa_range);
+
 static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 				       struct gfn_to_hva_cache *ghc,
 				       gpa_t gpa, unsigned long len)

-- 
2.34.1


