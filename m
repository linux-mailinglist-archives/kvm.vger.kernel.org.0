Return-Path: <kvm+bounces-5834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB6B827321
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70BA71C2284A
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239E9524B1;
	Mon,  8 Jan 2024 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SDBPji52"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE17A51011
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 15:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5eba564eb3fso28687087b3.1
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 07:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704727764; x=1705332564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKQ+Vy9dtFXts5pAU9/qPsNuqRhJH0HCsu8ixdtl6Q4=;
        b=SDBPji52TfFCG5FzoQ2+cMLoCIMRJrhRVLxslvHkDk53uNPcNo1orq+ouAds3vW2gT
         /OQglr5eSoXVESPGH6QIkjMwL/wmE7gJFNzWcHIIJ1BTKJJvCkP9vWzC5rILOktsl76H
         KiZWQ+bFHeRwlMAM8p9WLQUK7pBR4Oa4VUG4Xw19plgCB/1xOmnG67xchVB4ihs64Gr8
         LizVDK1BAkpHIlQbLgJhUJwAaWDd2Jqn23QLqGI1pxZHUIzlfUjUl7pKX8gd6QRUdknP
         XLgGx53XfdWnq38T3Jbm5PgqjWZnuydPKGq8bJyueeYkHKwqEP0PavYuHUJ6EF1zEyFc
         nZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704727764; x=1705332564;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OKQ+Vy9dtFXts5pAU9/qPsNuqRhJH0HCsu8ixdtl6Q4=;
        b=dzoGs1mpKjzMmGb8iT8PO6t8fPTBn5RXndq9HWs224+GfROulbTovNT7cOFtQLfU88
         kmi30WBwgd5Cz6ZWvzT3N+8rkHs7YP0uQztIPY3IyHQk0G2mD1+W95ssu3YjvXcvKbjc
         T22L59OY0V/wZcR/hVqCJY9+vnRIM7lfu0ssLW3zkn3YmVuBdULEF4O0crZB4Y+qv1JP
         HBDm6A92JYOzsStjZlH6ySIRuOXTcIwUyXVujXAuKiTzTEr7b9Py4xdyphIK/+/dR6gd
         n8hWmrodga+nBtlOm9DJeC0jHAUrjtPLYjZLLZPj7elNxw8OlNQIZATB+bHXpO0OaKvB
         Endw==
X-Gm-Message-State: AOJu0Yzev16Lt0501A6xDHnRx1YVRWS3zQA/SjrZpQn3HFqDsWxDPZiB
	DTv6P4UnoUxbbM4CuLgoVpbcfu51KVG310sJ4g==
X-Google-Smtp-Source: AGHT+IGepoywKejyAoaQR8xobZotx6Ir6nRuJ6+QsOx4BUGWL/PUX4QE9vS6cBLlZRwYn4HeGALphxbC22U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:b90:b0:5c9:ed07:22d with SMTP id
 ck16-20020a05690c0b9000b005c9ed07022dmr2167319ywb.0.1704727763924; Mon, 08
 Jan 2024 07:29:23 -0800 (PST)
Date: Mon, 8 Jan 2024 07:29:22 -0800
In-Reply-To: <ZZv8XA3eUHLaCr8K@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050> <ZZSbLUGNNBDjDRMB@google.com>
 <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com> <ZZYbzzDxPI8gjPu8@chao-email>
 <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
 <ZZbJxgyYoEJy+bAj@chao-email> <CALMp9eTf=9VqM=xutOXmgRr+aFz-YhOz6h4B+uLgtFBXtHefPA@mail.gmail.com>
 <ZZhl4FHcdrzMXoVy@google.com> <ZZv8XA3eUHLaCr8K@linux.bj.intel.com>
