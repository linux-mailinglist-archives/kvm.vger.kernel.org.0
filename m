Return-Path: <kvm+bounces-28557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D5E999143
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67063B283F0
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3A621A719;
	Thu, 10 Oct 2024 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TC4r7pK0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF8421A6E3
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584864; cv=none; b=DRa7/F1KPPK09mIhjIWebMF15i1u/RZUSvqa5BL/ZSwrNRl+dvtf86YVO5MXaAGlaAR8xa1Pm87huOh4u2nBCOeXZqA8Mza1u2KAlMeE3EfiY7H2IsYUNxXyrur1ONahiYihYzEIac1nhEtwRa9tixkAh0pEf+Mi/TIeMLVXM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584864; c=relaxed/simple;
	bh=Xp30Q5aCXuVbCuroW5D/p68jGCOUTPuU5mMuuixoyAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=puIlmGdGz8TejKviMl8c/ZAlzHZhOZ/dFXaf8XeQZOaHf/KbY8v10wXbWTW/1iMsyRk1PXWcnwzV6VlRg/x/slbt8p4NhsEDjFqIhPg4Iuxw2OqtRPH3bdR9YAyNrHhdJIazuDZFQFWVBRRgD+XAz6Fusfwb+enzvH30tA7+Fbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TC4r7pK0; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71dfeda9ac0so1340111b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584862; x=1729189662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A6YyPrl/aVt4zvDZFXUjzF/Zy9evtaTkH7tjbHPMI5E=;
        b=TC4r7pK0g3B0mqcPz8ZXxRS8Rw8BfJUEjGW4S/zxeQ0UkyLNagAVzGBjTNdiDb2SpF
         nBffEhUIrykBpiBbRrDSiRgwT5seeVZBDRzQyYetSIdUzr6J3plmmVwFPQ6RY8jHlo2a
         /bzTNyfYCg7FOcuV8L8aRSCfF0OxPZH0J98kU8yMIJP4RIJQCk+K5i6C+TXRFdGZ6eYI
         vpEeOfusRR2SHfTSTJqQIXxoxJLlil/pU/N0igi2UlS4qu3p4+hgRBxyMsiC7c3vwh79
         jWUX53zTsO2dJgzKEQNNHmt+hOKbbgUbybt44zCMmnLOdc8l2Lu5JrNAilAaQXl0kghC
         1L/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584862; x=1729189662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A6YyPrl/aVt4zvDZFXUjzF/Zy9evtaTkH7tjbHPMI5E=;
        b=TJeuyWRKhV9ZwoNAm6vxGzX9VfGMRw1oX16AuRjCE1H8R8fK4DQuiX0IIdkeKRDpyl
         +v/V48sgscezQxNUQTpiCQwPZKbnCymaYUZLAyR+9eB0Tv/JSZtgZ4CPOlTx2hFNiLbG
         dOCw83F/aLhbF1Hpjwbz2S75Q4SpQ/c4hpy7eDahZZSQmFjgI/JRkchSL5eOFIPZcwoO
         lJ7QznzbwHjhY01Iqsq/Ev5JJULPoDMmvy1LKoczFn74aoqSKgiLROnB9qA0ZBpdbFep
         8f0G+S4u6WOY3MKJjWLFZ+iIz73kDkw+jZLZQBNy9yv4//ty77THkn0NEadekhaDeqiY
         J6qA==
X-Gm-Message-State: AOJu0Yzi48ZsoVQpCKfS3YVpfpGgAc26NhSmi1KYscXJTJtAwtljqH4/
	rahrYtxRGDwVn+TqA7GXj/S4JFVi39h9HdHsljNATVBHHc3xmwNKyHqZJrS8x3VWR2VPL46WSKZ
	tSA==
X-Google-Smtp-Source: AGHT+IFRVsKTyvnlBUrQtNNg8zvYT0OU1qw5Av8a7Gq/P6vdrCxit4uLl8sEcLrSKXXTWA/vla3myJTtPpY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9443:b0:71d:ff10:7c4 with SMTP id
 d2e1a72fcca58-71e1dbd1d0fmr15196b3a.4.1728584861919; Thu, 10 Oct 2024
 11:27:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:22 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-81-seanjc@google.com>
Subject: [PATCH v13 80/85] KVM: s390: Use kvm_release_page_dirty() to unpin
 "struct page" memory
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

Use kvm_release_page_dirty() when unpinning guest pages, as the pfn was
retrieved via pin_guest_page(), i.e. is guaranteed to be backed by struct
page memory.  This will allow dropping kvm_release_pfn_dirty() and
friends.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/vsie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 763a070f5955..e1fdf83879cf 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -670,7 +670,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
 /* Unpins a page previously pinned via pin_guest_page, marking it as dirty. */
 static void unpin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t hpa)
 {
-	kvm_release_pfn_dirty(hpa >> PAGE_SHIFT);
+	kvm_release_page_dirty(pfn_to_page(hpa >> PAGE_SHIFT));
 	/* mark the page always as dirty for migration */
 	mark_page_dirty(kvm, gpa_to_gfn(gpa));
 }
-- 
2.47.0.rc1.288.g06298d1525-goog


