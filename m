Return-Path: <kvm+bounces-21588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 334BA930299
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 653691C20C76
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81211135A5B;
	Fri, 12 Jul 2024 23:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hG1bihRk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621F413C8EC
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828643; cv=none; b=Gy3CUbngZaHa/v+HITdYldJGpE4Rld3QBwD56Aov/PZZN27GkjB9o2t0Kn26qDp3P/+L2+DUeOKGviZaYOhxD2wxIiQu4dSR3bGyDc1kLBme4wq5jD3j+AtRoFpvsKzJDftd8Tn9Lqhpltt8GIKWfeoRa2lQcaEbRxzj8dEXl1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828643; c=relaxed/simple;
	bh=p11QpoRvsIKvJqP1fnQdOFZ4Tob+FZZ5L9KMK41U41o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sEBzcAOlP6q77fv3Wuuq2FMexIZn4gdRo/bHn6k3AX+g5VlFwSpdVCQYBfoXvDDrJBeU0tNu1LeTyz95RvMqigoEqciq7OLwFdLJjI8MGr4ffEqW8ezktl76F7inOoasMeMqCIP33AJr1zRE1Y9JAvwVu4IWiWN6TzeYGkDeUx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hG1bihRk; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fb168d630cso16365275ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720828642; x=1721433442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qiVWRvv1F8e3dUvL1Y2M8rT+xfhgXW0ORg8RyR//qdc=;
        b=hG1bihRkHZ41SeVCT3lSdohxgYdDELi/uQfrzmth5ZiVsZSqoN+zraECIc6j7JEVyL
         q5IyWiajFTU8QPcxfKmPw7s+kgf1WcHfrfvLUPycG6ilMdRswwW6auniFAOti2bQhX6q
         lVq88Tuyylkwql13eY1IpEhy6B/tB4yoqgnnWgO3Uu1IjORUMvEwxjfuNoyJZ6iN+xM1
         RNcHwWrf/44Dj1LUTaGX+ULL+iQLBpk/B/T709EYwIjxhdm2Mbe82xlBuJ45r7BTelZY
         0IdxTgMvisZBZDKmO/b0lIX4v02yFgVcmnoj4LXIGHSiimu5Nyf5q+syZr5wNrv4V0Wj
         fGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720828642; x=1721433442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qiVWRvv1F8e3dUvL1Y2M8rT+xfhgXW0ORg8RyR//qdc=;
        b=R/DE9KSGD+V/xr2dLhf6vFa4go+lBUJk529EstPK05HPwhtDQQo3+ovajuDo7RriLO
         H1f4FJhKSuOQ7O+BY2Tfm1ZENaANvZouzZQDZ8n6oms1zSxQRsRUXkL7dLgik6D0xX7Z
         Liq7FS3Zl6vdTEgGIcsfbZ9Gz5tKfRQMeIu9LhsBQZnJYTfu0s9YQiL+a1EFAblnpgTJ
         y0jL8rXSG7ZC9eOAkQ6pjR155FGp6e7YEYkQboj0Kw4s9S9m8VBYdGxU1BOihU6+100o
         S/pLc8GqAsdOBBdxtte2T4AzBwNVdi4UhWFK9QrFVrJK7yQWhqoAeSKzgyvt2GBkXTd5
         2lhQ==
X-Gm-Message-State: AOJu0Yzg5XSeBObSclrbMYyQFxnsO0MXLOWT1GYG+miGMUPr6j6Z0olJ
	O5hW6FrBlbheeTuLAPwvtjDpPPeWVBOMnb4ou4pyF8wsNHs4vpbix1ZErsONx/Cch0qBG8TZiMV
	RSg==
X-Google-Smtp-Source: AGHT+IHPGZpyXCcBFMuLXhSVmPz5d91R37FEN+a4UtSf2JWGbSD75qYm1YYZE9baRXQPgTH07m7NoTEPXyM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1109:b0:1fb:4b87:6ea4 with SMTP id
 d9443c01a7336-1fbb6cf0feemr6807315ad.6.1720828641744; Fri, 12 Jul 2024
 16:57:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 16:56:59 -0700
In-Reply-To: <20240712235701.1458888-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712235701.1458888-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712235701.1458888-10-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Another small pull request.  Embarrasingly, I'm pretty sure Google has been
carrying a patch to make the per-CPU allocation NUMA-aware for many years :-(

The following changes since commit c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.11

for you to fetch changes up to 704ec48fc2fbd4e41ec982662ad5bf1eee33eeb2:

  KVM: SVM: Use sev_es_host_save_area() helper when initializing tsc_aux (2024-06-28 08:53:00 -0700)

----------------------------------------------------------------
KVM SVM changes for 6.11

 - Make per-CPU save_area allocations NUMA-aware.

 - Force sev_es_host_save_area() to be inlined to avoid calling into an
   instrumentable function from noinstr code.

----------------------------------------------------------------
Li RongQing (3):
      KVM: SVM: remove useless input parameter in snp_safe_alloc_page
      KVM: SVM: not account memory allocation for per-CPU svm_data
      KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area

Sean Christopherson (2):
      KVM: SVM: Force sev_es_host_save_area() to be inlined (for noinstr usage)
      KVM: SVM: Use sev_es_host_save_area() helper when initializing tsc_aux

 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/sev.c    |  6 +++---
 arch/x86/kvm/svm/svm.c    | 23 ++++++++++-------------
 arch/x86/kvm/svm/svm.h    | 18 +++++++++++++++---
 4 files changed, 29 insertions(+), 20 deletions(-)

