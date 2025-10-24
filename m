Return-Path: <kvm+bounces-61040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E009CC07875
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACEE01C250AC
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1396343202;
	Fri, 24 Oct 2025 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K4Iqd2Mm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AADB1990A7
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 17:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761326650; cv=none; b=ctQCenL7nGmxAL99UCqvYBxj4bNkw8finimekulOwxNWZGgRhfp/q8Y564GLAXUQ2hJQ1IUlxzFEeOGgPtAUqzmlMtTr3NK2xYwEhfc2Q9gaBfRH3U3u69vaUVZa36QCvi3bbIP2HuUC1ykDRzk0i2209YxrkFOefSdBt3Sx4q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761326650; c=relaxed/simple;
	bh=eSVXjWvufq5wlXV/uRQ71AATlF89iNraJnuNs0WQoSQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BJa93878VjdqLoe1SIek3HPtDtMeO0OV2ARexKDpp/k2H75uWhHOKqy4jHXQ5G0ojHQJLu/Ta3s1owheXXZjIIvbmfM3duolDC+Kx5LnbbiKuinuJM5ccsQ3mVKFy+3H3f4O7GVmMkUT8w2sFd8rQHMDSYrnQywT9Vq2xbmsfL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K4Iqd2Mm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6ce25bea3eso1661057a12.2
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 10:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761326648; x=1761931448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7FLP5WkTh+VRhKc08YfB2VDRV9fkYbRqP1RoJ7oLnhA=;
        b=K4Iqd2MmssquLsSI3+ynC5W+W9KudxoIIYNy5GGAUohuBWtEkZTANUhZbwze8cz42K
         MijQTgM0Jbn1shXxiFKH0DitMxFQQbzArnQreOfmXYy6mQS/XAWDVZ56+nSleZWcHGr0
         lFeX7VXQFZg9hOKVAFRo/aWnNG3lFO/rwmX13cARKg3MzYssUtpDFfbset0JOlm4YPTz
         kRHl5jIG3mfrBtOg6rYM+I6iWIKJ8cTzixps3IOuXUpZ8YjeOYQUw7zvfWBFnad15uKw
         lCuTP/0PiKCJNki5bkrSi2Wc59P8yLfX+6cdETW/zkkULQoZWCGY6XyTin5n+9SZu3oM
         sHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761326648; x=1761931448;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7FLP5WkTh+VRhKc08YfB2VDRV9fkYbRqP1RoJ7oLnhA=;
        b=ADxjWq32bK+EzymP1HwlRJVf6olp64pMgEQEO/8A+DMFoJ3wqf8HSTBbDmR5Ao20Xh
         YbRiYKcOJ257408VA7hIEDZHujLeiCxGtsAJLpIhmXCN2q+9xLVl+Va/n6k8cCG5qaDr
         dOjeVWhSx7zyxMXh5yJ8vnUZwFYP02yoFbagxcvVf/yL8hVUEDHW6S0r7iR1bqS5fCqo
         eXKBVZ4/Au1E90637dC3Mh9nE4Kg9BliT5JQ8dnSt2+7RiZqR6i6qehI2i0rH4RhluUQ
         bMQq+jWMSaIpw+wEVtrDqpRoXs+iwZcvfjAq48c8lb7tZRn8Zm4RDMqpzSSees31IXZ5
         HWLg==
X-Forwarded-Encrypted: i=1; AJvYcCXvEmnnn+tX7+2b6F9qRfDQgzmj+96Vl2BwlXGmEnWavaSTnkBz+i7C2EThCFREub2z1ys=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp4n0rnwjYfr85BQUpmLCbXKDtpTeXB4UN9PkjwL+NLpsyXOLC
	XsBbvckMJbKeSfEL8sxkR1nWF4rZH9AFK+TxG1GFvQzFIZ8+iZrANlku/MmTTEHJIbFdnGYQ3D2
	77jFc4Q==
