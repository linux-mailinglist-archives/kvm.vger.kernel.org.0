Return-Path: <kvm+bounces-15717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4848AF722
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 21:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E8681C2503E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92D01411F4;
	Tue, 23 Apr 2024 19:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnyJSpdt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F77B13F452
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 19:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713899814; cv=none; b=DRKgTRBw36sg0/hgg3QHllAg/VaT0RvmVRoIQT61R8HO4g41k+GrXup8g5Laqubf6ytUDWkr25OCEd4b1IIm36awk/12TusSiGTIIK0VJTuXrOkqlym89mHL4aNRFdevWZpeTCyVGYwd4WMQhdkTUgDsJG9qqEy3SttWhObUcXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713899814; c=relaxed/simple;
	bh=rKJ3l5PngsMhhUsgGiBJulPEoC22NhzF9omTbh59/TI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GzYqkS//kF5bk/Wl9KC9n2wL2Bm0/4+9Mfdf/jQnktm1JVvuTUnezAnMC+IbZePXcxM7twrxmcALW4pV/VboOg6b8oC655INPLkM1uxsCEWEegSF8WAXtUroPzTDrYldhotK7HqKHNnR0hWGuDzwK8K3wp9RGokMT0xTVdiMAQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cnyJSpdt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ac3403b27eso6530162a91.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713899812; x=1714504612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8B8BJDQiGUAbI0tZGCCPFyop6LA8Xy8bkwpS740fWe0=;
        b=cnyJSpdtTy358I3qXwRZOR0UkyGFGx7akqv6eOLaC4uZZgfLJ6vdUg6NKbsrU/hmgE
         3oRc87Nls3lX5EXG/tMfHyRrZ2PASYUXnwMXX48jTeYkzl2EGifKYzv+0T+BVnWpUIWX
         ikuqSatc4QLoPC5nsoo8ygJru5Cs6YquwMs0hQsEtt5UEC9DvdLgPZU6//0cSqbUn/X2
         C+g3sb5CUjC2CsYPpTYeVn9aoW2Jeb5rRq27m1tU0Fd1NpOuUp1taAjHYD6ApByS22zF
         E/CTHYuuvWPN7itfVNtwnK8OVN6UBh/K1AHpo1TYouPulANPreXtfm4LCs7sW8XgzhI3
         Iy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713899812; x=1714504612;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8B8BJDQiGUAbI0tZGCCPFyop6LA8Xy8bkwpS740fWe0=;
        b=UT5CMHl8E4rXflkQdreBI6eDdbLHSL82kf33ScpzEISc78qNL4mkD0apRbQQ9qDVbj
         2n3CUDz+FMtOLpIggle1AzfB22hNI4CiDPtiAKTjRxgzZ9SH6b3xW24it/Pdoe3pBBoU
         9AYlKAR1mbyigZiqwm5eT6a9lIJHFdzKqLBqvRiHLx0+6LhWGQqfosXrMuRgdZoCPK7L
         5rO15L98beKSlcnF+K4Ydpol1e1r6zTebYKL3vsyzeoM9rmkOEFrLL7uuK15uRfyOlAc
         9EjwMHLr07rFbXFWTY7542HFdPdrMGWJgkYkYDt615zDmdFo6fohYtHC8XfdnYdGL74N
         cwQQ==
X-Gm-Message-State: AOJu0YwgBlBuJagMdyC00M6BqgzVd/EcnWMdFKtsQu1FajsudbbwuYAL
	ktD98L4v4qDAeIFy06sOVIovqSfpw4lzAEgjDfMnA5609Jn5QckyoaCQ9s9Jg7uNy87flbmeFE0
	l1g==
X-Google-Smtp-Source: AGHT+IHc2Pkewcf/fjEyx1Ej8IWpt/3GzaBNYp2bJhAmBKboXze10z/yAFFif1JOzokxw7TZwp+xbvaMBRk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8a95:b0:2a2:ff01:dd7c with SMTP id
 x21-20020a17090a8a9500b002a2ff01dd7cmr1330pjn.8.1713899811718; Tue, 23 Apr
 2024 12:16:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Apr 2024 12:16:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423191649.2885257-1-seanjc@google.com>
Subject: [PATCH] Revert "KVM: async_pf: avoid recursive flushing of work items"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xu Yilun <yilun.xu@linux.intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM does NOT gift async #PF workers a "struct kvm" reference,
don't bother skipping "done" workers when flushing/canceling queued
workers, as the deadlock that was being fudged around can no longer occur.
When workers, i.e. async_pf_execute(), were gifted a referenced, it was
possible for a worker to put the last reference and trigger VM destruction,
i.e. trigger flushing of a workqueue from a worker in said workqueue.

Note, there is no actual lock, the deadlock was that a worker will be
stuck waiting for itself (the workqueue code simulates a lock/unlock via
lock_map_{acquire,release}()).

Skipping "done" workers isn't problematic per se, but using work->vcpu as
a "done" flag is confusing, e.g. it's not clear that async_pf.lock is
acquired to protect the work->vcpu, NOT the processing of async_pf.queue
(which is protected by vcpu->mutex).

This reverts commit 22583f0d9c85e60c9860bc8a0ebff59fe08be6d7.

Suggested-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/async_pf.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 99a63bad0306..0ee4816b079a 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -80,7 +80,6 @@ static void async_pf_execute(struct work_struct *work)
 	spin_lock(&vcpu->async_pf.lock);
 	first = list_empty(&vcpu->async_pf.done);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
-	apf->vcpu = NULL;
 	spin_unlock(&vcpu->async_pf.lock);
 
 	/*
@@ -120,8 +119,6 @@ static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 {
-	spin_lock(&vcpu->async_pf.lock);
-
 	/* cancel outstanding work queue item */
 	while (!list_empty(&vcpu->async_pf.queue)) {
 		struct kvm_async_pf *work =
@@ -129,23 +126,15 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 					 typeof(*work), queue);
 		list_del(&work->queue);
 
-		/*
-		 * We know it's present in vcpu->async_pf.done, do
-		 * nothing here.
-		 */
-		if (!work->vcpu)
-			continue;
-
-		spin_unlock(&vcpu->async_pf.lock);
 #ifdef CONFIG_KVM_ASYNC_PF_SYNC
 		flush_work(&work->work);
 #else
 		if (cancel_work_sync(&work->work))
 			kmem_cache_free(async_pf_cache, work);
 #endif
-		spin_lock(&vcpu->async_pf.lock);
 	}
 
+	spin_lock(&vcpu->async_pf.lock);
 	while (!list_empty(&vcpu->async_pf.done)) {
 		struct kvm_async_pf *work =
 			list_first_entry(&vcpu->async_pf.done,

base-commit: d2ea9fd98cca88b4724b4515cd4d40452f78caa8
-- 
2.44.0.769.g3c40516874-goog


