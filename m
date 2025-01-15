Return-Path: <kvm+bounces-35604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88341A12DEF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 22:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3509163F55
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 21:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81551DB922;
	Wed, 15 Jan 2025 21:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wDYC0Z6C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A931D6DA3
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 21:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736977779; cv=none; b=glaKKOgRC9/xKqZkwIXE2oBIUM9L1cHjxVcwj4mJCxgZFQbnD6NaEkRfqydQ5lsQ7b9cE6H5Tshc1+lWA9r3BeqZ183UNz8guV5ebQ5W6SdfW3U9sMzqXs0ubyEijkXkhcWn7+xI4IXtR2a3EgCMbGrI5gwi301mOjCjb6Mbrqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736977779; c=relaxed/simple;
	bh=I3Ad9XLY4fO9RVP3cYcOe+iuyKue3qbt4UU6mSO+EbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UQOs3AUGKaGm0Yk3izsf9xcIa7AtwTTeurAdniQTOqeyjRC64GWh6D9Ibej1F7STbE1YonqTHeQw4CDw9cO/EGSrRIDAsBszIAbRmvXlwtYdOXxiM6oGWjE7LvOz5UYUJAgH3ZnHRQxGvfrjR/9PSTiesrXJYm1/76Atc8ecEI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wDYC0Z6C; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee3206466aso2666969a91.1
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 13:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736977777; x=1737582577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ri0Hck0RLmnsmN464wmH1M0AsER8Cny8ZtD4ktzxzBQ=;
        b=wDYC0Z6C+GS9e9/Hjnr9NH8+8IDDt0crAjcneBWglFTeM8Re+48WaxgDqv3hlgMqtx
         KUFJn5HrbnRjKfpL2b1gS99hvrjZLg2IpM6FfxVfjifViBrNSOPyQXQBuah7/3GwbTtM
         oq0CzrF3EC2L7qI+x5VmBdm3gwA1H8rB31sArnq4vzJrefChhqsD+94AvhSq+8sotuZT
         8eQI+crAzFtHgomv9JI8uN1zQVEfWfzSMckF40nDYlgLX13LdnLFAkdT2UsluqVTNMmh
         nsTyqAumg8wY039TUo45iYwnTwFbxVisyzD6hLMhXGxD4USCsG6eFvHOQb3TUzb6Au9S
         +sGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736977777; x=1737582577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ri0Hck0RLmnsmN464wmH1M0AsER8Cny8ZtD4ktzxzBQ=;
        b=LZV5DXblEmTWUejz1UCUqXcvIGWgZ+kYKrCmady3ZdpiQdm021b+pJp87RHz5iKVe+
         4cc3UnhlfqUPsfj5FQ85R6fNzwTiW1hsKEAwPwBcvi8alQf6i8vQqTXz1wuHh4g0hSib
         iWz7JIEPvjDDbW7DhNavQ6NY22r3vzgv67mYJRgtqYsUTFWpswSiB6OUOjMzwReCgUOF
         TEdESPeCa0b5rJ51xgvr/pgfbLJNP/efjV3emxK4fUeK1ijK/rkIgyU95xg+IQcBYFPf
         qiLRCUw3qxPk6PPmP5E9CzlJOXNFalUobeqTSHJ3nHf50TIp6r19tZ3/23cskU1pXf2Q
         9kxA==
X-Forwarded-Encrypted: i=1; AJvYcCUvNRChiuBxIK2KnD1Z4Ed4rWOdp85up0XWMvR+D1oOrqQcLKVluce8v2yu6SU1CsAfShw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgoKbVgcQ6R6CbxZoat0oVMnZJ9hbVBWtfIbElVqPDhOQ2X9g4
	uQsQhh1S4iM4DLK4G9Ad/bnFUmXoogjWSbdDH4pnZ+JYYMvj6QWWxKHibqZHzdkmdyQmXCU7N5K
	rtQ==
X-Google-Smtp-Source: AGHT+IEEAOEXoLeKdCs3ol8mlXgGgS9EhtuXpM7azVEB0zR853XtvuP2Vhr+cXRn+bjq4NayHaaVQnN0nUY=
X-Received: from pjbqo11.prod.google.com ([2002:a17:90b:3dcb:b0:2f5:5e05:ca37])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b44:b0:2ef:ad48:7175
 with SMTP id 98e67ed59e1d1-2f728e687f4mr7025228a91.15.1736977777017; Wed, 15
 Jan 2025 13:49:37 -0800 (PST)
Date: Wed, 15 Jan 2025 13:49:35 -0800
In-Reply-To: <20250107042202.2554063-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
Message-ID: <Z4gtb-Z2GpbEkAsQ@google.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> It returns the cumulative nanoseconds that the host has been suspended.
> It is intended to be used for reporting host suspend time to the guest.

...

>  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> +static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
> +{
> +	switch (state) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		last_suspend = ktime_get_boottime_ns();
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +		total_suspend_ns += ktime_get_boottime_ns() - last_suspend;

After spending too much time poking around kvmlock and sched_clock code, I'm pretty
sure that accounting *all* suspend time to steal_time is wildly inaccurate for
most clocksources that will be used by KVM x86 guests.

KVM already adjusts TSC, and by extension kvmclock, to account for the TSC going
backwards due to suspend+resume.  I haven't dug super deep, buy I assume/hope the
majority of suspend time is handled by massaging guest TSC.

There's still a notable gap, as KVM's TSC adjustments likely won't account for
the lag between CPUs coming online and vCPU's being restarted, but I don't know
that having KVM account the suspend duration is the right way to solve that issue.


