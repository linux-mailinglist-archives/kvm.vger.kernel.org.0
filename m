Return-Path: <kvm+bounces-37023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E5FA2463F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88B331679AD
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A9239ACC;
	Sat,  1 Feb 2025 01:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qR49V3cl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9291D555
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373914; cv=none; b=Vf6qjKnQYs6MEdBHaYGFEMIDa9YHmYEppziCZfKq+/L0LRQ3W29CnLeYHMzCHfauPMnkQCvp5feELEUdqWepeE0rEaso/1iEHNGfH07ZhLh+g+TKq88CPRIv0O1Da121qK1E9gOWQDi3nqUY2mx18UuSc0jRdOupEfFQ58Lr1pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373914; c=relaxed/simple;
	bh=bIer252FPj2neLt5xdi2KiMB2kp+ZCOYERhI9r0upcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A7h/kURFsqqaJqau6ANbi63o7U3pXezlu1yON/Is6UFCRAzFbaUnBrZJxtfVn8rtUaznpGVN3RJRG3+h7IZ+8xF3c1XvtFZ2rMYPbUGM7gTzB/IO+oJXzywDzLXhKw1atT6F5qeHW1ufE8WNqak0tbqe1ZbjdzIa5a0fp+YoLz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qR49V3cl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so7220305a91.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373912; x=1738978712; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zp7NYWAIXF7j15e690s9k+4LsZ2x/OUxLnCwUuEMDT4=;
        b=qR49V3clEC6DCbODm1bLFr47MwfFTX8GBtSbxk7irAKu5kXnlzstI6tbs/50OhbIW0
         L3yEhZf4nsPrZ08yBb5jfNSP3pd3JePgH0zhXQqvCymRUy4jhM8J9H0wYxtY0l/WI54q
         H2IDTNrK/0MJeP6kQlBtruTUVsHALHXXd3PWE8KF6hFL5djqomD7VFjJEYa0U+p+Bb+e
         u+oMAy7tLWujSedjAd8VtREFnoGDxKRhRgTbvDDxejnTZ9lMmWNWM/PqVyRIpa7YPfDK
         gMdGkTGzOkHMN34Tp9bpnX03D5L7CvdbTz0448NX6JhZqbUmaDf1FMJXLTj8QCHwuEht
         mwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373912; x=1738978712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zp7NYWAIXF7j15e690s9k+4LsZ2x/OUxLnCwUuEMDT4=;
        b=jVroy2X9Ukh75wU3WeQDAtdIn6pisI3jrYjz3mCRhQ4qK7eurwVsYA0hSdwleFsv9j
         L5f3ZEZC+Fp1w0/klCJjchC4HRAOJI6Ol2bWWs8ZEfh8iE6Iq11FzVZZEEal6HZLi0Fl
         xDw65WPdpt7meCQCOTj7qL9JN1VrnQwq9r1dF7aCfvnwHuEMC3orGtc7cpzYZCYviyfX
         sgGU36RWpRluOM1uxPm1j+EvgO2HcyHoi3EFNH426Ad8phHLcBmbnohxh6SVuxTnSe4t
         eAjcNH1ZZKMVKzRAIpN6ZMzq1u6W24/CCRoJerw4o0lDVjFWCyUUNOyD0ABL7bNhrV0J
         XiTg==
X-Gm-Message-State: AOJu0YyMjb1pJN+oJf4SLFqRi+XWAitHwfPMhU/znaUCMvCyueS+b5oa
	FitOxH7ukZ/fbJoqSGrvld0ClwcAYqL19DJaUQYGd4oY4UEmsZ+rMt3lEdHPiGQ4derAvRHthHL
	coQ==
X-Google-Smtp-Source: AGHT+IEewJwHCgkXKTVE1+h2sO808rYxQKec4ZGCZb9LwsStHhG0Pq3/2ryQ5LpVFWr3Dlpj3qpPvdy7x70=
X-Received: from pjbsw11.prod.google.com ([2002:a17:90b:2c8b:b0:2ef:a732:f48d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5245:b0:2ee:ee77:2263
 with SMTP id 98e67ed59e1d1-2f83abaf3f2mr21239555a91.7.1738373912335; Fri, 31
 Jan 2025 17:38:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:17 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-2-seanjc@google.com>
Subject: [PATCH v2 01/11] KVM: x86: Don't take kvm->lock when iterating over
 vCPUs in suspend notifier
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When queueing vCPU PVCLOCK updates in response to SUSPEND or HIBERNATE,
don't take kvm->lock as doing so can trigger a largely theoretical
deadlock, it is perfectly safe to iterate over the xarray of vCPUs without
holding kvm->lock, and kvm->lock doesn't protect kvm_set_guest_paused() in
any way (pv_time.active and pvclock_set_guest_stopped_request are
protected by vcpu->mutex, not kvm->lock).

Reported-by: syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/677c0f36.050a0220.3b3668.0014.GAE@google.com
Fixes: 7d62874f69d7 ("kvm: x86: implement KVM PM-notifier")
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..26e18c9b0375 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6907,7 +6907,6 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 	unsigned long i;
 	int ret = 0;
 
-	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!vcpu->arch.pv_time.active)
 			continue;
@@ -6919,7 +6918,6 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 			break;
 		}
 	}
-	mutex_unlock(&kvm->lock);
 
 	return ret ? NOTIFY_BAD : NOTIFY_DONE;
 }
-- 
2.48.1.362.g079036d154-goog


