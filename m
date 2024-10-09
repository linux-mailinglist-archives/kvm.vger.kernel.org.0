Return-Path: <kvm+bounces-28256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A064996F60
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:14:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB7391F216BF
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E541E1A25;
	Wed,  9 Oct 2024 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yJ7oY2sW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7641E105C
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486311; cv=none; b=uLm5m9vy9MALd864b6tmnEFu/Dh5/8rxQdeG589nXsRzoWlkBwTEUtqGHmvWr7m5YZF0dCcxY0ENbPPReXxhIgey+ZxDtxw8gVVx3BJBYruZU/Us/lNLPIoeWXHrbKexf9j6rVKdqmmBv5/G/RP+Hr2N4fz78djDOjxMzw09Bo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486311; c=relaxed/simple;
	bh=ak9GgtEL5YTd9uZb24jF2orHXaja+Om0+voynGktgcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HSs0bnGWNCR9AmlJndFEWDozhNhpi8hinSaYBE8OGSSWRv/8xpYQW8yC7mgJArIgiXHSxpgPrYomlXk6Lrrwdi0j8D+5N9I4YlByjxU+FqRNagsgoVY6M4FNODwviV/p9qRO8JTpNSRUNAhX9tL4/fBl5nRW+nbzEMsF9uL+ZYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yJ7oY2sW; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7e9a3e3ec4fso5285575a12.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728486309; x=1729091109; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Rk7120SY/ZXFV3eahCprGvAPNvey5dvtQWWwk6TE9OY=;
        b=yJ7oY2sWGvj6azg9FXzdMfs7r8z2p3Nnj8IEh8PmelCuggwnetM8dKORAnrkRW7C+O
         4ZFBcpRdCeOmAHSVhNtFovgUvMA7j8DRCkQETMhlyjdzCsgjS89R023+LTJ1DS3gfbL6
         3OWB94j2wXPnjegXrF35VuFuB1Fe6BhXjzLduiOBto63bFDjoZ5x4Now1w18VxcCrJKb
         bn14yvdy0j3TsHzn13KXMfMe6Jo5HoVjKpqNA5T/cu/zQJBg6EgzWCO30aIWqWd7Mhec
         P4cX/1wDQNYWij3kXWvVJmoAGT8cpOFj+1FyRnVNqz7faZM61IDkOtQwasxaJ3IY7MnR
         qGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486309; x=1729091109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rk7120SY/ZXFV3eahCprGvAPNvey5dvtQWWwk6TE9OY=;
        b=dUk4E+yoJmTGGkxFqldeF+72TMnm1Dv+BOUSosB8jYUsDZlUQbHqxdZf40X4FCTf9l
         O4QvKs3/8XB6d85PNcXhNeqFHoW6c9mvpA6KE2U1AX7sQXvgrHtyOM4WA7tWoXHoiqoE
         pEz26h8E2kl17D21lbrK/IovUnoha7MSRUlrzUhyvnapiWmdJ8NIxsmIzk6BicGfgDjs
         X6T5V8QJhzpqeAwrNoP0y1vseW+s+jJuydxVi6n1NYxLVfJxnx+5hJm4/RxGht7JpLhl
         /5I3vKpC69o+OSdJZ5ghLrfTPDN3nF6foHpU189yRSVw2UqBJfCTXXdm+CSm0Km2iNdA
         7DBw==
X-Gm-Message-State: AOJu0YyUJHi9tpUfQ4iQc/SNmqEUwre3DTDhlbxRc0uI8DQefY4NWCqx
	B2Fc0sPBMKJPMEciGOu1Ylb5yU8UJs1ecbTvevbVEG2meCoP0esJID6wKfDS1O4K9vZP08aOgNZ
	+JQ==
X-Google-Smtp-Source: AGHT+IFu77cfGVVA2WGcrcN5nHTM+fZs3XRvNPGo5S0nSGXPoQt6AXHZRLCBGgSJNwiABPBpygvF2QiDHAc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:1401:0:b0:7db:1a9c:d850 with SMTP id
 41be03b00d2f7-7ea3207ceedmr3010a12.1.1728486309256; Wed, 09 Oct 2024 08:05:09
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:04:55 -0700
In-Reply-To: <20241009150455.1057573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009150455.1057573-7-seanjc@google.com>
Subject: [PATCH 6/6] KVM: Drop hack that "manually" informs lockdep of
 kvm->lock vs. vcpu->mutex
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Sean Christopherson <seanjc@google.com>, 
	Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Now that KVM takes vcpu->mutex inside kvm->lock when creating a vCPU, drop
the hack to manually inform lockdep of the kvm->lock => vcpu->mutex
ordering.

This effectively reverts commit 42a90008f890 ("KVM: Ensure lockdep knows
about kvm->lock vs. vcpu->mutex ordering rule").

Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ae216256ee9d..2dd3ff8764da 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4271,12 +4271,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
 	mutex_lock(&kvm->lock);
 
-#ifdef CONFIG_LOCKDEP
-	/* Ensure that lockdep knows vcpu->mutex is taken *inside* kvm->lock */
-	mutex_lock(&vcpu->mutex);
-	mutex_unlock(&vcpu->mutex);
-#endif
-
 	if (kvm_get_vcpu_by_id(kvm, id)) {
 		r = -EEXIST;
 		goto unlock_vcpu_destroy;
@@ -4293,7 +4287,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 * so that userspace can't invoke vCPU ioctl()s until the vCPU is fully
 	 * visible (per online_vcpus), e.g. so that KVM doesn't get tricked
 	 * into a NULL-pointer dereference because KVM thinks the _current_
-	 * vCPU doesn't exist.
+	 * vCPU doesn't exist.  As a bonus, taking vcpu->mutex ensures lockdep
+	 * knows it's taken *inside* kvm->lock.
 	 */
 	mutex_lock(&vcpu->mutex);
 	kvm_get_kvm(kvm);
-- 
2.47.0.rc0.187.ge670bccf7e-goog


