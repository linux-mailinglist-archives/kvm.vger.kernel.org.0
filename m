Return-Path: <kvm+bounces-37273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40DE9A27BB9
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01DA6188023C
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 19:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79184219EAB;
	Tue,  4 Feb 2025 19:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DyPTvswa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C432054F0
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 19:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698184; cv=none; b=ikeP9Z6SQoN1h1UPAX3gZwE9VciuA7PJESyy3AjlpvB+7xqFLT63eS8VDe4x1SNSt/TSU13w2kL6SbSV9A9E7ObsPt4cLMo6DsY8JOkYN8eYBHIedJkEz3W0ZW6H7tF0A94Hf8ChyLNbCQtwYsxvOKAvJ3v5pzS3eLE7CBE9tZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698184; c=relaxed/simple;
	bh=evhtNLT7qrEB/f0LsSGunk0SU0xDbeT6mUcieT4SQzs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oXgoh1qBULxy8EwWL3RSviC1T4ZuIu8j+3US0Wkf8WCN7adztZV3vya+oVGiFu9ZvQjj4lMxCVDjukdpaXK7vB0TF68Jr2FU90cnC4h7bYmNKQTw/FpWzCsH3HutHEYhMlbYLUm+0tnnfTb0hCZukBGRZbSmELFsubucLZroz6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DyPTvswa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738698181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lm77+J+FSsd7jyuwQ676pRUYyyJaAZq7OUEXpDi3H4w=;
	b=DyPTvswahDo32VpqRJGrc4NdeOFNplzy6qdkHL9B3IURWbsdDqqNy+fw+WenxDoZ1Q3VBq
	aCXGEkMPKXpp4o1ojJdylbKtHkZ0dYYxMpxS6ySDVKP4cYglxqPmdfIl6I2bACRYFhhup5
	aefdmuvyAE90aBCukAmHXOSuUCulch0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-qvj9D0FaNCe1bPlSQFICnw-1; Tue, 04 Feb 2025 14:42:58 -0500
X-MC-Unique: qvj9D0FaNCe1bPlSQFICnw-1
X-Mimecast-MFC-AGG-ID: qvj9D0FaNCe1bPlSQFICnw
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b6ecd22efbso23771585a.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 11:42:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698178; x=1739302978;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lm77+J+FSsd7jyuwQ676pRUYyyJaAZq7OUEXpDi3H4w=;
        b=ZYx1fiMtMpcksGqnqt/jiqmh0Db0LTh9fLA0Kpmdm/fDIg5/kATr2CcBrHQEiPE91r
         TfE+ZeON8MIw/hjvhSfawvcfOOuR68oPZYSISNRYhKLBLZfnoGYRGM7JfA0BC8Qdb5LP
         rdvCfo8l0XaTBQl7DMXq277EO7lHtWxQfEoZ+Quki8JOhwf5ayHJCNRtUhP92/01Vy2g
         nw2QxSPwRlV+TLlB6PkjyE4n9UCQ4iVR/OQzLCM3o3UmOyUWxNnBRWEtZMChx74kjGGx
         2MgWKnksiBx+DCBXMHGJAwObLN1h2zERkfB/qJEWLzABrb3p393x1fLn/N1UNF6UaD4t
         zRaw==
X-Gm-Message-State: AOJu0YyZr3Fgh6PukcLKvoDP4CgKhHFjpPKHRey8RKzLG02gECz4Y6sQ
	Nxrg3FMEwmu0dwzusXnCqPoybc+JP9YuENtOxK2DBg4TN0Cmu5ytRAy7Oky+2veZiWDi8x7H5xS
	RBOZnm4fSTmvFTNhDijaqj6EJJ8egu3qv41tezXeul87XP0m2QQ==
