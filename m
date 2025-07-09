Return-Path: <kvm+bounces-51930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA400AFE995
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51236568AE9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8072DE217;
	Wed,  9 Jul 2025 13:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ihiwuqaw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BAE2DCC03
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 13:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752066128; cv=none; b=u+qepBcsHLgqmL8kU8iF7sm7QyjkMn2gGcQRxKcLeVmiAUZ8eDKdYmjlMqm87+aIgoAHXd6Q7iTgerhKVCXGP0pLYUNRLS6LniNM+jTSjplMmHu4iwv6TqEwKcIvjMofxVzzg7F6y+XDZsfNdU6k49O+wHN6h0HWIYB/1M07YCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752066128; c=relaxed/simple;
	bh=PKN05u2GZVZFQVi8mYkv9AgVNmgvP8VQmZ7IS1XT7mc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=up5Th7wGJ65qJ9ioGSeVa52q3JZnkkCG+noMRqhml9RDrH1zb+XVLGbC8bawfuoCK6hFDUnIqwA+zLr6Jyi8IC4TjjA7JK1AZe5z6jyjqjQhUtFA2OtY/Dd9xIc9dWAtZJg92Fa/6RhCob7/V/V0NnQnl+2sdKAmPRi1b8B5mbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ihiwuqaw; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31ff607527so4093121a12.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 06:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752066126; x=1752670926; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nk4HVwXuMe6h7bhTVh6kU5/xhXMf/wzhNXvAy/BcLNA=;
        b=ihiwuqawJp/3oaQCLzrF89Ga5C7q+msM8t/hB+3Aj5QNV7YlxBqif6mKjT2fZiYHOh
         BJFPreo+5+/uYS2pizNivHR4DM1wPb4eYQNhja8g19tc9Z0unEZX0BawoLol1oq84bAX
         RVSinv3HGHuUwQvPQTtT3BMmM0MMMY+LWvdhnthKITUOH3gZESldsxJCWGnkgpY6NkY5
         Gatz/tD6lSzHjRCddFGPKzdEFrcLcrXHLZU8AQJVQvc7TbByzIrn7OTVDj0VG9FDcGVs
         mX1LDKBKfNxVVdHmy6DSp2GFo+dEYQoCWgOal0t1rtWJFmNqRlxvy7jxesZYHSOb8v3r
         jwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752066126; x=1752670926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nk4HVwXuMe6h7bhTVh6kU5/xhXMf/wzhNXvAy/BcLNA=;
        b=UfkdrggaBsxZIoN82k5V6tmaYVFZD4Xhh62Te0tyxwDiCZs4hknuY1kkwBZS67NVrD
         0wLNfQDfL5S5RV/l6u2AGzXCsB47jT3dPTLeQpJs1E+FiYFCbegNOyvs+YbR7rVSEkp2
         WtUqPHOzrngc5eNpJl32S+bNwxYOZz31D5N+iM/QWOKcO7GnsSp0+XHIS0fAu/72Wvsw
         KgLbk6eIOOz8JJrIdlHbnvk1+vDmunOyI4n+tTo8myJGw51w6L82H5L8ZOJnLsc2kLpa
         oKT8eZUQOqWfnV1IvLb6WdoxaVWgvYnqY0rL8q5gFp4qODc1SKmC10qiq2S5oA1AEEqP
         A1ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmqkHDlAnWVJxPZ5tFmK62nNyyt7hOBJUZil9gFF8/nij2jCdQyDCKR75LE5KKISqvdHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ+b9UZM5avnwSMLqNfUlicxpsOVYMx6o1EBnJwSWxR5ptYhAX
	WRYV3Sl4/JwMi7HvFIqIGO7hclDD8mR6i8t8VlDiNqPmt1b2Xhifqp7kxQocPYBeF1iMPwCBul1
	QHAtirg==
X-Google-Smtp-Source: AGHT+IEqA/QiNyqu/E2QYf39DzVcxxyp+7qsmUCTcR5JkCtmLF6Gg2fzq88sjURjxp34pOpwKi25NkyDfxY=
X-Received: from pfbjc28.prod.google.com ([2002:a05:6a00:6c9c:b0:748:d9c7:291e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918d:b0:215:dbb0:2a85
 with SMTP id adf61e73a8af0-22cd2e919ccmr4500528637.0.1752066126241; Wed, 09
 Jul 2025 06:02:06 -0700 (PDT)
Date: Wed, 9 Jul 2025 06:02:04 -0700
In-Reply-To: <63f08c9e-b228-4282-bd08-454ccdf53ecf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707101029.927906-1-nikunj@amd.com> <20250707101029.927906-3-nikunj@amd.com>
 <aG0tFvoEXzUqRjnC@google.com> <63f08c9e-b228-4282-bd08-454ccdf53ecf@amd.com>
Message-ID: <aG5oTKtWWqhwoFlI@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com, 
	vaishali.thakkar@suse.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Nikunj A. Dadhania wrote:
> On 7/8/2025 8:07 PM, Sean Christopherson wrote:
> > On Mon, Jul 07, 2025, Nikunj A Dadhania wrote:
> >> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
> >> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
> >> guests. Disable interception of this MSR when Secure TSC is enabled. Note
> >> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
> >> hypervisor context.
> > 
> > ...
> > 
> >> @@ -4487,6 +4512,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
> >>  
> >>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
> >>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
> >> +
> >> +	if (snp_secure_tsc_enabled(svm->vcpu.kvm))
> >> +		svm_disable_intercept_for_msr(&svm->vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_RW);
> > 
> > KVM shouldn't be disabling write interception for a read-only MSR. 
> 
> Few of things to consider here:
> 1) GUEST_TSC_FREQ is a *guest only* MSR and what is the point in KVM intercepting writes
>    to that MSR.

Because there's zero point in not intercepting writes, and KVM shouldn't do
things for no reason as doing so tends to confuse readers.  E.g. I reacted to
this because I didn't read the changelog first, and was surprised that the guest
could adjust its TSC frequency (which it obviously can't, but that's what the
code implies to me).

>    The guest vCPU handles it appropriately when interception is disabled.
>
> 2) Guest does not expect GUEST_TSC_FREQ MSR to be intercepted(read or write), guest 
>    will terminate if GUEST_TSC_FREQ MSR is intercepted by the hypervisor:

But it's read-only, the guest shouldn't be writing.  If the vCPU handles #GPs
appropriately, then it should have no problem handling #VCs on bad writes.

> 38cc6495cdec x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests

That's a guest bug, it shouldn't be complaining about the host intercepting writes.

