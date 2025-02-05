Return-Path: <kvm+bounces-37372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5275A297C9
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 505773A8D23
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155851FC0F7;
	Wed,  5 Feb 2025 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CS4bxmyP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB181FC7ED
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738777165; cv=none; b=cccE/8WZNG7QOgy2FE5ywaaXSfV+XCJ4JORThCvmBkDuU1mAQaIkzlPk5GJ0WkdIsIL9DAt95Kl2bfNYCGzvYXIRgiGJKNmSW+xmI1eMu3g/OqL/4t/kgjKjILHw9bP4aiPYe+ysfDPdSTLpJzWq8SIcb0E4Vvmv5I+72HhmBaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738777165; c=relaxed/simple;
	bh=xUxgWluhlzHqW/GsY5iaR4uR5G+QxNO8sO6k0Ks77Ag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=umpHe6HCdgB9Qm5SXZddwW1kd2V2pBqi5Tqwsm4k5J/Hs52FtdIPqkG/8YZVrVR5cDjpfnphNf/ewHRQdaWsEzlGGPG0EpW6u0Lh4JYZ7uHddh2XG1gY/XCRRjVojjuedSyFC3FjoFToSEliIFFbqST0q1Yxj2DDbrILTxdjnNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CS4bxmyP; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53e3a2264e1so107e87.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 09:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738777161; x=1739381961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEZm5CUmXLka1TAInFV81IX5nQDZQzMEScT7OiIQ9Q0=;
        b=CS4bxmyPgjgn+2K1HkBjTqAy7LiveTu5HDPT6cJL0Q2MeU0t3BMWlT6PzsFH9DtANR
         rmU8GSgrGHTGf00lUeKfSE0cRregw03SxyyFL9c1afsDMRwd8//hno+QdsAUm2YffoxT
         zYRHGgX/6eq8NggxTzkpaDFkvehTLPr5lSnhvQo3u/WnQmKNZ7W5iynaAngkgSy2mEDL
         rODs5z/+Wy+FN3dmmAWPVJskncLTuu6IHuwi2VCUl3NP0+4gmgwiXEoKT5p7bqDQmILu
         iSKwE94L47VBXEF42z0+x4+agoKPchgT7rLjroZ1G498Q6b8GHkPJtNlzLOn7sB+1eMf
         qOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738777161; x=1739381961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DEZm5CUmXLka1TAInFV81IX5nQDZQzMEScT7OiIQ9Q0=;
        b=ggpHk7bi8qlTl5CM4bAYuqz1ulAO9E96eT4rgMtkZOR4K3KQjuar2EDmfC/hIM2C+Q
         JI3shZk5fa35h32Qki2E1gQK89J4O+4okbJ17wUosPHsnBM6XnAu/r+IA6fD2dc7uu1F
         hd2ZyjN2o5PgiC5S/Jjf4v1JdnKXSeRychFbD+E/rjuvUwDxKvH83bOiPsgya9GuNLvd
         I0ODDg5cM1JPFMaFjWekCGbHI25C2IPTQeVnXViaVjpkNfCq/tO3KYv1k3/S5reZ2zxS
         eydzgPCgH7KU6LuR7h90pDEcR+rGvZkAKiKffVG208CbSEtCm5p8ci8+bPWh+y4mZP5B
         6r4w==
X-Gm-Message-State: AOJu0YzvruljexiC1Sx1JGaWueXOtAYoWgLAL9NTD7zxVfKZhEsiM/eK
	HB11i+0vNI8/txkWrqeDyVAFAKkhcXE+Izw7GTRLh4I+z2OfWhwZAxkcXwzslghU8WiZ8GnstAD
	aGVrU7pwF5rNhrKtE3NsH/ixSTWAfEF1exJ51
