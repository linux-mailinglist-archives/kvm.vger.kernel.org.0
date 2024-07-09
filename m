Return-Path: <kvm+bounces-21229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E514B92C394
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 21:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 810031F23670
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C531182A54;
	Tue,  9 Jul 2024 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Onux/iuN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F37D1B86D8
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720551649; cv=none; b=DVht2F4i3iE5gOEgF23nBpwaq9zWEwmZgiBCYu1U55jg2rVvfC4ymGbBq549YD4dQJuBA3Pq6Ma64IH0iZjtgY5DlYNAiyc9I/3D7yWQq0SiT3qsFrJ/YaZB/FzccHAKVIfVXOk2taxFbbSsCCJQitKM/YtBD09QuFG6n5J4tm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720551649; c=relaxed/simple;
	bh=KgHlg08ugzoAyJafomNsXB6uLitcla3YPdA6liNY/6M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ui/SU6U2GYV+C4dhND1KXBnFmj4ovv1xmZN5PC5F+KFFxXImqjPZgKf7ewxqBh/GSUyLG+lTDCIlgmtRQY3hbZmPz+urcfzsWjyMovJO6x6YdsxXf271ovGYDqSNbd7gkCugX6GjmoND2vmFFP0t77QpOrfi6rmRb6GSnynwpIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Onux/iuN; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-77f37c59abdso625842a12.2
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 12:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720551647; x=1721156447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B5ktds/3luYVxWenh7ZKPzZUqTBRwd2YZfHo67RxJG4=;
        b=Onux/iuNQAezqo8S9MU4adxgPBN2jG2Rp0qXHdQWDXktrxBpWX6Pe08Tpl05YgKLLQ
         r/o4v/MpmR+66SJvXqKDbhTIBlt9kBt8TVG2tVulYsXDOKJEenMR0SL/Pz6TY0yPplI2
         1bEaAPcw6KmZ6wU5N7zywhjb1uty0SWNDYVbK1FUyXcmo25TOqNm1sSEb6eQio1D2fRz
         2p2qXVgWzLjme4//lmMgMjcCCA6dcv0yHW2uu28Cim8cyHmmEbq6xg8oeLFPYCktNAAe
         RHtQhkGLcLP0PEMkdPBUYfhaEqBS5/vRiQd38TbKrsEbnWoVDlGI1Ir4tgoh2fvLndiU
         LORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720551647; x=1721156447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5ktds/3luYVxWenh7ZKPzZUqTBRwd2YZfHo67RxJG4=;
        b=mUHe54V6NNkiQgLtyAYK2QY0iAwDHIFbAzffXbxk6y5vB0IOCUHn35mQwi1273icIC
         s+q/EV3r1JK3vhKhWZEVAsArfjiQcTn9YKwlOD5M+8xMhqfcvc3LFySfwBmoX7296KlD
         Q9VaQksCeZ4hXx37GgD3rD7RRnIPJie9y8aqFFjZpNaOTWt6bLHuwu2X/5i8fg60EsGf
         umoH9wfRr1e6ZzAl0N303FvAxAwPum25oMbwoD59z9ERkVyX9PvhJ7rzSYUrvQy62rtG
         4U1w0rjVY8A1zn9BbTHYBp0XmVL9P6TGSaG18Zp3Hm98Qs5HXDWyFMjBVNgoggMPtyuO
         SnXw==
X-Forwarded-Encrypted: i=1; AJvYcCWXTkgvl+BXN5pkLkMrH+8XQ5XscvFRdQhx/QLFsV5USw8aNAB3wJci90fMH1WQDU1MSy7KqmfQr5tRCRhSO5idd6w2
X-Gm-Message-State: AOJu0YziMotsc2vqM9foYbqy46rSlNNXWJwllmDg2kbuGkoIOGYtM/ll
	mIHLtOHrzos8U+HQsyrnshEUmzMKqXKJKpLzJpol5t1BYcrnZVyo8JcOYNI6G78lTJ/KXyA/uhU
	Gmw==
X-Google-Smtp-Source: AGHT+IE3UNnwa6dMa0FwlUP5/4LrbcE8x0+b9LXSVdxKQ7jzCU3+gDYotGIrWaDhvj7SxN5jBJcinb7pt18=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:fd1:b0:6e8:bccc:a78a with SMTP id
 41be03b00d2f7-77dbe517f0bmr7012a12.12.1720551645769; Tue, 09 Jul 2024
 12:00:45 -0700 (PDT)
Date: Tue, 9 Jul 2024 12:00:44 -0700
In-Reply-To: <5b747a9dacb0ead3d16c71192df8a61e8545d0e6.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-30-seanjc@google.com>
 <5b747a9dacb0ead3d16c71192df8a61e8545d0e6.camel@redhat.com>
Message-ID: <Zo2I3FChU58bX7qH@google.com>
Subject: Re: [PATCH v2 29/49] KVM: x86: Remove unnecessary caching of KVM's PV
 CPUID base
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > Now that KVM only searches for KVM's PV CPUID base when userspace sets
> > guest CPUID, drop the cache and simply do the search every time.
> > 
> > Practically speaking, this is a nop except for situations where userspace
> > sets CPUID _after_ running the vCPU, which is anything but a hot path,
> > e.g. QEMU does so only when hotplugging a vCPU.  And on the flip side,
> > caching guest CPUID information, especially information that is used to
> > query/modify _other_ CPUID state, is inherently dangerous as it's all too
> > easy to use stale information, i.e. KVM should only cache CPUID state when
> > the performance and/or programming benefits justify it.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---

...

> > @@ -491,13 +479,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> >  	 * whether the supplied CPUID data is equal to what's already set.
> >  	 */
> >  	if (kvm_vcpu_has_run(vcpu)) {
> > -		/*
> > -		 * Note, runtime CPUID updates may consume other CPUID-driven
> > -		 * vCPU state, e.g. KVM or Xen CPUID bases.  Updating runtime
> > -		 * state before full CPUID processing is functionally correct
> > -		 * only because any change in CPUID is disallowed, i.e. using
> > -		 * stale data is ok because KVM will reject the change.
> > -		 */
> Hi,
> 
> Any reason why this comment was removed?

Because after this patch, runtime CPUID updates no longer consume other vCPU
state that is derived from guest CPUID.

> As I said earlier in the review.  It might make sense to replace this comment
> with a comment reflecting on why we need to call kvm_update_cpuid_runtime,
> that is solely to allow old == new compare to succeed.

Ya, I'll figure out a location and patch to document why KVM applies runtime
and quirks to the CPUID before checking.

> 
> >  		kvm_update_cpuid_runtime(vcpu);
> >  		kvm_apply_cpuid_pv_features_quirk(vcpu);

