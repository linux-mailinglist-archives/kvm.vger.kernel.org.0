Return-Path: <kvm+bounces-59378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 482BABB2192
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 02:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D80991C307D
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 00:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134AD4A32;
	Thu,  2 Oct 2025 00:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TChl7G5g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A0BA55
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 00:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759363464; cv=none; b=jV6y9yeW00dbf7E9iDfl36n7vKRUpTgCaMZiLB/2JSNSezeSslYRgs9TOkioz4+BQWkCjGRQVdsh31itkyUdczpr9d5LSJtEpdeLNUkAjfBiI8qhcnC00YzRprc39dNJxAK+QYPLMDK0vZXz9mNHxKrCfWGnxF6/elGJL+WDXAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759363464; c=relaxed/simple;
	bh=BdYWqa67dlw0B/C8i7/jTrgyauBgy3bv52+1FFgKo2c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uHbxAIrLJHCaQeSB1GgIBZ/TCRKc28N0cckYolEDbKFI0SMBB8s4zHSM8IbdQIVBAmJQpazJwNSaMl7gMhT9Ap35/7tyIcRz1aoFDYnOIBY3sH06dkDNpxetrvndqzmCF3CtGdNm00IayuQeUOe/50CnfuQmqqq/xqWoswGdxTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TChl7G5g; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso380503a91.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 17:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759363462; x=1759968262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R8xa8/hSqGbenJWY2RYDlB7Ya1W7yDIL1+dhdY1xbBc=;
        b=TChl7G5g4S5jIXhJU41BA+cyCrZty9ij7T1Q3SZHgVhFKFeStIhl5YizNWoYtiIfaN
         xPc9syXN1T4wtcakn0xOwhbu7/11PaWQv34q0xiloxXZCqDibNXJrt4qBQ8p9yqlWROu
         TkDSbYlP3Bc/lzEvL/BJYsqshAi5Ykui0GOJyEbIU25czmAAFoAM8/AxB9xJIoi2YT53
         5Qu/8JkUr7IAEVi8jTknN+Y5RpoyVBm8xBX1xsD0liEG8gCDuMLH45AnXyP0+baFEaIw
         r9zNgLpVi8LKz4l7r9euKhljVbVBJTFlT4RstGSpB8H+3C/+YIv4qmMnTazPR11sDW5V
         qPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759363462; x=1759968262;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R8xa8/hSqGbenJWY2RYDlB7Ya1W7yDIL1+dhdY1xbBc=;
        b=HZYco2WhQjJDVGCgJthPUQPUNjU6hEpKyV1BjuhZZz5P+6dmVWbktDDnk+H8jBwLHo
         n/+dOnVN6OTeKd85RtL1cgU1tQXjHJmYz2dFMxFBtZbS+7P17nQftn3Yp55Vq4TuaHkm
         tuAAlwdha9lcme/NzGv90wCrGZxoeOrXmojB3yZdzzUAuLTZcT1hwEZ+1RuNFBsdRJKK
         bZYQ/q/XuKuzOEZAMXi45Fg0JZ1RLdXO/O+9JW0KmckJW7g1T1F3ikEQiFY+0d4jrE0W
         A3Ak/gwUG2tnUizQg3fwiD1Z/6187Az5TOelSXVHQdpQYXu8ERTB4w9pydIf0rbsF1Vg
         f7Ng==
X-Forwarded-Encrypted: i=1; AJvYcCUeZH7OUhplY214vZ4nGgXkzVwESoI0hmmXunxt/eKLz8u5ZWBuM0TsKTHPqMAm7SSo+a4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWDdBYg6zoBqkGdlzzuNPcObFg7lGzqdkj9OgCl+lSjK3q+DkC
	k+IY67hGUD46p4Am4kQIeoXtgYrZRKX+zdXEAKRtS1Z3ccJIsYPY4/tzawWaMhK2HEFUwz/O+n0
	NqD07/w==
