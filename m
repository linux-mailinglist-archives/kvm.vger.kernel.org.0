Return-Path: <kvm+bounces-59789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id ABCB7BCEA78
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 23:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 84A0C4E6FEF
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 21:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D284303CAC;
	Fri, 10 Oct 2025 21:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJvWe1yQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F217330217C
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 21:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760133444; cv=none; b=t3FqenCifYvY8ZA4ouwo9m5ZVa0AKYmTcTG+zTXw7n6F18Pi0Bu+zndLiR9EEiOXZrpW81ywzXoidU+kf2SgwIlQRDdwT1xyhVoiA9mCqMsT41tljoMiNg8ilHP3pFZDZBFwaxj7glsmpkG4U3AO2LSIB+qbfi8MG75lDrkMwwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760133444; c=relaxed/simple;
	bh=OchTJI3OKmIuGRn9ia+kNVrtM0wvn+l48VZjq+onpdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j9h+8m7EspA8KVhXUh6HVINtfIEnvEcNTuWjcNcKJEbiWu8U/ertnOqsOMRPzyzPAuDRb2JDecYvTGIYckixe/pMhp0q54dFWhzn1OXro7YWZ6Q98VPxZxBNBzsKy++SJ/uUtCHLD7KnO+sEBP5NTRarh7vy3q4s1hl748mvo3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJvWe1yQ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7821487d16bso8141162b3a.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760133441; x=1760738241; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+CjJmSa/xDKPrpCplLdbCAjMTmIn7FLY2jt9GfKsc0c=;
        b=IJvWe1yQpKlfkYpQjp4iXCKPF1nNyGdEn70HGxcBvkmzna1HFIbDgScVeEbLiOADC9
         jouP7CDfdG4zDGVpwOEKAyz6ONPUztsGLhVti8TJyoF3KN4acgTguKc8WuZ5GFN6iNPG
         c7kkV6ZCkOoF4DtRvh6Une4oRCGmYqWNGaos1wktCvMN7mcJnrIzvl+1OJA3grNximqs
         4hJ7qGtmd4k4Eno+TQv47CBpjdHntOn46T8c83Zx90hjb8Uzwvgnv9mgYgYRoZazDYoB
         1TZzlUhLqFeF1yji5wbdGBSmGwHjE5amUJn8PMrN9EkODHzHOvnTQiyD9xsHXnXNzbaY
         ZAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760133441; x=1760738241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+CjJmSa/xDKPrpCplLdbCAjMTmIn7FLY2jt9GfKsc0c=;
        b=PZrrrranKcoTzIZARS9jWMcGqZo5xhh/PEVRh847+Dt8Gv9IwfKZJZPY0tGYiJIeqc
         034q5iatli1eEBbRMjH4vcaWAGTDiogm4cIWVysg3JsDcEjzmNKYYu4pAPwJMB6J08ss
         j/Vy1iSEeRAbte52rdcbgZgwf4SDwBMgScE5UEbfajl9Ij/I1IunOvW4iUOfQJ8r+2ah
         //eqF1GeML0aP9xI7muTRX8R+CWUyyZ+VA95Q1syfoHwmrP8eysJqHTbNVVYVFtAdkD+
         vI1dlgCRcpkisqoQAEvHSgEPep5wEyyxIX1U4OW0XJBb+IRd4Bt/dV9BHi+C+6khIhEK
         tiNA==
X-Forwarded-Encrypted: i=1; AJvYcCVSHgTS8PRjTHS9XlIl0xkSNdNgNgH1SHoRvNVpCZytfRXTiPEdW8cz3/jjQ8IdPvb8LGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt2MVbKSbOUZjvI+GbdWdi/3HyPY9Pd0x47GmR4VwuqT6X8GGX
	HFQlnCNLgM5Wlo3AWpMZ8H3BB/nyHsaUdWyfcVb6WEL4rsFejxYnu8KMQ+d6zoloNqG9IyQ2VIG
	lY0hhOMtaqwsm6C/MTzn7MkOrMw==
