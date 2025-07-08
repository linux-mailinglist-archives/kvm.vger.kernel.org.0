Return-Path: <kvm+bounces-51814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16729AFD998
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 23:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C6C77A5275
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 21:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79252245016;
	Tue,  8 Jul 2025 21:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IkSd7seH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F821A841A
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 21:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752009603; cv=none; b=uYThsn/Ivm8cYFGreAM/D4F6yVj3JVsGLDIcALPYfmTa8mjK0JXftlcRFSRzUEIyfsEHsKqCXbCr+S6XsvcU+YxqZdpYmxD+RjARkG0XHccgmCrlCTLZlgErFAoDlUV/DOn8odBJ/2CzaKfVxn2YCsY7JEpsum7hdMe0cV2lQxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752009603; c=relaxed/simple;
	bh=UWyDlS+zaUzSe1JsWsH9qLcZvUTqu++W/AAh7e8KU68=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FXKCbK5XjSMjwUrb1J6YOMy5zYxxO1XOMwgkHLEfVgujtZFUPJ3QkZLcvy6+GG6m9Csb6qyoK6rZEXCCpAn4xQrkKiQ5ImJUzQaLgcqQ94JnTgajWbdmE/p6qa3LL0S8rI98Gs85joGwLQbdXwvqYrL1dfgCpPzdvWIFJou5ihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IkSd7seH; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748e1e474f8so7268977b3a.2
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 14:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752009601; x=1752614401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X89Yr2KreICF0LmXhdEEooKcxvmc4FtZqWWId0QLeBE=;
        b=IkSd7seHxs4t/Pdxhh29bkw4y/xwHD7bNM+PgEDeXPKchjRa31fXAG8kLL90KcYuey
         V+k/LQKkm1VGqQyCtbwlpi+JjoJdvu5ses+TccmYeilXLxRzh0+ggqlN5Xkg0552E3gk
         l5jr67H9ORLIDH6xRa7oHghTtlZaIfcN6bZMpj/FgI2jYj7US7ieH7zJgQ0HwgM4JCV6
         +BGDqdv5qcdonrMkf1I0osMOlHrcw9hpS0ndlqmS29HhY5IYP1LVDobrIFo7gUs/isBN
         JYLdLTTm8iF97zkqOfIFebNHGIe8VOk1YDXJkaNr707nOVoRse0JDkELvUVL+gBxoyBB
         XuNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752009601; x=1752614401;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X89Yr2KreICF0LmXhdEEooKcxvmc4FtZqWWId0QLeBE=;
        b=fJIsTdQbh5jHdsiZUfaWUyYQpxAG+aD4tsUI6D09TC5PyKYOXVLlALdxrgJb4ll52C
         pM1Vx5jkW8SnJWoaer8USQkj91GRGdwCxqEJiCE6KSAlDj/U0KzcUA10oUZpt5SpkY+J
         Lj+xTk7NZkSfssmJZNZz6HCYEYSK2TJEr8D8huEzvXqKn6Y6q+XxzYZz0ShB8bFlYXkC
         xjz6aOVW9krGSfEca6v7hOVo4Eh4nM6rQn5yL5i4jmLL7iH7D1vaFSfpMb1ihT5drfj1
         VWfQzCHJRp8gdCXRfGpJ7CfNoVZyfabRwOfa++ZzWudtIGXydR+raFszScP4mHasmFkp
         4mMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOImHW6o1F7mmvilUTfwVEBnkSnb7X7aLM9MWZJEYoITDik+B0bS1rfgVF9+xE0B/32MU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiU2pP5NwA7E2C39eta0iQf08O+mICxGdz24ovZf4tfxAKJHtD
	8367dIvAHl6YMtb6Eds9k6WIrg6eUjbxzLFFQuzQB0hI2b0HcfsDw5Br8M9QxkGtvbkJ+gev+ks
	v4BD4MIMAIg1G4djguNjwaOTAcA==
