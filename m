Return-Path: <kvm+bounces-4385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FFC811D26
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 19:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C05291C21201
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653BC60EEA;
	Wed, 13 Dec 2023 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RJCA3e8A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1463B11D
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702493100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zSA+WMrA8eO/D9HzsQduQ+zsnP8CvaI3GamGqZxjrOw=;
	b=RJCA3e8AW1IcyprvKLOj7bkgFXWrboRsxH//Tbb3i+p1wIrx4bhzZm5Xfo1uhCBCxT7OLe
	dYBuy64F4eJme9rmrRuNsOx72XXt5Tj+JWFD8YIS81TTSrAxmbED6s5+q38/eBi+QpDPhf
	8RNIder/vf+wmm6Gy3fIyV1jSUIzXqg=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-b_O8oupDNx2na8fpZwzRgw-1; Wed, 13 Dec 2023 13:44:56 -0500
X-MC-Unique: b_O8oupDNx2na8fpZwzRgw-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4b2e6e439ebso6660884e0c.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:44:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702493095; x=1703097895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSA+WMrA8eO/D9HzsQduQ+zsnP8CvaI3GamGqZxjrOw=;
        b=nrfYl0WoPocrsyUMZrHMGYvkzb2Mb3Jc1w5MXdbwNKJKFAogS5jWzMUyvGlvI7dxun
         ZKKE8sefZMV96h7w8/+zojn/dyWJzBRY31Qk7qB1k4WrLap8mnVoXExdPIFhiBS3Nd7o
         PJX9xq5/B0cyRtjVRXCaB2Zcn77usOBkXIB88ZtN1TMsKiMKAA5CB0U1XsarIsvdQVTM
         Yb3G0lhIui0TN+TKuJGYwYUrWCSGL+oUikfcog66FhZw6/YHUPvfqkUOdgc90pYd1XBn
         3fnfK1dlxy5w9uocf/9bJV/dVDWHkJUixFWBxWYxQ5RMJJSC21nQCROBuR/4lBqotNlP
         qLvw==
X-Gm-Message-State: AOJu0YyRiO3CpvD+CjOo4HAs0kiQSGEhWVMSeFGA1eZQE5V+Q5AUT8HI
	DsLvFD4bjmnGohynwu2xhT+58EjdM8X+3tDki/uVbnlS81A3K1LmpLDqq2hCPX4iVGso4qCkfFX
	ri62wRcB9mqF2/qFNC2GNUcRLUGGE
X-Received: by 2002:a05:6122:e2e:b0:4b4:f65b:49a4 with SMTP id bk46-20020a0561220e2e00b004b4f65b49a4mr2103428vkb.16.1702493095514;
        Wed, 13 Dec 2023 10:44:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJ87bsfaafWN7TmiHkXvwPee7xLp5yx+ghgAAlRqlkhVyDix4rrhL5FVVz/EoFRUwOMyi80+sfTHGP33aev3Q=
X-Received: by 2002:a05:6122:e2e:b0:4b4:f65b:49a4 with SMTP id
 bk46-20020a0561220e2e00b004b4f65b49a4mr2103424vkb.16.1702493095171; Wed, 13
 Dec 2023 10:44:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208184628.2297994-1-pbonzini@redhat.com> <ZXPRGzgWFqFdI_ep@google.com>
 <184e253d-06c4-419e-b2b4-7cce1f875ba5@redhat.com> <ZXnoCadq2J3cPz2r@google.com>
 <84ad3082-794b-443f-874a-d304934a395b@redhat.com> <ZXn0sR6IyzLzVHW-@google.com>
In-Reply-To: <ZXn0sR6IyzLzVHW-@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 13 Dec 2023 19:44:42 +0100
Message-ID: <CABgObfa9y3dwLjduS8UmGDRxLBfFVJ9T8GhHx=22arM+U6kBzw@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for aarch64
To: Sean Christopherson <seanjc@google.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 7:15=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > selftests have the luxury of having sync-ed kernel headers, but in gene=
ral
> > userspace won't, and that means __KVM_HAVE_READONLY_MEM would be a very=
 poor
