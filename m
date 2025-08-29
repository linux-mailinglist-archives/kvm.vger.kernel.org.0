Return-Path: <kvm+bounces-56320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7B5B3BE73
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63D8AB625E2
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34DE9320CD3;
	Fri, 29 Aug 2025 14:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="BU22s7FE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17556320CA4
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478496; cv=none; b=Y1wxis7hztwnMRzWgJ5ym6M8ELoxsaxCDYM28Ojwnx790HSOSlZT8u3uKN6ZXX8Ot9Qm74BrEYDg2dZABb7aq6XxneeysbkXO6zjmekuaoMAf7cBEijFXjhhZhljBAin7a1hVzyYHkeKeBUKA9gvwDgo27XvxEBphWwOjbE0aoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478496; c=relaxed/simple;
	bh=XThoAUpZFHs1s+pwrFwO14HP8Izu5U/x/smPnCa25bQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VL9759Ph4+KQhrig7s0hwMQkxGTIIFG5c47yH0OsC3W3lTF4hsVp8qFSzPShbNVnsdZyNtViZv4NzkzLgBXPWaGtWMvGGBUhHSG1WEfNZszChlM2/p+MKzGk2MGODQcteci9Gan00KFP9g3obOBVJ6ILcgXkgWpmzEQ6dgfNNeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=BU22s7FE; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-771f90a45easo1854405b3a.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478494; x=1757083294; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WRvT6lW8SE24T6disqBtYa/lDa3Uh1O4/DOC6STqtSc=;
        b=BU22s7FEZ2elNh4IC6pB2iR8YesCFXFyg/77n/O4XJUbuT5uVkVQ383jSOit3CZcFp
         +0bKv2dz/iLzvM1u9wN3D8/4BGnVkO1GizExk90XHJefCpJMDfuMcuNIUCaW0pXwPKI5
         EqXK/ufm6cHe6f+It0ZDeDdD8Lvlt2LqtbuMN3b+DVLQrRVeVW/r/eozQ1rVc/qcUHGE
         krZFEqwKnIilPdu+7eSuE3/9HBcKAEvFmKWqebJek0+QXs5IEpOJnBCXzq8ZxuyqcQ+r
         z3OR761ylADj4I3ilY8sk2HdeIEMCsznjzZfPP8j3CKVm0pVxZZp6yUrElanG3ai3xE2
         ehQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478494; x=1757083294;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WRvT6lW8SE24T6disqBtYa/lDa3Uh1O4/DOC6STqtSc=;
        b=mGJr1wtnz877a4mewbWih1v+UUVrdsGBgiUbPToQbfYZHi501uBm0rYam/1+lp0XNJ
         io3o285uUxsNdSv6Eu9kv/ZNxgyNI78nzfqH9+zTYkBiLeJg6ZrmVFmmcB/QhMy53PLz
         CSE1jAogdK6Yk2VfBG1P6NjXgbo2iyYPCBc5VqkNe0uX7Q1eH5JGNv+cMDC2T7gvutBV
         JZdtsdEVXRX0S3BykyjZ/n/SUu2hkh25Hj3EMG0kq9A43Et0y1c5kn1DEQvjCz5FNzbm
         oCVPxtivhuJRDm3+7iGFju9jWY+r1jg1YDsl1kSkc65fpPi/93EB+eYKP1s89bIUlBGV
         SnVw==
X-Forwarded-Encrypted: i=1; AJvYcCUP6ukVkqwuveA0FpFoNXwKl1pbyd5ynV2uSdmNtXXckqyFnRAEhcBgWBO8KoDCYNH1WTY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLB3h29ie2kLg20xYm8uJLqbRVu7zz9nrz+WRVAqS5vT/wZWTm
	h/eEebGTa56XT/O0vuqZoBynTEI6fi1PCwhVo5PfQXuKvtXkOXG5S3pCulSOvEqmGUhjVI8wrqw
	dTfuE
X-Gm-Gg: ASbGncu2T0Y6PlJflwXGRHGbljuRu9kOZ54OUNAFlsd+RqwSId4MbAf2RWjZdrhzseR
	llkwZs5+3S/8rXobwtSnVebnVGW6jjfZBZIgoHQa9SBwsiOLAiM7W8rkocatE4v8PYW6ap1S9Dw
	eIxFSv+pdx62Rhchvfey8WPjdzs4TIex80WjmHmOqvWutMHtICG3xAk+rA+mKl1xiFnsWUi5iLk
	72O2zhXICfS2BINKjIHTxrYra5qsbjoUQQ21Ym8s78xs54baBLwsaUUA9nVtHB1K4cOUv0cZpDs
	bjo5Gb2pCl3tZP88W5ywf0RkvYHhDYAB8UtPXjMjnbRNLn+XKARD6OM+U0SmVKrHP2L0vyzlRGK
	k0WpbIxevriWbRcnTAVY6yd4DlmqX7QHjBreWviPXYBRt+w==
X-Google-Smtp-Source: AGHT+IFDBhv3MLTcxgH+II4bHiTtnlUQ3Qi3MwL3+YWiPJW3Bh7QRSHoNEvUKcz9tZC69e4QqkawWQ==
X-Received: by 2002:a05:6a00:9a5:b0:770:374c:6c55 with SMTP id d2e1a72fcca58-770374c6e1amr32573308b3a.31.1756478490940;
        Fri, 29 Aug 2025 07:41:30 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:23 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:10 -0700
Subject: [PATCH v5 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-9-9dca26139a33@rivosinc.com>
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
In-Reply-To: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-50721

Upgrade the SBI version to v3.0 so that corresponding features
can be enabled in the guest.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index d678fd7e5973..f9c350ab84d9 100644
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


