Return-Path: <kvm+bounces-11416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC40876DD9
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 00:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E1681C21A98
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28E83BBED;
	Fri,  8 Mar 2024 23:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qYrpFs8V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934B83BBC2
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 23:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709940174; cv=none; b=SCynpVd68LpgK1cGzOpz3fQLaRM++m2CrqFJztUGeE6zkUt+4RQb6aNsFpZ9ZJ62NLM4adqHhT0s8EXf5Ohr6rF9RIh4bEF6fifGv85FYA83Zy+hoRYVNEt1paTZt1qSf7rugYcNPO82z6sHNBT5I7tU5nCKZRgNm/3DZQxGIls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709940174; c=relaxed/simple;
	bh=LcAL4HJapLzwRprK5FA6YW0O8VXdIWha6BN3NRhxhhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qBHauJBz6KVAX30YVed9uhPLrNM03MggSYXaFciXkAl55nHx+utDGy16pd/48tyKFlWtdBEaO0fTBR9aBbtagZND/9q+fIHqpDkmLmQxo0m1z8QF/3THeFFA6Wske3p+afxCLXBVVN9cv2lLlwv5U6Obvy8tTdvemsQTW1FDTnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qYrpFs8V; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a0899c5f3so15062397b3.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 15:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709940171; x=1710544971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7S3B1t8pdIqU5Wjnk50i6MWuw2joVUe0pWEUYZUDmO4=;
        b=qYrpFs8V8LAIVPcoEjhTAY6DhQP58J8Rxyv+VQKEK8OP7XJQWTFnJwGacJnyYAiIyk
         T0YYe+ujQGG0DHA/C+KxT2YUYJDJYaTJqEr2x5LLJWyFiz5UXylhJHldphWacwTMcx7/
         AOReHMxlWHvnyJ/xZhLZASPrG0iqFaJw0CJHbOqciIiss1ruNPFQjxjwwkBbbLJryw59
         2Kl82HfCOVqGMpv2U4WxbX5ekTxd8ic20Yd2MF+r0KFfeG7x/BwEod5VnZKx3VN3FRwM
         qiCd0HR1wc2MLVh9F6WXce0tOzWzWrBilYBTck8I6yn3ihoHoXkLCXXsXxUIeKBph4BR
         2Vgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709940171; x=1710544971;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7S3B1t8pdIqU5Wjnk50i6MWuw2joVUe0pWEUYZUDmO4=;
        b=FQOnIOMjEYcmdb1HDGikJvQa8YUTFgD4fbCEBgmJW6s3708+MGyxuSuMY3YzdCQQBM
         XWAIYh+0Gc+T+7a8QlQE1INkPj3XzDm2etYCESC/j8iiDOVQHZxpJBPaoL/mUkE0c5Ow
         3Os4mz9WWNbpWiznYHaBOCriG4X5w2BJFNj7JqCnRBnOm7YxVu1w+svFv8kmFoGzJHRE
         vHTVlgTIlaTx5azH49Q2UcYccFUw6pQD9lFgTcwoSyEn0gvBC3LLIotSKoRIQcHWT1vI
         0VQqrsQ8F6NboTs3+j2TJmEUfrA8oxDrjPp/5JEURITxVdZ5+szGBuIuh4eblK1XDKAz
         97VA==
X-Forwarded-Encrypted: i=1; AJvYcCU9yXAgYhZMq5THeo++wXc4iav1BsVV4CqBAMghSqMg9aRfLASS0O93UxyQF9gHHamSOEyvcYFrcm/nRFY/YL0iCjPU
X-Gm-Message-State: AOJu0YzoISpj1UIPvguGB7FqXPpefFZEdL8n3dCJYaXo3SU++EYKWWut
	PMBXd5dBN/YrOlPS9f2dxUPoAr9t0W2NeDZDRUQVzWAsAgywXNgt37ehFm59wtTws2L2QtKgOp4
	u6A==
X-Google-Smtp-Source: AGHT+IHIif5Eml2ZF3fDerW6drNpqFldJ7Jz2SKMgJzKuurv4zQCJLfYI0vd1IGQU3mKE9h27C6nTWKouOk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d7d3:0:b0:608:e67f:4387 with SMTP id
 z202-20020a0dd7d3000000b00608e67f4387mr134113ywd.7.1709940171728; Fri, 08 Mar
 2024 15:22:51 -0800 (PST)
