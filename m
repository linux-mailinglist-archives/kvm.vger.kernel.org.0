Return-Path: <kvm+bounces-35172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F21A09FAA
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:47:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 309AC188F25F
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F5880BEC;
	Sat, 11 Jan 2025 00:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="NAvT3SRs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A80A17BA9
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556429; cv=none; b=k6sNSsKih1hjWvjw4edr5TCOaHwgeY6XqowkJL/txUy1JUjs85xwOnlQg/6l9HTHp1zlczqjYxXu/QMeGYx3LEk+RSeNrOCwuqCGUPHB48hLb+krEruSUzF+6SxqdGOJFcqyVt+whCXB8h9qTGG5HDA+yBZAW+pUu1xlK3MmTZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556429; c=relaxed/simple;
	bh=x73fNqoAS5LRFmLCPzUJa5e+UjVghwTErrVQRXnjl1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mk+z/O3H3kLCn5jON3W35Nrw1AYa/OB3xhOXDnjdFPRpI8wJvOL1cx1mnSoqGK2JqpmdO9igw9OnEKr+ViKg66cgkqsufJsA+dTXoU0E5E7iK/5iRc/HQJes5YimxQSS+eRBwZX1CASZdj33CxK0YbLuQv4cq3/NT3fs5tDqsnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=NAvT3SRs; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ef8c012913so3432996a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736556427; x=1737161227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhKWMGnM57WsMY43qomywj90difyS8W0XzJpu0qHE5Y=;
        b=NAvT3SRsWOLinGDQiHK44VVSX2/1ajnGSrVtiOSlaVJa/7cyXri77QfzsBNUO6KjSw
         OQnRJDOOkPAo/UTrpi7dvi8GDZSqK3tb3bOUHyLBtCf898NDC4Kmih1XBPBkKRzONRvp
         8FDRJKzLPyU+WwjNxW6+hxNi/Il2+Yi5qGgTXjHsrXm2JJPt5bjVS+WefMIbHNxE5wgT
         RfPafRkJptKbSTC/sXHbbYLZSxvEEYyjv6KjQIvLenrfQs2IPxM2RB7NQtnjfBFZWrxM
         MKxYBI8zMV6fnfSPRhIFUcXc0uN4JA0/RSSfwCX9XccIbENH2fx6jB05gn2C12wXYbWn
         VINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556427; x=1737161227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dhKWMGnM57WsMY43qomywj90difyS8W0XzJpu0qHE5Y=;
        b=d4ywTfhgd52TfvP1qMFtfcOy8U6f6wkO7qEKSQDzivTHCkMI4KB4ITStMT7dx68UTh
         TvrRUPYZKGmkjSSdqXDBOK/eAeGTFVk50V3zITxMGx8FWDz/8JTyMcGSIY5axcSA9umy
         m4KdAT44bdOcRQ2aAcq6R7r4JKxf5XlHEz+dKJg0B6LbRTEV4+U+ei816VTyhaH4py5b
         6ddGcMk+Dx4a6Mpii+HUsbsRAEqRqtxg4uW7rh6I6LzayWeR088JyjRy+HVSWP5DnxCK
         yd2De0A8in021JB8ZVZgTh+uPxwLbZM6S9JcdZZ7YG/Gu8m0lTdOWKwJ5JtUQtYAQxIq
         VoJA==
X-Forwarded-Encrypted: i=1; AJvYcCXb9+F4e//Fdbi6fFd+G9fgm8H5kN0OmbzgNTsE12VaLiXA6PxVHGvcMFkPZoyc13sJz8E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4TLUa/4dngC4TS4LwV1mIdPmElDFbyuhdMJpqV/9LGIvETvzt
	tU5bJ8t+q7LJTS5ZZtREsU23Kij8Lj2Rmb4iC8B01CPIYfEZVr9I6UDQpA2kYTg=
X-Gm-Gg: ASbGncsU0nRI9sCwaTgUiXA5UGoXQ4x/rRYmqiiz4FG/+7tcQhU27mzu3DWA+D4X+MJ
	3U//aBGWL4cDiK1PQ446vNRrwjvNx90VqukyQP6s7Yrw5fnXGOs0swEdnXwiKCe70V8/vhn/BR9
	A2/kk6V//flpeTmJdTwObfF8DV9qiV6COWDISV5djEAfbOckW7CL8QOuxLMhvJLQqRgWu0LcZ9m
	zg7AyLnf7se1d1oKv3qcyYYjTaDMRcz232KLauDO2JVCpP6RTjJe53vwDBgGQz+q3rxyf1BTQ0u
	SEM=
X-Google-Smtp-Source: AGHT+IEzAQsFVVUnarlp48IX+/exhmsTTctl6ss+iMEnk5dre6TgWISy267dYaDXt8LAjE4L45Tvqw==
X-Received: by 2002:a17:90b:3bcf:b0:2ee:b6c5:1de7 with SMTP id 98e67ed59e1d1-2f548e9872emr19653709a91.2.1736556426732;
        Fri, 10 Jan 2025 16:47:06 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a28723esm6064295a91.19.2025.01.10.16.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 16:47:06 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN
