Return-Path: <kvm+bounces-35133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162E7A09EA4
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:19:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E026C3A994F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0532206A2;
	Fri, 10 Jan 2025 23:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d3sNDG94"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4765A2063E0
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 23:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736551142; cv=none; b=LV/VDWIDqLcY4FPU7hbgQD8Bhk0f4cBgdxKIzMj2/BiuqVUfDIOTxvnCiX/ziN5GUIGu1xBLXvyL5urvZqkTc1J5f8SUUoezsNLRXXqsm4ZXRTUMh7is1cD8fH0VB2vOpREoMDCUwvyAAVwnfO5f1i/+AORru3ier4leMqHuGG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736551142; c=relaxed/simple;
	bh=Bo/YnknTXPxspNOgVE89cMxmQsPY5XSOymfImpJXfmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tqd1JEhXMrCNotir0R6NHNyXZ+LShtrEvJ+Ochcm6CjAKr5nKmTn40ItzsPQHz/iUyyH5aFAKJK60THxP244PfHCmW2qYhgUJp0eGNkj5uTS0hFG+YZm7o1Px25FWwKuOrJxUipczoanw05hFKylwFeRrFSgsjZhbc2m8DyRQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d3sNDG94; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so4698140a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 15:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736551140; x=1737155940; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AByyNesYvKU60RrHX/hX6z2cA+9SQ3uSnqwD1piFtB4=;
        b=d3sNDG94Lo+NM65wMp1dddP2TT+CmOEGuapYSJntC20xJfyMAx9HuXpqmZPDzTvHbB
         1tJdrfPl3eoBSZ6/Ky8KYdd3nbLZwgyfdInqxJ53zq1uR1Z7Y26ZEbmPfTu57fWMOU8P
         dCuplaHr5SRam72zXnAbnnqiRgc0vspOGVMm2+y89MBPvXY9j7V1DC9yeef0voXkEjAw
         uB212Z1VKDqpp/iG+BNtEOoalh/9gEcwyZ2lOLeAbxrbLM7nK8e8uHUd72ogwbxMy0Jl
         vgI5UBTk0J7RznRVFcRWB5zTqomv/YHZR1StWbXqyUlcLGLRSFtexHW1NzcrgYU6kx/h
         I3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736551140; x=1737155940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AByyNesYvKU60RrHX/hX6z2cA+9SQ3uSnqwD1piFtB4=;
        b=bh+AF8i8t9mo2vSPJqOsjJ3MUPyJZJlNsL+0oLeG6YrkClcM4Tfu4zIOugB6PRF7ZH
         SG4UbZxUnmt+jRO+Njt/6zxmt0M21y7pWOj0QTq4nFVJtfgKhdYO/EvCzdOBIT0VnaT9
         DqLB3Z/S8cs4CIBBY9YweTGce5ZJmlhgLlNC3Fd6nJCB/4OiziXhVxcUbQy+whoAfIDe
         c1trvuM+10z2qYftViEEurxkl4rlpT8aI+eaTlsNWJhyjoX3NLoMIRUmeqyB/2Abu7bB
         Fo2RzqerUpUgLX7WO6zzSfZuG92WkfVkQWBvoG3TlgrRdCUWP8LhXTF5xn+XXn2sQQRF
         tlYA==
X-Forwarded-Encrypted: i=1; AJvYcCUkh7Dt8MPD8Vsh9OBWE9FduNa7NyuMfJDP+zx5evKzYSb4wHyZlUeHeE9vBd5z6vuOJu4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxU5ryFhkTTbC3bEkVCJ0Cc8Xb1vqiPvdXd8By/0hkA4EyUHOmX
	GBS2Ma1qkG38N4D++Hx4uKTEBXDGqvXsAhK2KMTLtLxAvIaCGqMnkfQV/p9lPjlw0mzrYhNNSui
	cKA==
X-Google-Smtp-Source: AGHT+IFKJ9dI8iMVjEiNoHSVEVC2NxZpP+kJjpJkytnUK0H8OaMrSgfWJjkeUbO4BWq7klJIF4+9pf1va58=
X-Received: from pjbsg17.prod.google.com ([2002:a17:90b:5211:b0:2e2:8d64:6213])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4e:b0:2eb:140d:f6df
 with SMTP id 98e67ed59e1d1-2f548e98382mr16858900a91.1.1736551140650; Fri, 10
 Jan 2025 15:19:00 -0800 (PST)