X-Google-Smtp-Source: AGHT+IEJECoX83JVykI40dAiCVLjdOAqjjuEP5om/JQgcL8MQv9TRnbmTnuH3h+HF8hRJBvq3HMUhB0F9g0=
X-Received: from pjuu7.prod.google.com ([2002:a17:90b:5867:b0:32e:c154:c2f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acf:b0:32c:2cd:4d67
 with SMTP id 98e67ed59e1d1-339a6ea6915mr5491916a91.13.1759363461934; Wed, 01
 Oct 2025 17:04:21 -0700 (PDT)
Date: Wed, 1 Oct 2025 17:04:20 -0700
In-Reply-To: <CAGtprH-5NWVVyEM63ou4XjG4JmF2VYNakoFkwFwNR1AnJmiDpA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com> <aNshILzpjAS-bUL5@google.com>
 <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
 <aN1TgRpde5hq_FPn@google.com> <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
 <aN1h4XTfRsJ8dhVJ@google.com> <CAGtprH-5NWVVyEM63ou4XjG4JmF2VYNakoFkwFwNR1AnJmiDpA@mail.gmail.com>
Message-ID: <aN3BhKZkCC4-iphM@google.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nikita Kalyazin <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> On Wed, Oct 1, 2025 at 10:16=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > > On Wed, Oct 1, 2025 at 9:15=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > >
> > > > On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > > > > On Mon, Sep 29, 2025 at 5:15=E2=80=AFPM Sean Christopherson <sean=
jc@google.com> wrote:
> > > > > >
> > > > > > Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and t=
hus
> > > > > > KVM_CAP_GUEST_MEMFD_MMAP.  Two things:
> > > > > >
> > > > > >  1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUES=
T_MEMFD_FLAGS so
> > > > > >     that we don't need to add a capability every time a new fla=
g comes along,
> > > > > >     and so that userspace can gather all flags in a single ioct=
l.  If gmem ever
> > > > > >     supports more than 32 flags, we'll need KVM_CAP_GUEST_MEMFD=
_FLAGS2, but
> > > > > >     that's a non-issue relatively speaking.
> > > > > >
> > > > >
> > > > > Guest_memfd capabilities don't necessarily translate into flags, =
so ideally:
> > > > > 1) There should be two caps, KVM_CAP_GUEST_MEMFD_FLAGS and
> > > > > KVM_CAP_GUEST_MEMFD_CAPS.
> > > >
> > > > I'm not saying we can't have another GUEST_MEMFD capability or thre=
e, all I'm
> > > > saying is that for enumerating what flags can be passed to KVM_CREA=
TE_GUEST_MEMFD,
> > > > KVM_CAP_GUEST_MEMFD_FLAGS is a better fit than a one-off KVM_CAP_GU=
EST_MEMFD_MMAP.
> > >
> > > Ah, ok. Then do you envision the guest_memfd caps to still be separat=
e
> > > KVM caps per guest_memfd feature?
> >
> > Yes?  No?  It depends on the feature and the actual implementation.  E.=
g.
> > KVM_CAP_IRQCHIP enumerates support for a whole pile of ioctls.
>=20
> I think I am confused. Is the proposal here as follows?
> * Use KVM_CAP_GUEST_MEMFD_FLAGS for features that map to guest_memfd
> creation flags.

No, the proposal is to use KVM_CAP_GUEST_MEMFD_FLAGS to enumerate the set o=
f
supported KVM_CREATE_GUEST_MEMFD flags.  Whether or not there is an associa=
ted
"feature" is irrelevant.  I.e. it's a very literal "these are the supported
flags".

> * Use KVM caps for guest_memfd features that don't map to any flags.
>=20
> I think in general it would be better to have a KVM cap for each
> feature irrespective of the flags as the feature may also need
                                                   ^^^
> additional UAPIs like IOCTLs.

If the _only_ user-visible asset that is added is a KVM_CREATE_GUEST_MEMFD =
flag,
a CAP is gross overkill.  Even if there are other assets that accompany the=
 new
flag, there's no reason we couldn't say "this feature exist if XYZ flag is
supported".

E.g. it's functionally no different than KVM_CAP_VM_TYPES reporting support=
 for
KVM_X86_TDX_VM also effectively reporting support for a _huge_ number of th=
ings
far beyond being able to create a VM of type KVM_X86_TDX_VM.

KVM_CAP_XEN_HVM is a big collection of flags that have very little in commo=
n other
than being for Xen emulation.

> I fail to see the benefits of KVM_CAP_GUEST_MEMFD_FLAGS over
> KVM_CAP_GUEST_MEMFD_MMAP:

Adding a new flag doesn't require all of the things that come along with a =
new
capability.  E.g. there's zero chance of collisions between maintainer sub-=
trees
(at least as far as capabilities go; if multiple maintainers are adding mul=
tiple
gmem flags in the same kernel release, I really hope they'd be coordinating=
).

Enumerating in userspace is also more natural, e.g. userspace doesn't have =
to
manually build the mask of valid flags.

Writing documentation should be much easier (much less boilerplate), e.g. t=
he
sum total of uAPI for adding GUEST_MEMFD_FLAG_INIT_SHARED is:

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 7ba92f2ced38..754b662a453c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6438,6 +6438,11 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently def=
ined flags:
   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
   GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file
                                descriptor.
+  GUEST_MEMFD_FLAG_INIT_SHARED Make all memory in the file shared during
+                               KVM_CREATE_GUEST_MEMFD (memory files create=
d
+                               without INIT_SHARED will be marked private)=
.
+                               Shared memory can be faulted into host user=
space
+                               page tables. Private memory cannot.
   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
=20
 When the KVM MMU performs a PFN lookup to service a guest fault and the ba=
cking
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b1d52d0c56ec..52f6000ab020 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1599,7 +1599,8 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
=20
 #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest=
_memfd)
-#define GUEST_MEMFD_FLAG_MMAP  (1ULL << 0)
+#define GUEST_MEMFD_FLAG_MMAP          (1ULL << 0)
+#define GUEST_MEMFD_FLAG_INIT_SHARED   (1ULL << 1)
=20
 struct kvm_create_guest_memfd {
        __u64 size;

> 1) It limits the possible values to 32 even though we could pass 64 flags=
 to
