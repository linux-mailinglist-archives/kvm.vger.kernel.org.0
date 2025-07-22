Return-Path: <kvm+bounces-53064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E68B0D02D
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A0DB546462
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690B22BE02A;
	Tue, 22 Jul 2025 03:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vghvxWC+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B56291142
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154136; cv=none; b=idj9rghJUli8s89dDSghPZJiljeiDWHloFHTz/omZ9hQkd741rTG8vDGhNoCXkid2dNwDGZ7Cnp3OME7ZkY08TDlzvgWekL9nzCPMjf6tasHwND1jZmVdqq4JrL2IRXE5R13sTesTK3tx76KGG28EeRbNcCIoOfRkHPaCgdDNHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154136; c=relaxed/simple;
	bh=yUjOZkjnGhxBQWWEVekYL2PE2feGCddt+D8s2xN7xzU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y5CDgkdI2M6ctgwK2jH0NLVFiiTeGQHBYUamTZ81twPLhmXqfj4iXx/WtFuKNbP4aFB8pf1L7HmrHXELhKkGa6uQdeUqCDqbKcBrSqM7AbN2kGU2BQVjmSNdnZZcN1YrVIFvKzXL+hqoESI74+b93PVx5HkOvjBr/GNGpq5hsws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vghvxWC+; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b271f3ae786so3695788a12.3
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154134; x=1753758934; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IczIPc9KHJgwzJvoZ8OSDmYG0jZ0892D1g8bhwKC07A=;
        b=vghvxWC+freSDWe8HHFq0EL0qC+AnK+5+5rhhVhu1BHa4ViE6WsnSYikp26q7e0XLp
         2YvSBfJq5ZG2jq1SCsZv2LWeMqLvT0HigSAyAy0Opb5PGI1+EJo5x6JET5kLm/J90Nzg
         zeeTvqdXZxvamLvsstHgBYmTWOX6DysnAMjxERhS7t40O73GhlUXjuaK+GT2iMVXbI5V
         7tKS67xlOLBEY2fGSgw6pEMGloSIlSgS4SYTrmc9DGXHevtbD4EJbl2SbzhKxELsF6Gu
         Y4I3wlkkDpOLRmPBs+B8hgKW92lvNly2mb/mzITzpJdH87H0nK0jL5SZJXv7WaqTU88J
         godw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154134; x=1753758934;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IczIPc9KHJgwzJvoZ8OSDmYG0jZ0892D1g8bhwKC07A=;
        b=AYn7R8ErfLxRssvP6iE//NSiM7gfxNmmks64BCBQmUI1dP4AinKYP7YKx9ps+9mMt5
         WN0eHy584iH9GJKsnCO0hE2XsTrKRcIPulbFwh0rBPnMyAbAjCdyMMhSSExqazcHkCol
         7hKktOoH3/piTlzculQIqrY0IWazYDQzv1UpKYNByibY/2ULriuiEulGJiUqb24agl75
         dG8q5lNsg8SqAo+qsDuhgDSXAOrABp9nFvkgWmittvVhf2RoYO21z3DqKmzQEYSF8ksQ
         n9iw8XK+IR/ziDY4Xk9VapTPvxF+3S74GH+7k/Sue0QEe9+rtdV8UR+Ziw5UK6Qf0cWO
         pQbw==
X-Forwarded-Encrypted: i=1; AJvYcCXx/knwzpO3CzfQGI2UiduwAlLpTjbl2nSoy411huHoYNHF9lh3HpSuHCLQwsJGRj/OSfc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ7Hdiewsbz8tzs/Hp1ZfqqxGFn9EE5Xj3aj/jksSO3lKHAZDD
	JD60ZHEStwX3MNoYnndWgHkEds3OKC/zhtMmiWlgWZHNhGFyV4ApRNg8j3N/uyj9Cv4=
X-Gm-Gg: ASbGncuaNSb9YrRzQjE0bdnvdkhpWum14w9BSr203Dhhg7FGtzZX0VnJ+IEvQ/jjwiV
	l/Ql5zZI56GMNs0iG+o8UY1ZNlZgTFLkhSNpidtFPZuUtPQv2iNcUYSHUthDqfauWJAcj8wq1N4
	ZANXcrWcBUuNQvZ/AC55vw9tq7CIcn6IsTtJ47h7Qv4x5sxkgahG+om3v+Obj8l3VxH3t8beEB3
	5Ovqb3evDdypsOJZfpa+J9foSsCJhmUnKOBpa/BmZB5g1Qi5b29APdO3Q8ip/nFwsxn1cOECNnf
	+ILDmADdvyOukJfg20Plg82nNaPN3bnUDiEQzKXP3UchRRWZB9DuWtR8sDeG2D8kuV4hO6D9Eir
	S/gCnEryfFXqEH36O1OgDOYPXWRuXT287B7U=
X-Google-Smtp-Source: AGHT+IH3k/+gjr1r10wY69nF/zLNtmLpBdy2psVbdr40RupdADuqBFyStTW2VIXjsnxPyVZeQF0kHg==
X-Received: by 2002:a17:90b:1646:b0:2fe:85f0:e115 with SMTP id 98e67ed59e1d1-31c9e77cfe5mr28771702a91.26.1753154134478;
        Mon, 21 Jul 2025 20:15:34 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:34 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:25 -0700
Subject: [PATCH v4 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-9-ac76758a4269@rivosinc.com>
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

Upgrade the SBI version to v3.0 so that corresponding features
can be enabled in the guest.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 439ab2b3534f..03fd350ce7d1 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -11,7 +11,7 @@
 
 #define KVM_SBI_IMPID 3
 
-#define KVM_SBI_VERSION_MAJOR 2
+#define KVM_SBI_VERSION_MAJOR 3
 #define KVM_SBI_VERSION_MINOR 0
 
 enum kvm_riscv_sbi_ext_status {

-- 
2.43.0


