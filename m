Return-Path: <kvm+bounces-53490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1CBB12683
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9576EAC2E39
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0E3256C9E;
	Fri, 25 Jul 2025 22:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BOXRQLeE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B19265CC5
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481259; cv=none; b=UCBb2N2G/CgB4u6p/pfstuHxXyIE6EaZ7aTa83HC1v7t7DINtBJyYLlT7M9Rrbquzc9FijcD64ogjmyyH3U/o31lv03CyKtEBNM2Zfy58ZiCgbwAeKBoy5eOd+nAaiJEf7RJ+mxJj1oXMIOq7tESurifgYbN87THxvHs/qiaku8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481259; c=relaxed/simple;
	bh=0UH4VkKrDC9UB/t1TnPQVbCtT3g+g1vXCvgQpjpsK/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TTtTuzqiMVjvCOZsqaCREXLuKPyBTukY6AgwTqLDzsJK1fv1K9htr4yUBqygEN0C722jeZlMnIOhG2TEI41WaqIqA6zIo9ajX8DdK2l+Da9mZ7igsDo/xcvIpIEx0Ce+ECRNRjm+wSlUltylPlQh44+1ckAtBJ7YgX8ifHWJf28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BOXRQLeE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so3826513a91.2
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481257; x=1754086057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f2L1vSpr+9w5ouvEQyTcFk4kS0JZwfay2+mRwTwMIAs=;
        b=BOXRQLeEByIkLIo3ed4jRcY8edj5Fy7jtRdcKh2yfZN3uQPrMRPlEGcNdToUXkKpgC
         amz7pIfIEaYs/CCQPWsLCZ9QCxA5DBG/aff3h3xSE/qjOJhY5NG5J0wLdsIGNTXrP/kt
         gxrY8Us0dbjXYTS4pKsoFqzq+RQeJE8rbq3SgzF8rAnWMu4RDoG4Y81yowkY56orNuok
         72OWo1bpiQ49/AYdCWqVPgKTI+cYkMlIGSvcGEy8LbA0XVUEXkchgWhgjyHOX0nog2Kr
         n3VPf+3ZFLVT5emQh7gHtuSHA2gQOcNA7P4SPJowLKwf7sGyxts4j0JamXiODSkRk0hg
         bvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481257; x=1754086057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f2L1vSpr+9w5ouvEQyTcFk4kS0JZwfay2+mRwTwMIAs=;
        b=E35GWVGK0qQHBzWpVh5KgMy5RZshLfk+LRlBVjjx/X/1/xgB+Duw9LOVG5jk8VtKk4
         gizYJWQ0x620nOPkj0L7743crvh7eS7ftXksTSLY1pSwa+AlXk0XgwitPmB/6311FlpA
         UwHd6V6+Y8TbZgANzC5u4UMA5M+FWY5BKS9jIXdVLs4ZrmhDJPz+JC0SObgd4vV+M7+6
         TMZVT7tG/sBifvVGVl7bOMTGmo6roBu1c5BsB+H308OFnjaVlNOouDYT1KXQ+BllkMuK
         ABM0ttEc8kDpTqWbhxVOFWGNT6MTuEZIFBr/oIX2Nc6EOCQMdiFpI4I+tkKuqXQLk+H8
         rG5Q==
X-Gm-Message-State: AOJu0YwZT5S1WelGH/wkTphwjGg0DO+m2ihsQYiGMbB3zmQ8dKL4bF/G
	f7rUzrHcNPntibHXO429jgv8XVbK035SxL+laHUWpjwvjCwx+PzNEYbZ07TFE4SHDF6KyZnt9JI
	HX6jgfg==
X-Google-Smtp-Source: AGHT+IF7r7mSKn3M9/Oer2KwMeQLBiHU2lav83H+dXtW2+/ed+X53dVQlcF9d3N6vPTXWsBeFfjy9eT1Fd0=
X-Received: from pjbnc3.prod.google.com ([2002:a17:90b:37c3:b0:312:1dae:6bf0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f86:b0:311:a314:c2ca
 with SMTP id 98e67ed59e1d1-31e77a0a902mr5294070a91.6.1753481257081; Fri, 25
 Jul 2025 15:07:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:11 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-12-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Two small SNP changes.  I initially balked at completely dropping KVM's checks,
but I can't think of any way this will cause ABI problems, and I also don't see
how having KVM perform checks would add value in any way.  So here they are :-)

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.17

for you to fetch changes up to 24be2b7956a545945fcb560d42e3ea86406dba09:

  KVM: SVM: Allow SNP guest policy to specify SINGLE_SOCKET (2025-06-20 13:33:45 -0700)

----------------------------------------------------------------
KVM SVM changes for 6.17

Drop KVM's rejection of SNP's SMT and single-socket policy restrictions, and
instead rely on firmware to verify that the policy can actually be supported.
Don't bother checking that requested policy(s) can actually be satisfied, as
an incompatible policy doesn't put the kernel at risk in any way, and providing
guarantees with respect to the physical topology is outside of KVM's purview.

----------------------------------------------------------------
Tom Lendacky (2):
      KVM: SVM: Allow SNP guest policy disallow running with SMT enabled
      KVM: SVM: Allow SNP guest policy to specify SINGLE_SOCKET

 arch/x86/kvm/svm/sev.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

