Return-Path: <kvm+bounces-33663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 566FA9EFDB5
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B28F0188D0A7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4FB1CF5EA;
	Thu, 12 Dec 2024 20:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="DDjfKFD1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DC31AF0B0
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 20:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037022; cv=none; b=Y4kgrLITINhwTSfhB9r1BiQdVI4Gx4EU1tRFhdPGIQtfRUKKfDxD2Rk73bUZ5E4LSF5QJYtJMw3Vlvl4nFVhHMKwYy/nT8tM77Dnp/faLwRnjNPTvZX8pvAzAv9V5Ge6MsUlad3c3bGeWgbW+2siPMerQ4hb751eySG159ADOMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037022; c=relaxed/simple;
	bh=STe4e+9WEqKYdCIY+5uN2OC0S3vV4Xd+VYk5Fl2odcE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W1iv9WJIbeE0KUC8qWOz2E1MfwV48Dcc/hmrVPoyMH+O70eqhM4IDGWJn1AkRHNYrtNu4JSG7fQYlb8wDNyJMLmELQWlmvO1/M9bvhfw6exvphJt+Bam3IYKK3xFKlXx0b/gETSR+ziFJnHBZSvmCUGZ0R1YZzblH/wxL2KhKHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=DDjfKFD1; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2165cb60719so9019055ad.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 12:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1734037019; x=1734641819; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d9bocf/te6xqIlX1+3PhmzweHiQ8rAPL41LYUao1zG4=;
        b=DDjfKFD1KbG1l5UEQv/eWLdfaogq7kyuXEijpz7Dm9ftgAGGKtKlA+ZyPCXnbscyji
         8+fRGF50Sa5L8+vnFRBsPCRUXNyeB0KaXiAMVzLzr3C7kfU/zogUCqvtIcBNR1IbymUX
         ziVXgdd1GbMEekEt8e6XPQCSMPMyH/ByyJH0wI1qEHgVcNdiCzUEdf2xW1lzN7YzEKmm
         rDZ/v/QYRXdOndvGew7eLcnnQ/7e5ZUB4frRxjDkoz210sDcLPVLSdmiOK8Sk50k6+a/
         7zNzBvCtfcAubuUUBvTqGKhKk3b27qmh9xRnWI3suAwBVa4Tk5BFQfG6SLH8x/60HSkA
         2kQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734037019; x=1734641819;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9bocf/te6xqIlX1+3PhmzweHiQ8rAPL41LYUao1zG4=;
        b=UKPalXWr4JsUBQSO/VO76RD2xQkIr7/4sMW4m+0QnrYULZsHBGCbXdvj7pb58+aaaV
         OBeXHB2eVmHfK4+GY1UyhPbFl9XNc2Otn3C7zUqXq0Vw8F2gSyP67lRSJJn/n/j2U9lt
         pVzsoHuWNQPC9h00AYy4wKO7oT0Ca5rWgFC4E23xvoiKt0CQhLZ5UoaoOPBiP6zUDbTV
         iA+1rqWo9PTdpY+MQmyZKQKiJ0TTby9zv7HRDUbD8KckGDzILMnGGFy9tM0lFaq8qzYH
         ppy9sjEmlRD5kIJeQLtfFFjcCUOOSKDTU+K5IXlnv/iPKBvzxX4p7LAkLx4LkGIz9c6y
         pKww==
X-Gm-Message-State: AOJu0Yx4+oH9WaqG3VMoW4ssWrzp17nJ7CpVkEsPJWtFqqSD54N0xN20
	E+mls4ap6iMMdmOnZAg1wr0Hxkb9pGh0VgwWFslzLQ2LFgvoagAxZ/M6HbjNRjYeww1EtqrnqhH
	F
X-Gm-Gg: ASbGncuHnBQhPBM2wqvVl0qbO32bE6IOV11Nk8+56ek5BMDdVIRk7iJoVJVXr/lWL8t
	ESeBpyBmhjSX0N27gdDwIQFtlZaldsB2GhmmqJx6WHhv4eaJAQzuBk+gSu/Tpt8yCct1QRjbD9o
	wg/6H7SMXl3ZB6ysGiNzjq9m6qWNqKa05bs2tWVTBVJO92/PxwdCHdDxOOejd0vEnAtUowxH+59
	66OybA68lbjcWlTJQIphE/FkHX8/TcvWjWLl5TIl0jjra1Bq7IBXR78+Q5VS4jfkpB8aw==
X-Google-Smtp-Source: AGHT+IFh1FwmitrjM9d4Q6KSLRToIyFObPTDHz3LQbh1hbARG5r4BQI4+oOsAfuzEnKREvzvjAp+Cw==
X-Received: by 2002:a17:903:32cf:b0:215:b9a7:5282 with SMTP id d9443c01a7336-218929c3a18mr2340805ad.26.1734037019285;
        Thu, 12 Dec 2024 12:56:59 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2162e53798asm94019785ad.60.2024.12.12.12.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 12:56:59 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 12 Dec 2024 12:56:54 -0800
Subject: [PATCH 1/3] RISC-V: KVM: Redirect instruction access fault trap to
 guest
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241212-kvm_guest_stat-v1-1-d1a6d0c862d5@rivosinc.com>
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
In-Reply-To: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>, Quan Zhou <zhouquan@iscas.ac.cn>
X-Mailer: b4 0.15-dev-13183

From: Quan Zhou <zhouquan@iscas.ac.cn>

The M-mode redirects an unhandled instruction access
fault trap back to S-mode when not delegating it to
VS-mode(hedeleg). However, KVM running in HS-mode
terminates the VS-mode software when back from M-mode.

The KVM should redirect the trap back to VS-mode, and
let VS-mode trap handler decide the next step.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/kvm/vcpu_exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index fa98e5c024b2..c9f8b2094554 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -187,6 +187,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case EXC_STORE_MISALIGNED:
 	case EXC_LOAD_ACCESS:
 	case EXC_STORE_ACCESS:
+	case EXC_INST_ACCESS:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
 			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
 			ret = 1;

-- 
2.34.1