X-Google-Smtp-Source: AGHT+IENh/vL4K7OksuWFKnRRTL+KzULe+0U9zQWD/Ko5h5hy2xps3p0biomDvUPy4thli2UjCa0/fo67nc2OO9jBg==
X-Received: from pfix4.prod.google.com ([2002:aa7:9a84:0:b0:748:f030:4e6a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3e26:b0:736:5664:53f3 with SMTP id d2e1a72fcca58-74ea665319emr117997b3a.15.1752009600965;
 Tue, 08 Jul 2025 14:20:00 -0700 (PDT)
Date: Tue, 08 Jul 2025 14:19:59 -0700
In-Reply-To: <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
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
 <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com> <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
Message-ID: <diqz1pqq5qio.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Miao, Jun" <jun.miao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Wed, 2025-07-02 at 13:57 -0700, Ackerley Tng wrote:
>> >=20
>> > If a poisoned page continued to be used, it's a bit weird, no?=20
>>=20
>> Do you mean "continued to be used" in the sense that it is present in a
>> filemap and belongs to a (guest_memfd) inode?
>
> I mean anyway where it might get read or written to again.
>

Today, when handling memory failures, guest_memfd will unmap the page
from the guest and on the next fault, guest_memfd will discover the
HWpoison flag and return -EHWPOISON for KVM to handle.

If we go with my proposal, on TDX unmap failure, KVM kills the TD and
sets -EHWPOISON on the page.

Hence, the TD will not read/write the poisoned page.

TDX unmap failure implies that the page is private, so it will not be
mapped into the host page tables. If it is not in the host page tables,
the next access from the host will cause a page fault, and that's when
the HWpoison will be discoverd.

Hence, the host will also not read/write the poisoned page. Let me know
if you see any way else the poisoned page can be read/written to again.

>>=20
>> A poisoned page is not faulted in anywhere, and in that sense the page
>> is not "used". In the case of regular poisoning as in a call to
>> memory_failure(), the page is unmapped from the page tables. If that
>> page belongs to guest_memfd, in today's code [2], guest_memfd
>> intentionally does not truncate it from the filemap. For guest_memfd,
>> handling the HWpoison at fault time is by design; keeping it present in
>> the filemap is by design.
>
> I thought I read that you would allow it to be re-used. I see that the co=
de
> already checks for poison in the kvm_gmem_get_pfn() path and the mmap() p=
ath. So
> it will just sit in the fd and not be handed out again. I think it's ok. =
Well,
> as long as conversion to shared doesn't involve zeroing...?
>

IIUC it is zeroed on unmapping from the guest page tables? Is that done
by the TDX module, or by TDX code in KVM? Either way I think both of
those should be stopped once the unmap failure is discovered, as part of
"killing the TD".

>>=20
>> In the case of TDX unmap failures leading to HWpoison, the only place it
>> may remain mapped is in the Secure-EPTs. I use "may" because I'm not
>> sure about how badly the unmap failed. But either way, the TD gets
>> bugged, all vCPUs of the TD are stopped, so the HWpoison-ed page is no
>> longer "used".
>>=20
>> [2]
>> https://github.com/torvalds/linux/blob/b4911fb0b060899e4eebca0151eb56deb=
86921ec/virt/kvm/guest_memfd.c#L334
>
> Yes, I saw that. It looks like special error case treatment for the state=
 we are
> setting up.
>
>>=20
>> > It could take an
>> > #MC for another reason from userspace and the handling code would see =
the
>> > page
>> > flag is already set. If it doesn't already trip up some MM code somewh=
ere,
>> > it
>> > might put undue burden on the memory failure code to have to expect re=
peated
>> > poisoning of the same memory.
>> >=20
>>=20
>> If it does take another #MC and go to memory_failure(), memory_failure()
>> already checks for the HWpoison flag being set [3]. This is handled by
>> killing the process. There is similar handling for a HugeTLB
>> folio. We're not introducing anything new by using HWpoison; we're
>> buying into the HWpoison framework, which already handles seeing a
>> HWpoison when handling a poison.
>
> Do you see another user that is setting the poison flag manually like pro=
posed?
> (i.e. not through memory failure handlers)
>

As far as I know, this might be the first case of setting the poison
flag not through memory failure handlers.

>>=20
>> [3]
>> https://github.com/torvalds/linux/blob/b4911fb0b060899e4eebca0151eb56deb=
86921ec/mm/memory-failure.c#L2270
>>=20
>> > >=20
>> > > > What about a kvm_gmem_buggy_cleanup() instead of the system wide o=
ne.
>> > > > KVM calls
>> > > > it and then proceeds to bug the TD only from the KVM side. It's no=
t as
>> > > > safe for
>> > > > the system, because who knows what a buggy TDX module could do. Bu=
t TDX
>> > > > module
>> > > > could also be buggy without the kernel catching wind of it.
>> > > >=20
>> > > > Having a single callback to basically bug the fd would solve the a=
tomic
>> > > > context
>> > > > issue. Then guestmemfd could dump the entire fd into memory_failur=
e()
>> > > > instead of
>> > > > returning the pages. And developers could respond by fixing the bu=
g.
>> > > >=20
>> > >=20
>> > > This could work too.
>> > >=20
>> > > I'm in favor of buying into the HWpoison system though, since we're
>> > > quite sure this is fair use of HWpoison.
>> >=20
>> > Do you mean manually setting the poison flag, or calling into
>> > memory_failure(),
>> > and friends?
>>=20
>> I mean manually setting the poison flag.
>>=20
>> * If regular 4K page, set the flag.
>> * If THP page (not (yet) supported by guest_memfd), set the poison flag
>> =C2=A0 on the specific subpage causing the error, and in addition set TH=
P'S
>> has_hwpoison
>> =C2=A0 flag
>> * If HugeTLB page, call folio_set_hugetlb_hwpoison() on the subpage.
>>=20
>> This is already the process in memory_failure() and perhaps some
>> refactoring could be done.
>>=20
>> I think calling memory_failure() would do too much, since in addition to
>> setting the flag, memory_failure() also sometimes does freeing and may
>> kill processes, and triggers the users of the page to further handle the
>> HWpoison.
>
> It definitely seem like there is more involved than setting the flag. Whi=
ch
> means for our case we should try to understand what we are skipping and h=
ow it
> fits with the rest of the kernel. Is any code the checks for poison assum=
ing
> that memory_failure() stuff has been done? Stuff like that.
>

Yup! But I do still think setting HWpoison is good enough to pursue at
least for a next RFC patch series, and in the process of testing that
series we could learn more. Do you mean that we shouldn't proceed until
all of this is verified?

>>=20
>> > If we set them manually, we need to make sure that it does not have
>> > side effects on the machine check handler. It seems risky/messy to me.=
 But
>> > Kirill didn't seem worried.
>> >=20
>>=20
>> I believe the memory_failure() is called from the machine check handler:
>>=20
>> DEFINE_IDTENTRY_MCE(exc_machine_check)
>> =C2=A0 -> exc_machine_check_kernel()
>> =C2=A0=C2=A0=C2=A0=C2=A0 -> do_machine_check()
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> kill_me_now() or kill_me_m=
aybe()
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> memory_f=
ailure()
>>=20
>> (I might have quoted just one of the paths and I'll have to look into it
>> more.)
>
> It looked that way to me too. But it works from other contexts. See
> MADV_HWPOISON (which is for testing).
>
>>=20
>> For now, IIUC setting the poison flag is a subset of memory_failure(), w=
hich
>> is a
>> subset of what the machine check handler does.
>>=20
>> memory_failure() handles an already poisoned page, so I don't see any
>> side effects.
>>=20
>> I'm happy that Kirill didn't seem worried :) Rick, let me know if you
>> see any specific risks.
>>=20
>> > Maybe we could bring the poison page flag up to DavidH and see if ther=
e is
>> > any
>> > concern before going down this path too far?
>> >=20
>>=20
>> I can do that. David's cc-ed on this email, and I hope to get a chance
>> to talk about handling HWpoison (generally, not TDX specifically) at the
>> guest_memfd bi-weekly upstream call on 2025-07-10 so I can bring this up
>> too.
>
> Ok sounds good. Should we just continue the discussion there?

I think we're at a point where further discussion isn't really
useful. Kirill didn't seem worried about using HWpoison, so that's a
good sign. I think we can go ahead to use HWpoison for the next RFC of
this series and we might learn more through the process of testing it.

Do you prefer to just wait till the next guest_memfd call (now
rescheduled to 2025-07-17) before proceeding?

> I can try to
> attend.
>

Sure, thanks! It'll be focused on memory failure handling in general, so
TDX will just be another participant.

>>=20
>> > >=20
>> > > Are you saying kvm_gmem_buggy_cleanup() will just set the HWpoison f=
lag
>> > > on the parts of the folios in trouble?
>> >=20
>> > I was saying kvm_gmem_buggy_cleanup() can set a bool on the fd, simila=
r to
>> > VM_BUG_ON() setting vm_dead.
>>=20
>> Setting a bool on the fd is a possible option too. Comparing an
>> inode-level boolean and HWpoison, I still prefer HWpoison because
>>=20
>> 1. HWpoison gives us more information about which (sub)folio was
>> =C2=A0=C2=A0 poisoned. We can think of the bool on the fd as an fd-wide
>> =C2=A0=C2=A0 poisoning. If we don't know which subpage has an error, we'=
re forced
>> =C2=A0=C2=A0 to leak the entire fd when the inode is released, which cou=
ld be a
>> =C2=A0=C2=A0 huge amount of memory leaked.
>> 2. HWpoison is already checked on faults, so there is no need to add an
>> =C2=A0=C2=A0 extra check on a bool
>> 3. For HugeTLB, HWpoison will have to be summarized/itemized on merge/sp=
lit to
>> handle
>> =C2=A0=C2=A0 regular non-TDX related HWpoisons, so no additional code th=
ere.
>>=20
>> > After an invalidate, if gmem see this, it needs to
>> > assume everything failed, and invalidate everything and poison all gue=
st
>> > memory.
>> > The point was to have the simplest possible handling for a rare error.
>>=20
>> I agree a bool will probably result in fewer lines of code being changed
>> and could be a fair first cut, but I feel like we would very quickly
>> need another patch series to get more granular information and not have
>> to leak an entire fd worth of memory.
>
> We will only leak an entire VMs worth of memory if there is a bug, the fo=
rm of
> which I'm not sure. The kernel doesn't usually have a lot of defensive co=
de to
> handle for bugs elsewhere. Unless it's to help debugging. But especially =
for
> other platform software (bios, etc), it should try to stay out of the job=
 of
> maintaining code to work around unfixed bugs. And here we are working aro=
und
> *potential bugs*.
>
> So another *possible* solution is to expect TDX module/KVM to work. Kill =
the TD,
> return success to the invalidation, and hope that it doesn't do anything =
to
> those zombie mappings. It will likely work. Probably much more likely to =
work
> then some other warning cases in the kernel. As far as debugging, if stra=
nge
> crashes are observed after a bit splat, it can be a good hint.
>
> Unless Yan has some specific case to worry about that she has been holdin=
g on to
> that makes this error condition a more expected state. That could change =
things.
>
>>=20
>> Along these lines, Yan seems to prefer setting HWpoison on the entire
>> folio without going into the details of the exact subfolios being
>> poisoned. I think this is a possible in-between solution that doesn't
>> require leaking the entire fd worth of memory, but it still leaks more
>> than just where the actual error happened.
>>=20
>> I'm willing to go with just setting HWpoison on the entire large folio
>> as a first cut and leak more memory than necessary (because if we don't
>> know which subpage it is, we are forced to leak everything to be safe).
>
> Leaking more memory than necessary in a bug case seems totally ok to me.
>
>>=20
>> However, this patch series needs a large page provider in guest_memfd, a=
nd
>> will only land either after THP or HugeTLB support lands in
>> guest_memfd.
>>=20
>> For now if you're testing on guest_memfd+HugeTLB,
>> folio_set_hugetlb_hwpoison() already exists, why not use it?
>>=20
>> > Although
>> > it's only a proposal. The TDX emergency shutdown option may be simpler
>> > still.
>> > But killing all TDs is not ideal. So thought we could at least conside=
r
>> > other
>> > options.
>> >=20
>> > If we have a solution where TDX needs to do something complicated beca=
use
>> > something of its specialness, it may get NAKed.
>>=20
>> Using HWpoison is generic, since guest_memfd needs to handle HWpoison
>> for regular memory errors anyway. Even if it is not a final solution, it
>> should be good enough, if not for this patch series to merge, at least
>> for the next RFC of this patch series. :)
>
> Yes, maybe. If we have a normal, easy, non-imposing solution for handling=
 the
> error then I won't object.

I believe we have 1 solution now, with 4 options to prevent the memory
from being re-used by the host.

1. Kill the TD *and* one of the following to prevent the memory from
   being re-used by the host:
    a. Kill the host
    b. HWpoison the memory
    c. fd bool, aka inode-wide HWpoison on error
    d. Leak the memory directly (not great, will mess up conversions and
                                 guest_memfd inode release)=20

To push along on this topic, is it okay for us to proceed with HWpoison
and find out along the way if it is not easy or imposing?


