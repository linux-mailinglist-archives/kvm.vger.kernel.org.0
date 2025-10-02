Return-Path: <kvm+bounces-59431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E57BB461E
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 17:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 424C63BD3FE
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 15:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290A6226CEB;
	Thu,  2 Oct 2025 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0UZ56mjI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C653B224B04
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419730; cv=none; b=LYb4reM+fTFMQvMGKxZYlj1vyFe/cB/ATxzKj7syFUWH1d6BKZYjcSpkIInxGU0rR90wrU5lp7kA3B/oOowwukRnRwKFyr8ZqWS+JsyLRdim5B93wWBwi2MtZyYOFJt1qNwA89jhGNwGBjHpIHNzpLVCNfpKHBboCuLAbIIdsBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419730; c=relaxed/simple;
	bh=ELnqNe+Yjy1W6DliVLfikXo5OG04QMhkg2KzQdKNat0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWWH9neDgCa8Lkrvddm1cIIg++rjrD9NZGa992bMjpqU7Q9ZzAvS2VTVe/LmwPaFt1zcPAiI/6QeeE6NAJjhCfBxPkx5WEOzvXrLXwAdbb+uP0LhLlB6RSeEhRzTI0WE57q/RaG16hXxxAHpBOgu3pd1VkN666xluWMixdKH7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0UZ56mjI; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27d67abd215so231715ad.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 08:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759419728; x=1760024528; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H3/8YZKb78qfaKUeDi5eSNNRwUxESShbW+B1O8PpqLE=;
        b=0UZ56mjIbj/w4YezkPNMOm4ImiRSaqKgG+kCKJUWhyuV4tbUxyKtuuVKqRaZn/Iluu
         eIFbMb0T2ECxscc9YbeZkEnisZtbxNCOwCEzGnPBnDbXDB5zNsGAeEFVm/+vXJfu4Vch
         7a1AXc3GAaI31WbOVl8sYQRHwLWM3TXB6pX2bq6j5q9sGsqClmA9HY1yHuZbLHzzJ1pt
         pkG6q2EG3GKRpvQHp967POGCmiTYl95kNhrZEelNGeoI9toTAgeHnxpDZGzdrE5k+Q63
         lxmPqZrLNFTzWNZZmZ6DZnAKLUkyIJoAxCngizIDsDPwpF45FiMhcUq575tuBNGBjVce
         kEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759419728; x=1760024528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H3/8YZKb78qfaKUeDi5eSNNRwUxESShbW+B1O8PpqLE=;
        b=dekQWjNLmpuE01AgfHEwFktgAUBRnSd4HNZZCEPYExFeIyXsGv64RIwdFjdYtsNJWZ
         bS72jhG8N5brZ1W5+RdgtVpp5PGxr7MfmkMCoQORUs7YIdW3VBcPqmXNkgT7o0TlgYpc
         BEHBPDWlx8uRYFXzSohJ6K9DkxhiCSn55/wTEp90QGdVzavTU+FH/kfpQODZJroJ8+Tj
         QR5d5kCUbVhxMItWtLjRBOIJsECCMzMr4IwEd/eK8UyCUnDM6fMhm1SRrpXQTA0L98Q6
         SiDEub7nSZRRJQD9nmNBDqfpx7Q0HWxQ1GmnB2P3iBdjN2RYR1cq204Te3n0xqC+otz/
         9apQ==
X-Forwarded-Encrypted: i=1; AJvYcCWthWZImQG1iUbwt+989ryMOYP2SfaBHNXCRSy6YmHmg8LwYdkxHKFSKOlTzoWD+/7Mi+I=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj5f7YcN9/9/D7qmFmhiSuZtT6EAAPtY82EYMl1j/H79m+5z0h
	WlWrQY1chmzac9W76rEXNuYNcLUNMb7LA2YKB6k/lR8Ms6h68dvrf8DqwmHBB0nPsNki6AXff6q
	uPBhspy6IGjU7enpoR+fzEG8rUx9JphtsGRTp/WO6
X-Gm-Gg: ASbGncsFx/LUiIlkn22dv6PVwJtxD+x5W/XbDI+Mtsva1vtoq+xyXS1IMtkv/wbPObf
	BfiBswGJQ5DnfdUGekIR5++eKN/65YFHaCDFOtEaAc+/Q+FaxxMow2ulkdpo3O3jT2s6o6jk2I7
	TwDnBWxGa/8BOmpLEagPwdB/Q74omEIwxrL/za+6FZt4ngaSGBPndidGJO4MEkSb5jU+0qEgWDl
	wL81gfQL8Vf7LQzA9tddnazMs5/afy8JgTDEjR31KBf7WD022/2hDteFISCUPjvjH2gjZu0tRaJ
	d3ivMQ==