Date: Fri, 10 Jan 2025 16:46:59 -0800
Message-ID: <20250111004702.2813013-3-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250111004702.2813013-1-samuel.holland@sifive.com>
References: <20250111004702.2813013-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Pointer masking is controlled through a WARL field in henvcfg. Expose
the feature only if at least one PMLEN value is supported for VS-mode.
Allow the VMM to block access to the feature by disabling the Smnpm ISA
extension in the guest.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +
 arch/riscv/kvm/vcpu_onereg.c               |  1 -
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 70 +++++++++++++++++++++-
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
index 5782517f6e08..5176344d9162 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
@@ -30,6 +30,8 @@ struct kvm_sbi_fwft_config {
 /* FWFT data structure per vcpu */
 struct kvm_sbi_fwft {
 	struct kvm_sbi_fwft_config *configs;
+	bool have_vs_pmlen_7;
+	bool have_vs_pmlen_16;
 };
 
 #define vcpu_to_fwft(vcpu) (&(vcpu)->arch.fwft_context)
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 93115abca3b8..1d2033b33e6d 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -168,7 +168,6 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_C:
 	case KVM_RISCV_ISA_EXT_I:
 	case KVM_RISCV_ISA_EXT_M:
-	case KVM_RISCV_ISA_EXT_SMNPM:
 	/* There is not architectural config bit to disable sscofpmf completely */
 	case KVM_RISCV_ISA_EXT_SSCOFPMF:
 	case KVM_RISCV_ISA_EXT_SSNPM:
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index 1e85ff6666af..6e8f818fd6f5 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -68,13 +68,81 @@ static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
 	return SBI_SUCCESS;
 }
 
+static bool try_to_set_pmm(unsigned long value)
+{
+	csr_set(CSR_HENVCFG, value);
+	return (csr_read_clear(CSR_HENVCFG, ENVCFG_PMM) & ENVCFG_PMM) == value;
+}
+
+static bool kvm_sbi_fwft_pointer_masking_pmlen_supported(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+
+	if (!riscv_isa_extension_available(vcpu->arch.isa, SMNPM))
+		return false;
+
+	fwft->have_vs_pmlen_7 = try_to_set_pmm(ENVCFG_PMM_PMLEN_7);
+	fwft->have_vs_pmlen_16 = try_to_set_pmm(ENVCFG_PMM_PMLEN_16);
+
+	return fwft->have_vs_pmlen_7 || fwft->have_vs_pmlen_16;
+}
+
+static int kvm_sbi_fwft_set_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
+						  struct kvm_sbi_fwft_config *conf,
+						  unsigned long value)
+{
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+	unsigned long pmm;
+
+	if (value == 0)
+		pmm = ENVCFG_PMM_PMLEN_0;
+	else if (value <= 7 && fwft->have_vs_pmlen_7)
+		pmm = ENVCFG_PMM_PMLEN_7;
+	else if (value <= 16 && fwft->have_vs_pmlen_16)
+		pmm = ENVCFG_PMM_PMLEN_16;
+	else
+		return SBI_ERR_INVALID_PARAM;
+
+	vcpu->arch.cfg.henvcfg &= ~ENVCFG_PMM;
+	vcpu->arch.cfg.henvcfg |= pmm;
+
+	return SBI_SUCCESS;
+}
+
+static int kvm_sbi_fwft_get_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
+						  struct kvm_sbi_fwft_config *conf,
+						  unsigned long *value)
+{
+	switch (vcpu->arch.cfg.henvcfg & ENVCFG_PMM) {
+	case ENVCFG_PMM_PMLEN_0:
+		*value = 0;
+		break;
+	case ENVCFG_PMM_PMLEN_7:
+		*value = 7;
+		break;
+	case ENVCFG_PMM_PMLEN_16:
+		*value = 16;
+		break;
+	default:
+		return SBI_ERR_FAILURE;
+	}
+
+	return SBI_SUCCESS;
+}
+
 static const struct kvm_sbi_fwft_feature features[] = {
 	{
 		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
 		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
 		.set = kvm_sbi_fwft_set_misaligned_delegation,
 		.get = kvm_sbi_fwft_get_misaligned_delegation,
-	}
+	},
+	{
+		.id = SBI_FWFT_POINTER_MASKING_PMLEN,
+		.supported = kvm_sbi_fwft_pointer_masking_pmlen_supported,
+		.set = kvm_sbi_fwft_set_pointer_masking_pmlen,
+		.get = kvm_sbi_fwft_get_pointer_masking_pmlen,
+	},
 };
 
 static struct kvm_sbi_fwft_config *
-- 
2.47.0


