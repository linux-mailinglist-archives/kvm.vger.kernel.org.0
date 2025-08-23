Return-Path: <kvm+bounces-55569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7F5B32A29
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 18:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68D7B1893CFA
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 16:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C192E9EC1;
	Sat, 23 Aug 2025 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="A4x5nRlO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD202E9EB0
	for <kvm@vger.kernel.org>; Sat, 23 Aug 2025 16:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755964809; cv=none; b=LnVCBIYoTbbcQiN415zMIJvZvOJpJ/Cdl22Bf3oG+JwWJO8Ke3up2mIi52xdoS7CviPq8pBuTiRbWTRRbPLzeHaNpPyN35b7NKObuKShoWcZ9irgayDCVMJjaJHpfJU5Vp3RGNEhCz5kkjAKMYck9k1EAXnTQVyGlqYZrXPMMBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755964809; c=relaxed/simple;
	bh=WUdBTM0dhD8Re3kqq0DQBL5Pq0pV3tt6HtHEsLxoxa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIwSEHGTzC9HfGmgXDjUlzWHB2AMpsX/a3oMkWXAdr3jak+J6PvJymaPdGkK+3YZX+OIEfe0kVvK+La4uSGH6v+6Q3RBZIqKGJUdK//85f0N6CXrxFr8ja1srLLj0b3uEYshU8gymJAZ3AaZsRT8KVgCk12PgPByKdJZwXms9ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=A4x5nRlO; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7704f3c4708so311134b3a.1
        for <kvm@vger.kernel.org>; Sat, 23 Aug 2025 09:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755964807; x=1756569607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxIYjoD6qGJ2CFZvAXrDV0PDdB+JeyudOZZgvLWLYX8=;
        b=A4x5nRlOEs0eMEekwhHdrr94WOzBOwWUwfBsyfgg4mqWzenHJywiDuCnUiPpqra/Ef
         x8zYA63YhEWdTo5dP1KAAJi9X3DWKZNpJ4kOUBUEexCzTll6juuHvz40fZZXAmI/jByJ
         t2hYbKwQGjAI0YAHmZZFJACfkRHZlL+b+vIOvJxRvsgCVvyx/TvPGBH1fXfJ51xugZHC
         LJE5GZSMl74L7Bya/HDprTVzXxf6xuWkGVduToUWVxY5Yd8XB0kacfrCrAatvbz7nj/V
         ebyPe4gLXGLGHNBH3RRVHrpW6WxSrboKAeY/KTsEdch64028wAAZD7Q2MbtmDgerru7B
         JwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755964807; x=1756569607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxIYjoD6qGJ2CFZvAXrDV0PDdB+JeyudOZZgvLWLYX8=;
        b=B1fNXuGVWPbzTHfeqFX/S3f/TpVdSgkXuZ6TtmX26VkN1eKmsi8xqSGGR2uoapW1lI
         NqZm16l2XEHIhtlFrv5z+qcZlI5FJpjkE39Tk7Qbt3nSBeVRCdjs1wcAXA1xHCQMNOJA
         54hcEwnpvDNT1jXGs4imLPyUUBFfOd8el9if4e+KmLEBv9FiLdactFr0wxC3xhYgOwsG
         SvBQ2H8HmKBCqaDjeZcTn9Qd6Bp9hMMsYitw8ZdV37bFrEir5j7gNmu976w55nRGTzLr
         PnqxXVry69CN/9u1AgE+UlxLiy6yFBn2Ab1QWC5ZzcruGdnUdMRVG01rMP1jbytFooGv
         /zYg==
X-Forwarded-Encrypted: i=1; AJvYcCXlbJZCDwz8Wu95M2Eq1KqSORgASwaw2aLgk1U4WWqIws9XhAGC66QdBgSvCIQQl9pW+hY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn+Tmi7Q0EU0FCxkLa8zfGVOs8lVQhGIoUWLRFb0a6YQZeNNA9
	ueUAxN+n40hfy20Kkph6kuaaSnkDioyxwuyiMHgbSDdKbSuLpziFa2klBtQz49iwy7k=
X-Gm-Gg: ASbGncuTLgwO3xP0tq2siDvgXKy70xJ+HdsH9cqFs8ZEdrFigGkTg2E6VFlvODpO6e7
	Lj4F8ytknsKrs7kXa9cTed/OUEeyVWJ93m+eP7ZSFIbSUNvsDw/pG2Znz5JwGvxi78wdPykswNF
	wGIRy+T/fPDerkkXVgAGzUjAZyAZ+L/BlFIS73PUtFz57EwdPGCJiET1ndSCghlk8Qo17vqGq/g
	MpjtmWdtCmj8V9+DTBAAG3gloI6dq5zzOHMwItyKIu+a5IzWR8QJpm1kM2YSMBZTZ7Ov+lHk9Gv
	xvzE2LzM4fwAU3Ytse1w3bnuYBSRU6e+15Zrjx0HemjmmOD2pLZypYVun18FU4Pra5Wji6yX4pq
	l3VkX7JB/X/w7jIdP3SiVDLPdTpTxkftKqpKjnoH4+yIgriyOQF7c0uoxRy7n943yDOiNazhY
X-Google-Smtp-Source: AGHT+IH5FZJLOyfrOllB8g78rtlC90yaqO9Xq93Uvux/rEMgW/lp4f5ouiM5epDFAdg0M4MxVn/lXQ==
X-Received: by 2002:a05:6a20:1592:b0:23d:dd9b:b563 with SMTP id adf61e73a8af0-24340d15dcemr10004613637.39.1755964806710;
        Sat, 23 Aug 2025 09:00:06 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77040214b81sm2804464b3a.93.2025.08.23.09.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Aug 2025 09:00:06 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 1/6] RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
Date: Sat, 23 Aug 2025 21:29:42 +0530
Message-ID: <20250823155947.1354229-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250823155947.1354229-1-apatel@ventanamicro.com>
References: <20250823155947.1354229-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hedeleg may be updated by ONE_REG interface before the VCPU
is run at least once hence set the initial value of hedeleg in
kvm_arch_vcpu_create() instead of kvm_riscv_vcpu_setup_config().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3ebcfffaa978..47bcf190ccc5 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -133,6 +133,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
+
+	vcpu->arch.cfg.hedeleg = KVM_HEDELEG_DEFAULT;
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
@@ -570,7 +572,6 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 			cfg->hstateen0 |= SMSTATEEN0_SSTATEEN0;
 	}
 
-	cfg->hedeleg = KVM_HEDELEG_DEFAULT;
 	if (vcpu->guest_debug)
 		cfg->hedeleg &= ~BIT(EXC_BREAKPOINT);
 }
-- 
2.43.0


