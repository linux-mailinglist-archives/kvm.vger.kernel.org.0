Return-Path: <kvm+bounces-28524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D23A99990E0
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D0101C25D72
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7989C205E3C;
	Thu, 10 Oct 2024 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a77PMqjI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53601205E0A
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584793; cv=none; b=IbD6xbt33/DbVzXm+vR460D8AqcOER3ghZculRHMfDDE1kRgC8dTQKg5OrtTVqfjCwvnjShkAWGPlHZwvJE1H3oy5XRAOxttp/wgsj+Ak2B8F6KZ8V0x84tcoHertw6GkDY2BtguigWxtFqParTsv+t4R1tF4YZrmHQyLh1XMRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584793; c=relaxed/simple;
	bh=P6yv0TC0koYnkFHtfd6W3SlzMlk4IripfIbi6+Lm/9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a2d/+odCzFeksHpyNQhqv38jZHmozDSH1rHR4NV+3KZlPbSrjx+Sgns7Eq4BV1FROU4Z+1T2GYv7djoFOfxgvAIJh1NL2Swcrw3ruKsTnQMe9nAotO2yaHdTpHtRPtSXex1OZh2kTlq4xTP/RkOHY+yPxNYN/d0dIrzGI4/Xe6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a77PMqjI; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e019ab268so1589286b3a.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584792; x=1729189592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4aL9ye2ZxrCnqTpLqQlinT65BUul16gfmDzid4NN5Y=;
        b=a77PMqjIq3vLWks/ShFXHpZbDnuBVQmai91zT69BbUwBg3+sNEzUevImv4vYPqB3SZ
         om8MeiFZmfuFyqTQa0KjSKJA9hlghMqeoCasv0rEqK8+1XvrBNkUsubtWjj9vD7aGzDK
         DWHK1/6pg+wg4oYoW9aC+R4ALvw4SAmWD1iz5nlxSjYqP9yc0vS3FrHLDcpYL5IfkSPZ
         ZjeNHX7Lj0IluQY7kzhgYqhHrmn/TxGtn+2w11P0tE/6zbCPcnROX6y1R0rOcOpCorWd
         xxlujfXtkPqmsR8pGzTSMnqlSfuQ2+mvEbtk+8vSE9cw0rUnXeF2Yz7zxJeQSu3EBkzH
         +QFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584792; x=1729189592;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l4aL9ye2ZxrCnqTpLqQlinT65BUul16gfmDzid4NN5Y=;
        b=lFuVE+bYrMWit3rCcPPRUmjwgsExC1TP7b01t9EpH0gZxugKrfQeykY71D484h2/55
         F6naiFVoWCpfm14CfVHnvEgRwrpg1uh5wdG1Qkf7stXETGoH5cL2glcrikT4rsPTDn53
         n+tC+PpW7TotFpXjYPNB16cvEvCMsshY6ydCSk6eqMrsLFHJze7kYV9IwXOjnh9mskdv
         5VhLA3h8dDhdG3aw9xcr0coRYWG4xN/iTX5dOzroD/IOgcdNQvQSaKT0yq348vVEzDO6
         JQ9usNnF1/xijt1ahosI3guZrut28BeSJ5Wj2/yNQei1sd1ffZiNXQhHKACE2y3AOasM
         vXiQ==
X-Gm-Message-State: AOJu0Yzr+MTT3aTSHLCMZBhr1lp6kKOdLfWGi0q0U1I5cEATGKgS0UGP
	1jfJgufLO82O0xxqU0xHE8tvxYbZNwgV74e8TFt4AoVtT793HQ3dQDtI1uAkKO2KocPx4bFdVvy
	8IA==
X-Google-Smtp-Source: AGHT+IFunsAHL0GYDEyxrwNnSExkBiXOv88aJkEgjVxw5ZDXOBsEr4Eha3ByEK4QIBQ4extfr7SnAz+Fl/s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:aa7:9184:0:b0:71d:f7c9:8cb3 with SMTP id
 d2e1a72fcca58-71e1dbf1ab5mr7799b3a.5.1728584790633; Thu, 10 Oct 2024 11:26:30
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:49 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-48-seanjc@google.com>
Subject: [PATCH v13 47/85] KVM: x86/mmu: Put refcounted pages instead of
 blindly releasing pfns
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
Content-Transfer-Encoding: quoted-printable

Now that all x86 page fault paths precisely track refcounted pages, use
Use kvm_page_fault.refcounted_page to put references to struct page memory
when finishing page faults.  This is a baby step towards eliminating
kvm_pfn_to_refcounted_page().

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a038cde74f0d..f9b7e3a7370f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4373,6 +4373,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu=
 *vcpu,
 	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
 			    r =3D=3D RET_PF_RETRY);
=20
+	if (!fault->refcounted_page)
+		return;
+
 	/*
 	 * If the page that KVM got from the *primary MMU* is writable, and KVM
 	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
@@ -4384,9 +4387,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu=
 *vcpu,
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
 	if (!fault->map_writable || r =3D=3D RET_PF_RETRY)
-		kvm_release_pfn_clean(fault->pfn);
+		kvm_release_page_clean(fault->refcounted_page);
 	else
-		kvm_release_pfn_dirty(fault->pfn);
+		kvm_release_page_dirty(fault->refcounted_page);
 }
=20
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
--=20
2.47.0.rc1.288.g06298d1525-goog


