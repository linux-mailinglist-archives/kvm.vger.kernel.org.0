Return-Path: <kvm+bounces-51111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8DFAEE773
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 21:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C8593BF59E
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 19:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCF52E613F;
	Mon, 30 Jun 2025 19:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="utt1sk+B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4836D1C8631
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 19:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751311552; cv=none; b=H85nBbDIXru86LQR156PsJ2oO8aKk7g5atb9bv7oOYOdAFGkAVlVidC0PxxEvWpkjvWrJyemedjnislomQeSIwzoFTy5G7HzBGft0pSzRuPpwEFk4aG+HwVdqybS0oES0t/mwEopQex/8UEPRppiyknspxKip8b2ZfZzzuRbsBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751311552; c=relaxed/simple;
	bh=MgwlNA+u2quDSQ7yajLtN11JeCOGdcJ7wasKI58DoAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DNuYtvhUkpIY0A6eWPm9aprnBEWfbaXkxK1fFUKca/MT6mvkqCj4wHppQXgVcVM4iwPP75Lk2pEWZbbZ7jty2vSqQ93qkPtWwddCzVGvE4YJPZS1rRQ8i4jDzEyYhWMbZyHDmI6enAJXxuWYWfOtQKmg6VfLTWi7WzK4qr59VLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=utt1sk+B; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74b29ee4f8bso1208631b3a.2
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 12:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751311550; x=1751916350; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MgwlNA+u2quDSQ7yajLtN11JeCOGdcJ7wasKI58DoAw=;
        b=utt1sk+BvBn7fFAd+o9Sf4o+1lPYZjocSrrLT+dNxb0A5lfuUG9z5dQfIIB44kaPlP
         Tfk7C+CFP01FRTxFjLYq0q8I7oQDL1cXRVFruJblymT6ctxtf6Smyt3565cQguwWyc4+
         cIT3DOxr5MZ5v+fA1WoggQfX7o/C3G7dyyXYNcSEM1++i34ARoIoxgS+jeS3hgjS9Twg
         zCbdoMT2ecNn/sRLyXCaWK9KSwYHDulIPbB90pdQP/vHHEhWoe5v8YQmVOtVAgGSP3na
         9LEi6VqI0Uu0dwX7jxlJJF9c2hpRnKJF7tD/P4ldvdkxD6/BVOuVs0uA9ESVfcQR1olQ
         K8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751311550; x=1751916350;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MgwlNA+u2quDSQ7yajLtN11JeCOGdcJ7wasKI58DoAw=;
        b=HUrP4M8vEnRGacmVxCo9zFHi/qYPREQyzsQVQmwP9y+gImhzghbZdC7nQ9WACXhhtO
         X7rdFTyydWPbu8c7g+9Nn+uVH7tyTyHM3DVGoitPozY5kLUXFW1jCP88OzkMx1IXt1r8
         CEA00cldtG5nukUhvAdfvwNxzGmi65slGWZZKlnXtd5FTdNwFNXFBp9ZlqJ7klDfaeff
         9E3yHcg89XhHa1Xd7xvRedWHIu8K301j+xeEUziWNu7UwZ2bKQddfnrXr8Tv09fP8IgS
         Bb/5CcSr/AVgJh91aoGLQXh56/3+UbZpE/ZtL1XO99ODSgFfc5mfQL6xQYZrePVeTAdb
         DUtw==
X-Forwarded-Encrypted: i=1; AJvYcCU4E9zqrbVZ6PUMWRO5aYgUJYX+49l9jCdipNgdtMR4SwJIUsjXYREe4kRf/pUVctSsK8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyzV6cmaCz/YhSLa+rgql38UsS7bATtUfZKXw8d6muoDIJO97B
	MS7560sDX7IfmU5kCT7AprylWxFKbfA8dc5g/fGp2sBTUyi7UeRIQm7Gwt2LSQcnwybMdZN2YWa
	Wd/k1L1KCBpws6Cg+inSH/S3SYQ==
