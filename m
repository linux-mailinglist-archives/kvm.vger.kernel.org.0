Return-Path: <kvm+bounces-54157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09ED6B1CCE4
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0CFC16F459
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE102D4B5A;
	Wed,  6 Aug 2025 19:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jtkmJc9c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986E2D3746
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510279; cv=none; b=Ux2eWO/psnNuvtImsprTkR7C34D9y87FOxbvoyuyH0UXq8rpY3fqB09HsOQAegmHF6/Oym4FmIIgHX0yJEkFWMrt2+tlnCN9rJpqnOfbi4qMT8W3qU9UZrR+yMTEcIu5rHAr2u+hwZl55KyFL5o/IZr6JoUcI0ad23N2np29Pn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510279; c=relaxed/simple;
	bh=Wn/70g/zhO0dUDFH5wZEa7RcDliEFiv6OnJtKAjielc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MY/WiGXUvKnOFAM/XZgEy4oETSkIVwwQD8VvhU3So7GQInoknUVksjiYLUI0GPl/MJJ6FdUIkoTetU02UFCZfWcaNVU7DxBp/9PtegXN+Q9oR5MD+t7tfax7uCKhljH4Sx7YPqFniyXasWerbU+rSwuLUwsTM8Ug5XmZK+zExgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jtkmJc9c; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-240b9c0bddcso1712235ad.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510276; x=1755115076; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kcswufqwZeiVbOah5oR7VRWteUmksZlp7f05xG34s+k=;
        b=jtkmJc9cJ0fzxKszfmBkbNZX/tuaEHULFvmP05TZ18dN1rIKrRyrB5q7dtsBTrnONr
         UIp9is0G1CYORP6k0z1bb83xk5lmWUGBUFGLQjphTZlDLu4hmJroHvUDaK6STfruRInP
         y53fCsPu1TtFZS+20TDfjsYoxNaKyF3jNnqmNSYdf6gfKLylB04bUGqrbgRK8jQKz0YR
         Si0u74euyD1i0svnazPo8+LaJ++KvSw+3awEVvnFnG+Nykxkek8YK/WIZVDOTd0mJmid
         QIgIDq2RVp/hxU5RqkXeQFgV6Z6QXjeHyXkeq8b+fk3Jhk6CgoSI4cgunRPLS7fm2BKp
         OrZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510276; x=1755115076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kcswufqwZeiVbOah5oR7VRWteUmksZlp7f05xG34s+k=;
        b=YqnR4aFKvKqedFAGkVERYAle56kr05R6R5nrJdQru1fTceOBH+mgqMktpeCQ3mcfvQ
         W1kvRaI2CB99VJbyYOMe9BXfCx/mD9ov5CGR4Wm+G2h0JySWcBNbk3awD3eKc3zxLwB5
         IuHpyZ5y2DYewg+jv1BXO9inHaisoexKLGACHcuFirx2xDIyUJfJzbCaK7OC2NlwDttq
         n4GEtIL5RKoGnG9AZQDLfCsMrOZhypuB8jj7gQAmVPOFt+jK5zNOHhgFcDrAFzxHyBqx
         yMP6Pdb6/YwiwvVf1x6w5VOgO8b4BSvIbO8k05ygmseE3CyE2fTK31mWVP+dNRVBUg4l
         LZpQ==
X-Forwarded-Encrypted: i=1; AJvYcCW41f6bhuokyTiWJ8F5OEIl77VTVXFgUPEKlsDtBmJgFjiygsQ9Hp3lEfBANmwPbDkRc4g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5gZWTrHzhRvzcsLzc6r+gClQPosAuggN6hkEiBbXSjJ4Cx0pU
	JsiJC876ZMQmwSqHZAFPNlY7MLtIiYwA3pCywdkU7lbi7kS3WcZuBe33d8NSXjwjDcmjD5AtAxG
	ZPc8gwQ==
X-Google-Smtp-Source: AGHT+IE/UqkBVmIsYHo+3//+Db76eNFThoPapPb1lJatPNoq0GTt8I/qj7Zd+31YDzfBkj++w1pCOc8gls4=
X-Received: from pjbnd14.prod.google.com ([2002:a17:90b:4cce:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8e:b0:235:ef67:b5a0
 with SMTP id d9443c01a7336-242a0b3e6f7mr55163055ad.36.1754510276193; Wed, 06
 Aug 2025 12:57:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:37 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-16-seanjc@google.com>
Subject: [PATCH v5 15/44] KVM: SVM: Check pmu->version, not enable_pmu, when
 getting PMC MSRs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Gate access to PMC MSRs based on pmu->version, not on kvm->arch.enable_pmu,
to more accurately reflect KVM's behavior.  This is a glorified nop, as
pmu->version and pmu->nr_arch_gp_counters can only be non-zero if
amd_pmu_refresh() is reached, kvm_pmu_refresh() invokes amd_pmu_refresh()
if and only if kvm->arch.enable_pmu is true, and amd_pmu_refresh() forces
pmu->version to be 1 or 2.

I.e. the following holds true:

  !pmu->nr_arch_gp_counters || kvm->arch.enable_pmu == (pmu->version > 0)

and so the only way for amd_pmu_get_pmc() to return a non-NULL value is if
both kvm->arch.enable_pmu and pmu->version evaluate to true.

No real functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 288f7f2a46f2..7b8577f3c57a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -41,7 +41,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 	unsigned int idx;
 
-	if (!vcpu->kvm->arch.enable_pmu)
+	if (!pmu->version)
 		return NULL;
 
 	switch (msr) {
-- 
2.50.1.565.gc32cd1483b-goog