X-Gm-Gg: ASbGncuoJiAC682M8H+3QuF2ZhFmuavVSr2N4nfwJ1fDjwK+w3+c+r3NZVYzGW2Otht
	5bqE94i8OttDosSiEFY4bsTrgzZ4U6Tgmk0L9s3FfQfqqfNUlMKeyxEkvfEGaeqHkaUWZ0700iS
	GfcEQNpAoYQLYYNhLXME0wL8jtpaA6ug==
X-Google-Smtp-Source: AGHT+IFkjWQJCxN4xPQHUS0Vsp6dW2ckurfVhTOGUtFDFseGDt7Z4hk2Am1DCR5yVIgGrmc0D3h4BOlH617tYtopub8=
X-Received: by 2002:a05:6512:2398:b0:542:6b39:1d57 with SMTP id
 2adb3069b0e04-54400bd9244mr589006e87.3.1738777160952; Wed, 05 Feb 2025
 09:39:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com> <20250117163001.2326672-7-tabba@google.com>
 <CAGtprH90zc3EWSuyqy4hE7hsmSZSYfB3JBC8KBvc1PdMcw5a4w@mail.gmail.com> <CA+EHjTxhdQR1FrYXepVRb_Fy7Gk0q_ew+g-t8o1qxdJ63r6sPQ@mail.gmail.com>
In-Reply-To: <CA+EHjTxhdQR1FrYXepVRb_Fy7Gk0q_ew+g-t8o1qxdJ63r6sPQ@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 5 Feb 2025 09:39:09 -0800
X-Gm-Features: AWEUYZm5Gj2iCzvuEETaqpk3nGpaMUbNOOKI88lb2YmSVbbpegGLse48NXXxP8o
Message-ID: <CAGtprH_JLgxAS1-DMVk_MBAQMFx7jnGEyLPJDp-9QG4mzmvSxw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 5, 2025 at 2:07=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Vishal,
>
> On Wed, 5 Feb 2025 at 00:42, Vishal Annapurve <vannapurve@google.com> wro=
te:
> >
> > On Fri, Jan 17, 2025 at 8:30=E2=80=AFAM Fuad Tabba <tabba@google.com> w=
rote:
> > >
> > > Before transitioning a guest_memfd folio to unshared, thereby
> > > disallowing access by the host and allowing the hypervisor to
> > > transition its view of the guest page as private, we need to be
> > > sure that the host doesn't have any references to the folio.
> > >
> > > This patch introduces a new type for guest_memfd folios, and uses
> > > that to register a callback that informs the guest_memfd
> > > subsystem when the last reference is dropped, therefore knowing
> > > that the host doesn't have any remaining references.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > > The function kvm_slot_gmem_register_callback() isn't used in this
> > > series. It will be used later in code that performs unsharing of
> > > memory. I have tested it with pKVM, based on downstream code [*].
> > > It's included in this RFC since it demonstrates the plan to
> > > handle unsharing of private folios.
> > >
> > > [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/gue=
stmem-6.13-v5-pkvm
> >
> > Should the invocation of kvm_slot_gmem_register_callback() happen in
> > the same critical block as setting the guest memfd range mappability
> > to NONE, otherwise conversion/truncation could race with registration
> > of callback?
>
> I don't think it needs to, at least not as far potencial races are
> concerned. First because kvm_slot_gmem_register_callback() grabs the
> mapping's invalidate_lock as well as the folio lock, and
> gmem_clear_mappable() grabs the mapping lock and the folio lock if a
> folio has been allocated before.

I was hinting towards such a scenario:
Core1                                                                     C=
ore2
Shared to private conversion                                 ....
  -> Results in mappability attributes
      being set to NONE
...
        Trigger private to shared conversion/truncation for
...
        overlapping ranges
...
kvm_slot_gmem_register_callback() on
      the guest_memfd ranges converted
      above (This will end up registering callback
      for guest_memfd ranges which possibly don't
      carry *_MAPPABILITY_NONE)

>
> Second, __gmem_register_callback() checks before returning whether all
> references have been dropped, and adjusts the mappability/shareability
> if needed.
>
> Cheers,
> /fuad

