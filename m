Return-Path: <kvm+bounces-28503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B590B99908D
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA64F1C24067
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595B31FA263;
	Thu, 10 Oct 2024 18:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="be7NmGNy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B6A1F9A8E
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584749; cv=none; b=Rz8c0fLIqLYtGzz6L167b4f3np9fDRwnsUDbytSnOWzJDdqMba7M6fPIRh0FW4SvnCMC5RbB8nh6Q9m9frDuCida61pSabzrN9GVfWsOgUoe3FykEvQFWnGQc0+RK9OoVG8RuKwBGeCptzWa2BBl/vIYJeEhTGv+aRdr3UdCNxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584749; c=relaxed/simple;
	bh=wQkcrwrrK4R8UDZylZK1jjbxKHOYfzFAR77NBuuXUsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+vssBwMNzvTFAwA8dcRQZTJMGHu994MUUuNOk7zMOrDXwUQm89xRO9Ges+a9FTYJj91WBSV/RSoXwKoNvf4OIiOR5OsmyJKGWVhBM+W+fjy4e41oKtvH7qRoX+I+mCmABOGgBGSM4bsIjKXXgndG5qq6JuXa0RnolCNmRkdv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=be7NmGNy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e148d4550bso1322250a91.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584747; x=1729189547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/W6JK9yAcorM7mqEFQq2hRBqvFCoz2C4pz3yOEmiGek=;
        b=be7NmGNypoYKlIQHzeI5qmlCcUnBhnj66Rq1h3NtOxbOPwC+w2QWEewadPkTALHHw3
         xPJKAp195KEPkglLi++7I4Q8+YOmOUjNKY8vER3KsZeeMIagBJvsGt5Pobsm74JYsbU6
         LTrXc4Yk9chzFDVCyczjOYxiAQl3ChwlolnTSQxMAaBK84r8sAvRfe70ej1wxuwkkAso
         K642YYl0QtppHrwBVSCdBwaujah/UYJ3uFn3uGnTv6BDtvRNYAJCNnt+vptRV4XD1YyB
         zB9Nu1ry3UFXALvaKzFf8mG173wYfV1cR9LVTLoNYadPVMufgcCdJQL3tQsG1XncstE1
         EjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584747; x=1729189547;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/W6JK9yAcorM7mqEFQq2hRBqvFCoz2C4pz3yOEmiGek=;
        b=BANhBPUHJEu1sCSkAaLwr6/O/ihHB2ixbGosTcz7JHjk9cDa5qWSwgBkd/kiGU0So0
         k9HReFyYlnjJ8WJoyeQB+Kl1Xmpj0A+XrQiEPy9jQ8LGIOLKrILJH8LE/fGhiC2IblaQ
         bZijPQgAra2w6gSRVQoFgM4Ym+u7zAMuVhjuNyUEfCI5cpzmAvG7dq1aaUyinGJ7qGuY
         BYl5OIfHrUaBGwFg/SZg9zPmH6WWQya2SJyuwTkRV/LAO9rekdA+DdLxCgK+7ZwN00cQ
         BCiwxEACSEhlrNFRmYGQmIUTFpHavxCPiV4nGve/J/hjyKPL7IHB3tYrPIWRioFAj4Hf
         w6+w==
X-Gm-Message-State: AOJu0YzEGWZDKbMsERgrr0XCACc3hpE2ac6tCgbeMYFR+bSVPK0sPxPQ
	BnHtMzMti0dxqZIHwoWu0nn57Z9aSxildJ5zFe02+mPubzVhi877rAX4gqfjDDEvvIESTd+Y5n5
	NhA==
X-Google-Smtp-Source: AGHT+IFGWHaFUEsQRxn4rcRWabj8vzxqpLHdNOXqOmiiQlX4dD6MZqF5BpShV2hVfQIOX/PTyNMVtEMSya8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9a94:b0:2e2:da81:40c1 with SMTP id
 98e67ed59e1d1-2e2f09f2280mr109a91.1.1728584746508; Thu, 10 Oct 2024 11:25:46
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:28 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-27-seanjc@google.com>
Subject: [PATCH v13 26/85] KVM: Use plain "struct page" pointer instead of
 single-entry array
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

Use a single pointer instead of a single-entry array for the struct page
pointer in hva_to_pfn_fast().  Using an array makes the code unnecessarily
annoying to read and update.

No functional change intended.

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7acb1a8af2e4..d3e48fcc4fb0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2752,7 +2752,7 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcp=
u *vcpu, gfn_t gfn, bool *w
  */
 static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 {
-	struct page *page[1];
+	struct page *page;
=20
 	/*
 	 * Fast pin a writable pfn only if it is a write fault request
@@ -2762,8 +2762,8 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *kf=
p, kvm_pfn_t *pfn)
 	if (!((kfp->flags & FOLL_WRITE) || kfp->map_writable))
 		return false;
=20
-	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, page)) {
-		*pfn =3D page_to_pfn(page[0]);
+	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page)) {
+		*pfn =3D page_to_pfn(page);
 		if (kfp->map_writable)
 			*kfp->map_writable =3D true;
 		return true;
--=20
2.47.0.rc1.288.g06298d1525-goog


