Return-Path: <kvm+bounces-24732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E59CC959FD1
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 988C71F245D0
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6BC1B2ED3;
	Wed, 21 Aug 2024 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="eLzFTYDS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82DC1AD5F4
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 14:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250416; cv=none; b=AQyAwb+AvR5jO2HH6OaMYj9UtmUNxLQTU4RSQfRs+M5bPkQMndJ+b8A3blmLXCoXzc94bkLwnQU3i9q6Erku6B1Uv0cLz6pEAyTMAcRT0c59U0HgHw1o8HvfL3BvixjE8fiBFaBmVLNjiZMOBWk2rGoXaLyA4oQ4pZbh4GtBibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250416; c=relaxed/simple;
	bh=K+V7s4lhvmj533HTxynH3XTk1ifZ+Jcx/a/SUHWKnfU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XCAa245Gaz6Qfp35IJRSOBNbib5fgNXPN3tbM/KmegR7+QpllXy0Y9ihh4mW65jIzQ0JS13D+Ktv0sI0HX2rUerLEN6/Z+au9LlqpmtVIN0x88OYXCP6fFAJ7d8F+/nZOIrPrIuDLHQaVvfdFMkvr7F+oSyavkvEk7K3jkktvcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=eLzFTYDS; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42ab99fb45dso19879225e9.1
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 07:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1724250413; x=1724855213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXdIh8b8xsEHMRPpfkOL4NE/nDWmTWNNEanJmKrWH1A=;
        b=eLzFTYDSP9Xt/uW/xYpmQJc9njy9frFxRvyAoBbPN0A8IYYedeepOitOOPd/PFQU7+
         tGU6rvD2oC2antxm/WYwz8WboLW9LWFsum0XXtnYVV+/UIJYRsxZ++AB4zhk8iGo21IO
         kwr7sbvmw6MQ4H/0H7JS6wQG/c4Ky/TlssyzDlDb1xOZrAKm6d1x9DSVTy891wWo0/gm
         uVNAxp7zfRsO6JtMJSrBkv1RDMJlZjZvOS2gyDmoi+liQc/K68P8w9YnDK2cOnFjgelb
         s3/JcCCF2xsw8RH8ealsFmQVwIs9CkLGJdaYVslculiZHy1tLQDYOxmoqeBhtLE7oCOw
         Bf5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724250413; x=1724855213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXdIh8b8xsEHMRPpfkOL4NE/nDWmTWNNEanJmKrWH1A=;
        b=Ppp6q5/5U3cU5qQfrCdT+TwQQkxIUapRQ7Kf3FIMEYmHAHpawiwYiXat18JfrZbReH
         /ux0Y3VmuQ8BjxQE3iBXeskQIFwaKuop0eWuzPLJfC3BYDKaDi81vJ8uTK0Z1EpIhpJI
         Cab+90Ha5aTjzYCbdxmBu2/pfny4HQ5hJbCOM7N7RVedmqTqbdV2OpcEuVa9n5E0TAEE
         KIAaQGobEdZVPmsqFr2XkMeE7u5M/zI+zaFYQO5I75AHfUKBssh8GLM/Ge26avnGS2XK
         7XE7C7b1DzeJGnhFrvOfavH/73yq3yV5L3ewG+q7f0TquCtd6wXmi/E4pCverygSjm52
         PR4A==
X-Forwarded-Encrypted: i=1; AJvYcCUynwnLkZPIw7r3GuZ1TQcStBkwlVCYT6/CEyoBKD5jG31rcDBgDhNNDCkqndYfTQgrxnc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkIuDG63O6pys6Fh9VWu3qlWBf0TgTGADzDdjXCinwZVgFn9sv
	w0Jrk98hcofRAU/S+47X1XLPWoA7Jtd40W3YmBtZgdd7Bk1sK625touLvmsMZzs=
X-Google-Smtp-Source: AGHT+IE88JXO2twpmq32Cb9MW3e8dGHHyuJR6n2yRh6Jgp4wKRdFEtp+8UEdL8Pnee5IeiPEJWvqBg==
X-Received: by 2002:a05:600c:310d:b0:426:6ed5:fcb with SMTP id 5b1f17b1804b1-42abd113c18mr26021405e9.4.1724250412671;
        Wed, 21 Aug 2024 07:26:52 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abebc34ddsm28646765e9.0.2024.08.21.07.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:26:52 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 3/4] riscv: Set SBI_SUCCESS on successful DBCN call
Date: Wed, 21 Aug 2024 19:56:09 +0530
Message-Id: <20240821142610.3297483-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821142610.3297483-1-apatel@ventanamicro.com>
References: <20240821142610.3297483-1-apatel@ventanamicro.com>
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


