Return-Path: <kvm+bounces-23694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F04E694D15B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B911B237E4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 13:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606A119753F;
	Fri,  9 Aug 2024 13:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cAo8IySN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B505195F04
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723210503; cv=none; b=ihUPLtYS02q9v35CdBgm73O/TMXq0hTmzfOD47aBWFXUKJEMgalk+4vLZ2hJfD3kL5Z/wp3B9/pSiqgmjuI8afF7PMub0TceDt6EMxqLYge/I3Ba8byoKRPNU8l+I2xgc1jqTha6q5eXL0drruNuDYcI64hxC4kHNtbul3XMO88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723210503; c=relaxed/simple;
	bh=K+V7s4lhvmj533HTxynH3XTk1ifZ+Jcx/a/SUHWKnfU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sp61MjdHK6oOZZ55egDZsg8TlgBNVPNdAogWYYqnDU2/5PgnRUBEBYt0FzAfTgWoYHiejQZBDy2LIqNfDDHTzAms78Ee3tPHP+raieceVHMMCRL+TdhhkVdoZ0nKv0dq9dcb9z4JtsmmZ2lqOb0mURLECoj1q9fywInn/6gKUYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cAo8IySN; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7b396521ff6so1651934a12.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 06:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1723210501; x=1723815301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXdIh8b8xsEHMRPpfkOL4NE/nDWmTWNNEanJmKrWH1A=;
        b=cAo8IySNZ+ddDaWLE+poLJZtNrqCDFe+pd5TiJakSfSfIiGZCZQjM7VaWUXENCaHaH
         BfKOawh+ZhdSYfgQIwbCEEGaMNZJigMutR8nEAA6gbAX4t7Nzwf6VAjWf2g183tW4Q6J
         XXphd75Jis/Kd8PwkMMyHleXIEGAEH4Gsluj8PXPdQpYpSlne76n82Ni3X+8ggELS3we
         LFO5Jb3erN8yylZjQO+TwOpCiSh+0LRzpj3MHQSa/PVRl2dNFH+/UKwLjfNBvhxnH06K
         u9UWOA2yWeJANWGoFRNQb/D6xk53z5s92vWD8snPBFHV5NyaWVV+FDs5/eYdQdS8KJYD
         LO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723210501; x=1723815301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXdIh8b8xsEHMRPpfkOL4NE/nDWmTWNNEanJmKrWH1A=;
        b=IYKIzG5as3eRYZtFYTzNrmkCGFP6aPHxWRt1cWqUYxUfYM6BHtGR9v1DXy2JO8eUzp
         4Qe2GcU20gtY+tuyiNGZxBwS/dpowYj0TYvhtmbZvrYD1FflgUyaSLbvjJ8fv2QuhQfa
         W2uOtIP8uRtLaZgcXlT7/RzTLWv0RuzAkFbLRVHHR/TqrYdCCVLCocZbgPGhni9UK6a/
         gP7ZYWzqqQogF3tcO43GQY/PZcnasPwIav6Er2Qe4gFzdxurEAaIDdNQT/GAUJ0h8Tow
         GJmVipcLgTHbBg0p85US1XnPu5i89LCKLL7nfgFhKFyNzV4PIn45dp+bfqjNtX5ULXNL
         BUGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIquyoHQtjJvpUYeFnj9UYLDMqrbjFGqyWuEaTwQoxxvzsAsBEG3mUrg9wyTsWy1e91y8EUSg3qAHtlC9kW+5DvNsI
X-Gm-Message-State: AOJu0YzladwsD0UPpjPg0sFRE+o6sHWMnz8apcQSDX5bcKwdIEDskcxD
	DeNlutleUZ+GdKFZ5jElXNIU9AjfT7tLIRX1ftwN6PwdQq2qiLlX6sCmw5kpUYM=
X-Google-Smtp-Source: AGHT+IEB7dT26j/Diue9jPPQkJ4/fO+gdwRdmAym9DuYkekhfrZ/mIEeU4lhddcnVLIB5FEBgtdl2w==
X-Received: by 2002:a17:902:f689:b0:1fc:5879:1d08 with SMTP id d9443c01a7336-200ae550755mr19846695ad.32.1723210501265;
        Fri, 09 Aug 2024 06:35:01 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f26f4bsm142107075ad.34.2024.08.09.06.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 06:35:00 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 3/3] riscv: Set SBI_SUCCESS on successful DBCN call
Date: Fri,  9 Aug 2024 19:04:31 +0530
Message-Id: <20240809133431.2465029-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240809133431.2465029-1-apatel@ventanamicro.com>
References: <20240809133431.2465029-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

Ensure we explicitly set SBI_SUCCESS on a successful SBI calls
since KVM will not initialize it to zero for us. Only DBCN was
neglecting to do so.

Fixes: 4ddaa4249e0c ("riscv: Handle SBI DBCN calls from Guest/VM")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/kvm-cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index ae87848..0c171da 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -162,6 +162,7 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 		switch (vcpu->kvm_run->riscv_sbi.function_id) {
 		case SBI_EXT_DBCN_CONSOLE_WRITE:
 		case SBI_EXT_DBCN_CONSOLE_READ:
+			vcpu->kvm_run->riscv_sbi.ret[0] = SBI_SUCCESS;
 			addr = vcpu->kvm_run->riscv_sbi.args[1];
 #if __riscv_xlen == 32
 			addr |= (u64)vcpu->kvm_run->riscv_sbi.args[2] << 32;
-- 
2.34.1


