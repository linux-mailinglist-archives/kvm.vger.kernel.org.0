Return-Path: <kvm+bounces-11825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A79A487C439
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3803CB21534
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72CC976056;
	Thu, 14 Mar 2024 20:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1EkErgJt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F274A71741
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447825; cv=none; b=If6HXahBJgpVdWotO5JOqofQOzyKZb6NyKVGhDJozf8UHe2vn3jHvB+DZaL1TDqMrwf/Xf74vbBneiTnhFuRl2R83IhpykyCDg2Y3nG4tPWDiuD0qM4jBzuoMyNPQ20xwhMnEfOSwaqPsy8aUkZyVjRuXmBOMc2AuG3DxYUStGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447825; c=relaxed/simple;
	bh=/g/HcoEQQBJkRAL4ZwbS8omMCk85N2nyfxKtjk668ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQ+3ENWdvbeIJwPoY9a/9HaXVO9YZO+FnTPt9QBZNMtbIQEztxfaffCWR1xsEsI7usgxXhmOPNj8GRRTIZTz/T7qlXcd/nvVYUXag1WpAnsjA3pCIRLbkrqPbKyTI2vzz1o61gcQx8d3+Ozfck9sw21m4KXOp9VlNKQdPq8WzDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1EkErgJt; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d475b6609eso17445011fa.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447822; x=1711052622; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bhfRLCv5E8LczXhWX76XPlZKS4T8I7qgV0XO4dVuEZg=;
        b=1EkErgJtjpSjxkJR61YW7Hh5oWZkQImO+q1fy+cHh3S305YVpA0saVmsU3Fpb1xSxi
         2r4rm3Y3vrmutcNcEqq7ejeJCMQkQHjzZTD5LhR9OOUbnCBQEWznmjguTXdWIJc8w4+x
         Tf3cdgO4KZhqgqlgggREuoyMf7RCLbouuUHCJCCdeMTQ9Gz6YZhgN5Uvpgb0o323JEnv
         u02ZjtWJLfpQQ/6/SpvWQZd0DAWX8IcpZWLTfV7U87Eau6gr6xdLSDFGVIEEmmyAyHs3
         1+G52IoDNyl2SuDs+CZZ6/U4YAwVl8FJHlk1gqErcJfc3rFVkSspopsXtxYxp+dD8Zcd
         f7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447822; x=1711052622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhfRLCv5E8LczXhWX76XPlZKS4T8I7qgV0XO4dVuEZg=;
        b=a/9f/ffoN6i4Do5gRfIi+OM2yEfrzZ6DPfuLVBM4Y5x7Mip+rUpRT1dsWZmRalp7tY
         p/VoOfGveMftMDpJqy7ZWNMu0HJCE7lFxtgX41zCxl58gYnfAxU2bOjJCrxv/5xvfNms
         seibibWnqDbEKKogk6JmY9mJtjRougwr4F6eJvkP4k+dx7x+zzJb0egFhaltOdJTS2vN
         VXeNnY4KQl9Yr/NyYaXxRQtxNvWYxwNKaWabXUT/7DCqpVTURqmcWzs04bUrBsjeiq8T
         BU630MzWZuUBPgvpyRkaAB2Q0pbbrniz9kVj71YoZQM3jNBSWEI7xzmtTf8rPrkWQ2OG
         doFw==
X-Forwarded-Encrypted: i=1; AJvYcCUZGu6o3wZyrjSCoaDbTaIyx+sSB47iYktn+Gb+aqgMPTSwBDzycuw+dxlBj63eVZ3Uw88dVJiklK4soY9Po8ngSHaz
X-Gm-Message-State: AOJu0YyMlq5dGqytUCybPRXkMGtlrlrKYynVjkNlOSqsAW/HGTseUM9U
	fUqJpg+eSGjns0UtN8tbIGuB+vjOPhAHDuPqb2ohp7a4dUPyHeznUVYIdXpACg==
X-Google-Smtp-Source: AGHT+IFKN6Q76VRunakd62YijaomXD5YfYUy4KHbzgcm8HAUJxkFpfyEXSR19suk+AGp/vhNuREp1g==
X-Received: by 2002:a05:6512:52f:b0:513:ba0d:c2fa with SMTP id o15-20020a056512052f00b00513ba0dc2famr1938984lfc.54.1710447821974;
        Thu, 14 Mar 2024 13:23:41 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id v15-20020a1709063bcf00b00a46454a7e24sm1007519ejf.71.2024.03.14.13.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:23:41 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:23:37 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Subject: [PATCH 02/10] KVM: arm64: Fix __pkvm_init_switch_pgd C signature
Message-ID: <cd18b1eb89dc91230692e0534bd4e338b91b6867.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Update the function declaration to match the asm implementation.

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 145ce73fc16c..7a0082496d4a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bc58d1b515af..bcaeb0fafd2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt = hyp_phys_to_virt(phys);
-	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
 
 	BUG_ON(kvm_check_pvm_sysreg_table());

-- 
Pierre

