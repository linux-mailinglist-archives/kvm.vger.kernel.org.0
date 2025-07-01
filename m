Return-Path: <kvm+bounces-51226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C328CAF05F4
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 23:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5B931C203E8
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F25283FD4;
	Tue,  1 Jul 2025 21:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2RrCxWNN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A933223DFB
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751406539; cv=none; b=atDtmaqtUBZsdDFy6KmGR+st1N7ZgPGo4xm4rX+LgYpXiiJaYz7Azj8XA5Xgf/ycaCoiA5EgauOh4B/RhAxSwRi+M3sKN3LNge5cgRxLja9VIXyHdoJPCAfm8VDahTKVdPem0WwEmKuOo4onm+gdtXNctkqpJKtZfRxWfZDn2m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751406539; c=relaxed/simple;
	bh=MhBzcmRs4IbfRWvXPt/N6EYZPgvX5eYGeFtXHWVxwhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q+/tulRM6MWwaapsp4NeFWDy9mq+r5Z0PyqCE1ZLuVzTD51Sjqobmoz8nbQC0KHhhFFBDKUr0CpfQBm0RPLbN7FU56xp2Pv4GpTgPfFLfwlgm9L/Hf1reJJso49iNy01gTTohHwK+1RsFbxs2smzBjjr3c1eOfqqFwBZ+lagagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2RrCxWNN; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74880a02689so5131308b3a.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 14:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751406537; x=1752011337; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JVZ4nZhVYWad2CbXoDJ3BSKbLb9HI8Q+JMXYt3i56nA=;
        b=2RrCxWNN5QSMXMPHnWSoqOdkh9ufz7M11PsiwyocYOQ4QHpNc440fdv0qcJicqD0kL
         lXg5XdpyBM3aaTQeAbMDrP024yMtT7C6jz8ShY8CaO0fBwjNch2Gefgn0OXgL6IF07xd
         Vbb5cwTH6iUyiOFHAcvunbMZK21Q1/ZhMDGlXWzdfXX2d5Jrr62lcqUcXW1/x9fKkJs1
         A3imWjXv0oAGdpQPdeo0Ln0nSjtjykiVh3SIClor82XO9Ta/LxxIpG+rM2+IGusQtowT
         KDMMtArV5EA5IizsTXkWjMvnKDkjBbC5wYAU7VTwKI0QlHwJdhGd7HM/tmxJsycN0JXk
         lMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751406537; x=1752011337;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JVZ4nZhVYWad2CbXoDJ3BSKbLb9HI8Q+JMXYt3i56nA=;
        b=rHTsT76/5wvvSl1ciktrJWt0maE4FhdvwrwJl0w97Jf/hA2EGJmHnu3d83HhlSsbkl
         TOE8PdTGjSnFlikPDsbw6yaHJyxMZbBfHcsVbrART1GrTUmcewxhNzi2UYfINUVHjgZi
         qWhIMYlgtZ/1OSvbaIjGfLLM0Mmo+w0ffs0QoReJDTMuCXYiv7ONfzTZhpFkj5nPygR/
         rDtVZr//gx2fkSKAmfnQBe37SPx4YvRqkomgAnKisHVk1Iirnt/CLz5b5PiFJptWdNSl
         WbJDgf4d7Frj6X6kt4w7Hwip8K+Kg5Vk5ThSpOpE4z1oFN9GmzkViNRn4NisrllVnCjs
         r/bQ==
X-Forwarded-Encrypted: i=1; AJvYcCXayL1GYEx4086/sKUxpdYTT/jbalV6du4WFesPTm2K/lnY+S74DC3qJ/4ynDpBE47+y28=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhgS/RkMxygEJXXLn+72Azujae0dQhyIQyazLP6Y8Nl41Ew5nH
	uQDLsNaHtX3RWcZa8OLRdv41TyPfZwXlKBj8AaUbA1ujWEH+BrEpkyreyZ61tGokKzegA0HR6nI
	OCgHC1YKKX3Ev7ZNPmOqGCcu1NA==
X-Google-Smtp-Source: AGHT+IEqcUpBnNJRKMdnLvZ2ZSUMUS2quj2Z66sgnJlgrefu2emFNr4Z97aJIzGPcQ4MClhKH9r+grsT8hfglCP6lg==
X-Received: from pfbbx9.prod.google.com ([2002:a05:6a00:4289:b0:747:a97f:513f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:889:b0:742:a77b:8c3 with SMTP id d2e1a72fcca58-74b50e69a06mr725062b3a.4.1751406536971;
 Tue, 01 Jul 2025 14:48:56 -0700 (PDT)
Date: Tue, 01 Jul 2025 14:48:54 -0700
In-Reply-To: <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com> <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com> <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
Message-ID: <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Tue, 2025-07-01 at 13:01 +0800, Yan Zhao wrote:
>> > Maybe Yan can clarify here. I thought the HWpoison scenario was about =
TDX
>> > module
>> My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() wa=
s hit
>> in
>> TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged o=
n and
>> about to tear down.
>>=20
>> So, it could be due to KVM or TDX module bugs, which retries can't help.
>
> We were going to call back into guestmemfd for this, right? Not set it in=
side
> KVM code.
>

Perhaps we had different understandings of f/g :P

I meant that TDX module should directly set the HWpoison flag on the
folio (HugeTLB or 4K, guest_memfd or not), not call into guest_memfd.

guest_memfd will then check this flag when necessary, specifically:

* On faults, either into guest or host page tables=20
* When freeing the page
    * guest_memfd will not return HugeTLB pages that are poisoned to
      HugeTLB and just leak it
    * 4K pages will be freed normally, because free_pages_prepare() will
      check for HWpoison and skip freeing, from __folio_put() ->
      free_frozen_pages() -> __free_frozen_pages() ->
      free_pages_prepare()
* I believe guest_memfd doesn't need to check HWpoison on conversions [1]

[1] https://lore.kernel.org/all/diqz5xghjca4.fsf@ackerleytng-ctop.c.googler=
s.com/

> What about a kvm_gmem_buggy_cleanup() instead of the system wide one. KVM=
 calls
> it and then proceeds to bug the TD only from the KVM side. It's not as sa=
fe for
> the system, because who knows what a buggy TDX module could do. But TDX m=
odule
> could also be buggy without the kernel catching wind of it.
>
> Having a single callback to basically bug the fd would solve the atomic c=
ontext
> issue. Then guestmemfd could dump the entire fd into memory_failure() ins=
tead of
> returning the pages. And developers could respond by fixing the bug.
>

This could work too.

I'm in favor of buying into the HWpoison system though, since we're
quite sure this is fair use of HWpoison.

Are you saying kvm_gmem_buggy_cleanup() will just set the HWpoison flag
on the parts of the folios in trouble?

> IMO maintainability needs to be balanced with efforts to minimize the fal=
lout
> from bugs. In the end a system that is too complex is going to have more =
bugs
> anyway.
>
>>=20
>> > bugs. Not TDX busy errors, demote failures, etc. If there are "normal"
>> > failures,
>> > like the ones that can be fixed with retries, then I think HWPoison is=
 not a
>> > good option though.
>> >=20
>> > > =C2=A0 there is a way to make 100%
>> > > sure all memory becomes re-usable by the rest of the host, using
>> > > tdx_buggy_shutdown(), wbinvd, etc?
>>=20
>> Not sure about this approach. When TDX module is buggy and the page is s=
till
>> accessible to guest as private pages, even with no-more SEAMCALLs flag, =
is it
>> safe enough for guest_memfd/hugetlb to re-assign the page to allow
>> simultaneous
>> access in shared memory with potential private access from TD or TDX mod=
ule?
>
> With the no more seamcall's approach it should be safe (for the system). =
This is
> essentially what we are doing for kexec.

