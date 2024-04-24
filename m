Return-Path: <kvm+bounces-15878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E0D8B16B0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 01:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F388C1C24F51
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 23:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E389016EC1E;
	Wed, 24 Apr 2024 23:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="308TfEim"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2190216EBE7
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 22:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713999602; cv=none; b=cO1r5Rk+/B9lebf5McS46gmybTJw34cI9/I7jA+ZXgR+Lw25tFfPpT4u9/CB5jRpceVcpIV12QaAIRONtyMHk7ofFrCc0oVdEirKXEMhxfPkSK1Fa0bqqUZdG0KRc9XyH5pRoBXqkXp3gxoJSI6+aasKngn/7jZbE+NE1ReOzRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713999602; c=relaxed/simple;
	bh=DqAQEHGDx6EY1b993wyDcxpyd3anFLT4vTfzBQtDgJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pcr9Ud9EdnS7AvLcsFhi9uVW22YfP1q/84LkliF4de3qE+qMhklwFygUqmPghFGKxPyUxvnmTo2rUBXQt3a1Tb3MlRkV9A56MKZfCjfAfMMYUdsgpAUvfVI6DvV1S1diba10x1aHDDUv0azb91PTn+kXpuxPTNtkrFYE7Sz38Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=308TfEim; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5c670f70a37so350477a12.2
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713999599; x=1714604399; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CPQuZuOq+EB+82vseydeL3MmBIwkyv7t/AeyvUHFOt0=;
        b=308TfEimuLnkpfRVOrYv07ACb1i4MW0YkblfTFvKsAJku8M9LW1prn2LG1ErqAORDm
         jJf6OPI6to43ypEM1jHqaFvzxXvzfpLFiwV6LKeHpmmWITo287h2/dRr7j18XuLRmsjx
         xOtI8BOS+KSXnViqeg2NI0W6dB5chgwVVOWwLh6+MPPBJh7n8fm9ZArELImF17WUTpvv
         JuLM9USYfZ6GSsMCEMd1TG1g7YQSCLaQPF0ffEN0vPlRJXsuN1jSPcqPDmP772Qrty75
         p7nlJZnwT1QewAYyNbGCvCoWzUAVrG60uAknMS3phnMEtn2LAvzjFATtF7c1XdQL7Pv7
         BTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713999599; x=1714604399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CPQuZuOq+EB+82vseydeL3MmBIwkyv7t/AeyvUHFOt0=;
        b=UUnc3Amleap4qEW8cgT+F/q6Ur1s1gc1ZW88lYGJW37lxRmNcIog9Tfk5IelU/yPU3
         pr/xONYnroNndeFAYv8HmygZHkr4n8kNdPDQ2uTj3B3na78SUX51GQykjRWs3olCT4S6
         VvJKj5wpMCt/uMprR5g4Uj/ChndikOzZiXxwrDb1a7pfDn2oDgokyVOL0I2udG/2KUH0
         pPj7LnbjFLiVS0FEJtZdkjqfuYSWBISASiQwHbfSM8a14Jk/dBqfs7v3OKZoKzaC6SY1
         nky4lXB6XszrjSSedKe3MpWVdGh6HxD/T+TjRydJYCWd6Fyl7zV0YU0cwBPeprc2ypH6
         JGXg==
X-Forwarded-Encrypted: i=1; AJvYcCXONKzsmSSzNe8mEGQQtttGgW0IiFnxMTuqmr3ER5nj1EXiAdLR4IJEY5oNZtYtCcW706gXZsJckBQd6FaEGjlRGyFN
X-Gm-Message-State: AOJu0Yyc35XAvmyU2BL7XlTjB6DORUQQjIhDh5StEHTjzB1xDFKJjMkh
	3G0wyvVslpVFOfaL01n3wcEZZ1rPQKEWEhJEQQz7Y0FTYWkJCSJP2ljb+Em8VUj+pQj++ru9HIU
	Pqg==
X-Google-Smtp-Source: AGHT+IE68lJ7PRaMFcV0k+cqap59rtrBp3DhH1/zb508mWTnJNRitx52m6b+OMU/P0pJH5TF1Mtzl7DxEZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4c13:0:b0:5f7:d61e:50e5 with SMTP id
 z19-20020a634c13000000b005f7d61e50e5mr46918pga.6.1713999599325; Wed, 24 Apr
 2024 15:59:59 -0700 (PDT)
Date: Wed, 24 Apr 2024 15:59:57 -0700
In-Reply-To: <ZimI8j9LIUsAArdD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-8-pbonzini@redhat.com>
 <ZimI8j9LIUsAArdD@google.com>
Message-ID: <ZimO7V2udx8KB2Li@google.com>
Subject: Re: [PATCH 07/11] KVM: guest_memfd: extract __kvm_gmem_get_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 24, 2024, Sean Christopherson wrote:
> On Thu, Apr 04, 2024, Paolo Bonzini wrote:
> > In preparation for adding a function that walks a set of pages
> > provided by userspace and populates them in a guest_memfd,
> > add a version of kvm_gmem_get_pfn() that has a "bool prepare"
> > argument and passes it down to kvm_gmem_get_folio().
> > 
> > Populating guest memory has to call repeatedly __kvm_gmem_get_pfn()
> > on the same file, so make the new function take struct file*.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  virt/kvm/guest_memfd.c | 38 +++++++++++++++++++++++---------------
> >  1 file changed, 23 insertions(+), 15 deletions(-)
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 486748e65f36..a537a7e63ab5 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -540,33 +540,29 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
> >  	fput(file);
> >  }
> >  
> > -int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > -		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
> > +static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
> > +		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
> 
> I genuinely don't know what it means to "prepare" a guest_memfd.  I see it becomes
> 
> 	if (!prepare)
> 		fgp_flags |= FGP_CREAT_ONLY;
> 
> but I find the name "prepare" to be extremely unhelpful.

Ah, I'm blind.  Maybe "do_prepare", or "do_arch_prepare"?  To make it clear that
it's a command, not a description of the operation (which is how I first read it).

And I feel like overloading it to also mean FGP_CREAT_ONLY when _not_ preparing
the memory is odd.

	if (prepare) {
		int r =	kvm_gmem_prepare_folio(inode, index, folio);
		if (r < 0) {
			folio_unlock(folio);
			folio_put(folio);
			return ERR_PTR(r);
		}
	}

Instead of "prepare" as a command, would it make sense to describe the "populating"
case?  Because I think it's more intuitive that populating _needs_ to operate on
new, unprepared data.