Date: Fri, 8 Mar 2024 15:22:50 -0800
In-Reply-To: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
Message-ID: <ZeudRmZz7M6fWPVM@google.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
From: Sean Christopherson <seanjc@google.com>
To: James Gowans <jgowans@amazon.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Patrick Roy <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, Derek Manwaring <derekmn@amazon.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Nikita Kalyazin <kalyazin@amazon.co.uk>, 
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, Alexander Graf <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2024, James Gowans wrote:
> However, memfd_secret doesn=E2=80=99t work out the box for KVM guest memo=
ry; the
> main reason seems to be that the GUP path is intentionally disabled for
> memfd_secret, so if we use a memfd_secret backed VMA for a memslot then
> KVM is not able to fault the memory in. If it=E2=80=99s been pre-faulted =
in by
> userspace then it seems to work.

Huh, that _shouldn't_ work.  The folio_is_secretmem() in gup_pte_range() is
supposed to prevent the "fast gup" path from getting secretmem pages.

Is this on an upstream kernel?  If so, and if you have bandwidth, can you f=
igure
out why that isn't working?  At the very least, I suspect the memfd_secret
maintainers would be very interested to know that it's possible to fast gup
secretmem.

> There are a few other issues around when KVM accesses the guest memory.
> For example the KVM PV clock code goes directly to the PFN via the
> pfncache, and that also breaks if the PFN is not in the direct map, so
> we=E2=80=99d need to change that sort of thing, perhaps going via userspa=
ce
> addresses.
>=20
> If we remove the memfd_secret check from the GUP path, and disable KVM=E2=
=80=99s
> pvclock from userspace via KVM_CPUID_FEATURES, we are able to boot a
> simple Linux initrd using a Firecracker VMM modified to use
> memfd_secret.
>=20
> We are also aware of ongoing work on guest_memfd. The current
> implementation unmaps guest memory from VMM address space, but leaves it
> in the kernel=E2=80=99s direct map. We=E2=80=99re not looking at unmappin=
g from VMM
> userspace yet; we still need guest RAM there for PV drivers like virtio
> to continue to work. So KVM=E2=80=99s gmem doesn=E2=80=99t seem like the =
right solution?

We (and by "we", I really mean the pKVM folks) are also working on allowing
userspace to mmap() guest_memfd[*].  pKVM aside, the long term vision I hav=
e for
guest_memfd is to be able to use it for non-CoCo VMs, precisely for the sec=
urity
and robustness benefits it can bring.

What I am hoping to do with guest_memfd is get userspace to only map memory=
 it
needs, e.g. for emulated/synthetic devices, on-demand.  I.e. to get to a st=
ate
where guest memory is mapped only when it needs to be.  More below.

> With this in mind, what=E2=80=99s the best way to solve getting guest RAM=
 out of
> the direct map? Is memfd_secret integration with KVM the way to go, or
> should we build a solution on top of guest_memfd, for example via some
> flag that causes it to leave memory in the host userspace=E2=80=99s page =
tables,
> but removes it from the direct map?=20

100% enhance guest_memfd.  If you're willing to wait long enough, pKVM migh=
t even
do all the work for you. :-)

The killer feature of guest_memfd is that it allows the guest mappings to b=
e a
superset of the host userspace mappings.  Most obviously, it allows mapping=
 memory
into the guest without mapping first mapping the memory into the userspace =
page
tables.  More subtly, it also makes it easier (in theory) to do things like=
 map
the memory with 1GiB hugepages for the guest, but selectively map at 4KiB g=
ranularity
in the host.  Or map memory as RWX in the guest, but RO in the host (I don'=
t have
a concrete use case for this, just pointing out it'll be trivial to do once
guest_memfd supports mmap()).

Every attempt to allow mapping VMA-based memory into a guest without it bei=
ng
accessible by host userspace emory failed; it's literally why we ended up
implementing guest_memfd.  We could teach KVM to do the same with memfd_sec=
ret,
but we'd just end up re-implementing guest_memfd.

memfd_secret obviously gets you a PoC much faster, but in the long term I'm=
 quite
sure you'll be fighting memfd_secret all the way.  E.g. it's not dumpable, =
it
deliberately allocates at 4KiB granularity (though I suspect the bug you fo=
und
means that it can be inadvertantly mapped with 2MiB hugepages), it has no l=
ine
of sight to taking userspace out of the equation, etc.

With guest_memfd on the other hand, everyone contributing to and maintainin=
g it
has goals that are *very* closely aligned with what you want to do.

[*] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com

