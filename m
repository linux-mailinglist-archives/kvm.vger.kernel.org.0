Return-Path: <kvm+bounces-28530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 282A89990F4
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C016E287C97
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC2C207A15;
	Thu, 10 Oct 2024 18:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmtzsAHw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E53420720B
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584807; cv=none; b=qfblW+IqM8P8tbp7zw0T7NFB5t14M8tHQIMtVDQENUCGKFIsDIMT2nTQNqDErtVYlH28EkayoNmQqMyKyKXuJsGKFxueNWeiLE3tG3DwCxLDPT+Q0NDXLp1qiqc84SnhqFDjFcpFeUeiK0P6Tz3/2xJ7eg6d4RpJRZZ2pCAb7k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584807; c=relaxed/simple;
	bh=kbjwflG2kz8fn2XlGwl/ZUkp2MoQm+/BMH1MpANV1Tw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PoozIGhyILTkiuy8nnO48iY8oKzUalat0ee0Ld2gSQ2zm336JYakyRyRu4JkzCljzkohGV/mbdDjT7O0po8LtdB/ykf06DC6uezM1wUZlz5cocK3dyme5t3Hu44sDUJ2nq7DgPSiDjRbsbcheZfGUg2comGhcvEmjfZ9TCaruf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmtzsAHw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2d3d5fb4eso897525a91.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584805; x=1729189605; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RAEBOjiR86B8MKio5svj+gL/GJb0VtWq7ImNxArS0H8=;
        b=lmtzsAHwQyNwRvm4YycGayWTaD3mMWa0KP6qhPQcjm6Xns70mqWPYJS1kLd7s22LTY
         /T7yWx+i0180z3+0c870icqFaPkxG/5jw4mabTqo8QyB0EcckP0wh91y7Mr5DVDEcAvZ
         hQO7SxtZXgjJ+5PNG6GYQ8lhMuxPsiaTv7bKN0qEUlt9rMOH5ix6Gd6u/08WvrX8BdhV
         sxBtnyqiiR8igp8kOk/PVonv0d4Scqtx+EB6UWy3fO105xlv1kZig9jJkbcTPFSX83n6
         4g/v3dji6XZ61FVYO2EBHHk9ucMefuuWtbYJ3TSw4Isga9JWzpWIfkjpdmCzxAee0iT7
         Q0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584805; x=1729189605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RAEBOjiR86B8MKio5svj+gL/GJb0VtWq7ImNxArS0H8=;
        b=cWrAvGy8TQ357PeajtOg49U+ZzTSIwNjTYNNRPAQYrhEe+JM479OvPUuQML9juISnm
         +Z5ulE62TPp1dOYJSU1DfxoTtegUzGrYqLUdogq9LUEJs1M3VGm02FwhoxEsRv5aYoTq
         rziG4950uUiwoziGxWbpD+Z+9bKuDdwW+Q2TAaPwZeKlNxvrzfrTWRtkzfY767MlSdjh
         3ifFsQDqijUkILwdqGspOaLjgwPTR0VEeVy823Rockz/tp0GoTa09VfPon8d1s/Favb7
         hg9PRwr7BoMjIWUj7nIQCuRamvfrxC+ZLId496L9nhNxOBGZuc2a79cP+DwEdJQ863FM
         ADPw==
X-Gm-Message-State: AOJu0Yy1o1lvRtobVZWbc/kdWduk1UoN3V+J4LD0RVub4Jia5NhZeKGj
	pPtHqyywjtwZ5h8gFjGDXZZKU9NJXBP6mB65KZSHJ2VurucKlKBJ8YR/aC+GPSi47t+IpxesDnh
	m7g==
X-Google-Smtp-Source: AGHT+IH3g+or1uGKI8zaqA7g6VjAId1uToioip8sNGZo/KyXggeZoODfUOK1q5z450FXHERnWYgwR7EwX2I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5107:b0:2e2:ca3e:10fe with SMTP id
 98e67ed59e1d1-2e2f0f88a54mr24a91.8.1728584805241; Thu, 10 Oct 2024 11:26:45
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:55 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-54-seanjc@google.com>
Subject: [PATCH v13 53/85] KVM: PPC: e500: Mark "struct page" pfn accessed
 before dropping mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that shadow_map() can convert to kvm_release_faultin_page() without
tripping its lockdep assertion on mmu_lock being held.  Marking pages
accessed outside of mmu_lock is ok (not great, but safe), but marking
pages _dirty_ outside of mmu_lock can make filesystems unhappy.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 5c2adfd19e12..334dd96f8081 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -498,11 +498,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
-
 	/* Drop refcount on page, so that mmu notifiers can clear it */
 	kvm_release_pfn_clean(pfn);
-
+	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
 
-- 
2.47.0.rc1.288.g06298d1525-goog


