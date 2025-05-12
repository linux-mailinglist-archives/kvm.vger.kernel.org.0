Return-Path: <kvm+bounces-46260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C329EAB44FE
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E519F188EA8D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 19:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E33298CBE;
	Mon, 12 May 2025 19:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EwEGNDXl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B82F255F4B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 19:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078212; cv=none; b=hKmsVOtKL+LlvQy052JLAiZQM/WIhzTvRngqX92OjRFfbPw3q5SFfJVM2xptZ8cUfyoAHdVTc4l0pAg1SuBxsf/S4aI0kwCZmQlCydTzJdOK2/lpZ2V/cMINtzg26Gi3hhwZVazVRhLnD/fUrue7ZPPd61LTxrRjrRKrGrUaWWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078212; c=relaxed/simple;
	bh=2vaiqhqeKWGu9XvsNKNJPRQDw6T+T8MMPTOPIlL+1ZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mD+cp59IHvjplav5SvG3YVt65ympdKBBxFpsForWTFGEeL/tGw1je+9J1mV3VrGaiglhH9UuPGbHKwNnX/L+KZKc6g6532YmTERkYC2l5WcemRPlX8JZOEEGmoV08qTtXoNWMvfqsj7h/9lZGM8hmrJaRbbl8fLViDJGNd2xauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EwEGNDXl; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e78fc91f30dso3846586276.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 12:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747078210; x=1747683010; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xRIZyt0DVoYMQplsRT+zKgPzUDZj9bK9ZV6JBr5E08=;
        b=EwEGNDXlXW40vVt4P1xgx5QHITg9+/s4MOgg85FqTaNcFeAGYI7rWMr93p+ucPX0Yl
         Br+bV8XefGSs8iiRY0AxkTvpx6evGKi62NkU7F7IA9hUEwsTkb9W23y5xrboOFrzBmnX
         qmLBhsAF9aJIccuHCJJumSx56iXjehGPGKQq4rjw2/wGlNxk4xu0UcExZ18IGiT1d3hw
         80/khshYNzHEp65mUHwV3IrO9P3PPcVkWg0cNB8FoTOSwUPnrzxkER6pRW3LO5s/i4x5
         ym4g+7CQ3cUw0REjXfgQ4WwoktwjFlZnW71iZKjjJZzs/QNanrYoUNBAvaPapTDXcdGj
         3W9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747078210; x=1747683010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xRIZyt0DVoYMQplsRT+zKgPzUDZj9bK9ZV6JBr5E08=;
        b=n46TsfJkh0R4EG1gQWV3r18XQsEyfnoWc2VCSG9Rvx9RddsBXXpidg31//f9KbRIFb
         tJtEqt31HZQyce2/CjgfCKY6/VXqEP4bvy5Tgla+zqkgck9PIRHnZk3nsMU/W4RLhYdt
         f8VZ3swvYKjxfTaD8l6aPs1T9p8Hj44DSDk7xNZk4XHdRtsJznGDkHrPW/3gURRu2nn7
         jip+VrxV+Lxjf4RAW785oAqTZwNnDKFcaJGg9PsmqJNxeD7PiW3QhimGc22629mmACiH
         VKXnuG2sAi9k31BYCk3kzUgiX68PSeuw1kPTCA8viHjtUjRmAKEU8Qf6hUz5D4DoER+X
         DtYg==
X-Forwarded-Encrypted: i=1; AJvYcCVMkiUi2V17T2ncEknTTvtTrA1enb56FH+F3Yvr8lzgtNif9p0WTSq0Oes4SCedf5IYwoA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeGQ3C2aHt5a8U3pkuRZkLnI3aXTLsJZMNaUo63jvQoxU0lSQz
	kWHadkScoZ/QprwFZvIdykUmJa4DYq9/SYWo4Xr82gCpF9bWm7NyY9dneTAVOIw44ut1DFybIX/
	LrQtFeKitXZACmOwbLekKzKXU/aqniqFSHnfA
