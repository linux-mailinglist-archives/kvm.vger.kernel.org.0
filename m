Return-Path: <kvm+bounces-68278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E66ED2953F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 42E483048922
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF69232D7F3;
	Thu, 15 Jan 2026 23:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UG+jSlDe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB4B24468C
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768520823; cv=none; b=sR0ncdKQYf4nQdI91mIEADKRjWdcr+SO2cJyIipbFM6uhjhVEOATOq6jUn3IR6wSbLKAD2GsjMtfLQRVyOxCYULoNrlBgZzI85gmnObZvjMCBs9P5Dos7Q4mJ/xLSFlxR9L5qEaeYoS7ikAVAVNaFO7Cs7FEjDBMJuM9jVgCFLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768520823; c=relaxed/simple;
	bh=/Fp/ejZbkRM9Z9EBhY/M51jZlAC6bTQOWy6F0Nkqee8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OEHgKtvO3EIc6dcQ+uHOt0nVOOTwMJLHyHUmY91tQ9yI7O9mgQ4/BAYWE1OSqNuyCbS5tm/h8NCqPyIGPLyo6tYEJ5igbRW8rzkA2oAxoGPZq/rrmifBIKAKEym2KfAXn/82QGSslm17Yy9CmrSQI0x90Z7meqPNiX3CD/WKTNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UG+jSlDe; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c38781efcso1091504a91.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768520821; x=1769125621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfJSMSycVj4hVnhjAI/bMXdkjSgS09U+rtVP3ejUx34=;
        b=UG+jSlDejXxnWAjR0EyTCkfmKOXHqExIInLOLCiejp34sS4/acvXU/BdzfYRn6UbFc
         3VLeFmaTYRL+yV/oUvhB/7IjhMxAz7QschmLAJ0riHYRz+gpxCitbenQFikX/uwIKpNA
         xQ/ZyX8mTLKBH1wbl2Z3mTHxOGCHbPLjHyyOyWtWw3Jbwsd/4j56odFzIRyWlUddQsur
         R+s8USOyvHe9vxg0OmhwvP9Je3vWifIRUj6VFjPpZZli+7zaHpjUM83kzwV+hXULVuKB
         mKj9jj02v7LDXS77T/YXMdAepGb4oznCcsyxCiiHFs85DzG21y/ZmUnuQrFroVbL0WMZ
         kp2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768520821; x=1769125621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfJSMSycVj4hVnhjAI/bMXdkjSgS09U+rtVP3ejUx34=;
        b=vidEVMN8xDHoKWZdPj5tssxA1x8hbrwJ2O3XQU24c94xVBrVvR1PBIugNwINTIvwgh
         UywdQrxqf/k8c6RgvddIf7luqGNGVUCF6sAznQNYGBCn7YINewzz2cT0MSAqJ/Pdm5Av
         1d7QAzKtYqlD4P3Vd3UYZw4LtkwyF27q6+fJQAluBQTIwPr8RfYPmS9cVZgdIc5A3Ra5
         oHhxCpUL3OGwsO6P/SwmBSzUQxAdeDv9K/5wPJC0g+cx/Yj9zBINOL4X84IgSzKXLtT9
         8h91VMapMdTMnbgad51ga+yv55gofP0RgzWZpfz5SDFsRjhCj3Q/SMFZpf4yZoKQqQpa
         5Rzw==
X-Forwarded-Encrypted: i=1; AJvYcCV2d8CtPSl2vFi02LWLyCbAXHlMqHr+bDcs6myD+2UW247WmiY1Ps9rAY5Wooz+5XOogMI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfj0mrC6RailVA3v4/DoPOScCKLrsH8azZ7Vgz9ToHbjKfcVl4
	xdW7hZwHP83TQr43FrCm35f/UH+FzqCIFgKUTnWzpy1a+A9E8YgEdWCaEojN0PuzzgZKsIGjenf
	kIZbGdQ==
X-Received: from pjvp18.prod.google.com ([2002:a17:90a:df92:b0:34a:b869:5ed4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3811:b0:34c:4c6d:ad0f
 with SMTP id 98e67ed59e1d1-35272fd8d8fmr903040a91.37.1768520821030; Thu, 15
 Jan 2026 15:47:01 -0800 (PST)
Date: Thu, 15 Jan 2026 15:46:59 -0800
In-Reply-To: <2kgs2paktjfb33sdr46zhlernx2xgokh5ac4og45obrvvlm34d@2df2kb2u44cy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115172154.709024-1-seanjc@google.com> <2kgs2paktjfb33sdr46zhlernx2xgokh5ac4og45obrvvlm34d@2df2kb2u44cy>
Message-ID: <aWl8cyfgqdbOrMV1@google.com>
Subject: Re: [PATCH v5] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> On Thu, Jan 15, 2026 at 09:21:54AM -0800, Sean Christopherson wrote:
> > +static void l2_guest_code(vm_vaddr_t base)
> >  {
> > -	READ_ONCE(*a);
> > -	WRITE_ONCE(*a, 1);
> > -	GUEST_SYNC(true);
> > -	GUEST_SYNC(false);
> > +	vm_vaddr_t page0 = TEST_GUEST_ADDR(base, 0);
> > +	vm_vaddr_t page1 = TEST_GUEST_ADDR(base, 1);
> >  
> > -	WRITE_ONCE(*b, 1);
> > -	GUEST_SYNC(true);
> > -	WRITE_ONCE(*b, 1);
> > -	GUEST_SYNC(true);
> > -	GUEST_SYNC(false);
> > +	READ_ONCE(*(u64 *)page0);
> > +	GUEST_SYNC(page0 | TEST_SYNC_READ_FAULT);
> > +	WRITE_ONCE(*(u64 *)page0, 1);
> > +	GUEST_SYNC(page0 | TEST_SYNC_WRITE_FAULT);
> > +	READ_ONCE(*(u64 *)page0);
> > +	GUEST_SYNC(page0 | TEST_SYNC_NO_FAULT);
> > +
> > +	WRITE_ONCE(*(u64 *)page1, 1);
> > +	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
> > +	WRITE_ONCE(*(u64 *)page1, 1);
> > +	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
> > +	READ_ONCE(*(u64 *)page1);
> > +	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);
> > +	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);
> 
> Extra GUEST_SYNC()?

Yeah, I'm guessing it was a copy+paste goof, I can't think of any value added by
a second sync here.  I'll drop it when applying.

Thanks!