Message-ID: <ZZwU0s8pjthw12Bb@google.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, Chao Gao <chao.gao@intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 08, 2024, Tao Su wrote:
> On Fri, Jan 05, 2024 at 12:26:08PM -0800, Sean Christopherson wrote:
> > On Thu, Jan 04, 2024, Jim Mattson wrote:
> > > On Thu, Jan 4, 2024 at 7:08=E2=80=AFAM Chao Gao <chao.gao@intel.com> =
wrote:
> > > >
> > > > On Wed, Jan 03, 2024 at 07:40:02PM -0800, Jim Mattson wrote:
> > > > >On Wed, Jan 3, 2024 at 6:45=E2=80=AFPM Chao Gao <chao.gao@intel.co=
m> wrote:
> > > > >>
> > > > >> On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wr=
ote:
> > > > >> >On Tue, Jan 02, 2024, Jim Mattson wrote:
> > > > >> >> This is all just so broken and wrong. The only guest.MAXPHYAD=
DR that
> > > > >> >> can be supported under TDP is the host.MAXPHYADDR. If KVM cla=
ims to
> > > > >> >> support a smaller guest.MAXPHYADDR, then KVM is obligated to =
intercept
> > > > >> >> every #PF,
> > > > >>
> > > > >> in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU =
supports only
> > > > >> 4-level EPT), KVM has no need to intercept #PF because accessing=
 a GPA with
> > > > >> RSVD bits 51-48 set leads to EPT violation.
> > > > >
> > > > >At the completion of the page table walk, if there is a permission
> > > > >fault, the data address should not be accessed, so there should no=
t be
> > > > >an EPT violation. Remember Meltdown?
> > > >
> > > > You are right. I missed this case. KVM needs to intercept #PF to se=
t RSVD bit
> > > > in PFEC.
> > >=20
> > > I have no problem with a user deliberately choosing an unsupported
> > > configuration, but I do have a problem with KVM_GET_SUPPORTED_CPUID
> > > returning an unsupported configuration.
> >=20
> > +1
> >=20
> > Advertising guest.MAXPHYADDR < host.MAXPHYADDR in KVM_GET_SUPPORTED_CPU=
ID simply
> > isn't viable when TDP is enabled.  I suppose KVM do so when allow_small=
er_maxphyaddr
> > is enabled, but that's just asking for confusion, e.g. if userspace ref=
lects the
> > CPUID back into the guest, it could unknowingly create a VM that depend=
s on
> > allow_smaller_maxphyaddr.
> >=20
> > I think the least awful option is to have the kernel expose whether or =
not the
> > CPU support 5-level EPT to userspace.  That doesn't even require new uA=
PI per se,
> > just a new flag in /proc/cpuinfo.  It'll be a bit gross for userspace t=
o parse,
> > but it's not the end of the world.  Alternatively, KVM could add a capa=
bility to
> > enumerate the max *addressable* GPA, but userspace would still need to =
manually
> > take action when KVM can't address all of memory, i.e. a capability wou=
ld be less
> > ugly, but wouldn't meaningfully change userspace's responsibilities.
>=20
> Yes, exposing whether the CPU support 5-level EPT is indeed a better solu=
tion, it
> not only bypasses the KVM_GET_SUPPORTED_CPUID but also provides the infor=
mation to
> userspace.
>=20
> I think a new KVM capability to enumerate the max GPA is better since it =
will be
> more convenient if userspace wants to use, e.g., automatically limit phys=
ical bits
> or the GPA in the user memory region.

Not really, because "automatically" limiting guest.MAXPHYADDR without setti=
ng
allow_smaller_maxphyaddr isn't exactly safe.  I think it's also useful to c=
apture
*why* KVM's max addressable GPA is smaller than host.MAXPHYADDR, e.g. if do=
wn the
road someone ships a CPU that actually does the right thing when guest.MAXP=
HYADDR
is smaller than host.MAXPHYADDR.

> But only reporting this capability can=E2=80=99t solve the KVM hang issue=
, userspace can
> choose to ignore the max GPA, e.g., six selftests in changelog are still =
failed.

I know.  I just have more pressing concerns than making selftests work on f=
unky
hardware that AFAIK isn't publicly available.

> I think we can reconsider patch2 if we don=E2=80=99t advertise
> guest.MAXPHYADDR < host.MAXPHYADDR in KVM_GET_SUPPORTED_CPUID.

Nah, someone just needs to update the selftests if/when the ept_5level flag
lands.