X-Gm-Gg: ASbGncv866pQbV5DjWbhTuy9Plkr1/CJml9zNDG9meTlwcbrmquAMlmdC1+JB7bG8C2
	Gj/rLBsI9CQHwPCEtil6Uo5EU/gJQWjdN/bISk0sbw8zBDSu3GJnEZgbuDc0Vr6mYQWw9lCTJbu
	9c7xb3Bpzfb9padx1wivfts0vrNTzkn92rBWjVDoYUOlUM7PyIDj1w907AGxQETZ+zXLBIRMkIm
	qzF6Vg67HqmHJSIAAsDxUloSddvnOSIGO3d9TVVZ7Efwwh2LFLrIpwFX/hMZJfzwYap1fmNAIwc
	9jd/
X-Received: by 2002:a05:620a:8395:b0:7b6:dd89:d86f with SMTP id af79cd13be357-7c039b65ff2mr28088485a.24.1738698178062;
        Tue, 04 Feb 2025 11:42:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1kXnH0DVm+wAP+GkN7ZGmKIwC+BKKALxPN58aJSVkKJ6kQ+N7rq8ui6rYX6/trXwNmJyP4g==
X-Received: by 2002:a05:620a:8395:b0:7b6:dd89:d86f with SMTP id af79cd13be357-7c039b65ff2mr28085685a.24.1738698177744;
        Tue, 04 Feb 2025 11:42:57 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a8c8fafsm669811385a.26.2025.02.04.11.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:42:56 -0800 (PST)
Message-ID: <da91fc38126227c227a4fe6b85cd630ca1ca8853.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: Remove use of apicv_update_lock when
 toggling guest debug state
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>,  Naveen N Rao <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Tue, 04 Feb 2025 14:42:55 -0500
In-Reply-To: <2d86cce9-88c2-4b2f-a8a6-ee33d0e1c98d@redhat.com>
References: <cover.1738595289.git.naveen@kernel.org>
	 <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
	 <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>
	 <a7eb34n6gkwg6kafh7r76tkwtweuflyfoczgxya2k63al2qdoe@phmszu6ilk4w>
	 <Z6JTmvrkrLpaJ1nw@google.com>
	 <2d86cce9-88c2-4b2f-a8a6-ee33d0e1c98d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-02-04 at 18:58 +0100, Paolo Bonzini wrote:
> On 2/4/25 18:51, Sean Christopherson wrote:
> > On Tue, Feb 04, 2025, Naveen N Rao wrote:
> > > On Mon, Feb 03, 2025 at 09:00:05PM -0500, Maxim Levitsky wrote:
> > > > On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> > > > > apicv_update_lock is not required when querying the state of guest
> > > > > debug in all the vcpus. Remove usage of the same, and switch to
> > > > > kvm_set_or_clear_apicv_inhibit() helper to simplify the code.
> > > > 
> > > > It might be worth to mention that the reason why the lock is not needed,
> > > > is because kvm_vcpu_ioctl from which this function is called takes 'vcpu->mutex'
> > > > and thus concurrent execution of this function is not really possible.
> > > 
> > > Looking at this again, that looks to be a vcpu-specific lock, so I guess
> > > it is possible for multiple vcpus to run this concurrently?
> > 
> > Correct.
> 
> And this patch is incorrect. Because there is a store and many loads, 
> you have the typical race when two vCPUs set blockirq at the same time
> 
> 	vcpu 0				vcpu 1
> 	---------------			--------------
> 	set vcpu0->guest_debug
> 					clear vcpu1->guest_debug
> 	read vcpu0->guest_debug
> 	read vcpu1->guest_debug	
> 	set inhibit
> 					read stale vcpu0->guest_debug
> 					read vcpu1->guest_debug
> 					clear inhibit
> 
> But since this is really a slow path, why even bother optimizing it?
> 
> Paolo
> 


Paolo, you are absolutely right! the vcpu mutex only prevents concurrent ioctl
on a same vcpu, but not on different vcpus, and without locking of course
this patch isn't going to work. The per-vcpu mutex is not something I know well,
and I only recently made aware of it, so I mixed this thing up.

So yes, some kind of lock is needed here.

Best regards,
     Maxim Levitsky


