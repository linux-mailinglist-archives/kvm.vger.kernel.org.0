Return-Path: <kvm+bounces-28270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D730C9970CB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:14:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E827B251B9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15501204F83;
	Wed,  9 Oct 2024 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="knLE5FfQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1176204F68
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489021; cv=none; b=kryaINKvHmBWoWpsKnoTDSurLyvRXas6cM8Exm+b9QqLJH7u9/QOiXJq1SEaAfA5P1UytuIEmM+cKGprF4NVr4kdau9RNkU272FGnUP2zwIbuFJZNVuv1oS252QuMfiioChrzDed0+ovpgvuoTpiIKxaj7IqUX6Ap1w0Cm1C8VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489021; c=relaxed/simple;
	bh=ySYmz6+XDdTBZKIHQpIWEkeL65GnrCL3nDWRuqk8AHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HUv9Ln6oiXUHPSS+CTIsFZEVqtc5bSNNQ3CMbLBMgk+xqhsXXiLiq/vFR/29C7chRjpf2AuCKuJt0T1CISc3Sq9iTcJuerqrKg/8h25+cE4cVAuHfFSRHDPJbnY4VPv8m1QFSudd/pFx/6c5D10JLym3782XoFs0lX7327zblSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=knLE5FfQ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2903a1cfe3so877516276.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489019; x=1729093819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IpGlLPpdKIlhRCfJQtftwzWlWOxZ3g0ZRZhoTsEcT4I=;
        b=knLE5FfQmeSTB7xMcSplj1mP74VJ5UFP8UfVhbVUJ8rBuIBMXJj3WqSuOX3HoVtZvE
         B0WFiRXWtzZ96ejyKsV9QtaDO1upWXTsXDangHzQDFDQWbNdfs1UVkIcuvBZEn7U8uZ7
         O1p5UEhXn/QCXdYPYNG0hYq0iSwgCXL8JwvDQ/FgvWCK9Etz6xlaS7NbXos4hf6gepew
         E1dUStsKLx2pt+D4WsXAxycW0IghnAR7tOxHIPWw76FzW6UwJMOCQfVqlGzYIpAwOGEI
         qJcfS5lRwCuLRLJorEfQMS00IsqfCkCrQaH5DhU0Exchs7U7cP/kfpJnG4fJJpnmHPe5
         bEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489019; x=1729093819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IpGlLPpdKIlhRCfJQtftwzWlWOxZ3g0ZRZhoTsEcT4I=;
        b=mAC2CRUKWnPlm/lLFV5n4HjqQdXbr+7hHwTPHeJ9H49eX/4hkZN4gGGEjl6Kxtw9X3
         0C89bzQ5cUMfI7IU957us/T8ZOiIB8tCwEAyGmFqJxxEr9VcTwt2XYuvrIbOX5qcyNUj
         BfOd9N/xpQx1gF2v3F/irWpP5m7iJY49G2PHxNIKFtoPGK5vrR7uENT/8qZyIRSfugEj
         JDHcPAye9NrNlK9JTBGG/bEy7ppvrjikjTToNAwub1Kcli993i64Ggkg6Go8TKWyLA2J
         z56jjG53Pl3VjVthy999H8quoilK8yEzjkVY0GyHZdD7OnBJH3V3NtM2j2UbGFCZWgt0
         0sbg==
X-Forwarded-Encrypted: i=1; AJvYcCXxef+NBWCZDENzPT3htQXky2vuy/x7/o83FOtNArzKqvXndt39COC3auTK365HiMbmJnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY97P8nh/uWasQBq/ZQxAlmFKRRVz7xhawE54+9c2eB9vFAUiy
	wFDArCLXiegfbG7Ht37bqHExG3CDnkNqBnFTuYwugBg9HLzb2ztdF8uRbr24HZdNjZNPbkqvQxB
	NCw==
X-Google-Smtp-Source: AGHT+IHJrTSljEGX+w+vGWljsF6J67uTWXS92qMmyHsTMzVm3HG9JVjkOOVhTNIgejhJpa5nZzlmmTlBPQo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8248:0:b0:e28:e97f:5397 with SMTP id
 3f1490d57ef6-e290b7ec5bdmr51276.3.1728489018761; Wed, 09 Oct 2024 08:50:18
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:50 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-12-seanjc@google.com>
Subject: [PATCH v3 11/14] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_arch_put_guest() to write memory from the guest in
mmu_stress_test as an easy way to provide a bit of extra coverage.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index fbb693428a82..656a837c7f49 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -23,7 +23,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
 	for (;;) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-			*((volatile uint64_t *)gpa) = gpa;
+			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 		GUEST_SYNC(0);
 	}
 }
-- 
2.47.0.rc0.187.ge670bccf7e-goog