X-Google-Smtp-Source: AGHT+IEM3NAm2OsnhE6rbsmiMe42AuE8aEPB3EVgzuajXVv2Zs+VmfSL7ZNVcO9oi89tDaSplPmcERQJBM1Ly5wFIQ==
X-Received: from pfbbw20.prod.google.com ([2002:a05:6a00:4094:b0:746:247f:7384])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:91e9:b0:748:68dd:eb8c with SMTP id d2e1a72fcca58-74af7049b1bmr22091856b3a.23.1751311550592;
 Mon, 30 Jun 2025 12:25:50 -0700 (PDT)
Date: Mon, 30 Jun 2025 12:25:49 -0700
In-Reply-To: <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com> <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com> <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
Message-ID: <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Mon, 2025-06-30 at 19:13 +0800, Yan Zhao wrote:
>> > > ok! Lets go f/g. Unless Yan objects.
>> I'm ok with f/g. But I have two implementation specific questions:
>>=20
>> 1. How to set the HWPoison bit in TDX?

I was thinking to set the HWpoison flag based on page type. If regular
4K page, set the flag. If THP page (not (yet) supported by guest_memfd),
set the has_hwpoison flag, and if HugeTLB page, call
folio_set_hugetlb_hwpoison().

But if we go with Rick's suggestion below, then we don't have to figure
this out.

>> 2. Should we set this bit for non-guest-memfd pages (e.g. for S-EPT page=
s) ?
>
> Argh, I guess we can keep the existing ref count based approach for the o=
ther
> types of TDX owned pages?
>

Wait TDX can only use guest_memfd pages, right? Even if TDX can use
non-guest_memfd pages, why not also set HWpoison for non-guest_memfd
pages?

Either way I guess if we go with Rick's suggestion below, then we don't
have to figure the above out.

>>=20
>> TDX can't invoke memory_failure() on error of removing guest private pag=
es or
>> S-EPT pages, because holding write mmu_lock is regarded as in atomic con=
text.
>> As there's a mutex in memory_failure(),
>> "BUG: sleeping function called from invalid context at kernel/locking/mu=
tex.c"
>> will be printed.
>>=20
>> If TDX invokes memory_failure_queue() instead, looks guest_memfd can inv=
oke
>> memory_failure_queue_kick() to ensure HWPoison bit is set timely.
>> But which component could invoke memory_failure_queue_kick() for S-EPT p=
ages?
>> KVM?
>
> Hmm, it only has queue of 10 pages per-cpu. If something goes wrong in th=
e TDX
> module, I could see exceeding this during a zap operation. At which point=
, how
> much have we really handled it?
>
>
> But, at the risk of derailing the solution when we are close, some reflec=
tion
> has made me question whether this is all misprioritized. We are trying to=
 handle
> a case where a TDX module bug may return an error when we try to release =
gmem
> pages. For that, this solution is feeling way too complex.
>
> If there is a TDX module bug, a simpler way to handle it would be to fix =
the
> bug. In the meantime the kernel can take simpler, more drastic efforts to
> reclaim the memory and ensure system stability.
>
> In the host kexec patches we need to handle a kexec while the TDX module =
is
> running. The solution is to simply wbinvd on each pCPU that might have en=
tered
> the TDX module. After that, barring no new SEAMCALLs that could dirty
> memory,=C2=A0the pages are free to use by the next kernel. (at least on s=
ystems
> without the partial write errata)
>
> So for this we can do something similar. Have the arch/x86 side of TDX gr=
ow a
> new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALLs =
after
> that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the s=
ystem
> die. Zap/cleanup paths return success in the buggy shutdown case.
>

Do you mean that on unmap/split failure: there is a way to make 100%
sure all memory becomes re-usable by the rest of the host, using
tdx_buggy_shutdown(), wbinvd, etc?

If yes, then I'm onboard with this, and if we are 100% sure all memory
becomes re-usable by the host after all the extensive cleanup, then we
don't need to HWpoison anything.

> Does it fit? Or, can you guys argue that the failures here are actually n=
on-
> special cases that are worth more complex recovery? I remember we talked =
about
> IOMMU patterns that are similar, but it seems like the remaining cases un=
der
> discussion are about TDX bugs.

