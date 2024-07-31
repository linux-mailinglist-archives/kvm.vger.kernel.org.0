Return-Path: <kvm+bounces-22771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5161943299
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF0941C20839
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88BD14A90;
	Wed, 31 Jul 2024 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3xRRTUT9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE1D2F37
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438084; cv=none; b=Io+MF1GvVptBS6SwgO7Kfz7yilksQuiM+PiqhULOuE2PFz4pSoSI+kKSL9QyBP2+qa8FoBqc8DTP8MstYZ+CHqJ+zpDa5VO4APXbF0dd+hL8E6cX0i4XTzz4UvAqE5fepWRPBBEHaiGvalrna1atESEY/iCPEDoodaRlNgRo9V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438084; c=relaxed/simple;
	bh=wUHLhFS9SdXHmqa3PQC6xsI/T85uU0FHGAHHTqH7qew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WJC0szHoCwRkw5VaChPpqNsLubY3Ny32kQMWilEpS4TFgXlXXe9sjabumrxrIKhPEqD3EXzkDIg4GEgnHQqsHdi7QVEifK4KJerKgtG1PNHCayb6wDyLLsht6j+XqND0y9/zZaa0ap/yIFhZ+HhQVFC3uC7C0Fde1XyOvmCa2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3xRRTUT9; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7acb08471b1so3068156a12.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 08:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722438082; x=1723042882; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNJBybQopQ2ZrxRweqcaE48I1KQGrUoMT3Gla2tgL0c=;
        b=3xRRTUT9Lxg9Pt5q3mX3veCC3CBSxjoRg7JuyFreN2guenAh34q6Fc70OF9yvqJI+y
         XM8lD8DrxJ6iuqxcBQfFRcWfjJORSI5Z6fNfQYCfP1ngzsvjNWmQUTd7dm3RzZ9un0Vp
         kkQoucLYdWUrjKJ4y1BqNeNf5PlXYGaZvDM4QW6KNjM3KliPDu9Qkr8qjnnnWfEGfIvb
         lI/smDcZErgunOcJUXj7e44VovwKpgS4pzcFL8pBzQ6uB9K4W8DrcfSzTDaq/3956KHb
         +BygWzRsIp9eBHsVw9I7Szrcq4RaYLgZmsHHadx5zpv4yUK6W7zVRzK8DeNZS8vUe8QB
         dKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722438082; x=1723042882;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gNJBybQopQ2ZrxRweqcaE48I1KQGrUoMT3Gla2tgL0c=;
        b=e90d7HKWHAeeJLNIPQ/1ruP9Yha0j76pYoIJEjMEgcP8+JAq7uCO9VPrqQDDikbzB1
         llGrAZDKz8eg+eOCUzzb9Zz+VYIz/vPMLcR9zA0UUq/5hpcYvSCI5meFy7jFBnOQDWOJ
         I2Fbfo7IAaj76ztTRVSj5YLCV2ud8GaTJissGGTr9wSKs7Zk7icnKIckOZm1mjN+J6WJ
         jyldWvOTgy5SECfq1IIE4tPEqngh/eC4OKxS0//U8T/jj3a/4CwWQMaUeYYYyFJFFFp1
         1NvG08RAR0yeyn9bopL6DYuAK1pdDhw6dq855DSHuhQAVeM9NyQDwWA4wbcXNZguhqbn
         WZew==
X-Forwarded-Encrypted: i=1; AJvYcCVsXmjis7rMMcWErwvbMey9PvUMWR932iL8cVFJ1NRXGRF4jIR9h86jpuNOCI4/zq/qJ9q7Pis7R1f1rPOan51tkXKh
X-Gm-Message-State: AOJu0YwJUUoPO6VGRcEdoCMS/BxrjJJsrukuGc4yBtv9Xs/XgVNpfWxN
	jLj9NXxT2p6m6mCQ4fE0eVOeFJKgxqh+QjsJZ56QcY3liaeXN990vSMkBv/EPOcK2e3aTXAqwFb
	xSQ==
X-Google-Smtp-Source: AGHT+IGcAn8E6dkVWW8sE36BP9jCnCmxK5HfcNcn6NYUeDPjrXiDSAMLJMNmKjWnCHzC8DBP855Q/NibcH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:610:b0:7a1:6633:6a07 with SMTP id
 41be03b00d2f7-7ac8dcbb142mr75473a12.2.1722438081874; Wed, 31 Jul 2024
 08:01:21 -0700 (PDT)
Date: Wed, 31 Jul 2024 08:01:20 -0700
In-Reply-To: <87cymtdc0t.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZnXHQid_N1w4kLoC@google.com>
 <87cymtdc0t.fsf@draig.linaro.org>
Message-ID: <ZqpRwCKxVkDmmDB3@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: David Stevens <stevensd@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > On Thu, Feb 29, 2024, David Stevens wrote:
> >> From: David Stevens <stevensd@chromium.org>
> >>=20
> >> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> >> that is backed by struct pages that aren't currently being refcounted
> >> (e.g. tail pages of non-compound higher order allocations) into the
> >> guest.
> >>=20
> >> Our use case is virtio-gpu blob resources [1], which directly map host
> >> graphics buffers into the guest as "vram" for the virtio-gpu device.
> >> This feature currently does not work on systems using the amdgpu drive=
r,
> >> as that driver allocates non-compound higher order pages via
> >> ttm_pool_alloc_page().
> >>=20
> >> First, this series replaces the gfn_to_pfn_memslot() API with a more
> >> extensible kvm_follow_pfn() API. The updated API rearranges
> >> gfn_to_pfn_memslot()'s args into a struct and where possible packs the
> >> bool arguments into a FOLL_ flags argument. The refactoring changes do
> >> not change any behavior.
> >>=20
> >> From there, this series extends the kvm_follow_pfn() API so that
> >> non-refconuted pages can be safely handled. This invloves adding an
> >> input parameter to indicate whether the caller can safely use
> >> non-refcounted pfns and an output parameter to tell the caller whether
> >> or not the returned page is refcounted. This change includes a breakin=
g
> >> change, by disallowing non-refcounted pfn mappings by default, as such
> >> mappings are unsafe. To allow such systems to continue to function, an
> >> opt-in module parameter is added to allow the unsafe behavior.
> >>=20
> >> This series only adds support for non-refcounted pages to x86. Other
> >> MMUs can likely be updated without too much difficulty, but it is not
> >> needed at this point. Updating other parts of KVM (e.g. pfncache) is n=
ot
> >> straightforward [2].
> >
> > FYI, on the off chance that someone else is eyeballing this, I am worki=
ng on
> > revamping this series.  It's still a ways out, but I'm optimistic that =
we'll be
> > able to address the concerns raised by Christoph and Christian, and may=
be even
> > get KVM out of the weeds straightaway (PPC looks thorny :-/).
>=20
> I've applied this series to the latest 6.9.x while attempting to
> diagnose some of the virtio-gpu problems it may or may not address.
> However launching KVM guests keeps triggering a bunch of BUGs that
> eventually leave a hung guest:

Can you give v12 (which is comically large) a spin?  I still need to do mor=
e
testing, but if it too is buggy, I definitely want to know sooner than late=
r.

Thanks!

https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com

