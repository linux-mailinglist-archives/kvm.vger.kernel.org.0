Return-Path: <kvm+bounces-11574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2C087860B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90AB11C210A4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993774AEDE;
	Mon, 11 Mar 2024 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KGDDdzX5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE07487BF
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710176975; cv=none; b=ERhrQQhr8c2zA8MxtHcdKHkC9gzfqZ7/o59VX2MItTJdbcKLKpXCdkI9il5hlfMrqgaXZJn1hh9WjPTgj0NA1q3A5c9gds6DlxZ3MrqQ1n8lHSWGAsmUeTx6WzgFUIlQn6kIeRonZ3AOD/+dUMpPyz3mG1Idc9u9ynOmzrBqYHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710176975; c=relaxed/simple;
	bh=XLk19ZBhBhVn7IUOsmvZ8U8sgpOdtTT2ysq1KfrJWls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kELQhOLkCMobE+ZHHb7vcpMVoWzx5Hx6yV0OGvNzn9MD4Aagi6IZwnO1M2VDcj/+KoEnqMluaa5k6v8vZY3RtCrYOGpxaDmh7dkKjineth9VBo78jy96vtROgk44vi8pX1patFt+T3pSMg3nYWczVv7yoOsHkFc4qbmwKMgjvnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KGDDdzX5; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5a1ca29db62so2008980eaf.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710176973; x=1710781773; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1OwM9AzJwgsVuat8jwfOhprJEE77wo3Y3VPYftmF6ms=;
        b=KGDDdzX5jS1bRoK8jMLxPuE0CBZcRgmykDy0/33JQX+h6AKTp+MoCoSFmJ6mFW16GO
         FpNIfbK3GY2cBiTxeuIp8Bwt0fwZA4/7liw4Yo4Qji13RpLvvXyEz75sHSzyT7E3cYwZ
         rtiM04F4RWHbUVfM2Y+5najL2AM6HxHLJ8we3kAd05WwZ5JeaNrY9Wn2x568aX7cHWLV
         LfmHuAdj9zcm/4GAMJDuiDZb/HWtaKHrFJ7jN/x6qKkrSpBIMSErVdWS9DgRT3OgwI4l
         NizCl4zlosBpa94VJ1aGpjvqKoj/N9bZ9IalyIXTiE686AOGk5SmMzfLfgMpAv+DVAWs
         1/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710176973; x=1710781773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1OwM9AzJwgsVuat8jwfOhprJEE77wo3Y3VPYftmF6ms=;
        b=YZjNxFCWKi/257e/oEFLLyw+/taPpxfhMNFcrI+Qqvyasv9JuKweQeTMG0LgOqHcQl
         2F4yDrB8LByNYrfFqMDWgKDLyHHbZPiI9hJv4fl0SLxppG4+YxGss8C6vWywNGsnhM3n
         3ByM9bilaiHkHg1kbQt0tql8rYu+49JMT4XijEke/RLZAOKSQAHadAa33/cwFfHw/psB
         Rs27ze9k9mpdr38G1PjreX8t6R9Q61eKn0uVXrrNK+GMJyfjrMaDIPQWuTQAonhkh7yo
         7t+NT5+ly56tSSyKMAoNtNmvnOXrLTJ1dIA4/B9u7omHB0muMmTF3woYVdQuMCC8P33n
         yq9A==
X-Forwarded-Encrypted: i=1; AJvYcCWMm9YyuepZi/kCd8hhfMyz+UlM8yhpFYFFZUA2iicaxBYKRBTwVzY6Nhgo+AthMroooXpNRoBsCSKu/JtnmN9CcZex
X-Gm-Message-State: AOJu0YyjB/NNwIHAwcsQbWbD5lh6Nukb3BDtB2Lw9FL7IWIiEDEp2kxo
	lFLar8U7Caq+gwZRfVPmkkgKT8ZCvqiUctai+7FiZqkgSt4omeZFSnUiAA5tcvq9sYh1QCtG6DB
	XbCwANmxGImsouN0DMdB0TH/pah98ARfGiLQR
