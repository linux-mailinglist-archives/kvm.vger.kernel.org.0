Return-Path: <kvm+bounces-30210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3039B80DB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 18:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBA7282DA5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F81A1C579D;
	Thu, 31 Oct 2024 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zOEMREqJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5581BE87E
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730394403; cv=none; b=SgyPtqj0ZLjPhKscf3xjPpq16eo5Xi8bcxnmT91VbZ9/y6EL4sucrlWdqld3GZPWybvx9UNqO1rr8qmNhHJIKfuQZzWrF6ee5ihQg8+eR2cZ0QFKu+AIIPfMjBtFfvVN9dpKqjwY/b4Alhs2LZHWn9SQl5SHyCgTQ2DvqjONE94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730394403; c=relaxed/simple;
	bh=CF9GNWAqKmVnELilmfxXohKaud+5EZ3rcAojpZDvqys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cMy4cBSWGf+zzaoNemEhMMiwwwtqbJ4mYZDxAv3kslP45sDTfz03JMYUpCsnkg4TEY38cugBxSiOgbJFks5G0QNIXw0a7EFel+D/FZOvn028oYYGAMjnwXzxcBtsmPaosJ7EEwdRaL7865Ea72tD9l6vhTIWfqZOdm/XE+KINug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zOEMREqJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30ceaa5feeso1932143276.2
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 10:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730394401; x=1730999201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5mvSMrPyn0juvdY997mNRNyl5E1lyo12cgDG/LNUV4Q=;
        b=zOEMREqJhazgdbctpKNuHwfeHX1dIFH3dJ4GnBizcvRQGVHDCRndraNI2gwPd+L45W
         Tln524wSE3k9arg2/exxsSt+ETYzyCWXacidpTbBd2TkFlFFGLi/CrgYhJQzRnRq/ZtV
         lufNsckN92lOHIpSJbGoAXUd1poKo6583ldlxI+xKxsG9aLDyekEB0tB8k9Z98ConHlU
         H/1avGvS0ocL7ygv1VVMWPE98dVKZDcGQJxA/229PFv2ybe7IQbMfLUzH14d/vpf3iL1
         DONs280DRVWLIPuYBmW3RYOD9BWEWUFH69dO82C/LXtjEjag32+Aed08jDodZKO1Ujdf
         kGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730394401; x=1730999201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5mvSMrPyn0juvdY997mNRNyl5E1lyo12cgDG/LNUV4Q=;
        b=KRYnqXaCTq3HpTXVOa+KNHoO8sQdKa7svlf+JTyVv6gS2HOuLVnRXFAkQfmZkeeVIu
         TKJlWT44OLAbXPxBeuZGyq3W8qBV8YK/4XjOCMzOVMZW7JnyipkOk++mmqjFRhmxhkmR
         0RUpc7++ESe2fwTNvTvXxy3wTC7O84bdeSq2WNjO0RVsW73huC1VsAUAUiBRZ4G1bZUd
         h5f18CwRFYn3dczWdRY0SDGDohHUaZIpDuwZNCJVJUwjFiaNhj6AhTZ7wd+jqFqILdP1
         KDzGZa3OWpI6gyYP6jPEYPfUi4tHm/NrWqOnYNATyoot3/uwZmOClzbL4Ux7HeBAWRaH
         5ExQ==
X-Gm-Message-State: AOJu0YyiLtWRFW2juE1o5ypYqr5ts0Il8IfBn7jb4sOKQcYp1JsTP7CB
	UounsrUst04JxmTpoIb1qzjUoo22t5K4JeGmbYtJU+BWHe7XQd9i0eE9RZF5tjknK5tq1JWW/Zx
	aSw==
X-Google-Smtp-Source: AGHT+IHaNKkAsPzvMlrC7DsQB+BKEBKT51iYS8Lpz9uTMWn9JUZ5fiG1CamoxG8hwdIvdxbOzXOPUscKPTA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:b10e:0:b0:e30:d9d3:b87 with SMTP id
 3f1490d57ef6-e33026aa6c5mr845276.8.1730394400585; Thu, 31 Oct 2024 10:06:40
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 31 Oct 2024 10:06:33 -0700
In-Reply-To: <20241031170633.1502783-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241031170633.1502783-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241031170633.1502783-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Demote the WARN on yielded in
 xxx_cond_resched() to KVM_MMU_WARN_ON
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert the WARN in tdp_mmu_iter_cond_resched() that the iterator hasn't
already yielded to a KVM_MMU_WARN_ON() so the code is compiled out for
production kernels (assuming production kernels disable KVM_PROVE_MMU).

Checking for a needed reschedule is a hot path, and KVM sanity checks
iter->yielded in several other less-hot paths, i.e. the odds of KVM not
flagging that something went sideways are quite low.  Furthermore, the
odds of KVM not noticing *and* the WARN detecting something worth
investigating are even lower.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a06f3d5cb651..c158ef8c1a36 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -698,7 +698,7 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 							  struct tdp_iter *iter,
 							  bool flush, bool shared)
 {
-	WARN_ON_ONCE(iter->yielded);
+	KVM_MMU_WARN_ON(iter->yielded);
 
 	if (!need_resched() && !rwlock_needbreak(&kvm->mmu_lock))
 		return false;
-- 
2.47.0.163.g1226f6d8fa-goog


