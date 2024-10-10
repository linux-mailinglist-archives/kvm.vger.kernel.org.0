Return-Path: <kvm+bounces-28525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1C59990E5
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19F66B27C13
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4600820695C;
	Thu, 10 Oct 2024 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0FbCESn6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AAB206050
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584797; cv=none; b=NMx9kh+hsVxvFv0OOJAEJ0df+mClyHKyz5NAYWq4mXjzbQTtlq8G4ROG6V5PtIPxllDga2g7xpAgBzm6lTb2TFFwLapRgHM6tJ4N4+FmZfKnezTdkYjPxJGRzWKNaEuj4xvN95nX9CBd9cvobaXtxwTqvAw5OSGrlAIpriFhO3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584797; c=relaxed/simple;
	bh=aOhxn0fpApYS19RFll+QfwBJLF7yF1QDDa2KZCpFRDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kf+/iTOTzVmg1C7le+O1q4QYig0spaNR1c4OP2v/5MsUVbjDBH5yqsalbJNpYsmU/kXeUJJ8wf+ZtD8SV+8nl4BCXw9IDi0pbt86WG5KnUDdS1Cb6pozbOgCBzCQoek0+PAwKGVoi7Li5d9RxdTAS68XaK60daKOoQO5aokkTrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0FbCESn6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e1fbe2a6b1so23282187b3.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584794; x=1729189594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BN+hsHae4h8wzhzshUJRGKM30XxzO0F311sC9z4rUGc=;
        b=0FbCESn6n9wvwnedhP6g2o0aQ3uGz7LbaDMietMd23Zpw5H+WqY+ubJNtwyvC9nEJv
         FWG1G2wSjqX+D1kLYEKQ0FHw8fShSQ9I1S4nI3dc82vP/efq88a1zYT1Twk5N0zf9ScQ
         /53A6MT01CFUmrfBGbUUJJnvgQCVHLryQ3ee2m4qzskSNjfHdhLhZsMphQs5+zcS9Thx
         dQDoRI6PZz3brGVXYophhSUWOYJnUXXzqTn7D+S/653MDkAwi1Meo569GoTGnQl8jyTd
         gG9Yppau1gFkgT2RyuAm8WpGDImvPtucCOwbYKUzjX6gz+sxcdjTnHuWB3tqJHMrzQma
         e97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584794; x=1729189594;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BN+hsHae4h8wzhzshUJRGKM30XxzO0F311sC9z4rUGc=;
        b=pjnvM/OjaLdPF/OtDxxslsiXiQuyItTdv9C2DoiW8GmHvt/xKQaAUfbZFe/U6gH5PJ
         wCLj80GnZB+gDeY3O7zRbctGPOUjKCU9sihYCsM1YT72AsRI+MfG5nsBS5Xvq7qcqieT
         mqtVBCyo0y0EIEknU3Wmy0fq4nF1Rxzxd0dD/MAwwc53QJkZ6PbSZDRiXSX1YR/5V3Pu
         hyxSHamuEq3cpZfCL64FwNvTrkjmQu4qOQ2QPnxt7WS81W31ownQs8OafpvI9M6w+L/Y
         LWh8Q1k1+fQ6NLMLIoeYpnJot2RufYb3edP99yizqdsYh+pbRwD5NqU+luBePIeOeR74
         QzgA==
X-Gm-Message-State: AOJu0YxVh2+RGf714TuMsjN8eVkQXa1XH9xoDArVwCnucNdTiGyyHYc9
	minfTdACignkluLi/AmJjcyNr2AOM35t8KT0loAHWjteoKqvvNyhNaeaiTar9aqmmKyQpJZ4fNU
	zRQ==
X-Google-Smtp-Source: AGHT+IEjw5s9ln5Mmco0bHKHDYNNIWwRc71SIREcZZABOz/fcRYPRAU5+BeNEqASF/uZrX6+QTap8C7eoHE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2c01:b0:6e2:3e17:1838 with SMTP id
 00721157ae682-6e3221407b0mr440167b3.1.1728584793806; Thu, 10 Oct 2024
 11:26:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:50 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-49-seanjc@google.com>
Subject: [PATCH v13 48/85] KVM: x86/mmu: Don't mark unused faultin pages as accessed
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

When finishing guest page faults, don't mark pages as accessed if KVM
is resuming the guest _without_ installing a mapping, i.e. if the page
isn't being used.  While it's possible that marking the page accessed
could avoid minor thrashing due to reclaiming a page that the guest is
about to access, it's far more likely that the gfn=3D>pfn mapping was
was invalidated, e.g. due a memslot change, or because the corresponding
VMA is being modified.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f9b7e3a7370f..e14b84d2f55b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4386,7 +4386,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu=
 *vcpu,
 	 * fault handler, and so KVM must (somewhat) speculatively mark the
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
-	if (!fault->map_writable || r =3D=3D RET_PF_RETRY)
+	if (r =3D=3D RET_PF_RETRY)
+		kvm_release_page_unused(fault->refcounted_page);
+	else if (!fault->map_writable)
 		kvm_release_page_clean(fault->refcounted_page);
 	else
 		kvm_release_page_dirty(fault->refcounted_page);
--=20
2.47.0.rc1.288.g06298d1525-goog