Date: Fri, 10 Jan 2025 15:18:59 -0800
In-Reply-To: <20241105184333.2305744-9-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-9-jthoughton@google.com>
Message-ID: <Z4Gq443gcop9mL4X@google.com>
Subject: Re: [PATCH v8 08/11] KVM: x86/mmu: Add infrastructure to allow
 walking rmaps outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, James Houghton wrote:
> +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> +{
> +	unsigned long old_val, new_val;
> +
> +	/*
> +	 * Elide the lock if the rmap is empty, as lockless walkers (read-only
> +	 * mode) don't need to (and can't) walk an empty rmap, nor can they add
> +	 * entries to the rmap.  I.e. the only paths that process empty rmaps
> +	 * do so while holding mmu_lock for write, and are mutually exclusive.
> +	 */
> +	old_val = atomic_long_read(&rmap_head->val);
> +	if (!old_val)
> +		return 0;
> +
> +	do {
> +		/*
> +		 * If the rmap is locked, wait for it to be unlocked before
> +		 * trying acquire the lock, e.g. to bounce the cache line.
> +		 */
> +		while (old_val & KVM_RMAP_LOCKED) {
> +			old_val = atomic_long_read(&rmap_head->val);
> +			cpu_relax();
> +		}

As Lai Jiangshan pointed out[1][2], this should PAUSE first, then re-read the SPTE,
and KVM needs to disable preemption while holding the lock, because this is nothing
more than a rudimentary spinlock.

[1] https://lore.kernel.org/all/ZrooozABEWSnwzxh@google.com
[2] https://lore.kernel.org/all/Zrt5eNArfQA7x1qj@google.com

I think this?

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a0950b77126..9dac1bbb77d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -873,6 +873,8 @@ static unsigned long __kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
 {
        unsigned long old_val, new_val;
 
+       lockdep_assert_preemption_disabled();
+
        /*
         * Elide the lock if the rmap is empty, as lockless walkers (read-only
         * mode) don't need to (and can't) walk an empty rmap, nor can they add
@@ -889,8 +891,8 @@ static unsigned long __kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
                 * trying acquire the lock, e.g. to bounce the cache line.
                 */
                while (old_val & KVM_RMAP_LOCKED) {
-                       old_val = atomic_long_read(&rmap_head->val);
                        cpu_relax();
+                       old_val = atomic_long_read(&rmap_head->val);
                }
 
                /*
@@ -931,6 +933,8 @@ static unsigned long kvm_rmap_lock(struct kvm *kvm,
 static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
                            unsigned long new_val)
 {
+       lockdep_assert_held_write(&kvm->mmu_lock);
+
        KVM_MMU_WARN_ON(new_val & KVM_RMAP_LOCKED);
        /*
         * Ensure that all accesses to the rmap have completed
@@ -948,12 +952,21 @@ static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
 
 /*
  * If mmu_lock isn't held, rmaps can only locked in read-only mode.  The actual
- * locking is the same, but the caller is disallowed from modifying the rmap,
- * and so the unlock flow is a nop if the rmap is/was empty.
+ * locking is the same, but preemption needs to be manually disabled (because
+ * a spinlock isn't already held) and the caller is disallowed from modifying
+ * the rmap, and so the unlock flow is a nop if the rmap is/was empty.  Note,
+ * preemption must be disable *before* acquiring the bitlock.  If the rmap is
+ * empty, i.e. isn't truly locked, immediately re-enable preemption.
  */
 static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_head)
 {
-       return __kvm_rmap_lock(rmap_head);
+       unsigned rmap_val;
+       preempt_disable();
+
+       rmap_val = __kvm_rmap_lock(rmap_head);
+       if (!rmap_val)
+               preempt_enable();
+       return rmap_val;
 }
 
 static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
@@ -964,6 +977,7 @@ static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
 
        KVM_MMU_WARN_ON(old_val != kvm_rmap_get(rmap_head));
        atomic_long_set(&rmap_head->val, old_val);
+       preempt_enable();
 }
 
 /*