X-Google-Smtp-Source: AGHT+IEIm9NIN92smmhmaW4iWKKJb1V67wupHKKcMMvqTgE7x+LAyO/si8uIpWAx2DZBg/t9wHtaIrchfoA=
X-Received: from pjbsd7.prod.google.com ([2002:a17:90b:5147:b0:33b:b3b8:216b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:244d:b0:24d:1f99:713a
 with SMTP id d9443c01a7336-2948ba0d8f8mr43813095ad.31.1761326647757; Fri, 24
 Oct 2025 10:24:07 -0700 (PDT)
Date: Fri, 24 Oct 2025 10:24:06 -0700
In-Reply-To: <CAAhR5DFJKTTY3tN7AU=BXDRJAGjuortmK0ruQWU8RB_Z6jVugQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com> <20250925172851.606193-14-sagis@google.com>
 <68efcb7ee33e5_cab031002e@iweiny-mobl.notmuch> <CAAhR5DGcz-2=a6Q2zZS_eP2ZjNNPs65jNG+K50tdVAQfC6AbbA@mail.gmail.com>
 <aPui50JMEcuIl7-8@google.com> <CAAhR5DFJKTTY3tN7AU=BXDRJAGjuortmK0ruQWU8RB_Z6jVugQ@mail.gmail.com>
Message-ID: <aPu2NsDuU08UQ5N4@google.com>
Subject: Re: [PATCH v11 13/21] KVM: selftests: Add helpers to init TDX memory
 and finalize VM
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, linux-kselftest@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025, Sagi Shahar wrote:
> On Fri, Oct 24, 2025 at 11:02=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Oct 23, 2025, Sagi Shahar wrote:
> > > On Wed, Oct 15, 2025 at 11:25=E2=80=AFAM Ira Weiny <ira.weiny@intel.c=
om> wrote:
> > > >
> > > > Sagi Shahar wrote:
> > > > > From: Ackerley Tng <ackerleytng@google.com>
> > > > >
> > > >
> > > > [snip]
> > > >
> > > > > diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b=
/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > > > > index 2551b3eac8f8..53cfadeff8de 100644
> > > > > --- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > > > > +++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > > > > @@ -270,3 +270,61 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint6=
4_t attributes)
> > > > >
> > > > >       free(init_vm);
> > > > >  }
> > > > > +
> > > >
> > > > [snip]
> > > >
> > > > > +
> > > > > +void vm_tdx_finalize(struct kvm_vm *vm)
> > > >
> > > > Why is this not a new kvm_arch_vm_finalize_vcpu() call?
> > >
> > > What do you mean?
> >
> > Ira is pointing out that upstream now has kvm_arch_vm_finalize_vcpus(),=
 so you
> > can (and I agree, should) implement that for x86.c, and do vm_tdx_final=
ize() from
> > there (based on the VM shape) instead of requiring the caller to manual=
ly finalize
> > the TD.
> >
> > Unlike SEV, where userspace can manipulate guest state prior to LAUNCH,=
 TDX guest
> > state is unreachable from time zero, i.e. there is unlikely to be many =
(any?) use
> > cases where a selftest wants to do something between creating vCPUs and=
 finalizing
> > the TD.
>=20
> There are actually a few use cases for calling vm_tdx_finalize
> seperately from the create phase. One such case is when a user wants
> to add additional memslots for testing shared memory conversions.

Why does creating memslots need to be done before finalizing the TD?  The e=
xtra
memslots shouldn't _need_ to be included in the initial image, and I don't =
recall
anything in the kernel that prevents adding a memslot after the TD is initi=
alized.

> Another one is installing interrupt handlers. But these are probably
> rare enough that they can call __vm_create() and vm_vcpu_add()
> manually instead of using the wrapper

Hmm, for installing interrupt handlers, we could handle that by adding a gu=
est
variant, e.g. so that the guest can install/remove exception handlers after
the initial image is finalized.  We probably want that anyways, otherwise t=
ests
would be unable to manipulate handlers throughout a test.

In fact, it's tempting to kill off vm_install_exception_handler() in x86 en=
tirely,
but that's probably not worth the churn (and some tests would be made more =
complex).

