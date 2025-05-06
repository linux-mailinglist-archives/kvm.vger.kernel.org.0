Return-Path: <kvm+bounces-45599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973DFAAC7A0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4FDC3B0B92
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EED2820C5;
	Tue,  6 May 2025 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ce4KsqT+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1D222A4F0
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746540970; cv=none; b=OSxuuVwhYHQ6cMAqEtLc5AVuljKO0/fSQNXUPrFl0eaDhqBFFpWBZyx/n26baFRlqi7O1il32n6+oKUuehLqN8jZILtbgDWIxuapLJSHEnKKPOOQ/QlWdTglAnOkaayQveLdI9ffppcSRnjuPp/slxKzLV3RXQa659V9JAzAAWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746540970; c=relaxed/simple;
	bh=nGZfIx4Ed+ZFz2U1JEUcofTZSLNFo8zSSEgYCX/iv0M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fC2szTvOPBM+o5Y8Rh1IxnbZ+Rh5nUI5qw6xcc9/9Xe+nUrk5grKfV7CvPVdjKZW8ZaQXo33CMFZemdI+9vHEjGTBd/Df9zrTLW5A5baD17HzuFlDGWPcR5bMs/ji210JcX7pyxc2uIdGuSGsQtZlMrGugKi9SSd5NS4v4SS6d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ce4KsqT+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7395095a505so3937742b3a.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 07:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746540968; x=1747145768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WrcdjkSiEM3T1KHu9XV65lo+7YycT5Nay5GRFc9p3r4=;
        b=Ce4KsqT+eF8EbZVzCUsXwYn7XREUx6B4EEXP0ely5yXFZWm//yva7jsuFFYZVosnYi
         vvbFo+ceTsGm5mcTzwkMSRmerV8LqHYnyKCI8JVtZY2VTkMVC/dPK1177V5QS0vD/XMy
         /ckzJekE0HnuzInEDyUYnVywKBEHSWC0rl2lsl8U3X9MqFjf5UQHyMXv1XWZ7gH24ml6
         Fq2QrqXOVBPQ6fhtZCJwlJ+olZEMqYcH5yk/0SJpzm5rRKUFr+LbrZDtvdpTPMZqpMVo
         ZxE03KJhVhaGTO2DqUBsUnCl2dL1Nm0Z95HW1qTHjE7rXrkn4f3W8eWW+MuxfvXHhFxb
         3A6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746540968; x=1747145768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WrcdjkSiEM3T1KHu9XV65lo+7YycT5Nay5GRFc9p3r4=;
        b=c4Ivad90bW51X6ELbF+PpCLdLG+lL66XfAgP2Pq+7U0NeOtMsO2WEuIp+zd3amVdwj
         J7VrpdXQKgFKNt9LrP0X5XEBYmg0raAmv4In7teMlzxZyP9rUiE810KGnNvupnIO32lg
         KFueymZI2mLXVcVc0RqHmmQDJXsMGhn1Y2RNItEVz4GOIsvK0n2UeVEkYqjs7OB4x4sf
         5pyNIkWUSq2nv4Du6Xok39mm8ox5Awa+KAcSPJZEp9SF0KM07SZtDUKI2Nz29w81flhB
         ruL+Jy5ZLK1HZWmTUiTwehqj76I9HfS69/3JbvSgFLfkzgOI3VxW/2G8g0wbgstrdIe0
         TLOw==
X-Forwarded-Encrypted: i=1; AJvYcCU50t5AgrAS8+ebxo71fyd3rvyducIW+4WG+b5zOgwpqVEVnuBwt0xuPJu3GlR1b32Cnck=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH6b3lSx7QcP8v8F+w0jXTHhBxkmdT9eBG5VnHlfpSqYAjSvlQ
	pqvnllQ4f60bIVrPg0HoCD7zpN6fO3kCiGGXfaNNiu+JQILGVKyMTAlD5A07zI7V2hddXvJBqZk
	5AA==
X-Google-Smtp-Source: AGHT+IGVWwya7CMmkwuCQneO5Dqgblsv/kYJEhrK535ESjIRh4BpPMEUpLfbHphMVOjw5lo3RBtUbslJkfo=
X-Received: from pfgu9.prod.google.com ([2002:a05:6a00:989:b0:73e:2380:71b3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:28c3:b0:736:5438:ccc
 with SMTP id d2e1a72fcca58-740919bd7d7mr4136427b3a.9.1746540968104; Tue, 06
 May 2025 07:16:08 -0700 (PDT)
Date: Tue, 6 May 2025 07:16:06 -0700
In-Reply-To: <aBnbBL8Db0rHXxFX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250505180300.973137-1-seanjc@google.com> <aBnbBL8Db0rHXxFX@google.com>
Message-ID: <aBoZpr2HNPysavjd@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1
 VM count transitions
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Larabel <Michael@michaellarabel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 06, 2025, Yosry Ahmed wrote:
> On Mon, May 05, 2025 at 11:03:00AM -0700, Sean Christopherson wrote:
> > +static void svm_srso_vm_destroy(void)
> > +{
> > +	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> > +		return;
> > +
> > +	if (atomic_dec_return(&srso_nr_vms))
> > +		return;
> > +
> > +	guard(spinlock)(&srso_lock);
> > +
> > +	/*
> > +	 * Verify a new VM didn't come along, acquire the lock, and increment
> > +	 * the count before this task acquired the lock.
> > +	 */
> > +	if (atomic_read(&srso_nr_vms))
> > +		return;
> > +
> > +	on_each_cpu(svm_srso_clear_bp_spec_reduce, NULL, 1);
> 
> Just a passing-by comment. I get worried about sending IPIs while
> holding a spinlock because if someone ever tries to hold that spinlock
> with IRQs disabled, it may cause a deadlock.
> 
> This is not the case for this lock, but it's not obvious (at least to
> me) that holding it in a different code path that doesn't send IPIs with
> IRQs disabled could cause a problem.
> 
> You could add a comment, convert it to a mutex to make this scenario
> impossible,

Using a mutex doesn't make deadlock impossible, it's still perfectly legal to
disable IRQs while holding a mutex.

Similarly, I don't want to add a comment, because there is absolutely nothing
special/unique about this situation/lock.  E.g. KVM has tens of calls to
smp_call_function_many_cond() while holding a spinlock equivalent, in the form
of kvm_make_all_cpus_request() while holding mmu_lock.

smp_call_function_many_cond() already asserts that IRQs are disabled, so I have
zero concerns about this flow breaking in the future.

> or dismiss my comment as being too paranoid/ridiculous :)

I wouldn't say your thought process is too paranoid; when writing the code, I had
to pause and think to remember whether or not using on_each_cpu() while holding a
spinlock is allowed.  But I do think the conclusion is wrong :-)