X-Google-Smtp-Source: AGHT+IGEttitqS00mYuaoUzQDWimuQr0uAhH+JIPafnITXzap2JWpX6yyqziJd28u6Zj6hxcz6fDiiDFyq5Q34h2lVw=
X-Received: by 2002:a05:6820:160e:b0:5a1:249d:926 with SMTP id
 bb14-20020a056820160e00b005a1249d0926mr6766936oob.6.1710176973153; Mon, 11
 Mar 2024 10:09:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com> <ZeuxaHlZzI4qnnFq@google.com>
 <Ze6Md/RF8Lbg38Rf@thinky-boi> <Ze8y-vGzbDSLP-2G@google.com>
In-Reply-To: <Ze8y-vGzbDSLP-2G@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 11 Mar 2024 10:08:56 -0700
Message-ID: <CAF7b7mpgeLJudcT9YhjQOqsXxz07Y9PY1a-F0ts6oVsVJwrnpA@mail.gmail.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 10, 2024 at 9:46=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hey,
>
> Thanks Sean for bringing this up on the list, didn't have time for a lot
> of upstream stuffs :)
>
> On Fri, Mar 08, 2024 at 04:46:32PM -0800, David Matlack wrote:
> > On 2024-03-08 02:07 PM, Sean Christopherson wrote:
> > > On Thu, Feb 15, 2024, Anish Moorthy wrote:
> > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kv=
m/api.rst
> > > > index 9f5d45c49e36..bf7bc21d56ac 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
> > > >    #define KVM_MEM_LOG_DIRTY_PAGES        (1UL << 0)
> > > >    #define KVM_MEM_READONLY       (1UL << 1)
> > > >    #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> > > > +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
> > >
> > > David M.,
> > >
> > > Before this gets queued anywhere, a few questions related to the gene=
ric KVM
> > > userfault stuff you're working on:
> > >
> > >   1. Do you anticipate reusing KVM_MEM_EXIT_ON_MISSING to communicate=
 that a vCPU
> > >      should exit to userspace, even for guest_memfd?  Or are you envi=
sioning the
> > >      "data invalid" gfn attribute as being a superset?
> > >
> > >      We danced very close to this topic in the PUCK call, but I don't=
 _think_ we
> > >      ever explicitly talked about whether or not KVM_MEM_EXIT_ON_MISS=
ING would
> > >      effectively be obsoleted by a KVM_SET_MEMORY_ATTRIBUTES-based "i=
nvalid data"
> > >      flag.
> > >
> > >      I was originally thinking that KVM_MEM_EXIT_ON_MISSING would be =
re-used,
> > >      but after re-watching parts of the PUCK recording, e.g. about de=
coupling
> > >      KVM from userspace page tables, I suspect past me was wrong.
> >
> > No I don't anticipate reusing KVM_MEM_EXIT_ON_MISSING.
> >
> > The plan is to introduce a new gfn attribute and exit to userspace base=
d
> > on that. I do forsee having an on/off switch for the new attribute, but
> > it wouldn't make sense to reuse KVM_MEM_EXIT_ON_MISSING for that.
>
> With that in mind, unless someone else has a usecase for the
> KVM_MEM_EXIT_ON_MISSING behavior my *strong* preference is that we not
> take this bit of the series upstream. The "memory fault" UAPI should
> still be useful when the KVM userfault stuff comes along.
>
> Anish, apologies, you must have whiplash from all the bikeshedding,
> nitpicking, and other fun you've been put through on this series. Thanks
> for being patient.

No worries- I got a lot of patient (and much-needed) review as well
:). And I understand not wanting to add an eternal feature when
something better is coming down the line.

On Mon, Mar 11, 2024 at 9:36=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Oh, and I'll plan on grabbing patches 1-4 for 6.10.

I think patches 10/11/12 are useful changes to the selftest that make
sense to merge even with KVM_MEM_EXIT_ON_MISSING being mothballed-
they should rebase without any issues. And the annotations on the
stage-2 fault handlers seem like they should still be added, but I
suppose David can do that with his series.