> the original ioctl.

So because we're currently limited to 32 flags, we should instead throw in =
the
towel and artificially limit ourselves to 1 flag (0 or 1)?  Because for all=
 intents
and purposes, that's what we'd be doing.

Again, that is unlikely to be problematic before I retire.  It might not ev=
en be
a problem _ever_, because with luck we'll kill off 32-bit KVM in the next f=
ew
years and then we can actually leverage returning a "long" from ioctls.  Li=
terally
every capability that returns a mask of flags has this "problem"; it's not =
notable
or even an issue in practice.

> 2) Userspace has to anyways assume the semantics of each bit position.

Not always.

	uint64_t valid_flags =3D vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
	uint64_t flag;
	int fd;

	for (flag =3D BIT(0); flag; flag <<=3D 1) {
		fd =3D __vm_create_guest_memfd(vm, page_size, flag);
		if (flag & valid_flags) {
			TEST_ASSERT(fd >=3D 0,
				    "guest_memfd() with flag '0x%lx' should succeed",
				    flag);
			close(fd);
		} else {
			TEST_ASSERT(fd < 0 && errno =3D=3D EINVAL,
				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
				    flag);
		}
	}

But pedantry aside, I don't see how this is at all an interesting point.  Y=
es,
userspace has to know how to use a feature.

> 3) Userspace still has to check for caps for features that carry extra
> UAPI baggage.

That's simply not true.  E.g. see the example with VM types.
=20
> KVM_CAP_GUEST_MEMFD_MMAP allows userspace to assume that mmap is
> supported and userspace can just pass in the mmap flag that it anyways
> has to assume.