> > userspace API.  Fortunately it has "__" so it is not userspace API at a=
ll,
> > and I don't want selftests to treat it as one.
>
> Wait, what?  How does double underscores exempt it from being uAPI?  AIUI=
, the C
> standard effectively ensures that userspace won't define/declare symbols =
with
> double underscores, i.e. ensures there won't be conflicts.  But pretty mu=
ch all
> of the kernel-defined types are prefixed with "__", e.g. __u8 and friends=
, so I
> don't see how prefixing with "__" exempts something from becoming uAPI.

Userspace is generally not supposed to know that double underscore
symbols exist, though in some cases it has to (see for example
_UFFDIO_*). Looking at yesterday's patch from Dionna, userspace is
very much not supposed to use _BITUL, and even less so for _UL.

In particular, __KVM_HAVE_* symbols are meant to mask definitions in
include/uapi/linux/kvm.h.
__KVM_HAVE_READONLY_MEM was a very misguided mean to define
KVM_CAP_READONLY_MEM only on architectures where it could have
possibly be true (see commit 0f8a4de3e088, "KVM: Unconditionally
export KVM_CAP_READONLY_MEM", 2014-08-29). Which does not make sense
at all, as the commit message points out. So I'm willing to test my
chances, kill it and see if anyone complains (while crossing fingers
that Google and Amazon don't :)).

Paolo

> I completely agree that __KVM_HAVE_READONLY_MEM shouldn't be uAPI, but th=
en it
> really, really shouldn't be defined in arch/x86/include/uapi/asm/kvm.h.
>

On Wed, Dec 13, 2023 at 7:15=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Dec 13, 2023, Paolo Bonzini wrote:
> > On 12/13/23 18:21, Sean Christopherson wrote:
> > > On Tue, Dec 12, 2023, Paolo Bonzini wrote:
> > > > On 12/9/23 03:29, Sean Christopherson wrote:
> > > > > On Fri, Dec 08, 2023, Paolo Bonzini wrote:
> > > > > > KVM/Arm supports readonly memslots; fix the calculation of
> > > > > > supported_flags in set_memory_region_test.c, otherwise the
> > > > > > test fails.
> > > > >
> > > > > You got beat by a few hours, and by a better solution ;-)
> > > > >
> > > > > https://lore.kernel.org/all/20231208033505.2930064-1-shahuang@red=
hat.com
> > > >
> > > > Better but also wrong---and my patch has the debatable merit of mor=
e
> > > > clearly exposing the wrongness.  Testing individual architectures i=
s bad,
> > > > but testing __KVM_HAVE_READONLY_MEM makes the test fail when runnin=
g a new
> > > > test on an old kernel.
> > >
> > > But we already crossed that bridge and burned it for good measure by =
switching
> > > to KVM_SET_USER_MEMORY_REGION2, i.e. as of commit
> > >
> > >    8d99e347c097 ("KVM: selftests: Convert lib's mem regions to KVM_SE=
T_USER_MEMORY_REGION2")
> > >
> > > selftests built against a new kernel can't run on an old kernel.  Bui=
lding KVM
> > > selftests requires kernel headers, so while not having a hard require=
ment that
> > > the uapi headers are fresh would be nice, I don't think it buys all t=
hat much.
> > >
> > > If we wanted to assert that x86, arm64, etc. enumerate __KVM_HAVE_REA=
DONLY_MEM,
> > > i.e. ensure that read-only memory is supported as expected, then that=
 can be done
> > > as a completely unrelated test.
> >
> > selftests have the luxury of having sync-ed kernel headers, but in gene=
ral
> > userspace won't, and that means __KVM_HAVE_READONLY_MEM would be a very=
 poor
> > userspace API.  Fortunately it has "__" so it is not userspace API at a=
ll,
> > and I don't want selftests to treat it as one.
>
> Wait, what?  How does double underscores exempt it from being uAPI?  AIUI=
, the C
> standard effectively ensures that userspace won't define/declare symbols =
with
> double underscores, i.e. ensures there won't be conflicts.  But pretty mu=
ch all
> of the kernel-defined types are prefixed with "__", e.g. __u8 and friends=
, so I
> don't see how prefixing with "__" exempts something from becoming uAPI.
>
> I completely agree that __KVM_HAVE_READONLY_MEM shouldn't be uAPI, but th=
en it
> really, really shouldn't be defined in arch/x86/include/uapi/asm/kvm.h.
>


