Return-Path: <kvm+bounces-28255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE5C996F5C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C45041F22A29
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B501E1323;
	Wed,  9 Oct 2024 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U0P9BZ1x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D221E1025
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486309; cv=none; b=iat6w7+DCXNW7tC62xchBhWfQvnGrtxmvybCWjFG+zoPsLr+G3htLGElIgmUeHb2c3qNNRZeupfOvGdh2wleTEUOX701ilJx3jUAxXso2Ms0BpmKdPdUH6pYVFdcoLMedZttDX4QIwO9S2O5UAhyNR8A21X44euvy7zUspW9GD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486309; c=relaxed/simple;
	bh=kwo0uSuKY7476PfjqvG5TtQzMdHfogujCrHGNVPo1T8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TPxh3bO35+MIL5z7KYf+MpbK21TSuQM2nuC2U5tlZpVcLGEXrw8bWBg9kIqkjJOE2dbHZCrMsCnGPm1uwHJIqPCEq17I2JpfXSC77L/mFFuAnF3f62ut5dh4ktpICh+SGd36ZVAE0H+06QNsZphfE1iTau2HOV3Z+a4XODxMd+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U0P9BZ1x; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e24a31ad88aso7978829276.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728486307; x=1729091107; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MsHXMuXqSSPEjUvJamNyym976rxmSNlIq8VvuH3KZEA=;
        b=U0P9BZ1xLeGJyLYwRb95PMmrHSzDtIsaoRiL+/6xDhZRE0TMFdPdIDIB4Lxhl9qhc+
         Er1cb87wW0XA0YKMBwKumXOzBEF/LxqzjtdeeygxesSVYAw9f3Q2ql+ukcPE2gIw706j
         zTxkkYmrinXhnN/NL+Q8ueU6dYkB+kFWSZi99hsf1YtuIjy/WEzfIAu5hB+c/LTjDGGe
         R22avY7RwR+dM81cbPelK5zSeSiOZswjbgYmD2xtfyZsRTdyZWEgCZMQxEpf5BxHQtjq
         R5I+3G2k9LIA0PZsF/i0Va9EJj3cD2+y4udZabHCl17mojTCEuTrC/4iQ5RjjoT5HvYs
         Plpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486307; x=1729091107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MsHXMuXqSSPEjUvJamNyym976rxmSNlIq8VvuH3KZEA=;
        b=hwEWXJQG7IJTZO4BvajcbTm9xJ7QODFVqt2EEnP+92qeo3OLf/6aYUp42LT9RSAbHk
         f68x6Dkb8BUwFa8ww3+3G8+dhbFrvqT8f9ibpqZhZAn2XgSloRAcBZBPkPMORJ7xA6Pz
         ViihmSGknVqQKshpi/tN38eMiZlP2d34Pwe7xDf7oy6T1U9BXA9dx7uMDLDvaV1DrFvK
         18jqUQTnzSoW455j3J+hr1L9O2Ozs0db8wZ7WFkQLPp/Oxs+iyerI/2rdhnw7k17aRhY
         ooBrbLAWKnkom1DL8V00Qpq9yxQoQFHL38dATNBUkcG9AzkEvPlXP3kSPGL8CZAhJyGu
         cx4A==
X-Gm-Message-State: AOJu0YwnlJnyL+zg/OHgGhNEfXEGixeHXPoyVVBlpDxVwKwZcxi/0jY8
	vyni4aJUL2zTuVSU7VArvVf5mntV6RazEJL5M2rynG4cVcRIblJOytt5toTnuExnviJClV9kU+/
	2vQ==
X-Google-Smtp-Source: AGHT+IGRGVQGlUZhucVNLnR0VbMgf818PFYAsq4h2foZBXfftxDdMGYHMQR3T60F+hTMqx6ttjl2hkd9Yn8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:b205:0:b0:e27:3e6a:345 with SMTP id
 3f1490d57ef6-e28fe6935c6mr2016276.10.1728486307464; Wed, 09 Oct 2024 08:05:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:04:54 -0700
In-Reply-To: <20241009150455.1057573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009150455.1057573-6-seanjc@google.com>
Subject: [PATCH 5/6] KVM: Don't BUG() the kernel if xa_insert() fails with -EBUSY
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Sean Christopherson <seanjc@google.com>, 
	Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

WARN once instead of triggering a BUG if xa_insert() fails because it
encountered an existing entry.  While KVM guarantees there should be no
existing entry, there's no reason to BUG the kernel, as KVM needs to
gracefully handle failure anyways.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f081839521ef..ae216256ee9d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4284,7 +4284,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
 	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
 	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
-	BUG_ON(r == -EBUSY);
+	WARN_ON_ONCE(r == -EBUSY);
 	if (r)
 		goto unlock_vcpu_destroy;
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog


