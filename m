Return-Path: <kvm+bounces-51340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C3FAF639C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 22:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C6711C42B46
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C6E2F5084;
	Wed,  2 Jul 2025 20:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nn2j6vj7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5C71E9B3D
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 20:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751489852; cv=none; b=GO0nyay/uRlZ0fgf+ElGoe7nnP/IpLMVX1PGtyuIjP9FxbxgZInxFtiNtM4vwKLLxCDFLkmwLC4x3LUZE1VyxEiqHl7N1WKk6sCknof7uRK3bhz8QyD1YKN9pJGPxIVcTs9XM0T6E7HxVhJZ9ICwrnoUE4wNarPZVt1VmQmgTrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751489852; c=relaxed/simple;
	bh=KDcXOE1zhROiHK+fRoIz8A4aWDXPZSi9W8bZeIQIp2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y9bDTXl2wK61yPmM6pWSi1RlWDiPCIZgyMZe2kWSgAM9X1IPQae5stu2Xzlq4nmgOg9w94xAl0XDyqLP25BsSmelFh+eN6OjtCTdJlf6ZsNAgRiU4s2eHQXGQZNfkx44nW5jhnV5vcP6O90/N+usu5EnEr8asUJPkBGcFafzxu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nn2j6vj7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fdba7f818so5567432a12.2
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 13:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751489850; x=1752094650; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sW4QNQizmwSJEDRBMKEYI4xwGlCEtKex6a+194UsQcU=;
        b=nn2j6vj7lB1M+St5b7ynLC8TWX064VPvd1tM9pFRCzgiHVwj7Jl6Qg9rvjUuY+MCyA
         yd+Qazl8mDT5HE2Y3LIZw1Y2KWigLT0pXiLM4LOFMG3PuJobXUxRz1jB9XfAYK1oyixj
         jWKzyBqNUq7qOnxzKZFtSOjbIP1as0n/bLZOwewZFM1a1Omhc6o7gD2OPpejay7YGDI5
         LN25vAlm/NdRnxiOFIKHr1zg3sTgCM1QrD2N4RLtFBVSfELz36pzO3hlpwUHMz0HRP7e
         sh7gneqX6ODWBpX14Koif8FjCHU/6wfflRWCgslhw/iSUyPc6XzCkudZvjzoi6yMqdDE
         AU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751489850; x=1752094650;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sW4QNQizmwSJEDRBMKEYI4xwGlCEtKex6a+194UsQcU=;
        b=gbzkllCtP0ntO4rMhAERHt6nrlZNC+dDZUFMGgcOagg5TUYQwZ4mKul51jCN3iG5cM
         hp/IdKvmWXDT+nJtQ0J//a3tIQn10aNWLp67OQZSSAM/WfchMAFBE4Dt4ccGXJKJcSFp
         TG55MUk7KO6jcwXAib7rShSWmLR4DPZYqxKVN51vzT8qgsqHfsUrl72AvcIjKD3pd59p
         8ADPgHXw2L19B0cXv8rIyolO3kRZspaDXPVYesDWZr28v9f4SxcTvG+AYi/tWbNH7SJG
         F0dvwdce09Pgy42EnwCbSFU7Nqim4bit/HrYVaUhHwYY2Ao8XbP16iagN7oU3yoDrnPf
         KFqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSmCm/GCNo6J/sGh3x411aG1kC3yXMBeGw1GfO7JmtHQtiwavAFTF1unH05pohrGC4hPw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9/5Hg0nDkM25VmScBFyHRgjvk2Kx/lXgOYkzwCF7pryxnq2D+
	K3BBjUBD9wwQk7A9SWWAa6DX/HkDVUZfpKV/OdwqkK0UsGlwu2I/MFO7kjkkrWaW/SPjSGUSqOM
	wuSo5tsRw3oifnV3Ii5v3g3fDfw==
X-Google-Smtp-Source: AGHT+IFb6SLIfuP52bs7wPWNruqTvRPL2KxyKrl6XOJ9FUw5uFkFZJRds7UighTHcqwZzHj8XWrac1IRDdOAVI0Q4w==
X-Received: from pghq9.prod.google.com ([2002:a63:e209:0:b0:b36:36f4:9862])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:6199:b0:215:ead1:b867 with SMTP id adf61e73a8af0-222d7de178bmr7733706637.14.1751489849762;
 Wed, 02 Jul 2025 13:57:29 -0700 (PDT)
Date: Wed, 02 Jul 2025 13:57:28 -0700
In-Reply-To: <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
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
 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com> <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
Message-ID: <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Tue, 2025-07-01 at 14:48 -0700, Ackerley Tng wrote:
>> Perhaps we had different understandings of f/g :P
>
> Ah yes, I thought you were saying that guestmemfd would use poison intern=
ally
> via some gmem_buggy_page() or similar. I guess I thought it is more of
> guestmemfd's job. But as Yan pointed out, we need to handle non gmem page=
 errors
> too. Currently we leak, but it would be nice to keep the handling symmetr=
ical.
> Which would be easier if we did it all in TDX code.
>

I meant to set HWpoison externally from guest_memfd because I feel that
it is a separate thing. Unmap failures are similar to discovering a
memory error. If setting HWpoison on memory error is external to
guest_memfd, setting HWpoison on unmap failure should also be
conceptually external to guest_memfd.

After Yan pointed out that non-guest_memfd page errors need to be
handled, it aligns with the idea that setting HWpoison is external to
guest_memfd.

I agree keeping the handling symmetrical would be best, so in both cases
the part of KVM TDX code that sees the unmap failure should directly set
HWpoison and not go through guest_memfd.

>>=20
>> I meant that TDX module should directly set the HWpoison flag on the
>> folio (HugeTLB or 4K, guest_memfd or not), not call into guest_memfd.
>>=20
>> guest_memfd will then check this flag when necessary, specifically:
>>=20
>> * On faults, either into guest or host page tables=20
>> * When freeing the page
>> =C2=A0=C2=A0=C2=A0 * guest_memfd will not return HugeTLB pages that are =
poisoned to
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 HugeTLB and just leak it
>> =C2=A0=C2=A0=C2=A0 * 4K pages will be freed normally, because free_pages=
_prepare() will
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check for HWpoison and skip freeing, from=
 __folio_put() ->
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free_frozen_pages() -> __free_frozen_page=
s() ->
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free_pages_prepare()
>> * I believe guest_memfd doesn't need to check HWpoison on conversions [1=
]
>>=20
>> [1] https://lore.kernel.org/all/diqz5xghjca4.fsf@ackerleytng-ctop.c.goog=
lers.com/
>
> If a poisoned page continued to be used, it's a bit weird, no?=20

Do you mean "continued to be used" in the sense that it is present in a
filemap and belongs to a (guest_memfd) inode?

A poisoned page is not faulted in anywhere, and in that sense the page
is not "used". In the case of regular poisoning as in a call to
memory_failure(), the page is unmapped from the page tables. If that
page belongs to guest_memfd, in today's code [2], guest_memfd
intentionally does not truncate it from the filemap. For guest_memfd,
handling the HWpoison at fault time is by design; keeping it present in
the filemap is by design.

In the case of TDX unmap failures leading to HWpoison, the only place it
may remain mapped is in the Secure-EPTs. I use "may" because I'm not
sure about how badly the unmap failed. But either way, the TD gets
bugged, all vCPUs of the TD are stopped, so the HWpoison-ed page is no
longer "used".

[2] https://github.com/torvalds/linux/blob/b4911fb0b060899e4eebca0151eb56de=
b86921ec/virt/kvm/guest_memfd.c#L334

> It could take an
> #MC for another reason from userspace and the handling code would see the=
 page
> flag is already set. If it doesn't already trip up some MM code somewhere=
, it
> might put undue burden on the memory failure code to have to expect repea=
ted
> poisoning of the same memory.
>

If it does take another #MC and go to memory_failure(), memory_failure()
already checks for the HWpoison flag being set [3]. This is handled by
killing the process. There is similar handling for a HugeTLB
folio. We're not introducing anything new by using HWpoison; we're
buying into the HWpoison framework, which already handles seeing a
HWpoison when handling a poison.

[3] https://github.com/torvalds/linux/blob/b4911fb0b060899e4eebca0151eb56de=
b86921ec/mm/memory-failure.c#L2270

>>=20
>> > What about a kvm_gmem_buggy_cleanup() instead of the system wide one. =
KVM calls
>> > it and then proceeds to bug the TD only from the KVM side. It's not as=
 safe for
>> > the system, because who knows what a buggy TDX module could do. But TD=
X module
>> > could also be buggy without the kernel catching wind of it.
>> >=20
>> > Having a single callback to basically bug the fd would solve the atomi=
c context
>> > issue. Then guestmemfd could dump the entire fd into memory_failure() =
instead of
>> > returning the pages. And developers could respond by fixing the bug.
>> >=20
>>=20
>> This could work too.
>>=20
>> I'm in favor of buying into the HWpoison system though, since we're
>> quite sure this is fair use of HWpoison.
>
> Do you mean manually setting the poison flag, or calling into memory_fail=
ure(),
> and friends?

I mean manually setting the poison flag.

* If regular 4K page, set the flag.
* If THP page (not (yet) supported by guest_memfd), set the poison flag
  on the specific subpage causing the error, and in addition set THP'S has_=
hwpoison
  flag
* If HugeTLB page, call folio_set_hugetlb_hwpoison() on the subpage.

This is already the process in memory_failure() and perhaps some
refactoring could be done.

I think calling memory_failure() would do too much, since in addition to
setting the flag, memory_failure() also sometimes does freeing and may
kill processes, and triggers the users of the page to further handle the
HWpoison.

> If we set them manually, we need to make sure that it does not have
> side effects on the machine check handler. It seems risky/messy to me. Bu=
t
> Kirill didn't seem worried.
>

I believe the memory_failure() is called from the machine check handler:

DEFINE_IDTENTRY_MCE(exc_machine_check)
  -> exc_machine_check_kernel()
     -> do_machine_check()
        -> kill_me_now() or kill_me_maybe()
           -> memory_failure()

(I might have quoted just one of the paths and I'll have to look into it
more.)

For now, IIUC setting the poison flag is a subset of memory_failure(), whic=
h is a
subset of what the machine check handler does.

memory_failure() handles an already poisoned page, so I don't see any
side effects.

I'm happy that Kirill didn't seem worried :) Rick, let me know if you
see any specific risks.

> Maybe we could bring the poison page flag up to DavidH and see if there i=
s any
> concern before going down this path too far?
>

I can do that. David's cc-ed on this email, and I hope to get a chance
to talk about handling HWpoison (generally, not TDX specifically) at the
guest_memfd bi-weekly upstream call on 2025-07-10 so I can bring this up
too.

>>=20
>> Are you saying kvm_gmem_buggy_cleanup() will just set the HWpoison flag
>> on the parts of the folios in trouble?
>
> I was saying kvm_gmem_buggy_cleanup() can set a bool on the fd, similar t=
o
> VM_BUG_ON() setting vm_dead.

Setting a bool on the fd is a possible option too. Comparing an
inode-level boolean and HWpoison, I still prefer HWpoison because

1. HWpoison gives us more information about which (sub)folio was
   poisoned. We can think of the bool on the fd as an fd-wide
   poisoning. If we don't know which subpage has an error, we're forced
   to leak the entire fd when the inode is released, which could be a
   huge amount of memory leaked.
2. HWpoison is already checked on faults, so there is no need to add an
   extra check on a bool
3. For HugeTLB, HWpoison will have to be summarized/itemized on merge/split=
 to handle
   regular non-TDX related HWpoisons, so no additional code there.

> After an invalidate, if gmem see this, it needs to
> assume everything failed, and invalidate everything and poison all guest =
memory.
> The point was to have the simplest possible handling for a rare error.

I agree a bool will probably result in fewer lines of code being changed
and could be a fair first cut, but I feel like we would very quickly
need another patch series to get more granular information and not have
to leak an entire fd worth of memory.

Along these lines, Yan seems to prefer setting HWpoison on the entire
folio without going into the details of the exact subfolios being
poisoned. I think this is a possible in-between solution that doesn't
require leaking the entire fd worth of memory, but it still leaks more
than just where the actual error happened.

I'm willing to go with just setting HWpoison on the entire large folio
as a first cut and leak more memory than necessary (because if we don't
know which subpage it is, we are forced to leak everything to be safe).

However, this patch series needs a large page provider in guest_memfd, and
will only land either after THP or HugeTLB support lands in
guest_memfd.

For now if you're testing on guest_memfd+HugeTLB,
folio_set_hugetlb_hwpoison() already exists, why not use it?

> Although
> it's only a proposal. The TDX emergency shutdown option may be simpler st=
ill.
> But killing all TDs is not ideal. So thought we could at least consider o=
ther
> options.
>
> If we have a solution where TDX needs to do something complicated because
> something of its specialness, it may get NAKed.

Using HWpoison is generic, since guest_memfd needs to handle HWpoison
for regular memory errors anyway. Even if it is not a final solution, it
should be good enough, if not for this patch series to merge, at least
for the next RFC of this patch series. :)

> This is my main concern with the
> direction of this problem/solution. AFAICT, we are not even sure of a con=
crete
> problem, and it appears to be special to TDX. So the complexity budget sh=
ould be
> small. It's in sharp contrast to the length of the discussion.












































