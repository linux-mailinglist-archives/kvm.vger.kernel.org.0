Return-Path: <kvm+bounces-22179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD8593B5FD
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F5B41C23599
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96021662FB;
	Wed, 24 Jul 2024 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H9lkMMwX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAB82AE6C
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721842231; cv=none; b=uVqB5OfLRNuCBhS+8l2OeYESN1V0+ORRjH+jei5hgMud83Tz/c2Y9F88vYLFTtN5rBafLWuyAsd+RPtwHtTno1k/SiVH1pKLyveHQigCEdkzuOepYNgcQgb/bS0cyQ6yH4+lK1dShA8q8PkLooOLb+wSh+hwWofhF8DCatANVwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721842231; c=relaxed/simple;
	bh=tsPCi2L3qSxeelwjKZkBqG9a02Hi5u0iYpjphTj0ids=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cIWLkRladsD5W79Cn6p/MUGo3L+wYQdKQeFZ6DR37TSSJaAEw8YJ+egEblo8U9R5H5Yx9nkLV8GZLKmRezOPT5Kq4lgESETF1N9KHMTzpYHr5fP3tes/tANLHC6g8DZCgH65AeaNYj3RF7SJNZJofiKhVHHAH3eZxnKvdI3mWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H9lkMMwX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721842228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SMDCLFO3EloUla0zlTAIGGkjZf6G2W40HmQno6SR3TQ=;
	b=H9lkMMwXPbRbo4mvAAgYulO2idBEpKXFJMIM1GKkLylo2HMk8Gr51aQioZiD7QCGJXzgEN
	g4MRSxQGZFxDTH5W4qsADP36/tydKh9SNo9xBDitlLLZ7JZ/DK/tC1KHaKfpKo3t/u3osM
	K/mW4NrNBpzQZgIfqJ3wLfX2AqYelCM=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-G9wFs8tbP5G7DuqDN9NapA-1; Wed, 24 Jul 2024 13:30:26 -0400
X-MC-Unique: G9wFs8tbP5G7DuqDN9NapA-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-49290a496c4so6416137.2
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721842224; x=1722447024;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SMDCLFO3EloUla0zlTAIGGkjZf6G2W40HmQno6SR3TQ=;
        b=b7U3tqrosdsOLR3Dd7Uq1cN6IZk3EQNt8p+cjpU2EsKG6Ja2OGyf1GoDpbOXzaMx8C
         7MH03pR7XiJEj3+bMmY6DoC/T2b9pr5UfPv9a+Pky2MKOdBkVFXapRwx1TfiLYK8pp+A
         VPklvSChbRB6PfUBZZc17TIuHZLqpz+VQSzTwfRnfQ13x866Ibej6FpE7XS313oREkno
         bpZX1HlVp5f43qkt9wBR3axZVUZp8w3/9yc3BJIofF+WqKvj3jeXvWLSZp8bP+tmcQpz
         dHkZ+0lJMllQ2ELEMMrtG/03czaQCX80Fi25dw690kjI/GvbWvOnTtZnJpRCy7Dctb9F
         Lk9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWBxobr/lVu7z9SLqukVvRC0Dz0wfV+NMVUWTdvhFYWbZKEBXLFV4d/ytWtoASJ2BGZ6cznfLsGZ20TnNfALUCqVGEG
X-Gm-Message-State: AOJu0YwOYZXBRD9Pg16RONnOyacquhjojRMkiz9PtlxdEmyRgJsIQq+O
	7EFYM4Tbbe1xZ/Al/++MNUd91DMTYo+wIw/2uBLlTf8+2J+rgnMNuS7HVvL/4VfAUqpRn6yTJ8t
	ta9Rq9Rsts1crNYK58RbTNTC/tp6SIIIUhuQ/p09zcioxgnYzEQ==
X-Received: by 2002:a05:6102:3c88:b0:48f:c2dd:3520 with SMTP id ada2fe7eead31-493d6461976mr446989137.11.1721842224428;
        Wed, 24 Jul 2024 10:30:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcmZ7mYC4SkAnQ3ys5NfQquMWHnqJRbJ/cE9fSDgz+ltmTsyGj/NjhY3A8OWt5JJj/eXONHA==
X-Received: by 2002:a05:6102:3c88:b0:48f:c2dd:3520 with SMTP id ada2fe7eead31-493d6461976mr446907137.11.1721842224002;
        Wed, 24 Jul 2024 10:30:24 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1d64194aasm3025485a.52.2024.07.24.10.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:30:23 -0700 (PDT)
Message-ID: <da3c92a68d3f60942f07dcf1a63b25e6bf3d3e6e.camel@redhat.com>
Subject: Re: [PATCH v2 10/49] KVM: x86: Drop now-redundant MAXPHYADDR and
 GPA rsvd bits from vCPU creation
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:30:22 -0400
In-Reply-To: <ZoxDqKdh37qpm-HQ@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-11-seanjc@google.com>
	 <ccbed564392478b3a5bb51b650a102ca474ba7e0.camel@redhat.com>
	 <ZoxDqKdh37qpm-HQ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 12:53 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > Drop the manual initialization of maxphyaddr and reserved_gpa_bits during
> > > vCPU creation now that kvm_arch_vcpu_create() unconditionally invokes
> > > kvm_vcpu_after_set_cpuid(), which handles all such CPUID caching.
> > > 
> > > None of the helpers between the existing code in kvm_arch_vcpu_create()
> > > and the call to kvm_vcpu_after_set_cpuid() consume maxphyaddr or
> > > reserved_gpa_bits (though auditing vmx_vcpu_create() and svm_vcpu_create()
> > > isn't exactly easy).  And even if that weren't the case, KVM _must_
> > > refresh any affected state during kvm_vcpu_after_set_cpuid(), e.g. to
> > > correctly handle KVM_SET_CPUID2.  In other words, this can't introduce a
> > > new bug, only expose an existing bug (of which there don't appear to be
> > > any).
> > 
> > IMHO the change is not as bulletproof as claimed:
> > 
> > If some code does access the uninitialized state (e.g vcpu->arch.maxphyaddr
> > which will be zero, I assume), in between these calls, then even though later
> > the correct CPUID will be set and should override the incorrect state set
> > earlier, the problem *is* that the mentioned code will have to deal with non
> > architecturally possible value (e.g maxphyaddr == 0) which might cause a bug
> > in it.
> > 
> > Of course such code currently doesn't exist, so it works but it can fail in
> > the future.
> 
> Similar to not consuming a null cpuid_entries, any such future bug should never
> escape developer testing since this is a very fixed sequence.  And practically
> speaking, completely closing these holes isn't feasible because it's impossible
> to initialize everything simultaneously, i.e. some amount of code will always
> need to execute with zero-initialized vCPU state.
> 
> > How about we move the call to kvm_vcpu_after_set_cpuid upward?
> 
> A drop-in replacement was my preference too, but it doesn't work.  :-/
> kvm_vcpu_after_set_cpuid() needs to be called after vcpu_load(), e.g. VMX's
> hook will do VMWRITE.
> 

Let it be then, but let's at least drop the part of the commit message after
'And even if that weren't the case', just not to confuse future reader,
because as I explained, this is not 100% bulletproof.

Best regards,
	Maxim Levitsky


