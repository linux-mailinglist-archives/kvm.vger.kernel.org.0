Return-Path: <kvm+bounces-23287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA08E94864E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81F9D284568
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A1316F0C6;
	Mon,  5 Aug 2024 23:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Hxt0O+7K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4535273FD
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901463; cv=none; b=epKvNyR3EiCG07kkW8MI4ig0Uo5C1/vF+7dfbHhc0lEA5VLsdOdzTk2VaFNZqjzeIBiHkz464avqjIrV5SjeygqZPeMUcczjHeWEvT6pOvv12NCr4lyofOQJgDyqNWyEd7Gg0MdrzIXEbaF0010YiijkElyJhC5XLeGtXQcBaW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901463; c=relaxed/simple;
	bh=N36BgzP/Ze7QI1FmjnSinfkcU4TKCKVAfKUS3FFhhCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WJFBrK0OJTLVbcoEsqTrvAlnqgWiWS1RvhTNt/wRbWVEWIQfz1Hw/F6afbSlHVE6/cYZTdLM3kJ/n+pA/Ke5cgBVhlvfR4S01a8JY7Y8fpj/dcfc+EEfrCjAJstnHEPHVLU3VV+bvXD2HoskYlzf6ldeAbRdw6FcVwG+5LUybhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Hxt0O+7K; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ef25511ba9so48054051fa.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1722901460; x=1723506260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ldf/5dV/loYFjBwyCn5nK6gnfSKwn5dyvPTT5/+hrg8=;
        b=Hxt0O+7KivZfcyasMKLnfYIzaXxvHvaX4e45o+khL6U0hf0sPrQjNs4ilukfmMVPkc
         8AZnFrJMYPJGiH/98DkgTwV6MDsfSt+PKJBc8vJHfheGRk1jQo8tvk8mclbBpjF0mZI5
         IPLZMvndIjAlynZ2pPGN49npQZaEkJ/hjhfWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722901460; x=1723506260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ldf/5dV/loYFjBwyCn5nK6gnfSKwn5dyvPTT5/+hrg8=;
        b=HzE7+IOOhrORBP6rzXj/WXbNNd6453jxq/Hflw0BHc2JKXlBwXKFiU/TMqZl0GlkfO
         hC3tbixwB9cz1lkocuCXTM0E5BL8YdlqAVCh0WZAJA+t5f54mlvJUEfbyR32V1/GZbJf
         y05YtnGy3ItKPG6xitkwYtZDpFe/316UPwAVz9Ag7KPQwcqGiA92QPLQSb92/H1Gdbx9
         As+kV012lIbP4mdatNMueDDjtJvWUNxxPnX28E5KMJ5c8HP0r4anzU7vEe8SgY774ppO
         aJO24LIpGdkzfo23AgGm22bTlJdIXP8/9GtdlznLMtpwWsJCe9wCRTP1EKnDMXEbokRZ
         WvPA==
X-Forwarded-Encrypted: i=1; AJvYcCUPlEfJzoMuQH5cmMCwn9LrjyFmimuv8X3iPyw22L15TK/7hLmbCkAHCgFFJSda4MesgybAlKnNo/2nZ7LR6KJnCLnw
X-Gm-Message-State: AOJu0YyAfLpVgpq3FjPex6X4Ipp2taCjw052W7V5rFLLMncR77ssje5n
	Hn0M2COcAnkd9yyhdhMTAT0bKuc+yHSz4wgkae+mbwmpDBVVoi+HHbfaniGIKuSJ8o5mD4uw9PS
	cRXfHLh3ptkRKzocMbe2uIfCTuU9vYHmvME5B
X-Google-Smtp-Source: AGHT+IHIK0kYEUYapI5tIc8vSMvjbESuyPpwn3iTc/MzDz8eRJWcfhJa0eyJoudkIswN6TS8V0q74Bp34S0uh1BvkQE=
X-Received: by 2002:a2e:9004:0:b0:2ec:347a:b020 with SMTP id
 38308e7fff4ca-2f15b13c649mr36224431fa.12.1722901459336; Mon, 05 Aug 2024
 16:44:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZnXHQid_N1w4kLoC@google.com>
 <87cymtdc0t.fsf@draig.linaro.org>
In-Reply-To: <87cymtdc0t.fsf@draig.linaro.org>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 6 Aug 2024 08:44:08 +0900
Message-ID: <CAD=HUj6gjqthaenpZUr2Lci3WJW86OWe559YrDWiUSVfZBNHiQ@mail.gmail.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 8:41=E2=80=AFPM Alex Benn=C3=A9e <alex.bennee@linar=
o.org> wrote:
>
> Sean Christopherson <seanjc@google.com> writes:
>
> > On Thu, Feb 29, 2024, David Stevens wrote:
> >> From: David Stevens <stevensd@chromium.org>
> >>
> >> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> >> that is backed by struct pages that aren't currently being refcounted
> >> (e.g. tail pages of non-compound higher order allocations) into the
> >> guest.
> >>
> >> Our use case is virtio-gpu blob resources [1], which directly map host
> >> graphics buffers into the guest as "vram" for the virtio-gpu device.
> >> This feature currently does not work on systems using the amdgpu drive=
r,
> >> as that driver allocates non-compound higher order pages via
> >> ttm_pool_alloc_page().
> >>
> >> First, this series replaces the gfn_to_pfn_memslot() API with a more
> >> extensible kvm_follow_pfn() API. The updated API rearranges
> >> gfn_to_pfn_memslot()'s args into a struct and where possible packs the
> >> bool arguments into a FOLL_ flags argument. The refactoring changes do
> >> not change any behavior.
> >>
> >> From there, this series extends the kvm_follow_pfn() API so that
> >> non-refconuted pages can be safely handled. This invloves adding an
> >> input parameter to indicate whether the caller can safely use
> >> non-refcounted pfns and an output parameter to tell the caller whether
> >> or not the returned page is refcounted. This change includes a breakin=
g
> >> change, by disallowing non-refcounted pfn mappings by default, as such
> >> mappings are unsafe. To allow such systems to continue to function, an
> >> opt-in module parameter is added to allow the unsafe behavior.
> >>
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
>
> I've applied this series to the latest 6.9.x while attempting to
> diagnose some of the virtio-gpu problems it may or may not address.
> However launching KVM guests keeps triggering a bunch of BUGs that
> eventually leave a hung guest:
>

Likely the same issue as [1]. Commit d02c357e5bfa added another call
to kvm_release_pfn_clean() in kvm_faultin_pfn(), which ends up
releasing a reference that is no longer being taken. If you replace
that with kvm_set_page_accessed() instead, then things should work
again. I didn't send out a rebased version of the series, since Sean's
work supersedes my series.

-David

[1] https://lore.kernel.org/lkml/15865985-4688-4b7e-9f2d-89803adb8f5b@colla=
bora.com/

