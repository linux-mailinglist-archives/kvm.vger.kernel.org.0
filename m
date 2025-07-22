Return-Path: <kvm+bounces-53061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27903B0D027
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABB913ACB12
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D03928FFE6;
	Tue, 22 Jul 2025 03:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="w68NOB56"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19310C148
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154133; cv=none; b=OiIGKaBFGMslRNiN2de1LoeQSYu2B4N/ynP9mfeEfWbHrzRvEJNsB50kzfgcEhAD8XTbmvUet6vUrXqHD9DS6vyyH0XlT5VtBtIUL2wREjgKI58a377trQ73v0SwoFFLwHEfd3T6jIkWUV0guwfeUzd87UfOALdzLKzcrlHTDKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154133; c=relaxed/simple;
	bh=MqHwXxa9SSyAxr2Hw1r4Mv5fnDVYLJpVS2ULkJu1mRU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qFmkVeZv44jSTr+IbT9gAGkv8pQymqkgCp9AJjwOQl/q1Xv6LLydDK4G9pHxJ6wd24Hs40yh9TE6xeDKrHpf56CwCkHEyB+qwif2vNsP4mw2Tm7k8AcRpAr3cqxx5h60wqMV1Kp5Qco3tyYE7VKInbRLnRV15OrQgYDXExoUaFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=w68NOB56; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-74924255af4so4358730b3a.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154131; x=1753758931; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SzDB3T8h1PmSiiQR5aHwi6QPgnFacs+893qWZ0jSQcw=;
        b=w68NOB566VukxOWmJF0Pvk2Jk4tg53iQuicIbSOlTmnnA9g9vsHMT5mtOVGHYgARWV
         n/PVjc8FCHCHiXOe+Ia/HyZR0CrrZuJ22yB7CfRDasHQrcdpvyMr8h3/3ODHATCR1Vh/
         KhH+ymfgvsArx39lh5py7NyoU6LBP4TbCW6xU7+nvw3eokG6VGH4HXVamFbsGlhWRvY4
         bRFx/o5HZX5xOb6bEovDb4B/iISdOu1khf4oefHeVu7CBOgqVpAVD+VnAmIAjmaImXiS
         jg4+krkupDVfNYmaaq2f6lrxmfPO+RRAyIINoAyPxa2+aoRXEbufOS+LD3bUwEV/uPDB
         rJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154131; x=1753758931;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzDB3T8h1PmSiiQR5aHwi6QPgnFacs+893qWZ0jSQcw=;
        b=JTOMaIS+UoibRnkK9mhEBotWoMaW8SlvMy2N2vapG/Bh0L4RB9uxIUhmCO0gT0pUs2
         Hy63D5UvhFhrvHAAKhEw808Ba5LdN4Ylm90kRcFJRG+dLfOT2oRkBB9vIH33YIttMQOb
         5uZ1ntYDe8LL0uBf7k89P3W+pUuK4dudqeg24tbL0mvB8on3WBH/LuFRNPuDfJ4vtx1W
         GXuHK9fbX70F4BvoJavq7a+IDYzfUuQFqna91QZueDYATKxoh5I5zHA+5f7+TaUtRV5d
         3L7Q/whPdO2HbA7ZVJrqt1T1v9Kpgu4s0Sxn9oMraNup661w0/7RNG22j8T3ZYauS6Y1
         WTgw==
X-Forwarded-Encrypted: i=1; AJvYcCWv4a0Q8HIqNn4Yc4hoNqd00ajbIkTeVmfO+Iy8sbFUI6t1R4h+yqYLS9jqsrQbb0wcpCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZzVKzNyaVUjOkLfUjcVDmGicd/kIPt1NFnbyaog3ZX9SNR3gH
	GchYamTwYtxH/yQRCaYMuZy8uCSVEvT9ZZ5m2qaoI6MnHvuYeTT/qmlzarFE+bJtRk4=
X-Gm-Gg: ASbGncsB7Mv2z9xR3Sqxfh+8Lp0Y1pLHSrCS6tKb6YIDjwra0zV+xalKv00KSW9s0pP
	bzJSvPYj6WPlPvy7EckeedZJSUM53wndkcLvqzGuRrZMO8+9LhLfARFL9WnVyGeHYgs63BE8yI5
	DPNsgSTqXEtAPld65W+vAhl6txj8vsDJ9SAKHTFqllM8hqhQ8muoWSFhaIdMjKB3qaaL8nwaJg3
	OXT6PyM7huBd6LfiEyAvNZ+Prr6HQhHeUmVHkaOaBmmVPu0fvB00kztrvOg996vREirNdAvV8XD
	hgHOT1+n3AsHIYvS5qf5UUFfxMNb/aNqVoTe+qGEOehxv0DFCXxOkazEqzu/vsMQDu6jhO1TYep
	6G0EZBJidWHOELjkjuZbvnX9XC3HtPaEiaFU=
X-Google-Smtp-Source: AGHT+IFIrVKrPK9UdCTELOyVWNX8T+lBXipMNBQiQT8fVWHbL9rvRg5zysIp/cvj2jz89NoBA/hgbQ==
X-Received: by 2002:a05:6a21:2d4a:b0:215:efe1:a680 with SMTP id adf61e73a8af0-2381143ed4emr32571364637.16.1753154131380;
        Mon, 21 Jul 2025 20:15:31 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:31 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:22 -0700
Subject: [PATCH v4 6/9] KVM: Add a helper function to validate vcpu gpa
 range
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-6-ac76758a4269@rivosinc.com>
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
In-Reply-To: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

The arch specific code may need to validate a gpa range if it is a shared
memory between the host and the guest. Currently, there are few places
where it is used in RISC-V implementation. Given the nature of the function
it may be used for other architectures. Hence, a common helper function
is added.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa..9532da14b451 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1387,6 +1387,8 @@ static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
+int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
+				bool write_access);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
 			     int len);
 int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa, void *data,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 222f0e894a0c..11bb5c24ed0d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3361,6 +3361,27 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest);
 
+int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
+				bool write_access)
+{
+	unsigned long hva;
+	int offset = offset_in_page(gpa);
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int seg;
+	bool writable = false;
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
2.43.0