X-Gm-Gg: ASbGncsXBSywNJjy+2IgbB6oB45ClxcH/83jK6FTz7/UVB0/5zgrkIe/1uB5zISpbc+
	4GUdoZBO6ugerk9jWdiUHVD04gcMXRy8IlhYDtQBdsgGXCiItFtuV3Bzn3XonNiZoKwQTkH1sd6
	Azp/rcEf3ZJMXV7Xg5BetiKTRjJ9+M3gFV9x4NDNsUNYfDvdezC+RajWaWm7BG/TZvrufLL8buG
	A==
X-Google-Smtp-Source: AGHT+IEYxfy+iIaUBNgU9T6jCSjA/oXKOMtzoXjq1V2q9P4pPr/RlKitvANriEH2zjTwxWX+k/0FVFwiTWXwlL2OCdE=
X-Received: by 2002:a05:690c:2020:b0:70a:4540:c8dd with SMTP id
 00721157ae682-70a4540cc82mr141639737b3.32.1747078208889; Mon, 12 May 2025
 12:30:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com> <20250430165655.605595-9-tabba@google.com>
 <CADrL8HVO6s7V0c0Jv0gJ58Wk4NKr3F+sqS4i2dFw069P6ot7Fg@mail.gmail.com>
 <702d9951-ac26-4ee4-8a78-d5104141c2e4@redhat.com> <CA+EHjTyCQJccwGim_xe5xSv7ihLANRdcrwhrMAib+ByBzVAwSg@mail.gmail.com>
In-Reply-To: <CA+EHjTyCQJccwGim_xe5xSv7ihLANRdcrwhrMAib+ByBzVAwSg@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 12 May 2025 12:29:33 -0700
X-Gm-Features: AX0GCFtYFUIZ8MQMW02UoIlsS1ifURM47rF6GhrxE2cY-QHs4awlqCbXiPDlOAk
Message-ID: <CADrL8HXoEzZOCDPGH7h_OSOx3ySFHyXBaLVC8dL73J0+Wu+jvA@mail.gmail.com>
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 12:09=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
>
> Hi James.
>
> On Sun, 11 May 2025 at 09:03, David Hildenbrand <david@redhat.com> wrote:
> >
> > On 09.05.25 22:54, James Houghton wrote:
> > > On Wed, Apr 30, 2025 at 9:57=E2=80=AFAM Fuad Tabba <tabba@google.com>=
 wrote:
> > >> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *=
vma)
> > >> +{
> > >> +       struct kvm_gmem *gmem =3D file->private_data;
> > >> +
> > >> +       if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
> > >> +               return -ENODEV;
> > >> +
> > >> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D
> > >> +           (VM_SHARED | VM_MAYSHARE)) {
> > >> +               return -EINVAL;
> > >> +       }
> > >> +
> > >> +       vm_flags_set(vma, VM_DONTDUMP);
> > >
> > > Hi Fuad,
> > >
> > > Sorry if I missed this, but why exactly do we set VM_DONTDUMP here?
> > > Could you leave a small comment? (I see that it seems to have
> > > originally come from Patrick? [1]) I get that guest memory VMAs
> > > generally should have VM_DONTDUMP; is there a bigger reason?
> >
> > (David replying)
> >
> > I assume because we might have inaccessible parts in there that SIGBUS
> > on access.
>
> That was my thinking.
>
> > get_dump_page() does ignore any errors, though (returning NULL), so
> > likely we don't need VM_DONTDUMP.
>
> In which case I'll remove this from the next respin.

SGTM, thanks!

Userspace could remove VM_DONTDUMP by doing MADV_DODUMP, which is why
I was curious about this.

And thanks for the extra context[1], Patrick. :)

[1]: https://lore.kernel.org/kvm/20250512074615.27394-1-roypat@amazon.co.uk=
/

