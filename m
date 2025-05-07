Return-Path: <kvm+bounces-45710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4DAAAE080
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61DBA3B645B
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 13:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7DC288C1D;
	Wed,  7 May 2025 13:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PysQpbFs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD68280A2E
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746623945; cv=none; b=jM85YuWD9DI7pQ56VHeer3QbIXsGNjGQ890ehYvi65BHt09bIQ2Abss3lhB/U5T2WnqQVGrXJdkPOmyAoQwNRZWtag/8Ht/Qqikhu2JOqpynLs/OyCDUMJvoW03WPWAWyq91HxZEpOps7y+56CVr2qd8jUZt5orBFh83OQo8Fq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746623945; c=relaxed/simple;
	bh=0aeeZzBAboUCL2dYAAmEo32zpolosp3HiSeGVBJnS+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kXfubhgoEZRtJ5pDf6d+NtHOFGLo1EfNCXrJ3/py6qta//HRLGEN+RxPVd3Pnq2RpXYQ7bva0FrLS2CagEjCQmYCezCTteORZyM5BumPg02K49oMGzqMuwNscDn3styivhXeSCAE5zda/JAAZ/3B7lsGhwFCN3G92AYigoi54vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PysQpbFs; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b0e5f28841dso4360823a12.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 06:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746623943; x=1747228743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiDDof4wiRjH13eU8HS600kti+qoQv7U6EC7ECLTvXQ=;
        b=PysQpbFsLvNideaj9JwoHeW2LfCx1qvAp/bICsQVWkKz0xu2sxgPubKmKGhDW9ovFS
         Z2OSc4RS/dsR5+p1S26Rq7gM9JExvc7PN6hXI0WPQkpRRtj7d/Z3FHRMwOWc+gU6lPU/
         GaTSoqxEAMOb65Q8wSyXi11ao5ncXdqsshnASOi2LdG6nuwhic8QR/42dlzQBnsM2+1p
         GQjUod/hJt7BAzn0zmd7X4UJ++WLTvlAu0FINp/4S85FZhPVfAmINHXlN2JLc4T+k5+2
         VRB2U72Eg5Qj9H3raIiOOHaRHa3HNXd063tCDe9opJTzh42zl3NEo8jgeglexg89Vtcq
         3c0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746623943; x=1747228743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiDDof4wiRjH13eU8HS600kti+qoQv7U6EC7ECLTvXQ=;
        b=VsDElhs878VBkFvxsDuoOxgnk9y+F1eNU74p1VL2vj5RI3zlL3Ksnq6iOka/7txUAy
         z1nsSf5UAPaD5V1pybUcguN8MFZShLMOIg5ppxUhn9aCh7tkaxhamBVMK2KWjEp7lbCt
         cCMnDUIckrzhwp4jaF0QxOF/U95O85Rq3sMMVJ+9k68WbNy4lA1FLAm9RrrTYY1YMD5N
         2oTj5BOKhhNypaeamq01OWf2dEbUaTbUD7vZTyEmGYA0gMz4/FOA0TkBHBzirFbc9RdI
         Yq/eF76eCZhlI7RPRjKm4e1kjaI9YR6Ak8KGLsiB7PG937+Eymy6jcPHn/Z8Qdoq+3+I
         sr6g==
X-Forwarded-Encrypted: i=1; AJvYcCUOPYkL7R70V/+hN73cKiHomFDaL9MDDvp7L9/WeWoFnGGKYbBWAS2WgSVaM22NiIg6cCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YznfdAHOL7FpeHAZjRWzWGNwfarNUkg9jOznt4uHm+gBMQRgkLn
	Sr3cqdfg1V7HrgNIbUD81RVw/F8evUR5XO/pHLH+Zfs3nuJ4As9qXayNApwlMrwC8bPmiHsD+4h
	pDA==
X-Google-Smtp-Source: AGHT+IG0pbnqCOzrdthF9M4ba5aUOwNn28h6yygWEFPEB7MG/opmaX+QYIEbz4HJ6A2roFeeeso4RABRwXI=
X-Received: from pjbse11.prod.google.com ([2002:a17:90b:518b:b0:2fe:7f7a:74b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e84:b0:2ff:5357:1c7f
 with SMTP id 98e67ed59e1d1-30aac28b3bcmr4899205a91.30.1746623942825; Wed, 07
 May 2025 06:19:02 -0700 (PDT)
Date: Wed, 7 May 2025 06:19:01 -0700
In-Reply-To: <aBsGNPvG75KspVmp@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250505180300.973137-1-seanjc@google.com> <aBnbBL8Db0rHXxFX@google.com>
 <aBoZpr2HNPysavjd@google.com> <aBoc0MhlvO4hR03u@google.com>
 <aBoxcOPWRWyFIgVE@google.com> <aBsGNPvG75KspVmp@google.com>
Message-ID: <aBtc7Y8odYFGGLrt@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1
 VM count transitions
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Larabel <Michael@michaellarabel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 07, 2025, Yosry Ahmed wrote:
> On Tue, May 06, 2025 at 08:57:36AM -0700, Sean Christopherson wrote:
> > Sleepable spinlocks aside, the lockdep_assert_irqs_enabled() in
> > smp_call_function_many_cond() already provides sufficient of coverage for that
> > case.  And if code is using some other form of IPI communication *and* taking raw
> > spinlocks, then I think it goes without saying that developers would need to be
> > very, very careful.
> 
> I think we are not talking about the same thing, or I am
> misunderstanding you. The lockdep_assert_irqs_enabled() assertion in
> smp_call_function_many_cond() does not protect against this case AFAICT.
> 
> Basically imagine that a new code path is added that does:
> 
> 	spin_lock_irq(&srso_lock);
> 	/* Some trivial logic, no IPI sending */
> 	spin_unlock_irq(&srso_lock);
> 
> I believe spin_lock_irq() will disable IRQs (at least on some setups)
> then spin on the lock.

Yes, because the most common use case for spin_lock_irq() is to prevent deadlock
due to the lock being taken in IRQ context.

> Now imagine svm_srso_vm_destroy() is already holding the lock and sends
> the IPI from CPU 1, while CPU 2 is executing the above code with IRQs
> already disabled and spinning on the lock.
> 
> This is the deadlock scenario I am talking about. The lockdep assertion
> in smp_call_function_many_cond() doesn't help because IRQs are enabled
> on CPU 1, the problem is that they are disabled on CPU 2.
> 
> Lockdep can detect this by keeping track of the fact that some code
> paths acquire the lock with IRQs off while some code paths acquire the
> lock and send IPIs, I think.

I understand the scenario, I just don't see any meaningful risk in this case,
which in turn means I don't see any reason to use an inferior lock type (for this
particular case) to protect the count.  

spin_lock_irq() isn't a tool that's used willy-nilly, and the usage of srso_lock
is extremely limited.  If we manage to merge code that does spin_lock_irq(&srso_lock),
you have my full permission to mock my ineptitude :-)