X-Google-Smtp-Source: AGHT+IGiYc77i8nX+Z2g2INjozhLBkRfFMX1H3oJMQJTQ9c5FFCBUYoMWU0i/9BJoLlAJlBLBN+UnC4qkbLI8K2O4nQ=
X-Received: by 2002:a17:902:cf0f:b0:26a:a69:1d8c with SMTP id
 d9443c01a7336-28e8ea947c7mr4078255ad.17.1759419727349; Thu, 02 Oct 2025
 08:42:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com> <aNshILzpjAS-bUL5@google.com>
 <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
 <aN1TgRpde5hq_FPn@google.com> <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
 <aN1h4XTfRsJ8dhVJ@google.com> <CAGtprH-5NWVVyEM63ou4XjG4JmF2VYNakoFkwFwNR1AnJmiDpA@mail.gmail.com>
 <aN3BhKZkCC4-iphM@google.com>
In-Reply-To: <aN3BhKZkCC4-iphM@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 2 Oct 2025 08:41:54 -0700
X-Gm-Features: AS18NWCJxtIe6xIIIw7eyTkEkDk9o_zgkLRq6XWM0vDf2Pb1z9fDhfHRGlEOtAA
Message-ID: <CAGtprH_evo=nyk1B6ZRdKJXX2s7g1W8dhwJhEPJkG=o2ORU48g@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nikita Kalyazin <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 5:04=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > On Wed, Oct 1, 2025 at 10:16=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > > > On Wed, Oct 1, 2025 at 9:15=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > >
> > > > > On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > > > > > On Mon, Sep 29, 2025 at 5:15=E2=80=AFPM Sean Christopherson <se=
anjc@google.com> wrote:
> > > > > > >
> > > > > > > Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and=
 thus
> > > > > > > KVM_CAP_GUEST_MEMFD_MMAP.  Two things:
> > > > > > >
> > > > > > >  1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GU=
EST_MEMFD_FLAGS so
> > > > > > >     that we don't need to add a capability every time a new f=
lag comes along,
> > > > > > >     and so that userspace can gather all flags in a single io=
ctl.  If gmem ever
> > > > > > >     supports more than 32 flags, we'll need KVM_CAP_GUEST_MEM=
FD_FLAGS2, but
> > > > > > >     that's a non-issue relatively speaking.
> > > > > > >
> > > > > >
> > > > > > Guest_memfd capabilities don't necessarily translate into flags=
, so ideally:
> > > > > > 1) There should be two caps, KVM_CAP_GUEST_MEMFD_FLAGS and
> > > > > > KVM_CAP_GUEST_MEMFD_CAPS.
> > > > >
> > > > > I'm not saying we can't have another GUEST_MEMFD capability or th=
ree, all I'm
> > > > > saying is that for enumerating what flags can be passed to KVM_CR=
EATE_GUEST_MEMFD,
> > > > > KVM_CAP_GUEST_MEMFD_FLAGS is a better fit than a one-off KVM_CAP_=
GUEST_MEMFD_MMAP.
> > > >
> > > > Ah, ok. Then do you envision the guest_memfd caps to still be separ=
ate
> > > > KVM caps per guest_memfd feature?
> > >
> > > Yes?  No?  It depends on the feature and the actual implementation.  =
E.g.
> > > KVM_CAP_IRQCHIP enumerates support for a whole pile of ioctls.
> >
> > I think I am confused. Is the proposal here as follows?
> > * Use KVM_CAP_GUEST_MEMFD_FLAGS for features that map to guest_memfd
> > creation flags.
>
> No, the proposal is to use KVM_CAP_GUEST_MEMFD_FLAGS to enumerate the set=
 of
> supported KVM_CREATE_GUEST_MEMFD flags.  Whether or not there is an assoc=
iated
> "feature" is irrelevant.  I.e. it's a very literal "these are the support=
ed
> flags".
>
> > * Use KVM caps for guest_memfd features that don't map to any flags.
> >
> > I think in general it would be better to have a KVM cap for each
> > feature irrespective of the flags as the feature may also need
>                                                    ^^^
> > additional UAPIs like IOCTLs.
>
> If the _only_ user-visible asset that is added is a KVM_CREATE_GUEST_MEMF=
D flag,
> a CAP is gross overkill.  Even if there are other assets that accompany t=
he new
> flag, there's no reason we couldn't say "this feature exist if XYZ flag i=
s
> supported".
>
> E.g. it's functionally no different than KVM_CAP_VM_TYPES reporting suppo=
rt for
> KVM_X86_TDX_VM also effectively reporting support for a _huge_ number of =
things
> far beyond being able to create a VM of type KVM_X86_TDX_VM.
>

What's your opinion about having KVM_CAP_GUEST_MEMFD_MMAP part of
KVM_CAP_GUEST_MEMFD_CAPS i.e. having a KVM cap covering all features
of guest_memfd? That seems more consistent to me in order for
userspace to deduce the supported features and assume flags/ioctls/...
associated with the feature as a group.

