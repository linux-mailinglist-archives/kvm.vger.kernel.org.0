Return-Path: <kvm+bounces-8062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55CB184AAF8
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 01:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 128DB28C218
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB76EEC7;
	Tue,  6 Feb 2024 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sA7uDE+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16DA39B
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 00:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178351; cv=none; b=d3ac7EgRc0S083DMmP+LOfXOsksaiV606esnByzd9Fvg2UVQsSH3+L4fXhaw/NBT8xwInd+WA5YDSGa1VLATYquReRWkF4Db4lGNbAmiCoQGYQnwgQiGWDs6mtMnYgqwSpIzMPdfh28VrhQ1ZQVfkaCcrQ0vJhmn/WpXKp/YfT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178351; c=relaxed/simple;
	bh=U7p1iFE6ywvljPJognZaN8unEMxJXmtola9t/S0saE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BtvdbgXwrAatayMfB2M87sdeuYrTM7hN3eBy+n7LIkfIvkXxSdPxqH+Uinv7oQHkADEXumLTElRkulmAvtyzDCFBGbt7LwrIyK+RawYeIMkBNfpE/BfDYndOgIxv3B6/Qelezz0XK7M1La3DUp84hgFb41m8UpNHTAhJEXnPEF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sA7uDE+p; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dbddee3694so38938a12.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 16:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707178349; x=1707783149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2aHBcot/2NqMYA7ZGuWe5JuLCcnyjFV+ziaoOKAd19I=;
        b=sA7uDE+p+Au52Gr59NBaIRz8K9RyvlI4tf6Tys6SP2l2xwq/ndA5cisuoDeoKPnSgr
         BavVl4oTvJdoFP04y/aLvvtCBG6vun3c13SVJhm7DMTIpxEFU/1i5OjGGrGGFHrsT5zp
         8IaKrXYgMA6RFXPcRemSQSNAIBPzPZgDl2gr/BLVJr+bUdRh2r9o+twViZhKVbiMaZ/Y
         804r6L7y8ImuXPY1ut/ZItCT7cpawXV9SXI7IwD3cIi7AQKF3zCJvyu/BG56rS+oVDTg
         SSCcu4kJvFLQhEKyIJf9/EaJW20RG0ULkZHLIe4HpLWri1AEka3k5shpznmCAjOsEbiA
         9pxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707178349; x=1707783149;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2aHBcot/2NqMYA7ZGuWe5JuLCcnyjFV+ziaoOKAd19I=;
        b=FxUqw1Lv5bMPVrXSoCwfsvRjh5hRXDcflsPPins8O/ox1fSZmfL+dl5CWxeM7MPWGx
         FRkTvoEVFjskEmC+Kp77X/WQarEChGxSGzXL3PUGboIEKSkyRvx8gt3QY8v76nTfAZXJ
         lfKSjpxTDwdK67RN+663F+vTwwBVGHVMKXtVLEcpif1cMqHxJIBrGMO1oDP+zfBwHisB
         VvivXZPnClnLMo+4xLsOePqdqamGDnxnN3CygFmAh8CkFF2Ll/twjRWH4P3lptl8hTvK
         BQlGrKtDMG0Egie/VKwUqztZ5nlFVWNak6x/4fraDeic2v5h1FevCCHxqsHt1C07mPnw
         JJNw==
X-Gm-Message-State: AOJu0Yz69POqssGmZ0fTnFHIdaOOdHoxM0bZ3k2t+8F2NNFZFLAvGAvP
	epPfRNsRBv3dDwn8riV2IvV+HMKAy8nUKwVsKA0Wxy9vfYfFwQO4ooLMHBItaRGnDWsd07KCwhr
	cow==
X-Google-Smtp-Source: AGHT+IGrtWHSBFbmlk1OGbAiCKrrldxhM8yAJ86BBSoQJD/eK75NBEnbVI50mHb+WvJO+r3RBjcBOSJoxps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ced1:b0:1d9:5778:f923 with SMTP id
 d17-20020a170902ced100b001d95778f923mr87plg.5.1707178348825; Mon, 05 Feb 2024
 16:12:28 -0800 (PST)
Date: Mon, 5 Feb 2024 16:12:27 -0800
In-Reply-To: <CANaxB-yAJf4wFyRgkc+XzAdkC9JUKtx-BoZ=eCV7jRSagjsv0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240205173124.366901-1-avagin@google.com> <ZcErs9rPqT09nNge@google.com>
 <CANaxB-yAJf4wFyRgkc+XzAdkC9JUKtx-BoZ=eCV7jRSagjsv0g@mail.gmail.com>
Message-ID: <ZcF5a72HihKkLGVx@google.com>
Subject: Re: [PATCH] kvm/x86: add capability to disable the write-track mechanism
From: Sean Christopherson <seanjc@google.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Andrei Vagin <avagin@google.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, kvm@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhi Wang <zhi.a.wang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 05, 2024, Andrei Vagin wrote:
> On Mon, Feb 5, 2024 at 10:41=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Feb 05, 2024, Andrei Vagin wrote:
> > > The write-track is used externally only by the gpu/drm/i915 driver.
> > > Currently, it is always enabled, if a kernel has been compiled with t=
his
> > > driver.
> > >
> > > Enabling the write-track mechanism adds a two-byte overhead per page =
across
> > > all memory slots. It isn't significant for regular VMs. However in gV=
isor,
> > > where the entire process virtual address space is mapped into the VM,=
 even
> > > with a 39-bit address space, the overhead amounts to 256MB.
> > >
> > > This change introduces the new KVM_CAP_PAGE_WRITE_TRACKING capability=
,
> > > allowing users to enable/disable the write-track mechanism. It is ena=
bled
> > > by default for backward compatibility.
> >
> > I would much prefer to allocate the write-tracking metadata on-demand i=
n
> > kvm_page_track_register_notifier(), i.e. do the same as mmu_first_shado=
w_root_alloc(),
> > except for just gfn_write_track.
> >
> > The only potential hiccup would be if taking slots_arch_lock would dead=
lock, but
> > it should be impossible for slots_arch_lock to be taken in any other pa=
th that
> > involves VFIO and/or KVMGT *and* can be coincident.  Except for kvm_arc=
h_destroy_vm()
> > (which deletes KVM's internal memslots), slots_arch_lock is taken only =
through
> > KVM ioctls(), and the caller of kvm_page_track_register_notifier() *mus=
t* hold
> > a reference to the VM.
> >
> > That way there's no need for new uAPI and no need for userspace changes=
.
>=20
> I think it is a good idea, I don't know why I didn't consider it.

Because you wanted to make me look smart ;-)