X-Google-Smtp-Source: AGHT+IGYgyBc6HexQmAe6kTYgJMM1MjLeDik4f5tZp5udMaitkKnqtOlleS/fc4L8ze18sw7c/5OQ0YI+1OxGD54kg==
X-Received: from pjbfs19.prod.google.com ([2002:a17:90a:f293:b0:330:9af8:3e1d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:244b:b0:325:b6b:9f80 with SMTP id adf61e73a8af0-32da845fdffmr19296952637.43.1760133441208;
 Fri, 10 Oct 2025 14:57:21 -0700 (PDT)
Date: Fri, 10 Oct 2025 14:57:19 -0700
In-Reply-To: <aOltikRvKzCy1DXN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-6-seanjc@google.com>
 <diqzo6qfhgc9.fsf@google.com> <e9bd02ba-ff0e-47a3-a12e-9a53717dde9b@amd.com> <aOltikRvKzCy1DXN@google.com>
Message-ID: <diqzv7kmfmio.fsf@google.com>
Subject: Re: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Oct 10, 2025, Shivank Garg wrote:
>> >> @@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >>  	return r;
>> >>  }
>> >>  
>> >> +static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
>> >> +						   pgoff_t index)
>> > 
>> > How about kvm_gmem_get_index_policy() instead, since the policy is keyed
>> > by index?
>
> But isn't the policy tied to the folio?  I assume/hope that something will split
> folios if they have different policies for their indices when a folio contains
> more than one page.  In other words, how will this work when hugepage support
> comes along?
>
> So yeah, I agree that the lookup is keyed on the index, but conceptually aren't
> we getting the policy for the folio?  The index is a means to an end.
>

I think the policy is tied to the index.

When we mmap(), there may not be a folio at this index yet, so any folio
that gets allocated for this index then is taken from the right NUMA
node based on the policy.

If the folio is later truncated, the folio just goes back to the NUMA
node, but the memory policy remains for the next folio to be allocated
at this index.

>> >> +{
>> >> +#ifdef CONFIG_NUMA
>> >> +	struct mempolicy *mpol;
>> >> +
>> >> +	mpol = mpol_shared_policy_lookup(&gi->policy, index);
>> >> +	return mpol ? mpol : get_task_policy(current);
>> > 
>> > Should we be returning NULL if no shared policy was defined?
>> > 
>> > By returning NULL, __filemap_get_folio_mpol() can handle the case where
>> > cpuset_do_page_mem_spread().
>> > 
>> > If we always return current's task policy, what if the user wants to use
>> > cpuset_do_page_mem_spread()?
>> > 
>> 
>> I initially followed shmem's approach here.
>> I agree that returning NULL maintains consistency with the current default
>> behavior of cpuset_do_page_mem_spread(), regardless of CONFIG_NUMA.
>> 
>> I'm curious what could be the practical implications of cpuset_do_page_mem_spread()
>> v/s get_task_policy() as the fallback?
>
> Userspace could enable page spreading on the task that triggers guest_memfd
> allocation.  I can't conjure up a reason to do that, but I've been surprised
> more than once by KVM setups.
>
>> Which is more appropriate for guest_memfd when no policy is explicitly set
>> via mbind()?
>
> I don't think we need to answer that question?  Userspace _has_ set a policy,
> just through cpuset, not via mbind().  So while I can't imagine there's a sane
> use case for cpuset_do_page_mem_spread() with guest_memfd, I also don't see a
> reason why KVM should effectively disallow it.
>
> And unless I'm missing something, allocation will eventually fallback to
> get_task_policy() (in alloc_frozen_pages_noprof()), so by explicitly getting the
> task policy in guest_memfd, KVM is doing _more_ work than necessary _and_ is
> unnecessarily restricting usersepace.
>
> Add in that returning NULL would align this code with the ->get_policy hook (and
> could be shared again, I assume), and my vote is definitely to return NULL and
> not get in the way.

... although if we are going to return NULL then we can directly use
mpol_shared_policy_lookup(), so the first discussion is moot.


Though looking slightly into the future, shareability (aka memory
attributes or shared/private state within guest_memfd inodes) are also
keyed by index, and is a property of the index and not the folio (since
shared/private state is defined even before folios are allocated for a
given index.

